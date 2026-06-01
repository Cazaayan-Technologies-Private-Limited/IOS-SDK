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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let urlStr = redirectionUrl, let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            camsWebView.load(request)
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
                    entityName: "TokenMobile", deviceType: "M", in: self.view
                ) { success in
                    if success {
                        self.ValidateToken()
                    } else {
                        print("Token generation failed.")
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
                        default:
                            print("Unhandled error code: \(errorCode)")
                        }
                    }
                case .failure(let error):
                    print("Login API call failed: \(error.localizedDescription)")
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
                    entityName: "TokenMobile", deviceType: "M",
                    in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.camsCalling()
                    } else {
                        print("Token generation failed.")
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
            
            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("callingCams Response: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000001" {
                        if let status = jsonResponse["IsConsentSubmitted"] as? String, status.uppercased() == "Y" {
                            DispatchQueue.main.async {
                                self.timer?.invalidate()
                                self.timer = nil
                                self.navigateToNominationVC()
                            }
                        }
                    }
                    
                case .failure(let error):
                    print("camsCalling failed: \(error.localizedDescription)")
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
                    entityName: "TokenMobile", deviceType: "M", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.SIXTHAPI(userID: userID)
                    } else {
                        print("Token generation failed.")
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
                                
                                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: userID, SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "M",in: self.view) { success in
                                    if success {
                                        self.SIXTHAPI(userID: userID)
                                    } else {
                                        print("Token generation failed.")
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
                                let storyboard = UIStoryboard(name: "Bank", bundle: Bundle.module)
                                if let vc = storyboard.instantiateViewController(identifier: "BankVC") as? BankVC {
                                    vc.panNo = self.panNo
                                    vc.regId = self.regId
                                    
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                            
                        default:
                            print("Unhandled error code: \(errorCode)")
                        }
                    }
                case .failure(let error):
                    print("SIXTHAPI API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func navigateToNominationVC() {
        let storyboard = UIStoryboard(
            name: "OtherDetails",
            bundle: Bundle.module)
        let vc =
        storyboard.instantiateViewController(
            identifier: "OtherDetailsVC")
        as! OtherDetailsVC
        vc.panNo = panNo
        vc.regId = regId
        vc.delegate = self
        self.navigationController?
            .pushViewController(vc, animated: true)
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

