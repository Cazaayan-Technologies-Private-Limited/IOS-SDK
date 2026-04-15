//
//  PanVerifyPopupVC.swift
//  t5
//
//  Created by manas dutta on 12/12/25.
//
import UIKit

protocol PanVerifyPopupVCDelegate: AnyObject {
    func didReceiveApiResponse(panName: String?, panNo: String?, regId: String?, ErrorCode: String?)
}

class PanVerifyPopupVC: UIViewController {
    
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var PANNAME: UILabel!
    @IBOutlet weak var PANNumber: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var holderview: UIView!
    @IBOutlet weak var holderBottomConstraint: NSLayoutConstraint!
    
    var panName: String?
    var dob: String?
    var requestId: String?
    var panNo: String?
    var logindecodeArray: String?
    var mobiledecodeArray: String?
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var mobileUserId: String?
    var mobileSessionID: String?
    weak var delegate: PanVerifyPopupVCDelegate?
    weak var delegate1: ReloadPageDelegate?
    var identifier: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.holderview.layer.cornerRadius = 20
        self.proceedBtn.layer.cornerRadius = 20
        PANNAME.text = panName
        PANNumber.text = panNo
        print("PAN Name: \(panName ?? "")")
        print("DOB: \(dob ?? "")")
        print("Request ID: \(requestId ?? "")")
        print("PAN No: \(panNo ?? "")")
        
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID, decodeByteArrayString  in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.fetchedUserId = userId
                self.fetchedSessionID = sessionID
                self.logindecodeArray = decodeByteArrayString
                print("UserID: \(userId), SessionID: \(sessionID)")
            } else {
                print("No UserID or SessionID found.")
            }
        }
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
        navigationItem.hidesBackButton = true
        
//        backgroundView.backgroundColor = UIColor.black
//        backgroundView.alpha = 0.4
        
        holderview.layer.cornerRadius = 25
        holderview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        holderview.clipsToBounds = true
        proceedBtn.layer.cornerRadius = 20
        proceedBtn.backgroundColor = .appPrimary
        view.backgroundColor = .appBackground
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
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        holderBottomConstraint.constant = -350
         UIView.animate(withDuration: 0.3, animations: {
             self.view.layoutIfNeeded()
         }) { _ in
             self.dismiss(animated: false)
         }
    }
    
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
                                self.showAlertWithDismiss(title: "Alert", message: ErrorMessage ?? "")
                            }
                            
                        case "000000":
                            DispatchQueue.main.async {
                                let panNo = jsonResponse["PanNo"] as? String
                                       // Save PAN locally
                                UserDefaults.standard.set(panNo, forKey: "SavedPAN")
                                self.delegate?.didReceiveApiResponse(
                                    panName: jsonResponse["PANName"] as? String,
                                    panNo: jsonResponse["PanNo"] as? String,
                                    regId: jsonResponse["RegId"] as? String,
                                    ErrorCode: jsonResponse["ErrorCode"] as? String
                                )
                                print("dismiss")
                                self.dismiss(animated: true, completion: nil)
                            }
                        case "999993":
                            self.showAlertWithDismiss(title: "Alert", message: ErrorMessage ?? "")
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
    
    func showAlertWithDismiss(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Dismiss the current screen after alert is dismissed
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

