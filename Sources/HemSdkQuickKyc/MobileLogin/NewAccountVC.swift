//
//  ViewController.swift
//  t5
//
//  Created by manas dutta on 11/12/25.
//


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
        performFirstApiCall(phoneNumber: phoneNumber)
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
//extension UITextField {
//     func setLeftIcon(_ image: UIImage) {
//        let iconView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20)) // Adjust position if needed
//        iconView.image = image
//        iconView.tintColor = .gray
//        iconView.contentMode = .scaleAspectFit
//        
//        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        iconContainerView.addSubview(iconView)
//        
//        leftView = iconContainerView
//        leftViewMode = .always
//    }
//}
