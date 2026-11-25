//
//  SessionExpiryHandler.swift
//  HemSdkQuickKyc
//
//  One place that handles "session expired" for the whole SDK.
//

import UIKit

@MainActor
enum SessionExpiryHandler {

    /// Server error codes that mean the login session is no longer valid
    static let sessionExpiredCodes: Set<String> = ["999993"]

    private static var isShowing = false

    static func isSessionExpired(_ errorCode: String?) -> Bool {
        guard let code = errorCode else { return false }
        return sessionExpiredCodes.contains(code)
    }

    /// Shows "Session Expired" once, then logs the user out of the SDK:
    /// - SDK opened with a TxnId (client app) → the SDK closes and reports STATUS = SESSION_EXPIRED,
    ///   so the host app can start a new login (a TxnId can't be reused)
    /// - SDK opened without TxnId → back to the SDK's mobile-number login screen
    static func handle(message: String? = nil) {
        guard !isShowing else { return }        // several APIs can fail at the same time
        isShowing = true
        print("🔒 Session expired – logging out")

        let text = (message?.isEmpty == false) ? message! : "Your session has expired. Please log in again."
        let alert = UIAlertController(title: "Session Expired", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            clearSession()
            restartLogin(message: text)
            isShowing = false
        })

        guard let top = topViewController() else {
            // nothing on screen to show the alert → log out directly
            clearSession()
            restartLogin(message: text)
            isShowing = false
            return
        }
        top.present(alert, animated: true)
    }

    private static func clearSession() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        for key in ["EmailAddress", "UserType", "userId", "loginName", "BranchCode"] {
            UserDefaults.standard.removeObject(forKey: key)
        }
        CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
        CoreDataHelper.deleteAllUserIds(entityName: "MobileUser")
    }

    private static func restartLogin(message: String) {
        guard let sdkNav = sdkNavigationController() else {
            print("❌ SDK navigation controller not found")
            T5Launcher.onSDKClose?(["STATUS": "SESSION_EXPIRED", "MESSAGE": message])
            return
        }

        if let txnId = T5Launcher.launchTransactionId, !txnId.isEmpty {
            // Client flow: close the SDK and tell the host app
            sdkNav.dismiss(animated: true) {
                T5Launcher.onSDKClose?(["STATUS": "SESSION_EXPIRED", "MESSAGE": message])
            }
            return
        }

        // Mobile-number flow: show the SDK login screen again (inside the SDK, not the host app's window)
        let storyboard = UIStoryboard(name: "DashboardVC", bundle: Bundle.module)
        guard let loginVC = storyboard.instantiateViewController(withIdentifier: "NewAccountVC") as? NewAccountVC else {
            sdkNav.dismiss(animated: true) {
                T5Launcher.onSDKClose?(["STATUS": "SESSION_EXPIRED", "MESSAGE": message])
            }
            return
        }
        loginVC.txnId = nil
        loginVC.mobileNumber = T5Launcher.launchMobileNumber
        if sdkNav.presentedViewController != nil {
            sdkNav.dismiss(animated: false)           // close any popup on top of the SDK screens
        }
        sdkNav.setViewControllers([loginVC], animated: true)
    }

    // MARK: - Helpers

    private static func keyWindow() -> UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        ?? UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first
    }

    private static func topViewController() -> UIViewController? {
        var top = keyWindow()?.rootViewController
        while let presented = top?.presentedViewController, !presented.isBeingDismissed {
            top = presented
        }
        return top
    }

    /// The navigation controller the SDK was presented in (its first screen is NewAccountVC)
    private static func sdkNavigationController() -> UINavigationController? {
        var vc = keyWindow()?.rootViewController
        var found: UINavigationController?
        while let current = vc {
            if let nav = current as? UINavigationController,
               nav.viewControllers.first is NewAccountVC {
                found = nav
            }
            vc = current.presentedViewController
        }
        return found
    }
}

extension UIViewController {
    /// Shows a message; on OK the SDK closes and the user is back on the app's mobile-number screen.
    /// The host app gets the reason through T5Launcher.onSDKClose (e.g. STATUS = UNDER_VERIFICATION).
    func showAlertAndCloseSDK(message: String, status: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let nav = self.navigationController
            let toDismiss: UIViewController = (nav?.presentingViewController != nil ? nav : nil) ?? self
            toDismiss.dismiss(animated: true) {
                T5Launcher.onSDKClose?(["STATUS": status, "MESSAGE": message])
            }
        })
        (presentedViewController ?? self).present(alert, animated: true)
    }
}
