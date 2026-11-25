//
//  BankAlertHelper.swift
//  HemSdkQuickKyc
//
//  Shared user-facing alerts for the Bank section (BankVC, UPIVC, CamsVC).
//  Used whenever an API call fails, returns an error / unknown code,
//  or returns a response with missing data.
//

import UIKit

enum BankAlertText {
    static let genericError   = "Something went wrong. Please try again."
    static let missingCode    = "We received an unexpected response from the server. Please try again."
    static let missingData    = "Some required details are missing in the server response. Please try again."
    static let tokenFailed    = "Your session could not be refreshed. Please try again."
    static let networkError   = "Unable to connect to the server. Please check your internet connection and try again."
    static let timeoutError   = "The request timed out. Please try again."
}

extension UIViewController {

    /// Returns the API's `ErrorMessage` if it is present and not blank, otherwise `fallback`.
    func bankApiMessage(_ json: [String: Any], fallback: String = BankAlertText.genericError) -> String {
        let keys = ["ErrorMessage", "errorMessage", "Message", "message"]
        for key in keys {
            if let msg = json[key] as? String {
                let trimmed = msg.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty && trimmed.lowercased() != "null" { return trimmed }
            }
        }
        return fallback
    }

    /// Friendly text for a transport / parsing failure from `apiCall`.
    func bankNetworkMessage(_ error: Error) -> String {
        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain {
            switch nsError.code {
            case NSURLErrorTimedOut:
                return BankAlertText.timeoutError
            case NSURLErrorNotConnectedToInternet,
                 NSURLErrorNetworkConnectionLost,
                 NSURLErrorCannotConnectToHost,
                 NSURLErrorCannotFindHost,
                 NSURLErrorDNSLookupFailed:
                return BankAlertText.networkError
            default:
                break
            }
        }
        // Empty / invalid JSON etc. (errors built in ApiManager)
        if nsError.localizedDescription == "Empty response data" ||
           nsError.localizedDescription == "Invalid JSON response" {
            return BankAlertText.missingCode
        }
        return BankAlertText.networkError
    }

    /// Small reference line added under every error alert, e.g. "Ref: ValidateIsReversePennyDropDone · 900004".
    /// The user sees the problem, and from a client screenshot/video we can see which API / code failed.
    func bankRef(_ api: String, _ detail: String? = nil) -> String {
        var ref = "\n\nRef: \(api)"
        if let detail = detail, !detail.isEmpty { ref += " · \(detail)" }
        return ref
    }

    /// Shows a single-button alert. Safe to call while another alert is on screen
    /// (it is stacked on top instead of being dropped).
    /// Identical messages already on screen are not shown twice.
    func showBankAlert(title: String = "Alert", message: String, onOK: (() -> Void)? = nil) {
        presentBankAlert(title: title, message: message, onOK: onOK, attempt: 0)
    }

    private func presentBankAlert(title: String, message: String, onOK: (() -> Void)?, attempt: Int) {
        // Find the top-most controller so the alert is never silently rejected
        // ("Attempt to present ... which is already presenting").
        var top: UIViewController = self
        while let presented = top.presentedViewController, !presented.isBeingDismissed {
            top = presented
        }
        if let existing = top as? UIAlertController, existing.message == message {
            return // same alert is already visible
        }
        // Screen not on screen yet (still being pushed) → retry shortly.
        // Still not visible after ~2s means the user navigated away → drop it.
        guard top.viewIfLoaded?.window != nil else {
            if attempt < 4 {
                // Inherits MainActor isolation from UIViewController
                Task { [weak self] in
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    self?.presentBankAlert(title: title, message: message, onOK: onOK, attempt: attempt + 1)
                }
            } else {
                print("⚠️ Bank alert skipped (view not in window): \(message)")
            }
            return
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in onOK?() })
        top.present(alert, animated: true)
    }

    /// Alert for a non-success `ErrorCode` – uses the API message, or a fallback when it is missing.
    func showBankApiError(_ json: [String: Any], api: String, fallback: String = BankAlertText.genericError) {
        let code = json["ErrorCode"] as? String ?? "nil"
        print("❌ \(api) returned ErrorCode \(code): \(json)")
        showBankAlert(message: bankApiMessage(json, fallback: fallback) + bankRef(api, code))
    }

    /// Alert for a response that has no `ErrorCode` at all.
    func showBankMissingCode(_ json: [String: Any], api: String) {
        print("❌ \(api) response has no ErrorCode: \(json)")
        showBankAlert(message: bankApiMessage(json, fallback: BankAlertText.missingCode) + bankRef(api, "No ErrorCode"))
    }

    /// Alert for a success response that is missing a required field.
    func showBankMissingData(_ json: [String: Any], api: String, field: String) {
        print("❌ \(api) success response missing \(field): \(json)")
        showBankAlert(message: BankAlertText.missingData + bankRef(api, "Missing \(field)"))
    }

    /// Alert for a transport failure (no internet, timeout, bad JSON, ...).
    func showBankNetworkError(_ error: Error, api: String) {
        print("❌ \(api) failed: \(error.localizedDescription)")
        let nsError = error as NSError
        showBankAlert(title: "Network Error", message: bankNetworkMessage(error) + bankRef(api, "\(nsError.domain == NSURLErrorDomain ? "URLError" : "Error") \(nsError.code)"))
    }

    /// Alert for token regeneration failure.
    func showBankTokenError(api: String) {
        print("❌ Token generation failed (\(api))")
        showBankAlert(message: BankAlertText.tokenFailed + bankRef(api, "Token"))
    }
}
