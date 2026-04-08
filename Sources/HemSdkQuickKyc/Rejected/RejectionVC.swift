//
//  RejectionVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

class RejectionVC: UIViewController ,@MainActor ReloadPageDelegate, @MainActor doneapplicationprotocol{
    func reloadPageData() {
        print("Reloading data in RejectionVC")
        self.SIXTHAPI()
        //rejectionCollectionView.reloadData()
    }
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var rejectionCollectionView: UICollectionView!
    
    
    var panNo: String?
    var uccCode: String?
    var regId: String?
    var decodeArray: String?
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var rejectionList: [[String: Any]] = []
    weak var delegate: ReloadPageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        rejectionCollectionView.register(UINib(nibName: "RejectionCVC", bundle: Bundle.module), forCellWithReuseIdentifier: "RejectionCVC")
        self.submitBtn.layer.cornerRadius = 10
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.fetchedUserId = userId
                self.fetchedSessionID = sessionID
                self.decodeArray = decodeByteArrayString
                print("UserID: \(userId), SessionID: \(sessionID)")
                self.SIXTHAPI()
            } else {
                print("No UserID or SessionID found.")
            }
        }
        view.backgroundColor = .appBackground
    }
    
    func doneapplication(ispdfgenerated:String) {
        self.navigationController?.popToRootViewController(animated: true)
        
        if ispdfgenerated == "1" {
            // Navigate to esignVC
            let storyboard = UIStoryboard(name: "Esign", bundle: Bundle.module)
            let vc =
            storyboard.instantiateViewController(identifier: "ApplicationStatusVC")
            as! ApplicationStatusVC
            vc.PanNo = panNo
            vc.RegId = regId
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            // Pop to root view controller
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func submitVerificationBtn(_ sender: UIButton) {
        guard !rejectionList.isEmpty else {
                print("No rejection items found")
                return
            }

        for item in rejectionList {
               guard let documentName = item["DocumentName"] as? String else { continue }

               if handleNavigation(documentName: documentName) {
                   return
               }
            }

            print("All items already rectified")
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleNavigation(documentName: String) -> Bool {
        switch documentName {

        case "DOCUMENT DETAILS":
            let storyboard = UIStoryboard(name: "Document", bundle: Bundle.module)
            if let vc = storyboard.instantiateViewController(withIdentifier: "DocumentVC") as? DocumentVC {
                self.navigationController?.pushViewController(vc, animated: true)
                return true
            }
        case "BANK DETAILS":
            // navigate bank
            return false

        default:
            print("Unknown document: \(documentName)")
        }

        return false
    }
}

//extension RejectionVC:UICollectionViewDelegate,UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return rejectionList.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RejectionCVC", for: indexPath) as! RejectionCVC
//        
//        // Get the rejection data for the current index
//        let rejectionData = rejectionList[indexPath.row]
//        
//        // Set the documentName, panNo, and regId for each cell
//        cell.documentName = rejectionData["DocumentName"] as? String
//        cell.panNo = panNo  // Assuming panNo is available in the view controller
//        cell.regId = regId  // Assuming regId is available in the view controller
//        cell.navigationController = self.navigationController  // Pass navigation controller
//        cell.delegate = self
//        // Configure labels
//        cell.pageNamelabel.text = rejectionData["DocumentName"] as? String
//        cell.errorLabel.text = rejectionData["RejectRemark"] as? String
//        
//        if let modificationStatus = rejectionData["ModificationStatus"] as? String {
//            
//            if modificationStatus == "Y" {
//                cell.rectifiedBtn.isHidden = false
//                cell.RectifyBtn.isEnabled = false
//                cell.RectifyBtn.alpha = 1.0 // Dim the button to indicate it's disabled
//            } else {
//                cell.rectifiedBtn.isHidden = true
//                cell.RectifyBtn.isEnabled = true
//                cell.RectifyBtn.alpha = 1.0 // Restore button visibility
//            }
//        }
//        return cell
//    }
//}
//
//extension RejectionVC : UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.frame.width - 40)
//        let height = (collectionView.frame.height - 40)/2
//        return CGSize(width: width, height: height)
//    }
//}

extension RejectionVC{
    
    func SIXTHAPI(){
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.decodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.SIXTHAPI()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            
            let parameters: [String: Any] = [
                "UserId": self.fetchedUserId,
                "TokenId": tokenId
            ]
            
            print("6th api params\(parameters)")
            let sixthUrl = "ActiveApplication/GetActiveApplicationCL"
            
            // API call
            apiCall(url: sixthUrl, method: "POST", parameters: parameters, view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("GetActiveApplicationCL: \(jsonResponse)")
                    self.panNo = jsonResponse["PanNo"] as? String
                    self.regId = jsonResponse["RegId"] as? String
                    self.uccCode = jsonResponse["UccCode"] as? String
                    
                    if let rejectionArray = jsonResponse["RejectionList"] as? [[String: Any]] {
                        self.rejectionList = rejectionArray
                    }
             
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "999992":
                            // Handle token regeneration and retry logic
                            self.handleTokenError()
                            
                        case "000000":
                            // Success case: handle valid response
                            self.handleSuccessResponse(jsonResponse)
                        default:
                            // Handle unhandled error codes
                            print("Unhandled error code: \(errorCode)")
                        }
                    } else {
                        // Handle missing error code
                        print("Error code not found in response.")
                    }
                case .failure(let error):
                    print("SIXTHAPI API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func handleTokenError() {
        DispatchQueue.main.async {
            CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
            print("All TokenMobile entries deleted due to error code 999992")
            
            // Regenerate tokens and retry SIXTHAPI
            CoreDataHelper.generateToken(decodeByteArrayToString: self.decodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                if success {
                    // Retry SIXTHAPI after token regeneration
                    self.SIXTHAPI()
                } else {
                    print("Token generation failed.")
                }
            }
        }
    }
    
    private func handleSuccessResponse(_ jsonResponse: [String: Any]) {
        // Example: Check for specific fields in the successful response
        if let rejectionList = jsonResponse["RejectionList"] as? [[String: Any]] {
            print("Rejection list received: \(rejectionList)")
            
            self.rejectionList = rejectionList
          
//            DispatchQueue.main.async {
//                self.rejectionCollectionView.reloadData()
//            }
            
        } else {
            print("No rejection list found in the response.")
        }
    }
    
    func ValidateToken(){
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
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
    
    func UpdateFinalStatus(){
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.decodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.UpdateFinalStatus()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "UserId": fetchedUserId,
                "TokenId": tokenId,
                "RegId": regId,
                "PanNo": panNo,
                "isTermsAndCondition": "true",
                "UCCCode": "",
                "isCommodityCategoriDone": "0",
                "CommodityCategoriValue": "",
                "CommodityCategoriKey": "",
                "DeviceType": "W",
            ]
            print(parameters)
            let Url = "ClientSLFinalStatus/UpdateFinalStatus"
            
            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("UpdateFinalStatus Response: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            DispatchQueue.main.async {
                                let vc =
                                self.storyboard?.instantiateViewController(
                                    withIdentifier: "applicationDoneVC")
                                as! applicationDoneVC
                                vc.modalPresentationStyle = .overCurrentContext
                                vc.modalTransitionStyle = .crossDissolve
                                vc.delegate = self
                                self.present(vc, animated: true)
                            }
                        default:
                            print("Unhandled error code: \(errorCode)")
                        }
                    }
                case .failure(let error):
                    print("UpdateFinalStatus API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
}

