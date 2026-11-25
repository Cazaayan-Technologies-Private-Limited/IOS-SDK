//
//  CamsVC.swift
//  HemSdkQuickKyc
//
//  Created by Manas Datta on 20/04/26.
//

import UIKit
import WebKit

class CamsVC: UIViewController, @MainActor ReloadPageDelegate {
    func reloadPageData() {
        self.ValidateToken()
    }
    
    @IBOutlet weak var camsWebView: WKWebView!
    @IBOutlet weak var closeBtn: UIButton!
    
    var mobiledecodeArray: String?
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var panNo: String?
    var regId: String?
    var clienttrnxid: String?
    var redirectionUrl: String?
    var timer: Timer?
    var PANName: String?
    var EmailId: String?
    var CAMSfipid: String?
    /// Last error shown by the 10s CAMS polling – prevents the same alert every tick
    private var lastPollingAlert: String?
    
    enum ComingFrom {
           case bankVC
           case upiVC
       }
       var comingFrom: ComingFrom = .bankVC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        camsWebView.navigationDelegate = self   // report page load failures
        if let urlStr = redirectionUrl, let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            camsWebView.load(request)
        } else {
            // Earlier: blank screen with no message
            print("❌ CAMS redirection URL invalid: \(redirectionUrl ?? "nil")")
            showBankAlert(message: "Unable to open the bank verification page. Please try again or add your bank details manually." + bankRef("RequestCAMS", "Invalid redirectionurl"))
        }
        
        navigationItem.hidesBackButton = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { [weak self] _ in
            self?.camsCalling()
        })
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        if let userId = fetchedUserId {
            self.showAlert(message: "We were unable to process your request. We kindly request you to upload your bank proof manually.") {
                // Call SIXTHAPI only after alert is dismissed
                self.SIXTHAPI(userID: userId)
            }
        } else {
            print("User ID is not fetched yet.")
            self.showBankAlert(message: "Your session details could not be found. Please log in again." + self.bankRef("CamsVC", "Session"))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    func ValidateToken(){
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W", in: self.view
                ) { success in
                    if success {
                        self.ValidateToken()
                    } else {
                        self.showBankTokenError(api: #function)
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "UserId":  fetchedUserId,
                "TokenId": tokenId
            ]
            print(parameters)
            let Url = "TokenAuthentication/ValidateToken"
            
            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("ValidateToken Response: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            DispatchQueue.main.async {
                                print("api is running")
                                // self.ViewTradingBankDPClientData()
                            }
                        case "999992":
                            CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
                            CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W", in: self.view) { success in
                                if success {
                                    self.ValidateToken()
                                } else {
                                    self.showBankTokenError(api: "ValidateToken")
                                }
                            }
                        default:
                            self.showBankApiError(jsonResponse, api: "ValidateToken")
                        }
                    } else {
                        self.showBankMissingCode(jsonResponse, api: "ValidateToken")
                    }
                case .failure(let error):
                    self.showBankNetworkError(error, api: "ValidateToken")
                }
            }
        }
    }
    
    func camsCalling() {
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
            [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self
                        .mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W",
                    in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.camsCalling()
                    } else {
                        self.showBankTokenError(api: #function)
                    }
                }
                
                print("No tokens available. Please reload the tokens.")
                return
            }
            
            let parameters: [String: Any?] = [
                "UserId": fetchedUserId ?? "",
                "PANNo": panNo ?? "",
                "RegId": regId,
                "SessionId": fetchedSessionID ?? "",
                "Token": tokenId,
                "TxnId": clienttrnxid ?? "",
                "Document": "INCOMEPROOF",
            ]
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                print("callingCams request:\n\(jsonString)")
            }
            
            print(parameters)
            let Url = "MultiPartImageUpload/ValidateIsCAMSDone"
            
            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view, isLoader: false) { result in
                switch result {
                case .success(let jsonResponse):
                    print("callingCams Response: \(jsonResponse)")
                    if (jsonResponse["ErrorCode"] as? String) == "000000" || (jsonResponse["ErrorCode"] as? String) == "000001" {
                        self.lastPollingAlert = nil   // healthy again → allow future errors to show
                    }
                    
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            if let status = jsonResponse["IsConsentSubmitted"] as? String, status.uppercased() == "Y" {
                                    DispatchQueue.main.async {
                                        self.timer?.invalidate()
                                        self.timer = nil
                                        self.navigateToNominationVC()
                                    }
                                }
                        case "000001":
                            if let status = jsonResponse["IsConsentSubmitted"] as? String, status.uppercased() == "Y" {
                                    DispatchQueue.main.async {
                                        self.timer?.invalidate()
                                        self.timer = nil
                                        self.navigateToNominationVC()
                                    }
                                }
                        case "999992":
                            // Expired token while polling → regenerate silently, next tick retries
                            CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
                            CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W", in: self.view) { success in
                                if !success { self.showPollingAlert(BankAlertText.tokenFailed + self.bankRef("ValidateIsCAMSDone", "Token")) }
                            }
                        default:
                            // Polling runs every 10s – show each distinct error only once
                            print("❌ ValidateIsCAMSDone returned ErrorCode \(errorCode): \(jsonResponse)")
                            self.showPollingAlert(self.bankApiMessage(jsonResponse) + self.bankRef("ValidateIsCAMSDone", errorCode))
                        }
                        
                    } else {
                        print("❌ ValidateIsCAMSDone response has no ErrorCode: \(jsonResponse)")
                        self.showPollingAlert(self.bankApiMessage(jsonResponse, fallback: BankAlertText.missingCode) + self.bankRef("ValidateIsCAMSDone", "No ErrorCode"))
                    }                   //by sayantan
                    
//                    if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000001" {
//                        if let status = jsonResponse["IsConsentSubmitted"] as? String, status.uppercased() == "Y" {
//                            DispatchQueue.main.async {
//                                self.timer?.invalidate()
//                                self.timer = nil
//                                self.navigateToNominationVC()
//                            }
//                        }
//                    }
                    
                case .failure(let error):
                    print("camsCalling failed: \(error.localizedDescription)")
                    self.showPollingAlert(self.bankNetworkMessage(error) + self.bankRef("ValidateIsCAMSDone", "\((error as NSError).code)"), title: "Network Error")
                }
            }
        }
    }
    
    func SIXTHAPI(userID:String){
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.SIXTHAPI(userID: userID)
                    } else {
                        self.showBankTokenError(api: #function)
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any] = [
                "UserId": self.fetchedUserId as Any,
                "TokenId": tokenId
            ]
            print("GetActiveApplicationCL\(parameters)")
            let sixthUrl = "ActiveApplication/GetActiveApplicationCL"
            // API call
            apiCall(url: sixthUrl, method: "POST", parameters: parameters, view: self.view,loaderText: "Kindly wait we are fetching your details...") { result in
                switch result {
                case .success(let jsonResponse):
                    print("GetActiveApplicationCL: \(jsonResponse)")
                    self.panNo = jsonResponse["PanNo"] as? String
                    self.regId = jsonResponse["RegId"] as? String
                    self.PANName = jsonResponse["PANName"] as? String
                    self.EmailId = jsonResponse["EmailId"] as? String
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
                                print("All TokenMobile entries deleted due to error code 999992")
                                
                                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: userID, SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                                    if success {
                                        self.SIXTHAPI(userID: userID)
                                    } else {
                                        self.showBankTokenError(api: #function)
                                    }
                                }
                            }
                            
                        case "000000":
                            var count = 0
                            if let camsClick = jsonResponse["CAMSClickCount"] {
                                count = (camsClick as? Int) ?? Int(camsClick as? String ?? "0") ?? 0
                            }
                            
                            if count >= 2 {
                                DispatchQueue.main.async {
                                    self.navigateToNominationVC()
                                }
                            } else {
                                DispatchQueue.main.async {
                                                                 // Navigate back to the appropriate screen based on where we came from
                                                                 self.navigateBackToPreviousScreen()
                                                             }
                            }
                            
                        default:
                            self.showBankApiError(jsonResponse, api: "GetActiveApplicationCL")
                        }
                    } else {
                        self.showBankMissingCode(jsonResponse, api: "GetActiveApplicationCL")
                    }
                case .failure(let error):
                    self.showBankNetworkError(error, api: "GetActiveApplicationCL")
                }
            }
        }
    }
    
    private func navigateBackToPreviousScreen() {
           // First, pop the current CamsVC
           self.navigationController?.popViewController(animated: false)
           
           // Then navigate to the appropriate screen based on where we came from
           switch comingFrom {
           case .bankVC:
               // Navigate to BankVC
               let storyboard = UIStoryboard(name: "Bank", bundle: Bundle.module)
               if let vc = storyboard.instantiateViewController(identifier: "BankVC") as? BankVC {
                   vc.panNo = self.panNo
                   vc.regId = self.regId
                   vc.mobiledecodeArray = self.mobiledecodeArray
                   vc.fetchedUserId = self.fetchedUserId
                   vc.fetchedSessionID = self.fetchedSessionID
                   self.navigationController?.pushViewController(vc, animated: true)
               }
               
           case .upiVC:
               // Navigate to UPIVC
               let storyboard = UIStoryboard(name: "Bank", bundle: Bundle.module)
               if let vc = storyboard.instantiateViewController(identifier: "UPIVC") as? UPIVC {
                   vc.panNo = self.panNo
                   vc.regId = self.regId
                   vc.PanNo = self.panNo
                   vc.RegId = self.regId
                   vc.mobiledecodeArray = self.mobiledecodeArray
                   vc.fetchedUserId = self.fetchedUserId
                   vc.fetchedSessionID = self.fetchedSessionID
                   vc.CAMSfipid = self.CAMSfipid
                   vc.PANName = self.PANName
                   vc.EmailId = self.EmailId
                   self.navigationController?.pushViewController(vc, animated: true)
               }
           }
       }
    
    private func navigateToNominationVC() {
        let storyboard = UIStoryboard(name: "OtherDetails", bundle: Bundle.module)
                       let vc = storyboard.instantiateViewController(identifier: "OtherDetailsVC") as! OtherDetailsVC
                       let savedPAN = UserDefaults.standard.string(forKey: "PanNo")
                       let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.panNo
                       
                       let regId = UserDefaults.standard.string(forKey: "RegId")
                       let regIdFinal = (regId?.isEmpty == false) ? regId : self.regId
                       
                       vc.panNo = finalPAN
                       vc.regId = regIdFinal
                       self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        showBankAlert(message: message, onOK: completion)
    }
    
    private func showPollingAlert(_ message: String, title: String = "Alert") {
        guard message != lastPollingAlert else { return }
        lastPollingAlert = message
        showBankAlert(title: title, message: message)
    }
}

// MARK: - CAMS page load errors
extension CamsVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showCamsPageError(error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showCamsPageError(error)
    }
    
    private func showCamsPageError(_ error: Error) {
        let nsError = error as NSError
        // Not real failures: -999 load cancelled (redirect / new load),
        // -1002 / WebKit 101 / 102 = app-callback URL at the end of the CAMS flow or interrupted frame load
        if nsError.code == NSURLErrorCancelled || nsError.code == NSURLErrorUnsupportedURL { return }
        if nsError.domain == "WebKitErrorDomain" && (nsError.code == 101 || nsError.code == 102) { return }
        print("❌ CAMS page failed to load: \(nsError.domain) \(nsError.code) \(nsError.localizedDescription)")
        showBankAlert(title: "Network Error",
                      message: "Unable to load the bank verification page. Please check your internet connection and try again." + bankRef("CAMS page", "\(nsError.code)"))
    }
}
