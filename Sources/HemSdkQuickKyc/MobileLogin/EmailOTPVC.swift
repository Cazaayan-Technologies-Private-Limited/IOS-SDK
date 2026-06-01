//
//  EmailOTPVC.swift
//  t5
//
//  Created by manas dutta on 12/12/25.
//

import UIKit

protocol EmailOTPDelegate: AnyObject {
    func didTapChangeButton(with email: String, userId: String?, sessionID: String?, phoneNumber: String?)
}

class EmailOTPVC: UIViewController, UITextFieldDelegate{
//    func didSelectRelation(_ relation: String) {
//        print("relation \(relation)")
//        DispatchQueue.main.async {
//            self.relationshipBtn.setTitle(relation, for: .normal)
//            //self.relationshipBtn.isEnabled = false
//            self.relation = relation
//        }
//    }

    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var ResendOTP: UIButton!
    @IBOutlet weak var otpTF1: UITextField!
    @IBOutlet weak var otpTF2: UITextField!
    @IBOutlet weak var otpTF3: UITextField!
    @IBOutlet weak var otpTF4: UITextField!
    @IBOutlet weak var otpTF5: UITextField!
    @IBOutlet weak var otpTF6: UITextField!

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var homeBtn: UIButton!
    
    var relation:String?
    var mobileRelation : String?
    var EmailID : String?
    var userId:String?
    var sessionID : String?
    var phoneNumber : String?
    var relations: [[String: Any]] = []
    var timer: Timer?
    var remainingSeconds = 60
    var MD5ByteArray = [UInt8]()
    var OTP = String()
    weak var delegate: EmailOTPDelegate?
    var otpTextFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        otpTextFields = [otpTF1, otpTF2, otpTF3, otpTF4, otpTF5, otpTF6]
        setupOTPFields()
        startTimer()
        setupResendButton()

        Label1.text = "We have sent a 6 digit code to \(EmailID ?? "")"
        emailVerification(EmailID: EmailID ?? "")
        ResendOTP.tintColor = .appBackground
       // homeBtn.tintColor = .appPrimary
        
        otpTF1.layer.cornerRadius = 10300
        otpTF1.layer.cornerRadius = 10
        otpTF1.layer.cornerRadius = 10
        otpTF1.layer.cornerRadius = 10
        otpTF1.layer.cornerRadius = 10
        otpTF1.layer.cornerRadius = 10
        
        view1.layer.cornerRadius = 10
        view2.layer.cornerRadius = 10
        view3.layer.cornerRadius = 10
        view4.layer.cornerRadius = 10
        view5.layer.cornerRadius = 10
        view6.layer.cornerRadius = 10
        
        view1.layer.borderWidth = 0.5
        view2.layer.borderWidth = 0.5
        view3.layer.borderWidth = 0.5
        view4.layer.borderWidth = 0.5
        view5.layer.borderWidth = 0.5
        view6.layer.borderWidth = 0.5
        
        view1.layer.borderColor = UIColor.appBorder.cgColor
        view2.layer.borderColor = UIColor.appBorder.cgColor
        view3.layer.borderColor = UIColor.appBorder.cgColor
        view4.layer.borderColor = UIColor.appBorder.cgColor
        view5.layer.borderColor = UIColor.appBorder.cgColor
        view6.layer.borderColor = UIColor.appBorder.cgColor
        
        self.navigationItem.hidesBackButton = true
    }
    
    func setupOTPFields() {
        for (index, tf) in otpTextFields.enumerated() {
            tf.delegate = self
            tf.keyboardType = .numberPad
            tf.textAlignment = .center
            tf.tag = index
            tf.addTarget(self, action: #selector(otpTextChanged(_:)), for: .editingChanged)
        }
        otpTF1.becomeFirstResponder()
    }
    
    @objc func otpTextChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }

        // Allow only 1 digit
        if text.count > 1 {
            textField.text = String(text.last!)
        }

        if text.count == 1 {
            let nextTag = textField.tag + 1
            if nextTag < otpTextFields.count {
                otpTextFields[nextTag].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                verifyOTPIfNeeded()
            }
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        if string.isEmpty { // backspace
            textField.text = ""
            let prevTag = textField.tag - 1
            if prevTag >= 0 {
                otpTextFields[prevTag].becomeFirstResponder()
            }
            return false
        }

        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
    }
    
    func getEnteredOTP() -> String {
        return otpTextFields.compactMap { $0.text }.joined()
    }
    
    func verifyOTPIfNeeded() {
        let otp = getEnteredOTP()
        if otp.count == 6 {
            if let EmailID = EmailID {
                OtpVerification(EmailID: EmailID, otp: otp)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        
    }
    
    @IBAction func homeBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
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
            TimerLabel.text = String(format: "%02d:%02d  /", minutes, seconds)
        } else {
            timer?.invalidate()
            ResendOTP.isEnabled = true // Enable ResendOTP button when the timer ends
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.count == 6 {
            if let EmailID = EmailID {
                OtpVerification(EmailID: EmailID, otp: OTP)
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
//    
    func clearOTPFields() {
        otpTextFields.forEach { $0.text = "" }
        otpTF1.becomeFirstResponder()
    }
    
    
    func OtpVerification(EmailID: String, otp: String) {
//        guard let otp = otpTF.text, !otp.isEmpty else {
//            showAlert(message: "Please enter the OTP")
//            return
//        }
        print(otp)
        
        print("MDF Hasable : \(MD5(otp))")
        //Convert raw string to byte Array
        print("MD5ByteArray : \(MD5ByteArray)")
        let decodeByteArrayToString = String(decoding: MD5ByteArray, as: UTF8.self)
        // Save the decoded byte array string to the OTP variable
        //OTP = decodeByteArrayToString
        print("md5Converted :-->\(decodeByteArrayToString)")
        // Convert string to data
        let stringToData = Data(decodeByteArrayToString.utf8)
        // Convert data to UTF-8 Encoding String
        _ = String(data: stringToData, encoding: String.Encoding.utf8)!
        
        let parameters: [String: Any] = [
            "PanNo":"",
            "EmailAddress":EmailID,
            "DeviceType":"W",
            "RmCode":"",
            "OTP":otp
        ]
        if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) {
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            print("Request URL: https://signup.hemnxt.com:84/V4.0.0/api/TPManagement/ValidateEmailOTP")
            print("HTTP Method: POST")
            print("Request Parameters: \(jsonString)")
        }
       
        let otpUrl = "OTPManagement/ValidateEmailOTP"
        apiCall(url: otpUrl, method: "POST", parameters: parameters, view: self.view,loaderText: "verifying OTP, please wait...") { result in
            switch result {
            case .success(let jsonResponse):
                print("2nd Response: \(jsonResponse)")
                let ErrorMessage = jsonResponse["ErrorMessage"] as? String
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "400004":
                        DispatchQueue.main.async {
                            self.UserCreationDetails(EmailID: EmailID, decodedString: decodeByteArrayToString)
                        }
                    case "400002":
                        DispatchQueue.main.async {
                            self.showTemporaryAlert(message: ErrorMessage ?? "")
                            //self.otpTF?.text = nil
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
    func navigateToEmailIdVC(emailID: String, decodedString: String) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "PanVerifyVC") as? PanVerifyVC {
            vc.emailID = emailID
            vc.decodedString = decodedString
            vc.phoneNumber = phoneNumber
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func emailVerification(EmailID: String){
        
        let parameters: [String: Any] = [
            "PanNo":"",
            "EmailAddress":EmailID,
            "DeviceType":"W",
            "RmCode":"",
            "MobileRelation":mobileRelation,
            "OTP":""
        ]
        
        let emailURL = "OTPManagement/SendOTPToEmailClient"
        
        apiCall(url: emailURL, method: "POST", parameters: parameters, view: self.view,loaderText: "getting OTP, please wait...") { result in
            switch result {
            case .success(let jsonResponse):
                print("1st Response: \(jsonResponse)")
                
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "000000":
                        DispatchQueue.main.async {
                            
                            
                            if let relationsDict = jsonResponse["Relations"] as? [String: Any],
                               let relationsList = relationsDict["list"] as? [[String: Any]] {
                                self.relations = relationsList // Save the relations data
                               // self.setRelationshipButton() // Set button title and selection state
                            } else {
                                print("Error: Could not parse 'Relations' from response")
                            }
                            print(jsonResponse)
                            self.showTemporaryAlert(message: "OTP sent successfully")
                            print("otp generation is called")
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
    //    func setRelationshipButton() {
    //        if let selectedRelation = relations.first(where: { $0["DefaultSelect"] as? Int == 1 }) {
    //            let relationName = selectedRelation["Relation"] as? String ?? "Select Relationship"
    //            relation = relationName
    //            relationshipBtn.setTitle(relationName, for: .normal)
    //            relationshipBtn.isEnabled = false // Disable if there's a selected relation
    //        } else {
    //            relationshipBtn.setTitle("Select Relationship", for: .normal)
    //            relationshipBtn.isEnabled = true // Enable if no pre-selected relation
    //        }
    //    }
    
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
    
    // /UserCreationDetails/InsertClientRegister
    func UserCreationDetails(EmailID: String,decodedString: String){
        
        var parameters: [String: Any?] = [
            "PanNo":"",
            "EmailAddress":EmailID,
            "DeviceType":"W",
            "RmCode":"",
            "OTP":decodedString,
            "IsDpExternal":"0",
            "DPBrokerCode":"",
            "SessionId":"",
            "IPAddress":"1",
            "ReferEarnClientId":"",
            "UserName":"SDSFD",
            "EmailRelation":"SELF",
            "MobileRelation":"SELF",
            "MobileNumber":phoneNumber
        ]
        
        for (key, value) in parameters {
            if let stringValue = value as? String, stringValue.isEmpty {
                parameters[key] = nil
            }
        }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) {
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            print("UserCreationDetails/InsertClientRegister")
            print("HTTP Method: POST")
            print("Request Parameters: \(jsonString)")
        }
        let emailURL = "UserCreationDetails/InsertClientRegister"
        
        apiCall(url: emailURL, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
            switch result {
            case .success(let jsonResponse):
                print("3rd Response: \(jsonResponse)")
                let UserID = jsonResponse["UserID"] as? String
                let EmailAddress = jsonResponse["EmailAddress"] as? String
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "900006":
                        DispatchQueue.main.async {
                            self.PanPage(userId: UserID ?? "", EmailId: EmailAddress ?? "")
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
    
    func PanPage(userId: String, EmailId: String) {
        let storyboard = UIStoryboard(name: "DashboardVC", bundle: Bundle.module)  // Explicitly load from package
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "PanVerifyVC") as? PanVerifyVC else {
            print("❌ Failed to instantiate PanVerifyVC – double-check Module is 't5' or Inherit from Target")
            return
        }
        
        vc.MobileUserID = userId
        vc.emailID = EmailId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func ChangeBtn(_ sender: UIButton) {
        if let email = EmailID {
            delegate?.didTapChangeButton(with: email, userId: userId, sessionID: sessionID, phoneNumber: phoneNumber)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ResendOtpBtn(_ sender: Any) {
        remainingSeconds = 60
        ResendOTP.isEnabled = false // Disable the button again
        startTimer()
        emailVerification(EmailID: EmailID!)
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

extension EmailOTPVC{
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
