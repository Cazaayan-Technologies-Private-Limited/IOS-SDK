//
//  UPIVC.swift
//  HemSdkQuickKyc
//
//  Created by Manas Datta on 14/05/26.
//

import UIKit

class UPIVC: UIViewController {
    
    @IBOutlet weak var gpayView: UIView!
    @IBOutlet weak var addBankBtn: UIButton!
    @IBOutlet weak var upiBtn: UIButton!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var upiLabel: UILabel!
    @IBOutlet weak var fasterBtn: UIButton!
    
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var mobiledecodeArray: String?
    var panNo: String?
    var regId: String?
    var upiLink: String?
    var isUpiChecked = true
    var reversePennyDropTxnId: String?
    var reversePennyDropId: String?
    var PanNo: String?
    var RegId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        gpayView.layer.cornerRadius = 10
//        gpayView.layer.borderWidth = 1
//        gpayView.layer.borderColor = UIColor.appBorder.cgColor
        
        navigationItem.hidesBackButton = true
        view.backgroundColor = .appBackground
        addBankBtn.backgroundColor = .documentBackground
        
        upiBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        payButton.backgroundColor = .documentBackground
        payButton.layer.cornerRadius = 10
        payButton.isHidden = true
        upiLabel.isHidden = true
        upiBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        addBankBtn.layer.cornerRadius = 20
        fasterBtn.layer.cornerRadius = 10
    }
    
    @IBAction func addBankBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Bank", bundle: Bundle.module)
        let vc = storyboard.instantiateViewController(identifier: "BankVC") as! BankVC
        let savedPAN = UserDefaults.standard.string(forKey: "PanNo")
                   let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.PanNo
                   let regId = UserDefaults.standard.string(forKey: "RegId")
               let regIdFinal = (regId?.isEmpty == false) ? regId : self.RegId
                                                  vc.panNo = finalPAN
                                                  vc.regId = regIdFinal
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "TradingandDemat", bundle: Bundle.module)
        let vc = storyboard.instantiateViewController(identifier: "TradingandDematVC") as! TradingandDematVC
        let savedPAN = UserDefaults.standard.string(forKey: "PanNo")
        let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.panNo
        
        let regId = UserDefaults.standard.string(forKey: "RegId")
        let regIdFinal = (regId?.isEmpty == false) ? regId : self.regId
        
        vc.panNo = finalPAN
        vc.regId = regIdFinal
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func payButton(_ sender: UIButton) {
        getUpiDetails()
    }
    
    @IBAction func upiBtnTapped(_ sender: UIButton) {
        isUpiChecked.toggle()
        
        // Show filled circle when checked, empty circle when unchecked
        let imageName = isUpiChecked ? "circle.circle.fill" : "circle"
        
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        payButton.isHidden = !isUpiChecked
        upiLabel.isHidden = !isUpiChecked
    }
    
    private func fetchUserId() {
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.fetchedUserId = userId
                self.fetchedSessionID = sessionID
                self.mobiledecodeArray = decodeByteArrayString
                print("UserID: \(userId), SessionID: \(sessionID)")
                self.getUpiDetails()
            } else {
                print("No UserID or SessionID found.")
            }
        }
    }
    
    func getUpiDetails(){
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
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
                        self.getUpiDetails()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "PANNo": panNo,
                "RegId": regId,
                "UserId": fetchedUserId,
                "SessionId": fetchedSessionID,
                "Token": tokenId
            ]
            print(parameters)
            let Url = "PennyDrop/RequestToReversePennyDrop"
            
            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("RequestToReversePennyDrop Response: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            
                            self.reversePennyDropTxnId =
                            jsonResponse["transactionid"] as? String
                            self.reversePennyDropId =
                            jsonResponse["Id"] as? String
                            
                            DispatchQueue.main.async {
                                if let upiLink = jsonResponse["UpiLink"] as? String {

                                    print("UPI LINK = \(upiLink)")

                                    if upiLink.lowercased().hasPrefix("upi://") {

                                        self.openUPIApps(upiLink: upiLink)

                                    } else {

                                        self.showAlert(
                                            title: "Invalid UPI Link",
                                            message: "Received invalid UPI URL from server."
                                        )
                                    }
                                }
                                
//                                if let upiLink = jsonResponse["UpiLink"] as? String,
//                                   let url = URL(string: upiLink) {
//                                    
//                                    // Check if device can open UPI app
//                                    if UIApplication.shared.canOpenURL(url) {
//                                        
//                                        UIApplication.shared.open(url, options: [:]) { success in
//                                            print("UPI App Opened: \(success)")
//                                        }
//                                        
//                                    } else {
//                                        
//                                        self.showAlert(
//                                            title: "UPI App Not Found",
//                                            message: "Please install any UPI app like Google Pay, PhonePe or Paytm."
//                                        )
//                                    }
//                                    
//                                } else {
//                                    print("Invalid UPI Link")
//                                }
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
    
    func startUpi(){
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
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
                        self.startUpi()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "PANNo": panNo,
                "RegId": regId,
                "UserId": fetchedUserId,
                "SessionId": fetchedSessionID,
                "Token": tokenId,
                "TxnId": reversePennyDropTxnId ?? "",
                "Id": reversePennyDropId ?? "",
                "Status": nil,
                "IsPennyDrop": nil,
                "Remark": nil
            ]
            print(parameters)
            let Url = "PennyDrop/ValidateIsReversePennyDropDone"
            
            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("ValidateIsReversePennyDropDone Response: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            print("Unhandled error code: \(errorCode)")
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
                "UserId": self.fetchedUserId ?? "",
                "TokenId": tokenId
            ]
            print("GetActiveApplicationCL\(parameters)")
            let sixthUrl = "ActiveApplication/GetActiveApplicationCL"
            // API call
            apiCall(url: sixthUrl, method: "POST", parameters: parameters, view: self.view,loaderText: "Kindly wait we are fetching your details...") { result in
                switch result {
                case .success(let jsonResponse):
                    
                    print("GetActiveApplicationCL: \(jsonResponse)")
                    
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
                                print("All TokenMobile entries deleted due to error code 999992")
                                
                                // Regenerate tokens
                                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: userID, SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "M",in: self.view) { success in
                                    if success {
                                        // Retry SIXTHAPI after token regeneration
                                        self.SIXTHAPI(userID: userID)
                                    } else {
                                        print("Token generation failed.")
                                    }
                                }
                            }
                            
                        case "000000":
                            print("Unhandled error code: \(errorCode)")
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
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
//    func openUPIApps(upiLink: String) {
//
//        let alert = UIAlertController(
//            title: "Choose Payment App",
//            message: nil,
//            preferredStyle: .actionSheet
//        )
//
//        // Google Pay
//        if let gpayURL = URL(
//            string: upiLink.replacingOccurrences(
//                of: "upi://",
//                with: "tez://"
//            )
//        ),
//           UIApplication.shared.canOpenURL(gpayURL) {
//
//            alert.addAction(
//                UIAlertAction(title: "Google Pay", style: .default) { _ in
//                    UIApplication.shared.open(gpayURL)
//                }
//            )
//        }
//
//        // PhonePe
//        if let phonepeURL = URL(
//            string: upiLink.replacingOccurrences(
//                of: "upi://",
//                with: "phonepe://"
//            )
//        ),
//           UIApplication.shared.canOpenURL(phonepeURL) {
//
//            alert.addAction(
//                UIAlertAction(title: "PhonePe", style: .default) { _ in
//                    UIApplication.shared.open(phonepeURL)
//                }
//            )
//        }
//
//        // Paytm
//        if let paytmURL = URL(
//            string: upiLink.replacingOccurrences(
//                of: "upi://",
//                with: "paytmmp://"
//            )
//        ),
//           UIApplication.shared.canOpenURL(paytmURL) {
//
//            alert.addAction(
//                UIAlertAction(title: "Paytm", style: .default) { _ in
//                    UIApplication.shared.open(paytmURL)
//                }
//            )
//        }
//
//        alert.addAction(
//            UIAlertAction(title: "Cancel", style: .cancel)
//        )
//
//        // iPad Support
//        if let popover = alert.popoverPresentationController {
//            popover.sourceView = self.view
//            popover.sourceRect = CGRect(
//                x: self.view.bounds.midX,
//                y: self.view.bounds.midY,
//                width: 0,
//                height: 0
//            )
//            popover.permittedArrowDirections = []
//        }
//
//        self.present(alert, animated: true)
//    }
    
    func openUPIApps(upiLink: String) {

        let alert = UIAlertController(
            title: "Choose Payment App",
            message: nil,
            preferredStyle: .actionSheet
        )

        // Google Pay
        if let gpayURL = URL(
            string: upiLink.replacingOccurrences(
                of: "upi://",
                with: "tez://"
            )
        ),
           UIApplication.shared.canOpenURL(gpayURL) {

            let gpayAction = UIAlertAction(
                title: "Google Pay",
                style: .default
            ) { _ in
                UIApplication.shared.open(gpayURL)
            }

            gpayAction.setValue(
                UIImage(named: "gpay")?.withRenderingMode(.alwaysOriginal),
                forKey: "image"
            )

            alert.addAction(gpayAction)
        }

        // PhonePe
        if let phonepeURL = URL(
            string: upiLink.replacingOccurrences(
                of: "upi://",
                with: "phonepe://"
            )
        ),
           UIApplication.shared.canOpenURL(phonepeURL) {

            let phonepeAction = UIAlertAction(
                title: "PhonePe",
                style: .default
            ) { _ in
                UIApplication.shared.open(phonepeURL)
            }

            phonepeAction.setValue(
                UIImage(named: "phonepe")?.withRenderingMode(.alwaysOriginal),
                forKey: "image"
            )

            alert.addAction(phonepeAction)
        }

        // Paytm
        if let paytmURL = URL(
            string: upiLink.replacingOccurrences(
                of: "upi://",
                with: "paytmmp://"
            )
        ),
           UIApplication.shared.canOpenURL(paytmURL) {

            let paytmAction = UIAlertAction(
                title: "Paytm",
                style: .default
            ) { _ in
                UIApplication.shared.open(paytmURL)
            }

            paytmAction.setValue(
                UIImage(named: "paytm")?.withRenderingMode(.alwaysOriginal),
                forKey: "image"
            )

            alert.addAction(paytmAction)
        }

        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )

        // iPad support
        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(
                x: self.view.bounds.midX,
                y: self.view.bounds.midY,
                width: 0,
                height: 0
            )
            popover.permittedArrowDirections = []
        }

        self.present(alert, animated: true)
    }
}
