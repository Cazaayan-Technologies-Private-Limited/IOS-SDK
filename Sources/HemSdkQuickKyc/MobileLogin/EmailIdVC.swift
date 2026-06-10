//
//  EmailIdVC.swift
//  t5
//
//  Created by manas dutta on 12/12/25.
//

//import UIKit
//
//class EmailIdVC: UIViewController, @MainActor EmailOTPDelegate  {
//
//    @IBOutlet weak var termsnconditionBtn: UIButton!
//    @IBOutlet weak var EmailTF: UITextField!
//    @IBOutlet weak var RequestBtn: UIButton!
//    @IBOutlet weak var emailView: UIView!
//    @IBOutlet weak var termView: UIView!
//    @IBOutlet weak var homeBtn: UIButton!
//    @IBOutlet weak var buttonView: UIView!
//    
//    var userId:String?
//    var sessionID : String?
//    var phoneNumber : String?
//    var decodeArray: String?
//    var mobileRelation : String?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        if let iphone = UIImage(systemName: "envelope.fill") {
////            EmailTF.setLeftIcon(iphone)
////        }
//        termsnconditionBtn.isSelected = true
//        
//        self.RequestBtn.layer.cornerRadius = 10
//        print("\(userId ?? "") and \(sessionID ?? "")")
//        view.backgroundColor = .white
//        navigationItem.hidesBackButton = true
//        
//        emailView.layer.cornerRadius = 20
//        emailView.layer.borderWidth = 0.5
//        emailView.layer.borderColor = UIColor.appBorder.cgColor
//        
//        termView.layer.cornerRadius = 20
//        termView.layer.borderWidth = 0.5
//        termView.layer.borderColor = UIColor.appBorder.cgColor
//        homeBtn.tintColor = .appPrimary
//        //RequestBtn.backgroundColor = .appPrimary
//        view.backgroundColor = .appBackground
//        self.navigationItem.hidesBackButton = true
//        buttonView.backgroundColor = .appPrimary
//        buttonView.layer.cornerRadius = 20
//    }
//    
//    func didTapChangeButton(with email: String, userId: String?, sessionID: String?, phoneNumber: String?) {
//        EmailTF.text = email
//        self.userId = userId
//        self.sessionID = sessionID
//        self.phoneNumber = phoneNumber
//    }
//    
//    @IBAction func RequestOtpBtn(_ sender: UIButton) {
//        guard termsnconditionBtn.isSelected else {
//            showAlert(message: "Please accept the terms and conditions")
//            return
//        }
//        guard let EmailID = EmailTF.text, !EmailID.isEmpty else {
//            // Handle empty phone number case
//            showAlert(message: "Please enter a EmailID")
//            return
//        }
//        if isValidEmail(EmailID) {
//            // Proceed with API call if the email is valid
//            self.navigateToEmailOTP(with: EmailID)
//            //emailVerification(emailId: EmailID)
//        } else {
//            // Show alert if email is invalid
//            showAlert(message: "Please enter a valid email address")
//        }
//        
//        //emailVerification(emailId: EmailID)
//    }
//    
//    @IBAction func BackBtn(_ sender: UIButton) {
//        //self.navigationController?.popViewController(animated: true)
//        let storyboard = UIStoryboard(name: "DashboardVC", bundle: Bundle.module)
//        let vc = storyboard.instantiateViewController(identifier: "NewAccountVC") as! NewAccountVC
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    @IBAction func homeBtn(_ sender: UIButton) {
//        self.navigationController?.popToRootViewController(animated: true)
//    }
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
//    func isValidEmail(_ email: String) -> Bool {
//        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
//        return emailPredicate.evaluate(with: email)
//    }
//    func showAlert(message: String) {
//        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//}
//
//extension EmailIdVC{
//    func emailVerification(emailId: String){
//        
//        let parameters: [String: Any] = [
//            "PanNo":"",
//            "EmailAddress":emailId,
//            "DeviceType":"W",
//            "RmCode":"",
//            "MobileRelation":mobileRelation,
//            "OTP":""
//        ]
//        
//        let emailURL = "OTPManagement/SendOTPToEmailClient"
//        
//        apiCall(url: emailURL, method: "POST", parameters: parameters, view: self.view) { result in
//            switch result {
//            case .success(let jsonResponse):
//                print("Login Response: \(jsonResponse)")
//                
//                if let errorCode = jsonResponse["ErrorCode"] as? String {
//                    switch errorCode {
//                    case "000000":
//                        DispatchQueue.main.async {
//                            self.navigateToEmailOTP(with: emailId)
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
//    func navigateToEmailOTP(with emailId: String) {
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "EmailOTPVC") as? EmailOTPVC {
//            vc.EmailID = emailId
//            vc.userId = userId
//            vc.sessionID = sessionID
//            vc.phoneNumber = phoneNumber
//            vc.mobileRelation = mobileRelation
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//}
import UIKit
import AuthenticationServices
import GoogleSignIn

class EmailIdVC: UIViewController, @MainActor EmailOTPDelegate, UITextFieldDelegate {

   // @IBOutlet weak var termsnconditionBtn: UIButton!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var RequestBtn: UIButton!
    @IBOutlet weak var emailView: UIView!
    //@IBOutlet weak var termView: UIView!
   // @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var signInGoogleBtn: UIButton!
    
    var userId:String?
    var sessionID : String?
    var phoneNumber : String?
    var decodedString: String?
    var mobileRelation : String?
    
//    var emailList: [String] = ["imanuradha@gmail.com", "anuradha123@gmail.com"]
    var emailList: [String] = []
    private let emailStorageKey = "savedEmailList"
    var isDropdownVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let iphone = UIImage(systemName: "envelope.fill") {
//            EmailTF.setLeftIcon(iphone)
//        }
        //termsnconditionBtn.isSelected = true
        
        self.RequestBtn.layer.cornerRadius = 10
        print("\(userId ?? "") and \(sessionID ?? "")")
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        
        emailView.layer.cornerRadius = 20
        emailView.layer.borderWidth = 0.5
        emailView.layer.borderColor = UIColor.appBorder.cgColor
        
        signInGoogleBtn.layer.cornerRadius = 20
        signInGoogleBtn.layer.borderWidth = 0.5
        signInGoogleBtn.layer.borderColor = UIColor.appBorder.cgColor
        signInGoogleBtn.backgroundColor = UIColor.white
        
//        termView.layer.cornerRadius = 20
//        termView.layer.borderWidth = 0.5
//        termView.layer.borderColor = UIColor.appBorder.cgColor
        //homeBtn.tintColor = .appPrimary
        //RequestBtn.backgroundColor = .appPrimary
        view.backgroundColor = .appBackground
        self.navigationItem.hidesBackButton = true
        buttonView.backgroundColor = .appPrimary
        buttonView.layer.cornerRadius = 20
        
        tableView.delegate = self
         tableView.dataSource = self
         
        view1.isHidden = true // initially hidden
        EmailTF.delegate = self
        
        //tableView.register(UINib(nibName: "EmailTVC", bundle: nil), forCellReuseIdentifier: "EmailTVC")
        
        tableView.register(UINib(nibName: "EmailTVC", bundle: Bundle.module), forCellReuseIdentifier: "EmailTVC")
        
        loadSavedEmails()
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: "456973629244-8scrmbadk525r5r45sn8auagt6g132r9.apps.googleusercontent.com")
        
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        fetchDeviceEmailAccounts()
    }
    
    func loadSavedEmails() {
         if let saved = UserDefaults.standard.stringArray(forKey: emailStorageKey) {
             emailList = saved
         }
     }
     
     func saveEmail(_ email: String) {
         if !emailList.contains(email) {
             emailList.insert(email, at: 0)  // Add to top
             UserDefaults.standard.set(emailList, forKey: emailStorageKey)
         }
     }

    func fetchDeviceEmailAccounts() {

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in

            guard let self = self else { return }

            if let error = error {
                print("Google Sign-In error: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user else {
                print("No Google user found")
                return
            }

            let email = user.profile?.email ?? ""
            self.saveEmail(email)

            self.UserCreationDetails(EmailID: email,decodedString: decodedString ?? "" )
        }
    }
    
//    func saveEmailToDatabase(email: String) {
//        let parameters: [String: Any] = [
//            "PanNo": "",
//            "EmailAddress": email,
//            "DeviceType": "W",
//            "RmCode": "",
//            "MobileRelation": "SELF",
//            "OTP": ""
//        ]
//        
//        let emailURL = "OTPManagement/SendOTPToEmailClient"
//        
//        apiCall(url: emailURL, method: "POST", parameters: parameters, view: self.view) { result in
//            switch result {
//            case .success(let jsonResponse):
//                print("Email saved successfully: \(jsonResponse)")
//                
//                if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
//                    DispatchQueue.main.async {
//                        self.navigateToPanVerifyVC(with: email)
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        // Even if API returns error, you might still want to proceed
//                        // or show an alert
//                        self.navigateToPanVerifyVC(with: email)
//                    }
//                }
//                
//            case .failure(let error):
//                print("Failed to save email: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    // Optionally show alert but still navigate
//                    self.showAlert(message: "Email saved locally but failed to sync with server")
//                    self.navigateToPanVerifyVC(with: email)
//                }
//            }
//        }
//    }
    
    func UserCreationDetails(EmailID: String,decodedString: String){
        
        var parameters: [String: Any?] = [
            "PanNo":"",
            "EmailAddress":EmailID,
            "DeviceType":"W",
            "RmCode":"",
            "OTP": "111111",
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
                            self.navigateToPanVerifyVC(with: EmailID)
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

    func navigateToPanVerifyVC(with email: String) {
        let storyboard = UIStoryboard(name: "DashboardVC", bundle: Bundle.module)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "PanVerifyVC") as? PanVerifyVC else {
            return
        }
        
        vc.emailID = email
        vc.decodedString = self.decodedString
        vc.phoneNumber = self.phoneNumber
        
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }

    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        view1.isHidden = true  // Hide dropdown if visible
          return true
    }
    
    func didTapChangeButton(with email: String, userId: String?, sessionID: String?, phoneNumber: String?) {
        EmailTF.text = email
        self.userId = userId
        self.sessionID = sessionID
        self.phoneNumber = phoneNumber
    }
    
    @IBAction func RequestOtpBtn(_ sender: UIButton) {

        guard let EmailID = EmailTF.text, !EmailID.isEmpty else {
            // Handle empty phone number case
            showAlert(message: "Please enter a EmailID")
            return
        }
        if isValidEmail(EmailID) {
            // Proceed with API call if the email is valid
            self.navigateToEmailOTP(with: EmailID)
            //emailVerification(emailId: EmailID)
        } else {
            // Show alert if email is invalid
            showAlert(message: "Please enter a valid email address")
        }
        
        //emailVerification(emailId: EmailID)
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "DashboardVC", bundle: Bundle.module)
                      let vc = storyboard.instantiateViewController(identifier: "NewAccountVC") as! NewAccountVC
                 
                      self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func homeBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func TCbtn(_ sender: UIButton) {
        if sender.isSelected {
            // If the button is selected and user clicks, deselect it and show terms and conditions page
            sender.isSelected = false
            let storyboard = UIStoryboard(name: "terms", bundle: Bundle.module)
            if let vc = storyboard.instantiateViewController(withIdentifier: "termsVC") as? termsVC {
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                
                // Closure or delegate to set the button to selected when termsVC is dismissed
//                vc.dismissHandler = { [weak self] in
//                    self?.termsnconditionBtn.isSelected = true
//                }
                
                present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension EmailIdVC{
    func emailVerification(emailId: String){
        
        let parameters: [String: Any] = [
            "PanNo":"",
            "EmailAddress":emailId,
            "DeviceType":"W",
            "RmCode":"",
            "MobileRelation":mobileRelation,
            "OTP":""
        ]
        
        let emailURL = "OTPManagement/SendOTPToEmailClient"
        
        apiCall(url: emailURL, method: "POST", parameters: parameters, view: self.view) { result in
            switch result {
            case .success(let jsonResponse):
                print("Login Response: \(jsonResponse)")
                
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "000000":
                        DispatchQueue.main.async {
                            self.navigateToEmailOTP(with: emailId)
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
    
    func navigateToEmailOTP(with emailId: String) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EmailOTPVC") as? EmailOTPVC {
            vc.EmailID = emailId
            vc.userId = userId
            vc.sessionID = sessionID
            vc.phoneNumber = phoneNumber
            vc.mobileRelation = mobileRelation
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension EmailIdVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmailTVC") as! EmailTVC
          
          let email = emailList[indexPath.row]
          cell.emailBtn.setTitle(email, for: .normal)
          
          // 🔥 Handle button click
          cell.onTap = { [weak self] in
              guard let self = self else { return }
              
              self.EmailTF.text = email
              self.view1.isHidden = true
          }

          return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedEmail = emailList[indexPath.row]
        
        // Set email in textfield
        EmailTF.text = selectedEmail
        
        // Hide table
        view1.isHidden = true
    }
}

