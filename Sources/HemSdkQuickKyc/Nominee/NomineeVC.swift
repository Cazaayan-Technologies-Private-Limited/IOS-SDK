//
//  NomineeVC.swift
//  t5
//
//  Created by manas dutta on 21/02/26.
//


import UIKit

class NomineeVC: UIViewController, @MainActor SelectionDelegate, @MainActor VerticsVC1Delegate, @MainActor CalenderVCDelegate, @MainActor DigiLocker_b_VCDelegate1, @MainActor ReloadPageDelegate, @MainActor RelationshipScheme {
    func didSelectDepository(type: String, identifier: String) {
        print("🔵 [didSelectDepository] Called → Type: \(type) | Identifier: \(identifier)")
        
        switch identifier {
            
            // MARK: - Nominee Documents
        case "NomineeDocument1":
            DispatchQueue.main.async {
                print("   → Setting Nominee 1 button to \(type)")
                self.updateButtonTitle(self.documentTypeBtn1, title: type)
                self.nomineedocumentType1 = type
                if type == "Aadhaar" {
                    self.saveDigiLocker(identifier1: "NomineeDocument1")
                }
            }
            
        case "NomineeDocument2":
            DispatchQueue.main.async {
                print("   → Setting Nominee 1 button to \(type)")
                self.updateButtonTitle(self.documentTypeBtn2, title: type)
                self.nomineedocumentType2 = type
                if type == "Aadhaar" {
                    self.saveDigiLocker(identifier1: "NomineeDocument2")
                }
            }
            
        case "NomineeDocument3":
            DispatchQueue.main.async {
                print("   → Setting Nominee 1 button to \(type)")
                self.updateButtonTitle(self.documentTypeBtn3, title: type)
                self.nomineedocumentType3 = type
                if type == "Aadhaar" {
                    self.saveDigiLocker(identifier1: "NomineeDocument3")
                }
            }
            
            // MARK: - Guardian Documents (Fixed wrong button names)
        case "guardianDocument1":
            DispatchQueue.main.async {
                print("   → Setting Nominee 1 button to \(type)")
                self.updateButtonTitle(self.guardianDocumentTypeBtn1, title: type)
                self.guardiandocumentType1 = type
                if type == "Aadhaar" {
                    self.saveDigiLocker(identifier1: "guardianDocument1")
                }
            }
            
        case "guardianDocument2":
            DispatchQueue.main.async {
                print("   → Setting Nominee 1 button to \(type)")
                self.updateButtonTitle(self.guardianDocumentTypeBtn2, title: type)
                self.guardiandocumentType2 = type
                if type == "Aadhaar" {
                    self.saveDigiLocker(identifier1: "guardianDocument2")
                }
            }
            
        case "guardianDocument3":
            DispatchQueue.main.async {
                print("   → Setting Nominee 1 button to \(type)")
                self.updateButtonTitle(self.guardianDocumentTypeBtn3, title: type)
                self.guardiandocumentType3 = type
                if type == "Aadhaar" {
                    self.saveDigiLocker(identifier1: "guardianDocument3")
                }
            }
            
        default:
            print("→ Unknown identifier: \(identifier)")
            break
        }
    }
    
    func updateButtonTitle(_ button: UIButton, title: String) {
        if #available(iOS 15.0, *) {
            var config = button.configuration ?? UIButton.Configuration.plain()
            config.title = title
            button.configuration = config
        } else {
            button.setTitle(title, for: .normal)
        }
    }
    
    
    //    func didReceiveApiResponse(data: [String : Any], identifier1: String, identifier3: String) {
    //        DispatchQueue.main.async {
    //
    //            print("🔥 identifier1 received:", identifier1)
    //            print("🔥 API DATA:", data)
    //            // 1. Auto-fill the correct nominee's fields
    //            switch identifier1 {
    //            case "NomineeDocument1":
    //                self.fillNomineeFields(data: data, index: 1)
    //            case "NomineeDocument2":
    //                self.fillNomineeFields(data: data, index: 2)
    //            case "NomineeDocument3":
    //                self.fillNomineeFields(data: data, index: 3)
    //
    //            case "guardianDocument1":
    //                self.fillGuardianFields(data: data, index: 1)
    //
    //            case "guardianDocument2":
    //                self.fillGuardianFields(data: data, index: 2)
    //
    //            case "guardianDocument3":
    //                self.fillGuardianFields(data: data, index: 3)
    //            default:
    //                print("Unknown identifier: \(identifier1)")
    //            }
    //        }
    //    }
    func didReceiveApiResponse(data: [String : Any], identifier1: String, identifier3: String) {
        DispatchQueue.main.async {
            
            print("🔥 identifier1 received:", identifier1)
            print("🔥 API DATA:", data)
            
            // Extract the base identifier (remove any appended _index_isGuardian)
            let baseIdentifier = identifier1.components(separatedBy: "_").first ?? identifier1
            
            // 1. Auto-fill the correct nominee's fields
            switch baseIdentifier {
            case "NomineeDocument1":
                self.fillNomineeFields(data: data, index: 1)
            case "NomineeDocument2":
                self.fillNomineeFields(data: data, index: 2)
            case "NomineeDocument3":
                self.fillNomineeFields(data: data, index: 3)
                
            case "guardianDocument1":
                self.fillGuardianFields(data: data, index: 1)
                
            case "guardianDocument2":
                self.fillGuardianFields(data: data, index: 2)
                
            case "guardianDocument3":
                self.fillGuardianFields(data: data, index: 3)
            default:
                print("Unknown identifier: \(identifier1)")
            }
        }
    }
    
    func didSelectDate(_ date: String, identifier: String) {
        DispatchQueue.main.async {
            switch identifier {
                
            case "nomineeDOB1":
                self.nomineeDob1.text = date
                if let age = self.calculateAge(from: date) {
                    let isMinor = age < 18
                    self.nominee1IsMinor = isMinor ? "Y" : "N"
                    self.toggleGuardianFields(for: 1, show: isMinor)
                }
                
            case "nomineeDOB2":
                self.nomineeDob2.text = date  // ✅ Fixed: was nomineeDob3
                if let age = self.calculateAge(from: date) {
                    let isMinor = age < 18
                    self.nominee2IsMinor = isMinor ? "Y" : "N"  // ✅ Fixed: was nominee3IsMinor
                    self.toggleGuardianFields(for: 2, show: isMinor)
                }
                
            case "nomineeDOB3":
                self.nomineeDob3.text = date
                if let age = self.calculateAge(from: date) {
                    let isMinor = age < 18
                    self.nominee3IsMinor = isMinor ? "Y" : "N"
                    self.toggleGuardianFields(for: 3, show: isMinor)
                }
                
            case "guardianDOB1", "guardianDOB2", "guardianDOB3":
                // Just set the text, no minor logic needed
                if identifier == "guardianDOB1" { self.guardianDobTxt1.text = date }
                else if identifier == "guardianDOB2" { self.guardianDobTxt2.text = date }
                else if identifier == "guardianDOB3" { self.guardianDobTxt3.text = date }
                
                //            case "guardianDOB1":
                //                guardianDobTxt1.text = date
                //                if let age = calculateAge(from: date) {
                //                    // toggleGuardianHolderViews(show: age < 18)
                //                    nominee1IsMinor = "Y"
                //                }
                //
                //            case "guardianDOB2":
                //                guardianDobTxt2.text = date
                //                if let age = calculateAge(from: date) {
                //                    // toggleGuardianHolderViews(show: age < 18)
                //                    nominee2IsMinor = "Y"
                //                }
                //
                //            case "guardianDOB3":
                //                guardianDobTxt3.text = date
                //                if let age = calculateAge(from: date) {
                //                    // toggleGuardianHolderViews(show: age < 18)
                //                    nominee3IsMinor = "Y"
                //                }
            default:
                break
            }
        }
    }
    
    
    //    func didSelectDate(_ date: String, identifier: String) {
    //
    //        switch identifier {
    //
    //        case "nomineeDOB1":
    //            nomineeDob1.text = date
    //            if let age = calculateAge(from: date) {
    //                toggleGuardianFields(for: 1, show: age < 18)
    //            }
    //
    //        case "nomineeDOB2":
    //            nomineeDob2.text = date
    //            if let age = calculateAge(from: date) {
    //                toggleGuardianFields(for: 2, show: age < 18)
    //            }
    //
    //        case "nomineeDOB3":
    //            nomineeDob3.text = date
    //            if let age = calculateAge(from: date) {
    //                toggleGuardianFields(for: 3, show: age < 18)
    //                nominee3IsMinor = age < 18 ? "Y" : "N"
    //            }
    //
    //        case "guardianDOB1":
    //            guardianDobTxt1.text = date
    //            if let age = calculateAge(from: date) {
    //                // toggleGuardianHolderViews(show: age < 18)
    //                nominee1IsMinor = "Y"
    //            }
    //
    //        case "guardianDOB2":
    //            guardianDobTxt2.text = date
    //            if let age = calculateAge(from: date) {
    //                // toggleGuardianHolderViews(show: age < 18)
    //                nominee2IsMinor = "Y"
    //            }
    //
    //        case "guardianDOB3":
    //            guardianDobTxt3.text = date
    //            if let age = calculateAge(from: date) {
    //                // toggleGuardianHolderViews(show: age < 18)
    //                nominee3IsMinor = "Y"
    //            }
    //
    //        default:
    //            break
    //        }
    //    }
    
    func didDismissDigiLockerVC() {
        self.dismiss(animated: true)
    }
    
    func reloadPageData() {
        self.ViewAllNomineeDetails()
    }
    
    func didSelectRelation(type: String, id: String, identifier: String) {
        
        print("🔵 [didSelectRelation] Type: \(type) | ID: \(id) | Identifier: \(identifier)")
        
        DispatchQueue.main.async {
            switch identifier {
                
                // MARK: - Nominee Relations
            case "nomineeRelation1":
                self.relationLbl1.text = type
                self.relationID1 = id
                
            case "nomineeRelation2":
                self.relationLbl2.text = type
                self.relationID2 = id
                
            case "nomineeRelation3":
                self.relationLbl3.text = type
                self.relationID3 = id
                
                // MARK: - Guardian Relations
            case "guardianRelation1":
                self.guardianLbl1.text = type
                self.guardianRelationID1 = id
                
            case "guardianRelation2":
                self.guardianLbl2.text = type
                self.guardianRelationID2 = id
                
            case "guardianRelation3":
                self.guardianLbl3.text = type
                self.guardianRelationID3 = id
                
            default:
                print("⚠️ Unknown relation identifier: \(identifier)")
            }
        }
    }
    
    func getButtonTitle(_ button: UIButton) -> String {
        if #available(iOS 15.0, *) {
            return button.configuration?.title ?? button.title(for: .normal) ?? ""
        } else {
            return button.title(for: .normal) ?? ""
        }
    }
    
    
    //@IBOutlet weak var optInBtn: UIButton!
    //@IBOutlet weak var optOutBtn: UIButton!
    @IBOutlet weak var addNomineeBtn: UIButton!
    @IBOutlet weak var nominee1Stack: UIStackView!
    @IBOutlet weak var nomineeView1: UIView!
    @IBOutlet weak var nomineeBtn1: UIButton!
    @IBOutlet weak var documentTypeLbl1: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var documentLbl1: UILabel!
    @IBOutlet weak var dobLabel1: UILabel!
    @IBOutlet weak var nomineeMobileLbl1: UILabel!
    @IBOutlet weak var nomineeEmailLbl1: UILabel!
    @IBOutlet weak var documentTypeBtn1: UIButton!
    @IBOutlet weak var documentId1: UITextField!
    @IBOutlet weak var documentVerifyBtn1: UIButton!
    @IBOutlet weak var nomineeName1: UITextField!
    @IBOutlet weak var nomineeNameTxt1: UITextField!
    @IBOutlet weak var nomineeDob1: UITextField!
    @IBOutlet weak var nomineeDobBtn1: UIButton!
    @IBOutlet weak var nomineeMobile1: UITextField!
    @IBOutlet weak var nomineeEmail1: UITextField!
    @IBOutlet weak var addressSameAsApplicantBtn1: UIButton!
    @IBOutlet weak var addressLblFirst1: UILabel!
    @IBOutlet weak var addressTxtFirst1: UITextField!
    @IBOutlet weak var addressLblSecond1: UILabel!
    @IBOutlet weak var addressTxtSecond1: UITextField!
    @IBOutlet weak var addressLblThird1: UILabel!
    @IBOutlet weak var addressTxtThird1: UITextField!
    @IBOutlet weak var pinCodeLbl1: UILabel!
    @IBOutlet weak var pinCodeTxt1: UITextField!
    @IBOutlet weak var cityLbl1: UILabel!
    @IBOutlet weak var cityTxt1: UITextField!
    @IBOutlet weak var stateLbl1: UILabel!
    @IBOutlet weak var stateTxt1: UITextField!
    @IBOutlet weak var relationApplicantLbl1: UILabel!
    @IBOutlet weak var relationBtn1: UIButton!
    @IBOutlet weak var shareLbl1: UILabel!
    @IBOutlet weak var shareTxt1: UITextField!
    @IBOutlet weak var gurdianLbl1: UILabel!
    @IBOutlet weak var guardianTypeLbl1: UILabel!
    @IBOutlet weak var guardianDocumentTypeBtn1: UIButton!
    @IBOutlet weak var guardianDocumentView1: UIView!
    @IBOutlet weak var minorNameLbl1: UILabel!
    @IBOutlet weak var minorNameTxt1: UITextField!
    @IBOutlet weak var guardianDobLbl1: UILabel!
    //@IBOutlet weak var guardianNameTxt1: UITextField!
    @IBOutlet weak var guardianDobBtn1: UIButton!
    @IBOutlet weak var guardianDobTxt1: UITextField!
    @IBOutlet weak var guardianIDLbl1: UILabel!
    @IBOutlet weak var guardianIdTxt1: UITextField!
    @IBOutlet weak var guardianVerifyBtn1: UIButton!
    @IBOutlet weak var guardianMobileLbl1: UILabel!
    @IBOutlet weak var guardianMobileTxt1: UITextField!
    @IBOutlet weak var guardianEmailLbl1: UILabel!
    @IBOutlet weak var guardianEmailTxt1: UITextField!
    @IBOutlet weak var guardianRelationLbl1: UILabel!
    @IBOutlet weak var guardianRelationBtn1: UIButton!
    @IBOutlet weak var nomineeSameAsBtn1: UIButton!
    @IBOutlet weak var guardianAddressLblFirst1: UILabel!
    @IBOutlet weak var guardianAddressTxtFirst1: UITextField!
    @IBOutlet weak var guardianAddressLblSecond1: UILabel!
    @IBOutlet weak var guardianAddressTxtSecond1: UITextField!
    @IBOutlet weak var guardianAddressLblThird1: UILabel!
    @IBOutlet weak var guardianAddressTxtThird1: UITextField!
    @IBOutlet weak var guardianPinCodeLbl1: UILabel!
    @IBOutlet weak var guardianPinCodeTxt1: UITextField!
    @IBOutlet weak var guardianCityLbl1: UILabel!
    @IBOutlet weak var guardianCityTxt1: UITextField!
    @IBOutlet weak var guardianStateLbl1: UILabel!
    @IBOutlet weak var guardianStateTxt1: UITextField!
    @IBOutlet weak var relationLbl1: UILabel!
    @IBOutlet weak var guardianLbl1: UILabel!
    
    @IBOutlet weak var nominee2Stack: UIStackView!
    @IBOutlet weak var nomineeView2: UIView!
    @IBOutlet weak var nomineeBtn2: UIButton!
    @IBOutlet weak var documentTypeLbl2: UILabel!
    @IBOutlet weak var documentTypeBtn2: UIButton!
    @IBOutlet weak var documentId2: UITextField!
    @IBOutlet weak var documentVerifyBtn2: UIButton!
    @IBOutlet weak var nomineeName2: UITextField!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var documentLbl2: UILabel!
    @IBOutlet weak var dobLabel2: UILabel!
    @IBOutlet weak var nomineeMobileLbl2: UILabel!
    @IBOutlet weak var nomineeEmailLbl2: UILabel!
    @IBOutlet weak var nomineeNameTxt2: UITextField!
    @IBOutlet weak var nomineeDob2: UITextField!
    @IBOutlet weak var nomineeDobBtn2: UIButton!
    @IBOutlet weak var nomineeMobile2: UITextField!
    @IBOutlet weak var nomineeEmail2: UITextField!
    @IBOutlet weak var addressSameAsApplicantBtn2: UIButton!
    @IBOutlet weak var addressLblFirst2: UILabel!
    @IBOutlet weak var addressTxtFirst2: UITextField!
    @IBOutlet weak var addressLblSecond2: UILabel!
    @IBOutlet weak var addressTxtSecond2: UITextField!
    @IBOutlet weak var addressLblThird2: UILabel!
    @IBOutlet weak var addressTxtThird2: UITextField!
    @IBOutlet weak var pinCodeLbl2: UILabel!
    @IBOutlet weak var pinCodeTxt2: UITextField!
    @IBOutlet weak var cityLbl2: UILabel!
    @IBOutlet weak var cityTxt2: UITextField!
    @IBOutlet weak var stateLbl2: UILabel!
    @IBOutlet weak var stateTxt2: UITextField!
    @IBOutlet weak var relationApplicantLbl2: UILabel!
    @IBOutlet weak var relationBtn2: UIButton!
    @IBOutlet weak var shareLbl2: UILabel!
    @IBOutlet weak var shareTxt2: UITextField!
    @IBOutlet weak var gurdianLbl2: UILabel!
    @IBOutlet weak var guardianTypeLbl2: UILabel!
    @IBOutlet weak var guardianDocumentTypeBtn2: UIButton!
    @IBOutlet weak var guardianDocumentView2: UIView!
    @IBOutlet weak var minorNameLbl2: UILabel!
    @IBOutlet weak var minorNameTxt2: UITextField!
    @IBOutlet weak var guardianDobLbl2: UILabel!
    //@IBOutlet weak var guardianNameTxt2: UITextField!
    @IBOutlet weak var guardianDobBtn2: UIButton!
    @IBOutlet weak var guardianDobTxt2: UITextField!
    @IBOutlet weak var guardianIDLbl2: UILabel!
    @IBOutlet weak var guardianIdTxt2: UITextField!
    @IBOutlet weak var guardianVerifyBtn2: UIButton!
    @IBOutlet weak var guardianMobileLbl2: UILabel!
    @IBOutlet weak var guardianMobileTxt2: UITextField!
    @IBOutlet weak var guardianEmailLbl2: UILabel!
    @IBOutlet weak var guardianEmailTxt2: UITextField!
    @IBOutlet weak var guardianRelationLbl2: UILabel!
    @IBOutlet weak var guardianRelationBtn2: UIButton!
    @IBOutlet weak var nomineeSameAsBtn2: UIButton!
    @IBOutlet weak var guardianAddressLblFirst2: UILabel!
    @IBOutlet weak var guardianAddressTxtFirst2: UITextField!
    @IBOutlet weak var guardianAddressLblSecond2: UILabel!
    @IBOutlet weak var guardianAddressTxtSecond2: UITextField!
    @IBOutlet weak var guardianAddressLblThird2: UILabel!
    @IBOutlet weak var guardianAddressTxtThird2: UITextField!
    @IBOutlet weak var guardianPinCodeLbl2: UILabel!
    @IBOutlet weak var guardianPinCodeTxt2: UITextField!
    @IBOutlet weak var guardianCityLbl2: UILabel!
    @IBOutlet weak var guardianCityTxt2: UITextField!
    @IBOutlet weak var guardianStateLbl2: UILabel!
    @IBOutlet weak var guardianStateTxt2: UITextField!
    @IBOutlet weak var relationLbl2: UILabel!
    @IBOutlet weak var guardianLbl2: UILabel!
    
    @IBOutlet weak var nominee3Stack: UIStackView!
    @IBOutlet weak var nomineeView3: UIView!
    @IBOutlet weak var nomineeBtn3: UIButton!
    @IBOutlet weak var documentTypeLbl3: UILabel!
    @IBOutlet weak var documentTypeBtn3: UIButton!
    @IBOutlet weak var documentId3: UITextField!
    @IBOutlet weak var documentVerifyBtn3: UIButton!
    @IBOutlet weak var nomineeName3: UILabel!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var documentLbl3: UILabel!
    @IBOutlet weak var dobLabel3: UILabel!
    @IBOutlet weak var nomineeMobileLbl3: UILabel!
    @IBOutlet weak var nomineeEmailLbl3: UILabel!
    @IBOutlet weak var nomineeNameTxt3: UITextField!
    @IBOutlet weak var nomineeDob3: UITextField!
    @IBOutlet weak var nomineeDobBtn3: UIButton!
    @IBOutlet weak var nomineeMobile3: UITextField!
    @IBOutlet weak var nomineeEmail3: UITextField!
    @IBOutlet weak var guardianRelationLbl3: UILabel!
    @IBOutlet weak var guardianRelationBtn3: UIButton!
    @IBOutlet weak var addressSameAsApplicantBtn3: UIButton!
    @IBOutlet weak var addressLblFirst3: UILabel!
    @IBOutlet weak var addressTxtFirst3: UITextField!
    @IBOutlet weak var addressLblSecond3: UILabel!
    @IBOutlet weak var addressTxtSecond3: UITextField!
    @IBOutlet weak var addressLblThird3: UILabel!
    @IBOutlet weak var addressTxtThird3: UITextField!
    @IBOutlet weak var pinCodeLbl3: UILabel!
    @IBOutlet weak var pinCodeTxt3: UITextField!
    @IBOutlet weak var cityLbl3: UILabel!
    @IBOutlet weak var cityTxt3: UITextField!
    @IBOutlet weak var stateLbl3: UILabel!
    @IBOutlet weak var stateTxt3: UITextField!
    @IBOutlet weak var relationApplicantLbl3: UILabel!
    @IBOutlet weak var relationBtn3: UIButton!
    @IBOutlet weak var shareLbl3: UILabel!
    @IBOutlet weak var shareTxt3: UITextField!
    @IBOutlet weak var gurdianLbl3: UILabel!
    @IBOutlet weak var guardianTypeLbl3: UILabel!
    @IBOutlet weak var guardianDocumentTypeBtn3: UIButton!
    @IBOutlet weak var guardianDocumentView3: UIView!
    @IBOutlet weak var minorNameLbl3: UILabel!
    @IBOutlet weak var minorNameTxt3: UITextField!
    @IBOutlet weak var guardianDobLbl3: UILabel!
    //@IBOutlet weak var guardianNameTxt3: UITextField!
    @IBOutlet weak var guardianDobBtn3: UIButton!
    @IBOutlet weak var guardianDobTxt3: UITextField!
    @IBOutlet weak var guardianIDLbl3: UILabel!
    @IBOutlet weak var guardianIdTxt3: UITextField!
    @IBOutlet weak var guardianVerifyBtn3: UIButton!
    @IBOutlet weak var guardianMobileLbl3: UILabel!
    @IBOutlet weak var guardianMobileTxt3: UITextField!
    @IBOutlet weak var guardianEmailLbl3: UILabel!
    @IBOutlet weak var guardianEmailTxt3: UITextField!
    @IBOutlet weak var nomineeSameAsBtn3: UIButton!
    @IBOutlet weak var guardianAddressLblFirst3: UILabel!
    @IBOutlet weak var guardianAddressTxtFirst3: UITextField!
    @IBOutlet weak var guardianAddressLblSecond3: UILabel!
    @IBOutlet weak var guardianAddressTxtSecond3: UITextField!
    @IBOutlet weak var guardianAddressLblThird3: UILabel!
    @IBOutlet weak var guardianAddressTxtThird3: UITextField!
    @IBOutlet weak var guardianPinCodeLbl3: UILabel!
    @IBOutlet weak var guardianPinCodeTxt3: UITextField!
    @IBOutlet weak var guardianCityLbl3: UILabel!
    @IBOutlet weak var guardianCityTxt3: UITextField!
    @IBOutlet weak var guardianStateLbl3: UILabel!
    @IBOutlet weak var guardianStateTxt3: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var relationLbl3: UILabel!
    @IBOutlet weak var guardianLbl3: UILabel!
    @IBOutlet weak var skipBtn: UIButton!
    
    var nomineeCount = 0
    var nominee1Fields: [UIView] = []
    var nominee2Fields: [UIView] = []
    var nominee3Fields: [UIView] = []
    var isNominee1Expanded = false
    var isNominee2Expanded = false
    var isNominee3Expanded = false
    var NomineeType: String = "N"
    var nomineedocumentType1 : String?
    var nomineedocumentType2 : String?
    var nomineedocumentType3 : String?
    var guardiandocumentType1 : String?
    var guardiandocumentType2 : String?
    var guardiandocumentType3 : String?
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var mobiledecodeArray: String?
    var identifier: String = ""
    var RegId: String?
    var panNo: String?
    var isNomineeVerified = false
    var NomineeMinor : String?
    var regId: String?
    var PANName: String?
    var EmailId: String?
    var digiIdentifier: String?
    var relationID1:String?
    var relationID2:String?
    var relationID3:String?
    var guardianRelationID1: String?
    var guardianRelationID2: String?
    var guardianRelationID3: String?
    var nomineeDetailsArray: [[String: Any]] = []
    var nominee1Allocation: String = ""
    var nominee2Allocation: String = ""
    var nominee3Allocation: String = ""
    var nomineeAddressViews1: [UIView] = []
    var guardianAddressViews1: [UIView] = []
    var nomineeAddressViews2: [UIView] = []
    var guardianAddressViews2: [UIView] = []
    var nomineeAddressViews3: [UIView] = []
    var guardianAddressViews3: [UIView] = []
    var nominee1IsMinor: String = "N"
    var nominee2IsMinor: String = "N"
    var nominee3IsMinor: String = "N"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        //addNomineeBtn.isHidden = true
        
        nominee1Stack.isHidden = true
        nominee2Stack.isHidden = true
        nominee3Stack.isHidden = true
        
        nominee1Fields.forEach { $0.isHidden = true }
        nominee2Fields.forEach { $0.isHidden = true }
        nominee3Fields.forEach { $0.isHidden = true }
        
        nominee1Stack.layer.cornerRadius = 10
        nominee1Stack.layer.borderWidth = 1
        nominee1Stack.layer.borderColor = UIColor.lightGray.cgColor
        
        nominee2Stack.layer.cornerRadius = 10
        nominee2Stack.layer.borderWidth = 1
        nominee2Stack.layer.borderColor = UIColor.lightGray.cgColor
        
        nominee3Stack.layer.cornerRadius = 10
        nominee3Stack.layer.borderWidth = 1
        nominee3Stack.layer.borderColor = UIColor.lightGray.cgColor
        
        nomineeFieldsHide()
        
        nominee1Stack.isLayoutMarginsRelativeArrangement = true
        nominee1Stack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        
        nominee2Stack.isLayoutMarginsRelativeArrangement = true
        nominee2Stack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        
        nominee3Stack.isLayoutMarginsRelativeArrangement = true
        nominee3Stack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        
        toggleGuardianFields(for: 1, show: false)
        toggleGuardianFields(for: 2, show: false)
        toggleGuardianFields(for: 3, show: false)
        
        submitBtn.backgroundColor = .appPrimary
        //optInBtn.tintColor = .appPrimary
        //optOutBtn.tintColor = .appPrimary
        addNomineeBtn.tintColor = .appPrimary
        
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.fetchedUserId = userId
                self.fetchedSessionID = sessionID
                self.mobiledecodeArray = decodeByteArrayString
                print("UserID: \(userId), SessionID: \(sessionID)")
                self.ViewAllNomineeDetails()
            } else {
                print("No UserID or SessionID found.")
            }
        }
        relationLbl1.isHidden = false
        relationLbl1.text = "Select Relation"
        
        pinCodeTxt1.delegate = self
        pinCodeTxt2.delegate = self
        pinCodeTxt3.delegate = self
        guardianPinCodeTxt1.delegate = self
        guardianPinCodeTxt2.delegate = self
        guardianPinCodeTxt3.delegate = self
        
        view.backgroundColor = .appBackground
        
        view1.layer.cornerRadius = 10
        view1.layer.borderWidth = 1
        view1.layer.borderColor = UIColor.appBorder.cgColor
        
        view2.layer.cornerRadius = 10
        view2.layer.borderWidth = 1
        view2.layer.borderColor = UIColor.appBorder.cgColor
        
        view3.layer.cornerRadius = 10
        view3.layer.borderWidth = 1
        view3.layer.borderColor = UIColor.appBorder.cgColor
        
        guardianDocumentView1.layer.cornerRadius = 10
        guardianDocumentView1.layer.borderWidth = 1
        guardianDocumentView1.layer.borderColor =  UIColor.appBorder.cgColor
        
        guardianDocumentView2.layer.cornerRadius = 10
        guardianDocumentView2.layer.borderWidth = 1
        guardianDocumentView2.layer.borderColor =  UIColor.appBorder.cgColor
        
        guardianDocumentView3.layer.cornerRadius = 10
        guardianDocumentView3.layer.borderWidth = 1
        guardianDocumentView3.layer.borderColor =  UIColor.appBorder.cgColor
        
        textFieldsCapital()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check if user has already submitted nominees
        if let isSubmitted = UserDefaults.standard.value(forKey: "NomineesSubmitted_\(panNo ?? "")") as? Bool, isSubmitted == true {
            // Disable all controls if already submitted
            //disableAllControlsAfterSubmission()
            return
        }
        
        // Only fetch nominee details if user has opted in
        //if optInBtn.isSelected {
        ViewAllNomineeDetails()
        //}
    }
    
    func formatDateForAPI(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        if let date = dateFormatter.date(from: dateString) {
            return dateFormatter.string(from: date) // same format
        }
        return dateString
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "OtherDetails", bundle: Bundle.module)
        let vc = storyboard.instantiateViewController(identifier: "OtherDetailsVC") as! OtherDetailsVC
        let savedPAN = UserDefaults.standard.string(forKey: "PanNo")
        let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.panNo
        
        let regId = UserDefaults.standard.string(forKey: "RegId")
        let regIdFinal = (regId?.isEmpty == false) ? regId : self.regId
        vc.panNo = finalPAN
        vc.regId = regIdFinal
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func nomineeFieldsHide() {
        nomineeAddressViews1 = [
            addressLblFirst1, addressTxtFirst1,
            addressLblSecond1, addressTxtSecond1,
            addressLblThird1, addressTxtThird1,
            pinCodeLbl1, pinCodeTxt1,
            cityLbl1, cityTxt1,
            stateLbl1, stateTxt1
        ]
        
        guardianAddressViews1 = [
            guardianAddressLblFirst1, guardianAddressTxtFirst1,
            guardianAddressLblSecond1, guardianAddressTxtSecond1,
            guardianAddressLblThird1, guardianAddressTxtThird1,
            guardianPinCodeLbl1, guardianPinCodeTxt1,
            guardianCityLbl1, guardianCityTxt1,
            guardianStateLbl1, guardianStateTxt1
        ]
        
        nomineeAddressViews2 = [
            addressLblFirst2, addressTxtFirst2,
            addressLblSecond2, addressTxtSecond2,
            addressLblThird2, addressTxtThird2,
            pinCodeLbl2, pinCodeTxt2,
            cityLbl2, cityTxt2,
            stateLbl2, stateTxt2
        ]
        
        guardianAddressViews2 = [
            guardianAddressLblFirst2, guardianAddressTxtFirst2,
            guardianAddressLblSecond2, guardianAddressTxtSecond2,
            guardianAddressLblThird2, guardianAddressTxtThird2,
            guardianPinCodeLbl2, guardianPinCodeTxt2,
            guardianCityLbl2, guardianCityTxt2,
            guardianStateLbl2, guardianStateTxt2
        ]
        
        nomineeAddressViews3 = [
            addressLblFirst3, addressTxtFirst3,
            addressLblSecond3, addressTxtSecond3,
            addressLblThird3, addressTxtThird3,
            pinCodeLbl3, pinCodeTxt3,
            cityLbl3, cityTxt3,
            stateLbl3, stateTxt3
        ]
        
        guardianAddressViews3 = [
            guardianAddressLblFirst3, guardianAddressTxtFirst3,
            guardianAddressLblSecond3, guardianAddressTxtSecond3,
            guardianAddressLblThird3, guardianAddressTxtThird3,
            guardianPinCodeLbl3, guardianPinCodeTxt3,
            guardianCityLbl3, guardianCityTxt3,
            guardianStateLbl3, guardianStateTxt3
        ]
    }
    
    func hideNomineeAddress1(_ hide: Bool) {
        nomineeAddressViews1.forEach { $0.isHidden = hide }
    }
    
    func hideGuardianAddress1(_ hide: Bool) {
        guardianAddressViews1.forEach { $0.isHidden = hide }
    }
    
    func hideNomineeAddress2(_ hide: Bool) {
        nomineeAddressViews2.forEach { $0.isHidden = hide }
    }
    
    func hideGuardianAddress2(_ hide: Bool) {
        guardianAddressViews2.forEach { $0.isHidden = hide }
    }
    
    func hideNomineeAddress3(_ hide: Bool) {
        nomineeAddressViews3.forEach { $0.isHidden = hide }
    }
    
    func hideGuardianAddress3(_ hide: Bool) {
        guardianAddressViews3.forEach { $0.isHidden = hide }
    }
    
    
    @IBAction func addNomineeBtnTApped(_ sender: UIButton) {
        guard nomineeCount < 3 else { return }
        NomineeType = "Y" 
        nomineeCount += 1
        
        if nomineeCount == 1 {
            nominee1Stack.isHidden = false
        } else if nomineeCount == 2 {
            nominee2Stack.isHidden = false
        } else if nomineeCount == 3 {
            nominee3Stack.isHidden = false
            addNomineeBtn.isHidden = true // hide after 3
        }
    }
    
    //    @IBAction func optInTapped(_ sender: UIButton) {
    //        optInBtn.isSelected = true
    //        optOutBtn.isSelected = false
    //        NomineeType = "Y"
    //        addNomineeBtn.isHidden = false
    //    }
    
    //    @IBAction func optOutTapped(_ sender: UIButton) {
    //        optInBtn.isSelected = false
    //        optOutBtn.isSelected = true
    //        NomineeType = "N"
    //        addNomineeBtn.isHidden = true
    //
    //        // Hide all nominee stacks
    //        nominee1Stack.isHidden = true
    //        nominee2Stack.isHidden = true
    //        nominee3Stack.isHidden = true
    //
    //        nomineeCount = 0
    //        submitBtn.isEnabled = true
    //        submitBtn.alpha = 1.0
    //        let storyboard = UIStoryboard(name: "Document", bundle: Bundle.module )
    //        if let nextVC = storyboard.instantiateViewController(withIdentifier: "DocumentVC") as? DocumentVC {
    //            nextVC.PanNo = self.panNo
    //            nextVC.RegId = self.RegId
    //            nextVC.delegate = self
    //            self.navigationController?.pushViewController(nextVC, animated: true)
    //        }
    //
    //    }
    
    
    @IBAction func Nominee1Btn(_ sender: UIButton) {
        isNominee1Expanded.toggle()
        
        let imageName = isNominee1Expanded ? "chevron.up" : "chevron.down"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        
        // Hide/show all arranged subviews except the first one (the header button)
        for (index, view) in nominee1Stack.arrangedSubviews.enumerated() {
            if index != 0 { // Skip the header button
                view.isHidden = !isNominee1Expanded
            }
        }
    }
    
    @IBAction func Nominee2Btn(_ sender: UIButton) {
        isNominee2Expanded.toggle()
        let imageName = isNominee2Expanded ? "chevron.up" : "chevron.down"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        // Hide/show all arranged subviews except the first one (the header button)
        for (index, view) in nominee2Stack.arrangedSubviews.enumerated() {
            if index != 0 { // Skip the header button
                view.isHidden = !isNominee2Expanded
            }
        }
    }
    
    @IBAction func Nominee3Btn(_ sender: UIButton) {
        isNominee3Expanded.toggle()
        let imageName = isNominee3Expanded ? "chevron.up" : "chevron.down"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        // Hide/show all arranged subviews except the first one (the header button)
        for (index, view) in nominee3Stack.arrangedSubviews.enumerated() {
            if index != 0 { // Skip the header button
                view.isHidden = !isNominee3Expanded
            }
        }
    }
    
    private func fillNomineeFields(data: [String: Any], index: Int) {
        
        let name = data["NameAsPerAadhaar"] as? String ?? ""
        let dob = data["DOB"] as? String ?? ""
        let uid = data["Uid"] as? String ?? ""
        let gender = data["Gender"] as? String ?? ""
        let fatherName = data["FatherSpouseName"] as? String ?? ""
        
        let address1 = data["Address1"] as? String ?? ""
        let address2 = data["Address2"] as? String ?? ""
        let address3 = data["Address3"] as? String ?? ""
        let city = data["City"] as? String ?? ""
        let state = data["State"] as? String ?? ""
        let pincode = data["PinCode"] as? String ?? ""
        
        // Optional fields if available
        let mobile = data["Mobile"] as? String ?? ""
        let email = data["Email"] as? String ?? ""
        
        switch index {
        case 1:
            // Nominee fields
            nomineeNameTxt1.text = name
            nomineeDob1.text = dob
            documentId1.text = uid
            nomineeMobile1.text = mobile
            nomineeEmail1.text = email
            
            // Only auto-fill address fields if document type is Aadhaar
            if nomineedocumentType1 == "Aadhaar" {
                addressTxtFirst1.text = address1
                addressTxtSecond1.text = address2
                addressTxtThird1.text = address3
                cityTxt1.text = city
                stateTxt1.text = state
                pinCodeTxt1.text = pincode
            }
            
            // Set document type
            documentTypeBtn1.setTitle("Aadhaar", for: .normal)
            nomineedocumentType1 = "Aadhaar"
            
            documentVerifyBtn1.isEnabled = false
            documentVerifyBtn1.alpha = 0.5
            
            // Only disable address fields if document type is Aadhaar
            nomineeNameTxt1.isEnabled = false
            nomineeDob1.isEnabled = false
            documentId1.isEnabled = false
            documentTypeBtn1.isEnabled = false
            
            if nomineedocumentType1 == "Aadhaar" {
                addressTxtFirst1.isEnabled = false
                addressTxtSecond1.isEnabled = false
                addressTxtThird1.isEnabled = false
                pinCodeTxt1.isEnabled = false
                cityTxt1.isEnabled = false
                stateTxt1.isEnabled = false
            }
            
        case 2:
            // Nominee fields
            nomineeNameTxt2.text = name
            nomineeDob2.text = dob
            documentId2.text = uid
            nomineeMobile2.text = mobile
            nomineeEmail2.text = email
            
            // Only auto-fill address fields if document type is Aadhaar
            if nomineedocumentType2 == "Aadhaar" {
                addressTxtFirst2.text = address1
                addressTxtSecond2.text = address2
                addressTxtThird2.text = address3
                cityTxt2.text = city
                stateTxt2.text = state
                pinCodeTxt2.text = pincode
            }
            
            // Set document type
            documentTypeBtn2.setTitle("Aadhaar", for: .normal)
            nomineedocumentType2 = "Aadhaar"
            
            // Only disable address fields if document type is Aadhaar
            nomineeNameTxt2.isEnabled = false
            nomineeDob2.isEnabled = false
            documentId2.isEnabled = false
            documentTypeBtn2.isEnabled = false
            
            if nomineedocumentType2 == "Aadhaar" {
                addressTxtFirst2.isEnabled = false
                addressTxtSecond2.isEnabled = false
                addressTxtThird2.isEnabled = false
                pinCodeTxt2.isEnabled = false
                cityTxt2.isEnabled = false
                stateTxt2.isEnabled = false
            }
        case 3:
            // Nominee fields
            nomineeNameTxt3.text = name
            nomineeDob3.text = dob
            documentId3.text = uid
            nomineeMobile3.text = mobile
            nomineeEmail3.text = email
            
            // Only auto-fill address fields if document type is Aadhaar
            if nomineedocumentType3 == "Aadhaar" {
                addressTxtFirst3.text = address1
                addressTxtSecond3.text = address2
                addressTxtThird3.text = address3
                cityTxt3.text = city
                stateTxt3.text = state
                pinCodeTxt3.text = pincode
            }
            
            // Set document type
            documentTypeBtn3.setTitle("Aadhaar", for: .normal)
            nomineedocumentType3 = "Aadhaar"
            
            // Only disable address fields if document type is Aadhaar
            nomineeNameTxt3.isEnabled = false
            nomineeDob3.isEnabled = false
            documentId3.isEnabled = false
            documentTypeBtn3.isEnabled = false
            
            if nomineedocumentType3 == "Aadhaar" {
                addressTxtFirst3.isEnabled = false
                addressTxtSecond3.isEnabled = false
                addressTxtThird3.isEnabled = false
                pinCodeTxt3.isEnabled = false
                cityTxt3.isEnabled = false
                stateTxt3.isEnabled = false
            }
            
        default:
            return
        }
        
        // Age check and guardian visibility
        if let age = calculateAge(from: dob) {
            toggleGuardianFields(for: index, show: age < 18)
        }
        
        // Validate pincode to fetch city/state if needed
        validatePinCode(pinCode: pincode, for: "nominee", index: index)
        
        print("✅ Successfully auto-filled Nominee \(index)")
    }
    
    func calculateAge(from dob: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        guard let dateOfBirth = dateFormatter.date(from: dob) else {
            return nil
        }
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: Date())
        return ageComponents.year
    }
    
    func toggleGuardianFields(for nomineeIndex: Int, show: Bool) {
        switch nomineeIndex {
        case 1:
            gurdianLbl1?.isHidden = !show
            guardianTypeLbl1?.isHidden = !show
            guardianDocumentTypeBtn1?.isHidden = !show
            guardianDocumentView1?.isHidden = !show
            minorNameLbl1?.isHidden = !show
            minorNameTxt1?.isHidden = !show
            //guardianNameTxt1?.isHidden = !show
            guardianDobLbl1?.isHidden = !show
            guardianDobBtn1?.isHidden = !show
            guardianDobTxt1?.isHidden = !show
            guardianIDLbl1?.isHidden = !show
            guardianIdTxt1?.isHidden = !show
            guardianVerifyBtn1?.isHidden = !show
            guardianMobileLbl1?.isHidden = !show
            guardianMobileTxt1?.isHidden = !show
            guardianEmailLbl1?.isHidden = !show
            guardianEmailTxt1?.isHidden = !show
            nomineeSameAsBtn1?.isHidden = !show
            guardianAddressLblFirst1?.isHidden = !show
            guardianAddressTxtFirst1?.isHidden = !show
            guardianAddressLblSecond1?.isHidden = !show
            guardianAddressTxtSecond1?.isHidden = !show
            guardianAddressLblThird1?.isHidden = !show
            guardianAddressTxtThird1?.isHidden = !show
            guardianPinCodeLbl1?.isHidden = !show
            guardianPinCodeTxt1?.isHidden = !show
            guardianCityLbl1?.isHidden = !show
            guardianCityTxt1?.isHidden = !show
            guardianStateLbl1?.isHidden = !show
            guardianStateTxt1?.isHidden = !show
            guardianRelationLbl1?.isHidden = !show
            guardianRelationBtn1?.isHidden = !show
            guardianLbl1?.isHidden = !show
            
        case 2:
            gurdianLbl2?.isHidden = !show
            guardianTypeLbl2?.isHidden = !show
            guardianDocumentTypeBtn2?.isHidden = !show
            guardianDocumentView2?.isHidden = !show
            minorNameLbl2?.isHidden = !show
            minorNameTxt2?.isHidden = !show
            // guardianNameTxt2?.isHidden = !show
            guardianDobLbl2?.isHidden = !show
            guardianDobBtn2?.isHidden = !show
            guardianDobTxt2?.isHidden = !show
            guardianIDLbl2?.isHidden = !show
            guardianIdTxt2?.isHidden = !show
            guardianVerifyBtn2?.isHidden = !show
            guardianMobileLbl2?.isHidden = !show
            guardianMobileTxt2?.isHidden = !show
            guardianEmailLbl2?.isHidden = !show
            guardianEmailTxt2?.isHidden = !show
            nomineeSameAsBtn2?.isHidden = !show
            guardianAddressLblFirst2?.isHidden = !show
            guardianAddressTxtFirst2?.isHidden = !show
            guardianAddressLblSecond2?.isHidden = !show
            guardianAddressTxtSecond2?.isHidden = !show
            guardianAddressLblThird2?.isHidden = !show
            guardianAddressTxtThird2?.isHidden = !show
            guardianPinCodeLbl2?.isHidden = !show
            guardianPinCodeTxt2?.isHidden = !show
            guardianCityLbl2?.isHidden = !show
            guardianCityTxt2?.isHidden = !show
            guardianStateLbl2?.isHidden = !show
            guardianStateTxt2?.isHidden = !show
            guardianRelationLbl2?.isHidden = !show
            guardianRelationBtn2?.isHidden = !show
            guardianLbl2?.isHidden = !show
            
        case 3:
            gurdianLbl3?.isHidden = !show
            guardianTypeLbl3?.isHidden = !show
            guardianDocumentTypeBtn3?.isHidden = !show
            guardianDocumentView3?.isHidden = !show
            minorNameLbl3?.isHidden = !show
            minorNameTxt3?.isHidden = !show
            // guardianNameTxt3?.isHidden = !show
            guardianDobLbl3?.isHidden = !show
            guardianDobBtn3?.isHidden = !show
            guardianDobTxt3?.isHidden = !show
            guardianIDLbl3?.isHidden = !show
            guardianIdTxt3?.isHidden = !show
            guardianVerifyBtn3?.isHidden = !show
            guardianMobileLbl3?.isHidden = !show
            guardianMobileTxt3?.isHidden = !show
            guardianEmailLbl3?.isHidden = !show
            guardianEmailTxt3?.isHidden = !show
            nomineeSameAsBtn3?.isHidden = !show
            guardianAddressLblFirst3?.isHidden = !show
            guardianAddressTxtFirst3?.isHidden = !show
            guardianAddressLblSecond3?.isHidden = !show
            guardianAddressTxtSecond3?.isHidden = !show
            guardianAddressLblThird3?.isHidden = !show
            guardianAddressTxtThird3?.isHidden = !show
            guardianPinCodeLbl3?.isHidden = !show
            guardianPinCodeTxt3?.isHidden = !show
            guardianCityLbl3?.isHidden = !show
            guardianCityTxt3?.isHidden = !show
            guardianStateLbl3?.isHidden = !show
            guardianStateTxt3?.isHidden = !show
            guardianRelationLbl3?.isHidden = !show
            guardianRelationBtn3?.isHidden = !show
            guardianLbl3?.isHidden = !show
            
        default:
            break
        }
    }
    
    private func fillGuardianFields(data: [String: Any], index: Int) {
        DispatchQueue.main.async {
            print("🔧 Filling Guardian \(index) with DigiLocker data")
            
            let name = data["NameAsPerAadhaar"] as? String ?? ""
            let dob = data["DOB"] as? String ?? ""
            let uid = data["Uid"] as? String ?? ""
            
            let address1 = data["Address1"] as? String ?? ""
            let address2 = data["Address2"] as? String ?? ""
            let address3 = data["Address3"] as? String ?? ""
            let city = data["City"] as? String ?? ""
            let state = data["State"] as? String ?? ""
            let pincode = data["PinCode"] as? String ?? ""
            
            switch index {
            case 1:
                self.minorNameTxt1.text = name
                self.guardianDobTxt1.text = dob
                self.guardianIdTxt1.text = uid
                
                self.guardianAddressTxtFirst1.text = address1
                self.guardianAddressTxtSecond1.text = address2
                self.guardianAddressTxtThird1.text = address3
                self.guardianCityTxt1.text = city
                self.guardianStateTxt1.text = state
                self.guardianPinCodeTxt1.text = pincode
                
                self.guardianDocumentTypeBtn1.setTitle("Aadhaar", for: .normal)
                self.guardiandocumentType1 = "Aadhaar"
                
                self.guardianVerifyBtn1.isEnabled = false
                self.guardianVerifyBtn1.alpha = 0.5
                
            case 2:
                self.minorNameTxt2.text = name
                self.guardianDobTxt2.text = dob
                self.guardianIdTxt2.text = uid
                
                self.guardianAddressTxtFirst2.text = address1
                self.guardianAddressTxtSecond2.text = address2
                self.guardianAddressTxtThird2.text = address3
                self.guardianCityTxt2.text = city
                self.guardianStateTxt2.text = state
                self.guardianPinCodeTxt2.text = pincode
                
                self.guardianDocumentTypeBtn2.setTitle("Aadhaar", for: .normal)
                self.guardiandocumentType2 = "Aadhaar"
                
                self.guardianVerifyBtn2.isEnabled = false
                self.guardianVerifyBtn2.alpha = 0.5
                
            case 3:
                self.minorNameTxt3.text = name
                self.guardianDobTxt3.text = dob
                self.guardianIdTxt3.text = uid
                
                self.guardianAddressTxtFirst3.text = address1
                self.guardianAddressTxtSecond3.text = address2
                self.guardianAddressTxtThird3.text = address3
                self.guardianCityTxt3.text = city
                self.guardianStateTxt3.text = state
                self.guardianPinCodeTxt3.text = pincode
                
                self.guardianDocumentTypeBtn3.setTitle("Aadhaar", for: .normal)
                self.guardiandocumentType3 = "Aadhaar"
                
                self.guardianVerifyBtn3.isEnabled = false
                self.guardianVerifyBtn3.alpha = 0.5
                
            default:
                return
            }
            
            print("✅ Successfully auto-filled Guardian \(index)")
        }
    }
    
    func populateNomineeFieldsArrays() {
        // Nominee 1 Fields
        nominee1Fields = [
            documentTypeLbl1, documentTypeBtn1, documentId1, documentVerifyBtn1,
            nomineeNameTxt1, nomineeDob1, nomineeDobBtn1, nomineeMobile1, nomineeEmail1,
            addressSameAsApplicantBtn1, addressLblFirst1, addressTxtFirst1,
            addressLblSecond1, addressTxtSecond1, addressLblThird1, addressTxtThird1,
            pinCodeLbl1, pinCodeTxt1, cityLbl1, cityTxt1, stateLbl1, stateTxt1,
            relationApplicantLbl1, shareLbl1, shareTxt1,
            gurdianLbl1, guardianTypeLbl1, guardianDocumentTypeBtn1,  guardianDocumentView1,
            minorNameLbl1, minorNameTxt1,
            guardianDobLbl1, guardianDobBtn1, guardianDobTxt1,
            guardianIDLbl1, guardianIdTxt1, guardianVerifyBtn1,
            guardianMobileLbl1, guardianMobileTxt1,
            guardianEmailLbl1, guardianEmailTxt1,
            guardianRelationLbl1, guardianRelationBtn1,guardianLbl1,
            nomineeSameAsBtn1,
            guardianAddressLblFirst1, guardianAddressTxtFirst1,
            guardianAddressLblSecond1, guardianAddressTxtSecond1,
            guardianAddressLblThird1, guardianAddressTxtThird1,
            guardianPinCodeLbl1, guardianPinCodeTxt1,
            guardianCityLbl1, guardianCityTxt1,
            guardianStateLbl1, guardianStateTxt1, relationLbl1
        ]
        
        nominee2Fields = [
            documentTypeLbl2, documentTypeBtn2, documentId2, documentVerifyBtn2,
            nomineeNameTxt2, nomineeDob2, nomineeDobBtn2, nomineeMobile2, nomineeEmail2,
            addressSameAsApplicantBtn2, addressLblFirst2, addressTxtFirst2,
            addressLblSecond2, addressTxtSecond2, addressLblThird2, addressTxtThird2,
            pinCodeLbl2, pinCodeTxt2, cityLbl2, cityTxt2, stateLbl2, stateTxt2,
            relationApplicantLbl2, relationBtn2, shareLbl2, shareTxt2,
            gurdianLbl2, guardianTypeLbl2, guardianDocumentTypeBtn2,  guardianDocumentView2,
            minorNameLbl2, minorNameTxt2,
            guardianDobLbl2, guardianDobBtn2, guardianDobTxt2,
            guardianIDLbl2, guardianIdTxt2, guardianVerifyBtn2,
            guardianMobileLbl2, guardianMobileTxt2,
            guardianEmailLbl2, guardianEmailTxt2,
            guardianRelationLbl2, guardianRelationBtn2,
            nomineeSameAsBtn2,
            guardianAddressLblFirst2, guardianAddressTxtFirst2,
            guardianAddressLblSecond2, guardianAddressTxtSecond2,
            guardianAddressLblThird2, guardianAddressTxtThird2,
            guardianPinCodeLbl2, guardianPinCodeTxt2,
            guardianCityLbl2, guardianCityTxt2,
            guardianStateLbl2, guardianStateTxt2, guardianLbl2, relationLbl2
        ]
        
        nominee3Fields = [
            documentTypeLbl3, documentTypeBtn3, documentId3, documentVerifyBtn3,
            nomineeNameTxt3, nomineeDob3, nomineeDobBtn3, nomineeMobile3, nomineeEmail3,
            addressSameAsApplicantBtn3, addressLblFirst3, addressTxtFirst3,
            addressLblSecond3, addressTxtSecond3, addressLblThird3, addressTxtThird3,
            pinCodeLbl3, pinCodeTxt3, cityLbl3, cityTxt3, stateLbl3, stateTxt3,
            relationApplicantLbl3, relationBtn3, shareLbl3, shareTxt3,
            gurdianLbl3, guardianTypeLbl3, guardianDocumentTypeBtn3,  guardianDocumentView3,
            minorNameLbl3, minorNameTxt3,
            guardianDobLbl3, guardianDobBtn3, guardianDobTxt3,
            guardianIDLbl3, guardianIdTxt3, guardianVerifyBtn3,
            guardianMobileLbl3, guardianMobileTxt3,
            guardianEmailLbl3, guardianEmailTxt3,
            guardianRelationLbl3, guardianRelationBtn3,
            nomineeSameAsBtn3,
            guardianAddressLblFirst3, guardianAddressTxtFirst3,
            guardianAddressLblSecond3, guardianAddressTxtSecond3,
            guardianAddressLblThird3, guardianAddressTxtThird3,
            guardianPinCodeLbl2, guardianPinCodeTxt2,
            guardianCityLbl3, guardianCityTxt3,
            guardianStateLbl3, guardianStateTxt3, guardianLbl3, relationLbl3
        ]
    }
    
    
    func saveDigiLocker(identifier1 : String) {
        digiIdentifier = identifier1
        
        var panValue: String = panNo ?? ""
        
        switch identifier1 {
        case "NomineeDocument1":
            panValue = "NOMINEE_1"
        case "NomineeDocument2":
            panValue = "NOMINEE_2"
        case "NomineeDocument3":
            panValue = "NOMINEE_3"
        case "guardianDocument1":
            panValue = "NOMINEE_1G"
        case "guardianDocument2":
            panValue = "NOMINEE_2G"
        case "guardianDocument3":
            panValue = "NOMINEE_3G"
        default:
            panValue = panNo ?? "" // fallback for main PAN
        }
        
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                    if success {
                        // Call SIXTHAPI after tokenMobile API call is successful
                        self.saveDigiLocker(identifier1: identifier1)
                    } else {
                        print("Token generation failed.")
                    }
                }// Handle the case where no tokens are available
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "UserId": fetchedUserId,
                "TokenId": tokenId,
                "RegId": RegId,
                "PanNo": panValue,
                "PanName": "N",
                "Flag":"INSERT",
                "ThirdPartyRequest": ""
            ]
            print(parameters)
            let Url = "AadhaarData/SaveDigiLockerAuditLogDetails"
            
            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view,loaderText: "please wait...") { result in
                switch result {
                case .success(let jsonResponse):
                    print("SAVE-DIGILOCKER Response: \(jsonResponse)")
                    //                    let DigiLockerURL = jsonResponse["DigiLockerURL"] as? String
                    let digilockerReturnURL = jsonResponse["DigiLockeReturnURL"] as? String
                    let Client_id = jsonResponse["Client_id"] as? String
                    let DigiLockerURL = jsonResponse["DigiLockerURL"] as? String
                    let TransactionID = jsonResponse["TransactionID"] as? String
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
                                print("All TokenMobile entries deleted due to error code 999992")
                                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                                    if success {
                                        self.saveDigiLocker(identifier1: identifier1)
                                    } else {
                                        print("Token generation failed.")
                                    }
                                }
                            }
                        case "000000":
                            DispatchQueue.main.async {
                                if let digiType = jsonResponse["DigiType"] as? String {
                                    if digiType == "VERITICS" {
                                        self.navigationToVeriticsVC()
                                        //                                        self.navigateToVeriticsVC(DigiLockerURL: DigiLockerURL ?? "", TransactionID: TransactionID ?? "",identifier1 : identifier1)
                                    } else if digiType == "DIRECT"{
                                        let url = "\(DigiLockerURL ?? "")?redirect_uri=\(digilockerReturnURL ?? "")&response_type=code&response_type=code&client_id=\(Client_id ?? "")&state=\(TransactionID ?? "")"
                                        //                                        self.navigateToVeriticsVC(DigiLockerURL: url, TransactionID: TransactionID ?? "", identifier1: identifier1 )
                                        self.navigationToVeriticsVC()
                                    }else {
                                        print("Invalid type: \(digiType)")
                                    }
                                } else {
                                    print("DigiType is missing in the response")
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
    
    func validatePinCode(pinCode: String, for type: String, index: Int = 1) {
        let parameters: [String: Any] = ["PinCode": pinCode]
        
        let url = "CityState/GetCitySateOnPincode"
        
        apiCall(url: url, method: "POST", parameters: parameters, view: self.view) { result in
            switch result {
            case .success(let jsonResponse):
                if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
                    DispatchQueue.main.async {
                        if let countryList = jsonResponse["CountryList"] as? [[String: Any]],
                           let firstItem = countryList.first {
                            let city = firstItem["City"] as? String ?? ""
                            let state = firstItem["State"] as? String ?? ""
                            
                            if type == "nominee" {
                                switch index {
                                case 1:
                                    self.cityTxt1.text = city
                                    self.stateTxt1.text = state
                                    self.cityTxt1.isUserInteractionEnabled = false
                                    self.stateTxt1.isUserInteractionEnabled = false
                                case 2:
                                    self.cityTxt2.text = city
                                    self.stateTxt2.text = state
                                    self.cityTxt2.isUserInteractionEnabled = false
                                    self.stateTxt2.isUserInteractionEnabled = false
                                case 3:
                                    self.cityTxt3.text = city
                                    self.stateTxt3.text = state
                                    self.cityTxt3.isUserInteractionEnabled = false
                                    self.stateTxt3.isUserInteractionEnabled = false
                                default:
                                    break
                                }
                            } else if type == "guardian" {
                                // Add guardian address fields
                                switch index {
                                case 1:
                                    self.guardianCityTxt1.text = city
                                    self.guardianStateTxt1.text = state
                                    self.guardianCityTxt1.isUserInteractionEnabled = false
                                    self.guardianStateTxt1.isUserInteractionEnabled = false
                                case 2:
                                    self.guardianCityTxt2.text = city
                                    self.guardianStateTxt2.text = state
                                    self.guardianCityTxt2.isUserInteractionEnabled = false
                                    self.guardianStateTxt2.isUserInteractionEnabled = false
                                case 3:
                                    self.guardianCityTxt3.text = city
                                    self.guardianStateTxt3.text = state
                                    self.guardianCityTxt3.isUserInteractionEnabled = false
                                    self.guardianStateTxt3.isUserInteractionEnabled = false
                                default:
                                    break
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print("API call failed: \(error.localizedDescription)")
            }
        }
    }
    
    func ViewAllNomineeDetails() {
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W", in: self.view
                ) { success in
                    if success {
                        self.ViewAllNomineeDetails()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            
            let parameters: [String: Any?] = [
                "UserId": fetchedUserId,
                "PanNo": panNo,
                "RegId": RegId,
                "TokenId": tokenId
            ]
            
            print(parameters)
            
            let url = "NomineeDetails/ViewAllNomineeDetails"
            
            apiCall(url: url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("ViewAllNomineeDetails Response: \(jsonResponse)")
                    
                    if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
                        DispatchQueue.main.async {
                            if let IsNominate = jsonResponse["IsNominate"] as? String {
                                if IsNominate == "N" {
                                    print("NO NOMINEES ARE PRESENT")
                                    // Reset UI for no nominees
                                    //self.optOutBtn.isSelected = true
                                    //self.optInBtn.isSelected = false
                                    //self.addNomineeBtn.isHidden = true
                                    self.addNomineeBtn.isEnabled = false
                                    self.addNomineeBtn.alpha = 0.5
                                    self.nominee1Stack.isHidden = true
                                    self.nominee2Stack.isHidden = true
                                    self.nominee3Stack.isHidden = true
                                    self.nomineeCount = 0
                                    self.skipBtn.isEnabled = false
                                    self.skipBtn.alpha = 0.5
                                    self.submitBtn.isEnabled = false
                                    self.submitBtn.alpha = 0.5
                                } else if IsNominate == "Y" {
                                    //self.optInBtn.isSelected = true
                                    // self.optOutBtn.isSelected = false
                                    
                                    if let nomineeData = jsonResponse["NomineeDetails"] as? [[String: Any]], !nomineeData.isEmpty {
                                        self.nomineeDetailsArray = nomineeData
                                        self.updateNomineeViewsall() // You need to implement this method
                                    }
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            if let errorMessage = jsonResponse["ErrorMessage"] as? String {
                                self.showAlert(message: errorMessage)
                            } else {
                                self.showAlert(message: "Unhandled error code")
                            }
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(message: "API call failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func updateNomineeViewsall() {
        nomineeCount = nomineeDetailsArray.count
        
        // Check if any nominee is APPROVED
        var isAnyApproved = false
        for nomineeData in nomineeDetailsArray {
            if let status = nomineeData["Status"] as? String, status == "APPROVED" {
                isAnyApproved = true
                break
            }
        }
        
        if isAnyApproved {
            // Disable all controls if already approved
            disableAllControlsAfterSubmission()
            UserDefaults.standard.set(true, forKey: "NomineesSubmitted_\(panNo ?? "")")
            UserDefaults.standard.synchronize()
        }
        
        for (index, nomineeData) in nomineeDetailsArray.enumerated() {
            let nomineeIndex = index + 1
            
            switch nomineeIndex {
            case 1:
                nominee1Stack.isHidden = false
                populateNomineeData(nomineeData, for: 1)
            case 2:
                nominee2Stack.isHidden = false
                populateNomineeData(nomineeData, for: 2)
            case 3:
                nominee3Stack.isHidden = false
                populateNomineeData(nomineeData, for: 3)
            default:
                break
            }
        }
        
        addNomineeBtn.isHidden = (nomineeCount >= 3)
        
        // Expand the first nominee if there are saved details
        if nomineeCount >= 1 && !nominee1Stack.isHidden {
            isNominee1Expanded = true
            for (index, view) in nominee1Stack.arrangedSubviews.enumerated() {
                if index != 0 {
                    view.isHidden = false
                }
            }
        }
    }
 
    func populateNomineeData(_ data: [String: Any], for index: Int) {
        switch index {
        case 1:
            // Basic Info
            nomineeNameTxt1.text = data["NomineeName"] as? String ?? ""
            
            // Fix date format
            let dobString = data["DOB"] as? String ?? ""
            let formattedDOB = dobString.replacingOccurrences(of: "/", with: "-")
            nomineeDob1.text = formattedDOB
            
            documentId1.text = data["DocumentNumber"] as? String ?? ""
            nomineeMobile1.text = data["MobileNo"] as? String ?? ""
            nomineeEmail1.text = data["EmailId"] as? String ?? ""
            
            // Fix percentage - handle both String and Int
            if let percentageInt = data["Percentage"] as? Int {
                shareTxt1.text = "\(percentageInt)"
            } else if let percentageString = data["Percentage"] as? String {
                shareTxt1.text = percentageString
            } else if let percentageDouble = data["Percentage"] as? Double {
                shareTxt1.text = "\(Int(percentageDouble))"
            } else {
                shareTxt1.text = ""
            }
            print("✅ Share percentage set to: \(shareTxt1.text ?? "")")
            
            // Fix Relation - use RelationshipValue for display, Relationship for ID
            if let relationValue = data["RelationshipValue"] as? String {
                relationLbl1.text = relationValue
            } else {
                relationLbl1.text = "Select Relation"
            }
            
            if let relationId = data["Relationship"] as? Int {
                relationID1 = String(relationId)
            } else if let relationId = data["Relationship"] as? String {
                relationID1 = relationId
            }
            
            // Document Type
            let docType = data["DocumentType"] as? String ?? ""
            documentTypeBtn1.setTitle(docType, for: .normal)
            nomineedocumentType1 = docType
            
            // Address fields
            if let sameAsApplicant = data["SameAsPermanent"] as? Int, sameAsApplicant == 1 {
                addressSameAsApplicantBtn1.isSelected = true
                hideNomineeAddress1(true)
            } else {
                addressTxtFirst1.text = data["Address1"] as? String ?? ""
                addressTxtSecond1.text = data["Address2"] as? String ?? ""
                addressTxtThird1.text = data["Address3"] as? String ?? ""
                cityTxt1.text = data["City"] as? String ?? ""
                stateTxt1.text = data["State"] as? String ?? ""
                pinCodeTxt1.text = data["PinCode"] as? String ?? ""
                hideNomineeAddress1(false)
            }
            
            // Fix Minor detection
            let isMinor = data["NomineeMinor"] as? String ?? "N"
            let calculatedAge = calculateAge(from: formattedDOB) ?? 0
            let shouldBeMinor = (calculatedAge < 18)
            
            nominee1IsMinor = shouldBeMinor ? "Y" : isMinor
            
            print("🔍 Nominee 1 - DOB: \(formattedDOB), Age: \(calculatedAge), API Minor: \(isMinor), Final Minor: \(nominee1IsMinor)")
            
            DispatchQueue.main.async {
                if self.nominee1IsMinor == "Y" {
                    print("✅ Showing guardian fields for Nominee 1 (Minor)")
                    self.toggleGuardianFields(for: 1, show: true)
                    
                    // Fill guardian data
                    self.minorNameTxt1.text = data["GuardianName"] as? String ?? ""
                    
                    // Fix guardian DOB format
                    let guardianDobString = data["GDOB"] as? String ?? ""
                    let formattedGuardianDOB = guardianDobString.replacingOccurrences(of: "/", with: "-")
                    self.guardianDobTxt1.text = formattedGuardianDOB
                    
                    self.guardianIdTxt1.text = data["GDocumentNumber"] as? String ?? ""
                    self.guardianMobileTxt1.text = data["GMobileNo"] as? String ?? ""
                    self.guardianEmailTxt1.text = data["GEmail"] as? String ?? ""
                    
                    // Fix Guardian Document Type
                    let guardianDocType = data["GDocumentType"] as? String ?? ""
                    self.guardianDocumentTypeBtn1.setTitle(guardianDocType, for: .normal)
                    self.guardiandocumentType1 = guardianDocType
                    
                    if let guardianRelationId = data["GRelationship"] as? Int {
                        self.guardianRelationID1 = String(guardianRelationId)
                        self.guardianLbl1.text = self.getGuardianRelationName(from: guardianRelationId)
                    } else if let guardianRelationId = data["GRelationship"] as? String {
                        self.guardianRelationID1 = guardianRelationId
                        if let id = Int(guardianRelationId) {
                            self.guardianLbl1.text = self.getGuardianRelationName(from: id)
                        } else {
                            self.guardianLbl1.text = guardianRelationId
                        }
                    } else {
                        self.guardianLbl1.text = "Select Relation"
                    }
                    
                    if let sameAsNominee = data["SameAsNominee"] as? Int, sameAsNominee == 1 {
                        self.nomineeSameAsBtn1.isSelected = true
                        self.hideGuardianAddress1(true)
                    } else {
                        self.guardianAddressTxtFirst1.text = data["GAddress1"] as? String ?? ""
                        self.guardianAddressTxtSecond1.text = data["GAddress2"] as? String ?? ""
                        self.guardianAddressTxtThird1.text = data["GAddress3"] as? String ?? ""
                        self.guardianCityTxt1.text = data["GCity"] as? String ?? ""
                        self.guardianStateTxt1.text = data["GState"] as? String ?? ""
                        self.guardianPinCodeTxt1.text = data["GPinCode"] as? String ?? ""
                        self.hideGuardianAddress1(false)
                    }
                } else {
                    print("✅ Hiding guardian fields for Nominee 1 (Adult)")
                    self.toggleGuardianFields(for: 1, show: false)
                }
            }
            
            let isVerified = (data["DocumentNumber_Verify"] as? Int == 1)
            let isApproved = (data["Status"] as? String == "APPROVED")
            
            if isVerified || isApproved {
                disableNomineeFieldsAfterSave(index: 1)
                disableVerifyButtons(for: index, isGuardian: false)
            }
            
            if isVerified || isApproved {
                disableNomineeFieldsAfterSave(index: index)
                // ✅ Disable verify button for approved/verified nominees
                disableVerifyButtons(for: index, isGuardian: false)
                
                // Also disable guardian verify button if minor
                if index == 1 && nominee1IsMinor == "Y" {
                    disableVerifyButtons(for: index, isGuardian: true)
                } else if index == 2 && nominee2IsMinor == "Y" {
                    disableVerifyButtons(for: index, isGuardian: true)
                } else if index == 3 && nominee3IsMinor == "Y" {
                    disableVerifyButtons(for: index, isGuardian: true)
                }
            }
            
        case 2:
            // Similar fixes for Nominee 2
            nomineeNameTxt2.text = data["NomineeName"] as? String ?? ""
            
            let dobString = data["DOB"] as? String ?? ""
            let formattedDOB = dobString.replacingOccurrences(of: "/", with: "-")
            nomineeDob2.text = formattedDOB
            
            documentId2.text = data["DocumentNumber"] as? String ?? ""
            nomineeMobile2.text = data["MobileNo"] as? String ?? ""
            nomineeEmail2.text = data["EmailId"] as? String ?? ""
            
            // Fix percentage
            if let percentageInt = data["Percentage"] as? Int {
                shareTxt2.text = "\(percentageInt)"
            } else if let percentageString = data["Percentage"] as? String {
                shareTxt2.text = percentageString
            } else if let percentageDouble = data["Percentage"] as? Double {
                shareTxt2.text = "\(Int(percentageDouble))"
            } else {
                shareTxt2.text = ""
            }
            
            // Fix Relation
            if let relationValue = data["RelationshipValue"] as? String {
                relationLbl2.text = relationValue
            } else {
                relationLbl2.text = "Select Relation"
            }
            
            if let relationId = data["Relationship"] as? Int {
                relationID2 = String(relationId)
            } else if let relationId = data["Relationship"] as? String {
                relationID2 = relationId
            }
            
            let docType = data["DocumentType"] as? String ?? ""
            documentTypeBtn2.setTitle(docType, for: .normal)
            nomineedocumentType2 = docType
            
            if let sameAsApplicant = data["SameAsPermanent"] as? Int, sameAsApplicant == 1 {
                addressSameAsApplicantBtn2.isSelected = true
                hideNomineeAddress2(true)
            } else {
                addressTxtFirst2.text = data["Address1"] as? String ?? ""
                addressTxtSecond2.text = data["Address2"] as? String ?? ""
                addressTxtThird2.text = data["Address3"] as? String ?? ""
                cityTxt2.text = data["City"] as? String ?? ""
                stateTxt2.text = data["State"] as? String ?? ""
                pinCodeTxt2.text = data["PinCode"] as? String ?? ""
                hideNomineeAddress2(false)
            }
            
            let isMinor2 = data["NomineeMinor"] as? String ?? "N"
            let calculatedAge2 = calculateAge(from: formattedDOB) ?? 0
            let shouldBeMinor2 = (calculatedAge2 < 18)
            
            nominee2IsMinor = shouldBeMinor2 ? "Y" : isMinor2
            
            DispatchQueue.main.async {
                if self.nominee2IsMinor == "Y" {
                    self.toggleGuardianFields(for: 2, show: true)
                    
                    self.minorNameTxt2.text = data["GuardianName"] as? String ?? ""
                    
                    let guardianDobString = data["GDOB"] as? String ?? ""
                    let formattedGuardianDOB = guardianDobString.replacingOccurrences(of: "/", with: "-")
                    self.guardianDobTxt2.text = formattedGuardianDOB
                    
                    self.guardianIdTxt2.text = data["GDocumentNumber"] as? String ?? ""
                    self.guardianMobileTxt2.text = data["GMobileNo"] as? String ?? ""
                    self.guardianEmailTxt2.text = data["GEmail"] as? String ?? ""
                    
                    // Fix Guardian Document Type
                    let guardianDocType = data["GDocumentType"] as? String ?? ""
                    self.guardianDocumentTypeBtn2.setTitle(guardianDocType, for: .normal)
                    self.guardiandocumentType2 = guardianDocType
                    
                    if let guardianRelationId = data["GRelationship"] as? Int {
                        self.guardianRelationID2 = String(guardianRelationId)
                        self.guardianLbl2.text = self.getGuardianRelationName(from: guardianRelationId)
                    } else if let guardianRelationId = data["GRelationship"] as? String {
                        self.guardianRelationID2 = guardianRelationId
                        if let id = Int(guardianRelationId) {
                            self.guardianLbl2.text = self.getGuardianRelationName(from: id)
                        } else {
                            self.guardianLbl2.text = guardianRelationId
                        }
                    } else {
                        self.guardianLbl2.text = "Select Relation"
                    }
                    
                    if let sameAsNominee = data["SameAsNominee"] as? Int, sameAsNominee == 1 {
                        self.nomineeSameAsBtn2.isSelected = true
                        self.hideGuardianAddress2(true)
                    } else {
                        self.guardianAddressTxtFirst2.text = data["GAddress1"] as? String ?? ""
                        self.guardianAddressTxtSecond2.text = data["GAddress2"] as? String ?? ""
                        self.guardianAddressTxtThird2.text = data["GAddress3"] as? String ?? ""
                        self.guardianCityTxt2.text = data["GCity"] as? String ?? ""
                        self.guardianStateTxt2.text = data["GState"] as? String ?? ""
                        self.guardianPinCodeTxt2.text = data["GPinCode"] as? String ?? ""
                        self.hideGuardianAddress2(false)
                    }
                } else {
                    self.toggleGuardianFields(for: 2, show: false)
                }
            }
            
            let isVerified2 = (data["DocumentNumber_Verify"] as? Int == 1)
            let isApproved2 = (data["Status"] as? String == "APPROVED")
            
            if isVerified2 || isApproved2 {
                disableNomineeFieldsAfterSave(index: 2)
            }
            
            
        case 3:
            // Similar fixes for Nominee 3 (same pattern as above)
            nomineeNameTxt3.text = data["NomineeName"] as? String ?? ""
            
            let dobString = data["DOB"] as? String ?? ""
            let formattedDOB = dobString.replacingOccurrences(of: "/", with: "-")
            nomineeDob3.text = formattedDOB
            
            documentId3.text = data["DocumentNumber"] as? String ?? ""
            nomineeMobile3.text = data["MobileNo"] as? String ?? ""
            nomineeEmail3.text = data["EmailId"] as? String ?? ""
            
            // Fix percentage
            if let percentageInt = data["Percentage"] as? Int {
                shareTxt3.text = "\(percentageInt)"
            } else if let percentageString = data["Percentage"] as? String {
                shareTxt3.text = percentageString
            } else if let percentageDouble = data["Percentage"] as? Double {
                shareTxt3.text = "\(Int(percentageDouble))"
            } else {
                shareTxt3.text = ""
            }
            
            // Fix Relation
            if let relationValue = data["RelationshipValue"] as? String {
                relationLbl3.text = relationValue
            } else {
                relationLbl3.text = "Select Relation"
            }
            
            if let relationId = data["Relationship"] as? Int {
                relationID3 = String(relationId)
            } else if let relationId = data["Relationship"] as? String {
                relationID3 = relationId
            }
            
            let docType = data["DocumentType"] as? String ?? ""
            documentTypeBtn3.setTitle(docType, for: .normal)
            nomineedocumentType3 = docType
            
            if let sameAsApplicant = data["SameAsPermanent"] as? Int, sameAsApplicant == 1 {
                addressSameAsApplicantBtn3.isSelected = true
                hideNomineeAddress3(true)
            } else {
                addressTxtFirst3.text = data["Address1"] as? String ?? ""
                addressTxtSecond3.text = data["Address2"] as? String ?? ""
                addressTxtThird3.text = data["Address3"] as? String ?? ""
                cityTxt3.text = data["City"] as? String ?? ""
                stateTxt3.text = data["State"] as? String ?? ""
                pinCodeTxt3.text = data["PinCode"] as? String ?? ""
                hideNomineeAddress3(false)
            }
            
            let isMinor3 = data["NomineeMinor"] as? String ?? "N"
            let calculatedAge3 = calculateAge(from: formattedDOB) ?? 0
            let shouldBeMinor3 = (calculatedAge3 < 18)
            
            nominee3IsMinor = shouldBeMinor3 ? "Y" : isMinor3
            
            DispatchQueue.main.async {
                if self.nominee3IsMinor == "Y" {
                    self.toggleGuardianFields(for: 3, show: true)
                    
                    self.minorNameTxt3.text = data["GuardianName"] as? String ?? ""
                    
                    let guardianDobString = data["GDOB"] as? String ?? ""
                    let formattedGuardianDOB = guardianDobString.replacingOccurrences(of: "/", with: "-")
                    self.guardianDobTxt3.text = formattedGuardianDOB
                    
                    self.guardianIdTxt3.text = data["GDocumentNumber"] as? String ?? ""
                    self.guardianMobileTxt3.text = data["GMobileNo"] as? String ?? ""
                    self.guardianEmailTxt3.text = data["GEmail"] as? String ?? ""
                    
                    // Fix Guardian Document Type
                    let guardianDocType = data["GDocumentType"] as? String ?? ""
                    self.guardianDocumentTypeBtn3.setTitle(guardianDocType, for: .normal)
                    self.guardiandocumentType3 = guardianDocType
        
                    if let guardianRelationId = data["GRelationship"] as? Int {
                        self.guardianRelationID3 = String(guardianRelationId)
                        self.guardianLbl3.text = self.getGuardianRelationName(from: guardianRelationId)
                    } else if let guardianRelationId = data["GRelationship"] as? String {
                        self.guardianRelationID3 = guardianRelationId
                        if let id = Int(guardianRelationId) {
                            self.guardianLbl3.text = self.getGuardianRelationName(from: id)
                        } else {
                            self.guardianLbl3.text = guardianRelationId
                        }
                    } else {
                        self.guardianLbl3.text = "Select Relation"
                    }
                    
                    if let sameAsNominee = data["SameAsNominee"] as? Int, sameAsNominee == 1 {
                        self.nomineeSameAsBtn3.isSelected = true
                        self.hideGuardianAddress3(true)
                    } else {
                        self.guardianAddressTxtFirst3.text = data["GAddress1"] as? String ?? ""
                        self.guardianAddressTxtSecond3.text = data["GAddress2"] as? String ?? ""
                        self.guardianAddressTxtThird3.text = data["GAddress3"] as? String ?? ""
                        self.guardianCityTxt3.text = data["GCity"] as? String ?? ""
                        self.guardianStateTxt3.text = data["GState"] as? String ?? ""
                        self.guardianPinCodeTxt3.text = data["GPinCode"] as? String ?? ""
                        self.hideGuardianAddress3(false)
                    }
                } else {
                    self.toggleGuardianFields(for: 3, show: false)
                }
            }
            
            let isVerified3 = (data["DocumentNumber_Verify"] as? Int == 1)
            let isApproved3 = (data["Status"] as? String == "APPROVED")
            
            if isVerified3 || isApproved3 {
                disableNomineeFieldsAfterSave(index: 3)
            }
            
            
            
        default:
            break
        }
    }
    
    private func disableNomineeFieldsAfterSave(index: Int) {
        switch index {
        case 1:
            // Text fields
            nomineeNameTxt1.isEnabled = false
            nomineeDob1.isEnabled = false
            documentId1.isEnabled = false
            nomineeMobile1.isEnabled = false
            nomineeEmail1.isEnabled = false
            shareTxt1.isEnabled = false
            pinCodeTxt1.isEnabled = false
            cityTxt1.isEnabled = false
            stateTxt1.isEnabled = false
            addressTxtFirst1.isEnabled = false
            addressTxtSecond1.isEnabled = false
            addressTxtThird1.isEnabled = false
            
            // Buttons
            documentTypeBtn1.isEnabled = false
            documentVerifyBtn1.isEnabled = false
            relationBtn1.isEnabled = false
            nomineeDobBtn1.isEnabled = false
            relationBtn1.isEnabled = false
            addressSameAsApplicantBtn1.isEnabled = false
            
            // Guardian fields (if any)
            //guardianNameTxt1.isEnabled = false
            guardianDobTxt1.isEnabled = false
            guardianIdTxt1.isEnabled = false
            guardianMobileTxt1.isEnabled = false
            guardianEmailTxt1.isEnabled = false
            guardianPinCodeTxt1.isEnabled = false
            guardianCityTxt1.isEnabled = false
            guardianStateTxt1.isEnabled = false
            guardianAddressTxtFirst1.isEnabled = false
            guardianAddressTxtSecond1.isEnabled = false
            guardianAddressTxtThird1.isEnabled = false
            
            guardianDocumentTypeBtn1.isEnabled = false
            guardianVerifyBtn1.isEnabled = false
            guardianDobBtn1.isEnabled = false
            //  guradianRelationBtn1.isEnabled = false
            nomineeSameAsBtn1.isEnabled = false
            //  guardianAddressSameBtn1.isEnabled = false
            
            
        case 2:
            // Text fields
            nomineeNameTxt2.isEnabled = false
            nomineeDob2.isEnabled = false
            documentId2.isEnabled = false
            nomineeMobile2.isEnabled = false
            nomineeEmail2.isEnabled = false
            shareTxt2.isEnabled = false
            pinCodeTxt2.isEnabled = false
            cityTxt2.isEnabled = false
            stateTxt2.isEnabled = false
            addressTxtFirst2.isEnabled = false
            addressTxtSecond2.isEnabled = false
            addressTxtThird2.isEnabled = false
            
            // Buttons
            documentTypeBtn2.isEnabled = false
            documentVerifyBtn2.isEnabled = false
            relationBtn2.isEnabled = false
            nomineeDobBtn2.isEnabled = false
            relationBtn2.isEnabled = false
            addressSameAsApplicantBtn2.isEnabled = false
            
            // Guardian fields (if any)
            //guardianNameTxt1.isEnabled = false
            guardianDobTxt2.isEnabled = false
            guardianIdTxt2.isEnabled = false
            guardianMobileTxt2.isEnabled = false
            guardianEmailTxt2.isEnabled = false
            guardianPinCodeTxt2.isEnabled = false
            guardianCityTxt2.isEnabled = false
            guardianStateTxt2.isEnabled = false
            guardianAddressTxtFirst2.isEnabled = false
            guardianAddressTxtSecond2.isEnabled = false
            guardianAddressTxtThird2.isEnabled = false
            
            guardianDocumentTypeBtn2.isEnabled = false
            guardianVerifyBtn2.isEnabled = false
            guardianDobBtn2.isEnabled = false
            //  guradianRelationBtn1.isEnabled = false
            nomineeSameAsBtn2.isEnabled = false
            //  guardianAddressSameBtn1.isEnabled = false
            
        case 3:
            // Text fields
            nomineeNameTxt3.isEnabled = false
            nomineeDob3.isEnabled = false
            documentId3.isEnabled = false
            nomineeMobile3.isEnabled = false
            nomineeEmail3.isEnabled = false
            shareTxt3.isEnabled = false
            pinCodeTxt3.isEnabled = false
            cityTxt3.isEnabled = false
            stateTxt3.isEnabled = false
            addressTxtFirst3.isEnabled = false
            addressTxtSecond3.isEnabled = false
            addressTxtThird3.isEnabled = false
            
            // Buttons
            documentTypeBtn3.isEnabled = false
            documentVerifyBtn3.isEnabled = false
            relationBtn3.isEnabled = false
            nomineeDobBtn3.isEnabled = false
            relationBtn3.isEnabled = false
            addressSameAsApplicantBtn3.isEnabled = false
            
            // Guardian fields (if any)
            //guardianNameTxt1.isEnabled = false
            guardianDobTxt3.isEnabled = false
            guardianIdTxt3.isEnabled = false
            guardianMobileTxt3.isEnabled = false
            guardianEmailTxt3.isEnabled = false
            guardianPinCodeTxt3.isEnabled = false
            guardianCityTxt3.isEnabled = false
            guardianStateTxt3.isEnabled = false
            guardianAddressTxtFirst3.isEnabled = false
            guardianAddressTxtSecond3.isEnabled = false
            guardianAddressTxtThird3.isEnabled = false
            
            guardianDocumentTypeBtn3.isEnabled = false
            guardianVerifyBtn3.isEnabled = false
            guardianDobBtn3.isEnabled = false
            //  guradianRelationBtn1.isEnabled = false
            nomineeSameAsBtn3.isEnabled = false
            //  guardianAddressSameBtn1.isEnabled = false
            
        default:
            break
        }
    }
    
    func disableAllControlsAfterSubmission() {
        // Disable opt-in/opt-out buttons
        //        optInBtn.isEnabled = false
        //        optOutBtn.isEnabled = false
        //        optInBtn.isUserInteractionEnabled = false
        //        optOutBtn.isUserInteractionEnabled = false
        
        // Disable add nominee button
        addNomineeBtn.isHidden = true
        addNomineeBtn.isEnabled = false
        
        // Disable submit button
        submitBtn.isEnabled = false
        submitBtn.alpha = 0.5
        
        skipBtn.isEnabled = false
        skipBtn.alpha = 0.5
        
        // Disable all nominee expand/collapse buttons
        //nomineeBtn1.isEnabled = false
        //nomineeBtn2.isEnabled = false
        //nomineeBtn3.isEnabled = false
        
        // Disable all relation buttons
        relationBtn1.isEnabled = false
        relationBtn2.isEnabled = false
        relationBtn3.isEnabled = false
        guardianLbl1.isEnabled = false
        guardianLbl2.isEnabled = false
        guardianLbl3.isEnabled = false
        
        // Disable all document type buttons
        documentTypeBtn1.isEnabled = false
        documentTypeBtn2.isEnabled = false
        documentTypeBtn3.isEnabled = false
        guardianDocumentTypeBtn1.isEnabled = false
        guardianDocumentTypeBtn2.isEnabled = false
        guardianDocumentTypeBtn3.isEnabled = false
        
        // Disable all verify buttons
        documentVerifyBtn1.isEnabled = false
        documentVerifyBtn2.isEnabled = false
        documentVerifyBtn3.isEnabled = false
        guardianVerifyBtn1.isEnabled = false
        guardianVerifyBtn2.isEnabled = false
        guardianVerifyBtn3.isEnabled = false
    }
    
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func navigationToVeriticsVC() {
        let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
        let vc = storyboard.instantiateViewController(identifier: "digiNomiVC") as! digiNomiVC
        vc.panNo = panNo
        vc.regId = RegId
        vc.digilockerDone = "Done"
        vc.identifier3 = "NomineeVC"
        vc.identifier1 = digiIdentifier
        
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func documentType1(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.identifier = "NomineeDocument1"
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @IBAction func dobBtnTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.identifier = "nomineeDOB1"
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @IBAction func documentType2(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.identifier = "NomineeDocument2"
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @IBAction func dobBtnTapped2(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.identifier = "nomineeDOB2"
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @IBAction func documentType3(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.identifier = "NomineeDocument3"
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @IBAction func dobBtnTapped3(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.identifier = "nomineeDOB3"
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @IBAction func nomineeVerifyBtn1(_ sender: UIButton) {
        verifyNominee(index: 1)
    }
    
    @IBAction func nomineeVerifyBtn2(_ sender: UIButton) {
        verifyNominee(index: 2)
    }
    
    @IBAction func nomineeVerifyBtn3(_ sender: UIButton) {
        verifyNominee(index: 3)
    }
    
    @IBAction func guardianDocumentTypeBtn1(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.identifier = "guardianDocument1"
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @IBAction func guardianDocumentTypeBtn2(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.identifier = "guardianDocument2"
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @IBAction func guardianDocumentTypeBtn3(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.identifier = "guardianDocument3"
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @IBAction func guardianVerifyBtn1(_ sender: UIButton) {
        verifyGuardian(index: 1)
    }
    
    @IBAction func guardianVerifyBtn2(_ sender: UIButton) {
        verifyGuardian(index: 2)
    }
    
    @IBAction func guardianVerifyBtn3(_ sender: UIButton) {
        verifyGuardian(index: 3)
    }
    
    @IBAction func guardianDobBtn1(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.identifier = "guardianDOB1"
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @IBAction func guardianDobBtn2(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.identifier = "guardianDOB2"
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @IBAction func guardianDobBtn3(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.identifier = "guardianDOB3"
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    
    @IBAction func nomineeAdressSameBtn1(_ sender: UIButton) {
        sender.isSelected.toggle()
        hideNomineeAddress1(sender.isSelected)
    }
    
    @IBAction func nomineeAddressSameBtn2(_ sender: UIButton) {
        sender.isSelected.toggle()
        hideNomineeAddress2(sender.isSelected)
    }
    
    @IBAction func nomineeAddressSameBtn3(_ sender: UIButton) {
        sender.isSelected.toggle()
        hideNomineeAddress3(sender.isSelected)
    }
    
    @IBAction func guardianAddressSameBtn1(_ sender: UIButton) {
        sender.isSelected.toggle()
        hideGuardianAddress1(sender.isSelected)
    }
    
    @IBAction func guardianAddressSameBtn2(_ sender: UIButton) {
        sender.isSelected.toggle()
        hideGuardianAddress2(sender.isSelected)
    }
    
    @IBAction func guardianAddressSameBtn3(_ sender: UIButton) {
        sender.isSelected.toggle()
        hideGuardianAddress3(sender.isSelected)
    }
    
    @IBAction func nomineeRelationBtn1(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "relationVC") as! relationVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.identifier = "nomineeRelation1"
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @IBAction func guradianRelationBtn1(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "relationVC") as! relationVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.identifier = "guardianRelation1"
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    
    @IBAction func nomineeRelationBtn2(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "relationVC") as! relationVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.identifier = "nomineeRelation2"
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    
    @IBAction func guardianRelationBtn2(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "relationVC") as! relationVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.identifier = "guardianRelation2"
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
        
    }
    
    
    @IBAction func nomineeRelationBtn3(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "relationVC") as! relationVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.identifier = "nomineeRelation3"
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    
    @IBAction func guardianRelationBtn3(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "relationVC") as! relationVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.identifier = "guardianRelation3"
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    func textFieldsCapital() {
        let allTextFields: [UITextField] = [
              nomineeNameTxt1, nomineeNameTxt2, nomineeNameTxt3,
              documentId1, documentId2, documentId3,
              nomineeEmail1, nomineeEmail2, nomineeEmail3,
              addressTxtFirst1, addressTxtFirst2, addressTxtFirst3,
              addressTxtSecond1, addressTxtSecond2, addressTxtSecond3,
              addressTxtThird1, addressTxtThird2, addressTxtThird3,
              cityTxt1, cityTxt2, cityTxt3,
              stateTxt1, stateTxt2, stateTxt3,
              minorNameTxt1, minorNameTxt2, minorNameTxt3,
              guardianIdTxt1, guardianIdTxt2, guardianIdTxt3,
              guardianEmailTxt1, guardianEmailTxt2, guardianEmailTxt3,
              guardianAddressTxtFirst1, guardianAddressTxtFirst2, guardianAddressTxtFirst3,
              guardianAddressTxtSecond1, guardianAddressTxtSecond2, guardianAddressTxtSecond3,
              guardianAddressTxtThird1, guardianAddressTxtThird2, guardianAddressTxtThird3,
              guardianCityTxt1, guardianCityTxt2, guardianCityTxt3,
              guardianStateTxt1, guardianStateTxt2, guardianStateTxt3
          ]
          
          for textField in allTextFields {
              textField.autocapitalizationType = .allCharacters
              textField.autocorrectionType = .no
              textField.delegate = self
          }
        
        let emailFields: [UITextField] = [
            nomineeEmail1, nomineeEmail2, nomineeEmail3,
            guardianEmailTxt1, guardianEmailTxt2, guardianEmailTxt3
        ]
        
        for textField in emailFields {
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.keyboardType = .emailAddress
            textField.delegate = self
        }
        
        // Set mobile number fields
        let mobileFields: [UITextField] = [
            nomineeMobile1, nomineeMobile2, nomineeMobile3,
            guardianMobileTxt1, guardianMobileTxt2, guardianMobileTxt3
        ]
        
        for textField in mobileFields {
            textField.keyboardType = .phonePad
            textField.delegate = self
        }
        
        // Set pincode fields
        let pincodeFields: [UITextField] = [
            pinCodeTxt1, pinCodeTxt2, pinCodeTxt3,
            guardianPinCodeTxt1, guardianPinCodeTxt2, guardianPinCodeTxt3
        ]
        
        for textField in pincodeFields {
            textField.keyboardType = .numberPad
            textField.delegate = self
        }
    }
    
    func verifyNominee(index: Int) {
        
        var panNo = ""
        var name = ""
        var dob = ""
        
        switch index {
        case 1:
            panNo = documentId1.text ?? ""
            name = nomineeNameTxt1.text ?? ""
            dob = nomineeDob1.text ?? ""
        case 2:
            panNo = documentId2.text ?? ""
            name = nomineeNameTxt2.text ?? ""
            dob = nomineeDob2.text ?? ""
        case 3:
            panNo = documentId3.text ?? ""
            name = nomineeNameTxt3.text ?? ""
            dob = nomineeDob3.text ?? ""
        default:
            return
        }
        
        if let age = calculateAge(from: dob) {
            toggleGuardianFields(for: index, show: age < 18)
        }
        
        self.identifier = "Nominee\(index)"
        panValidation(panNo: panNo, name: name, userDOB: dob, isGuardian: false)
    }
    
    func verifyGuardian(index: Int) {
        
        var panNo = ""
        var name = ""
        var dob = ""
        
        switch index {
        case 1:
            panNo = guardianIdTxt1.text ?? ""
            name = minorNameTxt1.text ?? ""
            dob = guardianDobTxt1.text ?? ""
        case 2:
            panNo = guardianIdTxt2.text ?? ""
            name = minorNameTxt2.text ?? ""
            dob = guardianDobTxt2.text ?? ""
        case 3:
            panNo = guardianIdTxt3.text ?? ""
            name = minorNameTxt3.text ?? ""
            dob = guardianDobTxt3.text ?? ""
        default:
            return
        }
        
        guard !panNo.isEmpty, !name.isEmpty, !dob.isEmpty else {
            showAlert(message: "Please enter all nominee details.")
            return
        }
        self.identifier = "Nominee\(index)"
        panValidation(panNo: panNo, name: name, userDOB: dob, isGuardian: true)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func isValidMobile(_ mobile: String) -> Bool {
        let mobileRegex = "^[0-9]{10}$"
        return NSPredicate(format: "SELF MATCHES %@", mobileRegex).evaluate(with: mobile)
    }
    
    func isValidPinCode(_ pincode: String) -> Bool {
        let pinRegex = "^[0-9]{6}$"
        return NSPredicate(format: "SELF MATCHES %@", pinRegex).evaluate(with: pincode)
    }
    
    @IBAction func proceedBtn(_ sender: UIButton) {
        //        if optOutBtn.isSelected {
        //            // Opt-Out selected - submit directly
        //            print("User opted out, submitting without nominee validation")
        //            NomineeType = "N"
        //            insertUpdateNomineeDetailsWebWithMinimalParams()
        //            return
        //        }
        
        // For opt-in users
        NomineeType = "Y"
        guard nomineeCount > 0 else {
            showAlert(message: "Please add at least one nominee before proceeding.")
            return
        }
        
        // Validate PAN and Name duplicates from the actual UI fields
        var panSet = Set<String>()
        var nameSet = Set<String>()
        
        // Check Nominee 1
        if nomineeCount >= 1 && !nominee1Stack.isHidden {
            let pan = documentId1.text ?? ""
            let name = nomineeNameTxt1.text ?? ""
            
            if !pan.isEmpty && panSet.contains(pan) {
                showAlert(message: "Please enter different PAN or ID for each nominee.")
                return
            }
            if !name.isEmpty && nameSet.contains(name) {
                showAlert(message: "Please enter a different nominee name for each nominee.")
                return
            }
            if !pan.isEmpty { panSet.insert(pan) }
            if !name.isEmpty { nameSet.insert(name) }
        }
        
        // Check Nominee 2
        if nomineeCount >= 2 && !nominee2Stack.isHidden {
            let pan = documentId2.text ?? ""
            let name = nomineeNameTxt2.text ?? ""
            
            if !pan.isEmpty && panSet.contains(pan) {
                showAlert(message: "Please enter different PAN or ID for each nominee.")
                return
            }
            if !name.isEmpty && nameSet.contains(name) {
                showAlert(message: "Please enter a different nominee name for each nominee.")
                return
            }
            if !pan.isEmpty { panSet.insert(pan) }
            if !name.isEmpty { nameSet.insert(name) }
        }
        
        // Check Nominee 3
        if nomineeCount >= 3 && !nominee3Stack.isHidden {
            let pan = documentId3.text ?? ""
            let name = nomineeNameTxt3.text ?? ""
            
            if !pan.isEmpty && panSet.contains(pan) {
                showAlert(message: "Please enter different PAN or ID for each nominee.")
                return
            }
            if !name.isEmpty && nameSet.contains(name) {
                showAlert(message: "Please enter a different nominee name for each nominee.")
                return
            }
            if !pan.isEmpty { panSet.insert(pan) }
            if !name.isEmpty { nameSet.insert(name) }
        }
        
        if nomineeCount >= 1 && !nominee1Stack.isHidden {
            if let dob = nomineeDob1.text, let age = calculateAge(from: dob) {
                nominee1IsMinor = age < 18 ? "Y" : "N"
            }
        }
        
        if nomineeCount >= 2 && !nominee2Stack.isHidden {
            if let dob = nomineeDob2.text, let age = calculateAge(from: dob) {
                nominee2IsMinor = age < 18 ? "Y" : "N"
            }
        }
        
        if nomineeCount >= 3 && !nominee3Stack.isHidden {
            if let dob = nomineeDob3.text, let age = calculateAge(from: dob) {
                nominee3IsMinor = age < 18 ? "Y" : "N"
            }
        }
        
        // Validate allocation
        if !validateNomineeAllocation() {
            return
        }
        insertUpdateNomineeDetailsWebWithFullParams()
    }
    
    
    @IBAction func skipBtn(_ sender: UIButton) {
        // Opt-Out selected - submit directly
        print("User opted out, submitting without nominee validation")
        NomineeType = "N"
        insertUpdateNomineeDetailsWebWithMinimalParams()
    }
    
    
    func panValidation(panNo: String, name: String, userDOB: String,isGuardian: Bool){
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                    if success {
                        // Call SIXTHAPI after tokenMobile API call is successful
                        self.panValidation(panNo: panNo, name: name, userDOB: userDOB, isGuardian: isGuardian)
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
                "PanNo": panNo,
                "DeviceType": "1",
                "Name": name,
                "UserDOB": userDOB,
                "Flag":"N",
                "NOMType":identifier
            ]
            
            // URL for the login endpoint
            let Url = "Registration/ThirdPartyPANVerify"
            
            print(parameters)
            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view,loaderText: "please wait processing data...") { result in
                switch result {
                case .success(let jsonResponse):
                    print("PAN api Response: \(jsonResponse)")
                    
                    let ErrorMessage = jsonResponse["ErrorMessage"] as? String
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        
                        switch errorCode {
                            
                        case "000000":
                            DispatchQueue.main.async {
                                DispatchQueue.main.async {
                                    if !isGuardian {
                                        // Detect nominee index
                                        if let index = Int(self.identifier.replacingOccurrences(of: "Nominee", with: "")) {
                                            // Disable fields after PAN verification
                                            self.disableNomineeFieldsAfterDigiLocker(index: index)
                                            // ✅ Disable verify button for nominee
                                            self.disableVerifyButtons(for: index, isGuardian: false)
                                            
                                            // Age check for guardian
                                            if let age = self.calculateAge(from: userDOB) {
                                                self.toggleGuardianFields(for: index, show: age < 18)
                                            }
                                        }
                                    } else {
                                        // For guardian verification
                                        if let index = Int(self.identifier.replacingOccurrences(of: "Nominee", with: "")) {
                                            // ✅ Disable verify button for guardian
                                            self.disableVerifyButtons(for: index, isGuardian: true)
                                        }
                                    }
                                    let storyboard = UIStoryboard(name: "DashboardVC", bundle: Bundle.module)
                                    
                                    guard let viewController = storyboard.instantiateViewController(withIdentifier: "PanVerifyPopupVC") as? PanVerifyPopupVC else {
                                        print("ViewController not found")
                                        return
                                    }
                                    
                                    viewController.panName = jsonResponse["PANName"] as? String
                                    viewController.dob = jsonResponse["DOB"] as? String
                                    viewController.requestId = jsonResponse["RequestId"] as? String
                                    viewController.panNo = jsonResponse["PanNo"] as? String
                                    viewController.identifier = "nomineePanVerify"
                                    viewController.modalPresentationStyle = .overCurrentContext
                                    viewController.modalTransitionStyle = .crossDissolve
                                    
                                    self.present(viewController, animated: true)
                                }
                            }
                            
                        case "100001":
                            DispatchQueue.main.async {
                                self.showAlert( message: ErrorMessage ?? "")
                            }
                        case "300009":
                            DispatchQueue.main.async {
                                self.showAlert( message: ErrorMessage ?? "")
                            }
                        case "Pan-001":
                            DispatchQueue.main.async {
                                self.showAlert(message: ErrorMessage ?? "")
                            }
                        case "PANDOB-001":
                            DispatchQueue.main.async {
                                self.showAlert(message: ErrorMessage ?? "")
                            }
                        case "300001":
                            DispatchQueue.main.async {
                                self.showAlert(message: ErrorMessage ?? "")
                            }
                        case "300006":
                            DispatchQueue.main.async {
                                self.showAlert(message: ErrorMessage ?? "")
                            }
                        case "111111":
                            DispatchQueue.main.async {
                                self.showAlert(message: "Please check your pancard ID number")
                            }
                            
                        case "300003":
                            if let errorMessage = jsonResponse["ErrorMessage"] as? String {
                                DispatchQueue.main.async {
                                    self.showAlert(message: errorMessage)
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
    
    func insertUpdateNomineeDetailsWebWithMinimalParams() {
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
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
                        self.insertUpdateNomineeDetailsWebWithMinimalParams()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            
            var parameters: [String: Any?] = [
                "SessionId": fetchedSessionID,
                "TokenId": tokenId,
                "UserId": fetchedUserId,
                "PanNo": panNo,
                "RegId": RegId,
                "NomineeType": NomineeType
            ]
            
            let url = "NomineeDetails/InsertUpdateNomineeDetailsWeb"
            Task { @MainActor in
                apiCall(url: url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
                    switch result {
                    case .success(let jsonResponse):
                        print("InsertUpdateNomineeDetailsWeb Response: \(jsonResponse)")
                        if let errorCode = jsonResponse["ErrorCode"] as? String {
                            if errorCode == "000000" {
                                DispatchQueue.main.async {
                                    
                                    let storyboard = UIStoryboard(name: "Document", bundle: Bundle.module )
                                    if let nextVC = storyboard.instantiateViewController(withIdentifier: "DocumentVC") as? DocumentVC {
                                        let savedPAN = UserDefaults.standard.string(forKey: "PanNo")
                                        let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.panNo
                                        let regId = UserDefaults.standard.string(forKey: "RegId")
                                        let regIdFinal = (regId?.isEmpty == false) ? regId : self.RegId
                                        nextVC.PanNo = finalPAN
                                        nextVC.RegId = regIdFinal
                                        nextVC.delegate = self
                                        self.navigationController?.pushViewController(nextVC, animated: true)
                                    }
                                }
                            } else if errorCode == "999992" {
                                // Handle invalid token case
                                print("Invalid token detected. Attempting to refresh token.")
                                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                                    if success {
                                        self.insertUpdateNomineeDetailsWebWithMinimalParams()
                                    } else {
                                        DispatchQueue.main.async {
                                            self.showAlert(message: "Token refresh failed. Please try again.")
                                        }
                                    }
                                }
                            } else {
                                DispatchQueue.main.async {
                                    if let errorMessage = jsonResponse["ErrorMessage"] as? String {
                                        self.showAlert(message: errorMessage)
                                    } else {
                                        self.showAlert(message: "Unhandled error code")
                                    }
                                }
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.showAlert(message: "API call failed: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    func disableNomineeFieldsAfterDigiLocker(index: Int) {
        var documentType: String?
        
        switch index {
        case 1:
            documentType = nomineedocumentType1
            documentVerifyBtn1.isEnabled = false
            documentVerifyBtn1.alpha = 0.5
        case 2:
            documentType = nomineedocumentType2
            documentVerifyBtn2.isEnabled = false
            documentVerifyBtn2.alpha = 0.5
        case 3:
            documentType = nomineedocumentType3
            documentVerifyBtn3.isEnabled = false
            documentVerifyBtn3.alpha = 0.5
        default:
            break
        }
        
        // Only disable address fields if document type is Aadhaar
        let shouldDisableAddressFields = (documentType == "Aadhaar")
        
        switch index {
        case 1:
            nomineeNameTxt1.isEnabled = false
            nomineeDob1.isEnabled = false
            documentId1.isEnabled = false
            documentTypeBtn1.isEnabled = false
            
            // Conditionally disable address fields only for Aadhaar
            if shouldDisableAddressFields {
                addressTxtFirst1.isEnabled = false
                addressTxtSecond1.isEnabled = false
                addressTxtThird1.isEnabled = false
                pinCodeTxt1.isEnabled = false
                cityTxt1.isEnabled = false
                stateTxt1.isEnabled = false
            }
            // For PAN, address fields remain enabled
            
        case 2:
            nomineeNameTxt2.isEnabled = false
            nomineeDob2.isEnabled = false
            documentId2.isEnabled = false
            documentTypeBtn2.isEnabled = false
            
            if shouldDisableAddressFields {
                addressTxtFirst2.isEnabled = false
                addressTxtSecond2.isEnabled = false
                addressTxtThird2.isEnabled = false
                pinCodeTxt2.isEnabled = false
                cityTxt2.isEnabled = false
                stateTxt2.isEnabled = false
            }
            
        case 3:
            nomineeNameTxt3.isEnabled = false
            nomineeDob3.isEnabled = false
            documentId3.isEnabled = false
            documentTypeBtn3.isEnabled = false
            
            if shouldDisableAddressFields {
                addressTxtFirst3.isEnabled = false
                addressTxtSecond3.isEnabled = false
                addressTxtThird3.isEnabled = false
                pinCodeTxt3.isEnabled = false
                cityTxt3.isEnabled = false
                stateTxt3.isEnabled = false
            }
            
        default:
            break
        }
    }
    
    func validateNomineeAllocation() -> Bool {
        var totalAllocation = 0
        var activeNominees = 0
        
        // Calculate based on actual nominee count from UI
        if nomineeCount >= 1 && !nominee1Stack.isHidden {
            let percentage = Int(shareTxt1.text ?? "") ?? 0
            totalAllocation += percentage
            activeNominees += 1
            
            // Validate individual percentage is not more than 100
            if percentage > 100 {
                showAlert(message: "Nominee 1 allocation cannot exceed 100%")
                return false
            }
            if percentage < 0 {
                showAlert(message: "Nominee 1 allocation cannot be negative")
                return false
            }
        }
        
        if nomineeCount >= 2 && !nominee2Stack.isHidden {
            let percentage = Int(shareTxt2.text ?? "") ?? 0
            totalAllocation += percentage
            activeNominees += 1
            
            if percentage > 100 {
                showAlert(message: "Nominee 2 allocation cannot exceed 100%")
                return false
            }
            if percentage < 0 {
                showAlert(message: "Nominee 2 allocation cannot be negative")
                return false
            }
        }
        
        if nomineeCount >= 3 && !nominee3Stack.isHidden {
            let percentage = Int(shareTxt3.text ?? "") ?? 0
            totalAllocation += percentage
            activeNominees += 1
            
            if percentage > 100 {
                showAlert(message: "Nominee 3 allocation cannot exceed 100%")
                return false
            }
            if percentage < 0 {
                showAlert(message: "Nominee 3 allocation cannot be negative")
                return false
            }
        }
        
        // If no nominees, validation passes (they will be opted out)
        if activeNominees == 0 {
            return true
        }
        
        // Validate total allocation based on number of active nominees
        switch activeNominees {
        case 1:
            if totalAllocation != 100 {
                showAlert(message: "Single nominee allocation must be 100%.\nCurrent total: \(totalAllocation)%")
                return false
            }
        case 2:
            if totalAllocation != 100 {
                showAlert(message: "Total allocation percentage for both nominees must be 100%.\nCurrent total: \(totalAllocation)%")
                return false
            }
        case 3:
            if totalAllocation != 100 {
                showAlert(message: "Total allocation percentage for all three nominees must be 100%.\nCurrent total: \(totalAllocation)%")
                return false
            }
        default:
            break
        }
        
        return true
    }
    
    func insertUpdateNomineeDetailsWebWithFullParams() {
        // Validate required fields before sending
        guard validateNomineeData() else {
            return
        }
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W", in: self.view
                ) { success in
                    if success {
                        self.insertUpdateNomineeDetailsWebWithFullParams()
                    } else {
                        print("Token generation failed.")
                    }
                }
                return
            }
            
            // Build flat parameters dictionary
            var parameters: [String: Any] = [
                "SessionId": fetchedSessionID ?? "",
                "TokenId": tokenId,
                "UserId": fetchedUserId ?? "",
                "PanNo": panNo ?? "",
                "RegId": RegId ?? "",
                "NomineeType": NomineeType,
                "DeviceType": "W",
            ]
            
            // MARK: - Nominee 1 Fields
            if nomineeCount >= 1 && !nominee1Stack.isHidden {
                // Validate required fields for Nominee 1
                guard let nomineeName = nomineeNameTxt1.text, !nomineeName.isEmpty,
                      let nomineeDOB = nomineeDob1.text, !nomineeDOB.isEmpty,
                      let documentId = documentId1.text, !documentId.isEmpty,
                      let sharePercentage = shareTxt1.text, !sharePercentage.isEmpty,
                      let relationId = relationID1, !relationId.isEmpty else {  // ✅ Use relationID instead of relation name
                    showAlert(message: "Please fill all required nominee details and select a valid relation")
                    return
                }
                
                // Add Nominee 1 basic details
                parameters["NOMINEE_1Prefix"] = "Mr." // or get from a prefix field if you have
                parameters["NOMINEE_1DocumentType"] = nomineedocumentType1 ?? ""
                parameters["NOMINEE_1DocumentExpiryDate"] = "" // Add if you have expiry date field
                parameters["NOMINEE_1NomineePanNoAadhar"] = documentId
                parameters["NOMINEE_1Name"] = nomineeName
                parameters["NOMINEE_1MobileNo"] = nomineeMobile1.text ?? ""
                parameters["NOMINEE_1EmailId"] = nomineeEmail1.text ?? ""
                parameters["NOMINEE_1DOB"] = formatDateForAPI(nomineeDOB)
                parameters["NOMINEE_1AddressSameAsApplicant"] = addressSameAsApplicantBtn1.isSelected ? 1 : 0
                parameters["NOMINEE_1Relation"] = relationId
                parameters["NOMINEE_1Percentage"] = sharePercentage
                parameters["NOMINEE_1NomineeMinor"] = nominee1IsMinor
                
                // Add Nominee 1 address (if not same as applicant)
                if !addressSameAsApplicantBtn1.isSelected {
                    parameters["NOMINEE_1Address1"] = addressTxtFirst1.text ?? ""
                    parameters["NOMINEE_1Address2"] = addressTxtSecond1.text ?? ""
                    parameters["NOMINEE_1Address3"] = addressTxtThird1.text ?? ""
                    parameters["NOMINEE_1City"] = cityTxt1.text ?? ""
                    parameters["NOMINEE_1State"] = stateTxt1.text ?? ""
                    parameters["NOMINEE_1PinCode"] = pinCodeTxt1.text ?? ""
                    parameters["NOMINEE_1Country"] = "India" // Default country
                } else {
                    parameters["NOMINEE_1Address1"] = ""
                    parameters["NOMINEE_1Address2"] = ""
                    parameters["NOMINEE_1Address3"] = ""
                    parameters["NOMINEE_1City"] = ""
                    parameters["NOMINEE_1State"] = ""
                    parameters["NOMINEE_1PinCode"] = ""
                    parameters["NOMINEE_1Country"] = ""
                }
                
                // Add Guardian details for Nominee 1 (if minor)
                if nominee1IsMinor == "Y" {
                    parameters["NOMINEE_1GuardianPrefix"] = "Mr."
                    parameters["NOMINEE_1GuardianName"] = minorNameTxt1.text ?? ""
                    parameters["NOMINEE_1GuardianDocumentType"] = guardiandocumentType1 ?? ""
                    parameters["NOMINEE_1GuardianDocumentExpiryDate"] = ""
                    parameters["NOMINEE_1GDocumentIDNumberADhar"] = guardianIdTxt1.text ?? ""
                    parameters["NOMINEE_1GMobileNo"] = guardianMobileTxt1.text ?? ""
                    parameters["NOMINEE_1GEmail"] = guardianEmailTxt1.text ?? ""
                    parameters["NOMINEE_1GuardianDOB"] = formatDateForAPI(guardianDobTxt1.text ?? "")
                    parameters["NOMINEE_1GuardianRelation"] = guardianRelationID1 ?? ""
                    parameters["NOMINEE_1SameAsNominee"] = nomineeSameAsBtn1.isSelected ? 1 : 0
                    
                    // Add guardian address
                    if !nomineeSameAsBtn1.isSelected {
                        parameters["NOMINEE_1GuardianAddress1"] = guardianAddressTxtFirst1.text ?? ""
                        parameters["NOMINEE_1GuardianAddress2"] = guardianAddressTxtSecond1.text ?? ""
                        parameters["NOMINEE_1GuardianAddress3"] = guardianAddressTxtThird1.text ?? ""
                        parameters["NOMINEE_1GuardianCity"] = guardianCityTxt1.text ?? ""
                        parameters["NOMINEE_1GuardianState"] = guardianStateTxt1.text ?? ""
                        parameters["NOMINEE_1GuardianPinCode"] = guardianPinCodeTxt1.text ?? ""
                        parameters["NOMINEE_1GuardianCountry"] = "India"
                    } else {
                        // Copy from nominee address if same as nominee
                        parameters["NOMINEE_1GuardianAddress1"] = parameters["NOMINEE_1Address1"] ?? ""
                        parameters["NOMINEE_1GuardianAddress2"] = parameters["NOMINEE_1Address2"] ?? ""
                        parameters["NOMINEE_1GuardianAddress3"] = parameters["NOMINEE_1Address3"] ?? ""
                        parameters["NOMINEE_1GuardianCity"] = parameters["NOMINEE_1City"] ?? ""
                        parameters["NOMINEE_1GuardianState"] = parameters["NOMINEE_1State"] ?? ""
                        parameters["NOMINEE_1GuardianPinCode"] = parameters["NOMINEE_1PinCode"] ?? ""
                        parameters["NOMINEE_1GuardianCountry"] = "India"
                    }
                }
            }
            
            // MARK: - Nominee 2 Fields
            if nomineeCount >= 2 && !nominee2Stack.isHidden {
                // Validate required fields for Nominee 1
                guard let nomineeName = nomineeNameTxt2.text, !nomineeName.isEmpty,
                      let nomineeDOB = nomineeDob2.text, !nomineeDOB.isEmpty,
                      let documentId = documentId2.text, !documentId.isEmpty,
                      let sharePercentage = shareTxt2.text, !sharePercentage.isEmpty,
                      let relationId = relationID2, !relationId.isEmpty else {  // ✅ Use relationID instead of relation name
                    showAlert(message: "Please fill all required nominee details and select a valid relation")
                    return
                }
                
                // Add Nominee 1 basic details
                parameters["NOMINEE_2Prefix"] = "Mr." // or get from a prefix field if you have
                parameters["NOMINEE_2DocumentType"] = nomineedocumentType2 ?? ""
                parameters["NOMINEE_2DocumentExpiryDate"] = "" // Add if you have expiry date field
                parameters["NOMINEE_2NomineePanNoAadhar"] = documentId
                parameters["NOMINEE_2Name"] = nomineeName
                parameters["NOMINEE_2MobileNo"] = nomineeMobile2.text ?? ""
                parameters["NOMINEE_2EmailId"] = nomineeEmail2.text ?? ""
                parameters["NOMINEE_2DOB"] = formatDateForAPI(nomineeDOB)
                parameters["NOMINEE_2AddressSameAsApplicant"] = addressSameAsApplicantBtn2.isSelected ? 1 : 0
                parameters["NOMINEE_2Relation"] = relationId
                parameters["NOMINEE_2Percentage"] = sharePercentage
                parameters["NOMINEE_2NomineeMinor"] = nominee2IsMinor
                
                // Add Nominee 1 address (if not same as applicant)
                if !addressSameAsApplicantBtn2.isSelected {
                    parameters["NOMINEE_2Address1"] = addressTxtFirst2.text ?? ""
                    parameters["NOMINEE_2Address2"] = addressTxtSecond2.text ?? ""
                    parameters["NOMINEE_2Address3"] = addressTxtThird2.text ?? ""
                    parameters["NOMINEE_2City"] = cityTxt2.text ?? ""
                    parameters["NOMINEE_2State"] = stateTxt2.text ?? ""
                    parameters["NOMINEE_2PinCode"] = pinCodeTxt2.text ?? ""
                    parameters["NOMINEE_2Country"] = "India" // Default country
                } else {
                    parameters["NOMINEE_2Address1"] = ""
                    parameters["NOMINEE_2Address2"] = ""
                    parameters["NOMINEE_2Address3"] = ""
                    parameters["NOMINEE_2City"] = ""
                    parameters["NOMINEE_2State"] = ""
                    parameters["NOMINEE_2PinCode"] = ""
                    parameters["NOMINEE_2Country"] = ""
                }
                
                // Add Guardian details for Nominee 1 (if minor)
                if nominee2IsMinor == "Y" {
                    parameters["NOMINEE_2GuardianPrefix"] = "Mr."
                    parameters["NOMINEE_2GuardianName"] = minorNameTxt2.text ?? ""
                    parameters["NOMINEE_2GuardianDocumentType"] = guardiandocumentType2 ?? ""
                    parameters["NOMINEE_2GuardianDocumentExpiryDate"] = ""
                    parameters["NOMINEE_2GDocumentIDNumberADhar"] = guardianIdTxt2.text ?? ""
                    parameters["NOMINEE_2GMobileNo"] = guardianMobileTxt2.text ?? ""
                    parameters["NOMINEE_2GEmail"] = guardianEmailTxt2.text ?? ""
                    parameters["NOMINEE_2GuardianDOB"] = formatDateForAPI(guardianDobTxt2.text ?? "")
                    parameters["NOMINEE_2GuardianRelation"] = guardianRelationID2 ?? ""
                    parameters["NOMINEE_2SameAsNominee"] = nomineeSameAsBtn2.isSelected ? 1 : 0
                    
                    // Add guardian address
                    if !nomineeSameAsBtn2.isSelected {
                        parameters["NOMINEE_2GuardianAddress1"] = guardianAddressTxtFirst2.text ?? ""
                        parameters["NOMINEE_2GuardianAddress2"] = guardianAddressTxtSecond2.text ?? ""
                        parameters["NOMINEE_2GuardianAddress3"] = guardianAddressTxtThird2.text ?? ""
                        parameters["NOMINEE_2GuardianCity"] = guardianCityTxt2.text ?? ""
                        parameters["NOMINEE_2GuardianState"] = guardianStateTxt2.text ?? ""
                        parameters["NOMINEE_2GuardianPinCode"] = guardianPinCodeTxt2.text ?? ""
                        parameters["NOMINEE_2GuardianCountry"] = "India"
                    } else {
                        // Copy from nominee address if same as nominee
                        parameters["NOMINEE_2GuardianAddress1"] = parameters["NOMINEE_2Address1"] ?? ""
                        parameters["NOMINEE_2GuardianAddress2"] = parameters["NOMINEE_2Address2"] ?? ""
                        parameters["NOMINEE_2GuardianAddress3"] = parameters["NOMINEE_2Address3"] ?? ""
                        parameters["NOMINEE_2GuardianCity"] = parameters["NOMINEE_2City"] ?? ""
                        parameters["NOMINEE_2GuardianState"] = parameters["NOMINEE_2State"] ?? ""
                        parameters["NOMINEE_2GuardianPinCode"] = parameters["NOMINEE_2PinCode"] ?? ""
                        parameters["NOMINEE_2GuardianCountry"] = "India"
                    }
                }
            }
            // MARK: - Nominee 3 Fields
            if nomineeCount >= 3 && !nominee3Stack.isHidden {
                // Validate required fields for Nominee 1
                guard let nomineeName = nomineeNameTxt3.text, !nomineeName.isEmpty,
                      let nomineeDOB = nomineeDob3.text, !nomineeDOB.isEmpty,
                      let documentId = documentId3.text, !documentId.isEmpty,
                      let sharePercentage = shareTxt3.text, !sharePercentage.isEmpty,
                      let relationId = relationID3, !relationId.isEmpty else {  // ✅ Use relationID instead of relation name
                    showAlert(message: "Please fill all required nominee details and select a valid relation")
                    return
                }
                
                // Add Nominee 1 basic details
                parameters["NOMINEE_3Prefix"] = "Mr." // or get from a prefix field if you have
                parameters["NOMINEE_3DocumentType"] = nomineedocumentType3 ?? ""
                parameters["NOMINEE_3DocumentExpiryDate"] = "" // Add if you have expiry date field
                parameters["NOMINEE_3NomineePanNoAadhar"] = documentId
                parameters["NOMINEE_3Name"] = nomineeName
                parameters["NOMINEE_3MobileNo"] = nomineeMobile3.text ?? ""
                parameters["NOMINEE_3EmailId"] = nomineeEmail3.text ?? ""
                parameters["NOMINEE_3DOB"] = formatDateForAPI(nomineeDOB)
                parameters["NOMINEE_3AddressSameAsApplicant"] = addressSameAsApplicantBtn3.isSelected ? 1 : 0
                parameters["NOMINEE_3Relation"] = relationId
                parameters["NOMINEE_3Percentage"] = sharePercentage
                parameters["NOMINEE_3NomineeMinor"] = nominee3IsMinor
                
                // Add Nominee 1 address (if not same as applicant)
                if !addressSameAsApplicantBtn3.isSelected {
                    parameters["NOMINEE_3Address1"] = addressTxtFirst3.text ?? ""
                    parameters["NOMINEE_3Address2"] = addressTxtSecond3.text ?? ""
                    parameters["NOMINEE_3Address3"] = addressTxtThird3.text ?? ""
                    parameters["NOMINEE_3City"] = cityTxt3.text ?? ""
                    parameters["NOMINEE_3State"] = stateTxt3.text ?? ""
                    parameters["NOMINEE_3PinCode"] = pinCodeTxt3.text ?? ""
                    parameters["NOMINEE_3Country"] = "India" // Default country
                } else {
                    parameters["NOMINEE_3Address1"] = ""
                    parameters["NOMINEE_3Address2"] = ""
                    parameters["NOMINEE_3Address3"] = ""
                    parameters["NOMINEE_3City"] = ""
                    parameters["NOMINEE_3State"] = ""
                    parameters["NOMINEE_3PinCode"] = ""
                    parameters["NOMINEE_3Country"] = ""
                }
                
                // Add Guardian details for Nominee 1 (if minor)
                if nominee3IsMinor == "Y" {
                    parameters["NOMINEE_3GuardianPrefix"] = "Mr."
                    parameters["NOMINEE_3GuardianName"] = minorNameTxt3.text ?? ""
                    parameters["NOMINEE_3GuardianDocumentType"] = guardiandocumentType3 ?? ""
                    parameters["NOMINEE_3GuardianDocumentExpiryDate"] = ""
                    parameters["NOMINEE_3GDocumentIDNumberADhar"] = guardianIdTxt3.text ?? ""
                    parameters["NOMINEE_3GMobileNo"] = guardianMobileTxt3.text ?? ""
                    parameters["NOMINEE_3GEmail"] = guardianEmailTxt3.text ?? ""
                    parameters["NOMINEE_3GuardianDOB"] = formatDateForAPI(guardianDobTxt3.text ?? "")
                    parameters["NOMINEE_3GuardianRelation"] = guardianRelationID3 ?? ""
                    parameters["NOMINEE_3SameAsNominee"] = nomineeSameAsBtn3.isSelected ? 1 : 0
                    
                    // Add guardian address
                    if !nomineeSameAsBtn3.isSelected {
                        parameters["NOMINEE_3GuardianAddress1"] = guardianAddressTxtFirst3.text ?? ""
                        parameters["NOMINEE_3GuardianAddress2"] = guardianAddressTxtSecond3.text ?? ""
                        parameters["NOMINEE_3GuardianAddress3"] = guardianAddressTxtThird3.text ?? ""
                        parameters["NOMINEE_3GuardianCity"] = guardianCityTxt3.text ?? ""
                        parameters["NOMINEE_3GuardianState"] = guardianStateTxt3.text ?? ""
                        parameters["NOMINEE_3GuardianPinCode"] = guardianPinCodeTxt3.text ?? ""
                        parameters["NOMINEE_3GuardianCountry"] = "India"
                    } else {
                        // Copy from nominee address if same as nominee
                        parameters["NOMINEE_3GuardianAddress1"] = parameters["NOMINEE_3Address1"] ?? ""
                        parameters["NOMINEE_3GuardianAddress2"] = parameters["NOMINEE_3Address2"] ?? ""
                        parameters["NOMINEE_3GuardianAddress3"] = parameters["NOMINEE_3Address3"] ?? ""
                        parameters["NOMINEE_3GuardianCity"] = parameters["NOMINEE_3City"] ?? ""
                        parameters["NOMINEE_3GuardianState"] = parameters["NOMINEE_3State"] ?? ""
                        parameters["NOMINEE_3GuardianPinCode"] = parameters["NOMINEE_3PinCode"] ?? ""
                        parameters["NOMINEE_3GuardianCountry"] = "India"
                    }
                }
            }
            
            print("📤 Full Nominee Submission Parameters: \(parameters)")
            
            let url = "NomineeDetails/InsertUpdateNomineeDetailsWeb"
            
            apiCall(url: url, method: "POST", parameters: parameters, view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("✅ InsertUpdateNomineeDetailsWeb Response: \(jsonResponse)")
                    
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            DispatchQueue.main.async {
                                
                                UserDefaults.standard.set(true, forKey: "NomineesSubmitted_\(self.panNo ?? "")")
                                UserDefaults.standard.synchronize()
                                
                                self.disableAllControlsAfterSubmission()
                                
                                let storyboard = UIStoryboard(name: "Document", bundle: Bundle.module)
                                if let nextVC = storyboard.instantiateViewController(withIdentifier: "DocumentVC") as? DocumentVC {
                                    nextVC.PanNo = self.panNo
                                    nextVC.RegId = self.RegId
                                    nextVC.delegate = self
                                    self.navigationController?.pushViewController(nextVC, animated: true)
                                }
                            }
                            
                        case "999992":
                            // Handle invalid/expired token
                            DispatchQueue.main.async {
                                print("⚠️ Token expired or invalid. Regenerating token...")
                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
                                print("All TokenMobile entries deleted due to error code 999992")
                                
                                // Regenerate token
                                CoreDataHelper.generateToken(
                                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
                                    USERID: self.fetchedUserId ?? "",
                                    SessionId: self.fetchedSessionID ?? "",
                                    entityName: "TokenMobile",
                                    deviceType: "W",
                                    in: self.view
                                ) { success in
                                    if success {
                                        print("✅ Token regenerated successfully. Retrying API call...")
                                        // Retry the API call
                                        self.insertUpdateNomineeDetailsWebWithFullParams()
                                    } else {
                                        print("❌ Token generation failed.")
                                        self.showAlert(message: "Session expired. Please login again.")
                                    }
                                }
                            }
                            
                        default:
                            DispatchQueue.main.async {
                                let errorMsg = jsonResponse["ErrorMessage"] as? String ?? "Error code: \(errorCode)"
                                self.showAlert(message: errorMsg)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(message: "Unknown response format. Please check your data and try again.")
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(message: "API call failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    func validateNomineeData() -> Bool {
        if nomineeCount >= 1 && !nominee1Stack.isHidden {
            // Check required fields
            if nomineeNameTxt1.text?.isEmpty ?? true {
                showAlert(message: "Please select Document Type")
                return false
            }
            
            if documentId1.text?.isEmpty ?? true {
                showAlert(message: "Please enter Document ID")
                return false
            }
            
            if nomineeNameTxt1.text?.isEmpty ?? true {
                showAlert(message: "Please enter nominee name")
                return false
            }
            if nomineeDob1.text?.isEmpty ?? true {
                showAlert(message: "Please select nominee date of birth")
                return false
            }
            if nomineeMobile1.text?.isEmpty ?? true {
                showAlert(message: "Please enter Mobile Number")
                return false
            }
            
            if nomineeEmail1.text?.isEmpty ?? true {
                showAlert(message: "Please enter E-mail")
                return false
            }
            
            if !addressSameAsApplicantBtn1.isSelected {
                
                if addressTxtFirst1.text?.isEmpty ?? true {
                    showAlert(message: "Please enter Address1")
                    return false
                }

                if pinCodeLbl1.text?.isEmpty ?? true {
                    showAlert(message: "Please enter Pin Code")
                    return false
                }
                
                if cityTxt1.text?.isEmpty ?? true {
                    showAlert(message: "Please enter City")
                    return false
                }
                
                if stateTxt1.text?.isEmpty ?? true {
                    showAlert(message: "Please enter State")
                    return false
                }
            }
            
            if shareTxt1.text?.isEmpty ?? true {
                showAlert(message: "Please enter share percentage")
                return false
            }
            guard let relationText = relationLbl1.text,
                  !relationText.isEmpty,
                  relationText != "Select Relation" else {
                showAlert(message: "Please select nominee relation for Nominee 1")
                return false
            }
            
            
            if !addressSameAsApplicantBtn1.isSelected {
                if let pincode = pinCodeTxt1.text, !pincode.isEmpty {
                    if pincode.count != 6 {
                        showAlert(message: "Please enter a valid 6-digit pincode")
                        return false
                    }
                }
            }
            
            // Validate mobile if provided
            if let mobile = nomineeMobile1.text, !mobile.isEmpty {
                if mobile.count != 10 {
                    showAlert(message: "Please enter a valid 10-digit mobile number")
                    return false
                }
            }
            
            // Validate email if provided
            if let email = nomineeEmail1.text, !email.isEmpty {
                if !isValidEmail(email) {
                    showAlert(message: "Please enter a valid email address")
                    return false
                }
            }
            
            if nominee1IsMinor == "Y" {
                if minorNameTxt1.text?.isEmpty ?? true {
                    showAlert(message: "Please enter guardian name for Nominee 1")
                    return false
                }
                
                if guardianDobTxt1.text?.isEmpty ?? true {
                    showAlert(message: "Please select guardian date of birth for Nominee 1")
                    return false
                }
                
                if guardianIdTxt1.text?.isEmpty ?? true {
                    showAlert(message: "Please enter guardian document ID for Nominee 1")
                    return false
                }
                
                if guardianMobileTxt1.text?.isEmpty ?? true {
                    showAlert(message: "Please enter guardian mobile number for Nominee 1")
                    return false
                }
                
                if let mobile = guardianMobileTxt1.text, !mobile.isEmpty {
                    if mobile.count != 10 {
                        showAlert(message: "Please enter a valid 10-digit mobile number for guardian")
                        return false
                    }
                }
                
                if guardianEmailTxt1.text?.isEmpty ?? true {
                    showAlert(message: "Please enter guardian email for Nominee 1")
                    return false
                }
                
                if let email = guardianEmailTxt1.text, !email.isEmpty {
                    if !isValidEmail(email) {
                        showAlert(message: "Please enter a valid email address for guardian")
                        return false
                    }
                }
                
                // Guardian Relation validation
                guard let guardianRelationText = guardianLbl1.text,
                      !guardianRelationText.isEmpty,
                      guardianRelationText != "Select Relation" else {
                    showAlert(message: "Please select guardian relation for Nominee 1")
                    return false
                }
                
                // Guardian Address validation (if not same as nominee)
                if !nomineeSameAsBtn1.isSelected {
                    if guardianAddressTxtFirst1.text?.isEmpty ?? true {
                        showAlert(message: "Please enter guardian address line 1")
                        return false
                    }

                    if guardianPinCodeTxt1.text?.isEmpty ?? true {
                        showAlert(message: "Please enter guardian pin code")
                        return false
                    }
                    
                    if let pincode = guardianPinCodeTxt1.text, !pincode.isEmpty {
                        if pincode.count != 6 {
                            showAlert(message: "Please enter a valid 6-digit pincode for guardian")
                            return false
                        }
                    }
                    
                    if guardianCityTxt1.text?.isEmpty ?? true {
                        showAlert(message: "Please enter guardian city")
                        return false
                    }
                    
                    if guardianStateTxt1.text?.isEmpty ?? true {
                        showAlert(message: "Please enter guardian state")
                        return false
                    }
                    
                }
            }
            
        }
        
        // Validation for Nominee 2
        if nomineeCount >= 2 && !nominee2Stack.isHidden {
            // Check required fields
            if nomineeNameTxt2.text?.isEmpty ?? true {
                showAlert(message: "Please select Document Type")
                return false
            }
            
            if documentId2.text?.isEmpty ?? true {
                showAlert(message: "Please enter Document ID")
                return false
            }
            
            if nomineeNameTxt2.text?.isEmpty ?? true {
                showAlert(message: "Please enter nominee name")
                return false
            }
            if nomineeDob2.text?.isEmpty ?? true {
                showAlert(message: "Please select nominee date of birth")
                return false
            }
            if nomineeMobile2.text?.isEmpty ?? true {
                showAlert(message: "Please enter Mobile Number")
                return false
            }
            
            if nomineeEmail2.text?.isEmpty ?? true {
                showAlert(message: "Please enter E-mail")
                return false
            }
            
            if !addressSameAsApplicantBtn2.isSelected {
                
                if addressTxtFirst2.text?.isEmpty ?? true {
                    showAlert(message: "Please enter Address1")
                    return false
                }
                
                if pinCodeLbl2.text?.isEmpty ?? true {
                    showAlert(message: "Please enter Pin Code")
                    return false
                }
                
                if cityTxt2.text?.isEmpty ?? true {
                    showAlert(message: "Please enter City")
                    return false
                }
                
                if stateTxt2.text?.isEmpty ?? true {
                    showAlert(message: "Please enter State")
                    return false
                }
            }
            
            if shareTxt2.text?.isEmpty ?? true {
                showAlert(message: "Please enter share percentage")
                return false
            }
            guard let relationText = relationLbl2.text,
                  !relationText.isEmpty,
                  relationText != "Select Relation" else {
                showAlert(message: "Please select nominee relation for Nominee 1")
                return false
            }
            
            
            
            if let pincode = pinCodeTxt2.text, !pincode.isEmpty {
                if pincode.count != 6 {
                    showAlert(message: "Please enter a valid 6-digit pincode")
                    return false
                }
            }
            
            
            // Validate mobile if provided
            if let mobile = nomineeMobile2.text, !mobile.isEmpty {
                if mobile.count != 10 {
                    showAlert(message: "Please enter a valid 10-digit mobile number")
                    return false
                }
            }
            
            // Validate email if provided
            if let email = nomineeEmail2.text, !email.isEmpty {
                if !isValidEmail(email) {
                    showAlert(message: "Please enter a valid email address")
                    return false
                }
            }
            
            if nominee2IsMinor == "Y" {
                if minorNameTxt2.text?.isEmpty ?? true {
                    showAlert(message: "Please enter guardian name for Nominee 2")
                    return false
                }
                
                if guardianDobTxt2.text?.isEmpty ?? true {
                    showAlert(message: "Please select guardian date of birth for Nominee 2")
                    return false
                }
                
                if guardianIdTxt2.text?.isEmpty ?? true {
                    showAlert(message: "Please enter guardian document ID for Nominee 2")
                    return false
                }
                
                if guardianMobileTxt2.text?.isEmpty ?? true {
                    showAlert(message: "Please enter guardian mobile number for Nominee 2")
                    return false
                }
                
                if let mobile = guardianMobileTxt2.text, !mobile.isEmpty {
                    if mobile.count != 10 {
                        showAlert(message: "Please enter a valid 10-digit mobile number for guardian")
                        return false
                    }
                }
                
                if guardianEmailTxt2.text?.isEmpty ?? true {
                    showAlert(message: "Please enter guardian email for Nominee 2")
                    return false
                }
                
                if let email = guardianEmailTxt2.text, !email.isEmpty {
                    if !isValidEmail(email) {
                        showAlert(message: "Please enter a valid email address for guardian")
                        return false
                    }
                }
                
                guard let guardianRelationText = guardianLbl2.text,
                      !guardianRelationText.isEmpty,
                      guardianRelationText != "Select Relation" else {
                    showAlert(message: "Please select guardian relation for Nominee 2")
                    return false
                }
                
                if !nomineeSameAsBtn2.isSelected {
                    if guardianAddressTxtFirst2.text?.isEmpty ?? true {
                        showAlert(message: "Please enter guardian address line 1")
                        return false
                    }
                    
//                    if guardianAddressTxtSecond2.text?.isEmpty ?? true {
//                        showAlert(message: "Please enter guardian address line 2")
//                        return false
//                    }
                    
                    if guardianPinCodeTxt2.text?.isEmpty ?? true {
                        showAlert(message: "Please enter guardian pin code")
                        return false
                    }
                    
                    if let pincode = guardianPinCodeTxt2.text, !pincode.isEmpty {
                        if pincode.count != 6 {
                            showAlert(message: "Please enter a valid 6-digit pincode for guardian")
                            return false
                        }
                    }
                    
                    if guardianCityTxt2.text?.isEmpty ?? true {
                        showAlert(message: "Please enter guardian city")
                        return false
                    }
                    
                    if guardianStateTxt2.text?.isEmpty ?? true {
                        showAlert(message: "Please enter guardian state")
                        return false
                    }
                }
            }
            
        }
        
        // Validation for Nominee 3
        if nomineeCount >= 3 && !nominee3Stack.isHidden {
            // Check required fields
            if nomineeNameTxt3.text?.isEmpty ?? true {
                showAlert(message: "Please select Document Type")
                return false
            }
            
            if documentId3.text?.isEmpty ?? true {
                showAlert(message: "Please enter Document ID")
                return false
            }
            
            if nomineeNameTxt3.text?.isEmpty ?? true {
                showAlert(message: "Please enter nominee name")
                return false
            }
            if nomineeDob3.text?.isEmpty ?? true {
                showAlert(message: "Please select nominee date of birth")
                return false
            }
            if nomineeMobile3.text?.isEmpty ?? true {
                showAlert(message: "Please enter Mobile Number")
                return false
            }
            
            if nomineeEmail3.text?.isEmpty ?? true {
                showAlert(message: "Please enter E-mail")
                return false
            }
            
            if !addressSameAsApplicantBtn3.isSelected {
                
                if addressTxtFirst3.text?.isEmpty ?? true {
                    showAlert(message: "Please enter Address1")
                    return false
                }
                
                if pinCodeLbl3.text?.isEmpty ?? true {
                    showAlert(message: "Please enter Pin Code")
                    return false
                }
                
                if cityTxt3.text?.isEmpty ?? true {
                    showAlert(message: "Please enter City")
                    return false
                }
                
                if stateTxt3.text?.isEmpty ?? true {
                    showAlert(message: "Please enter State")
                    return false
                }
            }
            
            if shareTxt3.text?.isEmpty ?? true {
                showAlert(message: "Please enter share percentage")
                return false
            }
            guard let relationText = relationLbl3.text,
                  !relationText.isEmpty,
                  relationText != "Select Relation" else {
                showAlert(message: "Please select nominee relation for Nominee 1")
                return false
            }
            
            
            if !addressSameAsApplicantBtn3.isSelected {
                if let pincode = pinCodeTxt3.text, !pincode.isEmpty {
                    if pincode.count != 6 {
                        showAlert(message: "Please enter a valid 6-digit pincode")
                        return false
                    }
                }
            }
            
            // Validate mobile if provided
            if let mobile = nomineeMobile3.text, !mobile.isEmpty {
                if mobile.count != 10 {
                    showAlert(message: "Please enter a valid 10-digit mobile number")
                    return false
                }
            }
            
            // Validate email if provided
            if let email = nomineeEmail3.text, !email.isEmpty {
                if !isValidEmail(email) {
                    showAlert(message: "Please enter a valid email address")
                    return false
                }
            }
            if nominee3IsMinor == "Y" {
                if minorNameTxt3.text?.isEmpty ?? true {
                    showAlert(message: "Please enter guardian name for Nominee 3")
                    return false
                }
                
                if guardianDobTxt3.text?.isEmpty ?? true {
                    showAlert(message: "Please select guardian date of birth for Nominee 3")
                    return false
                }
                
                if guardianIdTxt3.text?.isEmpty ?? true {
                    showAlert(message: "Please enter guardian document ID for Nominee 3")
                    return false
                }
                
                if guardianMobileTxt3.text?.isEmpty ?? true {
                    showAlert(message: "Please enter guardian mobile number for Nominee 3")
                    return false
                }
                
                if let mobile = guardianMobileTxt3.text, !mobile.isEmpty {
                    if mobile.count != 10 {
                        showAlert(message: "Please enter a valid 10-digit mobile number for guardian")
                        return false
                    }
                }
                
                if guardianEmailTxt3.text?.isEmpty ?? true {
                    showAlert(message: "Please enter guardian email for Nominee 3")
                    return false
                }
                
                if let email = guardianEmailTxt3.text, !email.isEmpty {
                    if !isValidEmail(email) {
                        showAlert(message: "Please enter a valid email address for guardian")
                        return false
                    }
                }
                
                guard let guardianRelationText = guardianLbl3.text,
                      !guardianRelationText.isEmpty,
                      guardianRelationText != "Select Relation" else {
                    showAlert(message: "Please select guardian relation for Nominee 3")
                    return false
                }
                
                if !nomineeSameAsBtn3.isSelected {
                    if guardianAddressTxtFirst3.text?.isEmpty ?? true {
                        showAlert(message: "Please enter guardian address line 1")
                        return false
                    }
                    
//                    if guardianAddressTxtSecond3.text?.isEmpty ?? true {
//                        showAlert(message: "Please enter guardian address line 2")
//                        return false
//                    }
                    
                    if guardianPinCodeTxt3.text?.isEmpty ?? true {
                        showAlert(message: "Please enter guardian pin code")
                        return false
                    }
                    
                    if let pincode = guardianPinCodeTxt3.text, !pincode.isEmpty {
                        if pincode.count != 6 {
                            showAlert(message: "Please enter a valid 6-digit pincode for guardian")
                            return false
                        }
                    }
                    
                    if guardianCityTxt3.text?.isEmpty ?? true {
                        showAlert(message: "Please enter guardian city")
                        return false
                    }
                    
                    if guardianStateTxt3.text?.isEmpty ?? true {
                        showAlert(message: "Please enter guardian state")
                        return false
                    }
                }
            }
        }
        
        return true
    }
}

extension NomineeVC: UITextFieldDelegate {
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            // Handle mobile number fields - only digits, max 10 digits
            if textField == nomineeMobile1 || textField == nomineeMobile2 || textField == nomineeMobile3 ||
                textField == guardianMobileTxt1 || textField == guardianMobileTxt2 || textField == guardianMobileTxt3 {
                
                // Allow only digits
                let allowedCharacters = CharacterSet.decimalDigits
                let characterSet = CharacterSet(charactersIn: string)
                let isDigit = allowedCharacters.isSuperset(of: characterSet)
                
                if !isDigit && !string.isEmpty {
                    return false
                }
                
                let currentText = textField.text ?? ""
                let newLength = currentText.count + string.count - range.length
                return newLength <= 10
            }
            
            // Handle pincode fields - only digits, max 6 digits
            if textField == pinCodeTxt1 || textField == pinCodeTxt2 || textField == pinCodeTxt3 ||
                textField == guardianPinCodeTxt1 || textField == guardianPinCodeTxt2 || textField == guardianPinCodeTxt3 {
                
                let allowedCharacters = CharacterSet.decimalDigits
                let characterSet = CharacterSet(charactersIn: string)
                let isDigit = allowedCharacters.isSuperset(of: characterSet)
                
                if !isDigit && !string.isEmpty {
                    return false
                }
                
                let currentText = textField.text ?? ""
                let newLength = currentText.count + string.count - range.length
                return newLength <= 6
            }
            
            // Handle email fields - convert to lowercase
            if textField == nomineeEmail1 || textField == nomineeEmail2 || textField == nomineeEmail3 ||
                textField == guardianEmailTxt1 || textField == guardianEmailTxt2 || textField == guardianEmailTxt3 {
                
                // Convert email to lowercase
                let lowercaseString = string.lowercased()
                
                if let currentText = textField.text as NSString? {
                    let newText = currentText.replacingCharacters(in: range, with: lowercaseString)
                    textField.text = newText
                    return false
                }
                
                return true
            }
            
            // Handle all other text fields - convert to uppercase
            let uppercaseString = string.uppercased()
            
            if let currentText = textField.text as NSString? {
                let newText = currentText.replacingCharacters(in: range, with: uppercaseString)
                textField.text = newText
                return false
            }
            
            return true
        }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Ensure final text is uppercase for non-email fields
        if textField == nomineeEmail1 || textField == nomineeEmail2 || textField == nomineeEmail3 ||
            textField == guardianEmailTxt1 || textField == guardianEmailTxt2 || textField == guardianEmailTxt3 {
            // Validate email format
            if let email = textField.text, !email.isEmpty {
                if !isValidEmail(email) {
                    showAlert(message: "Please enter a valid email address")
                    textField.text = ""
                }
            }
        } else if textField == nomineeMobile1 || textField == nomineeMobile2 || textField == nomineeMobile3 ||
                    textField == guardianMobileTxt1 || textField == guardianMobileTxt2 || textField == guardianMobileTxt3 {
            // Validate mobile number length
            if let mobile = textField.text, !mobile.isEmpty {
                       if !isValidMobileNumber(mobile) {
                           if mobile.count != 10 {
                               showAlert(message: "Please enter a valid 10-digit mobile number")
                           } else if isSequentialNumber(mobile) {
                               showAlert(message: "Sequential numbers like 1234567890 or 0987654321 are not allowed")
                           } else if isRepeatedDigit(mobile) {
                               showAlert(message: "Repeated digits like \(mobile) are not allowed")
                           } else {
                               showAlert(message: "Please enter a valid mobile number")
                           }
                           textField.text = ""
                       }
                   }
               } else {
            // For all other fields, convert to uppercase
            textField.text = textField.text?.uppercased()
        }
        
        // Check which pincode field triggered the event
        switch textField {
        case pinCodeTxt1:
            if let pincode = pinCodeTxt1.text, pincode.count == 6 {
                validatePinCode(pinCode: pincode, for: "nominee", index: 1)
            }
        case pinCodeTxt2:
            if let pincode = pinCodeTxt2.text, pincode.count == 6 {
                validatePinCode(pinCode: pincode, for: "nominee", index: 2)
            }
        case pinCodeTxt3:
            if let pincode = pinCodeTxt3.text, pincode.count == 6 {
                validatePinCode(pinCode: pincode, for: "nominee", index: 3)
            }
        case guardianPinCodeTxt1:
            if let pincode = guardianPinCodeTxt1.text, pincode.count == 6 {
                validatePinCode(pinCode: pincode, for: "guardian", index: 1)
            }
        case guardianPinCodeTxt2:
            if let pincode = guardianPinCodeTxt2.text, pincode.count == 6 {
                validatePinCode(pinCode: pincode, for: "guardian", index: 2)
            }
        case guardianPinCodeTxt3:
            if let pincode = guardianPinCodeTxt3.text, pincode.count == 6 {
                validatePinCode(pinCode: pincode, for: "guardian", index: 3)
            }
        default:
            break
        }
    }
    
    func isValidMobileNumber(_ mobile: String) -> Bool {
        // Check if it's exactly 10 digits
        let mobileRegex = "^[0-9]{10}$"
        guard NSPredicate(format: "SELF MATCHES %@", mobileRegex).evaluate(with: mobile) else {
            return false
        }
        
        // Check for sequential numbers (1234567890, 0987654321)
        if isSequentialNumber(mobile) {
            return false
        }
        
        // Check for repeated same digit (1111111111, 2222222222, etc.)
        if isRepeatedDigit(mobile) {
            return false
        }
        
        return true
    }

    func isSequentialNumber(_ mobile: String) -> Bool {
        let ascending = "1234567890"
        let descending = "0987654321"
        return mobile == ascending || mobile == descending
    }

    func isRepeatedDigit(_ mobile: String) -> Bool {
        guard let firstChar = mobile.first else { return false }
        return mobile.allSatisfy { $0 == firstChar }
    }

    func areMobileNumbersUnique() -> Bool {
        var mobileNumbers: [String] = []
        
        // Collect all nominee mobile numbers
        if nomineeCount >= 1 && !nominee1Stack.isHidden, let mobile = nomineeMobile1.text, !mobile.isEmpty {
            mobileNumbers.append(mobile)
        }
        if nomineeCount >= 2 && !nominee2Stack.isHidden, let mobile = nomineeMobile2.text, !mobile.isEmpty {
            mobileNumbers.append(mobile)
        }
        if nomineeCount >= 3 && !nominee3Stack.isHidden, let mobile = nomineeMobile3.text, !mobile.isEmpty {
            mobileNumbers.append(mobile)
        }
        
        // Collect all guardian mobile numbers
        if nomineeCount >= 1 && nominee1IsMinor == "Y", let mobile = guardianMobileTxt1.text, !mobile.isEmpty {
            mobileNumbers.append(mobile)
        }
        if nomineeCount >= 2 && nominee2IsMinor == "Y", let mobile = guardianMobileTxt2.text, !mobile.isEmpty {
            mobileNumbers.append(mobile)
        }
        if nomineeCount >= 3 && nominee3IsMinor == "Y", let mobile = guardianMobileTxt3.text, !mobile.isEmpty {
            mobileNumbers.append(mobile)
        }
        
        // Check for duplicates
        let uniqueSet = Set(mobileNumbers)
        return mobileNumbers.count == uniqueSet.count
    }
        
    
    func disableVerifyButtons(for nomineeIndex: Int, isGuardian: Bool = false) {
        DispatchQueue.main.async {
            if isGuardian {
                switch nomineeIndex {
                case 1:
                    self.guardianVerifyBtn1.isEnabled = false
                    self.guardianVerifyBtn1.alpha = 0.5
                case 2:
                    self.guardianVerifyBtn2.isEnabled = false
                    self.guardianVerifyBtn2.alpha = 0.5
                case 3:
                    self.guardianVerifyBtn3.isEnabled = false
                    self.guardianVerifyBtn3.alpha = 0.5
                default:
                    break
                }
            } else {
                switch nomineeIndex {
                case 1:
                    self.documentVerifyBtn1.isEnabled = false
                    self.documentVerifyBtn1.alpha = 0.5
                case 2:
                    self.documentVerifyBtn2.isEnabled = false
                    self.documentVerifyBtn2.alpha = 0.5
                case 3:
                    self.documentVerifyBtn3.isEnabled = false
                    self.documentVerifyBtn3.alpha = 0.5
                default:
                    break
                }
            }
        }
    }
    
    func getGuardianRelationName(from id: Int) -> String {
        // Map the relation IDs to their display names
        // You'll need to adjust these values based on your actual relation types
        let relationMap: [Int: String] = [
            1: "Father",
            2: "Mother",
            3: "Brother",
            4: "Sister",
            5: "Grand Father",
            6: "Grand Mother",
            7: "Uncle",
            8: "Aunt",
            9: "Legal Guardian",
            // Add more mappings as needed
        ]
        
        return relationMap[id] ?? "Select Relation"
    }
}
