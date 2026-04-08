//
//  EmailIdVC.swift
//  t5
//
//  Created by manas dutta on 12/12/25.
//

import UIKit

class EmailIdVC: UIViewController, @MainActor EmailOTPDelegate  {

    @IBOutlet weak var termsnconditionBtn: UIButton!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var RequestBtn: UIButton!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var termView: UIView!
    @IBOutlet weak var homeBtn: UIButton!
    //    @IBOutlet weak var mainView: UIView!
    
    var userId:String?
    var sessionID : String?
    var phoneNumber : String?
    var decodeArray: String?
    var mobileRelation : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let iphone = UIImage(systemName: "envelope.fill") {
//            EmailTF.setLeftIcon(iphone)
//        }
        termsnconditionBtn.isSelected = true
        
        self.RequestBtn.layer.cornerRadius = 10
        print("\(userId ?? "") and \(sessionID ?? "")")
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        
        emailView.layer.cornerRadius = 20
        emailView.layer.borderWidth = 0.5
        emailView.layer.borderColor = UIColor.appBorder.cgColor
        
        termView.layer.cornerRadius = 20
        termView.layer.borderWidth = 0.5
        termView.layer.borderColor = UIColor.appBorder.cgColor
        homeBtn.tintColor = .appPrimary
        RequestBtn.backgroundColor = .appPrimary
        view.backgroundColor = .appBackground
        
    }
    
    func didTapChangeButton(with email: String, userId: String?, sessionID: String?, phoneNumber: String?) {
        EmailTF.text = email
        self.userId = userId
        self.sessionID = sessionID
        self.phoneNumber = phoneNumber
    }
    
    @IBAction func RequestOtpBtn(_ sender: UIButton) {
        guard termsnconditionBtn.isSelected else {
            showAlert(message: "Please accept the terms and conditions")
            return
        }
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
        //self.navigationController?.popViewController(animated: true)
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
                vc.dismissHandler = { [weak self] in
                    self?.termsnconditionBtn.isSelected = true
                }
                
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
