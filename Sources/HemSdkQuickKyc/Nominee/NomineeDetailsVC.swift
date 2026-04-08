//
//  NomineeDetailsVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

//import UIKit
//
//class NomineeDetailsVC: UIViewController, @MainActor NomineeDocumentVCDelegate, @MainActor ReloadPageDelegate {
//    func reloadPageData() {
//        self.ViewAllNomineeDetails()
//    }
//    
//    @IBOutlet weak var wishLabel: UILabel!
//    @IBOutlet weak var wishStackView: UIStackView!
//    @IBOutlet weak var NomineeHolderView1: UIView!
//    @IBOutlet weak var nm1View: UIView!
//    @IBOutlet weak var nominee1Name: UILabel!
//    @IBOutlet weak var nominee1DocumentType: UILabel!
//    @IBOutlet weak var Nominee1MobilenoDOB: UILabel!
//    @IBOutlet weak var allocationView: UIStackView!
//    @IBOutlet weak var allocationNominee1View: UIStackView!
//    @IBOutlet weak var NomineeName1TF: UITextField!
//    @IBOutlet weak var nominee1percentageTF: UITextField!
//    @IBOutlet weak var allocationNominee2View: UIStackView!
//    @IBOutlet weak var NomineeName2TF: UITextField!
//    @IBOutlet weak var nominee2percentageTF: UITextField!
//    @IBOutlet weak var allocationNominee3View: UIStackView!
//    @IBOutlet weak var NomineeName3TF: UITextField!
//    @IBOutlet weak var nominee3percentageTF: UITextField!
//    @IBOutlet weak var NomineeAllocationlbl: UILabel!
//    @IBOutlet weak var NomineeAllocationView: UIView!
//    @IBOutlet weak var NomineeHolderView2: UIView!
//    @IBOutlet weak var nm2View: UIView!
//    @IBOutlet weak var nominee2Name: UILabel!
//    @IBOutlet weak var nominee2DocumentType: UILabel!
//    @IBOutlet weak var Nominee2MobilenoDOB: UILabel!
//    @IBOutlet weak var NomineeHolderView3: UIView!
//    @IBOutlet weak var nm3View: UIView!
//    @IBOutlet weak var nominee3Name: UILabel!
//    @IBOutlet weak var nominee3DocumentType: UILabel!
//    @IBOutlet weak var Nominee3MobilenoDOB: UILabel!
//    @IBOutlet weak var saveNNextBtn: UIButton!
//    @IBOutlet weak var AddNomineeBtn: UIButton!
//    @IBOutlet weak var NoBtn: UIButton!
//    @IBOutlet weak var YesBtn: UIButton!
//    
//    var panNo : String?
//    var PANName : String?
//    var RegId : String?
//    var state: String?
//    var nomineeCount: Int = 0
//    var nomineeDetailsArray: [[String: Any]] = []
//    var nominee1Allocation: String = ""
//    var nominee2Allocation: String = ""
//    var nominee3Allocation: String = ""
//    weak var delegate: ReloadPageDelegate?
//    var fetchedUserId: String?
//    var fetchedSessionID: String?
//    var mobiledecodeArray: String?
//    var NomineeType: String = "N"
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        AddNomineeBtn.layer.cornerRadius = 15
//        saveNNextBtn.layer.cornerRadius = 15
//        NoBtn.isSelected = true
//        if nomineeDetailsArray.count >= 3 {
//            AddNomineeBtn.isEnabled = false
//        }
//        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
//            guard let self = self else { return }
//            
//            if let userId = userId, let sessionID = sessionID {
//                self.fetchedUserId = userId
//                self.fetchedSessionID = sessionID
//                self.mobiledecodeArray = decodeByteArrayString
//                print("UserID: \(userId), SessionID: \(sessionID)")
//                self.ViewAllNomineeDetails()
//            } else {
//                print("No UserID or SessionID found.")
//            }
//        }
//        print("Nominee Details Array: \(nomineeDetailsArray)")
//        navigationItem.hidesBackButton = true
//    }
//    
//    func setupUI() {
//        AddNomineeBtn.isHidden = true
//        [NomineeHolderView1, NomineeHolderView2, NomineeHolderView3].forEach {
//            $0?.layer.borderWidth = 1
//            $0?.layer.borderColor = UIColor.black.cgColor
//            $0?.layer.cornerRadius = 10
//            $0?.isHidden = true
//        }
//        [nm1View, nm2View, nm3View].forEach {
//            $0?.layer.cornerRadius = 10
//        }
//        NomineeAllocationlbl.isHidden = true
//        NomineeAllocationView.isHidden = true
//        //saveNNextBtn.isHidden = true
//    }
//    
//    @IBAction func BackBtn(_ sender: UIButton) {
//        delegate?.reloadPageData()
//
//          let vc = ApplicationFormVC()
//          vc.panNo = panNo
//          navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    @IBAction func homeBtn(_ sender: UIButton) {
//        self.navigationController?.popToRootViewController(animated: true)
//    }
//    
//    @IBAction func AddNomineeBtn(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "NomineeDocumentVC") as! NomineeDocumentVC
//        vc.PanNo = panNo
//        vc.PANName = PANName
//        vc.RegId = RegId
//        vc.nomineeCount = nomineeDetailsArray.count
//        switch nomineeDetailsArray.count {
//        case 0:
//            vc.identifier = "NOMINEE_1"
//            vc.state = "addnominee"
//        case 1:
//            vc.identifier = "NOMINEE_2"
//            vc.state = "addnominee"
//        case 2:
//            vc.identifier = "NOMINEE_3"
//            vc.state = "addnominee"
//        default:
//            break
//        }
//        
//        vc.delegate = self
//        self.navigationController?.pushViewController(vc, animated: true)
//        print("nomineeDetailsArray.count\(nomineeDetailsArray.count)")
//        
//    }
//    
//    @IBAction func NomineeConfirmationBtn(_ sender: UIButton) {
//        if sender == YesBtn {
//            YesBtn.isSelected = true
//            NoBtn.isSelected = false
//            AddNomineeBtn.isHidden = false
//            saveNNextBtn.isHidden = false
//            NomineeType = "Y"
//            
//        } else if sender == NoBtn {
//            YesBtn.isSelected = false
//            NoBtn.isSelected = true
//            AddNomineeBtn.isHidden = true
//            saveNNextBtn.isHidden = false
//            NomineeType = "N"
//        }
//    }
//    
//    private func nomineeIndex(for identifier: String) -> Int? {
//        switch identifier {
//        case "NOMINEE_1":
//            return 0
//        case "NOMINEE_2":
//            return 1
//        case "NOMINEE_3":
//            return -2
//        default:
//            return nil
//        }
//    }
//    
//    func didSaveNomineeDetails(_ details: [String: Any], for identifier: String) {
//        
//        NomineeAllocationlbl.isHidden = false
//        NomineeAllocationView.isHidden = false
//        NomineeHolderView1.isHidden = true
//        NomineeHolderView2.isHidden = true
//        NomineeHolderView3.isHidden = true
//        allocationNominee1View.isHidden = true
//        allocationNominee2View.isHidden = true
//        allocationNominee3View.isHidden = true
//        
//        if let index = nomineeIndex(for: identifier), index < nomineeDetailsArray.count {
//            nomineeDetailsArray[index] = details
//        } else {
//            nomineeDetailsArray.append(details)
//        }
//        
//        // Set the visibility based on the number of nominees
//        let nomineeCount = nomineeDetailsArray.count
//        if nomineeCount > 0 {
//            NomineeHolderView1.isHidden = false
//            allocationNominee1View.isHidden = false
//            if nomineeCount > 1 {
//                NomineeHolderView2.isHidden = false
//                allocationNominee2View.isHidden = false
//            }
//            if nomineeCount > 2 {
//                NomineeHolderView3.isHidden = false
//                allocationNominee3View.isHidden = false
//            }
//        }
//        
//        // Set details for each nominee
//        if nomineeCount > 0 {
//            let nominee1 = nomineeDetailsArray[0]
//            nominee1Name.text = nominee1["nomineeName"] as? String
//            nominee1DocumentType.text = nominee1["documentId"] as? String
//            let mobileNo = nominee1["nomineeMobileNo"] as? String ?? ""
//            let dob = nominee1["dob"] as? String ?? ""
//            Nominee1MobilenoDOB.text = "Mobile: \(mobileNo)/ DOB: \(dob)"
//            //  DeleteNominee1Btn.isHidden = nomineeCount == 2
//        }
//        
//        if nomineeCount > 1 {
//            let nominee2 = nomineeDetailsArray[1]
//            nominee2Name.text = nominee2["nomineeName"] as? String
//            nominee2DocumentType.text = nominee2["documentId"] as? String
//            let mobileNo = nominee2["nomineeMobileNo"] as? String ?? ""
//            let dob = nominee2["dob"] as? String ?? ""
//            Nominee2MobilenoDOB.text = "Mobile: \(mobileNo)/ DOB: \(dob)"
//            //DeleteNominee2Btn.isHidden = nomineeCount <= 1
//        }
//        
//        if nomineeCount > 2 {
//            let nominee3 = nomineeDetailsArray[2]
//            nominee3Name.text = nominee3["nomineeName"] as? String
//            nominee3DocumentType.text = nominee3["documentId"] as? String
//            let mobileNo = nominee3["nomineeMobileNo"] as? String ?? ""
//            let dob = nominee3["dob"] as? String ?? ""
//            Nominee3MobilenoDOB.text = "Mobile: \(mobileNo)/ DOB: \(dob)"
//            AddNomineeBtn.isEnabled = false
//        }
//        
//        print("Nominee Details Array in didSaveNomineeDetails: \(nomineeDetailsArray)")
//    }
//    
//    @IBAction func SaveNNextBtn(_ sender: UIButton) {
//        var panSet = Set<String>()
//        var nameSet = Set<String>()
//        for nominee in nomineeDetailsArray {
//            if let pan = nominee["documentId"] as? String {
//                if panSet.contains(pan) {
//                    // Step 2: Show alert if a duplicate is found
//                    showAlert(message: "Please enter different PAN or ID for each nominee.")
//                    return
//                }
//                panSet.insert(pan)
//            }
//            if let name = nominee["nomineeName"] as? String {
//                if nameSet.contains(name) {
//                    showAlert(message: "Please enter a different nominee name for each nominee.")
//                    return
//                }
//                nameSet.insert(name)
//            }
//        }
//        
//        if NomineeType == "N" {
//            print("nomineetype N called ")
//            insertUpdateNomineeDetailsWebWithMinimalParams()
//        } else if NomineeType == "Y" {
//            // Call API with full parameters
//            validateNomineeAllocation()
//        } else {
//            showAlert(message: "invalid number of nominee.")
//        }
//    }
//    
//    func validateNomineeAllocation() {
//        // Assign values from text fields to global variables
//        nominee1Allocation = nominee1percentageTF.text ?? ""
//        nominee2Allocation = nominee2percentageTF.text ?? ""
//        nominee3Allocation = nominee3percentageTF.text ?? ""
//        //print("percentage value",nominee1Allocation,nominee2Allocation,nominee3Allocation)
//        // Convert global string allocations to integers, defaulting to 0 if empty
//        let nominee1Percentage = Int(nominee1Allocation) ?? 0
//        let nominee2Percentage = Int(nominee2Allocation) ?? 0
//        let nominee3Percentage = Int(nominee3Allocation) ?? 0
//        
//        // Calculate the total allocation percentage
//        let totalAllocation = nominee1Percentage + nominee2Percentage + nominee3Percentage
//        
//        // Validate total allocation percentage
//        switch nomineeDetailsArray.count
//        
//        {
//        case 1:
//            if totalAllocation != 100 {
//                showAlert(message: "Total allocation percentage must be 100%.")
//                return
//            }
//            
//        case 2:
//            if totalAllocation != 100 {
//                showAlert(message: "Total allocation percentage must be 100%.")
//                return
//            }
//            
//        case 3:
//            if totalAllocation != 100 {
//                showAlert(message: "Total allocation percentage must be 100%.")
//                return
//            }
//            
//        default:
//            showAlert(message: "Invalid number of nominees.")
//            return
//        }
//        
//        // If validation passes, proceed to call the API
//        InsertUpdateNomineeDetailsWeb(nominee1percentage:nominee1Allocation,nominee2percentage:nominee2Allocation,nominee3percentage:nominee3Allocation)
//    }
//}
//
//extension Array where Element == Int {
//    func sum() -> Int {
//        return self.reduce(0, +)
//    }
//}
//
//extension NomineeDetailsVC{
//    
//    func insertUpdateNomineeDetailsWebWithMinimalParams() {
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
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
//                        self.insertUpdateNomineeDetailsWebWithMinimalParams()
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            
//            var parameters: [String: Any?] = [
//                "SessionId": fetchedSessionID,
//                "TokenId": tokenId,
//                "UserId": fetchedUserId,
//                "PanNo": panNo,
//                "RegId": RegId,
//                "NomineeType": NomineeType
//            ]
//            
//            let url = "NomineeDetails/InsertUpdateNomineeDetailsWeb"
//            
//            apiCall(url: url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("InsertUpdateNomineeDetailsWeb Response: \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        if errorCode == "000000" {
//                            DispatchQueue.main.async {
//                                let storyboard = UIStoryboard(name: "Document", bundle: Bundle.module )
//                                if let nextVC = storyboard.instantiateViewController(withIdentifier: "DocumentVC") as? DocumentVC {
////                                    nextVC.PanNo = self.panNo
////                                    nextVC.RegId = self.RegId
////                                    nextVC.delegate = self
//                                    self.navigationController?.pushViewController(nextVC, animated: true)
//                                }
//                            }
//                        } else if errorCode == "999992" {
//                            // Handle invalid token case
//                            print("Invalid token detected. Attempting to refresh token.")
//                            CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                                if success {
//                                    self.insertUpdateNomineeDetailsWebWithMinimalParams()
//                                } else {
//                                    DispatchQueue.main.async {
//                                        self.showAlert(message: "Token refresh failed. Please try again.")
//                                    }
//                                }
//                            }
//                        } else {
//                            DispatchQueue.main.async {
//                                if let errorMessage = jsonResponse["ErrorMessage"] as? String {
//                                    self.showAlert(message: errorMessage)
//                                } else {
//                                    self.showAlert(message: "Unhandled error code")
//                                }
//                            }
//                        }
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async {
//                        self.showAlert(message: "API call failed: \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
//    }
//    
//    func InsertUpdateNomineeDetailsWeb(nominee1percentage:String,nominee2percentage:String,nominee3percentage:String) {
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
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
//                        self.InsertUpdateNomineeDetailsWeb(nominee1percentage: nominee1percentage, nominee2percentage: nominee2percentage, nominee3percentage: nominee3percentage)
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            //print("percentage value",nominee1percentage,"second")
//            var parameters: [String: Any?] = [
//                "SessionId": fetchedSessionID,
//                "TokenId": tokenId,
//                "UserId": fetchedUserId,
//                "PanNo": panNo,
//                "RegId": RegId,
//                "NomineeType": NomineeType,
//                
//            ]
//            if nomineeDetailsArray.count >= 1 {
//                parameters["NOMINEE_1Percentage"] = nominee1percentage
//                print("parameters NOMINEE_1Percentage",parameters["NOMINEE_1Percentage"])
//            }
//            if nomineeDetailsArray.count >= 2 {
//                parameters["NOMINEE_2Percentage"] = nominee2percentage
//            }
//            if nomineeDetailsArray.count == 3 {
//                parameters["NOMINEE_3Percentage"] = nominee3percentage
//            }
//            for (index, nominee) in nomineeDetailsArray.enumerated() {
//                let nomineeIndex = index + 1 // To get NOMINEE_1, NOMINEE_2, etc.
//                
//                parameters["NOMINEE_\(nomineeIndex)NomineePanNoAadhar"] = nominee["documentId"]
//                parameters["NOMINEE_\(nomineeIndex)GuardianRelation"] = nominee["guardianRelation"]
//                parameters["NOMINEE_\(nomineeIndex)GuardianDocumentExpiryDate"] = nominee["GuardianDocumentExpiryDate"]
//                parameters["NOMINEE_\(nomineeIndex)Relation"] = nominee["relation"]
//                parameters["NOMINEE_\(nomineeIndex)GuardianCountry"] = nominee["guardianCountry"]
//                parameters["NOMINEE_\(nomineeIndex)GuardianPrefix"] = nominee["GuardianPrefix"]
//                parameters["NOMINEE_\(nomineeIndex)GuardianDOB"] = nominee["GuardianDOB"]
//                parameters["NOMINEE_\(nomineeIndex)MobileNo"] = nominee["nomineeMobileNo"]
//                parameters["NOMINEE_\(nomineeIndex)PinCode"] = nominee["pincode"]
//                parameters["NOMINEE_\(nomineeIndex)EmailId"] = nominee["nomineeEmailId"]
//                parameters["NOMINEE_\(nomineeIndex)GDocumentIDNumberADhar"] = nominee["GDocumentIDNumberADhar"]
//                parameters["NOMINEE_\(nomineeIndex)Address1"] = nominee["addressLine1"]
//                parameters["NOMINEE_\(nomineeIndex)Address2"] = nominee["addressLine2"]
//                parameters["NOMINEE_\(nomineeIndex)Address3"] = nominee["addressLine3"]
//                parameters["NOMINEE_\(nomineeIndex)DOB"] = nominee["dob"]
//                parameters["NOMINEE_\(nomineeIndex)GuardianPinCode"] = nominee["GuardianPinCode"]
//                parameters["NOMINEE_\(nomineeIndex)SameAsNominee"] = nominee["SameAsNominee"]
//                parameters["NOMINEE_\(nomineeIndex)City"] = nominee["city"]
//                parameters["NOMINEE_\(nomineeIndex)State"] = nominee["state"]
//                //parameters["NOMINEE_\(nomineeIndex)Percentage"] = nominee["Percentage"]
//                parameters["NOMINEE_\(nomineeIndex)DocumentType"] = nominee["nomineeDocumentType"]
//                parameters["NOMINEE_\(nomineeIndex)Name"] = nominee["nomineeName"]
//                parameters["NOMINEE_\(nomineeIndex)GuardianState"] = nominee["GuardianState"]
//                parameters["NOMINEE_\(nomineeIndex)GuardianName"] = nominee["GuardianName"]
//                parameters["NOMINEE_\(nomineeIndex)NomineeMinor"] = nominee["NomineeMinor"]
//                parameters["NOMINEE_\(nomineeIndex)DocumentExpiryDate"] = nominee["DocumentExpiryDate"]
//                parameters["NOMINEE_\(nomineeIndex)GMobileNo"] = nominee["GMobileNo"]
//                parameters["NOMINEE_\(nomineeIndex)GEmail"] = nominee["GEmail"]
//                parameters["NOMINEE_\(nomineeIndex)Country"] = nominee["Country"]
//                parameters["NOMINEE_\(nomineeIndex)GuardianCity"] = nominee["GuardianCity"]
//                parameters["NOMINEE_\(nomineeIndex)Prefix"] = nominee["Prefix"]
//                parameters["NOMINEE_\(nomineeIndex)AddressSameAsApplicant"] = nominee["AddressSameAsApplicant"]
//                parameters["NOMINEE_\(nomineeIndex)GuardianAddress2"] = nominee["GuardianAddress2"]
//                parameters["NOMINEE_\(nomineeIndex)GuardianDocumentType"] = nominee["GuardianDocumentType"] ?? ""
//                parameters["NOMINEE_\(nomineeIndex)GuardianAddress3"] = nominee["GuardianAddress3"]
//                parameters["NOMINEE_\(nomineeIndex)GuardianAddress1"] = nominee["GuardianAddress1"]
//            }
//            print("NOMINEE AS IT IS:\(parameters)")
//            
//            let url = "NomineeDetails/InsertUpdateNomineeDetailsWeb"
//            
//            apiCall(url: url, method: "POST", parameters: parameters as [String : Any], view: self.view,loaderText: "please wait processing data...") { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("InsertUpdateNomineeDetailsWeb Response: \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        if errorCode == "000000" {
////                            DispatchQueue.main.async {
////                                
////                                let storyboard = UIStoryboard(name: "Document", bundle: nil)
////                                if let nextVC = storyboard.instantiateViewController(withIdentifier: "DocumentVC") as? DocumentVC {
////                                    nextVC.PanNo = self.PanNo
////                                    nextVC.RegId = self.RegId
////                                    nextVC.delegate = self
////                                    self.navigationController?.pushViewController(nextVC, animated: true)
////                                }
////                            }
//                        } else if errorCode == "999992" {
//                            // Handle invalid token case
//                            print("Invalid token detected. Attempting to refresh token.")
//                            CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                                if success {
//                                    // Retry the API call after refreshing the token
//                                    self.InsertUpdateNomineeDetailsWeb(nominee1percentage: nominee1percentage, nominee2percentage: nominee2percentage, nominee3percentage: nominee3percentage)
//                                } else {
//                                    DispatchQueue.main.async {
//                                        self.showAlert(message: "Token refresh failed. Please try again.")
//                                    }
//                                }
//                            }
//                        } else {
//                            DispatchQueue.main.async {
//                                if let errorMessage = jsonResponse["ErrorMessage"] as? String {
//                                    self.showAlert(message: errorMessage)
//                                } else {
//                                    self.showAlert(message: "Unhandled error code")
//                                }
//                            }
//                        }
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async {
//                        self.showAlert(message: "API call failed: \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
//    }
//    func showAlert(message: String) {
//        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
//    }
//}
//
//extension NomineeDetailsVC {
//    
//    func ViewAllNomineeDetails() {
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//            guard let tokenId = tokenId else {
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile", deviceType: "W", in: self.view
//                ) { success in
//                    if success {
//                        // Retry SIXTHAPI after token regeneration
//                        self.ViewAllNomineeDetails()
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            
//            let parameters: [String: Any?] = [
//                "UserId": fetchedUserId,
//                "PanNo": panNo,
//                "RegId": RegId,
//                "TokenId": tokenId
//            ]
//            
//            print(parameters)
//            
//            let url = "NomineeDetails/ViewAllNomineeDetails"
//            
//            apiCall(url: url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("ViewAllNomineeDetails Response: \(jsonResponse)")
//                    let nomineeType = jsonResponse["IsNominate"] as? String
//                    if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
//                        DispatchQueue.main.async {
//                            
//                            if let IsNominate = jsonResponse["IsNominate"] as? String, IsNominate == "N"
//                            {
//                                print("NO NOMINEES ARE PRESENT")
//                                self.NoBtn.isSelected = true
//                                self.saveNNextBtn.isHidden = false
//                                
//                            } else if let nomineeData = jsonResponse["NomineeDetails"] as? [[String: Any]], !nomineeData.isEmpty {
//                                
//                                self.nomineeDetailsArray = nomineeData
//                                self.updateNomineeViewsall() // Make sure this function updates the UI based on `nomineeDetailsArray`
//                            } else {
//                                print("NO NOMINEES ARE PRESENT")
//                            }
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            if let errorMessage = jsonResponse["ErrorMessage"] as? String {
//                                self.showAlert(message: errorMessage)
//                            } else {
//                                self.showAlert(message: "Unhandled error code")
//                            }
//                        }
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async {
//                        self.showAlert(message: "API call failed: \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
//    }
//    
//    func updateNomineeViewsall() {
//        // Ensure UI updates happen on the main thread
//        DispatchQueue.main.async {
//            // Update nominee details
//            let nomineeCount = self.nomineeDetailsArray.count
//            self.allocationNominee1View.isHidden = true
//            self.allocationNominee2View.isHidden = true
//            self.allocationNominee3View.isHidden = true
//            
//            self.saveNNextBtn.isHidden = false
//            
//            self.NomineeAllocationlbl.isHidden = false
//            self.NomineeAllocationView.isHidden = false
//            self.NomineeHolderView1.isHidden = true
//            self.NomineeHolderView2.isHidden = true
//            self.NomineeHolderView3.isHidden = true
//            
//            if nomineeCount > 0 {
//                let nominee1 = self.nomineeDetailsArray[0]
//                self.nominee1Name.text = nominee1["NomineeName"] as? String
//                self.nominee1DocumentType.text = nominee1["DocumentNumber"] as? String
//                let mobileNo = nominee1["MobileNo"] as? String ?? ""
//                let dob = nominee1["DOB"] as? String ?? ""
//                self.Nominee1MobilenoDOB.text = "Mobile: \(mobileNo) / DOB: \(dob)"
//                if let percentage = nominee1["Percentage"] as? Int {
//                    self.nominee1percentageTF.text = "\(percentage)"
//                }
//                
//                // Set NomineeType and adjust button selection
//                if let nomineeType = nominee1["NomineeType"] as? String {
//                    self.NomineeType = nomineeType
//                    print("NomineeType: \(self.NomineeType)")
//                    
//                    // Deselect both buttons initially
//                    self.YesBtn.isSelected = false
//                    self.NoBtn.isSelected = false
//                    
//                    if nomineeType == "Y" {
//                        self.YesBtn.isSelected = true
//                        self.NoBtn.isEnabled = false
//                        self.AddNomineeBtn.isEnabled = false
//                    } else if nomineeType == "N" {
//                        self.NoBtn.isSelected = true
//                        self.YesBtn.isEnabled = false
//                    }
//                }
//                self.nominee1percentageTF.isEnabled = false
//            }
//            
//            if nomineeCount > 1 {
//                let nominee2 = self.nomineeDetailsArray[1]
//                self.nominee2Name.text = nominee2["NomineeName"] as? String
//                self.nominee2DocumentType.text = nominee2["DocumentNumber"] as? String
//                let mobileNo = nominee2["MobileNo"] as? String ?? ""
//                let dob = nominee2["DOB"] as? String ?? ""
//                self.Nominee2MobilenoDOB.text = "Mobile: \(mobileNo) / DOB: \(dob)"
//                
//                if let percentage = nominee2["Percentage"] as? Int {
//                    self.nominee2percentageTF.text = "\(percentage)"
//                }
//                self.nominee2percentageTF.isEnabled = false
//            }
//            
//            if nomineeCount > 2 {
//                let nominee3 = self.nomineeDetailsArray[2]
//                self.nominee3Name.text = nominee3["NomineeName"] as? String
//                self.nominee3DocumentType.text = nominee3["DocumentNumber"] as? String
//                let mobileNo = nominee3["MobileNo"] as? String ?? ""
//                let dob = nominee3["DOB"] as? String ?? ""
//                self.Nominee3MobilenoDOB.text = "Mobile: \(mobileNo) / DOB: \(dob)"
//                
//                if let percentage = nominee3["Percentage"] as? Int {
//                    self.nominee3percentageTF.text = "\(percentage)"
//                }
//                self.nominee3percentageTF.isEnabled = false
//            }
//            if nomineeCount > 0 {
//                self.NomineeHolderView1.isHidden = false
//                self.allocationNominee1View.isHidden = false
//                if nomineeCount > 1 {
//                    self.NomineeHolderView2.isHidden = false
//                    self.allocationNominee2View.isHidden = false
//                }
//                if nomineeCount > 2 {
//                    self.NomineeHolderView3.isHidden = false
//                    self.allocationNominee3View.isHidden = false
//                }
//            }
//        }
//    }
//}
//
