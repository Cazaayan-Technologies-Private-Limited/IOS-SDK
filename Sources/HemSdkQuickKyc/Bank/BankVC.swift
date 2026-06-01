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
    var bankList: [[String: Any]] = []
    var filteredBankList: [[String: Any]] = []
    var clienttrnxid: String?
    var segmentsPreferred: String?
    var PANName: String?
    var EmailId: String?
    var camsClosed: Bool = false
    var IsBankMappedInCAMS: String = ""
    var isConcentSubmitted: String?
    var isDerivative: String?
    var isGetDocumentsFromCAMS: String?
    var consent: String?
    var camsClickCount: String?
    var canNavigateNextPage = false
    var retryCount000002 = 0
    let maxRetry = 1
    var hasNavigatedToOtherDetails = false
    var CAMSfipid: String?
    var isPennyDropSixth: String?
    var isCAMS: String?
    var allowNavigation = false
    var isIFSCVerified = false
    
    @IBOutlet weak var SubmitBtn: UIButton!
    @IBOutlet weak var ConfirmAccountNumberTF: UITextField!
    @IBOutlet weak var AccountNumberTF: UITextField!
    @IBOutlet weak var IFSCTF: UITextField!
    @IBOutlet weak var MICRTF: UITextField!
    @IBOutlet weak var upiIDBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var connectToCams: UIButton!
    @IBOutlet weak var bankView: UIView!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var ifscView: UIView!
    @IBOutlet weak var micrView: UIView!
    
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
        
        bankView.layer.cornerRadius = 10
        bankView.layer.borderWidth = 1
        bankView.layer.borderColor = UIColor.appBorder.cgColor
        
        confirmView.layer.cornerRadius = 10
        confirmView.layer.borderWidth = 1
        confirmView.layer.borderColor = UIColor.appBorder.cgColor
        
        ifscView.layer.cornerRadius = 10
        ifscView.layer.borderWidth = 1
        ifscView.layer.borderColor = UIColor.appBorder.cgColor
        
        micrView.layer.cornerRadius = 10
        micrView.layer.borderWidth = 1
        micrView.layer.borderColor = UIColor.appBorder.cgColor
        
        // SubmitBtn.isEnabled = false
        SubmitBtn.layer.cornerRadius = 10
        upiIDBtn.layer.cornerRadius = 10
        SubmitBtn.backgroundColor = .appPrimary
        upiIDBtn.backgroundColor = .appBackground
        homeBtn.tintColor = .appPrimary
        view.backgroundColor = .appBackground
        
        connectToCams.backgroundColor = .appPrimary
        connectToCams.layer.cornerRadius = 10
        //connectToCams.isHidden = true
        
        SIXTHAPI(userID: fetchedUserId ?? "")
        upiIDBtn.backgroundColor = .documentBackground
        upiIDBtn.isHidden = true
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        if let userId = fetchedUserId {
    //            SIXTHAPI(userID: userId)845204
    //        }
    //    }
    
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
    
    
    @IBAction func UpiDetailsBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Bank", bundle: Bundle.module)
               let vc = storyboard.instantiateViewController(identifier: "UPIVC") as! UPIVC
        let savedPAN = UserDefaults.standard.string(forKey: "PanNo")
                let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.panNo
                vc.panNo = finalPAN
                vc.regId = regId
               self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func connectToCams(_ sender: UIButton) {
        redirectCams()
    }
    
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
            
//            guard isIFSCValid() else {
//                showAlert(message: "Please enter a valid IFSC code.")
//                return
//            }
            
            guard isIFSCValid(), isIFSCVerified else {
                showAlert(message: "Please enter a valid IFSC code.")
                return
            }
            
            guard isMICRValid() else {
                showAlert(message: "Please enter MICR code.")
                return
            }
            
            
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
        //delegate?.reloadPageData()
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
    
   // @objc func textFieldDidChange(_ textField: UITextField) {
        
        // ✅ Convert IFSC to uppercase automatically
//        if textField == IFSCTF {
//            textField.text = textField.text?.uppercased()
//        }
//        
//        // Validate account number and confirm account number
//        if textField == AccountNumberTF || textField == ConfirmAccountNumberTF {
//            if let accountNumber = AccountNumberTF.text, let confirmNumber = ConfirmAccountNumberTF.text {
//                
//                if confirmNumber == accountNumber, !accountNumber.isEmpty {
//                    SubmitBtn.isEnabled = true
//                    IFSCTF.isEnabled = true
//                } else {
//                    IFSCTF.isEnabled = false
//                }
//            }
//        }
//        
//        // Validate IFSC code
//        if textField == IFSCTF {
////            if let ifscCode = IFSCTF.text, ifscCode.count == 11 {
////                IFSCSearchWithoutBankName(ifscCode: ifscCode)
////            }
////        }
////    }
//        
//        if textField == IFSCTF {
//            textField.text = textField.text?.uppercased()
//            
//            // Validate IFSC when it reaches 11 characters
//            if let ifscCode = IFSCTF.text, ifscCode.count == 11 {
//                // Clear previous data while validating
//                self.MICRTF.text = ""
//                self.micr = nil
//                self.bankName = nil
//                self.branch = nil
//                self.IFSC = nil
//                self.isIFSCVerified = false
//                
//                // Call validation API
//                IFSCSearchWithoutBankName(ifscCode: ifscCode)
//            } else if let ifscCode = IFSCTF.text, ifscCode.count < 11 && ifscCode.count > 0 {
//                // If user deletes characters, clear the MICR field and reset verification flag
//                self.MICRTF.text = ""
//                self.micr = nil
//                self.bankName = nil
//                self.branch = nil
//                self.IFSC = nil
//                self.isIFSCVerified = false
//            }
//        }
//        
//        // Validate account number and confirm account number
//        if textField == AccountNumberTF || textField == ConfirmAccountNumberTF {
//            if let accountNumber = AccountNumberTF.text, let confirmNumber = ConfirmAccountNumberTF.text {
//                
//                if confirmNumber == accountNumber, !accountNumber.isEmpty {
//                    SubmitBtn.isEnabled = true
//                    IFSCTF.isEnabled = true
//                } else {
//                    IFSCTF.isEnabled = false
//                }
//            }
//        }
//        
//        // Also validate IFSC on the fly for MICR enabling
//        if textField == IFSCTF {
//            if let ifscCode = IFSCTF.text, ifscCode.count == 11 && isIFSCVerified {
//                MICRTF.isEnabled = true
//            } else {
//                MICRTF.isEnabled = false
//            }
//        }
//    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        // ✅ Convert IFSC to uppercase automatically
        if textField == IFSCTF {
            textField.text = textField.text?.uppercased()
           
            
            // Validate IFSC when it reaches 11 characters
            if let ifscCode = IFSCTF.text, ifscCode.count == 11 {
                // Clear previous data while validating
                self.MICRTF.text = ""
                self.micr = nil
                self.bankName = nil
                self.branch = nil
                self.IFSC = nil
                self.isIFSCVerified = false
                self.MICRTF.isEnabled = false
                
                // Call validation API
                IFSCSearchWithoutBankName(ifscCode: ifscCode)
            } else if let ifscCode = IFSCTF.text, ifscCode.count < 11 && ifscCode.count > 0 {
                // If user deletes characters, clear the MICR field and reset verification flag
                self.MICRTF.text = ""
                self.micr = nil
                self.bankName = nil
                self.branch = nil
                self.IFSC = nil
                self.isIFSCVerified = false
                self.MICRTF.isEnabled = false
            } else if IFSCTF.text?.isEmpty == true {
                // Clear everything if field is empty
                self.MICRTF.text = ""
                self.micr = nil
                self.bankName = nil
                self.branch = nil
                self.IFSC = nil
                self.isIFSCVerified = false
                self.MICRTF.isEnabled = false
            }
        }
        
        // Validate account number and confirm account number
        if textField == AccountNumberTF || textField == ConfirmAccountNumberTF {
            if let accountNumber = AccountNumberTF.text, let confirmNumber = ConfirmAccountNumberTF.text {
                
                if confirmNumber == accountNumber, !accountNumber.isEmpty {
                    SubmitBtn.isEnabled = true
                    IFSCTF.isEnabled = true
                } else {
                    IFSCTF.isEnabled = false
                }
            }
        }
        
        // Also validate IFSC on the fly for MICR enabling
        if textField == IFSCTF {
            if let ifscCode = IFSCTF.text, ifscCode.count == 11 && isIFSCVerified {
                MICRTF.isEnabled = true
            } else {
                MICRTF.isEnabled = false
            }
        }
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
            
        }))
        
        alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { _ in
            
            self.isPennyDrop = "N"
            self.SaveTradingBankDPClientData(accountnumber: self.AccountNumberTF.text ?? "")
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
                                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "M",in: self.view) { success in
                                    if success {
                                        self.SaveTradingBankDPClientData(accountnumber: accountnumber)
                                    } else {
                                        print("Token generation failed.")
                                    }
                                }
                            }
                            
                        case "000000":
                            if self.isCAMS == "N" {
                                DispatchQueue.main.async {
                                    print("CAMS is N → Navigating to next page")
                                    self.navigateToNextPage()
                                }
                                return
                            }
                            
                            if self.rejection == "Rejection" {
                                // Navigate back immediately after success
                                DispatchQueue.main.async {
                                    self.navigateToNextPage()
                                }
                            } else if self.isPennyDrop == "N" && self.isDerivative == "N" || self.isPennyDrop == "Y" && self.isDerivative == "N" {
                                self.navigateToNextPage()
                            } else {
                                self.SIXTHAPI(userID: self.fetchedUserId ?? "")
                            }
                        case "000002":
                            DispatchQueue.main.async {
                                self.showPennyDropAlert()
                            }
                            
                        case "531009":
                            DispatchQueue.main.async {
                                if let errorMessage = jsonResponse["ErrorMessage"] as? String {
                                    
                                    let alert = UIAlertController(title: "Message", message: errorMessage, preferredStyle: .alert)
                                    
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                                        let storyboard = UIStoryboard(name: "ApplicationForm", bundle: nil)
                                        let vc = storyboard.instantiateViewController(identifier: "ApplicationFormVC") as? ApplicationFormVC
                                        
                                        self.navigationController?.pushViewController(vc! , animated: true)
                                    }))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                            
                        case "904000":
                            self.showAlert(message: errorMessage)
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
//                            if let bankList = jsonResponse["BankList"] as? [[String: Any]], !bankList.isEmpty {
//                                self.bankList = bankList
//                                
//                                
//                                if let firstBank = bankList.first {
//                                    // ✅ Safely assign values
//                                    self.micr = firstBank["MICR"] as? String
//                                    self.IFSC = firstBank["IFSC"] as? String
//                                    self.bankName = firstBank["BankName"] as? String
//                                    self.branch = firstBank["Branch"] as? String
//                                    
//                                    // ✅ Update textfields and labels
//                                    self.MICRTF.text = self.micr ?? ""
//                                    
//                                } else {
//                                    self.micr = nil
//                                    self.MICRTF.text = ""
//                                    
//                                }
//                                
//                                self.MICRTF.isEnabled = true
//                            } else {
//                                self.bankList = []
//                                self.MICRTF.text = ""
//                                
//                                self.MICRTF.isEnabled = true
//                            }
//                            print("API is running")
//                        }
//                        
//                    case "111111":
//                        DispatchQueue.main.async {
//
//                                            self.isIFSCVerified = false
//                                            self.MICRTF.text = ""
//                                            self.MICRTF.isEnabled = false
//
//                                            // SHOW ERROR IMMEDIATELY
//                                            self.showAlert(message: "Wrong IFSC Code")
//                                        }
////                        self.MICRTF.isEnabled = false
////                        self.showAlert(message: ErrorMessage ?? "failure")
////                        print("failure")
//                        
//                    default:
//                        print("Unhandled error code: \(errorCode)")
//                    }
//                }
//            case .failure(let error):
//                print("Login API call failed: \(error.localizedDescription)")
//            }
//        }
//    }
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
//                print("IFSCSearchWithoutBankName Response: \(jsonResponse)")
//                let errorMessage = jsonResponse["ErrorMessage"] as? String
//                if let errorCode = jsonResponse["ErrorCode"] as? String {
//                    switch errorCode {
//                        
//                    case "000000":
//                        DispatchQueue.main.async {
//                            if let bankList = jsonResponse["BankList"] as? [[String: Any]], !bankList.isEmpty {
//                                self.bankList = bankList
//                                
//                                if let firstBank = bankList.first {
//                                    // ✅ Safely assign values
//                                    self.micr = firstBank["MICR"] as? String
//                                    self.IFSC = firstBank["IFSC"] as? String
//                                    self.bankName = firstBank["BankName"] as? String
//                                    self.branch = firstBank["Branch"] as? String
//                                    
//                                    // ✅ Update textfields and labels
//                                    self.MICRTF.text = self.micr ?? ""
//                                    self.isIFSCVerified = true
//                                    self.MICRTF.isEnabled = true
//                                    
//                                    // Remove any existing error styling
//                                    self.IFSCTF.layer.borderColor = UIColor.appBorder.cgColor
//                                    self.IFSCTF.layer.borderWidth = 1
//                                }
//                            } else {
//                                self.bankList = []
//                                self.MICRTF.text = ""
//                                self.micr = nil
//                                self.IFSC = nil
//                                self.bankName = nil
//                                self.branch = nil
//                                self.isIFSCVerified = false
//                                self.MICRTF.isEnabled = false
//                            }
//                            print("API is running")
//                        }
//                        
//                    case "111111":
//                        DispatchQueue.main.async {
//                            self.isIFSCVerified = false
//                            self.MICRTF.text = ""
//                            self.micr = nil
//                            self.IFSC = nil
//                            self.bankName = nil
//                            self.branch = nil
//                            self.MICRTF.isEnabled = false
//                            
//                            // ✅ SHOW ALERT IMMEDIATELY WHEN WRONG IFSC CODE
//                            let wrongIFSCAlert = UIAlertController(
//                                title: "Invalid IFSC Code",
//                                message: "The IFSC code you entered is invalid. Please check and enter a valid IFSC code.",
//                                preferredStyle: .alert
//                            )
//                            wrongIFSCAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
//                                // Optional: Clear the IFSC field or keep it
//                                // self.IFSCTF.text = ""
//                            })
//                            self.present(wrongIFSCAlert, animated: true)
//                            
//                            // Add red border to show error visually
//                            self.IFSCTF.layer.borderColor = UIColor.red.cgColor
//                            self.IFSCTF.layer.borderWidth = 1
//                        }
//                        
//                    default:
//                        DispatchQueue.main.async {
//                            self.isIFSCVerified = false
//                            self.MICRTF.text = ""
//                            self.micr = nil
//                            self.IFSC = nil
//                            self.bankName = nil
//                            self.branch = nil
//                            self.MICRTF.isEnabled = false
//                            
//                            // Show alert for other errors
//                            let errorAlert = UIAlertController(
//                                title: "Error",
//                                message: errorMessage ?? "Invalid IFSC code. Please try again.",
//                                preferredStyle: .alert
//                            )
//                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
//                            self.present(errorAlert, animated: true)
//                            
//                            self.IFSCTF.layer.borderColor = UIColor.red.cgColor
//                            self.IFSCTF.layer.borderWidth = 1
//                        }
//                        print("Unhandled error code: \(errorCode)")
//                    }
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self.isIFSCVerified = false
//                    let errorAlert = UIAlertController(
//                        title: "Network Error",
//                        message: "Failed to verify IFSC code. Please check your connection and try again.",
//                        preferredStyle: .alert
//                    )
//                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
//                    self.present(errorAlert, animated: true)
//                }
//                print("API call failed: \(error.localizedDescription)")
//            }
//        }
//    }
    
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
                print("IFSCSearchWithoutBankName Response: \(jsonResponse)")
                let errorMessage = jsonResponse["ErrorMessage"] as? String
                
                // ✅ IMPORTANT: Check if BankList exists and is not empty
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                        
                    case "000000":
                        DispatchQueue.main.async {
                            // ✅ Check if BankList exists and has data
                            if let bankList = jsonResponse["BankList"] as? [[String: Any]], !bankList.isEmpty {
                                self.bankList = bankList
                                
                                if let firstBank = bankList.first {
                                    // ✅ Safely assign values
                                    self.micr = firstBank["MICR"] as? String
                                    self.IFSC = firstBank["IFSC"] as? String
                                    self.bankName = firstBank["BankName"] as? String
                                    self.branch = firstBank["Branch"] as? String
                                    
                                    // ✅ Update textfields and labels
                                    self.MICRTF.text = self.micr ?? ""
                                    self.isIFSCVerified = true
                                    self.MICRTF.isEnabled = true
                                    
                                   
                                }
                            } else {
                                // ❌ BankList is empty - This means IFSC is invalid
                                self.handleInvalidIFSC()
                            }
                        }
                        
                    case "111111":
                        DispatchQueue.main.async {
                            self.handleInvalidIFSC()
                        }
                        
                    default:
                        DispatchQueue.main.async {
                            self.handleInvalidIFSC(errorMessage: errorMessage ?? "Invalid IFSC code. Please try again.")
                        }
                        print("Unhandled error code: \(errorCode)")
                    }
                } else {
                    // ❌ No ErrorCode in response
                    DispatchQueue.main.async {
                        self.handleInvalidIFSC(errorMessage: "Invalid IFSC code format")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isIFSCVerified = false
                    let errorAlert = UIAlertController(
                        title: "Network Error",
                        message: "Failed to verify IFSC code. Please check your connection and try again.",
                        preferredStyle: .alert
                    )
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(errorAlert, animated: true)
                }
                print("API call failed: \(error.localizedDescription)")
            }
        }
    }

    // ✅ Helper method to handle invalid IFSC
    func handleInvalidIFSC(errorMessage: String = "The IFSC code you entered is invalid. Please check and enter a valid IFSC code.") {
        self.isIFSCVerified = false
        self.MICRTF.text = ""
        self.micr = nil
        self.IFSC = nil
        self.bankName = nil
        self.branch = nil
        self.MICRTF.isEnabled = false
        
        // ✅ SHOW ALERT IMMEDIATELY FOR INVALID IFSC
        let invalidIFSCAlert = UIAlertController(
            title: "Invalid IFSC Code",
            message: errorMessage,
            preferredStyle: .alert
        )
        invalidIFSCAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            // Keep the IFSC code so user can correct it
            // Optionally you can clear it: self.IFSCTF.text = ""
        })
        self.present(invalidIFSCAlert, animated: true)
        
        // Add red border to show error visually
//        self.IFSCTF.layer.borderColor = UIColor.red.cgColor
//        self.IFSCTF.layer.borderWidth = 1
        
        print("❌ Invalid IFSC detected and handled")
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
                            DispatchQueue.main.async {
                                self.panNo = jsonResponse["PanNo"] as? String
                                self.regId = jsonResponse["RegId"] as? String
                                self.PANName = jsonResponse["PANName"] as? String
                                self.EmailId = jsonResponse["EmailId"] as? String
                                self.isDerivative = jsonResponse["IsDerivative"] as? String
                                self.consent = jsonResponse["IsConsentSubmitted"] as? String
                                self.camsClickCount = jsonResponse["CAMSClickCount"] as? String ?? ""
                                self.isPennyDropSixth = jsonResponse["IsPennyDrop"] as? String ?? ""
                                self.isGetDocumentsFromCAMS = jsonResponse["IsGetDocumentsFromCAMS"] as? String
                                self.CAMSfipid = jsonResponse["CAMSBankNameForfipid"] as? String
                                
                                self.updateSixth()
                                
                                print("Final → connectToCams.isHidden = \(self.connectToCams.isHidden)")
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
    
    func updateSixth() {
        self.connectToCams.isHidden = true
        if (self.isPennyDropSixth ?? "").isEmpty &&
            self.isDerivative == "Y" &&
            (self.camsClickCount ?? "").isEmpty &&
            self.consent == "N" {
            
            self.connectToCams.isHidden = true
            print("🔴 Button hidden due to empty PennyDrop + Derivative Y + Consent N + CAMSClickCount empty")
            return
        }
        
        // 🟢 CASE 1: Derivative = Y, PennyDrop = Y
        if self.isDerivative == "Y" {
            if self.camsClickCount == "" {
                if self.isGetDocumentsFromCAMS == "N", self.consent == "N" {
                    self.connectToCams.isHidden = false  // ✅ Show button
                }
            } else if self.camsClickCount == "1" {
                if self.isGetDocumentsFromCAMS == "N", self.consent == "N" {
                    self.connectToCams.isHidden = false
                } else if self.isGetDocumentsFromCAMS == "Y", self.consent == "Y" {
                    self.connectToCams.isHidden = true
                }
            } else if let clickCount = self.camsClickCount,
                      let clickInt = Int(clickCount), clickInt < 2 {
                self.connectToCams.isHidden = true
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
                                        self.showAlert(message: "Token refresh failed. Please try again.")
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
                
            }
            
            // Update the account number and labels if available
            if let accountNumber = response["BankAccountNumber"] as? String {
                
                AccountNumberTF.text = accountNumber
                ConfirmAccountNumberTF.text = accountNumber
                
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
                connectToCams.isHidden = true
                AccountNumberTF.isEnabled = true
                ConfirmAccountNumberTF.isEnabled = true
                IFSCTF.isEnabled = true
                MICRTF.isEnabled = true
                
            } else {
                // Disable text fields as per the previous logic
                AccountNumberTF.isEnabled = false
                ConfirmAccountNumberTF.isEnabled = false
                IFSCTF.isEnabled = false
                MICRTF.isEnabled = false
                
                SubmitBtn.isEnabled = false
                SubmitBtn.alpha = 0.5// Enable the submit button to navigate to the next page
            } // Enable the submit button to navigate to the next page
            
        } else {
            // If "IsPennyDropDone" is not "N" (or it's missing), skip updating the UI
            print("Penny drop is not done or data is missing. Skipping UI update.")
        }
    }
    
    func navigateToNextPage() {
        if rejection == "Rejection" {
            print("Rejection detected. Popping out the current screen.")
            delegate?.reloadPageData()
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        // Navigate to NomineeDetailsVC if no rejection
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
}

//extension BankVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filteredBankList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "micrTVC", for: indexPath) as! micrTVC
//        let bank = filteredBankList[indexPath.row]
//        cell.micrCode.text = bank["MICR"] as? String ?? ""
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let bank = filteredBankList[indexPath.row]
//
//        self.micr = bank["MICR"] as? String
//        self.IFSC = bank["IFSC"] as? String
//        self.bankName = bank["BankName"] as? String
//        self.branch = bank["Branch"] as? String
//
//        self.MICRTF.text = self.micr
//        self.bankNamelbl.text = "\(self.bankName ?? "")\n\(self.branch ?? "")"
//
//        micrTableView.isHidden = true
//    }
//}


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
//    //       @objc func confirmAccountBtnTapped() {
//    //           // Check if the exclamation mark image is displayed on the ConfirmAccountBtn
//    //           if let currentImage = ConfirmAccountNumberTF.image(for: .normal),
//    //              currentImage == UIImage(systemName: "exclamationmark.circle.fill") {
//    //               // Show alert for account number mismatch
//    //               showAlert(message: "Account numbers do not match. Please re-enter the same account number.")
//    //           }
//    //       }
//
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
//            //                   if let upiID = upiIDTF.text, !upiID.isEmpty {
//            //                       guard isUPIValid() else {
//            //                           showAlert(message: "Please enter a valid UPI ID.")
//            //                           return
//            //                       }
//            //                   }
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
//            //                   if let upiID = upiIDTF.text, !upiID.isEmpty {
//            //                       guard isUPIValid() else {
//            //                           showAlert(message: "Please enter a valid UPI ID.")
//            //                           return
//            //                       }
//            //                   }
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
//        self.navigationController?.popToRootViewController(animated: true)
//    }
//
//    @IBAction func BackBtn(_ sender: UIButton) {
//        delegate?.reloadPageData()
//            self.navigationController?.popViewController(animated: true)
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
//        if textField == AccountNumberTF || textField == ConfirmAccountNumberTF {
//            if let accountNumber = AccountNumberTF.text, let confirmNumber = ConfirmAccountNumberTF.text {
//
//                let exclamationImage = UIImage(systemName: "exclamationmark.circle.fill")
//                let checkmarkImage = UIImage(systemName: "checkmark.circle.fill")
//
//                // If the account numbers match
//                //                       if confirmNumber == accountNumber, !accountNumber.isEmpty {
//                //                           AcountNumberLabel.text = accountNumber
//                //                           ConfirmAccountBtn.setImage(checkmarkImage, for: .normal)
//                //                           ConfirmAccountBtn.tintColor = .green
//                //                           AccountBtn.setImage(checkmarkImage, for: .normal)
//                //                           AccountBtn.tintColor = .green
//                //                           ConfirmAccountBtn.isHidden = false
//                //                           AccountBtn.isHidden = false
//                //                           SubmitBtn.isEnabled = true
//                //                           IFSCTF.isEnabled = true
//                //                       } else {
//                //                           // If the account numbers don't match, show the exclamation mark
//                //                           ConfirmAccountBtn.setImage(exclamationImage, for: .normal)
//                //                           ConfirmAccountBtn.tintColor = .red
//                //                           ConfirmAccountBtn.isHidden = false
//                //                           AccountBtn.isHidden = true
//                //                           IFSCTF.isEnabled = false
//                //                       }
//            }
//        }
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
//        //           if textField == upiIDTF {
//        //               if validateUPIID(upiID: upiIDTF.text ?? "") {
//        //                   // UPI ID is valid
//        //                   SubmitBtn.isEnabled = isAccountNumberValid() && isIFSCValid()
//        //               } else if upiIDTF.text?.isEmpty ?? true {
//        //                   // Allow empty UPI ID
//        //                   SubmitBtn.isEnabled = isAccountNumberValid() && isIFSCValid()
//        //               } else {
//        //                   // If UPI ID is invalid, disable Submit button
//        //                   //SubmitBtn.isEnabled = false
//        //               }
//        //           }
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
//    //       func isUPIValid() -> Bool {
//    //           return validateUPIID(upiID: upiIDTF.text ?? "")
//    //       }
//
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
//        let alert = UIAlertController(title: "Alert", message: "Bank account could not be verified. Proceed with the same bank account or provide another account details.", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//            // Keep IsPennyDrop as "Y"
//        }))
//
//        alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { _ in
//            // Change IsPennyDrop to "N"
//            self.isPennyDrop = "N"
//            self.SaveTradingBankDPClientData(accountnumber: self.AccountNumberTF.text ?? "")
//            //self.navigateToNextPage()
//
//        }))
//
//        self.present(alert, animated: true, completion: nil)
//    }
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
//            guard let panNumber = self.panNo, !panNumber.isEmpty else {
//                   print("❌ PAN Number is missing from UserDefaults")
//                   return
//               }
//
//            let parameters: [String: Any?] = [
//                "BankName": bankName,
//                "MICRCode": micr,
//                "BrokeragePlanEquityName": "",
//                "IFSCCode": IFSC,
//                "PanNo": panNumber,
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
//            apiCall(url: Url, method: "POST", parameters: parameters as [String: Any], view: self.view,loaderText: "We are verifying your Bank Details, kindly wait...") { result in
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
//                                self.navigateToNextPage()
//                                print("API is running")
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
////        if rejection == "Rejection" {
////            print("Rejection detected. Popping out the current screen.")
////            delegate?.reloadPageData()
////            self.navigationController?.popViewController(animated: true)
////            return
////        }
//
//        // Navigate to NomineeDetailsVC if no rejection
//        //           let storyboard = UIStoryboard(name: "Nominee", bundle: nil)
//        //           if let nextVC = storyboard.instantiateViewController(withIdentifier: "NomineeDetailsVC") as? NomineeDetailsVC {
//        //               nextVC.PanNo = panNo
//        //               nextVC.RegId = regId
//        //               nextVC.delegate = self
//        //               self.navigationController?.pushViewController(nextVC, animated: true)
//        let storyboard = UIStoryboard(name: "OtherDetails", bundle: Bundle.module)
//        let vc = storyboard.instantiateViewController(identifier: "OtherDetailsVC") as! OtherDetailsVC
//        vc.panNo = self.panNo
//        vc.regId = self.regId
//        vc.delegate = self
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
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
//                                //  self.holderview2.isHidden = false
//                                // Update the UI
//                                self.MICRTF.text = self.micr
//                                //                                               self.bankNamelbl.text = "\(self.bankName ?? "No bank name found")\n\(self.branch ?? "No branch name found")"
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
//                    entityName: "TokenMobile", deviceType: "M", in: self.view
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
//                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "M",in: self.view) { success in
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
//            guard let panNumber = self.panNo, !panNumber.isEmpty else {
//                             print("❌ PAN Number is missing from UserDefaults")
//                             return
//                         }
//            let parameters: [String: Any?] = [
//                "UserId":  fetchedUserId,
//                "TokenId": tokenId,
//                "RegId": regId,
//                "PanNo": panNumber,
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
//                // self.bankNamelbl.text = "\(bankName)\n\(branch)"
//                // self.holderview2.isHidden = false
//            }
//
//            // Update the account number and labels if available
//            if let accountNumber = response["BankAccountNumber"] as? String {
//                // AcountNumberLabel.text = accountNumber
//                AccountNumberTF.text = accountNumber
//                ConfirmAccountNumberTF.text = accountNumber
//                //                   let checkmarkImage = UIImage(systemName: "checkmark.circle.fill")
//                //                   ConfirmAccountBtn.setImage(checkmarkImage, for: .normal)
//                //                   ConfirmAccountBtn.tintColor = .green
//                //                   AccountBtn.setImage(checkmarkImage, for: .normal)
//                //                   AccountBtn.tintColor = .green
//                //                   ConfirmAccountBtn.isHidden = false
//                //                   AccountBtn.isHidden = false
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
//            //               if let upiID = response["UPIID"] as? String {
//            //                   upiIDTF.text = upiID
//            //                   //self.upi
//            //               }
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
//                // upiIDTF.isEnabled = true
//            } else {
//                // Disable text fields as per the previous logic
//                AccountNumberTF.isEnabled = false
//                ConfirmAccountNumberTF.isEnabled = false
//                IFSCTF.isEnabled = false
//                MICRTF.isEnabled = false
//                //  upiIDTF.isEnabled = false
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
////
//  //    private func fetchUserId() {
//  //        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
//  //            guard let self = self else { return }
//  //
//  //            if let userId = userId, let sessionID = sessionID {
//  //                self.fetchedUserId = userId
//  //                self.fetchedSessionID = sessionID
//  //                self.mobiledecodeArray = decodeByteArrayString
//  //                print("UserID: \(userId), SessionID: \(sessionID)")
//  //                self.ValidateToken()
//  //            } else {
//  //                print("No UserID or SessionID found.")
//  //            }
//  //        }
//  //    }
//  //
//  //    @IBAction func SubmitBtn(_ sender: Any) {
//  //        print("Submit button tapped")
//  //
//  //        // Step 1: Check if rejection has value "Rejection"
//  //        if rejection == "Rejection" {
//  //            print("Rejection case detected. Performing all validations.")
//  //
//  //            // Perform all validations
//  //            guard let accountNumber = AccountNumberTF.text, accountNumber.count >= 9 else {
//  //                showAlert(message: "Please enter a valid account number with at least 9 digits.")
//  //                return
//  //            }
//  //
//  //            guard isAccountNumberValid() else {
//  //                showAlert(message: "Account numbers do not match. Please ensure both account numbers are the same.")
//  //                return
//  //            }
//  //
//  //            guard isIFSCValid() else {
//  //                showAlert(message: "Please enter a valid IFSC code.")
//  //                return
//  //            }
//  //
//  //            guard isMICRValid() else {
//  //                showAlert(message: "Please enter MICR code.")
//  //                return
//  //            }
//  //
//  ////            if let upiID = upiIDTF.text, !upiID.isEmpty {
//  ////                guard isUPIValid() else {
//  ////                    showAlert(message: "Please enter a valid UPI ID.")
//  ////                    return
//  ////                }
//  ////            }
//  //
//  //            // If all validations pass, call the API
//  //            print("All validations passed for rejection case, calling API")
//  //            SaveTradingBankDPClientData(accountnumber: AccountNumberTF.text!)
//  //            return
//  //        }
//  //
//  //        // Step 2: Handle the fresh case (Penny Drop logic)
//  //        if isPennyDrop.isEmpty {
//  //            print("Penny drop is done. Navigating to the next page.")
//  //            navigateToNextPage()
//  //        } else {
//  //            print("Fresh case detected. Performing validations.")
//  //
//  //            // Perform all validations
//  //            guard let accountNumber = AccountNumberTF.text, accountNumber.count >= 9 else {
//  //                showAlert(message: "Please enter a valid account number with at least 9 digits.")
//  //                return
//  //            }
//  //
//  //            guard isAccountNumberValid() else {
//  //                showAlert(message: "Account numbers do not match. Please ensure both account numbers are the same.")
//  //                return
//  //            }
//  //
//  //            guard isIFSCValid() else {
//  //                showAlert(message: "Please enter a valid IFSC code.")
//  //                return
//  //            }
//  //
//  //            guard isMICRValid() else {
//  //                showAlert(message: "Please enter MICR code.")
//  //                return
//  //            }
//  //
//  //            //                        if let upiID = upiIDTF.text, !upiID.isEmpty {
//  //            //                            guard isUPIValid() else {
//  //            //                                showAlert(message: "Please enter a valid UPI ID.")
//  //            //                                return
//  //            //                            }
//  //            //                        }
//  //
//  //            // If all validations pass, call the API
//  //            print("All validations passed for fresh case, calling API")
//  //            SaveTradingBankDPClientData(accountnumber: AccountNumberTF.text!)
//  //        }
//  //    }
//  //
//  //    func showAlert(message: String) {
//  //        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
//  //        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//  //        self.present(alert, animated: true, completion: nil)
//  //    }
//  //
//  //    @IBAction func homeBtn(_ sender: UIButton) {
//  //        // self.navigationController?.popToRootViewController(animated: true)
//  //    }
//  //
//  //    @IBAction func BackBtn(_ sender: UIButton) {
//  //        delegate?.reloadPageData()
//  //
//  //        //          let vc = ApplicationFormVC()
//  //        //          vc.panNo = panNo
//  //        //          vc.regId = regId
//  //        //          vc.PANName = PANName
//  //        //          vc.EmailId = EmailId
//  //
//  //        navigationController?.popViewController(animated: true)
//  //    }
//  //
//  //    // MARK: - UITextFieldDelegate
//  //
//  //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//  //        let allowedCharacterSet: CharacterSet
//  //
//  //        // Allow only digits for AccountNumberTF and ConfirmAccountNumberTF
//  //        if textField == AccountNumberTF || textField == ConfirmAccountNumberTF {
//  //            allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
//  //            if string.rangeOfCharacter(from: allowedCharacterSet.inverted) != nil {
//  //                return false
//  //            }
//  //
//  //            let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
//  //            return currentText.count < 18 // Limit to 9 digits
//  //        }
//  //
//  //        // Allow alphanumeric for IFSCTF
//  //        if textField == IFSCTF {
//  //            allowedCharacterSet = CharacterSet.alphanumerics
//  //            if string.rangeOfCharacter(from: allowedCharacterSet.inverted) != nil {
//  //                return false
//  //            }
//  //
//  //            let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
//  //            return currentText.count <= 11 // Limit to 11 characters
//  //        }
//  //        if textField == MICRTF {
//  //            // Check if the replacement string is numeric
//  //            let allowedCharacters = CharacterSet.decimalDigits
//  //            let characterSet = CharacterSet(charactersIn: string)
//  //            if !allowedCharacters.isSuperset(of: characterSet) {
//  //                showAlert(message: "Please enter numbers only")
//  //                return false
//  //            }
//  //
//  //            // Check if the total character count will exceed 9
//  //            let currentText = textField.text ?? ""
//  //            let newLength = currentText.count + string.count - range.length
//  //            if newLength > 9 {
//  //                showAlert(message: "Only 9 digits are allowed")
//  //                return false
//  //            }
//  //        }
//  //
//  //        // Allow any character for UPI ID
//  //        return true
//  //    }
//  //
//  //    @objc func textFieldDidChange(_ textField: UITextField) {
//  //        // Validate account number and confirm account number
//  //        //        if textField == AccountNumberTF || textField == ConfirmAccountNumberTF {
//  //        //                if let accountNumber = AccountNumberTF.text, let confirmNumber = ConfirmAccountNumberTF.text {
//  //        //
//  //        //                    let exclamationImage = UIImage(systemName: "exclamationmark.circle.fill")
//  //        //                    let checkmarkImage = UIImage(systemName: "checkmark.circle.fill")
//  //        //
//  //        //                    // If the account numbers match
//  //        //                    if confirmNumber == accountNumber, !accountNumber.isEmpty {
//  //        //                        AcountNumberLabel.text = accountNumber
//  //        //                        ConfirmAccountBtn.setImage(checkmarkImage, for: .normal)
//  //        //                        ConfirmAccountBtn.tintColor = .green
//  //        //                        AccountBtn.setImage(checkmarkImage, for: .normal)
//  //        //                        AccountBtn.tintColor = .green
//  //        //                        ConfirmAccountBtn.isHidden = false
//  //        //                        AccountBtn.isHidden = false
//  //        //                        SubmitBtn.isEnabled = true
//  //        //                        IFSCTF.isEnabled = true
//  //        //                    } else {
//  //        //                        // If the account numbers don't match, show the exclamation mark
//  //        //                        ConfirmAccountBtn.setImage(exclamationImage, for: .normal)
//  //        //                        ConfirmAccountBtn.tintColor = .red
//  //        //                        ConfirmAccountBtn.isHidden = false
//  //        //                        AccountBtn.isHidden = true
//  //        //                        IFSCTF.isEnabled = false
//  //        //                    }
//  //        //                }
//  //        //            }
//  //
//  //        // Validate IFSC code
//  //        if textField == IFSCTF {
//  //            if let ifscCode = IFSCTF.text, ifscCode.count == 11 {
//  //                // Call the IFSC search method
//  //                IFSCSearchWithoutBankName(ifscCode: ifscCode)
//  //            }
//  //        }
//  //
//  //        // Validate UPI ID
//  //        //        if textField == upiIDTF {
//  //        //            if validateUPIID(upiID: upiIDTF.text ?? "") {
//  //        //                // UPI ID is valid
//  //        //                SubmitBtn.isEnabled = isAccountNumberValid() && isIFSCValid()
//  //        //            } else if upiIDTF.text?.isEmpty ?? true {
//  //        //                // Allow empty UPI ID
//  //        //                SubmitBtn.isEnabled = isAccountNumberValid() && isIFSCValid()
//  //        //            } else {
//  //        //                // If UPI ID is invalid, disable Submit button
//  //        //                //SubmitBtn.isEnabled = false
//  //        //            }
//  //        //        }
//  //    }
//  //
//  //    func isAccountNumberValid() -> Bool {
//  //        guard let accountNumber = AccountNumberTF.text else { return false }
//  //        return accountNumber.count >= 9 && accountNumber == ConfirmAccountNumberTF.text
//  //    }
//  //
//  //    func isIFSCValid() -> Bool {
//  //        guard let ifscCode = IFSCTF.text else { return false }
//  //        return ifscCode.count == 11 // Further validation can be added here
//  //    }
//  //
//  //    func isMICRValid() -> Bool {
//  //        guard let ifscCode = MICRTF.text else { return false }
//  //        return ifscCode.count == 9 // Further validation can be added here
//  //    }
//  //
//  //    //    func isUPIValid() -> Bool {
//  //    //        return validateUPIID(upiID: upiIDTF.text ?? "")
//  //    //    }
//  //    //
//  //    func validateUPIID(upiID: String) -> Bool {
//  //        let upiRegex = "[A-Za-z0-9]+@[A-Za-z0-9]+"
//  //        let upiTest = NSPredicate(format: "SELF MATCHES %@", upiRegex)
//  //        return upiTest.evaluate(with: upiID)
//  //    }
//  //}
//  //
//  //
//  //extension BankVC{
//  //    func showErrorMessageAlert(message: String) {
//  //        showAlert(message: message) // Use the showAlert function to show the error message
//  //    }
//  //    func showPennyDropAlert() {
//  //                let alert = UIAlertController(title: "Alert", message: "Bank account could not be verified. Proceed with the same bank account or provide another account details.", preferredStyle: .alert)
//  //
//  //                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//  //                    // Keep IsPennyDrop as "Y"
//  //                }))
//  //
//  //                alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { _ in
//  //                    // Change IsPennyDrop to "N"
//  //                    self.isPennyDrop = "N"
//  //                    self.SaveTradingBankDPClientData(accountnumber: self.AccountNumberTF.text ?? "")
//  //                    //self.navigateToNextPage()
//  //
//  //                }))
//  //
//  //                self.present(alert, animated: true, completion: nil)
//  //            }
//  //
//  ////    func SaveTradingBankDPClientData(accountnumber: String) {
//  ////
//  ////        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//  ////            guard let tokenId = tokenId else {
//  ////                // Handle the case where no tokens are available
//  ////                CoreDataHelper.generateToken(
//  ////                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
//  ////                    USERID: self.fetchedUserId ?? "",
//  ////                    SessionId: self.fetchedSessionID ?? "",
//  ////                    entityName: "TokenMobile", deviceType: "M", in: self.view
//  ////                ) { success in
//  ////                    if success {
//  ////                        // Retry SIXTHAPI after token regeneration
//  ////                        self.SaveTradingBankDPClientData(accountnumber: accountnumber)
//  ////                    } else {
//  ////                        print("Token generation failed.")
//  ////                    }
//  ////                }
//  ////                print("No tokens available. Please reload the tokens.")
//  ////                return
//  ////            }
//  ////
//  ////            let savedPAN = UserDefaults.standard.string(forKey: "SavedPAN")
//  ////              let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : panNo
//  ////
//  ////            let parameters: [String: Any?] = [
//  ////                "BankName": bankName,
//  ////                "MICRCode": micr,
//  ////                "BrokeragePlanEquityName": "",
//  ////                "IFSCCode": IFSC,
//  ////                "PanNo": finalPAN,
//  ////                "PinCode": "",
//  ////                "BankBranchAddress": branch,
//  ////                "IsPennyDrop": isPennyDrop,
//  ////                "UserId": fetchedUserId,
//  ////                "UPI_ID": "",
//  ////                "DPScheme": "",
//  ////                "BranchName": branch,
//  ////                "TokenId": tokenId,
//  ////                "BrokeragePlanCommodityName": "",
//  ////                "RegId": regId,
//  ////                "BankAccountNumber": accountnumber
//  ////            ]
//  ////            print(parameters)
//  ////            let Url = "Client/SaveTradingBankDPClientData"
//  ////
//  ////            apiCall(url: Url, method: "POST", parameters: parameters as [String: Any], view: self.view,loaderText: "We are verifying your Bank Details, kindly wait...") { result in
//  ////                switch result {
//  ////                case .success(let jsonResponse):
//  ////                    print("SaveTradingBankDPClientData Response: \(jsonResponse)")
//  ////                    if let errorCode = jsonResponse["ErrorCode"] as? String, let errorMessage = jsonResponse["ErrorMessage"] as? String {
//  ////                        switch errorCode {
//  ////                        case "999992":
//  ////                            DispatchQueue.main.async {
//  ////                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
//  ////                                print("All TokenMobile entries deleted due to error code 999992")
//  ////                                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//  ////                                    if success {
//  ////                                        self.SaveTradingBankDPClientData(accountnumber: accountnumber)
//  ////                                    } else {
//  ////                                        print("Token generation failed.")
//  ////                                    }
//  ////                                }
//  ////                            }
//  ////                        case "000000":
//  ////                            DispatchQueue.main.async {
//  ////                                                 if self.rejection == "Rejection" {
//  ////                                                     // Pop back for rejection case
//  ////                                                     print("Rejection detected after successful API. Popping back.")
//  ////                                                     self.delegate?.reloadPageData()
//  ////                                                     self.navigationController?.popViewController(animated: true)
//  ////                                                 } else {
//  ////                                                     // Navigate to next page for normal success
//  ////                                                     print("API success. Navigating to next page.")
//  ////                                                     self.navigateToNextPage()
//  ////                                                 }
//  ////                                             }
//  ////                        case "000002":
//  ////                            DispatchQueue.main.async {
//  ////                                self.showPennyDropAlert()
//  ////                            }
//  ////                        case "531009":
//  ////                            DispatchQueue.main.async {
//  ////                                if let errorMessage = jsonResponse["ErrorMessage"] as? String {
//  ////                                    self.showErrorMessageAlert(message: errorMessage)
//  ////                                }
//  ////                            }
//  ////                        default:
//  ////                            print("Unhandled error code: \(errorCode)")
//  ////                        }
//  ////                    }
//  ////                case .failure(let error):
//  ////                    print("Login API call failed: \(error.localizedDescription)")
//  ////                }
//  ////            }
//  ////        }
//  ////    }
//  ////
//  //
//  //    func SaveTradingBankDPClientData(accountnumber: String) {
//  //
//  //        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//  //            guard let tokenId = tokenId else {
//  //                // Handle the case where no tokens are available
//  //                CoreDataHelper.generateToken(
//  //                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
//  //                    USERID: self.fetchedUserId ?? "",
//  //                    SessionId: self.fetchedSessionID ?? "",
//  //                    entityName: "TokenMobile", deviceType: "M", in: self.view
//  //                ) { success in
//  //                    if success {
//  //                        // Retry SIXTHAPI after token regeneration
//  //                        self.SaveTradingBankDPClientData(accountnumber: accountnumber)
//  //                    } else {
//  //                        print("Token generation failed.")
//  //                    }
//  //                }
//  //                print("No tokens available. Please reload the tokens.")
//  //                return
//  //            }
//  //
//  //            let savedPAN = UserDefaults.standard.string(forKey: "SavedPAN")
//  //            let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : panNo
//  //
//  //            let parameters: [String: Any?] = [
//  //                "BankName": bankName,
//  //                "MICRCode": micr,
//  //                "BrokeragePlanEquityName": "",
//  //                "IFSCCode": IFSC,
//  //                "PanNo": finalPAN,
//  //                "PinCode": "",
//  //                "BankBranchAddress": branch,
//  //                "IsPennyDrop": isPennyDrop,
//  //                "UserId": fetchedUserId,
//  //                "UPI_ID": "",
//  //                "DPScheme": "",
//  //                "BranchName": branch,
//  //                "TokenId": tokenId,
//  //                "BrokeragePlanCommodityName": "",
//  //                "RegId": regId,
//  //                "BankAccountNumber": accountnumber
//  //            ]
//  //            print(parameters)
//  //            let Url = "Client/SaveTradingBankDPClientData"
//  //
//  //            apiCall(url: Url, method: "POST", parameters: parameters as [String: Any], view: self.view, loaderText: "We are verifying your Bank Details, kindly wait...") { result in
//  //                switch result {
//  //                case .success(let jsonResponse):
//  //                    print("SaveTradingBankDPClientData Response: \(jsonResponse)")
//  //                    if let errorCode = jsonResponse["ErrorCode"] as? String, let errorMessage = jsonResponse["ErrorMessage"] as? String {
//  //                        switch errorCode {
//  //                        case "999992":
//  //                            DispatchQueue.main.async {
//  //                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
//  //                                print("All TokenMobile entries deleted due to error code 999992")
//  //                                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//  //                                    if success {
//  //                                        self.SaveTradingBankDPClientData(accountnumber: accountnumber)
//  //                                    } else {
//  //                                        print("Token generation failed.")
//  //                                    }
//  //                                }
//  //                            }
//  //                        case "000000":
//  //                            DispatchQueue.main.async {
//  //                                // Add debug print to check the rejection value
//  //                                print("🔍 Rejection value before decision: \(self.rejection ?? "nil")")
//  //
//  //                                if self.rejection == "Rejection" {
//  //                                    // Pop back for rejection case
//  //                                    print("Rejection detected after successful API. Popping back.")
//  //                                    self.delegate?.reloadPageData()
//  //                                    self.navigationController?.popViewController(animated: true)
//  //                                } else {
//  //                                    // Navigate to next page for normal success
//  //                                    print("API success. Navigating to next page.")
//  //                                    self.navigateToNextPage()
//  //                                }
//  //                            }
//  //                        case "000002":
//  //                            DispatchQueue.main.async {
//  //                                self.showPennyDropAlert()
//  //                            }
//  //                        case "531009":
//  //                            DispatchQueue.main.async {
//  //                                if let errorMessage = jsonResponse["ErrorMessage"] as? String {
//  //                                    self.showErrorMessageAlert(message: errorMessage)
//  //                                }
//  //                            }
//  //                        default:
//  //                            print("Unhandled error code: \(errorCode)")
//  //                        }
//  //                    }
//  //                case .failure(let error):
//  //                    print("Login API call failed: \(error.localizedDescription)")
//  //                }
//  //            }
//  //        }
//  //    }
//  //
//  //    func navigateToNextPage() {
//  //        print("➡️ navigateToNextPage called")
//  //        let storyboard = UIStoryboard(name: "OtherDetails", bundle: Bundle.module)
//  //        let vc = storyboard.instantiateViewController(identifier: "OtherDetailsVC") as! OtherDetailsVC
//  //        vc.panNo = self.panNo
//  //        vc.regId = self.regId
//  //        self.navigationController?.pushViewController(vc, animated: true)
//  //    }
//  //
//  //
//  //
//  ////    func navigateToNextPage() {
//  ////        //        if rejection == "Rejection" {
//  ////        //            print("Rejection detected. Popping out the current screen.")
//  ////        //            delegate?.reloadPageData()
//  ////        //            self.navigationController?.popViewController(animated: true)
//  ////        //            return
//  ////        //        }
//  ////
//  ////        if let rejection = rejection, rejection == "Rejection" {
//  ////            delegate?.reloadPageData()
//  ////            self.navigationController?.popViewController(animated: true)
//  ////            return
//  ////        }
//  ////
//  ////        // Navigate to NomineeDetailsVC if no rejection
//  ////        let storyboard = UIStoryboard(name: "OtherDetails", bundle: Bundle.module)
//  ////        let vc = storyboard.instantiateViewController(identifier: "OtherDetailsVC") as! OtherDetailsVC
//  ////        vc.panNo = self.panNo
//  ////        vc.regId = self.regId
//  ////        vc.delegate = self
//  ////        self.navigationController?.pushViewController(vc, animated: true)
//  ////    }
//  //
//  ////    func navigateToNextPage() {
//  ////
//  ////        print("Rejection: \(rejection ?? "nil")")
//  ////        print("isPennyDrop: \(isPennyDrop)")
//  ////
//  ////        // ✅ ONLY handle rejection here
//  ////        if rejection == "Rejection" {
//  ////            print("🔙 Rejection flow → Going back")
//  ////            delegate?.reloadPageData()
//  ////            self.navigationController?.popViewController(animated: true)
//  ////            return
//  ////        }
//  ////
//  ////        // ✅ ALL other cases → go forward (penny drop success/fail doesn't matter)
//  ////        print("➡️ Normal flow → Going to next page")
//  ////
//  ////        let storyboard = UIStoryboard(name: "OtherDetails", bundle: Bundle.module)
//  ////        let vc = storyboard.instantiateViewController(identifier: "OtherDetailsVC") as! OtherDetailsVC
//  ////        vc.panNo = self.panNo
//  ////        vc.regId = self.regId
//  ////        vc.delegate = self
//  ////        self.navigationController?.pushViewController(vc, animated: true)
//  ////    }
//  //
//  //    func IFSCSearchWithoutBankName(ifscCode: String) {
//  //        let parameters: [String: Any?] = [
//  //            "BankName": "",
//  //            "IFSC": ifscCode,
//  //        ]
//  //        print(parameters)
//  //        let Url = "BankManagement/IFSCSearchWithoutBankName"
//  //
//  //        apiCall(url: Url, method: "POST", parameters: parameters as [String: Any], view: self.view) { result in
//  //            switch result {
//  //            case .success(let jsonResponse):
//  //                print("ViewOtherData Response: \(jsonResponse)")
//  //                let ErrorMessage = jsonResponse["ErrorMessage"] as? String
//  //                if let errorCode = jsonResponse["ErrorCode"] as? String {
//  //                    switch errorCode {
//  //
//  //                    case "000000":
//  //                        DispatchQueue.main.async {
//  //                            if let bankList = jsonResponse["BankList"] as? [[String: Any]],!bankList.isEmpty,
//  //                               let firstBank = bankList.first {
//  //                                // Update the properties
//  //                                self.micr = firstBank["MICR"] as? String
//  //                                self.IFSC = firstBank["IFSC"] as? String
//  //                                self.bankName = firstBank["BankName"] as? String
//  //                                self.branch = firstBank["Branch"] as? String
//  //                                //self.holderview2.isHidden = false
//  //                                // Update the UI
//  //                                self.MICRTF.text = self.micr
//  //                                //                                            self.bankNamelbl.text = "\(self.bankName ?? "No bank name found")\n\(self.branch ?? "No branch name found")"
//  //                                self.MICRTF.isEnabled = false
//  //                            }else{
//  //                                self.MICRTF.isEnabled = false
//  //                                self.micr = nil
//  //                                self.IFSC = nil
//  //                                self.bankName = nil
//  //                                self.branch = nil
//  //                                self.MICRTF.text = nil
//  //                                // self.bankNamelbl.text = nil
//  //                                self.MICRTF.isEnabled = true
//  //                            }
//  //                            print("API is running")
//  //                        }
//  //                    case "111111":
//  //                        self.MICRTF.isEnabled = false
//  //                        self.showAlert(message: ErrorMessage ?? "failure")
//  //                        print("failure")
//  //                    default:
//  //                        print("Unhandled error code: \(errorCode)")
//  //                    }
//  //                }
//  //            case .failure(let error):
//  //                print("Login API call failed: \(error.localizedDescription)")
//  //            }
//  //        }
//  //    }
//  //    func ValidateToken(){
//  //
//  //        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//  //            guard let tokenId = tokenId else {
//  //                // Handle the case where no tokens are available
//  //                CoreDataHelper.generateToken(
//  //                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
//  //                    USERID: self.fetchedUserId ?? "",
//  //                    SessionId: self.fetchedSessionID ?? "",
//  //                    entityName: "TokenMobile", deviceType: "W", in: self.view
//  //                ) { success in
//  //                    if success {
//  //                        // Retry SIXTHAPI after token regeneration
//  //                        self.ValidateToken()
//  //                    } else {
//  //                        print("Token generation failed.")
//  //                    }
//  //                }
//  //                print("No tokens available. Please reload the tokens.")
//  //                return
//  //            }
//  //            let parameters: [String: Any?] = [
//  //                "UserId":  fetchedUserId,
//  //                "TokenId": tokenId
//  //            ]
//  //            print(parameters)
//  //            let Url = "TokenAuthentication/ValidateToken"
//  //
//  //            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
//  //                switch result {
//  //                case .success(let jsonResponse):
//  //                    print("ValidateToken Response: \(jsonResponse)")
//  //                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//  //                        switch errorCode {
//  //                        case "000000":
//  //                            DispatchQueue.main.async {
//  //                                print("api is running")
//  //                                self.ViewTradingBankDPClientData()
//  //                            }
//  //                        default:
//  //                            print("Unhandled error code: \(errorCode)")
//  //                        }
//  //                    }
//  //                case .failure(let error):
//  //                    print("Login API call failed: \(error.localizedDescription)")
//  //                }
//  //            }
//  //        }
//  //    }
//  //
//  //    func ViewTradingBankDPClientData(){
//  //
//  //        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//  //            guard let tokenId = tokenId else {
//  //                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//  //                    if success {
//  //                        // Call SIXTHAPI after tokenMobile API call is successful
//  //                        self.ViewTradingBankDPClientData()
//  //                    } else {
//  //                        print("Token generation failed.")
//  //                    }
//  //                }
//  //                print("No tokens available. Please reload the tokens.")
//  //                return
//  //            }
//  //            let parameters: [String: Any?] = [
//  //                "UserId":  fetchedUserId,
//  //                "TokenId": tokenId,
//  //                "RegId": regId,
//  //                "PanNo": panNo,
//  //
//  //            ]
//  //            print(parameters)
//  //            let Url = "Client/ViewTradingBankDPClientData"
//  //
//  //            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
//  //                switch result {
//  //                case .success(let jsonResponse):
//  //                    print("ViewTradingBankDPClientData Response: \(jsonResponse)")
//  //                    //self.isPennyDrop = jsonResponse["IsPennyDropDone"] as? String ?? ""
//  //                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//  //                        switch errorCode {
//  //                        case "000000":
//  //                            DispatchQueue.main.async {
//  //                                self.updateUI(with: jsonResponse)
//  //                            }
//  //                        default:
//  //                            print("Unhandled error code: \(errorCode)")
//  //                        }
//  //                    }
//  //                case .failure(let error):
//  //                    print("Login API call failed: \(error.localizedDescription)")
//  //                }
//  //            }
//  //        }
//  //    }
//  //    func updateUI(with response: [String: Any]) {
//  //        // Check if "IsPennyDropDone" exists and is equal to "N"
//  //        if let isPennyDropDone = response["IsPennyDropDone"] as? String, isPennyDropDone == "N" || !isPennyDropDone.isEmpty {
//  //            //            self.isPennyDrop = "Y"
//  //            // Update the bank name and branch if available
//  //            if let bankName = response["BankName"] as? String, let branch = response["BranchName"] as? String {
//  //                self.bankName = bankName
//  //                self.branch = branch
//  //                //                self.bankNamelbl.text = "\(bankName)\n\(branch)"
//  //                //                self.holderview2.isHidden = false
//  //            }
//  //
//  //            // Update the account number and labels if available
//  //            if let accountNumber = response["BankAccountNumber"] as? String {
//  //                //    AcountNumberLabel.text = accountNumber
//  //                AccountNumberTF.text = accountNumber
//  //                ConfirmAccountNumberTF.text = accountNumber
//  //                let checkmarkImage = UIImage(systemName: "checkmark.circle.fill")
//  //                //                ConfirmAccountBtn.setImage(checkmarkImage, for: .normal)
//  //                //                ConfirmAccountBtn.tintColor = .green
//  //                //                AccountBtn.setImage(checkmarkImage, for: .normal)
//  //                //                AccountBtn.tintColor = .green
//  //                //                ConfirmAccountBtn.isHidden = false
//  //                //                AccountBtn.isHidden = false
//  //                SubmitBtn.isEnabled = true
//  //                IFSCTF.isEnabled = true
//  //            }
//  //
//  //            // Update IFSC code if available
//  //            if let ifscCode = response["IFSCCode"] as? String {
//  //                IFSCTF.text = ifscCode
//  //                self.IFSC = ifscCode
//  //            }
//  //
//  //            // Update MICR code if available
//  //            if let micrCode = response["MICRCode"] as? String {
//  //                MICRTF.text = "\(micrCode)"  // Convert MICR code to a string if it's an integer
//  //                self.micr = micrCode
//  //            }
//  //
//  //            // Update UPI ID if available
//  //            //            if let upiID = response["UPIID"] as? String {
//  //            //                upiIDTF.text = upiID
//  //            //                //self.upi
//  //            //            }
//  //
//  //            if let status = response["Status"] as? String, status == "REJECTED" {
//  //                AccountNumberTF.textColor = .red
//  //                ConfirmAccountNumberTF.textColor = .red
//  //            } else {
//  //                // Optional: Set text color back to default if not REJECTED
//  //                AccountNumberTF.textColor = .black
//  //                ConfirmAccountNumberTF.textColor = .black
//  //            }
//  //            // Disable the text fields and buttons since Penny Drop is not done
//  //            if rejection == "Rejection" {
//  //                // Enable all text fields
//  //                AccountNumberTF.isEnabled = true
//  //                ConfirmAccountNumberTF.isEnabled = true
//  //                IFSCTF.isEnabled = true
//  //                MICRTF.isEnabled = true
//  //                //  upiIDTF.isEnabled = true
//  //            } else {
//  //                // Disable text fields as per the previous logic
//  //                AccountNumberTF.isEnabled = false
//  //                ConfirmAccountNumberTF.isEnabled = false
//  //                IFSCTF.isEnabled = false
//  //                MICRTF.isEnabled = false
//  //                // upiIDTF.isEnabled = false
//  //                SubmitBtn.isEnabled = false
//  //                SubmitBtn.alpha = 0.5// Enable the submit button to navigate to the next page
//  //            } // Enable the submit button to navigate to the next page
//  //
//  //        } else {
//  //            // If "IsPennyDropDone" is not "N" (or it's missing), skip updating the UI
//  //            print("Penny drop is not done or data is missing. Skipping UI update.")
//  //        }
//  //    }
//  //}
//  //
//import UIKit
//
//class BankVC: UIViewController, UITextFieldDelegate, @MainActor ReloadPageDelegate {
//    func reloadPageData() {
//        self.ValidateToken()
//    }
//
//    var rejection : String?
//    var micr: String?
//    var bankName: String?
//    var branch: String?
//    var IFSC: String?
//    var apiResponse: [String: Any]?
//    var isPennyDrop: String = "Y"
//    var panNo: String?
//    var regId: String?
//    var fetchedUserId: String?
//    weak var delegate: ReloadPageDelegate?
//    var fetchedSessionID: String?
//    var mobiledecodeArray: String?
//    var bankList: [[String: Any]] = []
//    var filteredBankList: [[String: Any]] = []
//    var clienttrnxid: String?
//    var segmentsPreferred: String?
//    var PANName: String?
//    var EmailId: String?
//    var camsClosed: Bool = false
//    var IsBankMappedInCAMS: String = ""
//    var isConcentSubmitted: String?
//    var isDerivative: String?
//    var isGetDocumentsFromCAMS: String?
//    var consent: String?
//    var camsClickCount: String?
//    var canNavigateNextPage = false
//    var retryCount000002 = 0
//    let maxRetry = 1
//    var hasNavigatedToOtherDetails = false
//    var CAMSfipid: String?
//    var isPennyDropSixth: String?
//    var isCAMS: String?
//    var allowNavigation = false
//
//    @IBOutlet weak var SubmitBtn: UIButton!
//    @IBOutlet weak var ConfirmAccountNumberTF: UITextField!
//    @IBOutlet weak var AccountNumberTF: UITextField!
//    @IBOutlet weak var IFSCTF: UITextField!
//    @IBOutlet weak var MICRTF: UITextField!
//    @IBOutlet weak var upiIDBtn: UIButton!
//    @IBOutlet weak var homeBtn: UIButton!
//    @IBOutlet weak var connectToCams: UIButton!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.SubmitBtn.layer.cornerRadius = 10
//        AccountNumberTF.delegate = self
//        ConfirmAccountNumberTF.delegate = self
//        IFSCTF.delegate = self
//        MICRTF.delegate = self
//        fetchUserId()
//        print("ispennydrop \(isPennyDrop)")
//
//        AccountNumberTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        ConfirmAccountNumberTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        IFSCTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//
//        navigationItem.hidesBackButton = true
//
//        AccountNumberTF.layer.cornerRadius = 10
//        AccountNumberTF.layer.borderWidth = 1
//        AccountNumberTF.layer.borderColor = UIColor.appBorder.cgColor
//
//        ConfirmAccountNumberTF.layer.cornerRadius = 10
//        ConfirmAccountNumberTF.layer.borderWidth = 1
//        ConfirmAccountNumberTF.layer.borderColor = UIColor.appBorder.cgColor
//
//        IFSCTF.layer.cornerRadius = 10
//        IFSCTF.layer.borderWidth = 1
//        IFSCTF.layer.borderColor = UIColor.appBorder.cgColor
//
//        MICRTF.layer.cornerRadius = 10
//        MICRTF.layer.borderWidth = 1
//        MICRTF.layer.borderColor = UIColor.appBorder.cgColor
//
//        // SubmitBtn.isEnabled = false
//        SubmitBtn.layer.cornerRadius = 10
//        upiIDBtn.layer.cornerRadius = 10
//        SubmitBtn.backgroundColor = .appPrimary
//        upiIDBtn.backgroundColor = .appPrimary
//        homeBtn.tintColor = .appPrimary
//        view.backgroundColor = .appBackground
//
//        connectToCams.backgroundColor = .appPrimary
//        connectToCams.layer.cornerRadius = 10
//
//        SIXTHAPI(userID: fetchedUserId ?? "")
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if let userId = fetchedUserId {
//            SIXTHAPI(userID: userId)
//        }
//    }
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
//    @IBAction func connectToCams(_ sender: UIButton) {
//        redirectCams()
//    }
//
////    @IBAction func SubmitBtn(_ sender: Any) {
////
////        print("Submit button tapped")
////
////        // Step 1: Check if rejection has value "Rejection"
////        if rejection == "Rejection" {
////            print("Rejection case detected. Performing all validations.")
////
////            // Perform all validations
////            guard let accountNumber = AccountNumberTF.text, accountNumber.count >= 9 else {
////                showAlert(message: "Please enter a valid account number with at least 9 digits.")
////                return
////            }
////
////            guard isAccountNumberValid() else {
////                showAlert(message: "Account numbers do not match. Please ensure both account numbers are the same.")
////                return
////            }
////
////            guard isIFSCValid() else {
////                showAlert(message: "Please enter a valid IFSC code.")
////                return
////            }
////
////            guard isMICRValid() else {
////                showAlert(message: "Please enter MICR code.")
////                return
////            }
////
////
////            // If all validations pass, call the API
////            print("All validations passed for rejection case, calling API")
////            SaveTradingBankDPClientData(accountnumber: AccountNumberTF.text!)
////            return
////        }
////
////        // Step 2: Handle the fresh case (Penny Drop logic)
////        if isPennyDrop.isEmpty {
////            print("Penny drop is done. Navigating to the next page.")
////            navigateToNextPage()
////        } else {
////            print("Fresh case detected. Performing validations.")
////
////            // Perform all validations
////            guard let accountNumber = AccountNumberTF.text, accountNumber.count >= 9 else {
////                showAlert(message: "Please enter a valid account number with at least 9 digits.")
////                return
////            }
////
////            guard isAccountNumberValid() else {
////                showAlert(message: "Account numbers do not match. Please ensure both account numbers are the same.")
////                return
////            }
////
////            guard isIFSCValid() else {
////                showAlert(message: "Please enter a valid IFSC code.")
////                return
////            }
////
////            guard isMICRValid() else {
////                showAlert(message: "Please enter MICR code.")
////                return
////            }
////
////
////            // If all validations pass, call the API
////            print("All validations passed for fresh case, calling API")
////            SaveTradingBankDPClientData(accountnumber: AccountNumberTF.text!)
////        }
////    }
//
//    @IBAction func SubmitBtn(_ sender: Any) {
//            print("Submit button tapped")
//
//            // Step 1: Check if rejection has value "Rejection"
//            if rejection == "Rejection" {
//                print("Rejection case detected. Performing all validations.")
//
//                // Perform all validations
//                guard let accountNumber = AccountNumberTF.text, accountNumber.count >= 9 else {
//                    showAlert(message: "Please enter a valid account number with at least 9 digits.")
//                    return
//                }
//
//                guard isAccountNumberValid() else {
//                    showAlert(message: "Account numbers do not match. Please ensure both account numbers are the same.")
//                    return
//                }
//
//                guard isIFSCValid() else {
//                    showAlert(message: "Please enter a valid IFSC code.")
//                    return
//                }
//
//                guard isMICRValid() else {
//                    showAlert(message: "Please enter MICR code.")
//                    return
//                }
//
//                //                   if let upiID = upiIDTF.text, !upiID.isEmpty {
//                //                       guard isUPIValid() else {
//                //                           showAlert(message: "Please enter a valid UPI ID.")
//                //                           return
//                //                       }
//                //                   }
//
//                // If all validations pass, call the API
//                print("All validations passed for rejection case, calling API")
//                SaveTradingBankDPClientData(accountnumber: AccountNumberTF.text!)
//                return
//            }
//
//            // Step 2: Handle the fresh case (Penny Drop logic)
//            if isPennyDrop.isEmpty {
//                print("Penny drop is done. Navigating to the next page.")
//                navigateToNextPage()
//            } else {
//                print("Fresh case detected. Performing validations.")
//
//                // Perform all validations
//                guard let accountNumber = AccountNumberTF.text, accountNumber.count >= 9 else {
//                    showAlert(message: "Please enter a valid account number with at least 9 digits.")
//                    return
//                }
//
//                guard isAccountNumberValid() else {
//                    showAlert(message: "Account numbers do not match. Please ensure both account numbers are the same.")
//                    return
//                }
//
//                guard isIFSCValid() else {
//                    showAlert(message: "Please enter a valid IFSC code.")
//                    return
//                }
//
//                guard isMICRValid() else {
//                    showAlert(message: "Please enter MICR code.")
//                    return
//                }
//
//                //                   if let upiID = upiIDTF.text, !upiID.isEmpty {
//                //                       guard isUPIValid() else {
//                //                           showAlert(message: "Please enter a valid UPI ID.")
//                //                           return
//                //                       }
//                //                   }
//
//                // If all validations pass, call the API
//                print("All validations passed for fresh case, calling API")
//                SaveTradingBankDPClientData(accountnumber: AccountNumberTF.text!)
//            }
//        }
//
//
//    func showAlert(message: String) {
//        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    @IBAction func homeBtn(_ sender: UIButton) {
//        self.navigationController?.popToRootViewController(animated: true)
//    }
//
//    @IBAction func BackBtn(_ sender: UIButton) {
//        delegate?.reloadPageData()
//        self.navigationController?.popViewController(animated: true)
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
//        if textField == AccountNumberTF || textField == ConfirmAccountNumberTF {
//            if let accountNumber = AccountNumberTF.text, let confirmNumber = ConfirmAccountNumberTF.text {
//
//                let exclamationImage = UIImage(systemName: "exclamationmark.circle.fill")
//                let checkmarkImage = UIImage(systemName: "checkmark.circle.fill")
//
//                // If the account numbers match
//                if confirmNumber == accountNumber, !accountNumber.isEmpty {
//
//                    SubmitBtn.isEnabled = true
//                    IFSCTF.isEnabled = true
//                } else {
//                    // If the account numbers don't match, show the exclamation mark
//
//                    IFSCTF.isEnabled = false
//                }
//            }
//        }
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
//
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
//        func showPennyDropAlert() {
//            let alert = UIAlertController(title: "Alert", message: "Bank account could not be verified. Proceed with the same bank account or provide another account details.", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//
//            }))
//
//            alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { _ in
//
//                self.isPennyDrop = "N"
//                self.SaveTradingBankDPClientData(accountnumber: self.AccountNumberTF.text ?? "")
//            }))
//
//            self.present(alert, animated: true, completion: nil)
//        }
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
//            let parameters: [String: Any?] = [
//                "BankName": bankName,
//                "MICRCode": micr,
//                "BrokeragePlanEquityName": "",
//                "IFSCCode": IFSC,
//                "PanNo": panNo,
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
//            apiCall(url: Url, method: "POST", parameters: parameters as [String: Any], view: self.view,loaderText: "We are verifying your Bank Details, kindly wait...") { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("SaveTradingBankDPClientData Response: \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String, let errorMessage = jsonResponse["ErrorMessage"] as? String {
//                        switch errorCode {
//                        case "999992":
//                            DispatchQueue.main.async {
//                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
//                                print("All TokenMobile entries deleted due to error code 999992")
//                                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "M",in: self.view) { success in
//                                    if success {
//                                        self.SaveTradingBankDPClientData(accountnumber: accountnumber)
//                                    } else {
//                                        print("Token generation failed.")
//                                    }
//                                }
//                            }
//
//                        case "000000":
//                            if self.isCAMS == "N" {
//                                   DispatchQueue.main.async {
//                                       print("CAMS is N → Navigating to next page")
//                                       self.navigateToNextPage()
//                                   }
//                                   return
//                               }
//
//                            if self.rejection == "Rejection" {
//                                // Navigate back immediately after success
//                                DispatchQueue.main.async {
//                                    self.navigateToNextPage()
//                                }
//                            } else if self.isPennyDrop == "N" && self.isDerivative == "N" {
//                                self.navigateToNextPage()
//                            } else {
//                                self.SIXTHAPI(userID: self.fetchedUserId ?? "")
//                            }
//                        case "000002":
//                            DispatchQueue.main.async {
//                                                            self.showPennyDropAlert()
//                                                        }
//
//                        case "531009":
//                            DispatchQueue.main.async {
//                                if let errorMessage = jsonResponse["ErrorMessage"] as? String {
//
//                                    let alert = UIAlertController(title: "Message", message: errorMessage, preferredStyle: .alert)
//
//                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//                                        let storyboard = UIStoryboard(name: "ApplicationForm", bundle: nil)
//                                        let vc = storyboard.instantiateViewController(identifier: "ApplicationFormVC") as? ApplicationFormVC
//
//                                        self.navigationController?.pushViewController(vc! , animated: true)
//                                    }))
//
//                                    self.present(alert, animated: true, completion: nil)
//                                }
//                            }
//
//                        case "904000":
//                            self.showAlert(message: errorMessage)
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
//                            if let bankList = jsonResponse["BankList"] as? [[String: Any]], !bankList.isEmpty {
//                                self.bankList = bankList
//
//
//                                if let firstBank = bankList.first {
//                                    // ✅ Safely assign values
//                                    self.micr = firstBank["MICR"] as? String
//                                    self.IFSC = firstBank["IFSC"] as? String
//                                    self.bankName = firstBank["BankName"] as? String
//                                    self.branch = firstBank["Branch"] as? String
//
//                                    // ✅ Update textfields and labels
//                                    self.MICRTF.text = self.micr ?? ""
//
//                                } else {
//                                    self.micr = nil
//                                    self.MICRTF.text = ""
//
//                                }
//
//                                self.MICRTF.isEnabled = true
//                            } else {
//                                self.bankList = []
//                                self.MICRTF.text = ""
//
//                                self.MICRTF.isEnabled = true
//                            }
//                            print("API is running")
//                        }
//
//                    case "111111":
//                        self.MICRTF.isEnabled = false
//                        self.showAlert(message: ErrorMessage ?? "failure")
//                        print("failure")
//
//                    default:
//                        print("Unhandled error code: \(errorCode)")
//                    }
//                }
//            case .failure(let error):
//                print("Login API call failed: \(error.localizedDescription)")
//            }
//        }
//    }
//
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
//                                self.panNo = jsonResponse["PanNo"] as? String
//                                self.regId = jsonResponse["RegId"] as? String
//                                self.PANName = jsonResponse["PANName"] as? String
//                                self.EmailId = jsonResponse["EmailId"] as? String
//                                self.isDerivative = jsonResponse["IsDerivative"] as? String
//                                self.consent = jsonResponse["IsConsentSubmitted"] as? String
//                                self.camsClickCount = jsonResponse["CAMSClickCount"] as? String ?? ""
//                                self.isPennyDropSixth = jsonResponse["IsPennyDrop"] as? String ?? ""
//                                self.isGetDocumentsFromCAMS = jsonResponse["IsGetDocumentsFromCAMS"] as? String
//                                self.CAMSfipid = jsonResponse["CAMSBankNameForfipid"] as? String
//
//                                self.updateSixth()
//
//                                print("Final → connectToCams.isHidden = \(self.connectToCams.isHidden)")
//                            }
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
//
////    func updateSixth() {
////        // Default: Hide CAMS button
////        self.connectToCams.isHidden = true
////
////        // Case 1: When Derivative is "Y"
////        if self.isDerivative == "Y" {
////            print("✅ Derivative is Y - Checking CAMS eligibility")
////
////            // Check if CAMS button should be shown for Derivative users
////            if self.camsClickCount == "" || self.camsClickCount == "0" {
////                // First time - show button if conditions met
////                if self.isGetDocumentsFromCAMS == "N" && self.consent == "N" {
////                    self.connectToCams.isHidden = false
////                    print("🔘 Showing CAMS button for Derivative Y (first time)")
////                }
////            } else if self.camsClickCount == "1" {
////                // After first click - check status
////                if self.isGetDocumentsFromCAMS == "N" && self.consent == "N" {
////                    self.connectToCams.isHidden = false
////                    print("🔘 Showing CAMS button for Derivative Y (retry)")
////                } else if self.isGetDocumentsFromCAMS == "Y" && self.consent == "Y" {
////                    self.connectToCams.isHidden = true
////                    print("✅ CAMS already completed, hiding button")
////                }
////            } else {
////                // More than 1 click - hide button
////                self.connectToCams.isHidden = true
////                print("❌ Max CAMS attempts reached, hiding button")
////            }
////        }
////
////        // Case 2: When Derivative is "N"
////        else if self.isDerivative == "N" {
////            print("❌ Derivative is N - CAMS button should be hidden")
////            // For Non-Derivative users, CAMS button should ALWAYS be hidden
////            self.connectToCams.isHidden = true
////        }
////
////        // Case 3: When isDerivative is nil or unknown
////        else {
////            print("⚠️ isDerivative is nil or unknown - hiding CAMS button")
////            self.connectToCams.isHidden = true
////        }
////
////        print("Final connectToCams.isHidden = \(self.connectToCams.isHidden)")
////    }
//
//    func updateSixth() {
//
//        if self.isCAMS == "N" {
//              self.connectToCams.isHidden = true
//             // self.navigateToNextPage()
//              return
//          }
//
//        self.connectToCams.isHidden = true
//
//        // 🟢 CASE 1: Derivative = Y, PennyDrop = Y
//        if self.isDerivative == "Y", self.isCAMS == "Y" {
//            if self.camsClickCount == "" {
//                if self.isGetDocumentsFromCAMS == "N", self.consent == "N" {
//                    self.connectToCams.isHidden = false  // ✅ Show button
//                }
//            } else if self.camsClickCount == "1" {
//                if self.isGetDocumentsFromCAMS == "N", self.consent == "N" {
//                    self.connectToCams.isHidden = false
//                } else if self.isGetDocumentsFromCAMS == "Y", self.consent == "Y" {
//                    self.connectToCams.isHidden = true
//                }
//            } else if self.camsClickCount == "2" {
//                self.connectToCams.isHidden = true
//            }
//
//            // 🟢 CASE 2: PennyDrop = N
//        } else if self.isCAMS == "Y"{
//            if self.camsClickCount == "" || self.camsClickCount == "1" {
//                if self.isGetDocumentsFromCAMS == "N" && self.consent == "N" {
//                    self.connectToCams.isHidden = false
//                }
//            } else if self.isCAMS == "N" {
//                self.connectToCams.isHidden = true
//            }
//        }
//    }
//
//    func ValidateToken(){
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
//    func redirectCams() {
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
//            [self] tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self
//                        .mobiledecodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile", deviceType: "M",
//                    in: self.view
//                ) { success in
//                    if success {
//                        // Retry SIXTHAPI after token regeneration
//                        self.redirectCams()
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            let parameters: [String: Any?] = [
//                "UserId": fetchedUserId ?? "",
//                "PANNo": panNo ?? "",
//                "RegId": regId,
//                "SessionId": fetchedSessionID ?? "",
//                "Token": tokenId,
//                "CAMSfipid": CAMSfipid ?? "",
//                "Document": "INCOMEPROOF",
//                "subDocument": "Six Months Bank Statement"
//
//            ]
//            if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted),
//               let jsonString = String(data: jsonData, encoding: .utf8) {
//                print("RequestCAMS request:\n\(jsonString)")
//            }
//            print(parameters)
//            let Url = "MultiPartImageUpload/RequestCAMS"
//
//            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("RequestCams Response: \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "000000":
//                            if let clientId = jsonResponse["clienttrnxid"] as? String,
//                               let redirectionUrl = jsonResponse["redirectionurl"] as? String {
//
//                                self.clienttrnxid = clientId
//                                print("Saved TxnId: \(clientId)")
//
//                                DispatchQueue.main.async {
//                                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CamsVC") as? CamsVC {
//                                        vc.fetchedUserId = self.fetchedUserId
//                                        vc.fetchedSessionID = self.fetchedSessionID
//                                        vc.panNo = self.panNo
//                                        vc.regId = self.regId
//                                        vc.clienttrnxid = clientId
//                                        vc.mobiledecodeArray = self.mobiledecodeArray
//                                        vc.redirectionUrl = redirectionUrl
//                                        vc.PANName = self.PANName
//                                        vc.EmailId = self.EmailId
//                                        vc.CAMSfipid = self.CAMSfipid
//                                        self.navigationController?.pushViewController(vc, animated: true)
//                                    }
//                                }
//                            }
//                        case "999992":
//                            CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "M",in: self.view) { success in
//                                if success {
//                                    self.redirectCams()
//
//                                } else {
//                                    DispatchQueue.main.async {
//                                        self.showAlert(message: "Token refresh failed. Please try again.")
//                                    }
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
//    func ViewTradingBankDPClientData(){
//
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//            guard let tokenId = tokenId else {
//                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "M",in: self.view) { success in
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
//
//    func updateUI(with response: [String: Any]) {
//        // Check if "IsPennyDropDone" exists and is equal to "N"
//        if let isPennyDropDone = response["IsPennyDropDone"] as? String, isPennyDropDone == "N" || !isPennyDropDone.isEmpty {
//            //            self.isPennyDrop = "Y"
//            // Update the bank name and branch if available
//            if let bankName = response["BankName"] as? String, let branch = response["BranchName"] as? String {
//                self.bankName = bankName
//                self.branch = branch
//
//            }
//
//            // Update the account number and labels if available
//            if let accountNumber = response["BankAccountNumber"] as? String {
//
//                AccountNumberTF.text = accountNumber
//                ConfirmAccountNumberTF.text = accountNumber
//
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
//
//
//            if let status = response["Status"] as? String, status == "REJECTED" {
//                AccountNumberTF.textColor = .red
//                ConfirmAccountNumberTF.textColor = .red
//
//            } else {
//                // Optional: Set text color back to default if not REJECTED
//                AccountNumberTF.textColor = .black
//                ConfirmAccountNumberTF.textColor = .black
//            }
//            // Disable the text fields and buttons since Penny Drop is not done
//            if rejection == "Rejection" {
//                // Enable all text fields
//                connectToCams.isHidden = true
//                AccountNumberTF.isEnabled = true
//                ConfirmAccountNumberTF.isEnabled = true
//                IFSCTF.isEnabled = true
//                MICRTF.isEnabled = true
//
//            } else {
//                // Disable text fields as per the previous logic
//                AccountNumberTF.isEnabled = false
//                ConfirmAccountNumberTF.isEnabled = false
//                IFSCTF.isEnabled = false
//                MICRTF.isEnabled = false
//
//               SubmitBtn.isEnabled = false
//                SubmitBtn.alpha = 0.5// Enable the submit button to navigate to the next page
//            } // Enable the submit button to navigate to the next page
//
//        } else {
//            // If "IsPennyDropDone" is not "N" (or it's missing), skip updating the UI
//            print("Penny drop is not done or data is missing. Skipping UI update.")
//        }
//    }
//
//    func navigateToNextPage() {
//        if rejection == "Rejection" {
//            print("Rejection detected. Popping out the current screen.")
//            delegate?.reloadPageData()
//            self.navigationController?.popViewController(animated: true)
//            return
//        }
//
//        // Navigate to NomineeDetailsVC if no rejection
//        let storyboard = UIStoryboard(
//            name: "OtherDetails",
//            bundle: Bundle.module)
//        let vc =
//        storyboard.instantiateViewController(
//            identifier: "OtherDetailsVC")
//        as! OtherDetailsVC
//        vc.panNo = panNo
//        vc.regId = regId
//        vc.delegate = self
//        self.navigationController?
//            .pushViewController(vc, animated: true)
//    }
//}
