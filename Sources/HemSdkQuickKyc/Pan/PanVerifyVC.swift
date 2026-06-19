//
//  PanVerifyVC.swift
//  t5
//
//  Created by manas dutta on 12/12/25.
//

import UIKit

class PanVerifyVC: UIViewController,@MainActor PanVerifyPopupVCDelegate,@MainActor CalenderVCDelegate,UITextFieldDelegate, @MainActor ReloadPageDelegate {
    func reloadPageData() {
        print("SessionId Expired. Error Code: \(errorCode ?? "")")
        
        // Handle session expiration
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: "Session Expired",
                                                    message: "Your session has expired. Please log in again.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // Clear stored user data or session tokens
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                UserDefaults.standard.removeObject(forKey: "EmailAddress")
                UserDefaults.standard.removeObject(forKey: "UserType")
                UserDefaults.standard.removeObject(forKey: "userId")
                UserDefaults.standard.removeObject(forKey: "loginName")
                CoreDataHelper.deleteAllUserIds(entityName: "MobileUser")
                
                // Navigate to login screen
                let loginStoryboard = UIStoryboard(name: "Main", bundle: Bundle.module)
                if let loginViewController = loginStoryboard.instantiateViewController(withIdentifier: "NewAccountVC") as? NewAccountVC {
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = loginViewController
                        UIView.transition(with: window, duration: 0.5, options: [.transitionFlipFromRight], animations: nil, completion: nil)
                        window.makeKeyAndVisible()
                    }
                } else {
                    print("Failed to instantiate view controller with identifier 'ViewController'")
                }
                // Complete the function
                // completion(false)
            }
            alertController.addAction(okAction)
            
            // Present the alert
            if let window = UIApplication.shared.windows.first?.rootViewController {
                window.present(alertController, animated: true, completion: nil)
            } else {
                print("Failed to present alert")
            }
        }
        
    }
    
    func didSelectDate(_ date: String, identifier: String) {
        DOBTF.text = date
        UserDefaults.standard.set(date, forKey: "userDOB")
    }
    
    func didReceiveApiResponse(panName: String?, panNo: String?, regId: String?, ErrorCode errorCode: String?) {
        if let errorCode = errorCode, errorCode == "000000" {
            self.panName = panName
            self.panNo = panNo
            self.regId = regId
            
            let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "DigiLocker_a") as! DigiLocker_a
            nextVC.EmailId = emailID
            nextVC.PANName = self.panName
            nextVC.panNo = self.panNo
            nextVC.RegId = self.regId
            print("Push")
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            if let errorCode = errorCode {
                print("API response received with error code: \(errorCode)")
            } else {
                print("API response has no error code.")
            }
        }
    }
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var NAMETF: UITextField!
    @IBOutlet weak var DOBTF: UITextField!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var PANTF: UITextField!
    @IBOutlet weak var panInvalid: UILabel!
    @IBOutlet weak var panNumberInvalid: UILabel!
    @IBOutlet weak var dobInvalid: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var panView: UIView!
    @IBOutlet weak var dobView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var buttonView: UIView!
    //    @IBOutlet weak var backgroundView: UIView!
    //    @IBOutlet weak var holderView: UIView!
    //    @IBOutlet weak var stackview: UIStackView!
    //    @IBOutlet weak var proceedBtn: UIButton!
    //    @IBOutlet weak var cancelBtn: UIButton!
    //    @IBOutlet weak var PANNAME: UILabel!
    //    @IBOutlet weak var holderBottomConstraint: NSLayoutConstraint!
    
    
    private let datePicker = UIDatePicker()
    var panName : String?
    var panNo : String?
    var regId : String?
    var errorCode : String?
    var emailID: String?
    var decodedString: String?
    var MobileUserID: String?
    var LoginUserID: String?
    var decodeArray: String?
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var dob: String?
    var requestId: String?
    var logindecodeArray: String?
    var mobiledecodeArray: String?
    var mobileUserId: String?
    var mobileSessionID: String?
    weak var delegate: PanVerifyPopupVCDelegate?
    weak var delegate1: ReloadPageDelegate?
    var identifier: String = ""
    var phoneNumber: String?
    private var isFirstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.fetchedUserId = userId
                self.fetchedSessionID = sessionID
                self.decodeArray = decodeByteArrayString
                self.ValidateToken()
                print("UserID: \(userId), SessionID: \(sessionID)")
            } else {
                print("No UserID or SessionID found.")
            }
        }
        DOBTF.delegate = self // Set delegate
        print("Email ID: \(emailID ?? "")")
        emailTF.text = emailID
        emailTF.isEnabled = false
        //verifyBtn.layer.cornerRadius = 10
        navigationItem.hidesBackButton = true
        hidePanErrorLabels()
        panView.layer.cornerRadius = 10
        panView.layer.borderWidth = 0.5
        panView.layer.borderColor = UIColor.appBorder.cgColor
        nameView.layer.cornerRadius = 10
        nameView.layer.borderWidth = 0.5
        nameView.layer.borderColor = UIColor.appBorder.cgColor
        dobView.layer.cornerRadius = 10
        dobView.layer.borderWidth = 0.5
        dobView.layer.borderColor = UIColor.appBorder.cgColor
        PANTF.delegate = self
        NAMETF.delegate = self
        
        emailLbl.isHidden = true
        emailTF.isHidden = true
        
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID,decodeByteArrayString  in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.mobileUserId = userId
                self.mobileSessionID = sessionID
                self.mobiledecodeArray = decodeByteArrayString
                print("UserID: \(userId), SessionID: \(sessionID)")
            } else {
                print("No UserID or SessionID found.")
            }
        }
        //homeBtn.tintColor = .appPrimary
        //verifyBtn.backgroundColor = .appPrimary
        view.backgroundColor = .appBackground
        buttonView.backgroundColor = .appPrimary
        buttonView.layer.cornerRadius = 20
        
        clientPanDetails()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if isFirstLoad {
            isFirstLoad = false
            clientPanDetails()
        }
    }
    
    func hidePanErrorLabels() {
        panInvalid.isHidden = true
        panNumberInvalid.isHidden = true
        dobInvalid.isHidden = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == DOBTF {
            // Present the CalendarVC
            let storyboard = UIStoryboard(name: "Nominee", bundle: Bundle.module)
            if let vc = storyboard.instantiateViewController(identifier: "calenderVC") as? calenderVC {
                vc.modalPresentationStyle = .overCurrentContext
                vc.identifier = "To"
                vc.delegate = self // Assign the delegate
                vc.modalTransitionStyle = .crossDissolve
                present(vc, animated: true)
            }
            
            return false
        }
        return true
    }
    
    @IBAction func BackBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DashboardVC", bundle: Bundle.module)
        let vc = storyboard.instantiateViewController(identifier: "NewAccountVC") as! NewAccountVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func VerifyBtn(_ sender: UIButton) {
        guard let userId = fetchedUserId,
              let panNo = PANTF.text,
              let name = NAMETF.text,
              let userDOB = DOBTF.text else {
            print("Missing required fields")
            return
        }
        panValidation(userId: userId, panNo: panNo, name: name, userDOB: userDOB)
    }
    
    @IBAction func proceedBtn(_ sender: UIButton) {
        
        switch identifier {
        case "applicantPanverify":
            print("API Called")
            callApi()
            print("EXIT API")
        case "nomineePanVerify":
            dismiss(animated: true)
        default:
            break
        }
    }
    
    //  @IBAction func cancelBtn(_ sender: UIButton) {
    //  backgroundView.isHidden = true
    // }
    
    func callApi() {
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                    if success {
                        // Call SIXTHAPI after tokenMobile API call is successful
                        self.callApi()
                        //self.panValidation(panNo: panNo, name: name, userDOB: userDOB, isGuardian: isGuardian)
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            var parameters: [String: Any?] = [
                "UserId": mobileUserId,
                "SLUserId": fetchedUserId,
                "RequestId": requestId,
                "PanNo": panNo,
                "TokenId": tokenId,
                "RegId": "",
                "IsPanSeeded": "0",
                "LinkType":"0",
                "DOB":dob,
                "SessionId":mobileSessionID
            ]
            // URL for the login endpoint
            let Url = "Registration/InsertRegistrationPanDetails"
            for (key, value) in parameters {
                if let stringValue = value as? String, stringValue.isEmpty {
                    parameters[key] = nil
                }
            }
            print(parameters)
            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("PANPOP api Response: \(jsonResponse)")
                    
                    let ErrorMessage = jsonResponse["ErrorMessage"] as? String
                    let PANName = jsonResponse["PANName"] as? String
                    let panNo = jsonResponse["PanNo"] as? String
                    let RegId = jsonResponse["RegId"] as? String
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        
                        switch errorCode {
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
                                print("All TokenMobile entries deleted due to error code 999992")
                                
                                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.mobileUserId ?? "", SessionId: self.mobileSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                                    if success {
                                        // Retry SIXTHAPI after token regeneration
                                        self.callApi()
                                    } else {
                                        print("Token generation failed.")
                                        self.delegate1?.reloadPageData()
                                        self.dismiss(animated: true)
                                    }
                                }
                            }
                        case "300001":
                            DispatchQueue.main.async {
                                self.showAlert(title: "Alert", message: ErrorMessage ?? "")
                            }
                            
                        case "000000":
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
                                if let nextVC = storyboard.instantiateViewController(withIdentifier: "DigiLocker_a") as? DigiLocker_a {
                                    
                                    nextVC.EmailId = self.emailID
                                    nextVC.PANName = self.panName
                                    nextVC.panNo = self.panNo
                                    nextVC.RegId = self.regId
                                    
                                    self.navigationController?.pushViewController(nextVC, animated: true)
                                }
                                print("dismiss")
                                //  self.dismiss(animated: true, completion: nil)
                            }
                        case "999993":
                            self.showAlert(title: "Alert", message: ErrorMessage ?? "")
                            DispatchQueue.main.async {
                                
                                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.mobileUserId ?? "", SessionId: self.mobileSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                                    if success {
                                        self.callApi()                                    } else {
                                            print("Token generation failed.")
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
    
    func ValidateToken(){
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self
                        .decodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W",
                    in: self.view
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
    
    func clientPanDetails(){
        DispatchQueue.main.async {
              LoaderView.shared.startLoader(in: self.view, withText: "Fetching PAN details...")
          }
          
          CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
              guard let self = self else {
                  // If self is nil, hide loader
                  DispatchQueue.main.async {
                      LoaderView.shared.stopLoader()
                  }
                  return
              }
              
              guard let tokenId = tokenId else {
                  // Handle the case where no tokens are available
                  CoreDataHelper.generateToken(
                      decodeByteArrayToString: self.decodeArray ?? "",
                      USERID: self.fetchedUserId ?? "",
                      SessionId: self.fetchedSessionID ?? "",
                      entityName: "TokenMobile", deviceType: "W",
                      in: self.view
                  ) { success in
                      if success {
                          // Retry clientPanDetails after token regeneration
                          self.clientPanDetails()
                      } else {
                          print("Token generation failed.")
                          // ✅ Stop loader on failure
                          DispatchQueue.main.async {
                              LoaderView.shared.stopLoader()
                          }
                      }
                  }
                  print("No tokens available. Please reload the tokens.")
                  // ✅ Stop loader if no token
                  DispatchQueue.main.async {
                      LoaderView.shared.stopLoader()
                  }
                  return
              }
            let parameters: [String: Any?] = [
                "RegId": regId,
                "MobileNo": phoneNumber,
                "UserId": fetchedUserId,
                "PanNo": panNo,
                "TokenId": tokenId
            ]
            print(parameters)
            let Url = "Client/GetClientPANDetailsByMobileNo"
            
            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view, loaderText: "Fetching PAN details...") { result in
                switch result {
                case .success(let jsonResponse):
                    print(" Response: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            DispatchQueue.main.async {
                                
                                // PAN Number
                                if let panNo = jsonResponse["PANNo"] as? String,
                                   !panNo.trimmingCharacters(in: .whitespaces).isEmpty {
                                    self.PANTF.text = panNo
                                } else {
                                    self.PANTF.text = ""
                                }
                                
                                // PAN Name
                                if let panName = jsonResponse["PANName"] as? String,
                                   !panName.trimmingCharacters(in: .whitespaces).isEmpty {
                                    self.NAMETF.text = panName
                                } else {
                                    self.NAMETF.text = ""
                                }
                                
                                // DOB
                                if let dob = jsonResponse["DOB"] as? String,
                                   !dob.trimmingCharacters(in: .whitespaces).isEmpty {
                                    if let formattedDOB = self.convertDOBFormat(dob) {
                                        self.DOBTF.text = formattedDOB
                                    } else {
                                        self.DOBTF.text = dob
                                    }
                                } else {
                                    self.DOBTF.text = ""
                                }
                                
                                print("PAN details autofilled successfully")
                            }
                        case "111111":
                            DispatchQueue.main.async {

                                self.PANTF.text = ""
                                self.NAMETF.text = ""
                                self.DOBTF.text = ""

                                self.showAlert(
                                    title: "Alert",
                                    message: "Unable to fetch PAN details automatically. Please enter PAN manually to proceed."
                                )
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
    
    func convertDOBFormat(_ dateString: String) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
    func panValidation(userId: String, panNo: String, name: String, userDOB: String){
        hidePanErrorLabels()
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(decodeByteArrayToString: self.decodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                    if success {
                        self.panValidation(userId: userId, panNo: panNo, name: name, userDOB: userDOB)
                        
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            
            var parameters: [String: Any] = [
                "UserId": userId,
                "PanNo": panNo,
                "DeviceType": "W",
                "TokenId": tokenId,
                "Name": name,
                "UserDOB": userDOB
            ]
            
            // URL for the login endpoint
            let Url = "Registration/PANValidation"
            for (key, value) in parameters {
                if let stringValue = value as? String, stringValue.isEmpty {
                    parameters[key] = nil
                }
            }
            print(parameters)
            apiCall(url: Url, method: "POST", parameters: parameters, view: self.view,loaderText: "We are verifying your PAN, kindly wait...") { result in
                switch result {
                case .success(let jsonResponse):
                    print("PAN api Response: \(jsonResponse)")
                    let ErrorMessage = jsonResponse["ErrorMessage"] as? String ?? ""
                    
                    if let errorCode = jsonResponse["ErrorCode"] as? String
                    {
                        
                        switch errorCode {
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
                                print("All TokenMobile entries deleted due to error code 999992")
                                CoreDataHelper.generateToken(decodeByteArrayToString: self.decodeArray ?? "", USERID: userId, SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                                    if success {
                                        self.panValidation(userId: userId, panNo: panNo, name: name, userDOB: userDOB)
                                    } else {
                                        print("Token generation failed.")
                                    }
                                }
                            }
                        case "999993":
                            DispatchQueue.main.async {
                                
                                CoreDataHelper.generateToken(decodeByteArrayToString: self.decodeArray ?? "", USERID: userId, SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                                    if success {
                                        self.panValidation(userId: userId, panNo: panNo, name: name, userDOB: userDOB)
                                    } else {
                                        print("Token generation failed.")
                                    }
                                }
                            }
                        case "100001":
                            self.panInvalid.text = ErrorMessage.isEmpty
                            ? "Invalid ID Number or Combination of Inputs."
                            : ErrorMessage
                            self.panInvalid.isHidden = false
                            //                            DispatchQueue.main.async {
                            //
                            //                                self.showAlert(title: "Alert", message: ErrorMessage ?? "")
                            //                            }
                        case "Pan-001":
                            self.panNumberInvalid.text = ErrorMessage.isEmpty
                            ? "PAN Name is not matched. Please enter the name as per PAN card."
                            : ErrorMessage
                            self.panNumberInvalid.isHidden = false
                            //                            DispatchQueue.main.async {
                            //
                            //                                self.showAlert(title: "Alert", message: ErrorMessage ?? "")
                            //                            }
                        case "PANDOB-001":
                            self.dobInvalid.text = ErrorMessage.isEmpty
                            ? "Date of birth is not matched. Please enter the date of birth as per PAN card."
                            : ErrorMessage
                            self.dobInvalid.isHidden = false
                            //                            DispatchQueue.main.async {
                            //
                            //                                self.showAlert(title: "Alert", message: ErrorMessage ?? "")
                            //                            }
                        case "300001":
                            DispatchQueue.main.async {
                                
                                self.showAlert(title: "Alert", message: ErrorMessage ?? "")
                            }
                        case "300006":
                            self.panInvalid.text = ErrorMessage.isEmpty
                            ? "Invalid PAN"
                            : ErrorMessage
                            self.panInvalid.isHidden = false
                            //                            DispatchQueue.main.async {
                            //
                            //                                self.showAlert(title: "Alert", message: ErrorMessage ?? "")
                            //                            }
                        case "111111":
                            DispatchQueue.main.async {
                                
                                self.showAlert(title: "Alert", message: ErrorMessage ?? "")
                            }
                        case "BL001":
                            DispatchQueue.main.async {
                                
                                self.showAlert(title: "Alert", message: ErrorMessage ?? "")
                            }
                        case "000000":
                            DispatchQueue.main.async {
                                let storyboard = UIStoryboard(name: "DashboardVC", bundle: Bundle.module)
                                
                                // Instantiate the view controller by its identifier
                                guard let viewController = storyboard.instantiateViewController(withIdentifier: "PanVerifyPopupVC") as? PanVerifyPopupVC else {
                                    print("ViewController not found")
                                    return
                                }
                                viewController.identifier = "applicantPanverify"
                                //                                viewController.panName = jsonResponse["PANName"] as? String
                                if let panName = jsonResponse["PANName"] as? String {
                                    UserDefaults.standard.set(panName, forKey: "panName")
                                    viewController.panName = panName
                                }
                                viewController.dob = jsonResponse["DOB"] as? String
                                viewController.requestId = jsonResponse["RequestId"] as? String
                                viewController.panNo = jsonResponse["PanNo"] as? String
                                viewController.delegate = self
                                viewController.delegate1 = self
                                viewController.modalPresentationStyle = .overCurrentContext
                                
                                viewController.modalTransitionStyle = .crossDissolve
                                print("present")
                                self.present(viewController, animated: true, completion: nil)
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
    
    @IBAction func TermsCheckBtn(_ sender: UIButton) {
        if sender.isSelected {
            // If the button is selected and user clicks, deselect it and show terms and conditions page
            sender.isSelected = false
            let storyboard = UIStoryboard(name: "terms", bundle: Bundle.module)
            if let vc = storyboard.instantiateViewController(withIdentifier: "termsVC") as? termsVC {
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                
                // Closure or delegate to set the button to selected when termsVC is dismissed
                vc.dismissHandler = { [weak self] in
                    //  self?.termsCheckBtn.isSelected = true
                }
                present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func HomeBtn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "NewAccountVC") as! NewAccountVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Convert input to uppercase
        let uppercasedString = string.uppercased()
        
        if textField == PANTF || textField == NAMETF {
            if let text = textField.text,
               let textRange = Range(range, in: text) {
                
                let updatedText = text.replacingCharacters(in: textRange, with: uppercasedString)
                textField.text = updatedText
            }
            return false
        }
        
        return true
    }
}

class NoPasteTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) ||
            action == #selector(select(_:)) ||
            action == #selector(selectAll(_:)) ||
            action == #selector(cut(_:)) ||
            action == #selector(copy(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
