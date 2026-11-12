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
        // Called by BankVC / DocumentVC only after a successful save
        if let item = itemBeingRectified {
            locallyRectified.insert(item)
            itemBeingRectified = nil
        }
        self.SIXTHAPI()
        //rejectionCollectionView.reloadData()
    }
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var rejectionCollectionView: UICollectionView!
    @IBOutlet weak var messageLabel: UILabel!
    
    // List of rejected items (one row per item, like Android)
    private let listScrollView = UIScrollView()
    private let listStack = UIStackView()
    private var itemBeingRectified: String?          // item whose screen is open now
    private var locallyRectified = Set<String>()     // saved in this session, even if API is not updated yet
    
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
        setupRejectionList()
        submitBtn.isHidden = true   // shown only when every item is rectified
    }
    
    // MARK: - Rejection list UI
    
    private func setupRejectionList() {
        messageLabel?.isHidden = true   // old static message – replaced by the list
        
        listScrollView.translatesAutoresizingMaskIntoConstraints = false
        listScrollView.showsVerticalScrollIndicator = false
        view.addSubview(listScrollView)
        
        listStack.axis = .vertical
        listStack.spacing = 24
        listStack.translatesAutoresizingMaskIntoConstraints = false
        listScrollView.addSubview(listStack)
        
        let topAnchor = messageLabel?.topAnchor ?? view.safeAreaLayoutGuide.topAnchor
        NSLayoutConstraint.activate([
            listScrollView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            listScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            listScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            listScrollView.bottomAnchor.constraint(equalTo: submitBtn.topAnchor, constant: -10),
            
            listStack.topAnchor.constraint(equalTo: listScrollView.contentLayoutGuide.topAnchor),
            listStack.leadingAnchor.constraint(equalTo: listScrollView.contentLayoutGuide.leadingAnchor),
            listStack.trailingAnchor.constraint(equalTo: listScrollView.contentLayoutGuide.trailingAnchor),
            listStack.bottomAnchor.constraint(equalTo: listScrollView.contentLayoutGuide.bottomAnchor),
            listStack.widthAnchor.constraint(equalTo: listScrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    /// Builds one row per rejected item: [RECTIFY]  DOCUMENT NAME / remark
    private func renderRejectionList() {
        listStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, item) in rejectionList.enumerated() {
            let name = (item["DocumentName"] as? String) ?? (item["Document"] as? String) ?? ""
            let remark = (item["RejectRemark"] as? String) ?? ""
            let isRectified = isItemRectified(item)
            
            // Button
            let button = UIButton(type: .system)
            button.tag = index
            button.setTitle(isRectified ? "RECTIFIED" : "RECTIFY", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            button.backgroundColor = isRectified ? .systemGreen : .appPrimary
            button.layer.cornerRadius = 12
            button.isEnabled = !isRectified
            // Documents stay locked (dimmed) until Bank Details is rectified
            if !isRectified && isLockedUntilBankRectified(item) {
                button.alpha = 0.5
            }
            button.addTarget(self, action: #selector(rectifyTapped(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 120),
                button.heightAnchor.constraint(equalToConstant: 44)
            ])
            
            // Name + remark
            let nameLabel = UILabel()
            nameLabel.text = name
            nameLabel.font = .systemFont(ofSize: 13, weight: .medium)
            nameLabel.textColor = .appPrimary
            nameLabel.numberOfLines = 0
            
            let remarkLabel = UILabel()
            remarkLabel.text = remark
            remarkLabel.font = .systemFont(ofSize: 14)
            remarkLabel.textColor = .darkGray
            remarkLabel.numberOfLines = 0
            remarkLabel.isHidden = remark.isEmpty
            
            let textStack = UIStackView(arrangedSubviews: [nameLabel, remarkLabel])
            textStack.axis = .vertical
            textStack.spacing = 4
            
            let row = UIStackView(arrangedSubviews: [button, textStack])
            row.axis = .horizontal
            row.spacing = 12
            row.alignment = .center
            listStack.addArrangedSubview(row)
        }
        
        // All items rectified → let the user submit for verification
        let allRectified = !rejectionList.isEmpty && rejectionList.allSatisfy { isItemRectified($0) }
        submitBtn.isHidden = !allRectified
        submitBtn.setTitle("Submit for Verification", for: .normal)
    }
    
    private func itemName(_ item: [String: Any]) -> String {
        ((item["DocumentName"] as? String) ?? (item["Document"] as? String) ?? "").uppercased()
    }
    
    private func isItemRectified(_ item: [String: Any]) -> Bool {
        (item["ModificationStatus"] as? String) == "Y" || locallyRectified.contains(itemName(item))
    }
    
    /// Bank Details must be rectified before Document Details can be opened
    private func isBankDetailsPending() -> Bool {
        rejectionList.contains { itemName($0) == "BANK DETAILS" && !isItemRectified($0) }
    }
    
    private func isLockedUntilBankRectified(_ item: [String: Any]) -> Bool {
        itemName(item) == "DOCUMENT DETAILS" && isBankDetailsPending()
    }
    
    /// True when some item other than `name` still needs rectifying
    private func hasOtherPendingItems(than name: String) -> Bool {
        rejectionList.contains { itemName($0) != name && !isItemRectified($0) }
    }
    
    @objc private func rectifyTapped(_ sender: UIButton) {
        guard sender.tag < rejectionList.count else { return }
        let name = itemName(rejectionList[sender.tag])
        itemBeingRectified = name
        
        switch name {
        case "BANK DETAILS":
            openBankDetails()
        case "DOCUMENT DETAILS":
            if isBankDetailsPending() {
                itemBeingRectified = nil
                showAlert(message: "Please rectify Bank Details first.")
                return
            }
            handleNavigation()
        default:
            print("No screen mapped for rejected item: \(name)")
            showAlert(message: "Please contact support to rectify \(name.capitalized).")
        }
    }
    
    /// Same as Android: "Bank Account Details" screen (Verify with UPI / Add Bank Manually)
    private func openBankDetails() {
        let storyboard = UIStoryboard(name: "Bank", bundle: Bundle.module)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "UPIVC") as? UPIVC else {
            print("❌ UPIVC not found in Bank.storyboard")
            return
        }
        let savedPAN = UserDefaults.standard.string(forKey: "PanNo")
        let savedRegId = UserDefaults.standard.string(forKey: "RegId")
        let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : panNo
        let finalRegId = (savedRegId?.isEmpty == false) ? savedRegId : regId
        vc.panNo = finalPAN
        vc.PanNo = finalPAN
        vc.regId = finalRegId
        vc.RegId = finalRegId
        vc.rejection = "Rejection"     // back → this screen; success → this screen
        vc.delegate = self             // reloadPageData() → list refreshes
        navigationController?.pushViewController(vc, animated: true)
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
        // Button is only visible once every item is rectified
        UpdateFinalStatus()
        
//        for item in rejectionList {
//            guard let documentName = item["DocumentName"] as? String else { continue }
//            
//            if handleNavigation() {
//                return
//            }
//        }
//        
//        print("All items already rectified")
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleNavigation() {
        let storyboard = UIStoryboard(name: "Document", bundle: Bundle.module)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DocumentVC") as? DocumentVC {
            
            let savedPAN = UserDefaults.standard.string(forKey: "PanNo")
            let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.panNo
            
            let regId = UserDefaults.standard.string(forKey: "RegId")
            let regIdFinal = (regId?.isEmpty == false) ? regId : self.regId
            vc.PanNo = finalPAN
            vc.rejection = "Rejection"
            vc.RegId = regIdFinal
            vc.delegate = self              // reloadPageData() refreshes this list
            vc.isFromRejectionFlow = true
            // If Bank Details is still pending, only save the documents and come back here.
            // If documents are the last item, DocumentVC submits for verification as before.
            vc.returnToRejectionList = hasOtherPendingItems(than: "DOCUMENT DETAILS")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
    
//        switch documentName {
//
//        case "DOCUMENT DETAILS":
//            let storyboard = UIStoryboard(name: "Document", bundle: Bundle.module)
//            if let vc = storyboard.instantiateViewController(withIdentifier: "DocumentVC") as? DocumentVC {
//                
//                let savedPAN = UserDefaults.standard.string(forKey: "PanNo")
//                let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.panNo
//                                                
//                let regId = UserDefaults.standard.string(forKey: "RegId")
//                let regIdFinal = (regId?.isEmpty == false) ? regId : self.regId
//                vc.PanNo = finalPAN
//                vc.rejection = "Rejection"
//                vc.RegId = regIdFinal
//                vc.delegate = delegate
//                vc.isFromRejectionFlow = true
//                self.navigationController?.pushViewController(vc, animated: true)
//                return true
//            }
//        case "BANK DETAILS":
//            // navigate bank
//            return false
//
//        default:
//            print("Unknown document: \(documentName)")
//        }
//
//        return false
//    }
//}

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
            DispatchQueue.main.async {
                self.renderRejectionList()
            }
          
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

