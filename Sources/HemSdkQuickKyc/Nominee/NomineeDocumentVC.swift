//
//  NomineeDocumentVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

//import UIKit
//
//protocol NomineeDocumentVCDelegate: AnyObject {
//    func didSaveNomineeDetails(_ details: [String: Any], for identifier: String)
//}
//
//class NomineeDocumentVC: UIViewController, @MainActor SelectionDelegate ,@MainActor VerticsVCDelegate, @MainActor RelationshipScheme , @MainActor CalenderVCDelegate, UITextFieldDelegate, @MainActor DigiLocker_b_VCDelegate  {
//
//    func didDismissDigiLockerVC() {
//        self.dismiss(animated: true)
//    }
//    
//    weak var delegate: NomineeDocumentVCDelegate?
//    var identifier: String = ""
//    var Country : String?
//    var guardianCountry : String?
//    var NomineeMinor : String?
//    var documentType : String?
//    var guardiandocumentType : String?
//    var relationID:String?
//    var guardianRelationID:String?
//    var state: String?
//    var checkbtn:String?
//    var nomineeDetails : [String: Any]?
//    var isNomineeVerified = false
//    var isGuardianVerified = false
//    var nomineeCount: Int?
//    var relationDictionary : [String : String] = [:]
//    var nomineeDetailsArray: [[String: Any]] = []
//    
//    func didSelectDate(_ date: String,identifier: String) {
//        
//        switch identifier {
//        case "nomineeDOB":
//            dobTF.text = date
//            if let age = calculateAge(from: date) {
//                toggleGuardianHolderViews(show: age < 18)
//                NomineeMinor = age < 18 ? "Y" : "N"   // ✅ Fix
//            }
//        case "guardianDOB":
//            guardianDOBTF.text = date
//            if let age = calculateAge(from: date) {
//                // toggleGuardianHolderViews(show: age < 18)
//                NomineeMinor = "Y"
//            }
//        default:
//            break
//        }
//    }
//    
//    func didSelectRelation(type: String, id: String,identifier: String) {
//        switch identifier {
//        case "nomineeRelation":
//            RelationBtn.setTitle(type, for: .normal)
//            relationID = id
//        case "guardianRelation":
//            guardianRelationBtn.setTitle(type, for: .normal)
//            guardianRelationID = id
//        default:
//            break
//        }
//    }
//    
////    func didReceiveApiResponse(data: [String: Any], identifier1: String, identifier3: String) {
////        // Handle the received API response data
////        print("Received API Response: \(data)")
////        
////        switch identifier1 {
////        case "NomineeDocument":
////            // Update nominee textfields
////            if let dob = data["DOB"] as? String {
////                dobTF.text = dob
////                if let age = calculateAge(from: dob) {
////                    toggleGuardianHolderViews(show: age < 18)
////                }
////            }
////            if let address1 = data["Address1"] as? String {
////                addressLine1TF.text = address1
////            }
////            if let address2 = data["Address2"] as? String {
////                addressLine2TF.text = address2
////            }
////            if let address3 = data["Address3"] as? String {
////                addressLine3TF.text = address3
////            }
////            if let pincode = data["PinCode"] as? String {
////                pincodeTF.text = pincode
////                validatePinCode(pinCode: pincode, for: "nominee")
////            }
////            if let city = data["City"] as? String {
////                cityTF.text = city
////            }
////            if let state = data["State"] as? String {
////                stateTF.text = state
////            }
////            if let uid = data["Uid"] as? String {
////                documentIdTF.text = uid
////                self.isNomineeVerified = true
////            }
////            if let nameAsPerAadhaar = data["NameAsPerAadhaar"] as? String {
////                nomineeNameTF.text = nameAsPerAadhaar
////            }
////            dobTF.isEnabled = false
////            documentIdTF.isEnabled = false
////            nomineeNameTF.isEnabled = false
////            documentTypeBtn.isEnabled = false
////            
////            addressLine1TF.isEnabled = false
////            addressLine2TF.isEnabled = false
////            addressLine3TF.isEnabled = false
////            pincodeTF.isEnabled = false
////            
////        case "guardianDocument":
////            // Update guardian textfields
////            
////            // checkBtn.isHidden = true
////            if let dob = data["DOB"] as? String {
////                guardianDOBTF.text = dob
////            }
////            if let address1 = data["Address1"] as? String {
////                guardianAddress1TF.text = address1
////            }
////            if let address2 = data["Address2"] as? String {
////                guardianAddress2TF.text = address2
////            }
////            if let address3 = data["Address3"] as? String {
////                guardianAddress3TF.text = address3
////            }
////            if let pincode = data["PinCode"] as? String {
////                guardianPinCodeTF.text = pincode
////                validatePinCode(pinCode: pincode, for: "guardian")
////            }
////            if let city = data["City"] as? String {
////                guardianCityTF.text = city
////            }
////            if let state = data["State"] as? String {
////                guardianStateTF.text = state
////            }
////            if let uid = data["Uid"] as? String {
////                guardianIDTF.text = uid
////                self.isGuardianVerified = true
////            }
////            if let nameAsPerAadhaar = data["NameAsPerAadhaar"] as? String {
////                guardianNomineeNameTF.text = nameAsPerAadhaar
////            }
////            guardianDOBTF.isEnabled = false
////            guardianIDTF.isEnabled = false
////            guardianNomineeNameTF.isEnabled = false
////            guardianDocumentBtn.isEnabled = false
////            
////            guardianAddress1TF.isEnabled = false
////            guardianAddress2TF.isEnabled = false
////            guardianAddress3TF.isEnabled = false
////            guardianPinCodeTF.isEnabled = false
////            guardianCityTF.isEnabled = false
////            guardianCityTF.isEnabled = false
////            
////        default:
////            print("Unknown identifier: \(identifier1)")
////        }
////        
////        let name = data["NameAsPerAadhaar"] as? String
////        let dob = data["DOB"] as? String
////        let gender = data["Gender"] as? String
////        let fatherName = data["FatherSpouseName"] as? String
////        let address =
////        "\(data["Address1"] as? String ?? ""), \(data["Address2"] as? String ?? ""), \(data["Address3"] as? String ?? ""), \(data["City"] as? String ?? ""), \(data["State"] as? String ?? ""), \(data["PinCode"] as? String ?? "")"
////        
////        let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
////        if let digiLockerVC = storyboard.instantiateViewController(withIdentifier: "DigiLocker_b_VC") as? DigiLocker_b_VC {
////            digiLockerVC.name = name
////            digiLockerVC.dob = dob
////            digiLockerVC.gender = gender
////            digiLockerVC.fatherName = fatherName
////            digiLockerVC.address = address
////            digiLockerVC.modalPresentationStyle = .overCurrentContext
////            digiLockerVC.modalTransitionStyle = .crossDissolve
////            digiLockerVC.delegate = self
////            //self.present(digiLockerVC, animated: true, completion: nil)
////            DispatchQueue.main.async {
////                self.dismiss(animated: true) {
////                    digiLockerVC.modalPresentationStyle = .overCurrentContext
////                    digiLockerVC.modalTransitionStyle = .crossDissolve
////                    UIApplication.shared.keyWindow?.rootViewController?.present(digiLockerVC, animated: true, completion: nil)
////                }
////            }
////        }
////    }
//
//    @IBOutlet weak var nomineeStackView1: UIStackView!
//    @IBOutlet weak var nomineeStackView2: UIStackView!
//    @IBOutlet weak var nomineeStackView3: UIStackView!
//    @IBOutlet weak var nomineeNameTF: UITextField!
//    @IBOutlet weak var dobTF: UITextField!
//    @IBOutlet weak var documentIdTF: UITextField!
//    @IBOutlet weak var nomineeMobileNoTF: UITextField!
//    @IBOutlet weak var nomineeEmailIdTF: UITextField!
//    @IBOutlet weak var addressLine1TF: UITextField!
//    @IBOutlet weak var addressLine2TF: UITextField!
//    @IBOutlet weak var addressLine3TF: UITextField!
//    @IBOutlet weak var pincodeTF: UITextField!
//    @IBOutlet weak var cityTF: UITextField!
//    @IBOutlet weak var stateTF: UITextField!
//    @IBOutlet weak var Holderview: UIView!
//    @IBOutlet weak var RelationBtn: UIButton!
//    @IBOutlet weak var VerifyBtn: UIButton!
//    @IBOutlet weak var guardianIDTF: UITextField!
//    @IBOutlet weak var guardianNomineeNameTF: UITextField!
//    @IBOutlet weak var guardianRelationBtn: UIButton!
//    @IBOutlet weak var guardianVerifyBtn: UIButton!
//    @IBOutlet weak var guardianDocumentBtn: UIButton!
//    @IBOutlet weak var guardianDOBTF: UITextField!
//    @IBOutlet weak var documentTypeBtn: UIButton!
//    @IBOutlet weak var guardianAddress1TF: UITextField!
//    @IBOutlet weak var guardianAddress2TF: UITextField!
//    @IBOutlet weak var guardianAddress3TF: UITextField!
//    @IBOutlet weak var guardianPinCodeTF: UITextField!
//    @IBOutlet weak var guardianCityTF: UITextField!
//    @IBOutlet weak var guardianStateTF: UITextField!
//    @IBOutlet weak var guardianEmailTF: UITextField!
//    @IBOutlet weak var guardianMobileNoTF: UITextField!
//    @IBOutlet weak var guardianHolderView1: UIStackView!
//    @IBOutlet weak var guardianHolderView2: UIStackView!
//    @IBOutlet weak var guardianHolderView3: UIStackView!
//    @IBOutlet weak var guardianHolderView4: UIStackView!
//    @IBOutlet weak var guardianHolderView5: UIStackView!
//    @IBOutlet weak var guardianHolderView6: UIStackView!
//    @IBOutlet weak var guardianHolderView7: UIStackView!
//    @IBOutlet weak var relationlbl: UILabel!
//    @IBOutlet weak var checkBtn: UIButton!
//    @IBOutlet weak var guardianHolderView8: UIStackView!
//    @IBOutlet weak var guardianHolderView9: UIStackView!
//    @IBOutlet weak var guardianHolderView10: UIStackView!
//    @IBOutlet weak var guardianHolderView11: UIStackView!
//    @IBOutlet weak var guardianHolderView12: UIStackView!
//    @IBOutlet weak var guardianHolderView13: UIStackView!
//    @IBOutlet weak var SaveNextBtn: UIButton!
//    @IBOutlet weak var checkSameAddressBtn: UIButton!
//    @IBOutlet weak var relationWithNomineeLbl: UILabel!
//    @IBOutlet weak var selectStack: UIStackView!
//    @IBOutlet weak var addressStack1: UIStackView!
//    @IBOutlet weak var addressStack2: UIStackView!
//    @IBOutlet weak var addressStack3: UIStackView!
//    @IBOutlet weak var pinStack: UIStackView!
//    @IBOutlet weak var cityStack: UIStackView!
//    @IBOutlet weak var stateStack: UIStackView!
//    
//    var PanNo : String?
//    var PANName : String?
//    var RegId : String?
//    var mobiledecodeArray: String?
//    var fetchedUserId: String?
//    var fetchedSessionID: String?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("identifier:-\(identifier)")
//        self.Holderview.layer.cornerRadius = 10
//        SaveNextBtn.layer.cornerRadius = 10
//        //        self.ShareHolderView.layer.cornerRadius = 10
//        self.VerifyBtn.layer.cornerRadius = 10
//        self.VerifyBtn.layer.borderWidth = 2
//        self.VerifyBtn.layer.borderColor = UIColor.systemPink.cgColor
//        self.guardianVerifyBtn.layer.cornerRadius = 10
//        self.guardianVerifyBtn.layer.borderWidth = 2
//        self.guardianVerifyBtn.layer.borderColor = UIColor.systemPink.cgColor
//        toggleGuardianHolderViews(show: false)
//        //        cityStack.isHidden = true
//        //        stateStack.isHidden = true
//        guardianHolderView12.isHidden = true
//        guardianHolderView13.isHidden = true
//        
//        guardianHolderView12.isHidden = true
//        guardianHolderView13.isHidden = true
//        checkBtn.isHidden = true
//        didselectdepository(shoulsShow: true)
//        didselectGuardianDepository(shoulsShow: true)
//        
//        guardianDocumentBtn.setTitle("", for: .normal)
//        guardianRelationID = ""
//        
//        self.checkBtn.isUserInteractionEnabled = false
//        
//        self.checkBtn.isSelected = false
//        guardianHolderView8.isHidden = true
//        guardianHolderView9.isHidden = true
//        guardianHolderView10.isHidden = true
//        guardianHolderView11.isHidden = true
//        guardianHolderView12.isHidden = true
//        guardianHolderView13.isHidden = true
//        
//        self.NomineeMinor = "N"
//        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID,decodeByteArrayString  in
//            guard let self = self else { return }
//            
//            if let userId = userId, let sessionID = sessionID {
//                self.fetchedUserId = userId
//                self.fetchedSessionID = sessionID
//                self.mobiledecodeArray = decodeByteArrayString
//                print("UserID: \(userId), SessionID: \(sessionID)")
//                //                self.GetRelation()
//            } else {
//                print("No UserID or SessionID found.")
//            }
//        }
//        guardianMobileNoTF.delegate = self
//        nomineeMobileNoTF.delegate = self
//        pincodeTF.delegate = self
//        guardianPinCodeTF.delegate = self
//        self.autofillNomineeDetails()
//        checkSameAddressBtn.isSelected = false
//        if checkSameAddressBtn.isSelected {
//            // Ensure all are hidden again when the screen reappears
//            checkSameAddressBtn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
//            addressStack1.isHidden = true
//            addressStack2.isHidden = true
//            addressStack3.isHidden = true
//            pinStack.isHidden = true
//            cityStack.isHidden = true
//            stateStack.isHidden = true
//        }
//        navigationItem.hidesBackButton = true
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        if checkSameAddressBtn.isSelected {
//            checkSameAddressBtn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
//            addressStack1.isHidden = true
//            addressStack2.isHidden = true
//            addressStack3.isHidden = true
//            pinStack.isHidden = true
//            cityStack.isHidden = true
//            stateStack.isHidden = true
//        } else {
//            checkSameAddressBtn.setImage(UIImage(systemName: "square"), for: .normal)
//            addressStack1.isHidden = false
//            addressStack2.isHidden = false
//            addressStack3.isHidden = false
//            pinStack.isHidden = false
//            cityStack.isHidden = false
//            stateStack.isHidden = false
//        }
//    }
//    
//    private func autofillNomineeDetails() {
//        self.GetRelation { [weak self] success in
//            guard let self = self else { return }
//            guard success else {
//                print("Failed to fetch relation data.")
//                return
//            }
//            
//            guard let details = self.nomineeDetails else { return }
//            
//            // Setting the title for documentTypeBtn and guardianDocumentBtn
//            if let nomineeDocumentType = details["nomineeDocumentType"] as? String {
//                self.documentTypeBtn.setTitle(nomineeDocumentType, for: .normal)
//                self.documentType = nomineeDocumentType
//                didselectdepository(shoulsShow: false)
//                // Check if the document type is Aadhaar
//                if nomineeDocumentType == "Aadhaar" {
//                    self.isNomineeVerified = true
//                    dobTF.isEnabled = false
//                    documentIdTF.isEnabled = false
//                    nomineeNameTF.isEnabled = false
//                    documentTypeBtn.isEnabled = false
//                    addressLine1TF.isEnabled = false
//                    addressLine2TF.isEnabled = false
//                    addressLine3TF.isEnabled = false
//                    pincodeTF.isEnabled = false
//                    cityTF.isEnabled = false
//                    stateTF.isEnabled = false
//                }
//            }
//            if let guardianDocumentType = details["GuardianDocumentType"] as? String,!guardianDocumentType.isEmpty {
//                self.guardianDocumentBtn.setTitle(guardianDocumentType, for: .normal)
//                
//                self.guardiandocumentType = guardianDocumentType
//                
//                
//                
//                if guardianDocumentType == "Aadhaar" {
//                    didselectGuardianDepository(shoulsShow: false)
//                    toggleGuardianHolderViews(show: false)
//                    checkBtn.isHidden = false
//                    self.isGuardianVerified = true
//                    guardianDOBTF.isEnabled = false
//                    guardianIDTF.isEnabled = false
//                    guardianNomineeNameTF.isEnabled = false
//                    guardianDocumentBtn.isEnabled = false
//                    
//                    guardianAddress1TF.isEnabled = false
//                    guardianAddress2TF.isEnabled = false
//                    guardianAddress3TF.isEnabled = false
//                    guardianPinCodeTF.isEnabled = false
//                    guardianCityTF.isEnabled = false
//                    guardianCityTF.isEnabled = false
//                }
//            }
//            // Update text fields
//            self.nomineeNameTF.text = details["nomineeName"] as? String
//            self.dobTF.text =  details["dob"] as? String
//            self.documentIdTF.text = details["documentId"] as? String
//            self.nomineeMobileNoTF.text = details["nomineeMobileNo"] as? String
//            self.nomineeEmailIdTF.text = details["nomineeEmailId"] as? String
//            self.addressLine1TF.text = details["addressLine1"] as? String
//            self.addressLine2TF.text = details["addressLine2"] as? String
//            self.addressLine3TF.text = details["addressLine3"] as? String
//            self.pincodeTF.text = details["pincode"] as? String
//            self.cityTF.text = details["city"] as? String
//            self.stateTF.text = details["state"] as? String
//            //            cityStack.isHidden = false
//            //            stateStack.isHidden = false
//            if let addressSameAsApplicant = details["SameAsNominee"] as? String,!addressSameAsApplicant.isEmpty {
//                if addressSameAsApplicant == "1" {
//                    checkBtn.isSelected = true
//                    checkbtn = "1"
//                    
//                    
//                } else if addressSameAsApplicant == "0" {
//                    checkBtn.isSelected = false
//                    checkbtn = "0"
//                }
//                checkBtn.isEnabled = false
//            }
//            
//            // Update relation buttons if the relation data is available
//            if let relationId = details["relation"] as? String {
//                self.relationID = relationId
//                if let relationName = self.relationDictionary[relationId] {
//                    self.RelationBtn.setTitle(relationName, for: .normal)
//                } else {
//                    print("No matching relation name found for ID: \(relationId)")
//                }
//            }
//            
//            if let guardianrelationId = details["guardianRelation"] as? String {
//                self.guardianRelationID = guardianrelationId
//                if let relationName = self.relationDictionary[guardianrelationId] {
//                    self.guardianRelationBtn.setTitle(relationName, for: .normal)
//                } else {
//                    print("No matching guardian relation name found for ID: \(guardianrelationId)")
//                }
//            }
//            
//            // Set other guardian fields
//            self.guardianCountry = details["guardianCountry"] as? String
//            self.guardianDOBTF.text = details["GuardianDOB"] as? String
//            self.guardianPinCodeTF.text = details["GuardianPinCode"] as? String
//            self.guardianStateTF.text = details["GuardianState"] as? String
//            self.guardianNomineeNameTF.text = details["GuardianName"] as? String
//            self.guardianMobileNoTF.text = details["GMobileNo"] as? String
//            self.guardianEmailTF.text = details["GEmail"] as? String
//            self.guardianCityTF.text = details["GuardianCity"] as? String
//            self.guardianAddress1TF.text = details["GuardianAddress1"] as? String
//            self.guardianAddress2TF.text = details["GuardianAddress2"] as? String
//            self.guardianAddress3TF.text = details["GuardianAddress3"] as? String
//            self.guardianDocumentBtn.setTitle(details["GuardianDocumentType"] as? String, for: .normal)
//            self.guardianIDTF.text = details["GDocumentIDNumberADhar"] as? String
//            
//            // Disable fields
//            self.disableFields()
//        }
//    }
//    
//    private func disableFields() {
//        self.guardianIDTF.isEnabled = false
//        self.guardianNomineeNameTF.isEnabled = false
//        self.guardianDOBTF.isEnabled = false
//        self.nomineeNameTF.isEnabled = false
//        self.dobTF.isEnabled = false
//        self.documentIdTF.isEnabled = false
//        self.guardianDocumentBtn.isEnabled = false
//        self.documentTypeBtn.isEnabled = false
//    }
//    
//    func GetRelation(completion: @escaping (Bool) -> Void) {
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//            guard let tokenId = tokenId else {
//                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                    if success {
//                        // Call SIXTHAPI after tokenMobile API call is successful
//                        self.GetRelation(completion: completion)
//                    } else {
//                        print("Token generation failed.")
//                        completion(false)
//                    }
//                }
//                return
//            }
//            let parameters: [String: Any?] = [
//                "TokenId": tokenId,
//                "RelationType":"N"
//            ]
//            
//            let url = "DropDownManagement/GetRelation"
//            apiCall(url: url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("GetRelation Response: \(jsonResponse)")
//                    if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
//                        DispatchQueue.main.async {
//                            if let relationList = jsonResponse["RelationList"] as? [[String: Any]] {
//                                // Populate the dictionary with relation ID and names
//                                for relation in relationList {
//                                    if let id = relation["Id"] as? String, let name = relation["Relation"] as? String {
//                                        self.relationDictionary[id] = name
//                                    }
//                                }
//                                print("relation dictionary populated: \(self.relationDictionary)")
//                                completion(true)  // Call completion handler with success
//                            } else {
//                                completion(false)  // No relation list
//                            }
//                        }
//                    } else {
//                        completion(false)  // Error in API response
//                    }
//                case .failure(let error):
//                    print("API call failed: \(error.localizedDescription)")
//                    completion(false)
//                }
//            }
//        }
//    }
//    
//    @IBAction func homeBtn(_ sender: UIButton) {
//        self.navigationController?.popToRootViewController(animated: true)
//    }
//    
//    @IBAction func backBtn(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    @IBAction func checkSameAddressBtnTapped(_ sender: UIButton) {
//        sender.isSelected.toggle()
//        
//        if sender.isSelected {
//            // Selected state: hide fields, show checked image
//            sender.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
//            addressStack1.isHidden = true
//            addressStack2.isHidden = true
//            addressStack3.isHidden = true
//            pinStack.isHidden = true
//            cityStack.isHidden = true
//            stateStack.isHidden = true
//        } else {
//            // Unselected state: show fields, show unchecked image
//            sender.setImage(UIImage(systemName: "square"), for: .normal)
//            addressStack1.isHidden = false
//            addressStack2.isHidden = false
//            addressStack3.isHidden = false
//            pinStack.isHidden = false
//            cityStack.isHidden = false
//            stateStack.isHidden = false
//        }
//    }
//    
//    
//    @IBAction func saveBtn(_ sender: UIButton) {
//        
//        guard let documentType = documentType, !documentType.isEmpty else {
//            showAlert(message: "Please Select DocumentType.")
//            return
//        }
//        guard let panNo = documentIdTF.text, !panNo.isEmpty,
//              let name = nomineeNameTF.text, !name.isEmpty,
//              let userDOB = dobTF.text, !userDOB.isEmpty else {
//            showAlert(message: "Please enter Nominee Name, DOB, and Document ID.")
//            return
//        }
//        
//        guard let nomineeMobile = nomineeMobileNoTF.text, !nomineeMobile.isEmpty else {
//            showAlert(message: "Please enter nominee Mobile Number.")
//            return
//        }
//        
//        if nomineeMobile.count != 10 {
//            showAlert(message: "Nominee mobile number must be 10 digits.")
//            return
//        }
//        
//        // Nominee Email validation
//        guard let nomineeEmail = nomineeEmailIdTF.text, !nomineeEmail.isEmpty else {
//            showAlert(message: "Please enter nominee email address.")
//            return
//        }
//        
//        if !isValidEmail(nomineeEmail) {
//            showAlert(message: "Please enter a valid nominee email address.")
//            return
//        }
//        
//        
//        guard let relationID = relationID, !relationID.isEmpty else {
//            showAlert(message: "Please Select Relation.")
//            return
//        }
//        
//        if let age = calculateAge(from: dobTF.text ?? "") {
//            if age < 18 {
//                
//                guard let guardiandocumentType = guardiandocumentType, !guardiandocumentType.isEmpty else {
//                    showAlert(message: "Please Select Guardian Document Type.")
//                    return
//                }
//                self.NomineeMinor = "Y"
//                // Check if guardian name, DOB, and document ID are not empty
//                guard let guardianID = guardianIDTF.text, !guardianID.isEmpty,
//                      let guardianName = guardianNomineeNameTF.text, !guardianName.isEmpty,
//                      let guardianDOB = guardianDOBTF.text, !guardianDOB.isEmpty else {
//                    showAlert(message: "Please enter Name, DOB, and Document ID.")
//                    return
//                }
//                
//                // Check if guardian relation is selected
//                guard let guardianRelationID = guardianRelationID, !guardianRelationID.isEmpty else {
//                    showAlert(message: "Please Select Guardian Relation.")
//                    return
//                }
//                // Validate guardian email and mobile (only if entered)
//                if let guardianEmail = guardianEmailTF.text, !guardianEmail.isEmpty {
//                    if !isValidEmail(guardianEmail) {
//                        showAlert(message: "Please enter a valid guardian email address.")
//                        return
//                    }
//                }
//                
//                if let guardianMobile = guardianMobileNoTF.text, !guardianMobile.isEmpty {
//                    if guardianMobile.count != 10 {
//                        showAlert(message: "Guardian mobile number must be 10 digits.")
//                        return
//                    }
//                }
//                
//                if !checkBtn.isSelected {
//                    guard let guardianAddress = guardianAddress1TF.text, !guardianAddress.isEmpty else {
//                        showAlert(message: "Please enter Guardian Address.")
//                        return
//                    }
//                }
//                
//                if !checkBtn.isSelected {
//                    guard let guardianPinCode = guardianPinCodeTF.text, !guardianPinCode.isEmpty else {
//                        showAlert(message: "Please enter Guardian Pincode.")
//                        return
//                    }
//                    
//                    
//                    guard guardianPinCode.count == 6 else {
//                        showAlert(message: "Guardian Pincode must be 6 digits long.")
//                        return
//                    }
//                }
//                
//                if !isGuardianVerified {
//                    
//                    showAlert(message: "Please verify the guardian's document before saving.")
//                    return
//                }
//            } else {
//                // Nominee is 18 or older, check if nominee is verified
//                if !isNomineeVerified {
//                    showAlert(message: "Please verify the nominee's document before saving.")
//                    return
//                }
//            }
//        }
//        
//        let nomineeDetails = saveNomineeDetails() // Get the details from text fields
//        
//        print("Saving Nominee Details: \(nomineeDetails)")
//        
//        if state == "Modify" {
//            if let index = nomineeIndex(for: identifier) {
//                if index < nomineeDetailsArray.count {
//                    nomineeDetailsArray[index] = nomineeDetails
//                    print("Modified Nominee at index \(index)")
//                } else {
//                    print("Index out of bounds when trying to modify nominee. Current Nominee Details Array: \(nomineeDetailsArray)")
//                }
//            } else {
//                print("Invalid index for modification. Identifier: \(identifier)")
//            }
//        } else if state == "addnominee" {
//            nomineeDetailsArray.append(nomineeDetails)
//            print("Added New Nominee")
//        }
//        
//        delegate?.didSaveNomineeDetails(nomineeDetails, for: identifier)
//        
//        print("Current Nominee Details Array after save: \(nomineeDetailsArray)")
//        navigationController?.popViewController(animated: true)
//        
//    }
//    
//    private func nomineeIndex(for identifier: String) -> Int? {
//        switch identifier {
//        case "NOMINEE_1":
//            return 0
//        case "NOMINEE_2":
//            return 1
//        case "NOMINEE_3":
//            return 2
//        default:
//            return nil
//        }
//    }
//    private func saveNomineeDetails() -> [String: Any] {
//        return [
//            "nomineeName": nomineeNameTF.text ?? "",
//            "dob": dobTF.text ?? "",
//            "documentId": documentIdTF.text ?? "",
//            "nomineeMobileNo": nomineeMobileNoTF.text ?? "",
//            "nomineeEmailId": nomineeEmailIdTF.text ?? "",
//            "addressLine1": addressLine1TF.text ?? "",
//            "addressLine2": addressLine2TF.text ?? "",
//            "addressLine3": addressLine3TF.text ?? "",
//            "pincode": pincodeTF.text ?? "",
//            "city": cityTF.text ?? "",
//            "state": stateTF.text ?? "",
//            "Country": Country ?? "",
//            "Prefix": "",
//            "AddressSameAsApplicant": checkSameAddressBtn.isSelected ? "1" : "",
//            "SameAsNominee": checkBtn.isSelected ? "1" : "",
//            "DocumentExpiryDate": "",
//            "relation": relationID ?? "",
//            "guardianRelation": guardianRelationID ?? "",
//            "nomineeDocumentType": documentTypeBtn.title(for: .normal) ?? "",
//            "NomineeMinor": NomineeMinor ?? "",
//            "GuardianDocumentExpiryDate": "",
//            "guardianCountry": guardianCountry ?? "",
//            "GuardianPrefix": "",
//            "GuardianDOB": guardianDOBTF.text ?? "",
//            "GuardianPinCode": guardianPinCodeTF.text ?? "",
//            "GuardianState": guardianStateTF.text ?? "",
//            "GuardianName": guardianNomineeNameTF.text ?? "",
//            "GMobileNo": guardianMobileNoTF.text ?? "",
//            "GEmail": guardianEmailTF.text ?? "",
//            "GuardianCity": guardianCityTF.text ?? "",
//            "GuardianAddress1": guardianAddress1TF.text ?? "",
//            "GuardianAddress2": guardianAddress2TF.text ?? "",
//            "GuardianAddress3": guardianAddress3TF.text ?? "",
//            "GuardianDocumentType": guardianDocumentBtn.title(for: .normal) ?? "",
//            "GDocumentIDNumberADhar": guardianIDTF.text ?? ""
//        ]
//    }
//    
//    @IBAction func calendarBtn(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeDOB"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//    
//    @IBAction func guardianCalenderBtn(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "guardianDOB"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//    
//    @IBAction func CheckBtn(_ sender: UIButton) {
//        if sender.isSelected{
//            sender.isSelected = false
//            guardianHolderView8.isHidden = false
//            guardianHolderView9.isHidden = false
//            guardianHolderView10.isHidden = false
//            guardianHolderView11.isHidden = false
//            guardianHolderView12.isHidden = false
//            guardianHolderView13.isHidden = false
//            guardianAddress1TF.text =  nil
//            guardianAddress2TF.text = nil
//            guardianAddress3TF.text = nil
//            guardianPinCodeTF.text   = nil
//            guardianCityTF.text = nil
//            guardianStateTF.text = nil
//            guardianCountry = nil
//            checkbtn = ""
//        }
//        else{
//            sender.isSelected = true
//            guardianAddress1TF.text = addressLine1TF.text
//            guardianAddress2TF.text = addressLine2TF.text
//            guardianAddress3TF.text = addressLine3TF.text
//            guardianPinCodeTF.text   = pincodeTF.text
//            guardianCityTF.text = cityTF.text
//            guardianStateTF.text = stateTF.text
//            guardianCountry = Country
//            guardianHolderView8.isHidden = true
//            guardianHolderView9.isHidden = true
//            guardianHolderView10.isHidden = true
//            guardianHolderView11.isHidden = true
//            guardianHolderView12.isHidden = true
//            guardianHolderView13.isHidden = true
//            checkbtn = "1"
//        }
//    }
//    
//    @IBAction func guardianRelation(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "relationVC") as! relationVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "guardianRelation"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//    
//    @IBAction func RelationBtn(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "relationVC") as! relationVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeRelation"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//    
//    
//    @IBAction func guardianDocumentTypeBtn(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "guardianDocument"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//    
//    @IBAction func documentTypeBtn(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "NomineeDocument"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//    
//    @IBAction func VerifyBtn(_ sender: UIButton) {
//        guard let panNo = documentIdTF.text, !panNo.isEmpty,
//              let name = nomineeNameTF.text, !name.isEmpty,
//              let userDOB = dobTF.text, !userDOB.isEmpty else {
//            showAlert(message: "Please enter Nominee Name, DOB, and Document ID.")
//            return
//        }
//        guard
//            let panNo = documentIdTF.text,
//            let name = nomineeNameTF.text,
//            let userDOB = dobTF.text else {
//            showAlert(message: "Please enter Nominee Name, DOB, and Document ID.")
//            return
//        }
//        if let age = calculateAge(from: userDOB) {
//            
//            toggleGuardianHolderViews(show: age < 18)
//            if let guardianDocumentType = self.nomineeDetails?["GuardianDocumentType"] as? String,!guardianDocumentType.isEmpty {
//                didselectGuardianDepository(shoulsShow: false)
//            }
//            
//        }
//        panValidation(panNo: panNo, name: name, userDOB: userDOB, isGuardian: false)
//        
//    }
//    
//    @IBAction func guardianVerifyBtn(_ sender: UIButton) {
//        guard
//            let panNo = guardianIDTF.text,
//            let name = guardianNomineeNameTF.text,
//            let userDOB = guardianDOBTF.text else {
//            showAlert(message: "Please enter Nominee Name, DOB, and Document ID.")
//            return
//        }
//        panValidation(panNo: panNo, name: name, userDOB: userDOB, isGuardian: true)
//    }
//    
//    func didselectdepository(shoulsShow:Bool){
//        nomineeStackView1.isHidden = shoulsShow
//        nomineeStackView2.isHidden = shoulsShow
//        nomineeStackView3.isHidden = shoulsShow
//    }
//    
//    func didselectGuardianDepository(shoulsShow:Bool){
//        guardianHolderView2.isHidden = shoulsShow
//        
//        guardianHolderView3.isHidden = shoulsShow
//        guardianHolderView4.isHidden = shoulsShow
//    }
//    
//    func didSelectDepository(type: String,identifier: String) {
//        
//        switch identifier {
//        case "NomineeDocument":
//            self.didselectdepository(shoulsShow: false)
//            documentTypeBtn.setTitle(type, for: .normal)
//            documentType = type
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "NomineeDocument")
//            }
//        case "guardianDocument":
//            self.didselectGuardianDepository(shoulsShow: false)
//            
//            guardianDocumentBtn.setTitle(type, for: .normal)
//            guardiandocumentType = type
//            //            if ((guardiandocumentType?.isEmpty) == nil){
//            //                self.didselectGuardianDepository(shoulsShow: true)
//            //            }
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "guardianDocument")
//            }
//        default:
//            break
//        }
//    }
//    
//    func saveDigiLocker(identifier1 : String) {
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//            guard let tokenId = tokenId else {
//                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                    if success {
//                        // Call SIXTHAPI after tokenMobile API call is successful
//                        self.saveDigiLocker(identifier1: identifier1)
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }// Handle the case where no tokens are available
//                print("No tokens available. Please reload the tokens.")
//                return
//            }
//            let parameters: [String: Any?] = [
//                "UserId": fetchedUserId,
//                "TokenId": tokenId,
//                "RegId": RegId,
//                "PanNo": PanNo,
//                "PanName": "N",
//                "Flag":"INSERT",
//                "ThirdPartyRequest": ""
//            ]
//            print(parameters)
//            let Url = "AadhaarData/SaveDigiLockerAuditLogDetails"
//            
//            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view,loaderText: "please wait...") { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("SAVE-DIGILOCKER Response: \(jsonResponse)")
//                    //                    let DigiLockerURL = jsonResponse["DigiLockerURL"] as? String
//                    let digilockerReturnURL = jsonResponse["DigiLockeReturnURL"] as? String
//                    let Client_id = jsonResponse["Client_id"] as? String
//                    let DigiLockerURL = jsonResponse["DigiLockerURL"] as? String
//                    let TransactionID = jsonResponse["TransactionID"] as? String
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "999992":
//                            DispatchQueue.main.async {
//                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
//                                print("All TokenMobile entries deleted due to error code 999992")
//                                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                                    if success {
//                                        self.saveDigiLocker(identifier1: identifier1)
//                                    } else {
//                                        print("Token generation failed.")
//                                    }
//                                }
//                            }
//                        case "000000":
//                            DispatchQueue.main.async {
//                                if let digiType = jsonResponse["DigiType"] as? String {
//                                    if digiType == "VERITICS" {
//                                        self.navigateToVeriticsVC(DigiLockerURL: DigiLockerURL ?? "", TransactionID: TransactionID ?? "",identifier1 : identifier1)
//                                    } else if digiType == "DIRECT"{
//                                        let url = "\(DigiLockerURL ?? "")?redirect_uri=\(digilockerReturnURL ?? "")&response_type=code&response_type=code&client_id=\(Client_id ?? "")&state=\(TransactionID ?? "")"
//                                        self.navigateToVeriticsVC(DigiLockerURL: url, TransactionID: TransactionID ?? "", identifier1: identifier1 )
//                                    }else {
//                                        print("Invalid type: \(digiType)")
//                                    }
//                                } else {
//                                    print("DigiType is missing in the response")
//                                }
//                            }
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                        }
//                    }
//                case .failure(let error):
//                    print("Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//    
//    func navigateToVeriticsVC(DigiLockerURL: String, TransactionID: String,identifier1 : String) {
//        let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
//        let vc = storyboard.instantiateViewController(identifier: "VerticsVC") as? VerticsVC
//        vc!.DigiLockerURL = DigiLockerURL
//        vc!.TransactionID = TransactionID
//        vc!.RegId = RegId
//        vc!.identifier1 = identifier1
//        vc!.panNo = identifier
//        vc!.flag = "1"
//        vc!.identifier3 = "NomineeVC"
//        vc!.delegate = self
//        self.navigationController?.pushViewController(vc!, animated: true)
//    }
//    
//    func calculateAge(from dob: String) -> Int? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//        guard let dateOfBirth = dateFormatter.date(from: dob) else {
//            return nil
//        }
//        let calendar = Calendar.current
//        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: Date())
//        return ageComponents.year
//    }
//    
//    func toggleGuardianHolderViews(show: Bool) {
//        guardianHolderView1.isHidden = !show
//        //        guardianHolderView2.isHidden = !show
//        //        guardianHolderView3.isHidden = !show
//        //        guardianHolderView4.isHidden = !show
//        guardianHolderView5.isHidden = !show
//        guardianHolderView6.isHidden = !show
//        guardianHolderView7.isHidden = !show
//        relationlbl.isHidden = !show
//        guardianHolderView8.isHidden = !show
//        guardianHolderView9.isHidden = !show
//        guardianHolderView10.isHidden = !show
//        guardianHolderView11.isHidden = !show
//        guardianHolderView12.isHidden = !show
//        guardianHolderView13.isHidden = !show
//        checkBtn.isHidden = !show
//        //        checkBtn.isSelected = true
//        //        checkbtn = "1"
//        checkBtn.isUserInteractionEnabled = true
//    }
//}
//
//extension NomineeDocumentVC{
//    func panValidation(panNo: String, name: String, userDOB: String,isGuardian: Bool){
//        
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//            guard let tokenId = tokenId else {
//                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                    if success {
//                        // Call SIXTHAPI after tokenMobile API call is successful
//                        self.panValidation(panNo: panNo, name: name, userDOB: userDOB, isGuardian: isGuardian)
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
//                "TokenId": tokenId,
//                "PanNo": panNo,
//                "DeviceType": "1",
//                "Name": name,
//                "UserDOB": userDOB,
//                "Flag":"N",
//                "NOMType":identifier
//            ]
//            
//            // URL for the login endpoint
//            let Url = "Registration/ThirdPartyPANVerify"
//            //            for (key, value) in parameters {
//            //                if let stringValue = value as? String, stringValue.isEmpty {
//            //                    parameters[key] = nil
//            //                }
//            //            }
//            print(parameters)
//            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view,loaderText: "please wait processing data...") { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("PAN api Response: \(jsonResponse)")
//                    
//                    let ErrorMessage = jsonResponse["ErrorMessage"] as? String
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        
//                        switch errorCode {
//                            
//                        case "000000":
//                            DispatchQueue.main.async {
//                                
//                                if isGuardian {
//                                    self.isGuardianVerified = true
//                                    self.guardianIDTF.isEnabled = false
//                                    self.guardianNomineeNameTF.isEnabled = false
//                                    self.guardianDOBTF.isEnabled = false
//                                    self.guardianDocumentBtn.isEnabled = false
//                                } else {
//                                    self.isNomineeVerified = true
//                                    self.nomineeNameTF.isEnabled = false
//                                    self.dobTF.isEnabled = false
//                                    self.documentIdTF.isEnabled = false
//                                    self.documentTypeBtn.isEnabled = false
//                                }
//                                
//                                let storyboard = UIStoryboard(name: "DashboardVC", bundle: Bundle.module)
//                                
//                                // Instantiate the view controller by its identifier
//                                guard let viewController = storyboard.instantiateViewController(withIdentifier: "PanVerifyPopupVC") as? PanVerifyPopupVC else {
//                                    print("ViewController not found")
//                                    return
//                                }
//                                viewController.panName = jsonResponse["PANName"] as? String
//                                viewController.dob = jsonResponse["DOB"] as? String
//                                viewController.requestId = jsonResponse["RequestId"] as? String
//                                viewController.panNo = jsonResponse["PanNo"] as? String
//                                viewController.identifier = "nomineePanVerify"
//                                viewController.modalPresentationStyle = .overCurrentContext
//                                
//                                viewController.modalTransitionStyle = .crossDissolve
//                                print("present")
//                                self.present(viewController, animated: true, completion: nil)
//                            }
//                            
//                        case "100001":
//                            DispatchQueue.main.async {
//                                
//                                self.showAlert( message: ErrorMessage ?? "")
//                            }
//                        case "300009":
//                            DispatchQueue.main.async {
//                                
//                                self.showAlert( message: ErrorMessage ?? "")
//                            }
//                        case "Pan-001":
//                            DispatchQueue.main.async {
//                                
//                                self.showAlert(message: ErrorMessage ?? "")
//                            }
//                        case "PANDOB-001":
//                            DispatchQueue.main.async {
//                                
//                                self.showAlert(message: ErrorMessage ?? "")
//                            }
//                        case "300001":
//                            DispatchQueue.main.async {
//                                
//                                self.showAlert(message: ErrorMessage ?? "")
//                            }
//                        case "300006":
//                            DispatchQueue.main.async {
//                                
//                                self.showAlert(message: ErrorMessage ?? "")
//                            }
//                        case "111111":
//                            DispatchQueue.main.async {
//                                
//                                self.showAlert(message: "Please check your pancard ID number")
//                            }
//                            
//                        case "300003":
//                            if let errorMessage = jsonResponse["ErrorMessage"] as? String {
//                                DispatchQueue.main.async {
//                                    self.showAlert(message: errorMessage)
//                                }
//                            }
//                        default:
//                            print("Unhandled error code: \(errorCode)")
//                        }
//                    }
//                    
//                case .failure(let error):
//                    print("Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//    
//    func isValidEmail(_ email: String) -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
//        return emailTest.evaluate(with: email)
//    }
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // Allow only digits
//        let allowedCharacterSet = CharacterSet.decimalDigits
//        let replacementStringCharacterSet = CharacterSet(charactersIn: string)
//        
//        // Check if the input is numeric
//        let isNumeric = allowedCharacterSet.isSuperset(of: replacementStringCharacterSet)
//        
//        // Ensure only 10 digits are allowed for mobile numbers and 6 digits for pin codes
//        let currentText = textField.text ?? ""
//        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
//        
//        if textField == nomineeMobileNoTF || textField == guardianMobileNoTF {
//            if !isNumeric {
//                showAlert(message: "Please enter only numbers.")
//                return false
//            }
//            return prospectiveText.count <= 10
//        } else if textField == pincodeTF || textField == guardianPinCodeTF {
//            if !isNumeric {
//                showAlert(message: "Please enter only numbers.")
//                return false
//            }
//            if prospectiveText.count == 6 {
//                validatePinCode(pinCode: prospectiveText, for: textField == pincodeTF ? "nominee" : "guardian")
//            }
//            return prospectiveText.count <= 6
//        }
//        
//        return true
//    }
//    
//    func validatePinCode(pinCode: String, for type: String) {
//        let parameters: [String: Any?] = [
//            "PinCode": pinCode
//        ]
//        
//        print(parameters)
//        
//        let url = "CityState/GetCitySateOnPincode"
//        
//        apiCall(url: url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
//            switch result {
//            case .success(let jsonResponse):
//                print("DPSchemeName Response: \(jsonResponse)")
//                if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
//                    DispatchQueue.main.async {
//                        if let countryList = jsonResponse["CountryList"] as? [[String: Any]], let firstItem = countryList.first {
//                            let city = firstItem["City"] as? String
//                            let state = firstItem["State"] as? String
//                            let Country = firstItem["Country"] as? String
//                            if type == "nominee" {
//                                self.cityTF.text = city
//                                self.stateTF.text = state
//                                self.Country = Country
//                                self.cityTF.isUserInteractionEnabled = false
//                                self.stateTF.isUserInteractionEnabled = false
//                                //self.cityStack.isHidden = false
//                                //self.stateStack.isHidden = false
//                            } else if type == "guardian" {
//                                self.guardianCityTF.text = city
//                                self.guardianStateTF.text = state
//                                self.guardianCountry = Country
//                                self.guardianCityTF.isUserInteractionEnabled = false
//                                self.guardianStateTF.isUserInteractionEnabled = false
//                                self.guardianHolderView12.isHidden = false
//                                self.guardianHolderView13.isHidden = false
//                            }
//                        }
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        if let errorMessage = jsonResponse["ErrorMessage"] as? String {
//                            self.showAlert(message: errorMessage)
//                        } else {
//                            self.showAlert(message: "Unhandled error code")
//                        }
//                    }
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self.showAlert(message: "API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//    
//    func showAlert(message: String) {
//        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
//    }
//}
