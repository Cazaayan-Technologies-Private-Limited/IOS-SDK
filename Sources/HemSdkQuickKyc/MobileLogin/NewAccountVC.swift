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

    @IBOutlet weak var NumberTF: UITextField!
    @IBOutlet weak var RequestBtn: UIButton!
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var buttonView: UIView!
    /// Mobile number form (scroll view) – hidden while the TxnId is being validated
    @IBOutlet weak var formScrollView: UIScrollView!
    /// Hem Nxt logo shown while loading
    @IBOutlet weak var logoImageView: UIImageView!
    
    /// Makes sure the skip-OTP login chain starts only once
    private var hasStartedLoginFlow = false
    

    var selectedData: [String: Any]?
    var txnId: String?
    var mobileNumber: String?
    
    var decodeArray: String?
    var fetchedUserId: String?
    var LoginUserId: String?
    var fetchedSessionID: String?
    var relation:String?
    var userID = String()
    var sessionID = String()
    var errorCodes : String = ""
    
    var panNo: String?
//        var phoneNumber : String?
//        var timer: Timer?
//        var remainingSeconds = 60
//        var MD5ByteArray = [UInt8]()
//        var OTP : String = ""
//        var enteredOTP: String?
        var regId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
//        termsnconditionBtn.isSelected = true
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

        buttonView.backgroundColor = .appPrimary
        buttonView.layer.cornerRadius = 20
        
        print("🔥 viewDidLoad called")
        print("selectedData:", selectedData ?? "nil")
        print("Transaction ID:", txnId ?? "")
        print("Mobile Number:", mobileNumber ?? "")
        
        //let hardcodedTxnId = "13192c07-6eb0-450d-aa07-f103d2d7db89"
        //let phoneNumber = "7666188609"
        // Start exactly one flow:
        //  1. TxnId given           → validate it → skip-OTP flow (any error → alert, SDK closes)
        //  2. Only mobile given     → InitiateLogin → validate the new TxnId
        //  3. Nothing given         → error alert, SDK closes
        if let txn = txnId, !txn.isEmpty {
            validateTxnIdAPI(txnId: txn, phoneNumber: mobileNumber ?? "")
        } else if let data = selectedData,
                  let mobile = data["MobileNo"] as? String,
                  !mobile.isEmpty {
            print("Received data: \(data)")
            self.mobileNumber = mobile
            self.NumberTF.text = mobile
            self.NumberTF.isEnabled = false
            initiateLoginAPI(phoneNumber: mobile)
        } else {
            print("[HemSDK] No TxnId – showing error")
            showTxnErrorAndClose(message: "Transaction ID is missing. Please try again.")
        }
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = .appBackground
        NumberTF.delegate = self
        setupPhonePrefix()
    }
    
    /// TxnId flow failed → show the error and close the SDK when the user taps OK.
    /// (The mobile number + OTP form stays hidden; only the skip-OTP flow is used.)
    private var isShowingTxnError = false
    /// Error that arrived before the screen was on display – shown in viewDidAppear
    private var pendingTxnError: String?
    /// True once this screen is fully on display (alerts can only be shown after that)
    private var hasAppeared = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hasAppeared = true
        if let message = pendingTxnError {
            pendingTxnError = nil
            showTxnErrorAndClose(message: message)
        }
    }
    
    func showTxnErrorAndClose(message: String) {
        guard !isShowingTxnError else { return }      // never stack two alerts
        // An alert can only be shown once this screen is on display.
        // (Don't use isBeingPresented here – it is still true inside viewDidAppear.)
        guard hasAppeared, view.window != nil else {
            print("[HemSDK] Screen not visible yet – alert will show in viewDidAppear")
            pendingTxnError = message
            return
        }
        // Something else is on top (e.g. another alert) → show ours on top of it
        let presenter: UIViewController = presentedViewController ?? self
        print("[HemSDK] Showing error alert:", message)
        isShowingTxnError = true
        hasStartedLoginFlow = false
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.isShowingTxnError = false
            // Tell the host app why the SDK closed, then close it
            T5Launcher.onSDKClose?(["STATUS": "FAILED", "MESSAGE": message])
            if let nav = self.navigationController, nav.presentingViewController != nil {
                nav.dismiss(animated: true)
            } else {
                self.dismiss(animated: true)
            }
        })
        presenter.present(alert, animated: true)
    }
    
    /// Same as showTxnErrorAndClose, safe to call from URLSession (background) callbacks.
    /// Uses the server's message when there is one, otherwise the fallback text.
    nonisolated private func failTxnFlow(serverMessage: String? = nil, fallback: String) {
        let text = serverMessage?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let message = text.isEmpty ? fallback : text
        Task { @MainActor in
            self.showTxnErrorAndClose(message: message)
        }
    }
    
    func setupPhonePrefix() {

        let prefixLabel = UILabel()
        prefixLabel.text = "  +91  "
        prefixLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        prefixLabel.textColor = .black
        prefixLabel.sizeToFit()

        let containerView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: prefixLabel.frame.width + 10,
                height: NumberTF.frame.height
            )
        )

        prefixLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: prefixLabel.frame.width,
            height: NumberTF.frame.height
        )

        containerView.addSubview(prefixLabel)

        NumberTF.leftView = containerView
        NumberTF.leftViewMode = .always

        NumberTF.keyboardType = .numberPad
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func RequestOtpBtn(_ sender: UIButton) {
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
        if isInvalidMobileNumber(phoneNumber) {
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

    func initiateLoginAPI(phoneNumber: String) {
        
        let url = URL(string: T5Launcher.baseURL + "OTPManagement/InitiateLogin")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("cz_live_rdf5QYYl8z1lPEXLuw3y0e22gq05uUuU", forHTTPHeaderField: "api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "MobileNo": phoneNumber
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            print("-------- INITIATE LOGIN API --------")
            
            if let error = error {
                print("Error:", error.localizedDescription)
                self.failTxnFlow(fallback: "Unable to verify your details. Please check your internet connection and try again.")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Status Code:", response.statusCode)
            }
            
            guard let data = data else {
                print("No Data Received")
                self.failTxnFlow(fallback: "Unable to verify your details. Please try again.")
                return
            }
            
            print("Raw Response:", String(data: data, encoding: .utf8) ?? "")
            
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            if let txnId = json?["TxnId"] as? String, !txnId.isEmpty {
                print("TxnId:", txnId)
                DispatchQueue.main.async {
                    self.validateTxnIdAPI(txnId: txnId, phoneNumber: phoneNumber)
                }
            } else {
                print("TxnId not found in response ❌")
                let serverMessage = json?["ErrorMessage"] as? String
                self.failTxnFlow(serverMessage: serverMessage, fallback: "Unable to verify your details. Please try again.")
            }
            
        }.resume()
    }
    
    func validateTxnIdAPI(txnId: String, phoneNumber: String) {
        
        let url = URL(string: T5Launcher.baseURL+"OTPManagement/ValidateTxnId")!
        
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
                self.failTxnFlow(fallback: "Unable to verify your details. Please check your internet connection and try again.")
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            print("Status Code:", statusCode)
            
            guard let data = data else {
                print("No Data Received")
                self.failTxnFlow(fallback: "Unable to verify your details. Please try again.")
                return
            }
            
            print("Raw Response:", String(data: data, encoding: .utf8) ?? "")
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("ValidateTxnId: invalid JSON")
                self.failTxnFlow(fallback: "Unable to verify your details. Please try again.")
                return
            }
            
            // Valid TxnId = HTTP 2xx, no error code (or "000000"), and a mobile number returned
            let errorCode = json["ErrorCode"] as? String
            let mobile = (json["MobileNo"] as? String)?.trimmingCharacters(in: .whitespaces) ?? ""
            let isValid = (200...299).contains(statusCode)
                && (errorCode == nil || errorCode == "000000")
                && !mobile.isEmpty
            
            guard isValid else {
                print("[HemSDK] TxnId NOT valid (ErrorCode: \(errorCode ?? "nil")) – showing error")
                let serverMessage = json["ErrorMessage"] as? String
                self.failTxnFlow(serverMessage: serverMessage,
                                 fallback: "Invalid or expired transaction. Please try again.")
                return
            }
            
            DispatchQueue.main.async {
                guard !self.hasStartedLoginFlow else { return }   // never run the chain twice
                self.hasStartedLoginFlow = true
                
                print("Txn Validated ✅  Mobile from API:", mobile)
                // Set the number FIRST, then check it (before, the check ran with an empty number)
                self.mobileNumber = mobile
                self.txnId = txnId
                self.NumberTF.text = mobile
                self.NumberTF.isEnabled = false
                
                self.checkMobilenoExsistAPI()       // skip-OTP flow continues as before
            }
            
        }.resume()
    }
    
    func checkMobilenoExsistAPI() {
        
        let url = URL(string: T5Launcher.baseURL+"OTPManagement/CheckMobileNumberExists")!
        //let url = URL(string: "https://signup.hemnxt.com:84/V4.0.0/api/OTPManagement/CheckMobileNumberExists")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("cz_live_rdf5QYYl8z1lPEXLuw3y0e22gq05uUuU", forHTTPHeaderField: "api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "MobileNumber": self.mobileNumber ?? ""
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            print("-------- Check MobileNumber Exists API --------")
            
            if let error = error {
                print("Error:", error.localizedDescription)
                self.failTxnFlow(fallback: "Unable to verify your details. Please check your internet connection and try again.")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Status Code:", response.statusCode)
            }
            
            guard let data = data else {
                print("No Data Received")
                self.failTxnFlow(fallback: "Unable to verify your details. Please try again.")
                return
            }
            
            // ✅ PRINT RAW RESPONSE
            print("Raw Response:", String(data: data, encoding: .utf8) ?? "")
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    
                    print("CheckMobileNumberExists Parsed JSON:", json)
                    
                    if let errorCode = json["ErrorCode"] as? String {
                        switch errorCode {
                            case "000000":
                                Task { @MainActor in
                                    self.FifthApi()
                                }
                        case "000002":
                            Task { @MainActor in
                                self.callInsertClientRegisterApi(phonenumber: self.mobileNumber ?? "")
                            }
                            default:
                                print("CheckMobileNumberExists failed – showing error")
                                let serverMessage = json["ErrorMessage"] as? String
                                self.failTxnFlow(serverMessage: serverMessage, fallback: "Unable to verify your details. Please try again.")
                            }
                    } else {
                        self.failTxnFlow(fallback: "Unable to verify your details. Please try again.")
                    }
                    
                    DispatchQueue.main.async {
                        
                        //print("Txn Validated ✅")
                        
                        // ✅ Get MobileNo from response
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
                    }
                }
            } catch {
                print("JSON Parsing Error:", error)
                self.failTxnFlow(fallback: "Unable to verify your details. Please try again.")
            }
            
        }.resume()
    }
    
    func FifthApi(){
        let decodeByteArrayToString = "96e79218965eb72c92a549dd5a330112" //111111
        var parameters: [String: Any] = [
            "MobileNo": self.mobileNumber ?? "",
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
                            DispatchQueue.main.async {
                                CoreDataHelper.saveUserId(userID, sessionID: sessionId, decodeByteArrayString: decodeByteArrayToString, entityName: "MobileUser")
                            }
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
    
    func showTemporaryAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alert.dismiss(animated: true, completion: nil)
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
                    "MobileNo": self.mobileNumber ?? "",
                    "Flag": "" //An"
                ]
                
                print("6th api params\(parameters)")
                let sixthUrl = "ActiveApplication/GetActiveApplicationCL"
                
                // API call
                apiCall(url: sixthUrl, method: "POST", parameters: parameters, view: self.view) { result in
                    switch result {
                    case .success(let jsonResponse):
                        print("SIXTHAPI Response::: \(jsonResponse)")
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
                                if let panNo = jsonResponse["PanNo"] as? String {
                                    self.panNo = panNo
                                    UserDefaults.standard.set(panNo, forKey: "PanNo")  // Also save to UserDefaults as backup
                                }
                                
                                if let regId = jsonResponse["RegId"] as? String {
                                    self.regId = regId
                                    UserDefaults.standard.set(regId, forKey: "RegId")
                                }
                                print("errorcode 000000 called")
//                                if let finalStatus = FinalStatusValue, finalStatus == "KYC REJECTED" {
//                                    DispatchQueue.main.async {
//                                        let storyboard = UIStoryboard(name: "Rejection", bundle: Bundle.module)
//                                        let vc = storyboard.instantiateViewController(identifier: "RejectionVC") as! RejectionVC
//                                        self.navigationController?.pushViewController(vc, animated: true)
//                                    }
//                                    return
//                                }
                                
                                if finalStatus == "5" && isPdfGenerated == "0" && FinalStatusValue == "KYC REJECTED" {
                                    DispatchQueue.main.async {
                                        let storyboard = UIStoryboard(name: "Rejection", bundle: Bundle.module)
                                        let vc = storyboard.instantiateViewController(identifier: "RejectionVC") as! RejectionVC
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    return
                                }
                                
                                
                                if finalStatus == "3" && isPdfGenerated == "0" {
                                    DispatchQueue.main.async {
                                        
                                        self.showAlertAndCloseSDK(message: "Your application is currently under verification. We appreciate your patience and will update you shortly.", status: "UNDER_VERIFICATION")
                                        //                                    let storyboard = UIStoryboard(name: "EsignStatusVC", bundle: Bundle.module)
                                        //                                    let vc = storyboard.instantiateViewController(identifier: "ApplicationStatic1VC") as! ApplicationStatic1VC
                                        //                                    vc.PanNo = PanNo
                                        //                                    vc.RegId = RegId
                                        //                                    self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    return
                                }
                                
                                if finalStatus == "4" && isPdfGenerated == "0" {
                                    DispatchQueue.main.async {
                                        
                                        self.showAlertAndCloseSDK(message: "Your application is currently under verification. We appreciate your patience and will update you shortly.", status: "UNDER_VERIFICATION")
                                        //                                    let storyboard = UIStoryboard(name: "EsignStatusVC", bundle: Bundle.module)
                                        //                                    let vc = storyboard.instantiateViewController(identifier: "ApplicationStatic1VC") as! ApplicationStatic1VC
                                        //                                    vc.PanNo = PanNo
                                        //                                    vc.RegId = RegId
                                        //                                    self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    return
                                }
                                
                                if finalStatus == "4" && isPdfGenerated == "1" && isPDFSign == "0"{
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
                                
                                if finalStatus == "7" && isPdfGenerated == "0" && isPDFSign == "0"{
                                    print("✅ Navigating to ApplicationStatusVC - FinalStatus: \(finalStatus), isPdfGenerated: \(isPdfGenerated), isPDFSign: \(isPDFSign) PanNo: ")
                                    DispatchQueue.main.async {
//                                        let storyboard = UIStoryboard(name: "Esign", bundle: Bundle.module)
//                                        if let vc = storyboard.instantiateViewController(withIdentifier: "ApplicationStatusVC") as? ApplicationStatusVC {
//                                            vc.PanNo = PanNo
//                                            vc.RegId = RegId
//                                            self.navigationController?.pushViewController(vc, animated: true)
//                                        }
                                        self.showAlertAndCloseSDK(message: "Your application is currently under verification. We appreciate your patience and will update you shortly.", status: "UNDER_VERIFICATION")
                                    }
                                    return
                                }
                                
                                let EmailId = jsonResponse["EmailId"] as? String
                                
                                if EmailId?.isEmpty == true {
                                    self.navigateToEmailIdVC(
                                        userId: userID,
                                        sessionID: self.sessionID,
                                        phoneNumber: self.mobileNumber ?? ""
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
                                
                                if let tradingStatus = jsonResponse["Trading_Status"] as? String, tradingStatus == "PAGE PENDING" {
                                    DispatchQueue.main.async {
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
                                    return
                                }
                                
                                if let bankStatus = jsonResponse["BankDpTradStatus"] as? String, bankStatus == "PAGE PENDING" {
                                    DispatchQueue.main.async {
                                        let storyboard = UIStoryboard(name: "Bank", bundle: Bundle.module)
                                        let vc = storyboard.instantiateViewController(identifier: "UPIVC") as! UPIVC
                                        let savedPAN = UserDefaults.standard.string(forKey: "PanNo")
                                        let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.panNo
                                        
                                        let regId = UserDefaults.standard.string(forKey: "RegId")
                                        let regIdFinal = (regId?.isEmpty == false) ? regId : self.regId
                                        
                                        vc.panNo = finalPAN
                                        vc.regId = regIdFinal
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    return
                                }
                                
                                if let otherStatus = jsonResponse["OtherStatus"] as? String, otherStatus == "PAGE PENDING" {
                                    
                                    DispatchQueue.main.async {
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
                                    
    //                                DispatchQueue.main.async {
    //
    //                                    let storyboard = UIStoryboard(name: "OtherDetails", bundle: Bundle.module)
    //                                    let vc = storyboard.instantiateViewController(identifier: "OtherDetailsVC") as! OtherDetailsVC
    //                                    vc.panNo = self.panNo
    //                                    vc.regId = self.regId
    //                                    self.navigationController?.pushViewController(vc, animated: true)
    //                                }
                                    return
                                }
                                
                                if let nomineeStatus = jsonResponse["NomineeStatus"] as? String, nomineeStatus == "PAGE PENDING" {
                                    DispatchQueue.main.async {
                                        let storyboard = UIStoryboard(name: "Nominee", bundle: Bundle.module)
                                        let vc = storyboard.instantiateViewController(identifier: "NomineeVC") as! NomineeVC
                                        let savedPAN = UserDefaults.standard.string(forKey: "PanNo")
                                        let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.panNo
                                        
                                        let regId = UserDefaults.standard.string(forKey: "RegId")
                                        let regIdFinal = (regId?.isEmpty == false) ? regId : self.regId
                                        vc.panNo = finalPAN
                                        vc.RegId = regIdFinal
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    return
                                }
                                
                                if let documentStatus = jsonResponse["DocumentStatus"] as? String, documentStatus == "PAGE PENDING" {
                                    DispatchQueue.main.async {
                                        let storyboard = UIStoryboard(name: "Document", bundle: Bundle.module)
                                        let vc = storyboard.instantiateViewController(identifier: "DocumentVC") as! DocumentVC
                                        //                                    let savedPAN = UserDefaults.standard.string(forKey: "PanNo")
                                        //                                    let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.panNo
                                        //
                                        //                                    let regId = UserDefaults.standard.string(forKey: "RegId")
                                        //                                    let regIdFinal = (regId?.isEmpty == false) ? regId : self.regId
                                        //
                                        //                                    vc.PanNo = finalPAN
                                        //                                    vc.RegId = regIdFinal
                                        
                                        vc.PanNo = self.panNo  // This now has the value from API
                                        vc.RegId = self.regId  // This now has the value from API
                                        
                                        // Backup: if still nil, try UserDefaults
                                        if vc.PanNo == nil || vc.PanNo?.isEmpty == true {
                                            vc.PanNo = UserDefaults.standard.string(forKey: "PanNo")
                                        }
                                        
                                        if vc.RegId == nil || vc.RegId?.isEmpty == true {
                                            vc.RegId = UserDefaults.standard.string(forKey: "RegId")
                                        }
                                        
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
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
    
    func callInsertClientRegisterApi(phonenumber : String) {
        
        let decodeByteArrayToString = "96e79218965eb72c92a549dd5a330112"    //111111
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
            "SessionId": "",
            "IsMobileOTPBypass": "Y"
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
                let errorCode = jsonResponse["ErrorCode"] as? String ?? ""
                let errorMessage = (jsonResponse["ErrorMessage"] as? String)
                    ?? "Something went wrong. Please try again."
                
                // CRASH FIX: UserID / SessionId come back as null on errors (e.g. 900004),
                // and the old force-unwrap "(... as? String)!" crashed the app.
                let newUserID = jsonResponse["UserID"] as? String ?? ""
                let newSessionID = jsonResponse["SessionId"] as? String ?? ""
                
                // Save the user only when the server actually created one
                if !newUserID.isEmpty, !newSessionID.isEmpty {
                    userID = newUserID
                    sessionID = newSessionID
                    DispatchQueue.main.async { [self] in
                        CoreDataHelper.saveUserId(self.userID, sessionID: self.sessionID, decodeByteArrayString: decodeByteArrayToString , entityName: "MobileUser") // Save userId to Core Data
                    }
                }
                
                switch errorCode {
                case "400003":
                    DispatchQueue.main.async {
                        
                    }
                case "900006":
                    DispatchQueue.main.async {
                        guard !self.userID.isEmpty else {
                            self.showAlert(message: errorMessage)
                            return
                        }
                        self.navigateToEmailIdVC(userId: self.userID , sessionID: self.sessionID, phoneNumber: self.mobileNumber ?? phonenumber)
                    }
                default:
                    // e.g. 900004 "Mobile Number already exists in Backoffice."
                    print("Unhandled error code: \(errorCode)")
                    DispatchQueue.main.async {
                        self.showAlert(message: errorMessage)
                    }
                }
            case .failure(let error):
                print("Login API call failed: \(error.localizedDescription)")
            }
        }
    }

    func sectionPage(){
        //        let storyboard = UIStoryboard(name: "ApplicationForm", bundle: Bundle.module)
        //        let vc = storyboard.instantiateViewController(identifier: "ApplicationFormVC") as? ApplicationFormVC
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
    
    func navigateToEmailIdVC(userId:String,sessionID:String,phoneNumber:String) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EmailIdVC") as? EmailIdVC {
            vc.userId = userId
            vc.sessionID = sessionID
            vc.phoneNumber = phoneNumber
            vc.mobileRelation = relation
            vc.decodedString = decodeArray
            navigationController?.pushViewController(vc, animated: true)
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
    
    func isInvalidMobileNumber(_ phoneNumber: String) -> Bool {

        // Invalid exact numbers
        let invalidNumbers = [
            "1234567890",
            "0987654321"
        ]

        if invalidNumbers.contains(phoneNumber) {
            return true
        }

        // Repeated digits like 1111111111
        let firstChar = phoneNumber.first

        let isRepeated = phoneNumber.allSatisfy { $0 == firstChar }

        if isRepeated {
            return true
        }

        // Mobile number should start from 6-9
        if let firstDigit = phoneNumber.first,
           !"6789".contains(firstDigit) {
            return true
        }

        return false
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func homeBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
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
