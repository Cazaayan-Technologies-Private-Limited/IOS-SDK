//
//  ViewController.swift
//  t5
//
//  Created by manas dutta on 11/12/25.
//


//import UIKit
//
//class NewAccountVC: UIViewController, UITextFieldDelegate,@MainActor mobileOtpDelegate {
//    func didtapChangeBtn(with phoneNumber: String) {
//        NumberTF.text = phoneNumber
//    }
//    @IBOutlet weak var termsnconditionBtn: UIButton!
//    @IBOutlet weak var NumberTF: UITextField!
//    @IBOutlet weak var RequestBtn: UIButton!
//    @IBOutlet weak var numberView: UIView!
//    @IBOutlet weak var homeBtn: UIButton!
//    @IBOutlet weak var termView: UIView!
//
//    var selectedData: [String: Any]?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        termsnconditionBtn.isSelected = true
//        CoreDataHelper.deleteAllUserIds(entityName: "MobileUser")
//        self.RequestBtn.layer.cornerRadius = 10
//        NumberTF.delegate = self
//        if let data = selectedData {
//            print("Received data: \(data)")
//            self.NumberTF.text = data["MobileNo"] as? String
//        }
//        view.backgroundColor = .white
//
//        numberView.layer.cornerRadius = 20
//        numberView.layer.borderWidth = 0.5
//        numberView.layer.borderColor = UIColor.appBorder.cgColor
//        
//        termsnconditionBtn.layer.cornerRadius = 20
//        termsnconditionBtn.layer.borderWidth = 0.5
//        termsnconditionBtn.layer.borderColor = UIColor.appBorder.cgColor
//        homeBtn.tintColor = .appPrimary
//        RequestBtn.backgroundColor = .appPrimary
//        view.backgroundColor = .appBackground
//        termView.backgroundColor = .clear
//        
//    }
//    
//    
//    @IBAction func backBtn(_ sender: UIButton) {
//        self.navigationController?.popToRootViewController(animated: true)
//    }
//    
//    
//    @IBAction func RequestOtpBtn(_ sender: UIButton) {
//        guard termsnconditionBtn.isSelected else {
//            showAlert(message: "Please accept the terms and conditions")
//            return
//        }
//        guard let phoneNumber = NumberTF.text, !phoneNumber.isEmpty else {
//            // Handle empty phone number case
//            showAlert(message: "Please enter a phone number")
//            return
//        }
//        if phoneNumber.count != 10 {
//            showAlert(message: "Please enter a valid 10-digit phone number")
//            return
//        }
//        // Check if the phone number is made up of repeated digits
//        if isRepeatedDigitNumber(phoneNumber: phoneNumber) {
//            showAlert(message: "Invalid mobile number. Please enter a valid number.")
//            return
//        }
//        performFirstApiCall(phoneNumber: phoneNumber)
//    }
//    
//    func createRequest(url: URL, parameters: [String: Any]) -> URLRequest {
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
//        return request
//    }
//    
//    func performFirstApiCall(phoneNumber: String) {
//        let firstApiUrl =  "Registration/CheckBlockTableRecord"
//        let parameters: [String: Any] = [
//            "MobileNo": "",
//            "DeviceType": "W",
//            "RmCode": "",
//            "Branch": "",
//            "PhoneNumber": phoneNumber,
//            "OTP": ""
//        ]
//        
//        apiCall(url: firstApiUrl, method: "POST", parameters: parameters, view: self.view,loaderText: "please wait...") { result in
//            switch result {
//            case .success(let jsonResponse):
//                print("Login Response: \(jsonResponse)")
//                
//                if let errorCode = jsonResponse["ErrorCode"] as? String {
//                    switch errorCode {
//                    case "200000":
//                        DispatchQueue.main.async {
//                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MobileOTPVC") as? MobileOTPVC {
//                                vc.phoneNumber = phoneNumber
//                                //vc.errorCodes = errorCode
//                                self.navigationController?.pushViewController(vc, animated: true)
//                            }
//                        }
//                    case "000000":
//                        DispatchQueue.main.async {
//                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MobileOTPVC") as? MobileOTPVC {
//                                vc.phoneNumber = phoneNumber
//                                //vc.errorCodes = errorCode
//                                self.navigationController?.pushViewController(vc, animated: true)
//                            }
//                        }
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
//    func isRepeatedDigitNumber(phoneNumber: String) -> Bool {
//        // Check if the phone number has all the same digits
//        let firstChar = phoneNumber.first
//        for char in phoneNumber {
//            if char != firstChar {
//                return false // If any character is different, it's a valid number
//            }
//        }
//        return true // All characters are the same
//    }
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // Limit to 10 characters
//        let maxLength = 10
//        
//        // Current text in the text field
//        let currentString: NSString = textField.text as NSString? ?? ""
//        
//        // New string with the replacement
//        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
//        
//        // Only allow numbers and restrict to 10 digits
//        let allowedCharacterSet = CharacterSet.decimalDigits
//        let replacementCharacterSet = CharacterSet(charactersIn: string)
//        
//        let isReplacementStringNumeric = allowedCharacterSet.isSuperset(of: replacementCharacterSet)
//        
//        return newString.length <= maxLength && isReplacementStringNumeric
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
//    //
//    @IBAction func TCbtn(_ sender: UIButton) {
//        if sender.isSelected {
//            // If the button is selected and user clicks, deselect it and show terms and conditions page
//            sender.isSelected = false
//            let storyboard = UIStoryboard(name: "terms", bundle: Bundle.module)
//            if let vc = storyboard.instantiateViewController(withIdentifier: "termsVC") as? termsVC {
//                vc.modalPresentationStyle = .overCurrentContext
//                vc.modalTransitionStyle = .crossDissolve
//                
//                // Closure or delegate to set the button to selected when termsVC is dismissed
//                vc.dismissHandler = { [weak self] in
//                    self?.termsnconditionBtn.isSelected = true
//                }
//                
//                present(vc, animated: true, completion: nil)
//            }
//        }
//    }
//}
import UIKit

class NewAccountVC: UIViewController, UITextFieldDelegate,@MainActor mobileOtpDelegate {
    func didtapChangeBtn(with phoneNumber: String) {
        NumberTF.text = phoneNumber
    }
    @IBOutlet weak var termsnconditionBtn: UIButton!
    @IBOutlet weak var NumberTF: UITextField!
    @IBOutlet weak var RequestBtn: UIButton!
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var termView: UIView!

    var selectedData: [String: Any]?
    var txnId: String?
    var mobileNumber: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        termsnconditionBtn.isSelected = true
        CoreDataHelper.deleteAllUserIds(entityName: "MobileUser")
        self.RequestBtn.layer.cornerRadius = 10
        NumberTF.delegate = self
        if let data = selectedData {
            print("Received data: \(data)")
            self.NumberTF.text = data["MobileNo"] as? String
        }
        view.backgroundColor = .white

        numberView.layer.cornerRadius = 20
        numberView.layer.borderWidth = 0.5
        numberView.layer.borderColor = UIColor.appBorder.cgColor
        
        termsnconditionBtn.layer.cornerRadius = 20
        termsnconditionBtn.layer.borderWidth = 0.5
        termsnconditionBtn.layer.borderColor = UIColor.appBorder.cgColor
        homeBtn.tintColor = .appPrimary
        RequestBtn.backgroundColor = .appPrimary
        view.backgroundColor = .appBackground
        termView.backgroundColor = .clear
        
        print("🔥 viewDidLoad called")
        print("selectedData:", selectedData ?? "nil")
        
//        let hardcodedTxnId = "13192c07-6eb0-450d-aa07-f103d2d7db89"
//        let phoneNumber = "7666188609"
//        validateTxnIdAPI(txnId: hardcodedTxnId, phoneNumber: phoneNumber)
        
        if let data = selectedData,
              let mobile = data["MobileNo"] as? String,
              !mobile.isEmpty {
               print("Received data: \(data)")
               
               self.mobileNumber = mobile
               self.NumberTF.text = mobile
               self.NumberTF.isEnabled = false
               
               // ✅ CALL API ON LOAD
               initiateLoginAPI(phoneNumber: mobile)
           }
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func RequestOtpBtn(_ sender: UIButton) {
        guard termsnconditionBtn.isSelected else {
            showAlert(message: "Please accept the terms and conditions")
            return
        }
        guard let phoneNumber = NumberTF.text, !phoneNumber.isEmpty else {
            // Handle empty phone number case
            showAlert(message: "Please enter a phone number")
            return
        }
        if phoneNumber.count != 10 {
            showAlert(message: "Please enter a valid 10-digit phone number")
            return
        }
        // Check if the phone number is made up of repeated digits
        if isRepeatedDigitNumber(phoneNumber: phoneNumber) {
            showAlert(message: "Invalid mobile number. Please enter a valid number.")
            return
        }
        if let vc = storyboard?.instantiateViewController(withIdentifier: "MobileOTPVC") as? MobileOTPVC {
              vc.phoneNumber = phoneNumber
              vc.txnId = txnId
              navigationController?.pushViewController(vc, animated: true)
          }
    }
    
    func createRequest(url: URL, parameters: [String: Any]) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        return request
    }
    
    func performFirstApiCall(phoneNumber: String) {
        let firstApiUrl =  "Registration/CheckBlockTableRecord"
        let parameters: [String: Any] = [
            "MobileNo": "",
            "DeviceType": "W",
            "RmCode": "",
            "Branch": "",
            "PhoneNumber": phoneNumber,
            "OTP": ""
        ]
        
        apiCall(url: firstApiUrl, method: "POST", parameters: parameters, view: self.view,loaderText: "please wait...") { result in
            switch result {
            case .success(let jsonResponse):
                print("Login Response: \(jsonResponse)")
                
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "200000":
                        DispatchQueue.main.async {
                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MobileOTPVC") as? MobileOTPVC {
                                vc.phoneNumber = phoneNumber
                                //vc.errorCodes = errorCode
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    case "000000":
                        DispatchQueue.main.async {
                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MobileOTPVC") as? MobileOTPVC {
                                vc.phoneNumber = phoneNumber
                                //vc.errorCodes = errorCode
                                self.navigationController?.pushViewController(vc, animated: true)
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
//    
//    func initiateLoginAPI(phoneNumber: String) {
//        
//        let url = URL(string: "https://signup.hemnxt.com:84/V4.0.0/api/OTPManagement/InitiateLogin")!
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("cz_live_rdf5QYYl8z1lPEXLuw3y0e22gq05uUuU", forHTTPHeaderField: "api-key")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let body: [String: Any] = [
//            "MobileNo": phoneNumber
//        ]
//        
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            
//            guard let data = data else { return }
//            
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
//                   let txnId = json["TxnId"] as? String {
//                    
//                    print("TxnId:", txnId)
//                    
//                    // 👉 STEP 2: Validate TxnId
//                    self.validateTxnIdAPI(txnId: txnId, phoneNumber: phoneNumber)
//                }
//            } catch {
//                print("Error:", error)
//            }
//            
//        }.resume()
//    }
    
    func initiateLoginAPI(phoneNumber: String) {
        
        let url = URL(string: "https://signup.hemnxt.com:84/V4.0.0/api/OTPManagement/InitiateLogin")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("cz_live_rdf5QYYl8z1lPEXLuw3y0e22gq05uUuU", forHTTPHeaderField: "api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "MobileNo": phoneNumber
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // ✅ PRINT EVERYTHING
            print("-------- INITIATE LOGIN API --------")
            
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Status Code:", response.statusCode)
            }
            
            guard let data = data else {
                print("No Data Received")
                return
            }
            
            print("Raw Response:", String(data: data, encoding: .utf8) ?? "")
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    
                    print("Parsed JSON:", json)
                    
                    if let txnId = json["TxnId"] as? String {
                        
                        print("TxnId:", txnId)
                        
                        DispatchQueue.main.async {
                            self.validateTxnIdAPI(txnId: txnId, phoneNumber: phoneNumber)
                        }
                        
                    } else {
                        print("TxnId not found in response ❌")
                    }
                }
            } catch {
                print("JSON Parsing Error:", error)
            }
            
        }.resume()
    }
    
    func validateTxnIdAPI(txnId: String, phoneNumber: String) {
        
        let url = URL(string: "https://signup.hemnxt.com:84/V4.0.0/api/OTPManagement/ValidateTxnId")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("cz_live_rdf5QYYl8z1lPEXLuw3y0e22gq05uUuU", forHTTPHeaderField: "api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "TxnId": txnId
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            print("-------- VALIDATE TXN API --------")
            
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Status Code:", response.statusCode)
            }
            
            guard let data = data else {
                print("No Data Received")
                return
            }
            
            // ✅ PRINT RAW RESPONSE
            print("Raw Response:", String(data: data, encoding: .utf8) ?? "")
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    
                    print("Parsed JSON:", json)
                    
                    DispatchQueue.main.async {
                        
                        print("Txn Validated ✅")
                        
                        // ✅ Get MobileNo from response
                        if let mobile = json["MobileNo"] as? String {
                            
                            print("Mobile from API:", mobile)
                            
                            self.mobileNumber = mobile
                            self.txnId = txnId
                            
                            // ✅ Set in textfield
                            self.NumberTF.text = mobile
                            
                            // ✅ Disable editing
                            self.NumberTF.isEnabled = false
                        }
                    }
                }
            } catch {
                print("JSON Parsing Error:", error)
            }
            
        }.resume()
    }
    
    func isRepeatedDigitNumber(phoneNumber: String) -> Bool {
        // Check if the phone number has all the same digits
        let firstChar = phoneNumber.first
        for char in phoneNumber {
            if char != firstChar {
                return false // If any character is different, it's a valid number
            }
        }
        return true // All characters are the same
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Limit to 10 characters
        let maxLength = 10
        
        // Current text in the text field
        let currentString: NSString = textField.text as NSString? ?? ""
        
        // New string with the replacement
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        // Only allow numbers and restrict to 10 digits
        let allowedCharacterSet = CharacterSet.decimalDigits
        let replacementCharacterSet = CharacterSet(charactersIn: string)
        
        let isReplacementStringNumeric = allowedCharacterSet.isSuperset(of: replacementCharacterSet)
        
        return newString.length <= maxLength && isReplacementStringNumeric
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func homeBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    //
    @IBAction func TCbtn(_ sender: UIButton) {
        if sender.isSelected {
            // If the button is selected and user clicks, deselect it and show terms and conditions page
            sender.isSelected = false
            let storyboard = UIStoryboard(name: "terms", bundle: Bundle.module)
            if let vc = storyboard.instantiateViewController(withIdentifier: "termsVC") as? termsVC {
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                
                // Closure or delegate to set the button to selected when termsVC is dismissed
                vc.dismissHandler = { [weak self] in
                    self?.termsnconditionBtn.isSelected = true
                }
                
                present(vc, animated: true, completion: nil)
            }
        }
    }
}



//import UIKit
//
//class NewAccountVC: UIViewController, UITextFieldDelegate,@MainActor mobileOtpDelegate {
//    func didtapChangeBtn(with phoneNumber: String) {
//        NumberTF.text = phoneNumber
//    }
//    @IBOutlet weak var termsnconditionBtn: UIButton!
//    @IBOutlet weak var NumberTF: UITextField!
//    @IBOutlet weak var RequestBtn: UIButton!
//    @IBOutlet weak var numberView: UIView!
//    @IBOutlet weak var homeBtn: UIButton!
//    @IBOutlet weak var termView: UIView!
//
//    var selectedData: [String: Any]?
//    var txnId: String?
//    var mobileNumber: String?
//    var fetchedUserId: String?
//    var decodeArray: String?
//    var fetchedSessionID: String?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        termsnconditionBtn.isSelected = true
//        CoreDataHelper.deleteAllUserIds(entityName: "MobileUser")
//        self.RequestBtn.layer.cornerRadius = 10
//        NumberTF.delegate = self
//        if let data = selectedData {
//            print("Received data: \(data)")
//            self.NumberTF.text = data["MobileNo"] as? String
//        }
//        view.backgroundColor = .white
//
//        numberView.layer.cornerRadius = 20
//        numberView.layer.borderWidth = 0.5
//        numberView.layer.borderColor = UIColor.appBorder.cgColor
//        
//        termsnconditionBtn.layer.cornerRadius = 20
//        termsnconditionBtn.layer.borderWidth = 0.5
//        termsnconditionBtn.layer.borderColor = UIColor.appBorder.cgColor
//        homeBtn.tintColor = .appPrimary
//        RequestBtn.backgroundColor = .appPrimary
//        view.backgroundColor = .appBackground
//        termView.backgroundColor = .clear
//        
//        print("🔥 viewDidLoad called")
//        print("selectedData:", selectedData ?? "nil")
//        
////        let hardcodedTxnId = "13192c07-6eb0-450d-aa07-f103d2d7db89"
////        let phoneNumber = "7666188609"
////        validateTxnIdAPI(txnId: hardcodedTxnId, phoneNumber: phoneNumber)
//        
//        if let data = selectedData,
//              let mobile = data["MobileNo"] as? String,
//              !mobile.isEmpty {
//               print("Received data: \(data)")
//               
//               self.mobileNumber = mobile
//               self.NumberTF.text = mobile
//               self.NumberTF.isEnabled = false
//               
//               // ✅ CALL API ON LOAD
//               initiateLoginAPI(phoneNumber: mobile)
//           }
//    }
//    
//    
//    @IBAction func backBtn(_ sender: UIButton) {
//        self.navigationController?.popToRootViewController(animated: true)
//    }
//    
//    
//    @IBAction func RequestOtpBtn(_ sender: UIButton) {
//        
//        guard termsnconditionBtn.isSelected else {
//            showAlert(message: "Please accept the terms and conditions")
//            return
//        }
//        
//        guard let phoneNumber = NumberTF.text, !phoneNumber.isEmpty else {
//            showAlert(message: "Please enter a phone number")
//            return
//        }
//        
//        if phoneNumber.count != 10 {
//            showAlert(message: "Please enter a valid 10-digit phone number")
//            return
//        }
//        
//        if isRepeatedDigitNumber(phoneNumber: phoneNumber) {
//            showAlert(message: "Invalid mobile number.")
//            return
//        }
//        
//        // ✅ Call SIXTH API BEFORE navigation
//        SIXTHAPI(userID: fetchedUserId ?? "") { success, errorMsg in
//            
//            DispatchQueue.main.async {
//                
//                if success {
//                    // ✅ Only navigate if API is success
//                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MobileOTPVC") as? MobileOTPVC {
//                        vc.phoneNumber = phoneNumber
//                        vc.txnId = self.txnId
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }
//                    
//                } else {
//                    // ❌ Show error here
//                    self.showAlert(message: errorMsg ?? "Something went wrong")
//                }
//            }
//        }
//    }
//    
////    @IBAction func RequestOtpBtn(_ sender: UIButton) {
////        guard termsnconditionBtn.isSelected else {
////            showAlert(message: "Please accept the terms and conditions")
////            return
////        }
////        guard let phoneNumber = NumberTF.text, !phoneNumber.isEmpty else {
////            // Handle empty phone number case
////            showAlert(message: "Please enter a phone number")
////            return
////        }
////        if phoneNumber.count != 10 {
////            showAlert(message: "Please enter a valid 10-digit phone number")
////            return
////        }
////        // Check if the phone number is made up of repeated digits
////        if isRepeatedDigitNumber(phoneNumber: phoneNumber) {
////            showAlert(message: "Invalid mobile number. Please enter a valid number.")
////            return
////        }
////        if let vc = storyboard?.instantiateViewController(withIdentifier: "MobileOTPVC") as? MobileOTPVC {
////              vc.phoneNumber = phoneNumber
////              vc.txnId = txnId
////              navigationController?.pushViewController(vc, animated: true)
////          }
////    }
//    
//    func createRequest(url: URL, parameters: [String: Any]) -> URLRequest {
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
//        return request
//    }
//    
//    func performFirstApiCall(phoneNumber: String) {
//        let firstApiUrl =  "Registration/CheckBlockTableRecord"
//        let parameters: [String: Any] = [
//            "MobileNo": "",
//            "DeviceType": "W",
//            "RmCode": "",
//            "Branch": "",
//            "PhoneNumber": phoneNumber,
//            "OTP": ""
//        ]
//        
//        apiCall(url: firstApiUrl, method: "POST", parameters: parameters, view: self.view,loaderText: "please wait...") { result in
//            switch result {
//            case .success(let jsonResponse):
//                print("Login Response: \(jsonResponse)")
//                
//                if let errorCode = jsonResponse["ErrorCode"] as? String {
//                    switch errorCode {
//                    case "200000":
//                        DispatchQueue.main.async {
//                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MobileOTPVC") as? MobileOTPVC {
//                                vc.phoneNumber = phoneNumber
//                                //vc.errorCodes = errorCode
//                                self.navigationController?.pushViewController(vc, animated: true)
//                            }
//                        }
//                    case "000000":
//                        DispatchQueue.main.async {
//                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MobileOTPVC") as? MobileOTPVC {
//                                vc.phoneNumber = phoneNumber
//                                //vc.errorCodes = errorCode
//                                self.navigationController?.pushViewController(vc, animated: true)
//                            }
//                        }
//                    default:
//                        print("Unhandled error code: \(errorCode)")
//                    }
//                }
//            case .failure(let error):
//                print("Login API call failed: \(error.localizedDescription)")
//            }
//        }
//    }
////
////    func initiateLoginAPI(phoneNumber: String) {
////
////        let url = URL(string: "https://signup.hemnxt.com:84/V4.0.0/api/OTPManagement/InitiateLogin")!
////
////        var request = URLRequest(url: url)
////        request.httpMethod = "POST"
////        request.setValue("cz_live_rdf5QYYl8z1lPEXLuw3y0e22gq05uUuU", forHTTPHeaderField: "api-key")
////        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
////
////        let body: [String: Any] = [
////            "MobileNo": phoneNumber
////        ]
////
////        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
////
////        URLSession.shared.dataTask(with: request) { data, response, error in
////
////            guard let data = data else { return }
////
////            do {
////                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
////                   let txnId = json["TxnId"] as? String {
////
////                    print("TxnId:", txnId)
////
////                    // 👉 STEP 2: Validate TxnId
////                    self.validateTxnIdAPI(txnId: txnId, phoneNumber: phoneNumber)
////                }
////            } catch {
////                print("Error:", error)
////            }
////
////        }.resume()
////    }
//    
//    func initiateLoginAPI(phoneNumber: String) {
//        
//        let url = URL(string: "https://signup.hemnxt.com:84/V4.0.0/api/OTPManagement/InitiateLogin")!
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("cz_live_rdf5QYYl8z1lPEXLuw3y0e22gq05uUuU", forHTTPHeaderField: "api-key")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let body: [String: Any] = [
//            "MobileNo": phoneNumber
//        ]
//        
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            
//            // ✅ PRINT EVERYTHING
//            print("-------- INITIATE LOGIN API --------")
//            
//            if let error = error {
//                print("Error:", error.localizedDescription)
//                return
//            }
//            
//            if let response = response as? HTTPURLResponse {
//                print("Status Code:", response.statusCode)
//            }
//            
//            guard let data = data else {
//                print("No Data Received")
//                return
//            }
//            
//            print("Raw Response:", String(data: data, encoding: .utf8) ?? "")
//            
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                    
//                    print("Parsed JSON:", json)
//                    
//                    if let txnId = json["TxnId"] as? String {
//                        
//                        print("TxnId:", txnId)
//                        
//                        DispatchQueue.main.async {
//                            self.validateTxnIdAPI(txnId: txnId, phoneNumber: phoneNumber)
//                        }
//                        
//                    } else {
//                        print("TxnId not found in response ❌")
//                    }
//                }
//            } catch {
//                print("JSON Parsing Error:", error)
//            }
//            
//        }.resume()
//    }
//    
//    func validateTxnIdAPI(txnId: String, phoneNumber: String) {
//        
//        let url = URL(string: "https://signup.hemnxt.com:84/V4.0.0/api/OTPManagement/ValidateTxnId")!
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("cz_live_rdf5QYYl8z1lPEXLuw3y0e22gq05uUuU", forHTTPHeaderField: "api-key")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let body: [String: Any] = [
//            "TxnId": txnId
//        ]
//        
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            
//            print("-------- VALIDATE TXN API --------")
//            
//            if let error = error {
//                print("Error:", error.localizedDescription)
//                return
//            }
//            
//            if let response = response as? HTTPURLResponse {
//                print("Status Code:", response.statusCode)
//            }
//            
//            guard let data = data else {
//                print("No Data Received")
//                return
//            }
//            
//            // ✅ PRINT RAW RESPONSE
//            print("Raw Response:", String(data: data, encoding: .utf8) ?? "")
//            
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                    
//                    print("Parsed JSON:", json)
//                    
//                    DispatchQueue.main.async {
//                        
//                        print("Txn Validated ✅")
//                        
//                        // ✅ Get MobileNo from response
//                        if let mobile = json["MobileNo"] as? String {
//                            
//                            print("Mobile from API:", mobile)
//                            
//                            self.mobileNumber = mobile
//                            self.txnId = txnId
//                            
//                            // ✅ Set in textfield
//                            self.NumberTF.text = mobile
//                            
//                            // ✅ Disable editing
//                            self.NumberTF.isEnabled = false
//                        }
//                    }
//                }
//            } catch {
//                print("JSON Parsing Error:", error)
//            }
//            
//        }.resume()
//    }
//    
//    func SIXTHAPI(userID: String, completion: @escaping (Bool, String?) -> Void) {
//        
//        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
//            guard let self = self else { return }
//            
//            if let userId = userId, let sessionID = sessionID {
//                self.fetchedUserId = userId
//                self.fetchedSessionID = sessionID
//                self.decodeArray = decodeByteArrayString
//            }
//        }
//        
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { tokenId in
//            guard let tokenId = tokenId else {
//                completion(false, "Token not available")
//                return
//            }
//            
//            let parameters: [String: Any] = [
//                "UserId": userID,
//                "TokenId": tokenId,
//                "UserIDSL": userID,
//                "MobileNo": self.mobileNumber ?? "",
//                "Flag": "An"
//            ]
//            
//            let sixthUrl = "ActiveApplication/GetActiveApplicationCL"
//            
//            apiCall(url: sixthUrl, method: "POST", parameters: parameters, view: self.view) { result in
//                
//                switch result {
//                case .success(let jsonResponse):
//                    
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        
//                        switch errorCode {
//                            
//                        case "000001":
//                            let msg = jsonResponse["ErrorMessage"] as? String ?? "Something went wrong"
//                            completion(false, msg)   // ❌ STOP FLOW
//                            
//                        case "000000":
//                            completion(true, nil)   // ✅ SUCCESS
//                            
//                        case "999992":
//                            CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
//                            completion(false, "Session expired. Retry.")
//                            
//                        default:
//                            completion(false, "Unhandled error")
//                        }
//                    }
//                    
//                case .failure(let error):
//                    completion(false, error.localizedDescription)
//                }
//            }
//        }
//    }
//    
//    func isRepeatedDigitNumber(phoneNumber: String) -> Bool {
//        // Check if the phone number has all the same digits
//        let firstChar = phoneNumber.first
//        for char in phoneNumber {
//            if char != firstChar {
//                return false // If any character is different, it's a valid number
//            }
//        }
//        return true // All characters are the same
//    }
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // Limit to 10 characters
//        let maxLength = 10
//        
//        // Current text in the text field
//        let currentString: NSString = textField.text as NSString? ?? ""
//        
//        // New string with the replacement
//        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
//        
//        // Only allow numbers and restrict to 10 digits
//        let allowedCharacterSet = CharacterSet.decimalDigits
//        let replacementCharacterSet = CharacterSet(charactersIn: string)
//        
//        let isReplacementStringNumeric = allowedCharacterSet.isSuperset(of: replacementCharacterSet)
//        
//        return newString.length <= maxLength && isReplacementStringNumeric
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
//    //
//    @IBAction func TCbtn(_ sender: UIButton) {
//        if sender.isSelected {
//            // If the button is selected and user clicks, deselect it and show terms and conditions page
//            sender.isSelected = false
//            let storyboard = UIStoryboard(name: "terms", bundle: Bundle.module)
//            if let vc = storyboard.instantiateViewController(withIdentifier: "termsVC") as? termsVC {
//                vc.modalPresentationStyle = .overCurrentContext
//                vc.modalTransitionStyle = .crossDissolve
//                
//                // Closure or delegate to set the button to selected when termsVC is dismissed
//                vc.dismissHandler = { [weak self] in
//                    self?.termsnconditionBtn.isSelected = true
//                }
//                
//                present(vc, animated: true, completion: nil)
//            }
//        }
//    }
//}
