//
//  applicationDoneVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//
import UIKit

protocol doneapplicationprotocol: AnyObject{
    func doneapplication(ispdfgenerated:String)
}

class applicationDoneVC: UIViewController {
    
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var holderview: UIView!
    
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var mobiledecodeArray: String?
    var decodeArray:String?
    var panNo: String?
    var regId: String?
    var PANName : String?
    var EmailId : String?
    var isPdfGenerated: String?
    weak var delegate : doneapplicationprotocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okBtn.layer.cornerRadius = 10
        holderview.layer.cornerRadius = 10
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
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func okBtn(_ sender: UIButton) {
        //delegate?.doneapplication(ispdfgenerated: "")
        if let userId = fetchedUserId {
            SIXTHAPI(userID: userId)
        } else {
            print("User ID is not fetched yet.")
        }
    }
    
    func SIXTHAPI(userID:String){
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W", in: self.view
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
            apiCall(url: sixthUrl, method: "POST", parameters: parameters, view: self.view,loaderText: "Kindly wait we are fetching your details...") { result in
                switch result {
                case .success(let jsonResponse):
                    print("GetActiveApplicationCL: \(jsonResponse)")
                    self.panNo = jsonResponse["PanNo"] as? String
                    self.regId = jsonResponse["RegId"] as? String
                    self.PANName = jsonResponse["PANName"] as? String
                    self.EmailId = jsonResponse["EmailId"] as? String
                    if let isPdfGenerated = jsonResponse["IsPdfGenerated"] as? String {
                        self.isPdfGenerated = isPdfGenerated
                        print("IsPdfGenerated value: \(self.isPdfGenerated ?? "")")
                    } else {
                        print("IsPdfGenerated key not found in response.")
                    }
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
                                self.delegate?.doneapplication(ispdfgenerated: self.isPdfGenerated ?? "")
                                self.dismiss(animated: true)
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
