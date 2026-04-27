
import UIKit
protocol mobileOtpDelegate:AnyObject{
    func didtapChangeBtn(with phoneNumber: String)
}

class MobileOTPVC: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var Label1: UILabel!
    // @IBOutlet weak var ChangeNumberBtn: UIButton!
    // @IBOutlet weak var OTPTF: UITextField!
    @IBOutlet weak var TimeLbl: UILabel!
    @IBOutlet weak var ResendOTP: UIButton!
    //  @IBOutlet weak var relationshipBtn: UIButton!
    //   @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var passText1: UITextField!
    @IBOutlet weak var passText2: UITextField!
    @IBOutlet weak var passText3: UITextField!
    @IBOutlet weak var passText4: UITextField!
    @IBOutlet weak var passText5: UITextField!
    @IBOutlet weak var passText6: UITextField!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var homeBtn: UIButton!
    
    var relations: [[String: Any]] = []
    var decodeArray: String?
    var fetchedUserId: String?
    var LoginUserId: String?
    var fetchedSessionID: String?
    var relation:String?
    var userID = String()
    var sessionID = String()
    var errorCodes : String = ""
    
    weak var delegate:mobileOtpDelegate?
    
    var panNo: String?
    var phoneNumber : String?
    var timer: Timer?
    var remainingSeconds = 60
    var MD5ByteArray = [UInt8]()
    var OTP : String = ""
    var enteredOTP: String?
    var txnId: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let iphone = UIImage(systemName: "ellipsis.rectangle.fill") {
            //OTPTF.setLeftIcon(iphone)
        }
        //OTPTF.layer.borderWidth = 0.5
        //OTPTF.layer.cornerRadius = 10
        // OTPTF.layer.borderColor = UIColor.lightGray.cgColor
        print(phoneNumber!)
        startTimer()
        setupResendButton()
        Label1.text = "We have sent a 6 digit code to +91 \(phoneNumber ?? "")"
        print("errorcode:-\(errorCodes)")
        // OTPTF.delegate = self
        //OTPTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        OTPGeneratorApi(phoneNumber: phoneNumber!)
        
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.LoginUserId = userId
                //                                self.fetchedSessionID = sessionID
                //                                self.decodeArray = decodeByteArrayString
                print("UserID: \(userId), SessionID: \(sessionID)")
            } else {
                print("No UserID or SessionID found.")
            }
        }
        //   view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        // mainView.layer.cornerRadius = 20
        //  mainView.layer.borderWidth = 0.5
        //mainView.layer.borderColor = UIColor.black.cgColor
        passText1.layer.cornerRadius = 10
        passText2.layer.cornerRadius = 10
        passText3.layer.cornerRadius = 10
        passText4.layer.cornerRadius = 10
        passText5.layer.cornerRadius = 10
        passText6.layer.cornerRadius = 10
        
        view1.layer.cornerRadius = 10
        view2.layer.cornerRadius = 10
        view3.layer.cornerRadius = 10
        view4.layer.cornerRadius = 10
        view5.layer.cornerRadius = 10
        view6.layer.cornerRadius = 10
        
        view1.layer.borderColor = UIColor.appBorder.cgColor
        view2.layer.borderColor = UIColor.appBorder.cgColor
        view3.layer.borderColor = UIColor.appBorder.cgColor
        view4.layer.borderColor = UIColor.appBorder.cgColor
        view5.layer.borderColor = UIColor.appBorder.cgColor
        view6.layer.borderColor = UIColor.appBorder.cgColor
        
        view1.layer.borderWidth = 0.5
        view2.layer.borderWidth = 0.5
        view3.layer.borderWidth = 0.5
        view4.layer.borderWidth = 0.5
        view5.layer.borderWidth = 0.5
        view6.layer.borderWidth = 0.5
        
        let textFields = [passText1, passText2, passText3, passText4, passText5, passText6]
        
        for (index, tf) in textFields.enumerated() {
            tf?.delegate = self
            tf?.keyboardType = .numberPad
            tf?.textAlignment = .center
            tf?.tag = index
            tf?.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        }
        
        passText1.becomeFirstResponder()
        ResendOTP.tintColor = .appPrimary
        homeBtn.tintColor = .appPrimary
        view.backgroundColor = .appBackground
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    func setupResendButton() {
        // Set the default color for the button in the normal state
        ResendOTP.setTitleColor(.purple, for: .normal)
        // Set the color for the button in the disabled state
        ResendOTP.setTitleColor(.gray, for: .disabled)
        ResendOTP.isEnabled = false // Initially disable the button
        
    }
    func startTimer() {
        ResendOTP.isEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            let minutes = remainingSeconds / 60
            let seconds = remainingSeconds % 60
            TimeLbl.text = String(format: "%02d:%02d  /", minutes, seconds)
        } else {
            timer?.invalidate()
            ResendOTP.isEnabled = true // Enable ResendOTP button when the timer ends
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        // Allow only numbers
        if !string.isEmpty && !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
            return false
        }
        
        // Allow backspace
        if string.isEmpty {
            return true
        }
        
        // Only 1 character per field
        return textField.text?.isEmpty ?? true
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.count == 6 {
            enteredOTP = text
            if let phoneNumber = phoneNumber {
                OtpVerification(phoneNumber: phoneNumber)
            }
        }
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        
        let textFields = [passText1, passText2, passText3, passText4, passText5, passText6]
        
        if let text = textField.text, text.count == 1 {
            if textField.tag < textFields.count - 1 {
                textFields[textField.tag + 1]?.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                verifyOTPIfNeeded()
            }
        }
    }
    
    func getEnteredOTP() -> String {
        return [
            passText1.text,
            passText2.text,
            passText3.text,
            passText4.text,
            passText5.text,
            passText6.text
        ].compactMap { $0 }.joined()
    }
    
    func verifyOTPIfNeeded() {
        let otp = getEnteredOTP()
        
        if otp.count == 6 {
            enteredOTP = otp
            if let phoneNumber = phoneNumber {
                OtpVerification(phoneNumber: phoneNumber)
            }
        }
    }
    
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        let maxLength = 6
    //
    //        // Current text in the text field
    //        let currentString: NSString = textField.text as NSString? ?? ""
    //
    //        // New string after applying the replacement
    //        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
    //
    //        // Ensure the new string length doesn't exceed the maximum limit and only allow digits
    //        let allowedCharacterSet = CharacterSet.decimalDigits
    //        let replacementCharacterSet = CharacterSet(charactersIn: string)
    //
    //        let isReplacementStringNumeric = allowedCharacterSet.isSuperset(of: replacementCharacterSet)
    //
    //        return newString.length <= maxLength && isReplacementStringNumeric
    //    }
    
    func GetInput(){
        let otp = getEnteredOTP()
        
        guard otp.count == 6 else {
            showAlert(message: "Please enter valid OTP")
            return
        }
        
        OTP = otp
        print("Entered OTP:", OTP)
        
        print("MD5 Hash:", MD5(OTP))
        
    }
    
    
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //    @IBAction func homeBtn(_ sender: UIButton) {
    //        self.navigationController?.popToRootViewController(animated: true)
    //    }
    
    //    @IBAction func relationshipBtn(_ sender: UIButton) {
    //        let vc = storyboard?.instantiateViewController(identifier: "relationshipVC") as! relationshipVC
    //        vc.modalTransitionStyle = .crossDissolve
    //        vc.modalPresentationStyle = .overCurrentContext
    //        vc.relations = relations
    //        vc.delegate = self
    //        //        vc.onSelectRelation = { [weak self] selectedRelation in
    //        //                self?.relationshipBtn.setTitle(selectedRelation, for: .normal)
    //        //                self?.relationshipBtn.isEnabled = false // Disable button after selection
    //        //            }
    //        present(vc, animated: true)
    //    }
    
    
    @IBAction func ResendOtpBtn(_ sender: UIButton) {
        //        let vc = storyboard?.instantiateViewController(identifier: "EmailIdVC") as! EmailIdVC
        //        self.navigationController?.pushViewController(vc, animated: true)
        self.showTemporaryAlert(message: "OTP sent successfully.")
        remainingSeconds = 60
        ResendOTP.isEnabled = false // Disable the button again
        startTimer()
        OTPGeneratorApi(phoneNumber: phoneNumber!)
    }
    @IBAction func ChangeBtn(_ sender: UIButton) {
        if let phoneNumber = phoneNumber {
            delegate?.didtapChangeBtn(with: phoneNumber)
        }
        self.navigationController?.popViewController(animated: true)
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func showTemporaryAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}

extension MobileOTPVC{
    
    func OtpVerification(phoneNumber: String) {
        GetInput()
        let decodeByteArrayToString = String(decoding: MD5ByteArray, as: UTF8.self)
        // Save the decoded byte array string to the OTP variable
        OTP = decodeByteArrayToString
        print(decodeByteArrayToString)
        // Convert string to data
        let stringToData = Data(decodeByteArrayToString.utf8)
        // Convert data to UTF-8 Encoding String
        _ = String(data: stringToData, encoding: String.Encoding.utf8)!
        
        let parameters: [String: Any] = [
            "DeviceType": "W",
            "PhoneNumber": phoneNumber,
            "OTP": decodeByteArrayToString,
            "MobileNo": "",
            "RmCode": "",
            "Branch": ""
        ]
        //sessionID=28RL2GSO
        // URL for the login endpoint
        let otpUrl = "OTPManagement/ValidateMobileOTPForClient"
        
        apiCall(url: otpUrl, method: "POST", parameters: parameters, view: self.view) { result in
            switch result {
            case .success(let jsonResponse):
                print("3RD Response: \(jsonResponse)")
                //                CoreDataHelper.saveUserId(self.userID, sessionID: jsonResponse["SessionId"] as? String ?? "", decodeByteArrayString: decodeByteArrayToString, entityName: "MobileUser")
                let ErrorMessage = jsonResponse["ErrorMessage"] as? String
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "400003":
                        DispatchQueue.main.async { [self] in
                            if errorCodes == "200000" {
                                self.callInsertClientRegisterApi(phonenumber: phoneNumber)
                            }
                            //                            else if errorCodes == "000000" {
                            //                                self.navigateToEmailIdVC(userId: userID , sessionID: sessionID, phoneNumber: phoneNumber )
                            //                            }
                            else {
                                FifthApi(phoneNumber: phoneNumber, decodeByteArrayToString: decodeByteArrayToString)
                            }
                        
                        }
                        
                    case "000000":
                        DispatchQueue.main.async {
                            self.navigateToEmailIdVC(userId: self.userID, sessionID: self.sessionID, phoneNumber: phoneNumber)
                
                            
                            
                            print("OTP generation successful")
                        }
                        
                    case "400001":
                        DispatchQueue.main.async {
                            self.showTemporaryAlert(message: ErrorMessage ?? "")
                            // self.OTPTF?.text = nil
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
    
    func OTPGeneratorApi(phoneNumber: String) {
        let apiUrlString = "OTPManagement/SendOTPToMobileClient"
        guard let apiUrl = URL(string: apiUrlString) else {
            showAlert(message: "Invalid API URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "MobileNo": "",
            "DeviceType": "W",
            "RmCode": "",
            "Branch": "",
            "PhoneNumber": phoneNumber,
            "OTP": "",
        ]
        print(parameters)
        apiCall(url: apiUrlString, method: "POST", parameters: parameters, view: self.view,loaderText: "Getting an OTP, please wait...") { result in
            switch result {
            case .success(let jsonResponse):
                print("2ND Response: \(jsonResponse)")
                let ErrorMessage = jsonResponse["ErrorMessage"] as? String
                self.errorCodes = (jsonResponse["ErrorCode"] as? String)!
                
                print("errorcodes\(self.errorCodes)")
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "000000":
                        DispatchQueue.main.async {
                            
                            
                            if let relationsDict = jsonResponse["Relations"] as? [String: Any],
                               let relationsList = relationsDict["list"] as? [[String: Any]] {
                                self.relations = relationsList // Save the relations data
                                //   self.setRelationshipButton() // Set button title and selection state
                            } else {
                                print("Error: Could not parse 'Relations' from response")
                            }
                            
                            print("otp generation is called")
                        }
                        //self.showTemporaryAlert(message: "OTP sent successfully")
                    case "200000":
                        DispatchQueue.main.async {
                            
                            if let relationsDict = jsonResponse["Relations"] as? [String: Any],
                               let relationsList = relationsDict["list"] as? [[String: Any]] {
                                self.relations = relationsList // Save the relations data
                                //self.setRelationshipButton() // Set button title and selection state
                            } else {
                                print("Error: Could not parse 'Relations' from response")
                            }
                        }
                        print("otp generation is called")
                        //self.showTemporaryAlert(message: "OTP sent successfully")
                    case "400000":
                        
                        self.showTemporaryAlert(message:ErrorMessage ?? "" )
                        print("Exceeded maximum tries. please try after 15 minutes.,")
                        //self.showTemporaryAlert(message: "OTP sent successfully")
                    default:
                        print("Unhandled error code: \(errorCode)")
                        self.showTemporaryAlert(message:ErrorMessage ?? "" )
                    }
                }
            case .failure(let error):
                print("Login API call failed: \(error.localizedDescription)")
            }
        }
    }
    
    //    func setRelationshipButton() {
    //        // Check for a relation with DefaultSelect = 1
    //        if let selectedRelation = relations.first(where: { $0["DefaultSelect"] as? Int == 1 }) {
    //            let relationName = selectedRelation["Relation"] as? String ?? "Select Relationship"
    //            relation = relationName
    //            relationshipBtn.setTitle(relationName, for: .normal)
    //            relationshipBtn.isEnabled = false // Disable if there's a selected relation
    //        } else {
    //            // If no DefaultSelect = 1, look for a relation with "Relation = SELF"
    //            if let selfRelation = relations.first(where: { $0["Relation"] as? String == "SELF" }) {
    //                let relationName = selfRelation["Relation"] as? String ?? "Select Relationship"
    //                relation = relationName
    //                relationshipBtn.setTitle(relationName, for: .normal)
    //            } else if let firstRelation = relations.first {
    //                // If "SELF" is not found, select the first relation in the list
    //                let relationName = firstRelation["Relation"] as? String ?? "Select Relationship"
    //                relation = relationName
    //                relationshipBtn.setTitle(relationName, for: .normal)
    //            } else {
    //                // If no relations are available, set to default text
    //                relationshipBtn.setTitle("Select Relationship", for: .normal)
    //            }
    //
    //            // Enable the button for user selection if no default was selected
    //            relationshipBtn.isEnabled = true
    //        }
    //    }
    
    func callInsertClientRegisterApi(phonenumber : String) {
        
        GetInput()
        let decodeByteArrayToString = String(decoding: MD5ByteArray, as: UTF8.self)
        // Save the decoded byte array string to the OTP variable
        print("DECODE:-\(decodeByteArrayToString)")
        // Convert string to data
        let stringToData = Data(decodeByteArrayToString.utf8)
        // Convert data to UTF-8 Encoding String
        _ = String(data: stringToData, encoding: String.Encoding.utf8)!
        
        
        let apiUrlString = "UserCreationDetails/InsertClientRegister"
        
        
        var parameters: [String: Any?] = [
            "DeviceType": "W",
            "UserName": "SDSFD",
            "OTP": decodeByteArrayToString,
            "MobileNumber": phonenumber,
            "EmailAddress": "",
            "IsDpExternal": "0",
            "RmCode": "",
            "MobileRelation": "SELF",
            "DPBrokerCode": "",
            "ReferEarnClientId": "",
            "IPAddress": "1",
            "SessionId": ""
        ]
        
        // Iterate through the dictionary and replace empty strings with nil
        for (key, value) in parameters {
            if let stringValue = value as? String, stringValue.isEmpty {
                parameters[key] = nil
            }
        }
        
        print(parameters)
        
        apiCall(url: apiUrlString, method: "POST", parameters: parameters as [String : Any], view: self.view) { [self] result in
            switch result {
            case .success(let jsonResponse):
                print("4TH Response: \(jsonResponse)")
                userID = (jsonResponse["UserID"] as? String)!
                sessionID = (jsonResponse["SessionId"] as? String)!
                CoreDataHelper.saveUserId(userID, sessionID: sessionID, decodeByteArrayString: decodeByteArrayToString , entityName: "MobileUser") // Save userId to Core Data
                
                //phoneNumber = (jsonResponse["MobileNumber"] as? String)!
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    
                    switch errorCode {
                    case "400003":
                        DispatchQueue.main.async {
                            
                        }
                    case "900006":
                        DispatchQueue.main.async {
                            self.navigateToEmailIdVC(userId: self.userID , sessionID: self.sessionID, phoneNumber: self.phoneNumber! )
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

    func FifthApi(phoneNumber:String,decodeByteArrayToString:String){
        var parameters: [String: Any] = [
            "MobileNo": phoneNumber,
            "OTP": decodeByteArrayToString,
            "SessionId": "",
            "DeviceType": "W",
            "IPAddress": "1",
            "MobileRelation": "SELF"
        ]
        
        
        // URL for the login endpoint
        let fifthUrl = "Login/validateClientLogin"
        for (key, value) in parameters {
            if let stringValue = value as? String, stringValue.isEmpty {
                parameters[key] = nil
            }
        }
        print(parameters)
        apiCall(url: fifthUrl, method: "POST", parameters: parameters, view: self.view) { result in
            switch result {
            case .success(let jsonResponse):
                print("5th api Response: \(jsonResponse)")
                let ErrorMessage = jsonResponse["ErrorMessage"] as? String
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "900000":
                        if let userID = jsonResponse["UserID"] as? String,
                           let sessionId = jsonResponse["SessionId"] as? String
                        {
                            // Save UserID and SessionId to Core Data
                            CoreDataHelper.saveUserId(userID, sessionID: sessionId, decodeByteArrayString: decodeByteArrayToString, entityName: "MobileUser")
                            DispatchQueue.main.async {
                                // Check if TokenMobile is empty
                                if !CoreDataHelper.areTokensAvailable(entityName: "TokenMobile") {
                                    print("token generation")
                                    CoreDataHelper.generateToken(decodeByteArrayToString: decodeByteArrayToString, USERID: userID, SessionId: sessionId, entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                                        if success {
                                            // Call SIXTHAPI after tokenMobile API call is successful
                                            self.SIXTHAPI(userID: userID)
                                        } else {
                                            print("Token generation failed.")
                                        }
                                    }
                                } else {
                                    // Directly call SIXTHAPI if tokens are already available
                                    self.SIXTHAPI(userID: userID)
                                }
                            }
                        } else {
                            print("Invalid response: missing UserID or SessionId")
                        }
                        
                    case "400001":
                        DispatchQueue.main.async {
                            self.showTemporaryAlert(message: ErrorMessage ?? "")
                        }
                    default:
                        self.showAlert(message: ErrorMessage ?? "")
                        print("Unhandled error code: \(errorCode)")
                    }
                }
            case .failure(let error):
                print("Login API call failed: \(error.localizedDescription)")
            }
        }
    }
    
    func navigateToEmailIdVC(userId:String,sessionID:String,phoneNumber:String) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EmailIdVC") as? EmailIdVC {
            vc.userId = userId
            vc.sessionID = sessionID
            vc.phoneNumber = phoneNumber
            vc.mobileRelation = relation
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func SIXTHAPI(userID:String){
        
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.fetchedUserId = userId
                self.fetchedSessionID = sessionID
                self.decodeArray = decodeByteArrayString
                print("UserID: \(userId), SessionID: \(sessionID)")
            } else {
                print("No UserID or SessionID found.")
            }
        }
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { tokenId in
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(decodeByteArrayToString: self.decodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                    if success {
                        // Call SIXTHAPI after tokenMobile API call is successful
                        self.SIXTHAPI(userID: userID)
                    } else {
                        print("Token generation failed.")
                    }
                }// Handle the case where no tokens are available
                print("No tokens available. Please reload the tokens.")
                return
            }
            
            let parameters: [String: Any] = [
                "UserId": userID,
                "TokenId": tokenId,
                "UserIDSL": userID,
                "MobileNo": self.phoneNumber,
                "Flag": "An"
            ]
            
            print("6th api params\(parameters)")
            let sixthUrl = "ActiveApplication/GetActiveApplicationCL"
            
            // API call
            apiCall(url: sixthUrl, method: "POST", parameters: parameters, view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("SIXTHAPI Response: \(jsonResponse)")
                    let EmailId = jsonResponse["EmailId"] as? String
                    let PanNo = jsonResponse["PanNo"] as? String
                    let PANName = jsonResponse["PANName"] as? String
                    let RegId = jsonResponse["RegId"] as? String
                    let FinalStatusValue = jsonResponse["FinalStatusValue"] as? String
                    let isPdfGenerated = jsonResponse["IsPdfGenerated"] as? String ?? "0"
                    let ErrorMessage = jsonResponse["ErrorMessage"] as? String
                    let finalStatus = jsonResponse["FinalStatus"] as? String ?? "0"
                    let isPDFSign = jsonResponse["IsPDFSign"] as? String ?? "0"
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
                                print("All TokenMobile entries deleted due to error code 999992")
                                
                                // Regenerate tokens
                                CoreDataHelper.generateToken(decodeByteArrayToString: self.decodeArray ?? "", USERID: userID, SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                                    if success {
                                        // Retry SIXTHAPI after token regeneration
                                        self.SIXTHAPI(userID: userID)
                                    } else {
                                        print("Token generation failed.")
                                    }
                                }
                            }
                        case "000000":
                            print("errorcode 000000 called")
                            if let finalStatus = FinalStatusValue, finalStatus == "KYC REJECTED" {
                                DispatchQueue.main.async {
                                    let storyboard = UIStoryboard(name: "Rejection", bundle: Bundle.module)
                                    let vc = storyboard.instantiateViewController(identifier: "RejectionVC") as! RejectionVC
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                return
                            }
                            
                            
                            if finalStatus == "3" && isPdfGenerated == "0" {
                                DispatchQueue.main.async {
                                    let storyboard = UIStoryboard(name: "EsignStatusVC", bundle: Bundle.module)
                                    let vc = storyboard.instantiateViewController(identifier: "ApplicationStatic1VC") as! ApplicationStatic1VC
                                    vc.PanNo = PanNo
                                    vc.RegId = RegId
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                return
                            }
                            
                            if finalStatus == "4" && isPdfGenerated == "1" && isPDFSign == "0" {
                                print("✅ Navigating to ApplicationStatusVC - FinalStatus: \(finalStatus), isPdfGenerated: \(isPdfGenerated), isPDFSign: \(isPDFSign)")
                                DispatchQueue.main.async {
                                    let storyboard = UIStoryboard(name: "Esign", bundle: Bundle.module)
                                    if let vc = storyboard.instantiateViewController(withIdentifier: "ApplicationStatusVC") as? ApplicationStatusVC {
                                        vc.PanNo = PanNo
                                        vc.RegId = RegId
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    } else {
                                        print("❌ Could not instantiate ApplicationStatusVC")
                                        self.sectionPage() // Fallback
                                    }
                                }
                                return
                            }
                            
                            let EmailId = jsonResponse["EmailId"] as? String
                            
                            if EmailId?.isEmpty == true {
                                self.navigateToEmailIdVC(
                                    userId: userID,
                                    sessionID: self.sessionID,
                                    phoneNumber: self.phoneNumber ?? ""
                                )
                                return
                            }
                            
                            if let panStatus = jsonResponse["PANStatus"] as? String, panStatus == "0" {
                                self.PanPage(userId: userID, EmailId: EmailId ?? "")
                                return
                            }
                            
                            if let aadharStatus = jsonResponse["AadhaarStatus"] as? String, aadharStatus == "0" {
                                self.AadhaarPage(
                                    PanNo: jsonResponse["PanNo"] as? String ?? "",
                                    PANName: jsonResponse["PANName"] as? String ?? "",
                                    RegId: jsonResponse["RegId"] as? String ?? "",
                                    EmailId: EmailId ?? ""
                                )
                                return
                            }
                            
                            self.sectionPage()
                        case "000001":
                            self.showAlert(message: ErrorMessage ?? "")
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
    
    func PanPage(userId:String,EmailId:String){
        let vc = storyboard?.instantiateViewController(identifier: "PanVerifyVC") as! PanVerifyVC
        vc.MobileUserID = userId
        vc.emailID = EmailId
        self.navigationController?.pushViewController(vc , animated: true)
    }
    
    func AadhaarPage(PanNo:String,PANName:String,RegId:String,EmailId:String){
        let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
        let vc = storyboard.instantiateViewController(identifier: "DigiLocker_a") as? DigiLocker_a
        vc?.EmailId = EmailId
        vc?.PANName = PANName
        vc?.panNo = PanNo
        vc?.RegId = RegId
        self.navigationController?.pushViewController(vc! , animated: true)
    }
    
    func sectionPage(){
        //        let storyboard = UIStoryboard(name: "ApplicationForm", bundle: Bundle.module)
        //        let vc = storyboard.instantiateViewController(identifier: "ApplicationFormVC") as? ApplicationFormVC
        let vc = ApplicationFormVC()
        vc.panNo = self.panNo
        self.navigationController?.pushViewController(vc , animated: true)
    }
    
}

extension MobileOTPVC{
    func MD5(_ input: String) -> String {
        
        return hex_md5(input)
    }
    
    // MARK: - Functions
    
    func hex_md5(_ input: String) -> String {
        return rstr2hex(rstr_md5(str2rstr_utf8(input)))
    }
    
    func str2rstr_utf8(_ input: String) -> [CUnsignedChar] {
        return Array(input.utf8)
    }
    
    func rstr2tr(_ input: [CUnsignedChar]) -> String {
        var output: String = ""
        
        input.forEach {
            output.append(String(UnicodeScalar($0)))
        }
        
        return output
    }
    
    
    public func rstr_md5(_ input: [CUnsignedChar]) -> [CUnsignedChar] {
        
        MD5ByteArray = binl2rstr(binl_md5(rstr2binl(input), input.count * 8))
        
        return binl2rstr(binl_md5(rstr2binl(input), input.count * 8))
    }
    /*
     * Convert a raw string to a hex string
     */
    func rstr2hex(_ input: [CUnsignedChar]) -> String {
        let hexTab: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
        var output: [Character] = []
        
        for i in 0..<input.count {
            let x = input[i]
            let value1 = hexTab[Int((x >> 4) & 0x0F)]
            let value2 = hexTab[Int(Int32(x) & 0x0F)]
            
            output.append(value1)
            output.append(value2)
        }
        
        return String(output)
    }
    
    /*
     * Convert a raw string to an array of little-endian words
     * Characters >255 have their high-byte silently ignored.
     */
    func rstr2binl(_ input: [CUnsignedChar]) -> [Int32] {
        var output: [Int: Int32] = [:]
        
        for i in stride(from: 0, to: input.count * 8, by: 8) {
            let value: Int32 = (Int32(input[i/8]) & 0xFF) << (Int32(i) % 32)
            
            output[i >> 5] = unwrap(output[i >> 5]) | value
        }
        
        return dictionary2array(output)
    }
    
    /*
     * Convert an array of little-endian words to a string
     */
    func binl2rstr(_ input: [Int32]) -> [CUnsignedChar] {
        var output: [CUnsignedChar] = []
        
        for i in stride(from: 0, to: input.count * 32, by: 8) {
            // [i>>5] >>>
            let value: Int32 = zeroFillRightShift(input[i>>5], Int32(i % 32)) & 0xFF
            output.append(CUnsignedChar(value))
        }
        
        return output
    }
    
    
    /*
     * Add integers, wrapping at 2^32.
     */
    func safe_add(_ x: Int32, _ y: Int32) -> Int32 {
        return x &+ y
    }
    
    /*
     * Bitwise rotate a 32-bit number to the left.
     */
    func bit_rol(_ num: Int32, _ cnt: Int32) -> Int32 {
        // num >>>
        return (num << cnt) | zeroFillRightShift(num, (32 - cnt))
    }
    
    
    /*
     * These funcs implement the four basic operations the algorithm uses.
     */
    func md5_cmn(_ q: Int32, _ a: Int32, _ b: Int32, _ x: Int32, _ s: Int32, _ t: Int32) -> Int32 {
        return safe_add(bit_rol(safe_add(safe_add(a, q), safe_add(x, t)), s), b)
    }
    
    func md5_ff(_ a: Int32, _ b: Int32, _ c: Int32, _ d: Int32, _ x: Int32, _ s: Int32, _ t: Int32) -> Int32 {
        return md5_cmn((b & c) | ((~b) & d), a, b, x, s, t)
    }
    
    func md5_gg(_ a: Int32, _ b: Int32, _ c: Int32, _ d: Int32, _ x: Int32, _ s: Int32, _ t: Int32) -> Int32 {
        return md5_cmn((b & d) | (c & (~d)), a, b, x, s, t)
    }
    
    func md5_hh(_ a: Int32, _ b: Int32, _ c: Int32, _ d: Int32, _ x: Int32, _ s: Int32, _ t: Int32) -> Int32 {
        return md5_cmn(b ^ c ^ d, a, b, x, s, t)
    }
    
    func md5_ii(_ a: Int32, _ b: Int32, _ c: Int32, _ d: Int32, _ x: Int32, _ s: Int32, _ t: Int32) -> Int32 {
        return md5_cmn(c ^ (b | (~d)), a, b, x, s, t)
    }
    
    
    /*
     * Calculate the MD5 of an array of little-endian words, and a bit length.
     */
    func binl_md5(_ input: [Int32], _ len: Int) -> [Int32] {
        /* append padding */
        
        var x: [Int: Int32] = [:]
        for (index, value) in input.enumerated() {
            x[index] = value
        }
        
        let value: Int32 = 0x80 << Int32((len) % 32)
        x[len >> 5] = unwrap(x[len >> 5]) | value
        
        // >>> 9
        let index = (((len + 64) >> 9) << 4) + 14
        x[index] = unwrap(x[index]) | Int32(len)
        
        var a: Int32 =  1732584193
        var b: Int32 = -271733879
        var c: Int32 = -1732584194
        var d: Int32 =  271733878
        
        for i in stride(from: 0, to: length(x), by: 16) {
            let olda: Int32 = a
            let oldb: Int32 = b
            let oldc: Int32 = c
            let oldd: Int32 = d
            
            a = md5_ff(a, b, c, d, unwrap(x[i + 0]), 7 , -680876936)
            d = md5_ff(d, a, b, c, unwrap(x[i + 1]), 12, -389564586)
            c = md5_ff(c, d, a, b, unwrap(x[i + 2]), 17,  606105819)
            b = md5_ff(b, c, d, a, unwrap(x[i + 3]), 22, -1044525330)
            a = md5_ff(a, b, c, d, unwrap(x[i + 4]), 7 , -176418897)
            d = md5_ff(d, a, b, c, unwrap(x[i + 5]), 12,  1200080426)
            c = md5_ff(c, d, a, b, unwrap(x[i + 6]), 17, -1473231341)
            b = md5_ff(b, c, d, a, unwrap(x[i + 7]), 22, -45705983)
            a = md5_ff(a, b, c, d, unwrap(x[i + 8]), 7 ,  1770035416)
            d = md5_ff(d, a, b, c, unwrap(x[i + 9]), 12, -1958414417)
            c = md5_ff(c, d, a, b, unwrap(x[i + 10]), 17, -42063)
            b = md5_ff(b, c, d, a, unwrap(x[i + 11]), 22, -1990404162)
            a = md5_ff(a, b, c, d, unwrap(x[i + 12]), 7 ,  1804603682)
            d = md5_ff(d, a, b, c, unwrap(x[i + 13]), 12, -40341101)
            c = md5_ff(c, d, a, b, unwrap(x[i + 14]), 17, -1502002290)
            b = md5_ff(b, c, d, a, unwrap(x[i + 15]), 22,  1236535329)
            
            a = md5_gg(a, b, c, d, unwrap(x[i + 1]), 5 , -165796510)
            d = md5_gg(d, a, b, c, unwrap(x[i + 6]), 9 , -1069501632)
            c = md5_gg(c, d, a, b, unwrap(x[i + 11]), 14,  643717713)
            b = md5_gg(b, c, d, a, unwrap(x[i + 0]), 20, -373897302)
            a = md5_gg(a, b, c, d, unwrap(x[i + 5]), 5 , -701558691)
            d = md5_gg(d, a, b, c, unwrap(x[i + 10]), 9 ,  38016083)
            c = md5_gg(c, d, a, b, unwrap(x[i + 15]), 14, -660478335)
            b = md5_gg(b, c, d, a, unwrap(x[i + 4]), 20, -405537848)
            a = md5_gg(a, b, c, d, unwrap(x[i + 9]), 5 ,  568446438)
            d = md5_gg(d, a, b, c, unwrap(x[i + 14]), 9 , -1019803690)
            c = md5_gg(c, d, a, b, unwrap(x[i + 3]), 14, -187363961)
            b = md5_gg(b, c, d, a, unwrap(x[i + 8]), 20,  1163531501)
            a = md5_gg(a, b, c, d, unwrap(x[i + 13]), 5 , -1444681467)
            d = md5_gg(d, a, b, c, unwrap(x[i + 2]), 9 , -51403784)
            c = md5_gg(c, d, a, b, unwrap(x[i + 7]), 14,  1735328473)
            b = md5_gg(b, c, d, a, unwrap(x[i + 12]), 20, -1926607734)
            
            a = md5_hh(a, b, c, d, unwrap(x[i + 5]), 4 , -378558)
            d = md5_hh(d, a, b, c, unwrap(x[i + 8]), 11, -2022574463)
            c = md5_hh(c, d, a, b, unwrap(x[i + 11]), 16,  1839030562)
            b = md5_hh(b, c, d, a, unwrap(x[i + 14]), 23, -35309556)
            a = md5_hh(a, b, c, d, unwrap(x[i + 1]), 4 , -1530992060)
            d = md5_hh(d, a, b, c, unwrap(x[i + 4]), 11,  1272893353)
            c = md5_hh(c, d, a, b, unwrap(x[i + 7]), 16, -155497632)
            b = md5_hh(b, c, d, a, unwrap(x[i + 10]), 23, -1094730640)
            a = md5_hh(a, b, c, d, unwrap(x[i + 13]), 4 ,  681279174)
            d = md5_hh(d, a, b, c, unwrap(x[i + 0]), 11, -358537222)
            c = md5_hh(c, d, a, b, unwrap(x[i + 3]), 16, -722521979)
            b = md5_hh(b, c, d, a, unwrap(x[i + 6]), 23,  76029189)
            a = md5_hh(a, b, c, d, unwrap(x[i + 9]), 4 , -640364487)
            d = md5_hh(d, a, b, c, unwrap(x[i + 12]), 11, -421815835)
            c = md5_hh(c, d, a, b, unwrap(x[i + 15]), 16,  530742520)
            b = md5_hh(b, c, d, a, unwrap(x[i + 2]), 23, -995338651)
            
            a = md5_ii(a, b, c, d, unwrap(x[i + 0]), 6 , -198630844)
            d = md5_ii(d, a, b, c, unwrap(x[i + 7]), 10,  1126891415)
            c = md5_ii(c, d, a, b, unwrap(x[i + 14]), 15, -1416354905)
            b = md5_ii(b, c, d, a, unwrap(x[i + 5]), 21, -57434055)
            a = md5_ii(a, b, c, d, unwrap(x[i + 12]), 6 ,  1700485571)
            d = md5_ii(d, a, b, c, unwrap(x[i + 3]), 10, -1894986606)
            c = md5_ii(c, d, a, b, unwrap(x[i + 10]), 15, -1051523)
            b = md5_ii(b, c, d, a, unwrap(x[i + 1]), 21, -2054922799)
            a = md5_ii(a, b, c, d, unwrap(x[i + 8]), 6 ,  1873313359)
            d = md5_ii(d, a, b, c, unwrap(x[i + 15]), 10, -30611744)
            c = md5_ii(c, d, a, b, unwrap(x[i + 6]), 15, -1560198380)
            b = md5_ii(b, c, d, a, unwrap(x[i + 13]), 21,  1309151649)
            a = md5_ii(a, b, c, d, unwrap(x[i + 4]), 6 , -145523070)
            d = md5_ii(d, a, b, c, unwrap(x[i + 11]), 10, -1120210379)
            c = md5_ii(c, d, a, b, unwrap(x[i + 2]), 15,  718787259)
            b = md5_ii(b, c, d, a, unwrap(x[i + 9]), 21, -343485551)
            
            a = safe_add(a, olda)
            b = safe_add(b, oldb)
            c = safe_add(c, oldc)
            d = safe_add(d, oldd)
        }
        
        return [a, b, c, d]
    }
    
    // MARK: - Helper
    
    func length(_ dictionary: [Int: Int32]) -> Int {
        return (dictionary.keys.max() ?? 0) + 1
    }
    
    func dictionary2array(_ dictionary: [Int: Int32]) -> [Int32] {
        var array = Array<Int32>(repeating: 0, count: dictionary.keys.count)
        
        for i in Array(dictionary.keys).sorted() {
            array[i] = unwrap(dictionary[i])
        }
        
        return array
    }
    
    func unwrap(_ value: Int32?, _ fallback: Int32 = 0) -> Int32 {
        if let value = value {
            return value
        }
        
        return fallback
    }
    
    func zeroFillRightShift(_ num: Int32, _ count: Int32) -> Int32 {
        let value = UInt32(bitPattern: num) >> UInt32(bitPattern: count)
        return Int32(bitPattern: value)
    }
    
}
