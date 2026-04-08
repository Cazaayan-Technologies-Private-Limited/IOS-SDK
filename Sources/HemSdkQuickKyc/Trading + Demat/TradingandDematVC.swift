//
//  TradingandDematVC.swift
//  t5
//
//  Created by manas dutta on 18/12/25.
//

//import UIKit
//
//protocol BrokerageSelectionDelegate: AnyObject {
//    func didSelectBrokerage(_ plan: BrokeragePlan, filter: BrokerageFilter)
//}
//
//class TradingandDematVC: UIViewController, @MainActor funcCallBack, @MainActor BrokerageSelectionDelegate, @MainActor DepositorySelectionDelegate, @MainActor CommodityCategoryVCDelegate {
//    func didSelectCommodityValues(selectedValues: [String : String]) {
//        // Save full dictionary
//        self.selectedCommodityDict = selectedValues
//        // Convert to arrays/strings if needed
//        self.selectedKeys = Array(selectedValues.keys).joined(separator: ", ")
//        self.selectedValues = Array(selectedValues.values).joined(separator: ", ")
//        print("Selected Keys: \(self.selectedKeys)")
//        print("Selected Values: \(self.selectedValues)")
//    }
//
//    func didSelectDepository(type: String, IsDpAccountNew: String) {
//        switch IsDpAccountNew {
//        case "Y":
//            depositoryLabel.text = "CDSL"
//            Depositoryname = "CDSL"
//        case "N":
//            depositoryLabel.text = type
//            Depositoryname = type
//            dematIdView.isHidden = false
//            //  boIDview.isHidden = false
//
//            // Check if the selected depository is NSDL or CDSL
//            if type == "NSDL" {
//                // Set the prefix "IN" to dematIDTF if NSDL is selected
//                dematIDTF.text = "IN"
//            } else if type == "CDSL" {
//                // Clear the text field for CDSL, no prefix is set
//                dematIDTF.text = "12"
//            }
//
//        default:
//            break
//        }
//    }
//    func didSelectSegmentBtn(index: Int) {
//
//        if selectedIndexes.contains(index) {
//            selectedIndexes.remove(index)   // ❌ unselect
//        } else {
//            selectedIndexes.insert(index)   // ✅ select
//        }
//
//        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
//
//        print("Selected Segments:",
//              selectedIndexes.map { segments[$0] })
//
//    }
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var equityBtn: UIButton!
//    @IBOutlet weak var mtfBtn: UIButton!
//    @IBOutlet weak var commodityBtn: UIButton!
//    @IBOutlet weak var selectBrokerage: UIButton!
//    @IBOutlet weak var firstAccountopnCharges: UILabel!
//    @IBOutlet weak var test1: UILabel!
//    @IBOutlet weak var test1EditBtn: UIButton!
//    @IBOutlet weak var secondAccountopnCharges: UILabel!
//    @IBOutlet weak var dematYesBtn: UIButton!
//    @IBOutlet weak var dematNoBtn: UIButton!
//    @IBOutlet weak var dematCharges: UILabel!
//    @IBOutlet weak var dematView: UIButton!
//    @IBOutlet weak var dematChargesLbl: UILabel!
//    @IBOutlet weak var firstSubTotalLbl: UILabel!
//    @IBOutlet weak var firstGSTLbl: UILabel!
//    @IBOutlet weak var firstAccountPayableLbl: UILabel!
//    @IBOutlet weak var test2: UILabel!
//    @IBOutlet weak var test2EditBtn: UIButton!
//    @IBOutlet weak var commodityCategoriesBtn: UIButton!
//    @IBOutlet weak var accountView: UIView!
//    @IBOutlet weak var subTotalView: UIView!
//    @IBOutlet weak var payableView: UIView!
//    @IBOutlet weak var marginView: UIView!
//    @IBOutlet weak var thirdAccountopnCharges: UILabel!
//    @IBOutlet weak var secondSubTotalLbl: UILabel!
//    @IBOutlet weak var secondGSTLbl: UILabel!
//    @IBOutlet weak var secondAccountPayableLbl: UILabel!
//    @IBOutlet weak var marginLbl: UILabel!
//    @IBOutlet weak var nodematView: UIView!
//    @IBOutlet weak var depositoryView: UIView!
//    @IBOutlet weak var depositoryLabel: UILabel!
//    @IBOutlet weak var depositoryButton: UIButton!
//    @IBOutlet weak var dematNameView: UIView!
//    @IBOutlet weak var dematNameTF: UITextField!
//    @IBOutlet weak var dematIdView: UIView!
//    @IBOutlet weak var dematIDTF: UITextField!
//    @IBOutlet weak var boIDView: UIView!
//    @IBOutlet weak var BOIDTF: UITextField!
//    @IBOutlet weak var selectBrokerage2Btn: UIButton!
//    @IBOutlet weak var edit1Stack: UIStackView!
//    @IBOutlet weak var edit2Stack: UIStackView!
//    @IBOutlet weak var account1View: UIView!
//    @IBOutlet weak var account2View: UIView!
//    @IBOutlet weak var dematStackView: UIStackView!
//    @IBOutlet weak var demat1View: UIView!
//    @IBOutlet weak var sub1View: UIView!
//    @IBOutlet weak var account3View: UIView!
//
//
//    var regId: String?
//    public let segments = ["Equity Cash", "F&O", "Currency", "Mutual Fund", "SLBM"]
//    private var selectedIndexes: Set<Int> = []
//    var panNo: String?
//    var EmailId: String?
//    var PANName: String?
//    var RegId: String?
//    var mobiledecodeArray: String?
//    var fetchedUserId: String?
//    var fetchedSessionID: String?
//    var transactionID: String?
//    var rejection: String?
//    var Depositoryname: String?
//    var IsSchemeExternal: String?
//    var selectBSDA: String?
//    var IsDpAccountNew: String?
//    var DPSchemeCode: String?
//    var DPSchemename: String?
//    var DPName: String?
//    var DPID: String?
//    var BOID: String?
//    var dob: String?
//    var selectedCommodityDict: [String: String] = [:]
//    var selectedKeys: String = ""
//    var selectedValues: String = ""
//    public var isMTFSelected = false
//    public var isCommoditySelected = false
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupCollectionView()
//
//        test1.isHidden = true
//        test1EditBtn.isHidden = true
//        dematCharges.isHidden = true
//        dematView.isHidden = true
//        test2.isHidden = true
//        test2EditBtn.isHidden = true
//        marginView.isHidden = true
//        commodityCategoriesBtn.isHidden = true
//        accountView.isHidden = true
//        subTotalView.isHidden = true
//        payableView.isHidden = true
//        nodematView.isHidden = true
//        DPSchemeName()
//        ViewDPScheme()
//        nodematView.layer.cornerRadius = 10
//        depositoryView.layer.cornerRadius = 10
//        dematNameView.layer.cornerRadius = 10
//        dematIdView.layer.cornerRadius = 10
//        boIDView.layer.cornerRadius = 10
//        selectBrokerage2Btn.isHidden = true
//        edit1Stack.isHidden = true
//        edit2Stack.isHidden = true
//
//        account1View.layer.cornerRadius = 10
//        account1View.layer.borderWidth = 0.5
//        account1View.layer.borderColor = UIColor.lightGray.cgColor
//        account2View.layer.cornerRadius = 10
//        account2View.layer.borderWidth = 0.5
//        account2View.layer.borderColor = UIColor.lightGray.cgColor
//        dematStackView.layer.cornerRadius = 10
//        dematStackView.layer.borderWidth = 0.5
//        dematStackView.layer.borderColor = UIColor.lightGray.cgColor
//        demat1View.layer.cornerRadius = 10
//        demat1View.layer.borderWidth = 0.5
//        demat1View.layer.borderColor = UIColor.lightGray.cgColor
//        sub1View.layer.cornerRadius = 10
//        sub1View.layer.borderWidth = 0.5
//        sub1View.layer.borderColor = UIColor.lightGray.cgColor
//        account3View.layer.cornerRadius = 10
//        account3View.layer.borderWidth = 0.5
//        account3View.layer.borderColor = UIColor.lightGray.cgColor
//        accountView.layer.cornerRadius = 10
//        accountView.layer.borderWidth = 0.5
//        accountView.layer.borderColor = UIColor.lightGray.cgColor
//        subTotalView.layer.cornerRadius = 10
//        subTotalView.layer.borderWidth = 0.5
//        subTotalView.layer.borderColor = UIColor.lightGray.cgColor
//        payableView.layer.cornerRadius = 10
//        payableView.layer.borderWidth = 0.5
//        payableView.layer.borderColor = UIColor.lightGray.cgColor
//        marginView.layer.cornerRadius = 10
//        marginView.layer.borderWidth = 0.5
//        marginView.layer.borderColor = UIColor.lightGray.cgColor
//        dematStackView.backgroundColor = UIColor.white
//
//        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self]
//            userId, sessionID, decodeByteArrayString in
//
//            guard let self = self else { return }
//
//            guard let userId = userId,
//                  let sessionID = sessionID else {
//                print("❌ No UserID or SessionID found.")
//                return
//            }
//
//            self.fetchedUserId = userId
//            self.fetchedSessionID = sessionID
//            self.mobiledecodeArray = decodeByteArrayString
//
//            print("✅ UserID: \(userId), SessionID: \(sessionID)")
//
//            // ✅ NOW SAFE TO CALL APIs
//            self.DPSchemeName()
//            self.ViewDPScheme()
//            self.brokeragePlan()
//            self.insertWeb()
//            self.comoditySave()
//        }
//
//        dematYesBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//        dematNoBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//        navigationItem.hidesBackButton = true
//    }
//
//    @IBAction func backBtn(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//
//    @IBAction func homeBtn(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "ApplicationForm", bundle: Bundle.module)
//        let vc = storyboard.instantiateViewController(identifier: "ApplicationFormVC") as? ApplicationFormVC
//        vc?.panNo = panNo
//        self.navigationController?.pushViewController(vc! , animated: true)
//    }
//
//
//    func isSegmentSelected(_ index: Int) -> String {
//        return selectedIndexes.contains(index) ? "1" : "0"
//    }
//
//    @IBAction func selectBrokerageTapped(_ sender: UIButton) {
//        let vc = UIStoryboard(
//            name: "BrokerageVC",
//            bundle: Bundle.module
//        ).instantiateViewController(withIdentifier: "BrokerageVC") as! BrokerageVC
//
//        vc.filter = .equity
//        vc.delegate = self
//        present(vc, animated: true)
//    }
//
//    @IBAction func test1EditBtnTapped(_ sender: UIButton) {
//        let vc = UIStoryboard(
//            name: "BrokerageVC",
//            bundle: Bundle.module
//        ).instantiateViewController(withIdentifier: "BrokerageVC") as! BrokerageVC
//
//        vc.filter = .equity
//        vc.delegate = self
//        present(vc, animated: true)
//    }
//
//    @IBAction func dematYesBtn(_ sender: UIButton) {
//        IsDpAccountNew = "Y"
//        dematYesBtn.setImage(UIImage(systemName: "circle.fill"), for: .normal)
//        dematNoBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//        //        dematCharges.isHidden = false
//        //        dematView.isHidden = false
//        dematCharges.isHidden = false
//        dematView.isHidden = false
//        nodematView.isHidden = true
//    }
//
//
//    @IBAction func dematNoBtn(_ sender: UIButton) {
//        IsDpAccountNew = "N"
//        dematNoBtn.setImage(UIImage(systemName: "circle.fill"), for: .normal)
//        dematYesBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//        //nodematView.isHidden = false
//        nodematView.isHidden = false
//        dematCharges.isHidden = true
//        dematView.isHidden = true
//    }
//
//    @IBAction func dematViewBtn(_ sender: UIButton) {
//
//        let storyboard = UIStoryboard(
//            name: "Demat",
//            bundle: Bundle.module
//        )
//
//        let vc = storyboard.instantiateViewController(
//            withIdentifier: "DpPlanVC"
//        ) as! DpPlanVC
//
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//
//        vc.IsSchemeExternal = IsSchemeExternal
//        vc.fetchedSessionID = fetchedSessionID
//        vc.fetchedUserId = fetchedUserId
//
//        self.present(vc, animated: true)
//        ViewDPDetails()
//    }
//
//
//    @IBAction func test2EditBtn(_ sender: UIButton) {
//        let vc = UIStoryboard(
//            name: "BrokerageVC",
//            bundle: Bundle.module
//        ).instantiateViewController(withIdentifier: "BrokerageVC") as! BrokerageVC
//
//        vc.filter = .commodity
//        vc.delegate = self
//        present(vc, animated: true)
//    }
//
//
//    @IBAction func commodityCategoryBtnTapped(_ sender: UIButton) {
//        let vc =
//        storyboard?.instantiateViewController(
//            identifier: "commodityCategoryVC") as! commodityCategoryVC
//        vc.panNo = panNo
//        vc.regId = regId
//        vc.delegate = self
//
//        vc.selectedCommodityValues = self.selectedCommodityDict
//        vc.selectedCommodityKeys = Array(self.selectedCommodityDict.keys)
//        vc.selectedCommodityValuesArray = Array(self.selectedCommodityDict.values)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//
//    @IBAction func savenext(_ sender: UIButton) {
//        insertWeb()
//        comoditySave()
//        paymentRequest()
//        DispatchQueue.main.async {
//            let storyboard = UIStoryboard(name: "Bank", bundle: Bundle.module)
//            let vc = storyboard.instantiateViewController(identifier: "BankVC") as! BankVC
//            vc.panNo = self.panNo
//            vc.regId = self.regId
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//
//
//    @IBAction func depositoryNameBtn(_ sender: UIButton) {
//        if let vc = storyboard?.instantiateViewController(
//            withIdentifier: "DepositoryVC") as? DepositoryVC
//        {
//            vc.modalPresentationStyle = .overCurrentContext
//            vc.IsDpAccountNew = IsDpAccountNew
//            vc.delegate = self
//            vc.modalTransitionStyle = .crossDissolve
//            self.present(vc, animated: true, completion: nil)
//        }
//    }
//
//    @IBAction func mtfBtnTapped(_ sender: UIButton) {
//        isMTFSelected.toggle()
//        updateMTFCommodityUI()
//    }
//
//    @IBAction func selectBrokerage2Tapped(_ sender: UIButton) {
//        let vc = UIStoryboard(
//            name: "BrokerageVC",
//            bundle: Bundle.module
//        ).instantiateViewController(withIdentifier: "BrokerageVC") as! BrokerageVC
//
//        vc.filter = .commodity
//        vc.delegate = self
//        present(vc, animated: true)
//    }
//
//    @IBAction func commodityBtnTapped(_ sender: UIButton) {
//        isCommoditySelected.toggle()
//        updateMTFCommodityUI()
//    }
//
//    func didSelectBrokerage(_ plan: BrokeragePlan, filter: BrokerageFilter) {
//
//        switch filter {
//        case .equity:
//            test1.text = plan.name
//            edit1Stack.isHidden = false
//            test1.isHidden = false
//            test1EditBtn.isHidden = false
//
//        case .commodity:
//            test2.text = plan.name
//            edit2Stack.isHidden = false
//            test2.isHidden = false
//            test2EditBtn.isHidden = false
//        }
//    }
//
//    func updateMTFCommodityUI() {
//
//        // MTF checkbox
//        mtfBtn.setImage(
//            UIImage(systemName: isMTFSelected ? "checkmark.square.fill" : "square"),
//            for: .normal
//        )
//        marginView.isHidden = !isMTFSelected
//
//
//        // Commodity checkbox
//        commodityBtn.setImage(
//            UIImage(systemName: isCommoditySelected ? "checkmark.square.fill" : "square"),
//            for: .normal
//        )
//
//        selectBrokerage2Btn.isHidden = !isCommoditySelected
//        commodityCategoriesBtn.isHidden = !isCommoditySelected
//        accountView.isHidden = !isCommoditySelected
//        subTotalView.isHidden = !isCommoditySelected
//        payableView.isHidden = !isCommoditySelected
//    }
//
//    func brokeragePlan() {
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
//            [self] tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                    if success {
//                        // Call SIXTHAPI after tokenMobile API call is successful
//                        self.brokeragePlan()
//                        //self.panValidation(panNo: panNo, name: name, userDOB: userDOB, isGuardian: isGuardian)
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            let parameters: [String: Any?] = [
//                "RegId": regId,
//                "UserId": fetchedUserId,
//                "TokenId": tokenId,
//                "SessionId": fetchedSessionID,
//            ]
//            print(parameters)
//            let Url = "BrokeragePlan/ViewNONAPIBrokeragePlanClientForClient"
//
//            apiCall(
//                url: Url, method: "POST",
//                parameters: parameters as [String: Any], view: self.view,
//                loaderText: "please wait..."
//            ) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("BrokeragePlan Response: \(jsonResponse)")
//                    //                    let DigiLockerURL = jsonResponse["DigiLockerURL"] as? String
//                    //                    let digilockerReturnURL =
//                    //                    jsonResponse["DigiLockeReturnURL"] as? String
//                    //                    let Client_id = jsonResponse["Client_id"] as? String
//                    //                    let TransactionID = jsonResponse["TransactionID"] as? String
//
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "999992":
//                            DispatchQueue.main.async {
//
//                            }
//                        case "000000":
//                            DispatchQueue.main.async {
//
//                            }
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                        }
//                    }
//                case .failure(let error):
//                    print(
//                        "Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//    func ValidateToken() {
//
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
//            [self] tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile", deviceType: "W", in: self.view
//                ) { success in
//                    if success {
//                        // Retry SIXTHAPI after token regeneration
//                        self.ValidateToken()
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            let parameters: [String: Any?] = [
//                "UserId": fetchedUserId,
//                "TokenId": tokenId,
//            ]
//            print(parameters)
//            let Url = "TokenAuthentication/ValidateToken"
//
//            apiCall(
//                url: Url, method: "POST",
//                parameters: parameters as [String: Any], view: self.view
//            ) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("ValidateToken Response: \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "000000":
//                            DispatchQueue.main.async {
//                                print("api is running")
//                            }
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                        }
//                    }
//                case .failure(let error):
//                    print(
//                        "Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//    func DPSchemeName() {
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
//            [self] tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                    if success {
//                        // Call SIXTHAPI after tokenMobile API call is successful
//                        self.DPSchemeName()
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            let parameters: [String: Any?] = [
//                "UserId": fetchedUserId,
//                "SessionID": fetchedSessionID,
//                "DPSchemeCode": "",
//                "DPSchemeName": "",
//                "TokenId": tokenId,
//                "IsSchemeExternal": "0",
//            ]
//            print(parameters)
//            let Url = "DropDownManagement/DPSchemeName"
//
//            apiCall(
//                url: Url, method: "POST",
//                parameters: parameters as [String: Any], view: self.view
//            ) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("DPSchemeName Response: \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "000000":
//                            DispatchQueue.main.async {
//                                print("api is running")
//                            }
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                        }
//                    }
//                case .failure(let error):
//                    print(
//                        "Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//
//    func ViewDPScheme() {
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
//            [self] tokenId in
//            guard let tokenId = tokenId else {
//
//                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                    if success {
//                        // Call SIXTHAPI after tokenMobile API call is successful
//                        self.ViewDPScheme()
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            let parameters: [String: Any?] = [
//                "UserId": fetchedUserId,
//                "SessionID": fetchedSessionID,
//                "DPSchemeCode": DPSchemeCode,
//                "DPSchemeName": DPSchemename,
//                "TokenId": tokenId,
//                "IsSchemeExternal": "0",
//                "ALL": false,
//                // "ALL": false,
//                //"IsSchemeExternal": IsSchemeExternal
//            ]
//            print(parameters)
//            let Url = "DPScheme/ViewDPScheme"
//
//            apiCall(
//                url: Url, method: "POST",
//                parameters: parameters as [String: Any], view: self.view
//            ) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("DPSchemeName Response: \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "000000":
//                            DispatchQueue.main.async {
//                                print("api is running")
//                            }
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                        }
//                    }
//                case .failure(let error):
//                    print(
//                        "Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//    func ViewDPDetails() {
//
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
//            [self] tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                    if success {
//                        // Call SIXTHAPI after tokenMobile API call is successful
//                        self.ViewDPDetails()
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            let parameters: [String: Any?] = [
//                "UserId": fetchedUserId,
//                "TokenId": tokenId,
//                "RegId": regId,
//                "PanNo": panNo,
//            ]
//
//            print(parameters)
//            let Url = "DPDetails/ViewDPDetails"
//
//            apiCall(
//                url: Url, method: "POST",
//                parameters: parameters as [String: Any], view: self.view
//            ) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("ViewDPDetails Response: \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "000000":
//                            DispatchQueue.main.async {
//                                // self.updateui(with: jsonResponse)
//                            }
//                        case "999992":
//                            DispatchQueue.main.async {
//                                CoreDataHelper.deleteAllTokens(
//                                    entityName: "TokenMobile")
//                                print(
//                                    "All TokenMobile entries deleted due to error code 999992"
//                                )
//                                CoreDataHelper.generateToken(
//                                    decodeByteArrayToString: self
//                                        .mobiledecodeArray ?? "",
//                                    USERID: self.fetchedUserId ?? "",
//                                    SessionId: self.fetchedSessionID ?? "",
//                                    entityName: "TokenMobile", deviceType: "W",
//                                    in: self.view
//                                ) { success in
//                                    if success {
//                                        self.ViewDPDetails()
//                                    } else {
//                                        print("Token generation failed.")
//                                    }
//                                }
//                            }
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                        }
//                    }
//                case .failure(let error):
//                    print(
//                        "Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//    func comoditySave() {
//
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
//            [self] tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                    if success {
//                        // Call SIXTHAPI after tokenMobile API call is successful
//                        self.insertWeb()
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//
//            let parameters: [String: Any?] = [
//                "RegId": regId,
//                "UserId": fetchedUserId,
//                "PanNo": panNo,
//                "TokenId": tokenId,
//                "CommodityCategoriKey": selectedKeys,
//                "isCommodityCategoriDone": 0,
//                "CommodityCategoriValue": selectedValues
//            ]
//
//            print(parameters)
//            let Url = "Client/commoditysave"
//
//            apiCall(
//                url: Url, method: "POST",
//                parameters: parameters as [String: Any], view: self.view
//            ) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("comoditySave Response: \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "000000":
//                            DispatchQueue.main.async {
//                                // self.updateui(with: jsonResponse)
//                            }
//                        case "999992":
//                            DispatchQueue.main.async {
//                                CoreDataHelper.deleteAllTokens(
//                                    entityName: "TokenMobile")
//                                print(
//                                    "All TokenMobile entries deleted due to error code 999992"
//                                )
//                                CoreDataHelper.generateToken(
//                                    decodeByteArrayToString: self
//                                        .mobiledecodeArray ?? "",
//                                    USERID: self.fetchedUserId ?? "",
//                                    SessionId: self.fetchedSessionID ?? "",
//                                    entityName: "TokenMobile", deviceType: "W",
//                                    in: self.view
//                                ) { success in
//                                    if success {
//                                        self.ViewDPDetails()
//                                    } else {
//                                        print("Token generation failed.")
//                                    }
//                                }
//                            }
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                        }
//                    }
//                case .failure(let error):
//                    print(
//                        "Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//
//    func insertWeb() {
//
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
//            [self] tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                    if success {
//                        // Call SIXTHAPI after tokenMobile API call is successful
//                        self.comoditySave()
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            let parameters: [String: Any?] = [
//                "RegId": regId,
//                "UserId": fetchedUserId,
//                "PanNo": panNo,
//                "IsDpAccountNew": self.IsDpAccountNew ?? "N",
//                "Depositoryname": self.Depositoryname ?? "",
//                "DPName": self.DPName ?? self.dematNameTF.text ?? "",
//                "DPID": self.DPID ?? self.dematIDTF.text ?? "",
//                "BOID": self.BOID ?? self.BOIDTF.text ?? "",
//                "BSDA": nil,
//                "DPScheme": self.DPSchemeCode ?? "",
//                "CreatedBy": nil,
//                "ModifiedBy": nil,
//                "TokenId": tokenId,
//                "IsDpExternal": "0",
//                "DPBrokerName": "string",
//                "BrowserName": nil,
//                "BrowserVersion": nil,
//                "OS": nil,
//                "OSVersion": nil,
//                "IPAddress": nil,
//                "DeviceType": "W",
//                "UserAgent": nil
//            ]
//
//            print(parameters)
//            let Url = "DPDetails/InsertUpdateDPetails_Web"
//
//            apiCall(
//                url: Url, method: "POST",
//                parameters: parameters as [String: Any], view: self.view
//            ) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("InsertUpdateDPetails_Web Response: \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "000000":
//                            DispatchQueue.main.async {
//                                // self.updateui(with: jsonResponse)
//                            }
//                        case "999992":
//                            DispatchQueue.main.async {
//                                CoreDataHelper.deleteAllTokens(
//                                    entityName: "TokenMobile")
//                                print(
//                                    "All TokenMobile entries deleted due to error code 999992"
//                                )
//                                CoreDataHelper.generateToken(
//                                    decodeByteArrayToString: self
//                                        .mobiledecodeArray ?? "",
//                                    USERID: self.fetchedUserId ?? "",
//                                    SessionId: self.fetchedSessionID ?? "",
//                                    entityName: "TokenMobile", deviceType: "W",
//                                    in: self.view
//                                ) { success in
//                                    if success {
//                                        self.ViewDPDetails()
//                                    } else {
//                                        print("Token generation failed.")
//                                    }
//                                }
//                            }
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                        }
//                    }
//                case .failure(let error):
//                    print(
//                        "Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//    func paymentRequest() {
//
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
//            [self] tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                    if success {
//                        // Call SIXTHAPI after tokenMobile API call is successful
//                        self.paymentRequest()
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            let isEquityCash       = isSegmentSelected(0)
//            let isEquityFNO        = isSegmentSelected(1)
//            let isEquityCurrency   = isSegmentSelected(2)
//            let isEquityMutualFund = isSegmentSelected(3)
//            let isEquitySLBM       = isSegmentSelected(4)
//
//            let parameters: [String: Any?] = [
//                "IsPaymentGetwayAllow": 0,
//                "TxnId": nil,
//                "RegId": regId,
//                "UserId": fetchedUserId,
//                "PanNo": panNo,
//                "TokenId": tokenId,
//                "Type": nil,
//                "IsEquitySelect": isEquityCash,
//                "IsEquityFNOSelect": isEquityFNO,
//                "IsEquityCurrencySelect": isEquityCurrency,
//                "IsEquityMutualFundSelect": isEquityMutualFund,
//                "IsEquitySLBMSelect": isEquitySLBM,
//                "IsCommoditySelect": isCommoditySelected ? "1" : "0",
//                "BrokeragePlanEquityName": test1.text ?? "",
//                "BrokeragePlanCommodityName": test2.text ?? "",
//                "IsForEquityMargin": "0",
//                "IsForCommodityMargin": "0",
//                "EquityMarginAmount": "0",
//                "CommodityMarginAmount": "0",
//                "TransactionID": nil,
//                "PaymentGetWay": nil,
//                "IsMTFSelect": isMTFSelected ? "1" : "0"
//            ]
//
//            print(parameters)
//            let Url = "Client/PaymentRequestOnTrading"
//
//            apiCall(
//                url: Url, method: "POST",
//                parameters: parameters as [String: Any], view: self.view
//            ) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("paymentRequest Response: \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "000000":
//                            DispatchQueue.main.async {
//                                // self.updateui(with: jsonResponse)
//                            }
//                        case "999992":
//                            DispatchQueue.main.async {
//                                CoreDataHelper.deleteAllTokens(
//                                    entityName: "TokenMobile")
//                                print(
//                                    "All TokenMobile entries deleted due to error code 999992"
//                                )
//                                CoreDataHelper.generateToken(
//                                    decodeByteArrayToString: self
//                                        .mobiledecodeArray ?? "",
//                                    USERID: self.fetchedUserId ?? "",
//                                    SessionId: self.fetchedSessionID ?? "",
//                                    entityName: "TokenMobile", deviceType: "W",
//                                    in: self.view
//                                ) { success in
//                                    if success {
//                                        self.ViewDPDetails()
//                                    } else {
//                                        print("Token generation failed.")
//                                    }
//                                }
//                            }
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                        }
//                    }
//                case .failure(let error):
//                    print(
//                        "Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//    func updateUI(with response: [String: Any]) {
//
//        if IsDpAccountNew == "Y" {
//            // 1. Check if Depositoryname is nil or empty
//
//            DPName = nil
//            DPID = nil
//            BOID = nil
//
//            guard let depositoryName = Depositoryname, !depositoryName.isEmpty
//            else {
//                showAlert(message: "Please select depository name")
//                return
//            }
//
//            // 2. Check if selectBSDA is nil
//            guard let bsdaSelection = selectBSDA else {
//                showAlert(message: "Please select BSDA button")
//                return
//            }
//
//            // 3. Check if DPSchemeCode is nil
//            guard let schemeCode = DPSchemeCode, !schemeCode.isEmpty else {
//                showAlert(message: "Please select scheme")
//                return
//            }
//
//            // All validations passed for "Y" case, proceed to call the API
//            insertWeb()
//
//        } else if IsDpAccountNew == "N" {
//            // If IsDpAccountNew is "N", reset values for the "Y" case
//            selectBSDA = nil
//            //Depositoryname = nil
//            selectBSDA = nil
//            DPSchemeCode = nil
//            IsSchemeExternal = nil
//
//            guard let depositoryName = Depositoryname, !depositoryName.isEmpty
//            else {
//                showAlert(message: "Please select depository name")
//                return
//            }
//
//            // Validate DPID (dematIDTF)
//            guard let dematID = dematIDTF.text, !dematID.isEmpty else {
//                showAlert(message: "Please enter demat ID")
//                return
//            }
//
//            // Special validation for NSDL and CDSL
//            if let depositoryName = Depositoryname {
//                if depositoryName == "NSDL" {
//                    // NSDL must have "IN" prefix and 6 additional digits
//                    if !dematID.hasPrefix("IN") || dematID.count != 8 {
//                        showAlert(
//                            message:
//                                "NSDL Demat ID must start with 'IN' and be followed by 6 digits"
//                        )
//                        return
//                    }
//                } else if depositoryName == "CDSL" {
//                    // CDSL must be exactly 8 digits
//                    if !isValidID(dematID) || dematID.count != 8 {
//                        showAlert(
//                            message: "CDSL Demat ID must be exactly 8 digits")
//                        return
//                    }
//                }
//            }
//
//            // Validate BOID
//            guard let boID = BOIDTF.text, !boID.isEmpty else {
//                showAlert(message: "Please enter BOID")
//                return
//            }
//
//            guard let dematName = dematNameTF.text, !dematName.isEmpty else {
//                showAlert(message: "Please enter demat name")
//                return
//            }
//
//            if !isValidID(boID) || boID.count != 8 {
//                showAlert(message: "BOID must be exactly 8 digits")
//                return
//            }
//
//            // Store the text field data in the variables
//            DPName = dematName
//            DPID = dematID
//            BOID = boID
//
//            // All validations passed for "N" case, proceed to call the API
//            insertWeb()
//        }
//
//        var commodityKeys: [String] = []
//        var commodityValues: [String] = []
//
//        // Handle both array and string cases
//        if let rawKeys = response["CommodityCategoriKey"] {
//            if let arrayKeys = rawKeys as? [[Any]] {
//                commodityKeys = arrayKeys.flatMap { $0 as? [String] ?? [] }
//            } else if let stringKeys = rawKeys as? String {
//                commodityKeys = stringKeys.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
//            }
//        }
//
//        if let rawValues = response["CommodityCategoriValue"] {
//            if let arrayValues = rawValues as? [[Any]] {
//                commodityValues = arrayValues.flatMap { $0 as? [String] ?? [] }
//            } else if let stringValues = rawValues as? String {
//                commodityValues = stringValues.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
//            }
//        }
//
//        // Build dictionary and assign
//        if !commodityKeys.isEmpty && !commodityValues.isEmpty {
//            self.selectedCommodityDict = Dictionary(uniqueKeysWithValues: zip(commodityKeys, commodityValues))
//
//            selectedKeys = commodityKeys.joined(separator: ", ")
//            selectedValues = commodityValues.joined(separator: ", ")
//
//            print("✅ Restored Commodity Dict: \(self.selectedCommodityDict)")
//            print("Selected Commodity Keys: \(selectedKeys)")
//            print("Selected Commodity Values: \(selectedValues)")
//
//        }
//    }
//
//    func isValidID(_ id: String) -> Bool {
//        let regex = "^[0-9]+$"
//        let idPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
//        return idPredicate.evaluate(with: id)
//    }
//
//    func showAlert(message: String) {
//        let alert = UIAlertController(
//            title: "Error", message: message, preferredStyle: .alert)
//        alert.addAction(
//            UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//}
//
//extension TradingandDematVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func setupCollectionView() {
//        collectionView.delegate = self
//        collectionView.dataSource = self
//
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 5
//        collectionView.collectionViewLayout = layout
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12)
//
//        collectionView.register(
//            UINib(nibName: "TradingandDematCVC", bundle: Bundle.module),
//            forCellWithReuseIdentifier: "TradingandDematCVC"
//        )
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        numberOfItemsInSection section: Int) -> Int {
//        return segments.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: "TradingandDematCVC",
//            for: indexPath
//        ) as! TradingandDematCVC
//
//        cell.delegate = self
//        cell.configure(
//            title: segments[indexPath.item],
//            isSelected: selectedIndexes.contains(indexPath.item),
//            index: indexPath.item
//        )
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 200, height: 44)
//    }
//}
//

import UIKit

protocol BrokerageSelectionDelegate: AnyObject {
    func didSelectBrokerage(_ plan: BrokeragePlan, filter: BrokerageFilter)
}

class TradingandDematVC: UIViewController, @MainActor DepositorySelectionDelegate, @MainActor CommodityCategoryVCDelegate {
    func didSelectCommodityValues(selectedValues: [String : String]) {
        // Save full dictionary
        self.selectedCommodityDict = selectedValues
        // Convert to arrays/strings if needed
        self.selectedKeys = Array(selectedValues.keys).joined(separator: ", ")
        self.selectedValues = Array(selectedValues.values).joined(separator: ", ")
        print("Selected Keys: \(self.selectedKeys)")
        print("Selected Values: \(self.selectedValues)")
    }
    
    func didSelectDepository(type: String, IsDpAccountNew: String) {
        switch IsDpAccountNew {
        case "N":
            depositoryLabel.text = type
            Depositoryname = type
            dematIdTxt.isHidden = false
            if type == "NSDL" {
                dematIdTxt.text = "IN"
            } else if type == "CDSL" {
                dematIdTxt.text = "12"
            }
        default:
            break
        }
    }

    @IBOutlet weak var equityBtn: UIView!
    @IBOutlet weak var fandoBtn: UIView!
    @IBOutlet weak var commodityBtn: UIView!
    @IBOutlet weak var currencyBtn: UIView!
    @IBOutlet weak var mutualBtn: UIView!
    @IBOutlet weak var fando1Btn: UIButton!
    @IBOutlet weak var commodity1Btn: UIButton!
    @IBOutlet weak var currency1Btn: UIButton!
    @IBOutlet weak var mutual1Btn: UIButton!
    @IBOutlet weak var dematTxt: UITextField!
    @IBOutlet weak var dematIdTxt: UITextField!
    @IBOutlet weak var boIdTxt: UITextField!
    @IBOutlet weak var termView: UIView!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var depositoryLabel: UILabel!
    @IBOutlet weak var depositoriesLabel: UILabel!
    @IBOutlet weak var dematNameLabel: UILabel!
    @IBOutlet weak var dematIdLabel: UILabel!
    @IBOutlet weak var boIdLabel: UILabel!
    @IBOutlet weak var dematYesBtn: UIButton!
    @IBOutlet weak var dematNoBtn: UIButton!
    @IBOutlet weak var dematChargesLabel: UILabel!
    @IBOutlet weak var dematChargesView: UIView!
    @IBOutlet weak var line1View: UIView!
    @IBOutlet weak var equity: UIButton!
    @IBOutlet weak var fando: UIButton!
    @IBOutlet weak var commodity: UIButton!
    @IBOutlet weak var currency: UIButton!
    @IBOutlet weak var mutual: UIButton!
    @IBOutlet weak var depositoryButton: UIButton!
    @IBOutlet weak var depositoryView: UIView!
    @IBOutlet weak var mtfBtn: UIView!
    @IBOutlet weak var mtf: UIButton!
    @IBOutlet weak var slbm: UIButton!
    @IBOutlet weak var SlbmBtn: UIView!
    
    var regId: String?
    public let segments = ["Equity Cash", "F&O", "Currency", "Mutual Fund", "MTF", "SLBM"]
    private var selectedIndexes: Set<Int> = []
    var panNo: String?
    var EmailId: String?
    var PANName: String?
    var RegId: String?
    var mobiledecodeArray: String?
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var transactionID: String?
    var rejection: String?
    var Depositoryname: String?
    var IsSchemeExternal: String?
    var selectBSDA: String?
    var IsDpAccountNew: String?
    var DPSchemeCode: String?
    var DPSchemename: String?
    var DPName: String?
    var DPID: String?
    var BOID: String?
    var dob: String?
    var selectedCommodityDict: [String: String] = [:]
    var selectedKeys: String = ""
    var selectedValues: String = ""
    public var isMTFSelected = false
    public var isCommoditySelected = false
    var equityPlanName: String = ""
    var commodityPlanName: String = ""
    var isEquitySelected = false
    var isFNOSelected = false
    var isCurrencySelected = false
    var isMutualSelected = false
    var isCommoditySelectedState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self]
            userId, sessionID, decodeByteArrayString in
            
            guard let self = self else { return }
            
            guard let userId = userId,
                  let sessionID = sessionID else {
                print("❌ No UserID or SessionID found.")
                return
            }
            
            self.fetchedUserId = userId
            self.fetchedSessionID = sessionID
            self.mobiledecodeArray = decodeByteArrayString
            
            print("✅ UserID: \(userId), SessionID: \(sessionID)")
            
            // ✅ NOW SAFE TO CALL APIs
            self.DPSchemeName()
           // self.insertWeb()
            ViewDPScheme()
            brokeragePlan()
            equity.isSelected = true
            viewTradingDetails()
        }
        
        dematYesBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        dematNoBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        navigationItem.hidesBackButton = true
        
        equityBtn.layer.cornerRadius = 10
        fandoBtn.layer.cornerRadius = 10
        commodityBtn.layer.cornerRadius = 10
        currencyBtn.layer.cornerRadius = 10
        mutualBtn.layer.cornerRadius = 10
        mtfBtn.layer.cornerRadius = 10
        SlbmBtn.layer.cornerRadius = 10
        dematTxt.layer.cornerRadius = 10
        dematIdTxt.layer.cornerRadius = 10
        boIdTxt.layer.cornerRadius = 10
        termView.layer.cornerRadius = 10
        depositoryView.layer.cornerRadius = 10
        proceedBtn.layer.cornerRadius = 10
        
        depositoryLabel.isHidden = true
        depositoryView.isHidden = true
        dematNameLabel.isHidden = true
        dematTxt.isHidden = true
        dematIdTxt.isHidden = true
        dematIdLabel.isHidden = true
        boIdLabel.isHidden = true
        boIdTxt.isHidden = true
        //dematYesBtn.isSelected = true
        depositoriesLabel.isHidden = true
        //dematYesBtn(dematYesBtn)
        updateDematSelection(isNew: true)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openDepository))
        depositoryButton.addGestureRecognizer(tap)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dematYesBtn(_ sender: UIButton) {
        updateDematSelection(isNew: true)
    }
    
    
    @IBAction func dematNoBtn(_ sender: UIButton) {
        updateDematSelection(isNew: false)
    }
    
    @objc func openDepository() {
        if let vc = storyboard?.instantiateViewController(
            withIdentifier: "DepositoryVC") as? DepositoryVC {
            
            vc.modalPresentationStyle = .overCurrentContext
            vc.IsDpAccountNew = IsDpAccountNew
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            
            self.present(vc, animated: true, completion: nil)
            print("depository clicked")
        }
    }
    
    func updateDematSelection(isNew: Bool) {
        IsDpAccountNew = isNew ? "Y" : "N"
        
        dematYesBtn.setImage(UIImage(systemName: isNew ? "circle.circle.fill" : "circle"), for: .normal)
        dematNoBtn.setImage(UIImage(systemName: isNew ? "circle" : "circle.circle.fill"), for: .normal)

        dematChargesView.isHidden = !isNew
        dematChargesLabel.isHidden = !isNew
        line1View.isHidden = !isNew

        let hideFields = isNew
        depositoryLabel.isHidden = hideFields
        depositoryView.isHidden = hideFields
        dematNameLabel.isHidden = hideFields
        dematTxt.isHidden = hideFields
        dematIdTxt.isHidden = hideFields
        dematIdLabel.isHidden = hideFields
        boIdLabel.isHidden = hideFields
        boIdTxt.isHidden = hideFields
    }
    
    @IBAction func equityBtnTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func fandoBtnTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func commodityBtnTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func currencyBtnTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func mutualBtnTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func mtfBtnTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func slbmBtnTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func savenext(_ sender: UIButton) {
        if !(equity.isSelected ||
                fando.isSelected ||
                currency.isSelected ||
                mutual.isSelected ||
             commodity.isSelected || mtf.isSelected || slbm.isSelected) {

               showAlert(message: "Please select at least one trading segment")
               return
           }
        paymentRequest()
        insertWeb()
         
//        updateUI(with: [:])
//        insertWeb()
//        paymentRequest()
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Bank", bundle: Bundle.module)
            let vc = storyboard.instantiateViewController(identifier: "BankVC") as! BankVC
            vc.panNo = self.panNo
            vc.regId = self.regId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
//    @IBAction func depositoryNameBtn(_ sender: UIButton) {
//        if let vc = storyboard?.instantiateViewController(
//            withIdentifier: "DepositoryVC") as? DepositoryVC
//        {
//            vc.modalPresentationStyle = .overCurrentContext
//            vc.IsDpAccountNew = IsDpAccountNew
//            vc.delegate = self
//            vc.modalTransitionStyle = .crossDissolve
//            self.present(vc, animated: true, completion: nil)
//        }
//    }
    
    func paymentRequest() {
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
            [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                    if success {
                        // Call SIXTHAPI after tokenMobile API call is successful
                        self.paymentRequest()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            
            let parameters: [String: Any?] = [
                "IsPaymentGetwayAllow": 0,
                "TxnId": nil,
                "RegId": regId,
                "UserId": fetchedUserId,
                "PanNo": panNo,
                "TokenId": tokenId,
                "Type": nil,
                "IsEquitySelect": "1",
                "IsEquityFNOSelect": fando.isSelected ? "1" : "0",
                "IsEquityCurrencySelect": currency.isSelected ? "1" : "0",
                "IsEquityMutualFundSelect": mutual.isSelected ? "1" : "0",
                "IsEquitySLBMSelect": slbm.isSelected ? "1" : "0",
                "IsCommoditySelect": commodity.isSelected ? "1" : "0",
                "BrokeragePlanEquityName": equityPlanName,
                "BrokeragePlanCommodityName": nil,
                "IsForEquityMargin": "0",
                "IsForCommodityMargin": "0",
                "EquityMarginAmount": "0",
                "CommodityMarginAmount": "0",
                "TransactionID": nil,
                "PaymentGetWay": "ATOM",
                "IsMTFSelect": mtf.isSelected ? "1" : "0"
            ]
            
            print(parameters)
            let Url = "Client/PaymentRequestOnTrading"
            
            apiCall(
                url: Url, method: "POST",
                parameters: parameters as [String: Any], view: self.view
            ) { result in
                switch result {
                case .success(let jsonResponse):
                    print("paymentRequest Response: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            DispatchQueue.main.async {
                                // self.updateui(with: jsonResponse)
                            }
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(
                                    entityName: "TokenMobile")
                                print(
                                    "All TokenMobile entries deleted due to error code 999992"
                                )
                                CoreDataHelper.generateToken(
                                    decodeByteArrayToString: self
                                        .mobiledecodeArray ?? "",
                                    USERID: self.fetchedUserId ?? "",
                                    SessionId: self.fetchedSessionID ?? "",
                                    entityName: "TokenMobile", deviceType: "W",
                                    in: self.view
                                ) { success in
                                    if success {
                                        self.paymentRequest()
                                    } else {
                                        print("Token generation failed.")
                                    }
                                }
                            }
                        default:
                            print("Unhandled error code: \(errorCode)")
                        }
                    }
                case .failure(let error):
                    print(
                        "Login API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func ValidateToken() {
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
            [self] tokenId in
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
                        self.ValidateToken()
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
            ]
            print(parameters)
            let Url = "TokenAuthentication/ValidateToken"
            
            apiCall(
                url: Url, method: "POST",
                parameters: parameters as [String: Any], view: self.view
            ) { result in
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
                    print(
                        "Login API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func viewTradingDetails() {
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
            [self] tokenId in
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
                        self.ValidateToken()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                  "RegId": regId,
                  "UserId": fetchedUserId,
                  "PanNo": panNo,
                  "TokenId": tokenId
            ]
            print(parameters)
            let Url = "Client/ViewPaymentDetailsData"
            
            apiCall(
                url: Url, method: "POST",
                parameters: parameters as [String: Any], view: self.view
            ) { result in
                switch result {
                case .success(let jsonResponse):
                    print("ValidateToken Response: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            DispatchQueue.main.async {
                                self.updateUIFromTradingDetails(jsonResponse)
                            }
                        default:
                            print("Unhandled error code: \(errorCode)")
                        }
                    }
                case .failure(let error):
                    print(
                        "Login API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func DPSchemeName() {
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
            [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                    if success {
                        // Call SIXTHAPI after tokenMobile API call is successful
                        self.DPSchemeName()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "UserId": fetchedUserId,
                "SessionID": fetchedSessionID,
                "DPSchemeCode": "",
                "DPSchemeName": "",
                "TokenId": tokenId,
                "IsSchemeExternal": "0",
            ]
            print(parameters)
            let Url = "DropDownManagement/DPSchemeName"
            
            apiCall(
                url: Url, method: "POST",
                parameters: parameters as [String: Any], view: self.view
            ) { result in
                switch result {
                case .success(let jsonResponse):
                    print("DPSchemeName Response: \(jsonResponse)")
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
                    print(
                        "Login API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func ViewDPScheme() {
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
            [self] tokenId in
            guard let tokenId = tokenId else {
                
                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                    if success {
                        // Call SIXTHAPI after tokenMobile API call is successful
                        self.ViewDPScheme()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "UserId": fetchedUserId,
                "SessionID": fetchedSessionID,
                "DPSchemeCode": DPSchemeCode,
                "DPSchemeName": DPSchemename,
                "TokenId": tokenId,
                "IsSchemeExternal": "0",
                "ALL": false,
            ]
            print(parameters)
            let Url = "DPScheme/ViewDPScheme"
            
            apiCall(
                url: Url, method: "POST",
                parameters: parameters as [String: Any], view: self.view
            ) { result in
                switch result {
                case .success(let jsonResponse):
                    print("DPSchemeName Response: \(jsonResponse)")
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
                    print(
                        "Login API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func ViewDPDetails() {
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
            [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                    if success {
                        // Call SIXTHAPI after tokenMobile API call is successful
                        self.ViewDPDetails()
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
            ]
            
            print(parameters)
            let Url = "DPDetails/ViewDPDetails"
            
            apiCall(
                url: Url, method: "POST",
                parameters: parameters as [String: Any], view: self.view
            ) { result in
                switch result {
                case .success(let jsonResponse):
                    print("ViewDPDetails Response: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            DispatchQueue.main.async {
                                // self.updateui(with: jsonResponse)
                            }
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(
                                    entityName: "TokenMobile")
                                print(
                                    "All TokenMobile entries deleted due to error code 999992"
                                )
                                CoreDataHelper.generateToken(
                                    decodeByteArrayToString: self
                                        .mobiledecodeArray ?? "",
                                    USERID: self.fetchedUserId ?? "",
                                    SessionId: self.fetchedSessionID ?? "",
                                    entityName: "TokenMobile", deviceType: "W",
                                    in: self.view
                                ) { success in
                                    if success {
                                        self.ViewDPDetails()
                                    } else {
                                        print("Token generation failed.")
                                    }
                                }
                            }
                        default:
                            print("Unhandled error code: \(errorCode)")
                        }
                    }
                case .failure(let error):
                    print(
                        "Login API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func insertWeb() {
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
            [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                    if success {
                        // Call SIXTHAPI after tokenMobile API call is successful
                        self.insertWeb()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "RegId": regId,
                "UserId": fetchedUserId,
                "PanNo": panNo,
                "IsDpAccountNew": self.IsDpAccountNew ?? "Y",
                "Depositoryname": self.IsDpAccountNew == "Y" ? "" : (self.Depositoryname ?? ""),
                "DPName": self.DPName ?? self.dematTxt.text ?? "",
                "DPID": self.DPID ?? self.dematIdTxt.text ?? "",
                "BOID": self.BOID ?? self.boIdTxt.text ?? "",
                "BSDA": nil,
                "DPScheme": self.DPSchemeCode ?? "",
                "CreatedBy": nil,
                "ModifiedBy": nil,
                "TokenId": tokenId,
                "IsDpExternal": "0",
                "DPBrokerName": "string",
                "BrowserName": nil,
                "BrowserVersion": nil,
                "OS": nil,
                "OSVersion": nil,
                "IPAddress": nil,
                "DeviceType": "W",
                "UserAgent": nil
            ]
            
            print(parameters)
            let Url = "DPDetails/InsertUpdateDPetails_Web"
            
            apiCall(
                url: Url, method: "POST",
                parameters: parameters as [String: Any], view: self.view
            ) { result in
                switch result {
                case .success(let jsonResponse):
                    print("InsertUpdateDPetails_Web Response: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000", "621002":
                       print("print")
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(
                                    entityName: "TokenMobile")
                                print(
                                    "All TokenMobile entries deleted due to error code 999992"
                                )
                                CoreDataHelper.generateToken(
                                    decodeByteArrayToString: self
                                        .mobiledecodeArray ?? "",
                                    USERID: self.fetchedUserId ?? "",
                                    SessionId: self.fetchedSessionID ?? "",
                                    entityName: "TokenMobile", deviceType: "W",
                                    in: self.view
                                ) { success in
                                    if success {
                                        self.ViewDPDetails()
                                    } else {
                                        print("Token generation failed.")
                                    }
                                }
                            }
                        default:
                            print("Unhandled error code: \(errorCode)")
                        }
                    }
                case .failure(let error):
                    print(
                        "Login API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func brokeragePlan() {
            CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
                [self] tokenId in
                guard let tokenId = tokenId else {
                    // Handle the case where no tokens are available
                    CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                        if success {
                            // Call SIXTHAPI after tokenMobile API call is successful
                            self.brokeragePlan()
                            //self.panValidation(panNo: panNo, name: name, userDOB: userDOB, isGuardian: isGuardian)
                        } else {
                            print("Token generation failed.")
                        }
                    }
                    print("No tokens available. Please reload the tokens.")
                    return
                }
                let parameters: [String: Any?] = [
                    "RegId": regId,
                    "UserId": fetchedUserId,
                    "TokenId": tokenId,
                    "SessionId": fetchedSessionID,
                ]
                print(parameters)
                let Url = "BrokeragePlan/ViewLDBrokeragePlanClientForClient"
    
                apiCall(
                    url: Url, method: "POST",
                    parameters: parameters as [String: Any], view: self.view,
                    loaderText: "please wait..."
                ) { result in
                    switch result {
                    case .success(let jsonResponse):
                        print("BrokeragePlan Response: \(jsonResponse)")
                        //                    let DigiLockerURL = jsonResponse["DigiLockerURL"] as? String
                        //                    let digilockerReturnURL =
                        //                    jsonResponse["DigiLockeReturnURL"] as? String
                        //                    let Client_id = jsonResponse["Client_id"] as? String
                        //                    let TransactionID = jsonResponse["TransactionID"] as? String
    
                        if let errorCode = jsonResponse["ErrorCode"] as? String {
                            switch errorCode {
                            case "999992":
                                DispatchQueue.main.async {
    
                                }
                            case "000000":
                                DispatchQueue.main.async {
                                    if let list = jsonResponse["List"] as? [[String: Any]] {
 
                                          if let firstPlan = list.first {
                                              self.equityPlanName = firstPlan["BrokeragePlanName"] as? String ?? ""
                                          }

                                          // find commodity plan
                                          if let commodityPlan = list.first(where: { ($0["Segment"] as? String) == "COMMODITY" }) {
                                              self.commodityPlanName = commodityPlan["BrokeragePlanName"] as? String ?? ""
                                          }
                                      }

                                      print("Equity Plan:", self.equityPlanName)
                                      print("Commodity Plan:", self.commodityPlanName)
                                    self.paymentRequest()
                                    self.insertWeb()
                                   
                                }
                            default:
                                print("Unhandled error code: \(errorCode)")
                            }
                        }
                    case .failure(let error):
                        print(
                            "Login API call failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    

    func updateUIFromTradingDetails(_ jsonResponse: [String: Any]) {
        
        // MARK: - DP Account Handling
//        if let isDpNew = jsonResponse["DP_IsDpAccountNew"] as? String {
//            self.IsDpAccountNew = isDpNew
//            
//            if isDpNew == "Y" {
//                self.dematYesBtn(self.dematYesBtn)
//            } else {
//                self.dematNoBtn(self.dematNoBtn)
//                
//                self.depositoryLabel.text = jsonResponse["DP_Depositoryname"] as? String
//                self.dematTxt.text = jsonResponse["DP_DPName"] as? String
//                self.dematIdTxt.text = jsonResponse["DP_DPID"] as? String
//                self.boIdTxt.text = jsonResponse["DP_BOID"] as? String
//            }
//        }
        
        self.IsDpAccountNew = "Y"
        updateDematSelection(isNew: true)
        
        // MARK: - Segment Selection Handling
        if let segments = jsonResponse["TRD_SegmentsPreferred"] as? String {
            
            // Reset all first
            equity.isSelected = false
            fando.isSelected = false
            currency.isSelected = false
            mutual.isSelected = false
            commodity.isSelected = false
            mtf.isSelected = false
            slbm.isSelected = false

            let upperSegments = segments.uppercased()
            
            if upperSegments.contains("EQUITY") {
                equity.isSelected = true
            }
            if upperSegments.contains("FNO") || upperSegments.contains("F&O") {
                fando.isSelected = true
            }
            if upperSegments.contains("CURRENCY") {
                currency.isSelected = true
            }
            if upperSegments.contains("MUTUAL") {
                mutual.isSelected = true
            }
            if upperSegments.contains("COMMODITY") {
                commodity.isSelected = true
            }
            if upperSegments.contains("MTF") {
                mtf.isSelected = true
            }
            if upperSegments.contains("SLBM") {
                slbm.isSelected = true
            }
        }
    }
    
    
    func isValidID(_ id: String) -> Bool {
        let regex = "^[0-9]+$"
        let idPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return idPredicate.evaluate(with: id)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}



//    func updateUI(with response: [String: Any]) {
//
//        if IsDpAccountNew == "Y" {
//            // 1. Check if Depositoryname is nil or empty
//
//            DPName = nil
//            DPID = nil
//            BOID = nil
//            insertWeb()
//
//        } else if IsDpAccountNew == "N" {
//            selectBSDA = nil
//            selectBSDA = nil
//            DPSchemeCode = nil
//            IsSchemeExternal = nil
//
//            guard let depositoryName = Depositoryname, !depositoryName.isEmpty
//            else {
//                showAlert(message: "Please select depository name")
//                return
//            }
//
//            guard let dematID = dematIdTxt.text, !dematID.isEmpty else {
//                showAlert(message: "Please enter demat ID")
//                return
//            }
//
//            guard let boID = boIdTxt.text, !boID.isEmpty else {
//                showAlert(message: "Please enter BOID")
//                return
//            }
//
//            guard let dematName = dematTxt.text, !dematName.isEmpty else {
//                showAlert(message: "Please enter demat name")
//                return
//            }
//
//            if !isValidID(boID) || boID.count != 8 {
//                showAlert(message: "BOID must be exactly 8 digits")
//                return
//            }
//
//            // Store the text field data in the variables
//            DPName = dematName
//            DPID = dematID
//            BOID = boID
//
//            // All validations passed for "N" case, proceed to call the API
//            insertWeb()
//        }
//    }
    
