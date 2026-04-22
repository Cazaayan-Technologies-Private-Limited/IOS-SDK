//
//  ApplicationStatusVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

class ApplicationStatic1VC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var onBordingView: UIView!
    @IBOutlet weak var applicationView: UIView!
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var approveView: UIView!
    @IBOutlet weak var onBordingDateLbl: UILabel!
    @IBOutlet weak var applicationDateLbl: UILabel!
    @IBOutlet weak var waitingDateLbl: UILabel!
    @IBOutlet weak var approveDateLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var mobiledecodeArray: String?
    var decodeArray:String?
    var panNo: String?
    var regId: String?
    var PANName : String?
    var EmailId : String?
    var isDerivative: String = "N"
    var networth: String?
    var networthDate: String?
    var finalStatus: String?
    var ekraSign: String = "0"
    var aofSign: String = "0"
    var ddpiSign: String = "0"
    var ekraID: String?
    var aofID: String?
    var ddpiID: String?
    var PanNo : String?
    var RegId : String?
    var signedResponse: String?
    var msg : String?
    var env : String?
    var pdfDataList: [[String: Any]] = []
    var esignRetryCount = 10
    var companyName: String?
    var returnurl: String?
    var txnId: String?
    var esignType: String?
    var currentEsignSegment: String?
    public var onStartEsign: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGroupedBackground
        navigationController?.isNavigationBarHidden = true
      
        mainView.layer.cornerRadius = 20
     
        SIXTHAPI(userID: fetchedUserId ?? "" )
        onBordingView.layer.cornerRadius = 25
        applicationView.layer.cornerRadius = 25
        waitingView.layer.cornerRadius = 25
        approveView.layer.cornerRadius = 25
        
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
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func QuitBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func ValidateToken(){
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.decodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.ValidateToken()
                    } else {
                        print("Token generation failed.")
                    }
                }
                // Handle the case where no tokens are available
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
    
    func formatDateTime(_ input: String) -> String {
        guard !input.isEmpty else { return "" }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy hh:mma"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy, hh:mm a"
        
        if let date = inputFormatter.date(from: input) {
            return outputFormatter.string(from: date)
        }
        
        return input // fallback if parsing fails
    }
}

extension ApplicationStatic1VC {
    
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
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self
                        .mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W",
                    in: self.view
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
                "UserId": self.fetchedUserId as Any,
                "TokenId": tokenId
            ]
            print("6th api params\(parameters)")
            let sixthUrl = "ActiveApplication/GetActiveApplicationCL"
            // API call
            apiCall(url: sixthUrl, method: "POST", parameters: parameters, view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("SIXTHAPI Response: \(jsonResponse)")
                    self.panNo = jsonResponse["PanNo"] as? String
                    self.regId = jsonResponse["RegId"] as? String
                    self.PANName = jsonResponse["PANName"] as? String
                    self.EmailId = jsonResponse["EmailId"] as? String
                    self.finalStatus = jsonResponse["FinalStatus"] as? String
                    
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
                            DispatchQueue.main.async{
                                
                                let onboardingDate = jsonResponse["OnBoardingStartedOn"] as? String ?? ""
                                let applicationDate = jsonResponse["ApplicationSubmittedOn"] as? String ?? ""
                                let waitingDate = jsonResponse["WaitingForVerificationOn"] as? String ?? ""
                                let approvedDate = jsonResponse["ApplicationApprovedOn"] as? String ?? ""
                                let name = jsonResponse["PANName"] as? String ?? ""
                                
                                self.onBordingDateLbl.text = self.formatDateTime(onboardingDate)
                                 self.applicationDateLbl.text = self.formatDateTime(applicationDate)
                                 self.waitingDateLbl.text = self.formatDateTime(waitingDate)
                                 self.approveDateLbl.text = self.formatDateTime(approvedDate)
                                self.nameLbl.text = name
                               
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
}
