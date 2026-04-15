//
//  BankVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

class BankVC: UIViewController, UITextFieldDelegate, @MainActor ReloadPageDelegate {
    func reloadPageData() {
        self.ValidateToken()
    }
    
    var rejection : String?
    var micr: String?
    var bankName: String?
    var branch: String?
    var IFSC: String?
    var apiResponse: [String: Any]?
    var isPennyDrop: String = "Y"
    var panNo: String?
    var regId: String?
    var fetchedUserId: String?
    weak var delegate: ReloadPageDelegate?
    var fetchedSessionID: String?
    var mobiledecodeArray: String?
    var PANName: String?
    var EmailId: String?
    
    @IBOutlet weak var SubmitBtn: UIButton!
    @IBOutlet weak var ConfirmAccountNumberTF: UITextField!
    @IBOutlet weak var AccountNumberTF: UITextField!
    @IBOutlet weak var IFSCTF: UITextField!
    @IBOutlet weak var MICRTF: UITextField!
    @IBOutlet weak var upiIDBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SubmitBtn.layer.cornerRadius = 10
        AccountNumberTF.delegate = self
        ConfirmAccountNumberTF.delegate = self
        IFSCTF.delegate = self
        MICRTF.delegate = self
        fetchUserId()
        print("ispennydrop \(isPennyDrop)")
        
        AccountNumberTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        ConfirmAccountNumberTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        IFSCTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        navigationItem.hidesBackButton = true
        
        AccountNumberTF.layer.cornerRadius = 10
        AccountNumberTF.layer.borderWidth = 1
        AccountNumberTF.layer.borderColor = UIColor.appBorder.cgColor
        
        ConfirmAccountNumberTF.layer.cornerRadius = 10
        ConfirmAccountNumberTF.layer.borderWidth = 1
        ConfirmAccountNumberTF.layer.borderColor = UIColor.appBorder.cgColor
        
        IFSCTF.layer.cornerRadius = 10
        IFSCTF.layer.borderWidth = 1
        IFSCTF.layer.borderColor = UIColor.appBorder.cgColor
        
        MICRTF.layer.cornerRadius = 10
        MICRTF.layer.borderWidth = 1
        MICRTF.layer.borderColor = UIColor.appBorder.cgColor
        
        // SubmitBtn.isEnabled = false
        SubmitBtn.layer.cornerRadius = 10
        upiIDBtn.layer.cornerRadius = 10
        SubmitBtn.backgroundColor = .appPrimary
        upiIDBtn.backgroundColor = .appPrimary
        homeBtn.tintColor = .appPrimary
        view.backgroundColor = .appBackground
        
        if let savedPAN = UserDefaults.standard.string(forKey: "SavedPAN"), !savedPAN.isEmpty {
            self.panNo = savedPAN
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
                self.ValidateToken()
            } else {
                print("No UserID or SessionID found.")
            }
        }
    }
    
    //       @objc func confirmAccountBtnTapped() {
    //           // Check if the exclamation mark image is displayed on the ConfirmAccountBtn
    //           if let currentImage = ConfirmAccountNumberTF.image(for: .normal),
    //              currentImage == UIImage(systemName: "exclamationmark.circle.fill") {
    //               // Show alert for account number mismatch
    //               showAlert(message: "Account numbers do not match. Please re-enter the same account number.")
    //           }
    //       }
    
    
    @IBAction func SubmitBtn(_ sender: Any) {
        print("Submit button tapped")
        
        // Step 1: Check if rejection has value "Rejection"
        if rejection == "Rejection" {
            print("Rejection case detected. Performing all validations.")
            
            // Perform all validations
            guard let accountNumber = AccountNumberTF.text, accountNumber.count >= 9 else {
                showAlert(message: "Please enter a valid account number with at least 9 digits.")
                return
            }
            
            guard isAccountNumberValid() else {
                showAlert(message: "Account numbers do not match. Please ensure both account numbers are the same.")
                return
            }
            
            guard isIFSCValid() else {
                showAlert(message: "Please enter a valid IFSC code.")
                return
            }
            
            guard isMICRValid() else {
                showAlert(message: "Please enter MICR code.")
                return
            }
            
            //                   if let upiID = upiIDTF.text, !upiID.isEmpty {
            //                       guard isUPIValid() else {
            //                           showAlert(message: "Please enter a valid UPI ID.")
            //                           return
            //                       }
            //                   }
            
            // If all validations pass, call the API
            print("All validations passed for rejection case, calling API")
            SaveTradingBankDPClientData(accountnumber: AccountNumberTF.text!)
            return
        }
        
        // Step 2: Handle the fresh case (Penny Drop logic)
        if isPennyDrop.isEmpty {
            print("Penny drop is done. Navigating to the next page.")
            navigateToNextPage()
        } else {
            print("Fresh case detected. Performing validations.")
            
            // Perform all validations
            guard let accountNumber = AccountNumberTF.text, accountNumber.count >= 9 else {
                showAlert(message: "Please enter a valid account number with at least 9 digits.")
                return
            }
            
            guard isAccountNumberValid() else {
                showAlert(message: "Account numbers do not match. Please ensure both account numbers are the same.")
                return
            }
            
            guard isIFSCValid() else {
                showAlert(message: "Please enter a valid IFSC code.")
                return
            }
            
            guard isMICRValid() else {
                showAlert(message: "Please enter MICR code.")
                return
            }
            
            //                   if let upiID = upiIDTF.text, !upiID.isEmpty {
            //                       guard isUPIValid() else {
            //                           showAlert(message: "Please enter a valid UPI ID.")
            //                           return
            //                       }
            //                   }
            
            // If all validations pass, call the API
            print("All validations passed for fresh case, calling API")
            SaveTradingBankDPClientData(accountnumber: AccountNumberTF.text!)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func homeBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        delegate?.reloadPageData()
            self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacterSet: CharacterSet
        
        // Allow only digits for AccountNumberTF and ConfirmAccountNumberTF
        if textField == AccountNumberTF || textField == ConfirmAccountNumberTF {
            allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
            if string.rangeOfCharacter(from: allowedCharacterSet.inverted) != nil {
                return false
            }
            
            let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            return currentText.count < 18 // Limit to 9 digits
        }
        
        // Allow alphanumeric for IFSCTF
        if textField == IFSCTF {
            allowedCharacterSet = CharacterSet.alphanumerics
            if string.rangeOfCharacter(from: allowedCharacterSet.inverted) != nil {
                return false
            }
            
            let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            return currentText.count <= 11 // Limit to 11 characters
        }
        if textField == MICRTF {
            // Check if the replacement string is numeric
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            if !allowedCharacters.isSuperset(of: characterSet) {
                showAlert(message: "Please enter numbers only")
                return false
            }
            
            // Check if the total character count will exceed 9
            let currentText = textField.text ?? ""
            let newLength = currentText.count + string.count - range.length
            if newLength > 9 {
                showAlert(message: "Only 9 digits are allowed")
                return false
            }
        }
        
        // Allow any character for UPI ID
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Validate account number and confirm account number
        if textField == AccountNumberTF || textField == ConfirmAccountNumberTF {
            if let accountNumber = AccountNumberTF.text, let confirmNumber = ConfirmAccountNumberTF.text {
                
                let exclamationImage = UIImage(systemName: "exclamationmark.circle.fill")
                let checkmarkImage = UIImage(systemName: "checkmark.circle.fill")
                
                // If the account numbers match
                //                       if confirmNumber == accountNumber, !accountNumber.isEmpty {
                //                           AcountNumberLabel.text = accountNumber
                //                           ConfirmAccountBtn.setImage(checkmarkImage, for: .normal)
                //                           ConfirmAccountBtn.tintColor = .green
                //                           AccountBtn.setImage(checkmarkImage, for: .normal)
                //                           AccountBtn.tintColor = .green
                //                           ConfirmAccountBtn.isHidden = false
                //                           AccountBtn.isHidden = false
                //                           SubmitBtn.isEnabled = true
                //                           IFSCTF.isEnabled = true
                //                       } else {
                //                           // If the account numbers don't match, show the exclamation mark
                //                           ConfirmAccountBtn.setImage(exclamationImage, for: .normal)
                //                           ConfirmAccountBtn.tintColor = .red
                //                           ConfirmAccountBtn.isHidden = false
                //                           AccountBtn.isHidden = true
                //                           IFSCTF.isEnabled = false
                //                       }
            }
        }
        
        // Validate IFSC code
        if textField == IFSCTF {
            if let ifscCode = IFSCTF.text, ifscCode.count == 11 {
                // Call the IFSC search method
                IFSCSearchWithoutBankName(ifscCode: ifscCode)
            }
        }
        
        // Validate UPI ID
        //           if textField == upiIDTF {
        //               if validateUPIID(upiID: upiIDTF.text ?? "") {
        //                   // UPI ID is valid
        //                   SubmitBtn.isEnabled = isAccountNumberValid() && isIFSCValid()
        //               } else if upiIDTF.text?.isEmpty ?? true {
        //                   // Allow empty UPI ID
        //                   SubmitBtn.isEnabled = isAccountNumberValid() && isIFSCValid()
        //               } else {
        //                   // If UPI ID is invalid, disable Submit button
        //                   //SubmitBtn.isEnabled = false
        //               }
        //           }
    }
    
    func isAccountNumberValid() -> Bool {
        guard let accountNumber = AccountNumberTF.text else { return false }
        return accountNumber.count >= 9 && accountNumber == ConfirmAccountNumberTF.text
    }
    
    func isIFSCValid() -> Bool {
        guard let ifscCode = IFSCTF.text else { return false }
        return ifscCode.count == 11 // Further validation can be added here
    }
    
    func isMICRValid() -> Bool {
        guard let ifscCode = MICRTF.text else { return false }
        return ifscCode.count == 9 // Further validation can be added here
    }
    
    //       func isUPIValid() -> Bool {
    //           return validateUPIID(upiID: upiIDTF.text ?? "")
    //       }
    
    func validateUPIID(upiID: String) -> Bool {
        let upiRegex = "[A-Za-z0-9]+@[A-Za-z0-9]+"
        let upiTest = NSPredicate(format: "SELF MATCHES %@", upiRegex)
        return upiTest.evaluate(with: upiID)
    }
}


extension BankVC{
    func showErrorMessageAlert(message: String) {
        showAlert(message: message) // Use the showAlert function to show the error message
    }
    func showPennyDropAlert() {
        let alert = UIAlertController(title: "Alert", message: "Bank account could not be verified. Proceed with the same bank account or provide another account details.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Keep IsPennyDrop as "Y"
        }))
        
        alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { _ in
            // Change IsPennyDrop to "N"
            self.isPennyDrop = "N"
            self.SaveTradingBankDPClientData(accountnumber: self.AccountNumberTF.text ?? "")
            //self.navigateToNextPage()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func SaveTradingBankDPClientData(accountnumber: String) {
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
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
                        self.SaveTradingBankDPClientData(accountnumber: accountnumber)
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            
            let parameters: [String: Any?] = [
                "BankName": bankName,
                "MICRCode": micr,
                "BrokeragePlanEquityName": "",
                "IFSCCode": IFSC,
                "PanNo": panNo,
                "PinCode": "",
                "BankBranchAddress": branch,
                "IsPennyDrop": isPennyDrop,
                "UserId": fetchedUserId,
                "UPI_ID": "",
                "DPScheme": "",
                "BranchName": branch,
                "TokenId": tokenId,
                "BrokeragePlanCommodityName": "",
                "RegId": regId,
                "BankAccountNumber": accountnumber
            ]
            print(parameters)
            let Url = "Client/SaveTradingBankDPClientData"
            
            apiCall(url: Url, method: "POST", parameters: parameters as [String: Any], view: self.view,loaderText: "We are verifying your Bank Details, kindly wait...") { result in
                switch result {
                case .success(let jsonResponse):
                    print("SaveTradingBankDPClientData Response: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String, let errorMessage = jsonResponse["ErrorMessage"] as? String {
                        switch errorCode {
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
                                print("All TokenMobile entries deleted due to error code 999992")
                                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                                    if success {
                                        self.SaveTradingBankDPClientData(accountnumber: accountnumber)
                                    } else {
                                        print("Token generation failed.")
                                    }
                                }
                            }
                        case "000000":
                            DispatchQueue.main.async {
                                self.navigateToNextPage()
                                print("API is running")
                            }
                        case "000002":
                            DispatchQueue.main.async {
                                self.showPennyDropAlert()
                            }
                        case "531009":
                            DispatchQueue.main.async {
                                if let errorMessage = jsonResponse["ErrorMessage"] as? String {
                                    self.showErrorMessageAlert(message: errorMessage)
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
    
    func navigateToNextPage() {
//        if rejection == "Rejection" {
//            print("Rejection detected. Popping out the current screen.")
//            delegate?.reloadPageData()
//            self.navigationController?.popViewController(animated: true)
//            return
//        }
        
        // Navigate to NomineeDetailsVC if no rejection
        //           let storyboard = UIStoryboard(name: "Nominee", bundle: nil)
        //           if let nextVC = storyboard.instantiateViewController(withIdentifier: "NomineeDetailsVC") as? NomineeDetailsVC {
        //               nextVC.PanNo = panNo
        //               nextVC.RegId = regId
        //               nextVC.delegate = self
        //               self.navigationController?.pushViewController(nextVC, animated: true)
        let storyboard = UIStoryboard(name: "OtherDetails", bundle: Bundle.module)
        let vc = storyboard.instantiateViewController(identifier: "OtherDetailsVC") as! OtherDetailsVC
        vc.panNo = self.panNo
        vc.regId = self.regId
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func IFSCSearchWithoutBankName(ifscCode: String) {
        let parameters: [String: Any?] = [
            "BankName": "",
            "IFSC": ifscCode,
        ]
        print(parameters)
        let Url = "BankManagement/IFSCSearchWithoutBankName"
        
        apiCall(url: Url, method: "POST", parameters: parameters as [String: Any], view: self.view) { result in
            switch result {
            case .success(let jsonResponse):
                print("ViewOtherData Response: \(jsonResponse)")
                let ErrorMessage = jsonResponse["ErrorMessage"] as? String
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                        
                    case "000000":
                        DispatchQueue.main.async {
                            if let bankList = jsonResponse["BankList"] as? [[String: Any]],!bankList.isEmpty,
                               let firstBank = bankList.first {
                                // Update the properties
                                self.micr = firstBank["MICR"] as? String
                                self.IFSC = firstBank["IFSC"] as? String
                                self.bankName = firstBank["BankName"] as? String
                                self.branch = firstBank["Branch"] as? String
                                //  self.holderview2.isHidden = false
                                // Update the UI
                                self.MICRTF.text = self.micr
                                //                                               self.bankNamelbl.text = "\(self.bankName ?? "No bank name found")\n\(self.branch ?? "No branch name found")"
                                self.MICRTF.isEnabled = false
                            }else{
                                self.MICRTF.isEnabled = false
                                self.micr = nil
                                self.IFSC = nil
                                self.bankName = nil
                                self.branch = nil
                                self.MICRTF.text = nil
                                // self.bankNamelbl.text = nil
                                self.MICRTF.isEnabled = true
                            }
                            print("API is running")
                        }
                    case "111111":
                        self.MICRTF.isEnabled = false
                        self.showAlert(message: ErrorMessage ?? "failure")
                        print("failure")
                    default:
                        print("Unhandled error code: \(errorCode)")
                    }
                }
            case .failure(let error):
                print("Login API call failed: \(error.localizedDescription)")
            }
        }
    }
    func ValidateToken(){
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
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
                                self.ViewTradingBankDPClientData()
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
    
    func ViewTradingBankDPClientData(){
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "M",in: self.view) { success in
                    if success {
                        // Call SIXTHAPI after tokenMobile API call is successful
                        self.ViewTradingBankDPClientData()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "UserId":  fetchedUserId,
                "TokenId": tokenId,
                "RegId": regId,
                "PanNo": panNo,
                
            ]
            print(parameters)
            let Url = "Client/ViewTradingBankDPClientData"
            
            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("ViewTradingBankDPClientData Response: \(jsonResponse)")
                    //self.isPennyDrop = jsonResponse["IsPennyDropDone"] as? String ?? ""
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            DispatchQueue.main.async {
                                self.updateUI(with: jsonResponse)
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
    func updateUI(with response: [String: Any]) {
        // Check if "IsPennyDropDone" exists and is equal to "N"
        if let isPennyDropDone = response["IsPennyDropDone"] as? String, isPennyDropDone == "N" || !isPennyDropDone.isEmpty {
            //            self.isPennyDrop = "Y"
            // Update the bank name and branch if available
            if let bankName = response["BankName"] as? String, let branch = response["BranchName"] as? String {
                self.bankName = bankName
                self.branch = branch
                // self.bankNamelbl.text = "\(bankName)\n\(branch)"
                // self.holderview2.isHidden = false
            }
            
            // Update the account number and labels if available
            if let accountNumber = response["BankAccountNumber"] as? String {
                // AcountNumberLabel.text = accountNumber
                AccountNumberTF.text = accountNumber
                ConfirmAccountNumberTF.text = accountNumber
                //                   let checkmarkImage = UIImage(systemName: "checkmark.circle.fill")
                //                   ConfirmAccountBtn.setImage(checkmarkImage, for: .normal)
                //                   ConfirmAccountBtn.tintColor = .green
                //                   AccountBtn.setImage(checkmarkImage, for: .normal)
                //                   AccountBtn.tintColor = .green
                //                   ConfirmAccountBtn.isHidden = false
                //                   AccountBtn.isHidden = false
                SubmitBtn.isEnabled = true
                IFSCTF.isEnabled = true
            }
            
            // Update IFSC code if available
            if let ifscCode = response["IFSCCode"] as? String {
                IFSCTF.text = ifscCode
                self.IFSC = ifscCode
            }
            
            // Update MICR code if available
            if let micrCode = response["MICRCode"] as? String {
                MICRTF.text = "\(micrCode)"  // Convert MICR code to a string if it's an integer
                self.micr = micrCode
            }
            
            // Update UPI ID if available
            //               if let upiID = response["UPIID"] as? String {
            //                   upiIDTF.text = upiID
            //                   //self.upi
            //               }
            
            if let status = response["Status"] as? String, status == "REJECTED" {
                AccountNumberTF.textColor = .red
                ConfirmAccountNumberTF.textColor = .red
            } else {
                // Optional: Set text color back to default if not REJECTED
                AccountNumberTF.textColor = .black
                ConfirmAccountNumberTF.textColor = .black
            }
            // Disable the text fields and buttons since Penny Drop is not done
            if rejection == "Rejection" {
                // Enable all text fields
                AccountNumberTF.isEnabled = true
                ConfirmAccountNumberTF.isEnabled = true
                IFSCTF.isEnabled = true
                MICRTF.isEnabled = true
                // upiIDTF.isEnabled = true
            } else {
                // Disable text fields as per the previous logic
                AccountNumberTF.isEnabled = false
                ConfirmAccountNumberTF.isEnabled = false
                IFSCTF.isEnabled = false
                MICRTF.isEnabled = false
                //  upiIDTF.isEnabled = false
                SubmitBtn.isEnabled = false
                SubmitBtn.alpha = 0.5// Enable the submit button to navigate to the next page
            } // Enable the submit button to navigate to the next page
            
        } else {
            // If "IsPennyDropDone" is not "N" (or it's missing), skip updating the UI
            print("Penny drop is not done or data is missing. Skipping UI update.")
        }
    }
}
//
  //    private func fetchUserId() {
  //        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
  //            guard let self = self else { return }
  //
  //            if let userId = userId, let sessionID = sessionID {
  //                self.fetchedUserId = userId
  //                self.fetchedSessionID = sessionID
  //                self.mobiledecodeArray = decodeByteArrayString
  //                print("UserID: \(userId), SessionID: \(sessionID)")
  //                self.ValidateToken()
  //            } else {
  //                print("No UserID or SessionID found.")
  //            }
  //        }
  //    }
  //
  //    @IBAction func SubmitBtn(_ sender: Any) {
  //        print("Submit button tapped")
  //
  //        // Step 1: Check if rejection has value "Rejection"
  //        if rejection == "Rejection" {
  //            print("Rejection case detected. Performing all validations.")
  //
  //            // Perform all validations
  //            guard let accountNumber = AccountNumberTF.text, accountNumber.count >= 9 else {
  //                showAlert(message: "Please enter a valid account number with at least 9 digits.")
  //                return
  //            }
  //
  //            guard isAccountNumberValid() else {
  //                showAlert(message: "Account numbers do not match. Please ensure both account numbers are the same.")
  //                return
  //            }
  //
  //            guard isIFSCValid() else {
  //                showAlert(message: "Please enter a valid IFSC code.")
  //                return
  //            }
  //
  //            guard isMICRValid() else {
  //                showAlert(message: "Please enter MICR code.")
  //                return
  //            }
  //
  ////            if let upiID = upiIDTF.text, !upiID.isEmpty {
  ////                guard isUPIValid() else {
  ////                    showAlert(message: "Please enter a valid UPI ID.")
  ////                    return
  ////                }
  ////            }
  //
  //            // If all validations pass, call the API
  //            print("All validations passed for rejection case, calling API")
  //            SaveTradingBankDPClientData(accountnumber: AccountNumberTF.text!)
  //            return
  //        }
  //
  //        // Step 2: Handle the fresh case (Penny Drop logic)
  //        if isPennyDrop.isEmpty {
  //            print("Penny drop is done. Navigating to the next page.")
  //            navigateToNextPage()
  //        } else {
  //            print("Fresh case detected. Performing validations.")
  //
  //            // Perform all validations
  //            guard let accountNumber = AccountNumberTF.text, accountNumber.count >= 9 else {
  //                showAlert(message: "Please enter a valid account number with at least 9 digits.")
  //                return
  //            }
  //
  //            guard isAccountNumberValid() else {
  //                showAlert(message: "Account numbers do not match. Please ensure both account numbers are the same.")
  //                return
  //            }
  //
  //            guard isIFSCValid() else {
  //                showAlert(message: "Please enter a valid IFSC code.")
  //                return
  //            }
  //
  //            guard isMICRValid() else {
  //                showAlert(message: "Please enter MICR code.")
  //                return
  //            }
  //
  //            //                        if let upiID = upiIDTF.text, !upiID.isEmpty {
  //            //                            guard isUPIValid() else {
  //            //                                showAlert(message: "Please enter a valid UPI ID.")
  //            //                                return
  //            //                            }
  //            //                        }
  //
  //            // If all validations pass, call the API
  //            print("All validations passed for fresh case, calling API")
  //            SaveTradingBankDPClientData(accountnumber: AccountNumberTF.text!)
  //        }
  //    }
  //
  //    func showAlert(message: String) {
  //        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
  //        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
  //        self.present(alert, animated: true, completion: nil)
  //    }
  //
  //    @IBAction func homeBtn(_ sender: UIButton) {
  //        // self.navigationController?.popToRootViewController(animated: true)
  //    }
  //
  //    @IBAction func BackBtn(_ sender: UIButton) {
  //        delegate?.reloadPageData()
  //
  //        //          let vc = ApplicationFormVC()
  //        //          vc.panNo = panNo
  //        //          vc.regId = regId
  //        //          vc.PANName = PANName
  //        //          vc.EmailId = EmailId
  //
  //        navigationController?.popViewController(animated: true)
  //    }
  //
  //    // MARK: - UITextFieldDelegate
  //
  //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
  //        let allowedCharacterSet: CharacterSet
  //
  //        // Allow only digits for AccountNumberTF and ConfirmAccountNumberTF
  //        if textField == AccountNumberTF || textField == ConfirmAccountNumberTF {
  //            allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
  //            if string.rangeOfCharacter(from: allowedCharacterSet.inverted) != nil {
  //                return false
  //            }
  //
  //            let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
  //            return currentText.count < 18 // Limit to 9 digits
  //        }
  //
  //        // Allow alphanumeric for IFSCTF
  //        if textField == IFSCTF {
  //            allowedCharacterSet = CharacterSet.alphanumerics
  //            if string.rangeOfCharacter(from: allowedCharacterSet.inverted) != nil {
  //                return false
  //            }
  //
  //            let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
  //            return currentText.count <= 11 // Limit to 11 characters
  //        }
  //        if textField == MICRTF {
  //            // Check if the replacement string is numeric
  //            let allowedCharacters = CharacterSet.decimalDigits
  //            let characterSet = CharacterSet(charactersIn: string)
  //            if !allowedCharacters.isSuperset(of: characterSet) {
  //                showAlert(message: "Please enter numbers only")
  //                return false
  //            }
  //
  //            // Check if the total character count will exceed 9
  //            let currentText = textField.text ?? ""
  //            let newLength = currentText.count + string.count - range.length
  //            if newLength > 9 {
  //                showAlert(message: "Only 9 digits are allowed")
  //                return false
  //            }
  //        }
  //
  //        // Allow any character for UPI ID
  //        return true
  //    }
  //
  //    @objc func textFieldDidChange(_ textField: UITextField) {
  //        // Validate account number and confirm account number
  //        //        if textField == AccountNumberTF || textField == ConfirmAccountNumberTF {
  //        //                if let accountNumber = AccountNumberTF.text, let confirmNumber = ConfirmAccountNumberTF.text {
  //        //
  //        //                    let exclamationImage = UIImage(systemName: "exclamationmark.circle.fill")
  //        //                    let checkmarkImage = UIImage(systemName: "checkmark.circle.fill")
  //        //
  //        //                    // If the account numbers match
  //        //                    if confirmNumber == accountNumber, !accountNumber.isEmpty {
  //        //                        AcountNumberLabel.text = accountNumber
  //        //                        ConfirmAccountBtn.setImage(checkmarkImage, for: .normal)
  //        //                        ConfirmAccountBtn.tintColor = .green
  //        //                        AccountBtn.setImage(checkmarkImage, for: .normal)
  //        //                        AccountBtn.tintColor = .green
  //        //                        ConfirmAccountBtn.isHidden = false
  //        //                        AccountBtn.isHidden = false
  //        //                        SubmitBtn.isEnabled = true
  //        //                        IFSCTF.isEnabled = true
  //        //                    } else {
  //        //                        // If the account numbers don't match, show the exclamation mark
  //        //                        ConfirmAccountBtn.setImage(exclamationImage, for: .normal)
  //        //                        ConfirmAccountBtn.tintColor = .red
  //        //                        ConfirmAccountBtn.isHidden = false
  //        //                        AccountBtn.isHidden = true
  //        //                        IFSCTF.isEnabled = false
  //        //                    }
  //        //                }
  //        //            }
  //
  //        // Validate IFSC code
  //        if textField == IFSCTF {
  //            if let ifscCode = IFSCTF.text, ifscCode.count == 11 {
  //                // Call the IFSC search method
  //                IFSCSearchWithoutBankName(ifscCode: ifscCode)
  //            }
  //        }
  //
  //        // Validate UPI ID
  //        //        if textField == upiIDTF {
  //        //            if validateUPIID(upiID: upiIDTF.text ?? "") {
  //        //                // UPI ID is valid
  //        //                SubmitBtn.isEnabled = isAccountNumberValid() && isIFSCValid()
  //        //            } else if upiIDTF.text?.isEmpty ?? true {
  //        //                // Allow empty UPI ID
  //        //                SubmitBtn.isEnabled = isAccountNumberValid() && isIFSCValid()
  //        //            } else {
  //        //                // If UPI ID is invalid, disable Submit button
  //        //                //SubmitBtn.isEnabled = false
  //        //            }
  //        //        }
  //    }
  //
  //    func isAccountNumberValid() -> Bool {
  //        guard let accountNumber = AccountNumberTF.text else { return false }
  //        return accountNumber.count >= 9 && accountNumber == ConfirmAccountNumberTF.text
  //    }
  //
  //    func isIFSCValid() -> Bool {
  //        guard let ifscCode = IFSCTF.text else { return false }
  //        return ifscCode.count == 11 // Further validation can be added here
  //    }
  //
  //    func isMICRValid() -> Bool {
  //        guard let ifscCode = MICRTF.text else { return false }
  //        return ifscCode.count == 9 // Further validation can be added here
  //    }
  //
  //    //    func isUPIValid() -> Bool {
  //    //        return validateUPIID(upiID: upiIDTF.text ?? "")
  //    //    }
  //    //
  //    func validateUPIID(upiID: String) -> Bool {
  //        let upiRegex = "[A-Za-z0-9]+@[A-Za-z0-9]+"
  //        let upiTest = NSPredicate(format: "SELF MATCHES %@", upiRegex)
  //        return upiTest.evaluate(with: upiID)
  //    }
  //}
  //
  //
  //extension BankVC{
  //    func showErrorMessageAlert(message: String) {
  //        showAlert(message: message) // Use the showAlert function to show the error message
  //    }
  //    func showPennyDropAlert() {
  //                let alert = UIAlertController(title: "Alert", message: "Bank account could not be verified. Proceed with the same bank account or provide another account details.", preferredStyle: .alert)
  //
  //                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
  //                    // Keep IsPennyDrop as "Y"
  //                }))
  //
  //                alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { _ in
  //                    // Change IsPennyDrop to "N"
  //                    self.isPennyDrop = "N"
  //                    self.SaveTradingBankDPClientData(accountnumber: self.AccountNumberTF.text ?? "")
  //                    //self.navigateToNextPage()
  //
  //                }))
  //
  //                self.present(alert, animated: true, completion: nil)
  //            }
  //
  ////    func SaveTradingBankDPClientData(accountnumber: String) {
  ////
  ////        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
  ////            guard let tokenId = tokenId else {
  ////                // Handle the case where no tokens are available
  ////                CoreDataHelper.generateToken(
  ////                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
  ////                    USERID: self.fetchedUserId ?? "",
  ////                    SessionId: self.fetchedSessionID ?? "",
  ////                    entityName: "TokenMobile", deviceType: "M", in: self.view
  ////                ) { success in
  ////                    if success {
  ////                        // Retry SIXTHAPI after token regeneration
  ////                        self.SaveTradingBankDPClientData(accountnumber: accountnumber)
  ////                    } else {
  ////                        print("Token generation failed.")
  ////                    }
  ////                }
  ////                print("No tokens available. Please reload the tokens.")
  ////                return
  ////            }
  ////
  ////            let savedPAN = UserDefaults.standard.string(forKey: "SavedPAN")
  ////              let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : panNo
  ////
  ////            let parameters: [String: Any?] = [
  ////                "BankName": bankName,
  ////                "MICRCode": micr,
  ////                "BrokeragePlanEquityName": "",
  ////                "IFSCCode": IFSC,
  ////                "PanNo": finalPAN,
  ////                "PinCode": "",
  ////                "BankBranchAddress": branch,
  ////                "IsPennyDrop": isPennyDrop,
  ////                "UserId": fetchedUserId,
  ////                "UPI_ID": "",
  ////                "DPScheme": "",
  ////                "BranchName": branch,
  ////                "TokenId": tokenId,
  ////                "BrokeragePlanCommodityName": "",
  ////                "RegId": regId,
  ////                "BankAccountNumber": accountnumber
  ////            ]
  ////            print(parameters)
  ////            let Url = "Client/SaveTradingBankDPClientData"
  ////
  ////            apiCall(url: Url, method: "POST", parameters: parameters as [String: Any], view: self.view,loaderText: "We are verifying your Bank Details, kindly wait...") { result in
  ////                switch result {
  ////                case .success(let jsonResponse):
  ////                    print("SaveTradingBankDPClientData Response: \(jsonResponse)")
  ////                    if let errorCode = jsonResponse["ErrorCode"] as? String, let errorMessage = jsonResponse["ErrorMessage"] as? String {
  ////                        switch errorCode {
  ////                        case "999992":
  ////                            DispatchQueue.main.async {
  ////                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
  ////                                print("All TokenMobile entries deleted due to error code 999992")
  ////                                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
  ////                                    if success {
  ////                                        self.SaveTradingBankDPClientData(accountnumber: accountnumber)
  ////                                    } else {
  ////                                        print("Token generation failed.")
  ////                                    }
  ////                                }
  ////                            }
  ////                        case "000000":
  ////                            DispatchQueue.main.async {
  ////                                                 if self.rejection == "Rejection" {
  ////                                                     // Pop back for rejection case
  ////                                                     print("Rejection detected after successful API. Popping back.")
  ////                                                     self.delegate?.reloadPageData()
  ////                                                     self.navigationController?.popViewController(animated: true)
  ////                                                 } else {
  ////                                                     // Navigate to next page for normal success
  ////                                                     print("API success. Navigating to next page.")
  ////                                                     self.navigateToNextPage()
  ////                                                 }
  ////                                             }
  ////                        case "000002":
  ////                            DispatchQueue.main.async {
  ////                                self.showPennyDropAlert()
  ////                            }
  ////                        case "531009":
  ////                            DispatchQueue.main.async {
  ////                                if let errorMessage = jsonResponse["ErrorMessage"] as? String {
  ////                                    self.showErrorMessageAlert(message: errorMessage)
  ////                                }
  ////                            }
  ////                        default:
  ////                            print("Unhandled error code: \(errorCode)")
  ////                        }
  ////                    }
  ////                case .failure(let error):
  ////                    print("Login API call failed: \(error.localizedDescription)")
  ////                }
  ////            }
  ////        }
  ////    }
  ////
  //
  //    func SaveTradingBankDPClientData(accountnumber: String) {
  //
  //        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
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
  //                        self.SaveTradingBankDPClientData(accountnumber: accountnumber)
  //                    } else {
  //                        print("Token generation failed.")
  //                    }
  //                }
  //                print("No tokens available. Please reload the tokens.")
  //                return
  //            }
  //
  //            let savedPAN = UserDefaults.standard.string(forKey: "SavedPAN")
  //            let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : panNo
  //
  //            let parameters: [String: Any?] = [
  //                "BankName": bankName,
  //                "MICRCode": micr,
  //                "BrokeragePlanEquityName": "",
  //                "IFSCCode": IFSC,
  //                "PanNo": finalPAN,
  //                "PinCode": "",
  //                "BankBranchAddress": branch,
  //                "IsPennyDrop": isPennyDrop,
  //                "UserId": fetchedUserId,
  //                "UPI_ID": "",
  //                "DPScheme": "",
  //                "BranchName": branch,
  //                "TokenId": tokenId,
  //                "BrokeragePlanCommodityName": "",
  //                "RegId": regId,
  //                "BankAccountNumber": accountnumber
  //            ]
  //            print(parameters)
  //            let Url = "Client/SaveTradingBankDPClientData"
  //
  //            apiCall(url: Url, method: "POST", parameters: parameters as [String: Any], view: self.view, loaderText: "We are verifying your Bank Details, kindly wait...") { result in
  //                switch result {
  //                case .success(let jsonResponse):
  //                    print("SaveTradingBankDPClientData Response: \(jsonResponse)")
  //                    if let errorCode = jsonResponse["ErrorCode"] as? String, let errorMessage = jsonResponse["ErrorMessage"] as? String {
  //                        switch errorCode {
  //                        case "999992":
  //                            DispatchQueue.main.async {
  //                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
  //                                print("All TokenMobile entries deleted due to error code 999992")
  //                                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
  //                                    if success {
  //                                        self.SaveTradingBankDPClientData(accountnumber: accountnumber)
  //                                    } else {
  //                                        print("Token generation failed.")
  //                                    }
  //                                }
  //                            }
  //                        case "000000":
  //                            DispatchQueue.main.async {
  //                                // Add debug print to check the rejection value
  //                                print("🔍 Rejection value before decision: \(self.rejection ?? "nil")")
  //
  //                                if self.rejection == "Rejection" {
  //                                    // Pop back for rejection case
  //                                    print("Rejection detected after successful API. Popping back.")
  //                                    self.delegate?.reloadPageData()
  //                                    self.navigationController?.popViewController(animated: true)
  //                                } else {
  //                                    // Navigate to next page for normal success
  //                                    print("API success. Navigating to next page.")
  //                                    self.navigateToNextPage()
  //                                }
  //                            }
  //                        case "000002":
  //                            DispatchQueue.main.async {
  //                                self.showPennyDropAlert()
  //                            }
  //                        case "531009":
  //                            DispatchQueue.main.async {
  //                                if let errorMessage = jsonResponse["ErrorMessage"] as? String {
  //                                    self.showErrorMessageAlert(message: errorMessage)
  //                                }
  //                            }
  //                        default:
  //                            print("Unhandled error code: \(errorCode)")
  //                        }
  //                    }
  //                case .failure(let error):
  //                    print("Login API call failed: \(error.localizedDescription)")
  //                }
  //            }
  //        }
  //    }
  //
  //    func navigateToNextPage() {
  //        print("➡️ navigateToNextPage called")
  //        let storyboard = UIStoryboard(name: "OtherDetails", bundle: Bundle.module)
  //        let vc = storyboard.instantiateViewController(identifier: "OtherDetailsVC") as! OtherDetailsVC
  //        vc.panNo = self.panNo
  //        vc.regId = self.regId
  //        self.navigationController?.pushViewController(vc, animated: true)
  //    }
  //
  //
  //
  ////    func navigateToNextPage() {
  ////        //        if rejection == "Rejection" {
  ////        //            print("Rejection detected. Popping out the current screen.")
  ////        //            delegate?.reloadPageData()
  ////        //            self.navigationController?.popViewController(animated: true)
  ////        //            return
  ////        //        }
  ////
  ////        if let rejection = rejection, rejection == "Rejection" {
  ////            delegate?.reloadPageData()
  ////            self.navigationController?.popViewController(animated: true)
  ////            return
  ////        }
  ////
  ////        // Navigate to NomineeDetailsVC if no rejection
  ////        let storyboard = UIStoryboard(name: "OtherDetails", bundle: Bundle.module)
  ////        let vc = storyboard.instantiateViewController(identifier: "OtherDetailsVC") as! OtherDetailsVC
  ////        vc.panNo = self.panNo
  ////        vc.regId = self.regId
  ////        vc.delegate = self
  ////        self.navigationController?.pushViewController(vc, animated: true)
  ////    }
  //
  ////    func navigateToNextPage() {
  ////
  ////        print("Rejection: \(rejection ?? "nil")")
  ////        print("isPennyDrop: \(isPennyDrop)")
  ////
  ////        // ✅ ONLY handle rejection here
  ////        if rejection == "Rejection" {
  ////            print("🔙 Rejection flow → Going back")
  ////            delegate?.reloadPageData()
  ////            self.navigationController?.popViewController(animated: true)
  ////            return
  ////        }
  ////
  ////        // ✅ ALL other cases → go forward (penny drop success/fail doesn't matter)
  ////        print("➡️ Normal flow → Going to next page")
  ////
  ////        let storyboard = UIStoryboard(name: "OtherDetails", bundle: Bundle.module)
  ////        let vc = storyboard.instantiateViewController(identifier: "OtherDetailsVC") as! OtherDetailsVC
  ////        vc.panNo = self.panNo
  ////        vc.regId = self.regId
  ////        vc.delegate = self
  ////        self.navigationController?.pushViewController(vc, animated: true)
  ////    }
  //
  //    func IFSCSearchWithoutBankName(ifscCode: String) {
  //        let parameters: [String: Any?] = [
  //            "BankName": "",
  //            "IFSC": ifscCode,
  //        ]
  //        print(parameters)
  //        let Url = "BankManagement/IFSCSearchWithoutBankName"
  //
  //        apiCall(url: Url, method: "POST", parameters: parameters as [String: Any], view: self.view) { result in
  //            switch result {
  //            case .success(let jsonResponse):
  //                print("ViewOtherData Response: \(jsonResponse)")
  //                let ErrorMessage = jsonResponse["ErrorMessage"] as? String
  //                if let errorCode = jsonResponse["ErrorCode"] as? String {
  //                    switch errorCode {
  //
  //                    case "000000":
  //                        DispatchQueue.main.async {
  //                            if let bankList = jsonResponse["BankList"] as? [[String: Any]],!bankList.isEmpty,
  //                               let firstBank = bankList.first {
  //                                // Update the properties
  //                                self.micr = firstBank["MICR"] as? String
  //                                self.IFSC = firstBank["IFSC"] as? String
  //                                self.bankName = firstBank["BankName"] as? String
  //                                self.branch = firstBank["Branch"] as? String
  //                                //self.holderview2.isHidden = false
  //                                // Update the UI
  //                                self.MICRTF.text = self.micr
  //                                //                                            self.bankNamelbl.text = "\(self.bankName ?? "No bank name found")\n\(self.branch ?? "No branch name found")"
  //                                self.MICRTF.isEnabled = false
  //                            }else{
  //                                self.MICRTF.isEnabled = false
  //                                self.micr = nil
  //                                self.IFSC = nil
  //                                self.bankName = nil
  //                                self.branch = nil
  //                                self.MICRTF.text = nil
  //                                // self.bankNamelbl.text = nil
  //                                self.MICRTF.isEnabled = true
  //                            }
  //                            print("API is running")
  //                        }
  //                    case "111111":
  //                        self.MICRTF.isEnabled = false
  //                        self.showAlert(message: ErrorMessage ?? "failure")
  //                        print("failure")
  //                    default:
  //                        print("Unhandled error code: \(errorCode)")
  //                    }
  //                }
  //            case .failure(let error):
  //                print("Login API call failed: \(error.localizedDescription)")
  //            }
  //        }
  //    }
  //    func ValidateToken(){
  //
  //        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
  //            guard let tokenId = tokenId else {
  //                // Handle the case where no tokens are available
  //                CoreDataHelper.generateToken(
  //                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
  //                    USERID: self.fetchedUserId ?? "",
  //                    SessionId: self.fetchedSessionID ?? "",
  //                    entityName: "TokenMobile", deviceType: "W", in: self.view
  //                ) { success in
  //                    if success {
  //                        // Retry SIXTHAPI after token regeneration
  //                        self.ValidateToken()
  //                    } else {
  //                        print("Token generation failed.")
  //                    }
  //                }
  //                print("No tokens available. Please reload the tokens.")
  //                return
  //            }
  //            let parameters: [String: Any?] = [
  //                "UserId":  fetchedUserId,
  //                "TokenId": tokenId
  //            ]
  //            print(parameters)
  //            let Url = "TokenAuthentication/ValidateToken"
  //
  //            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
  //                switch result {
  //                case .success(let jsonResponse):
  //                    print("ValidateToken Response: \(jsonResponse)")
  //                    if let errorCode = jsonResponse["ErrorCode"] as? String {
  //                        switch errorCode {
  //                        case "000000":
  //                            DispatchQueue.main.async {
  //                                print("api is running")
  //                                self.ViewTradingBankDPClientData()
  //                            }
  //                        default:
  //                            print("Unhandled error code: \(errorCode)")
  //                        }
  //                    }
  //                case .failure(let error):
  //                    print("Login API call failed: \(error.localizedDescription)")
  //                }
  //            }
  //        }
  //    }
  //
  //    func ViewTradingBankDPClientData(){
  //
  //        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
  //            guard let tokenId = tokenId else {
  //                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
  //                    if success {
  //                        // Call SIXTHAPI after tokenMobile API call is successful
  //                        self.ViewTradingBankDPClientData()
  //                    } else {
  //                        print("Token generation failed.")
  //                    }
  //                }
  //                print("No tokens available. Please reload the tokens.")
  //                return
  //            }
  //            let parameters: [String: Any?] = [
  //                "UserId":  fetchedUserId,
  //                "TokenId": tokenId,
  //                "RegId": regId,
  //                "PanNo": panNo,
  //
  //            ]
  //            print(parameters)
  //            let Url = "Client/ViewTradingBankDPClientData"
  //
  //            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
  //                switch result {
  //                case .success(let jsonResponse):
  //                    print("ViewTradingBankDPClientData Response: \(jsonResponse)")
  //                    //self.isPennyDrop = jsonResponse["IsPennyDropDone"] as? String ?? ""
  //                    if let errorCode = jsonResponse["ErrorCode"] as? String {
  //                        switch errorCode {
  //                        case "000000":
  //                            DispatchQueue.main.async {
  //                                self.updateUI(with: jsonResponse)
  //                            }
  //                        default:
  //                            print("Unhandled error code: \(errorCode)")
  //                        }
  //                    }
  //                case .failure(let error):
  //                    print("Login API call failed: \(error.localizedDescription)")
  //                }
  //            }
  //        }
  //    }
  //    func updateUI(with response: [String: Any]) {
  //        // Check if "IsPennyDropDone" exists and is equal to "N"
  //        if let isPennyDropDone = response["IsPennyDropDone"] as? String, isPennyDropDone == "N" || !isPennyDropDone.isEmpty {
  //            //            self.isPennyDrop = "Y"
  //            // Update the bank name and branch if available
  //            if let bankName = response["BankName"] as? String, let branch = response["BranchName"] as? String {
  //                self.bankName = bankName
  //                self.branch = branch
  //                //                self.bankNamelbl.text = "\(bankName)\n\(branch)"
  //                //                self.holderview2.isHidden = false
  //            }
  //
  //            // Update the account number and labels if available
  //            if let accountNumber = response["BankAccountNumber"] as? String {
  //                //    AcountNumberLabel.text = accountNumber
  //                AccountNumberTF.text = accountNumber
  //                ConfirmAccountNumberTF.text = accountNumber
  //                let checkmarkImage = UIImage(systemName: "checkmark.circle.fill")
  //                //                ConfirmAccountBtn.setImage(checkmarkImage, for: .normal)
  //                //                ConfirmAccountBtn.tintColor = .green
  //                //                AccountBtn.setImage(checkmarkImage, for: .normal)
  //                //                AccountBtn.tintColor = .green
  //                //                ConfirmAccountBtn.isHidden = false
  //                //                AccountBtn.isHidden = false
  //                SubmitBtn.isEnabled = true
  //                IFSCTF.isEnabled = true
  //            }
  //
  //            // Update IFSC code if available
  //            if let ifscCode = response["IFSCCode"] as? String {
  //                IFSCTF.text = ifscCode
  //                self.IFSC = ifscCode
  //            }
  //
  //            // Update MICR code if available
  //            if let micrCode = response["MICRCode"] as? String {
  //                MICRTF.text = "\(micrCode)"  // Convert MICR code to a string if it's an integer
  //                self.micr = micrCode
  //            }
  //
  //            // Update UPI ID if available
  //            //            if let upiID = response["UPIID"] as? String {
  //            //                upiIDTF.text = upiID
  //            //                //self.upi
  //            //            }
  //
  //            if let status = response["Status"] as? String, status == "REJECTED" {
  //                AccountNumberTF.textColor = .red
  //                ConfirmAccountNumberTF.textColor = .red
  //            } else {
  //                // Optional: Set text color back to default if not REJECTED
  //                AccountNumberTF.textColor = .black
  //                ConfirmAccountNumberTF.textColor = .black
  //            }
  //            // Disable the text fields and buttons since Penny Drop is not done
  //            if rejection == "Rejection" {
  //                // Enable all text fields
  //                AccountNumberTF.isEnabled = true
  //                ConfirmAccountNumberTF.isEnabled = true
  //                IFSCTF.isEnabled = true
  //                MICRTF.isEnabled = true
  //                //  upiIDTF.isEnabled = true
  //            } else {
  //                // Disable text fields as per the previous logic
  //                AccountNumberTF.isEnabled = false
  //                ConfirmAccountNumberTF.isEnabled = false
  //                IFSCTF.isEnabled = false
  //                MICRTF.isEnabled = false
  //                // upiIDTF.isEnabled = false
  //                SubmitBtn.isEnabled = false
  //                SubmitBtn.alpha = 0.5// Enable the submit button to navigate to the next page
  //            } // Enable the submit button to navigate to the next page
  //
  //        } else {
  //            // If "IsPennyDropDone" is not "N" (or it's missing), skip updating the UI
  //            print("Penny drop is not done or data is missing. Skipping UI update.")
  //        }
  //    }
  //}
  //
