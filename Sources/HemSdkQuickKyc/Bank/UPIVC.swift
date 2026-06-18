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
    @IBOutlet weak var upiDetailsHeight: NSLayoutConstraint!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var cams: UIButton!
    
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
    var decodeArray: String?
    var CAMSfipid: String?
    
    var isDerivative: String?
    var consent: String?
    var camsClickCount: String?
    var isGetDocumentsFromCAMS: String?
    var isPennyDropSixth: String?
    var PANName: String?
    var EmailId: String?
    var clienttrnxid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        gpayView.layer.cornerRadius = 10
        //        gpayView.layer.borderWidth = 1
        //        gpayView.layer.borderColor = UIColor.appBorder.cgColor
        
        navigationItem.hidesBackButton = true
        view.backgroundColor = .appBackground
        addBankBtn.layer.cornerRadius = 10
        addBankBtn.layer.borderWidth = 0.5
        addBankBtn.layer.borderColor = UIColor.appBorder.cgColor
        
        upiBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        //payButton.backgroundColor = .documentBackground
        payButton.layer.cornerRadius = 10
        //        payButton.isHidden = true
        //        upiLabel.isHidden = true
        upiBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        addBankBtn.layer.cornerRadius = 20
        fasterBtn.layer.cornerRadius = 10
        
        cams.backgroundColor = .appPrimary
        cams.layer.cornerRadius = 10
        cams.isHidden = true // Initially hidden
        
        isUpiChecked = false
        gpayView.isHidden = true
        upiDetailsHeight.constant = 0
        continueBtn.isHidden = true
        
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.fetchedUserId = userId
                self.fetchedSessionID = sessionID
                self.decodeArray = decodeByteArrayString
                print("UserID: \(userId), SessionID: \(sessionID)")
                SIXTHAPI(userID: fetchedUserId ?? "")
            } else {
                print("No UserID or SessionID found.")
            }
        }
        continueBtn.layer.cornerRadius = 10
        
        NotificationCenter.default.addObserver(
              self,
              selector: #selector(handleUPICallback(_:)),
              name: Notification.Name("UPICallbackReceived"),
              object: nil
          )
    }
    
    @objc func handleUPICallback(_ notification: Notification) {

        guard let url = notification.object as? URL else {
            return
        }

        print("UPI Callback URL: \(url)")

        let components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )

        let status = components?.queryItems?
            .first(where: { $0.name.lowercased() == "status" })?
            .value

        print("Status: \(status ?? "")")

        if status?.uppercased() == "SUCCESS" {

            startUpi()

        } else {

            print("Payment Failed")
        }
    }
    
    
    @IBAction func camsBtn(_ sender: UIButton) {
        redirectCams()
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
        
        if isUpiChecked {
            gpayView.isHidden = false
            upiDetailsHeight.constant = 170
        } else {
            gpayView.isHidden = true
            upiDetailsHeight.constant = 0
        }
        
        let imageName = isUpiChecked ? "circle.inset.filled" : "circle"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func continueBtnTapped(_ sender: UIButton) {
        switch sender.tag {
            
        case 1:
            // Approved -> Other Page
            
                let storyboard = UIStoryboard(name: "OtherDetails", bundle: Bundle.module)
                let vc = storyboard.instantiateViewController(identifier: "OtherDetailsVC") as! OtherDetailsVC
                let savedPAN = UserDefaults.standard.string(forKey: "PanNo")
                let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.panNo
                
                let regId = UserDefaults.standard.string(forKey: "RegId")
                let regIdFinal = (regId?.isEmpty == false) ? regId : self.regId
                
                vc.panNo = finalPAN
                vc.regId = regIdFinal
                self.navigationController?.pushViewController(vc, animated: true)
            
            
        case 2:
            // Rejected + ClickCount = 1 -> Bank Page
            let storyboard = UIStoryboard(name: "Bank", bundle: Bundle.module)
            let vc = storyboard.instantiateViewController(identifier: "BankVC") as! BankVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 3:
            // Rejected + ClickCount = 2 -> Other Page
            let storyboard = UIStoryboard(name: "OtherDetails", bundle: Bundle.module)
                           let vc = storyboard.instantiateViewController(identifier: "OtherDetailsVC") as! OtherDetailsVC
                           let savedPAN = UserDefaults.standard.string(forKey: "PanNo")
                           let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.panNo
                           
                           let regId = UserDefaults.standard.string(forKey: "RegId")
                           let regIdFinal = (regId?.isEmpty == false) ? regId : self.regId
                           
                           vc.panNo = finalPAN
                           vc.regId = regIdFinal
                           self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
        
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
    
//    func SIXTHAPI(userID:String){
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile", deviceType: "M", in: self.view
//                ) { success in
//                    if success {
//                        // Retry SIXTHAPI after token regeneration
//                        self.SIXTHAPI(userID: userID)
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            let parameters: [String: Any] = [
//                "UserId": self.fetchedUserId ?? "",
//                "TokenId": tokenId
//            ]
//            print("GetActiveApplicationCL\(parameters)")
//            let sixthUrl = "ActiveApplication/GetActiveApplicationCL"
//            // API call
//            apiCall(url: sixthUrl, method: "POST", parameters: parameters, view: self.view,loaderText: "Kindly wait we are fetching your details...") { result in
//                switch result {
//                case .success(let jsonResponse):
//                    
//                    print("GetActiveApplicationCL: \(jsonResponse)")
//                    let bankDpTradStatus = jsonResponse["BankDpTradStatus"] as? String ?? ""
//                    let isDerivative = jsonResponse["IsDerivative"] as? String ?? ""
//                    let camsClickCount = jsonResponse["CAMSClickCount"] as? String ?? ""
//                    let isCAMS = jsonResponse["ISCAMS"] as? String ?? ""
//                    
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "999992":
//                            DispatchQueue.main.async {
//                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
//                                print("All TokenMobile entries deleted due to error code 999992")
//                                
//                                // Regenerate tokens
//                                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: userID, SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "M",in: self.view) { success in
//                                    if success {
//                                        // Retry SIXTHAPI after token regeneration
//                                        self.SIXTHAPI(userID: userID)
//                                    } else {
//                                        print("Token generation failed.")
//                                    }
//                                }
//                            }
//                            
//                        case "000000":
//                            DispatchQueue.main.async {
//                                
//                                self.continueBtn.isHidden = true
//                                
//                                // Case 1: PAGE PENDING
//                                if bankDpTradStatus.uppercased() == "PAGE PENDING" {
//                                    
//                                    self.continueBtn.isHidden = true
//                                    
//                                }
//                                // Case 2: APPROVED
//                                else if bankDpTradStatus.uppercased() == "APPROVED" {
//                                    self.addBankBtn.isEnabled = false
//                                    self.addBankBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
//                                    self.continueBtn.isHidden = false
//                                    self.continueBtn.tag = 1
//                                    
//                                }
//                                // Case 3: REJECTED + Derivative Y + CAMS Y + ClickCount 1
//                                else if bankDpTradStatus.uppercased() == "REJECTED",
//                                        isDerivative.uppercased() == "Y",
//                                        isCAMS.uppercased() == "Y",
//                                        camsClickCount == "1" {
//                                    
//                                    self.addBankBtn.isEnabled = false
//                                    self.addBankBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
//                                    self.continueBtn.isHidden = false
//                                    self.continueBtn.tag = 2
//                                    
//                                }
//                                // Case 4: REJECTED + Derivative Y + CAMS Y + ClickCount 2
//                                else if bankDpTradStatus.uppercased() == "REJECTED",
//                                        isDerivative.uppercased() == "Y",
//                                        isCAMS.uppercased() == "Y",
//                                        camsClickCount == "2" {
//                                    
//                                    self.addBankBtn.isEnabled = false
//                                    self.addBankBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
//                                    self.continueBtn.isHidden = false
//                                    self.continueBtn.tag = 3
//                                }
//                            }
//                            
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                        }
//                    }
//                case .failure(let error):
//                    print("SIXTHAPI API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
    
    func SIXTHAPI(userID:String){
            CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { tokenId in
                guard let tokenId = tokenId else {
                    CoreDataHelper.generateToken(
                        decodeByteArrayToString: self.mobiledecodeArray ?? "",
                        USERID: self.fetchedUserId ?? "",
                        SessionId: self.fetchedSessionID ?? "",
                        entityName: "TokenMobile", deviceType: "M", in: self.view
                    ) { success in
                        if success {
                            self.SIXTHAPI(userID: userID)
                        } else {
                            print("Token generation failed.")
                        }
                    }
                    return
                }
                
                let parameters: [String: Any] = [
                    "UserId": self.fetchedUserId ?? "",
                    "TokenId": tokenId
                ]
                print("GetActiveApplicationCL\(parameters)")
                let sixthUrl = "ActiveApplication/GetActiveApplicationCL"
                
                apiCall(url: sixthUrl, method: "POST", parameters: parameters, view: self.view, loaderText: "Kindly wait we are fetching your details...") { result in
                    switch result {
                    case .success(let jsonResponse):
                        print("GetActiveApplicationCL: \(jsonResponse)")
                        
                        let bankDpTradStatus = jsonResponse["BankDpTradStatus"] as? String ?? ""
                        self.isDerivative = jsonResponse["IsDerivative"] as? String ?? ""
                        self.camsClickCount = jsonResponse["CAMSClickCount"] as? String ?? ""
                        let isCAMS = jsonResponse["ISCAMS"] as? String ?? ""
                        self.consent = jsonResponse["IsConsentSubmitted"] as? String
                        self.isGetDocumentsFromCAMS = jsonResponse["IsGetDocumentsFromCAMS"] as? String
                        self.isPennyDropSixth = jsonResponse["IsPennyDrop"] as? String ?? ""
                        self.CAMSfipid = jsonResponse["CAMSBankNameForfipid"] as? String
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
                                DispatchQueue.main.async {
                                    // Update CAMS button visibility based on isDerivative
                                    self.updateCAMSButtonVisibility()
                                    
                                    self.continueBtn.isHidden = true
                                    
                                    // Case 1: PAGE PENDING
                                    if bankDpTradStatus.uppercased() == "PAGE PENDING" {
                                        self.continueBtn.isHidden = true
                                    }
                                    // Case 2: APPROVED
                                    else if bankDpTradStatus.uppercased() == "APPROVED" {
                                        self.addBankBtn.isEnabled = false
                                        self.addBankBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
                                        self.continueBtn.isHidden = false
                                        self.continueBtn.tag = 1
                                    }
                                    // Case 3: REJECTED + Derivative Y + CAMS Y + ClickCount 1
                                    else if bankDpTradStatus.uppercased() == "REJECTED",
                                            self.isDerivative?.uppercased() == "Y",
                                            isCAMS.uppercased() == "Y",
                                            self.camsClickCount == "1" {
                                        self.addBankBtn.isEnabled = false
                                        self.addBankBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
                                        self.continueBtn.isHidden = false
                                        self.continueBtn.tag = 2
                                    }
                                    // Case 4: REJECTED + Derivative Y + CAMS Y + ClickCount 2
                                    else if bankDpTradStatus.uppercased() == "REJECTED",
                                            self.isDerivative?.uppercased() == "Y",
                                            isCAMS.uppercased() == "Y",
                                            self.camsClickCount == "2" {
                                        self.addBankBtn.isEnabled = false
                                        self.addBankBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
                                        self.continueBtn.isHidden = false
                                        self.continueBtn.tag = 3
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
    
    func updateCAMSButtonVisibility() {
           // Default: hide the CAMS button
           self.cams.isHidden = true
           
           // Only show CAMS button if isDerivative is "Y"
           guard self.isDerivative?.uppercased() == "Y" else {
               print("🔴 CAMS button hidden: isDerivative is not Y")
               return
           }
           
           // Check conditions for showing CAMS button
           if (self.isPennyDropSixth ?? "").isEmpty &&
               self.isDerivative == "Y" &&
               (self.camsClickCount ?? "").isEmpty &&
               self.consent == "N" {
               self.cams.isHidden = true
               print("🔴 Button hidden due to empty PennyDrop + Derivative Y + Consent N + CAMSClickCount empty")
               return
           }
           
           // 🟢 CASE 1: Derivative = Y, PennyDrop = Y
           if self.isDerivative == "Y" {
               if self.camsClickCount == "" {
                   if self.isGetDocumentsFromCAMS == "N", self.consent == "N" {
                       self.cams.isHidden = false  // ✅ Show button
                   }
               } else if self.camsClickCount == "1" {
                   if self.isGetDocumentsFromCAMS == "N", self.consent == "N" {
                       self.cams.isHidden = false
                   } else if self.isGetDocumentsFromCAMS == "Y", self.consent == "Y" {
                       self.cams.isHidden = true
                   }
               } else if let clickCount = self.camsClickCount,
                         let clickInt = Int(clickCount), clickInt < 2 {
                   self.cams.isHidden = true
               }
           }
           
           print("🟢 CAMS button visibility updated: isHidden = \(self.cams.isHidden)")
       }
    
    func redirectCams() {
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
                            self.redirectCams()
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
                    "CAMSfipid": CAMSfipid ?? "",
                    "Document": "INCOMEPROOF",
                    "subDocument": "Six Months Bank Statement"
                    
                ]
                if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("RequestCAMS request:\n\(jsonString)")
                }
                print(parameters)
                let Url = "MultiPartImageUpload/RequestCAMS"
                
                apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
                    switch result {
                    case .success(let jsonResponse):
                        print("RequestCams Response: \(jsonResponse)")
                        if let errorCode = jsonResponse["ErrorCode"] as? String {
                            switch errorCode {
                            case "000000":
                                if let clientId = jsonResponse["clienttrnxid"] as? String,
                                   let redirectionUrl = jsonResponse["redirectionurl"] as? String {
                                    
                                    self.clienttrnxid = clientId
                                    print("Saved TxnId: \(clientId)")
                                    
                                    DispatchQueue.main.async {
                                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CamsVC") as? CamsVC {
                                            vc.fetchedUserId = self.fetchedUserId
                                            vc.fetchedSessionID = self.fetchedSessionID
                                            vc.panNo = self.panNo
                                            vc.regId = self.regId
                                            vc.clienttrnxid = clientId
                                            vc.mobiledecodeArray = self.mobiledecodeArray
                                            vc.redirectionUrl = redirectionUrl
                                            vc.PANName = self.PANName
                                            vc.EmailId = self.EmailId
                                            vc.CAMSfipid = self.CAMSfipid
                                            vc.comingFrom = .upiVC
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                    }
                                }
                            case "999992":
                                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "M",in: self.view) { success in
                                    if success {
                                        self.redirectCams()
                                        
                                    } else {
                                        DispatchQueue.main.async {
                                            self.showAlert(title: "Alert", message: "Token refresh failed. Please try again.")
                                        }
                                    }
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
        ) {
//           UIApplication.shared.canOpenURL(paytmURL) {
//            
//            let paytmAction = UIAlertAction(
//                title: "Paytm",
//                style: .default
//            ) { _ in
//                UIApplication.shared.open(paytmURL)
//            }
//            
//            paytmAction.setValue(
//                UIImage(named: "paytm")?.withRenderingMode(.alwaysOriginal),
//                forKey: "image"
//            )
//            
//            alert.addAction(paytmAction)
//        }
//
            print("Paytm URL:", paytmURL)
            print("Can Open Paytm:", UIApplication.shared.canOpenURL(paytmURL))

            if UIApplication.shared.canOpenURL(paytmURL) {

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
            
            if let amazonURL = URL(
                string: upiLink.replacingOccurrences(
                    of: "upi://",
                    with: "amazonpay://"
                )
            ),
            UIApplication.shared.canOpenURL(amazonURL) {

                let amazonAction = UIAlertAction(
                    title: "Amazon Pay",
                    style: .default
                ) { _ in
                    UIApplication.shared.open(amazonURL)
                }

                alert.addAction(amazonAction)
            }
            
            if let bhimURL = URL(
                string: upiLink.replacingOccurrences(
                    of: "upi://",
                    with: "bhim://"
                )
            ),
            UIApplication.shared.canOpenURL(bhimURL) {

                let bhimAction = UIAlertAction(
                    title: "BHIM",
                    style: .default
                ) { _ in
                    UIApplication.shared.open(bhimURL)
                }

                alert.addAction(bhimAction)
            }
            
            if let credURL = URL(
                string: upiLink.replacingOccurrences(
                    of: "upi://",
                    with: "credpay://"
                )
            ),
            UIApplication.shared.canOpenURL(credURL) {

                let credAction = UIAlertAction(
                    title: "CRED",
                    style: .default
                ) { _ in
                    UIApplication.shared.open(credURL)
                }

                credAction.setValue(
                    UIImage(named: "cred")?.withRenderingMode(.alwaysOriginal),
                    forKey: "image"
                )

                alert.addAction(credAction)
            }
            
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
