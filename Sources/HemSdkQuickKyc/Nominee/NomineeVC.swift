//
//  NomineeVC.swift
//  t5
//
//  Created by manas dutta on 21/02/26.
//


import UIKit

class NomineeVC: UIViewController, @MainActor SelectionDelegate, @MainActor VerticsVCDelegate, @MainActor CalenderVCDelegate, @MainActor DigiLocker_b_VCDelegate1, @MainActor ReloadPageDelegate, @MainActor RelationshipScheme {
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
            print("   → Setting Nominee 2 button to \(type)")
            if #available(iOS 15.0, *) {
                self.documentTypeBtn2.configuration?.title = type
            } else {
                self.documentTypeBtn2.setTitle(type, for: .normal)
            }
            
            nomineedocumentType2 = type
            if type == "Aadhaar" {
                saveDigiLocker(identifier1: "NomineeDocument2")
            }
            
        case "NomineeDocument3":
            print("   → Setting Nominee 3 button to \(type)")
            if #available(iOS 15.0, *) {
                self.documentTypeBtn3.configuration?.title = type
            } else {
                self.documentTypeBtn3.setTitle(type, for: .normal)
            }
            nomineedocumentType3 = type
            if type == "Aadhaar" {
                saveDigiLocker(identifier1: "NomineeDocument3")
            }
            
            // MARK: - Guardian Documents (Fixed wrong button names)
        case "guardianDocument1":
            print("   → Setting Guardian 1 button to \(type)")
            if #available(iOS 15.0, *) {
                self.guardianDocumentTypeBtn1.configuration?.title = type
            } else {
                self.guardianDocumentTypeBtn1.setTitle(type, for: .normal)
            }
            
            guardiandocumentType1 = type
            if type == "Aadhaar" {
                saveDigiLocker(identifier1: "guardianDocument1")
            }
            
        case "guardianDocument2":
            print("   → Setting Guardian 2 button to \(type)")
            if #available(iOS 15.0, *) {
                self.guardianDocumentTypeBtn2.configuration?.title = type
            } else {
                self.guardianDocumentTypeBtn2.setTitle(type, for: .normal)
            }
            
            guardiandocumentType2 = type
            if type == "Aadhaar" {
                saveDigiLocker(identifier1: "guardianDocument2")
            }
            
        case "guardianDocument3":
            print("   → Setting Guardian 3 button to \(type)")
            if #available(iOS 15.0, *) {
                self.guardianDocumentTypeBtn3.configuration?.title = type
            } else {
                self.guardianDocumentTypeBtn3.setTitle(type, for: .normal)
            }
            
            guardiandocumentType3 = type
            if type == "Aadhaar" {
                saveDigiLocker(identifier1: "guardianDocument3")
            }
            
        default:
            print("→ Unknown identifier: \(identifier)")
            break
        }
    }
    
    func updateButtonTitle(_ button: UIButton, title: String) {
        if #available(iOS 15.0, *) {
            if var config = button.configuration {
                config.title = title
                button.configuration = config
            } else {
                // Fallback if configuration is nil
                button.setTitle(title, for: .normal)
            }
        } else {
            button.setTitle(title, for: .normal)
        }
    }

    func didReceiveApiResponse(data: [String : Any], identifier1: String, identifier3: String) {
        DispatchQueue.main.async {
            
            print("🔥 identifier1 received:", identifier1)
            print("🔥 API DATA:", data)
            // 1. Auto-fill the correct nominee's fields
            switch identifier1 {
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
        
        switch identifier {
            
        case "nomineeDOB1":
            nomineeDob1.text = date
            if let age = calculateAge(from: date) {
                toggleGuardianFields(for: 1, show: age < 18)
            }
            
        case "nomineeDOB2":
            nomineeDob2.text = date
            if let age = calculateAge(from: date) {
                toggleGuardianFields(for: 2, show: age < 18)
            }
            
        case "nomineeDOB3":
            nomineeDob3.text = date
            if let age = calculateAge(from: date) {
                toggleGuardianFields(for: 3, show: age < 18)
                NomineeMinor = age < 18 ? "Y" : "N"
            }
            
        case "guardianDOB1":
            guardianDobTxt1.text = date
            if let age = calculateAge(from: date) {
                // toggleGuardianHolderViews(show: age < 18)
                NomineeMinor = "Y"
            }
            
        case "guardianDOB2":
            guardianDobTxt2.text = date
            if let age = calculateAge(from: date) {
                // toggleGuardianHolderViews(show: age < 18)
                NomineeMinor = "Y"
            }
            
        case "guardianDOB3":
            guardianDobTxt3.text = date
            if let age = calculateAge(from: date) {
                // toggleGuardianHolderViews(show: age < 18)
                NomineeMinor = "Y"
            }
            
        default:
            break
        }
    }
    
    func didDismissDigiLockerVC() {
        self.dismiss(animated: true)
    }
    
    func reloadPageData() {
        self.ViewAllNomineeDetails()
    }
    
    func didSelectRelation(type: String, id: String, identifier: String) {
        switch identifier {
        case "nomineeRelation1":
            self.updateButtonTitle(self.relationBtn1, title: type)
                  self.relationID1 = id
                  print("✅ Set relation for nominee 1: \(type) (ID: \(id))")
        case "nomineeRelation2":
            relationBtn2.setTitle(type, for: .normal)
            relationID2 = id
        case "nomineeRelation3":
            relationBtn3.setTitle(type, for: .normal)
            relationID3 = id
        case "guardianRelation1":
            guardianRelationBtn1.setTitle(type, for: .normal)
            guardianRelationID1 = id
        case "guardianRelation2":
            guardianRelationBtn2.setTitle(type, for: .normal)
            guardianRelationID2 = id
        case "guardianRelation3":
            guardianRelationBtn3.setTitle(type, for: .normal)
            guardianRelationID3 = id
        default:
            break
        }
    }
    
    
    @IBOutlet weak var optInBtn: UIButton!
    @IBOutlet weak var optOutBtn: UIButton!
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
    @IBOutlet weak var minorNameLbl1: UILabel!
    @IBOutlet weak var minorNameTxt1: UITextField!
    @IBOutlet weak var guardianDobLbl1: UILabel!
    @IBOutlet weak var guardianNameTxt1: UITextField!
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
    @IBOutlet weak var minorNameLbl2: UILabel!
    @IBOutlet weak var minorNameTxt2: UITextField!
    @IBOutlet weak var guardianDobLbl2: UILabel!
    @IBOutlet weak var guardianNameTxt2: UITextField!
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
    @IBOutlet weak var minorNameLbl3: UILabel!
    @IBOutlet weak var minorNameTxt3: UITextField!
    @IBOutlet weak var guardianDobLbl3: UILabel!
    @IBOutlet weak var guardianNameTxt3: UITextField!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNomineeBtn.isHidden = true
        
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
        optInBtn.tintColor = .appPrimary
        optOutBtn.tintColor = .appPrimary
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
        //populateNomineeFieldsArrays()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Only fetch nominee details if user has opted in
        if optInBtn.isSelected {
            ViewAllNomineeDetails()
        }
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
    
    @IBAction func optInTapped(_ sender: UIButton) {
        optInBtn.isSelected = true
        optOutBtn.isSelected = false
        
        addNomineeBtn.isHidden = false
    }
    
    @IBAction func optOutTapped(_ sender: UIButton) {
        optInBtn.isSelected = false
        optOutBtn.isSelected = true
        
        addNomineeBtn.isHidden = true
        
        // Hide all nominee stacks
        nominee1Stack.isHidden = true
        nominee2Stack.isHidden = true
        nominee3Stack.isHidden = true
        
        nomineeCount = 0
    }
    
    
    @IBAction func Nominee1Btn(_ sender: UIButton) {
        isNominee1Expanded.toggle()
         
         // Hide/show all arranged subviews except the first one (the header button)
         for (index, view) in nominee1Stack.arrangedSubviews.enumerated() {
             if index != 0 { // Skip the header button
                 view.isHidden = !isNominee1Expanded
             }
         }
    }
    
    @IBAction func Nominee2Btn(_ sender: UIButton) {
        isNominee2Expanded.toggle()
         
         // Hide/show all arranged subviews except the first one (the header button)
         for (index, view) in nominee2Stack.arrangedSubviews.enumerated() {
             if index != 0 { // Skip the header button
                 view.isHidden = !isNominee2Expanded
             }
         }
    }
    
    @IBAction func Nominee3Btn(_ sender: UIButton) {
        isNominee3Expanded.toggle()
         
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
        
//        switch index {
//        case 1:
//            // Nominee fields
//            nomineeNameTxt1.text = name
//            nomineeDob1.text = dob
//            documentId1.text = uid
//            nomineeMobile1.text = mobile
//            nomineeEmail1.text = email
//            
//            // Address fields
//            addressTxtFirst1.text = address1
//            addressTxtSecond1.text = address2
//            addressTxtThird1.text = address3
//            cityTxt1.text = city
//            stateTxt1.text = state
//            pinCodeTxt1.text = pincode
//            
//            // Set document type
//            documentTypeBtn1.setTitle("Aadhaar", for: .normal)
//            nomineedocumentType1 = "Aadhaar"
//            
//            // Disable fields after verification
//            nomineeNameTxt1.isEnabled = false
//            nomineeDob1.isEnabled = false
//            documentId1.isEnabled = false
//            documentTypeBtn1.isEnabled = false
//            addressTxtFirst1.isEnabled = false
//            addressTxtSecond1.isEnabled = false
//            addressTxtThird1.isEnabled = false
//            pinCodeTxt1.isEnabled = false
//            cityTxt1.isEnabled = false
//            stateTxt1.isEnabled = false
//            
//        case 2:
//            // Nominee fields
//            nomineeNameTxt2.text = name
//            nomineeDob2.text = dob
//            documentId2.text = uid
//            nomineeMobile2.text = mobile
//            nomineeEmail2.text = email
//            
//            // Address fields
//            addressTxtFirst2.text = address1
//            addressTxtSecond2.text = address2
//            addressTxtThird2.text = address3
//            cityTxt2.text = city
//            stateTxt2.text = state
//            pinCodeTxt2.text = pincode
//            
//            // Set document type
//            documentTypeBtn2.setTitle("Aadhaar", for: .normal)
//            nomineedocumentType2 = "Aadhaar"
//            
//            // Disable fields
//            nomineeNameTxt2.isEnabled = false
//            nomineeDob2.isEnabled = false
//            documentId2.isEnabled = false
//            documentTypeBtn2.isEnabled = false
//            addressTxtFirst2.isEnabled = false
//            addressTxtSecond2.isEnabled = false
//            addressTxtThird2.isEnabled = false
//            pinCodeTxt1.isEnabled = false
//            cityTxt2.isEnabled = false
//            stateTxt2.isEnabled = false
//            
//        case 3:
//            // Nominee fields
//            nomineeNameTxt3.text = name
//            nomineeDob3.text = dob
//            documentId3.text = uid
//            nomineeMobile3.text = mobile
//            nomineeEmail3.text = email
//            
//            // Address fields
//            addressTxtFirst3.text = address1
//            addressTxtSecond3.text = address2
//            addressTxtThird3.text = address3
//            cityTxt3.text = city
//            stateTxt3.text = state
//            pinCodeTxt1.text = pincode
//            
//            // Set document type
//            documentTypeBtn3.setTitle("Aadhaar", for: .normal)
//            nomineedocumentType3 = "Aadhaar"
//            
//            // Disable fields
//            nomineeNameTxt3.isEnabled = false
//            nomineeDob3.isEnabled = false
//            documentId3.isEnabled = false
//            documentTypeBtn3.isEnabled = false
//            addressTxtFirst3.isEnabled = false
//            addressTxtSecond3.isEnabled = false
//            addressTxtThird3.isEnabled = false
//            pinCodeTxt1.isEnabled = false
//            cityTxt3.isEnabled = false
//            stateTxt3.isEnabled = false
//            
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
            minorNameLbl1?.isHidden = !show
            minorNameTxt1?.isHidden = !show
            guardianNameTxt1?.isHidden = !show
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
            
        case 2:
            gurdianLbl2?.isHidden = !show
            guardianTypeLbl2?.isHidden = !show
            guardianDocumentTypeBtn2?.isHidden = !show
            minorNameLbl2?.isHidden = !show
            minorNameTxt2?.isHidden = !show
            guardianNameTxt2?.isHidden = !show
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
            
        case 3:
            gurdianLbl3?.isHidden = !show
            guardianTypeLbl3?.isHidden = !show
            guardianDocumentTypeBtn3?.isHidden = !show
            minorNameLbl3?.isHidden = !show
            minorNameTxt3?.isHidden = !show
            guardianNameTxt3?.isHidden = !show
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
                self.guardianNameTxt1.text = name
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
                
            case 2:
                self.guardianNameTxt2.text = name
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
                
            case 3:
                self.guardianNameTxt3.text = name
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
            relationApplicantLbl1, relationBtn1, shareLbl1, shareTxt1,
            gurdianLbl1, guardianTypeLbl1, guardianDocumentTypeBtn1,
            minorNameLbl1, minorNameTxt1, guardianNameTxt1,
            guardianDobLbl1, guardianDobBtn1, guardianDobTxt1,
            guardianIDLbl1, guardianIdTxt1, guardianVerifyBtn1,
            guardianMobileLbl1, guardianMobileTxt1,
            guardianEmailLbl1, guardianEmailTxt1,
            guardianRelationLbl1, guardianRelationBtn1,
            nomineeSameAsBtn1,
            guardianAddressLblFirst1, guardianAddressTxtFirst1,
            guardianAddressLblSecond1, guardianAddressTxtSecond1,
            guardianAddressLblThird1, guardianAddressTxtThird1,
            guardianPinCodeLbl1, guardianPinCodeTxt1,
            guardianCityLbl1, guardianCityTxt1,
            guardianStateLbl1, guardianStateTxt1
        ]
        
        nominee2Fields = [
            documentTypeLbl2, documentTypeBtn2, documentId2, documentVerifyBtn2,
            nomineeNameTxt2, nomineeDob2, nomineeDobBtn2, nomineeMobile2, nomineeEmail2,
            addressSameAsApplicantBtn2, addressLblFirst2, addressTxtFirst2,
            addressLblSecond2, addressTxtSecond2, addressLblThird2, addressTxtThird2,
            pinCodeLbl2, pinCodeTxt2, cityLbl2, cityTxt2, stateLbl2, stateTxt2,
            relationApplicantLbl2, relationBtn2, shareLbl2, shareTxt2,
            gurdianLbl2, guardianTypeLbl2, guardianDocumentTypeBtn2,
            minorNameLbl2, minorNameTxt2, guardianNameTxt2,
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
            guardianStateLbl2, guardianStateTxt2
        ]
        
        nominee2Fields = [
            documentTypeLbl3, documentTypeBtn3, documentId3, documentVerifyBtn3,
            nomineeNameTxt3, nomineeDob3, nomineeDobBtn3, nomineeMobile3, nomineeEmail3,
            addressSameAsApplicantBtn3, addressLblFirst3, addressTxtFirst3,
            addressLblSecond3, addressTxtSecond3, addressLblThird3, addressTxtThird3,
            pinCodeLbl3, pinCodeTxt3, cityLbl3, cityTxt3, stateLbl3, stateTxt3,
            relationApplicantLbl3, relationBtn3, shareLbl3, shareTxt3,
            gurdianLbl3, guardianTypeLbl3, guardianDocumentTypeBtn3,
            minorNameLbl3, minorNameTxt3, guardianNameTxt3,
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
            guardianStateLbl3, guardianStateTxt3
        ]
    }
    
    
    func saveDigiLocker(identifier1 : String) {
        digiIdentifier = identifier1
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
                "PanNo": panNo,
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
                                    self.optOutBtn.isSelected = true
                                    self.optInBtn.isSelected = false
                                    self.addNomineeBtn.isHidden = true
                                    self.nominee1Stack.isHidden = true
                                    self.nominee2Stack.isHidden = true
                                    self.nominee3Stack.isHidden = true
                                    self.nomineeCount = 0
                                } else if IsNominate == "Y" {
                                    self.optInBtn.isSelected = true
                                    self.optOutBtn.isSelected = false
                                    
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
        // Show appropriate number of nominee stacks based on data count
        nomineeCount = nomineeDetailsArray.count
        
        for (index, nomineeData) in nomineeDetailsArray.enumerated() {
            let nomineeIndex = index + 1
            
            // Show the stack view
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
        
        // Hide add button if max reached
        addNomineeBtn.isHidden = (nomineeCount >= 3)
    }

    func populateNomineeData(_ data: [String: Any], for index: Int) {
        switch index {
        case 1:
            nomineeNameTxt1.text = data["NomineeName"] as? String ?? ""
            nomineeDob1.text = data["NomineeDOB"] as? String ?? ""
            documentId1.text = data["NomineeDocumentId"] as? String ?? ""
            nomineeMobile1.text = data["NomineeMobile"] as? String ?? ""
            nomineeEmail1.text = data["NomineeEmail"] as? String ?? ""
            shareTxt1.text = data["SharePercentage"] as? String ?? ""
            relationBtn1.setTitle(data["NomineeRelation"] as? String ?? "", for: .normal)
            
            // Set document type button title
            let docType = data["NomineeDocumentType"] as? String ?? ""
            documentTypeBtn1.setTitle(docType, for: .normal)
            nomineedocumentType1 = docType
            
            // Address fields
            if data["IsAddressSameAsApplicant"] as? String == "Y" {
                addressSameAsApplicantBtn1.isSelected = true
                hideNomineeAddress1(true)
            } else {
                addressTxtFirst1.text = data["NomineeAddress1"] as? String ?? ""
                addressTxtSecond1.text = data["NomineeAddress2"] as? String ?? ""
                addressTxtThird1.text = data["NomineeAddress3"] as? String ?? ""
                cityTxt1.text = data["NomineeCity"] as? String ?? ""
                stateTxt1.text = data["NomineeState"] as? String ?? ""
                pinCodeTxt1.text = data["NomineePinCode"] as? String ?? ""
            }
            
            // Guardian fields if minor
            if let isMinor = data["IsMinor"] as? String, isMinor == "Y" {
                toggleGuardianFields(for: 1, show: true)
                guardianNameTxt1.text = data["GuardianName"] as? String ?? ""
                guardianDobTxt1.text = data["GuardianDOB"] as? String ?? ""
                guardianIdTxt1.text = data["GuardianDocumentId"] as? String ?? ""
                guardianMobileTxt1.text = data["GuardianMobile"] as? String ?? ""
                guardianEmailTxt1.text = data["GuardianEmail"] as? String ?? ""
                guardianRelationBtn1.setTitle(data["GuardianRelation"] as? String ?? "", for: .normal)
            }
            
        case 2:
            // Similar population for nominee 2
            nomineeNameTxt2.text = data["NomineeName"] as? String ?? ""
            nomineeDob2.text = data["NomineeDOB"] as? String ?? ""
            documentId2.text = data["NomineeDocumentId"] as? String ?? ""
            nomineeMobile2.text = data["NomineeMobile"] as? String ?? ""
            nomineeEmail2.text = data["NomineeEmail"] as? String ?? ""
            shareTxt2.text = data["SharePercentage"] as? String ?? ""
            relationBtn2.setTitle(data["NomineeRelation"] as? String ?? "", for: .normal)
            
            let docType = data["NomineeDocumentType"] as? String ?? ""
            documentTypeBtn2.setTitle(docType, for: .normal)
            nomineedocumentType2 = docType
            
            if data["IsAddressSameAsApplicant"] as? String == "Y" {
                addressSameAsApplicantBtn2.isSelected = true
                hideNomineeAddress2(true)
            } else {
                addressTxtFirst2.text = data["NomineeAddress1"] as? String ?? ""
                addressTxtSecond2.text = data["NomineeAddress2"] as? String ?? ""
                addressTxtThird2.text = data["NomineeAddress3"] as? String ?? ""
                cityTxt2.text = data["NomineeCity"] as? String ?? ""
                stateTxt2.text = data["NomineeState"] as? String ?? ""
                pinCodeTxt2.text = data["NomineePinCode"] as? String ?? ""
            }
            
        case 3:
            // Similar population for nominee 3
            nomineeNameTxt3.text = data["NomineeName"] as? String ?? ""
            nomineeDob3.text = data["NomineeDOB"] as? String ?? ""
            documentId3.text = data["NomineeDocumentId"] as? String ?? ""
            nomineeMobile3.text = data["NomineeMobile"] as? String ?? ""
            nomineeEmail3.text = data["NomineeEmail"] as? String ?? ""
            shareTxt3.text = data["SharePercentage"] as? String ?? ""
            relationBtn3.setTitle(data["NomineeRelation"] as? String ?? "", for: .normal)
            
            let docType = data["NomineeDocumentType"] as? String ?? ""
            documentTypeBtn3.setTitle(docType, for: .normal)
            nomineedocumentType3 = docType
            
            if data["IsAddressSameAsApplicant"] as? String == "Y" {
                addressSameAsApplicantBtn3.isSelected = true
                hideNomineeAddress3(true)
            } else {
                addressTxtFirst3.text = data["NomineeAddress1"] as? String ?? ""
                addressTxtSecond3.text = data["NomineeAddress2"] as? String ?? ""
                addressTxtThird3.text = data["NomineeAddress3"] as? String ?? ""
                cityTxt3.text = data["NomineeCity"] as? String ?? ""
                stateTxt3.text = data["NomineeState"] as? String ?? ""
                pinCodeTxt3.text = data["NomineePinCode"] as? String ?? ""
            }
            
        default:
            break
        }
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
        vc.RegId = RegId
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
        vc.identifier = "nomineeDocument2"
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
        vc.identifier = "nomineeDocument3"
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
        
        guard !panNo.isEmpty, !name.isEmpty, !dob.isEmpty else {
            showAlert(message: "Please enter Guardian details.")
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
            name = guardianNameTxt1.text ?? ""
            dob = guardianDobTxt1.text ?? ""
        case 2:
            panNo = guardianIdTxt2.text ?? ""
            name = guardianNameTxt2.text ?? ""
            dob = guardianDobTxt2.text ?? ""
        case 3:
            panNo = guardianIdTxt3.text ?? ""
            name = guardianNameTxt3.text ?? ""
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
        var panSet = Set<String>()
        var nameSet = Set<String>()
        for nominee in nomineeDetailsArray {
            if let pan = nominee["documentId"] as? String {
                if panSet.contains(pan) {
                    // Step 2: Show alert if a duplicate is found
                    showAlert(message: "Please enter different PAN or ID for each nominee.")
                    return
                }
                panSet.insert(pan)
            }
            if let name = nominee["nomineeName"] as? String {
                if nameSet.contains(name) {
                    showAlert(message: "Please enter a different nominee name for each nominee.")
                    return
                }
                nameSet.insert(name)
            }
        }
        
        if NomineeType == "N" {
            print("nomineetype N called ")
            insertUpdateNomineeDetailsWebWithMinimalParams()
        } else if NomineeType == "Y" {
            // Call API with full parameters
            validateNomineeAllocation()
        } else {
            showAlert(message: "invalid number of nominee.")
        }
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
                                
                                if !isGuardian {
                                    
                                    // Detect nominee index
                                    if let index = Int(self.identifier.replacingOccurrences(of: "Nominee", with: "")) {
                                        
                                        // Disable fields after PAN verification
                                        self.disableNomineeFieldsAfterDigiLocker(index: index)
                                        
                                        // Age check for guardian
                                        if let age = self.calculateAge(from: userDOB) {
                                            self.toggleGuardianFields(for: index, show: age < 18)
                                        }
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
            
            apiCall(url: url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("InsertUpdateNomineeDetailsWeb Response: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        if errorCode == "000000" {
                            DispatchQueue.main.async {
                                let storyboard = UIStoryboard(name: "Document", bundle: Bundle.module )
                                if let nextVC = storyboard.instantiateViewController(withIdentifier: "DocumentVC") as? DocumentVC {
                                                                        nextVC.PanNo = self.panNo
                                                                        nextVC.RegId = self.RegId
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
    
    private func disableNomineeFieldsAfterDigiLocker(index: Int) {
        var documentType: String?
           
           switch index {
           case 1:
               documentType = nomineedocumentType1
           case 2:
               documentType = nomineedocumentType2
           case 3:
               documentType = nomineedocumentType3
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
//        switch index {
//        case 1:
//            nomineeNameTxt1.isEnabled   = false
//            nomineeDob1.isEnabled    = false
//            documentId1.isEnabled     = false
//            documentTypeBtn1.isEnabled  = false
//            addressTxtFirst1.isEnabled      = false
//            addressTxtSecond1.isEnabled      = false
//            addressTxtThird1.isEnabled      = false
//            pinCodeTxt1.isEnabled           = false
//            // Optionally disable mobile/email too if you consider them final
//            // nomineeMobileTxt1.isEnabled = false
//            // nomineeEmailTxt1.isEnabled  = false
//            
//        case 2:
//            nomineeNameTxt2.isEnabled   = false
//            nomineeDob2.isEnabled    = false
//            documentId2.isEnabled     = false
//            documentTypeBtn2.isEnabled  = false
//            addressTxtFirst2.isEnabled      = false
//            addressTxtSecond2.isEnabled      = false
//            addressTxtThird2.isEnabled      = false
//            pinCodeTxt2.isEnabled           = false
//            
//        case 3:
//            nomineeNameTxt3.isEnabled   = false
//            nomineeDob3.isEnabled    = false
//            documentId3.isEnabled     = false
//            documentTypeBtn3.isEnabled  = false
//            addressTxtFirst3.isEnabled      = false
//            addressTxtSecond3.isEnabled      = false
//            addressTxtThird3.isEnabled      = false
//            pinCodeTxt3.isEnabled           = false
//            
//        default: break
//        }
//        
    }
    
    func validateNomineeAllocation() {
        // Assign values from text fields to global variables
        nominee1Allocation = shareTxt1.text ?? ""
        nominee2Allocation = shareTxt2.text ?? ""
        nominee3Allocation = shareTxt3.text ?? ""
        //print("percentage value",nominee1Allocation,nominee2Allocation,nominee3Allocation)
        // Convert global string allocations to integers, defaulting to 0 if empty
        let nominee1Percentage = Int(nominee1Allocation) ?? 0
        let nominee2Percentage = Int(nominee2Allocation) ?? 0
        let nominee3Percentage = Int(nominee3Allocation) ?? 0
        
        // Calculate the total allocation percentage
        let totalAllocation = nominee1Percentage + nominee2Percentage + nominee3Percentage
        
        // Validate total allocation percentage
        switch nomineeDetailsArray.count
        
        {
        case 1:
            if totalAllocation != 100 {
                showAlert(message: "Total allocation percentage must be 100%.")
                return
            }
            
        case 2:
            if totalAllocation != 100 {
                showAlert(message: "Total allocation percentage must be 100%.")
                return
            }
            
        case 3:
            if totalAllocation != 100 {
                showAlert(message: "Total allocation percentage must be 100%.")
                return
            }
            
        default:
            showAlert(message: "Invalid number of nominees.")
            return
        }
    }
}




//import UIKit
//
//class NomineeVC: UIViewController, @MainActor SelectionDelegate, @MainActor VerticsVCDelegate, @MainActor CalenderVCDelegate, @MainActor DigiLocker_b_VCDelegate1, @MainActor ReloadPageDelegate, @MainActor RelationshipScheme {
//
//    func didSelectRelation(type: String, id: String, identifier: String) {
//        switch identifier {
//        case "nomineeRelation1":
//            relationBtn1.setTitle(type, for: .normal)
//            relationID1 = id
//        case "nomineeRelation2":
//            relationBtn2.setTitle(type, for: .normal)
//            relationID2 = id
//        case "nomineeRelation3":
//            relationBtn3.setTitle(type, for: .normal)
//            relationID3 = id
//        case "guardianRelation1":
//            relationNomineeBtn1.setTitle(type, for: .normal)
//            guardianRelationID1 = id
//        case "guardianRelation2":
//            relationNomineeBtn2.setTitle(type, for: .normal)
//            guardianRelationID2 = id
//        case "guardianRelation3":
//            relationNomineeBtn3.setTitle(type, for: .normal)
//            guardianRelationID3 = id
//        default:
//            break
//        }
//    }
//
//    func didDismissDigiLockerVC() {
//        self.dismiss(animated: true)
//    }
//
//    func reloadPageData() {
//        self.ViewAllNomineeDetails()
//    }
//
//    func didReceiveApiResponse(data: [String: Any], identifier1: String, identifier3: String) {
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
//
//            // 2. OPTIONAL: Show DigiLocker_b_VC (summary screen) after success
//            // If you want ONLY auto-fill + back to Nominee page, comment the whole block below
//            // self.showDigiLockerSummaryVC(data: data)
//        }
//    }
//
//    private func showDigiLockerSummaryVC(data: [String: Any]) {
//        let name = data["NameAsPerAadhaar"] as? String
//        let dob = data["DOB"] as? String
//        let gender = data["Gender"] as? String
//        let fatherName = data["FatherSpouseName"] as? String
//
//        let address = [
//            data["Address1"] as? String,
//            data["Address2"] as? String,
//            data["Address3"] as? String,
//            data["City"] as? String,
//            data["State"] as? String,
//            data["PinCode"] as? String
//        ].compactMap { $0 }.joined(separator: ", ")
//
//        let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
//        guard let vc = storyboard.instantiateViewController(withIdentifier: "digiVerifyVC") as? digiVerifyVC else { return }
//
//        vc.name = name
//        vc.dob = dob
//        vc.gender = gender
//        vc.fatherName = fatherName
//        vc.address = address
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//        vc.delegate = self
//
//        // Present after a slight delay
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.present(vc, animated: true)
//        }
//    }
//
//
//    func didSelectDepository(type: String, identifier: String) {
//        print("🔵 [didSelectDepository] Called → Type: \(type) | Identifier: \(identifier)")
//
//        switch identifier {
//
//            // MARK: - Nominee Documents
//        case "NomineeDocument1":
//            DispatchQueue.main.async {
//                print("   → Setting Nominee 1 button to \(type)")
//                if #available(iOS 15.0, *) {
//                    self.documentTypeBtn1.configuration?.title = type
//                } else {
//                    self.documentTypeBtn2.setTitle(type, for: .normal)
//                }
//                self.nomineedocumentType1 = type
//                if type == "Aadhaar" {
//                    self.saveDigiLocker(identifier1: "NomineeDocument1")
//                }
//            }
//
//        case "NomineeDocument2":
//            print("   → Setting Nominee 2 button to \(type)")
//            if #available(iOS 15.0, *) {
//                self.documentTypeBtn2.configuration?.title = type
//            } else {
//                self.documentTypeBtn2.setTitle(type, for: .normal)
//            }
//
//            nomineedocumentType2 = type
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "NomineeDocument2")
//            }
//
//        case "NomineeDocument3":
//            print("   → Setting Nominee 3 button to \(type)")
//            if #available(iOS 15.0, *) {
//                self.documentTypeBtn3.configuration?.title = type
//            } else {
//                self.documentTypeBtn3.setTitle(type, for: .normal)
//            }
//            nomineedocumentType3 = type
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "NomineeDocument3")
//            }
//
//            // MARK: - Guardian Documents (Fixed wrong button names)
//        case "guardianDocument1":
//            print("   → Setting Guardian 1 button to \(type)")
//            if #available(iOS 15.0, *) {
//                self.guardian1DocumentBtn.configuration?.title = type
//            } else {
//                self.guardian1DocumentBtn.setTitle(type, for: .normal)
//            }
//
//            guardiandocumentType1 = type
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "guardianDocument1")
//            }
//
//        case "guardianDocument2":
//            print("   → Setting Guardian 2 button to \(type)")
//            if #available(iOS 15.0, *) {
//                self.guardian2DocumentBtn.configuration?.title = type
//            } else {
//                self.guardian2DocumentBtn.setTitle(type, for: .normal)
//            }
//
//            guardiandocumentType2 = type
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "guardianDocument2")
//            }
//
//        case "guardianDocument3":
//            print("   → Setting Guardian 3 button to \(type)")
//            if #available(iOS 15.0, *) {
//                self.guardian3DocumentBtn.configuration?.title = type
//            } else {
//                self.guardian3DocumentBtn.setTitle(type, for: .normal)
//            }
//
//            guardiandocumentType3 = type
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "guardianDocument3")
//            }
//
//        default:
//            print("→ Unknown identifier: \(identifier)")
//            break
//        }
//    }
//
//
//    @IBOutlet weak var optInBtn: UIButton!
//    @IBOutlet weak var optOutBtn: UIButton!
//    @IBOutlet weak var mainStack: UIStackView!
//    @IBOutlet weak var nomineeView1: UIStackView!
//    @IBOutlet weak var nomineeLabel1: UILabel!
//    @IBOutlet weak var nomineeBtn1: UIButton!
//    @IBOutlet weak var viewLine1: UIView!
//    @IBOutlet weak var stackView1: UIStackView!
//    @IBOutlet weak var documentType1: UILabel!
//    @IBOutlet weak var documentTypeBtn1: UIButton!
//    @IBOutlet weak var documentIdLabel: UILabel!
//    @IBOutlet weak var documentIdTxt: UITextField!
//    @IBOutlet weak var nomineeVerifyBtn1: UIButton!
//    @IBOutlet weak var nomineeName1: UILabel!
//    @IBOutlet weak var nomineeNameTxt1: UITextField!
//    @IBOutlet weak var dob1: UILabel!
//    @IBOutlet weak var nomineeDobTxt1: UITextField!
//    @IBOutlet weak var selectDateBtn1: UIButton!
//    @IBOutlet weak var nomineeMobileLabel1: UILabel!
//    @IBOutlet weak var nomineeMobileTxt1: UITextField!
//    @IBOutlet weak var nomineeEmailLabel1: UILabel!
//    @IBOutlet weak var nomineeEmailTxt1: UITextField!
//    @IBOutlet weak var addressBtn1: UIButton!
//    @IBOutlet weak var address1Label1: UILabel!
//    @IBOutlet weak var address1Txt1: UITextField!
//    @IBOutlet weak var address2Label1: UILabel!
//    @IBOutlet weak var address3Label1: UILabel!
//    @IBOutlet weak var address2Txt1: UITextField!
//    @IBOutlet weak var address3Txt1: UITextField!
//    @IBOutlet weak var pinLabel1: UILabel!
//    @IBOutlet weak var pinTxt1: UITextField!
//    @IBOutlet weak var cityLabel1: UILabel!
//    @IBOutlet weak var cityTxt1: UITextField!
//    @IBOutlet weak var stateLabel1: UILabel!
//    @IBOutlet weak var stateTxt1: UITextField!
//    @IBOutlet weak var relationLabel1: UILabel!
//    @IBOutlet weak var relationBtn1: UIButton!
//    @IBOutlet weak var shareLabel1: UILabel!
//    @IBOutlet weak var shareTxt1: UITextField!
//    @IBOutlet weak var nominee1View1: UIView!
//
//    @IBOutlet weak var gurdianLabel1: UILabel!
//    @IBOutlet weak var guardian1DocumentType: UILabel!
//    @IBOutlet weak var guardian1DocumentBtn: UIButton!
//    @IBOutlet weak var guardianName1: UILabel!
//    @IBOutlet weak var guardianNameTxt1: UITextField!
//    @IBOutlet weak var guardianDobLabel1: UILabel!
//    @IBOutlet weak var guardianDobBtn1: UIButton!
//    @IBOutlet weak var guardianDobTxt1: UITextField!
//    @IBOutlet weak var guardianIDLabel1: UILabel!
//    @IBOutlet weak var guardianIdTxt: UITextField!
//    @IBOutlet weak var guardianVerify: UIButton!
//    @IBOutlet weak var guardianMobileLabel1: UILabel!
//    @IBOutlet weak var guardianMobileTxt1: UITextField!
//    @IBOutlet weak var guardianEmailLabel1: UILabel!
//    @IBOutlet weak var guardianEmailIdTxt1: UITextField!
//    @IBOutlet weak var relationNomineeLbl1: UILabel!
//    @IBOutlet weak var relationNomineeBtn1: UIButton!
//    @IBOutlet weak var guardianAddressSameBtn1: UIButton!
//    @IBOutlet weak var GuardianAddressLbl1: UILabel!
//    @IBOutlet weak var guardianAddressTxt1: UITextField!
//    @IBOutlet weak var GuardianAddress1Lbl1: UILabel!
//    @IBOutlet weak var guardianAddress1Txt1: UITextField!
//    @IBOutlet weak var GuardianAddress2Lbl1: UILabel!
//    @IBOutlet weak var GuardianAddress2Txt1: UITextField!
//    @IBOutlet weak var guardianPin1Lbl1: UILabel!
//    @IBOutlet weak var guardianPin1Txt1: UITextField!
//    @IBOutlet weak var guardianCity1Lbl1: UILabel!
//    @IBOutlet weak var guardianCity1Txt1: UITextField!
//    @IBOutlet weak var guardianState1Lbl1: UILabel!
//    @IBOutlet weak var guardianState1Txt1: UITextField!
//
//    @IBOutlet weak var nomineeView2: UIStackView!
//    @IBOutlet weak var nominee3View3: UIView!
//    @IBOutlet weak var viewLine2: UIView!
//    @IBOutlet weak var stackView2: UIStackView!
//    @IBOutlet weak var nomineeBtn2: UIButton!
//    @IBOutlet weak var documentType2: UILabel!
//    @IBOutlet weak var documentTypeBtn2: UIButton!
//    @IBOutlet weak var documentIdLabel2: UILabel!
//    @IBOutlet weak var documentIdTxt2:
//    UITextField!
//
//    @IBOutlet weak var nomineeName2: UILabel!
//    @IBOutlet weak var nomineeNameTxt2: UITextField!
//    @IBOutlet weak var dob2: UILabel!
//    @IBOutlet weak var selectDateBtn2: UIButton!
//    @IBOutlet weak var nomineeMobileLabel2: UILabel!
//    @IBOutlet weak var nomineeMobileTxt2: UITextField!
//    @IBOutlet weak var nomineeEmailLabel2: UILabel!
//    @IBOutlet weak var nomineeEmailTxt2: UITextField!
//    @IBOutlet weak var addressBtn2: UIButton!
//    @IBOutlet weak var address1Label2: UILabel!
//    @IBOutlet weak var address1Txt2: UITextField!
//    @IBOutlet weak var address2Label2: UILabel!
//    @IBOutlet weak var address3Label2: UILabel!
//    @IBOutlet weak var address2Txt2: UITextField!
//    @IBOutlet weak var address3Txt2: UITextField!
//    @IBOutlet weak var pinLabel2: UILabel!
//    @IBOutlet weak var pinTxt2: UITextField!
//    @IBOutlet weak var cityLabel2: UILabel!
//    @IBOutlet weak var cityTxt2: UITextField!
//    @IBOutlet weak var stateLabel2: UILabel!
//    @IBOutlet weak var stateTxt2: UITextField!
//    @IBOutlet weak var relationLabel2: UILabel!
//    @IBOutlet weak var relationBtn2: UIButton!
//    @IBOutlet weak var shareLabel2: UILabel!
//    @IBOutlet weak var shareTxt2: UITextField!
//    @IBOutlet weak var gurdianLabel2: UILabel!
//    @IBOutlet weak var guardian2DocumentType: UILabel!
//    @IBOutlet weak var guardian2DocumentBtn: UIButton!
//    @IBOutlet weak var guardianName2: UILabel!
//    @IBOutlet weak var guardianNameTxt2: UITextField!
//    @IBOutlet weak var guardianDobLabel2: UILabel!
//    @IBOutlet weak var guardianDobBtn2: UIButton!
//    @IBOutlet weak var guardianDobTxt2: UITextField!
//    @IBOutlet weak var guardianIDLabel2: UILabel!
//    @IBOutlet weak var guardianIdTxt2: UITextField!
//    @IBOutlet weak var guardianVerify2: UIButton!
//    @IBOutlet weak var guardianMobileLabel2: UILabel!
//    @IBOutlet weak var guardianMobileTxt2: UITextField!
//    @IBOutlet weak var guardianEmailLabel2: UILabel!
//    @IBOutlet weak var guardianEmailIdTxt2: UITextField!
//    @IBOutlet weak var relationNomineeLbl2: UILabel!
//    @IBOutlet weak var relationNomineeBtn2: UIButton!
//    @IBOutlet weak var guardianAddressSameBtn2: UIButton!
//    @IBOutlet weak var GuardianAddressLbl2: UILabel!
//    @IBOutlet weak var guardianAddressTxt2: UITextField!
//    @IBOutlet weak var GuardianAddress1Lbl2: UILabel!
//    @IBOutlet weak var guardianAddress1Txt2: UITextField!
//    @IBOutlet weak var GuardianAddress2Lbl2: UILabel!
//    @IBOutlet weak var GuardianAddress2Txt2: UITextField!
//    @IBOutlet weak var guardianPin1Lbl2: UILabel!
//    @IBOutlet weak var guardianPin1Txt2: UITextField!
//    @IBOutlet weak var guardianCity1Lbl2: UILabel!
//    @IBOutlet weak var guardianCity1Txt2: UITextField!
//    @IBOutlet weak var guardianState1Lbl2: UILabel!
//    @IBOutlet weak var guardianState1Txt2: UITextField!
//    @IBOutlet weak var nomineeDobTxt2: UITextField!
//
//    @IBOutlet weak var nomineeView3: UIStackView!
//    @IBOutlet weak var nominee2View2: UIView!
//    @IBOutlet weak var viewLine3: UIView!
//    @IBOutlet weak var stackView3: UIStackView!
//    @IBOutlet weak var nomineeBtn3: UIButton!
//    @IBOutlet weak var documentType3: UILabel!
//    @IBOutlet weak var documentTypeBtn3: UIButton!
//    @IBOutlet weak var documentIdLabel3: UILabel!
//    @IBOutlet weak var documentIdTxt3: UITextField!
//    @IBOutlet weak var nomineeVerify3: UIButton!
//    @IBOutlet weak var nomineeName3: UILabel!
//    @IBOutlet weak var nomineeNameTxt3: UITextField!
//    @IBOutlet weak var dob3: UILabel!
//    @IBOutlet weak var selectDateBtn3: UIButton!
//    @IBOutlet weak var nomineeDobTxt3: UITextField!
//    @IBOutlet weak var nomineeMobileLabel3: UILabel!
//    @IBOutlet weak var nomineeMobileTxt3: UITextField!
//    @IBOutlet weak var nomineeEmailLabel3: UILabel!
//    @IBOutlet weak var nomineeEmailTxt3: UITextField!
//    @IBOutlet weak var addressBtn3: UIButton!
//    @IBOutlet weak var address1Label3: UILabel!
//    @IBOutlet weak var address1Txt3: UITextField!
//    @IBOutlet weak var address2Label3: UILabel!
//    @IBOutlet weak var address2Txt3: UITextField!
//    @IBOutlet weak var address3Label3: UILabel!
//    @IBOutlet weak var address3Txt3: UITextField!
//    @IBOutlet weak var pinLabel3: UILabel!
//    @IBOutlet weak var pinTxt3: UITextField!
//    @IBOutlet weak var cityLabel3: UILabel!
//    @IBOutlet weak var cityTxt3: UITextField!
//    @IBOutlet weak var stateLabel3: UILabel!
//    @IBOutlet weak var stateTxt3: UITextField!
//    @IBOutlet weak var relationLabel3: UILabel!
//    @IBOutlet weak var relationBtn3: UIButton!
//    @IBOutlet weak var shareLabel3: UILabel!
//    @IBOutlet weak var shareTxt3: UITextField!
//
//    @IBOutlet weak var addNomineebtn: UIButton!
//    @IBOutlet weak var instructionLabel: UILabel!
//    @IBOutlet weak var instruction1Label: UILabel!
//    @IBOutlet weak var proceedBtn: UIButton!
//    @IBOutlet weak var gurdianLabel3: UILabel!
//    @IBOutlet weak var guardian3DocumentType: UILabel!
//    @IBOutlet weak var guardian3DocumentBtn: UIButton!
//    @IBOutlet weak var guardianName3: UILabel!
//    @IBOutlet weak var guardianNameTxt3: UITextField!
//    @IBOutlet weak var guardianDobLabel3: UILabel!
//    @IBOutlet weak var guardianDobBtn3: UIButton!
//    @IBOutlet weak var guardianDobTxt3: UITextField!
//    @IBOutlet weak var guardianIDLabel3: UILabel!
//    @IBOutlet weak var guardianIdTxt3: UITextField!
//    @IBOutlet weak var guardianVerify3: UIButton!
//    @IBOutlet weak var guardianMobileLabel3: UILabel!
//    @IBOutlet weak var guardianMobileTxt3: UITextField!
//    @IBOutlet weak var guardianEmailLabel3: UILabel!
//    @IBOutlet weak var guardianEmailIdTxt3: UITextField!
//    @IBOutlet weak var relationNomineeLbl3: UILabel!
//    @IBOutlet weak var relationNomineeBtn3: UIButton!
//    @IBOutlet weak var guardianAddressSameBtn3: UIButton!
//    @IBOutlet weak var GuardianAddressLbl3: UILabel!
//    @IBOutlet weak var guardianAddressTxt3: UITextField!
//    @IBOutlet weak var GuardianAddress1Lbl3: UILabel!
//    @IBOutlet weak var guardianAddress1Txt3: UITextField!
//    @IBOutlet weak var GuardianAddress2Lbl3: UILabel!
//    @IBOutlet weak var GuardianAddress2Txt3: UITextField!
//    @IBOutlet weak var guardianPin1Lbl3: UILabel!
//    @IBOutlet weak var guardianPin1Txt3: UITextField!
//    @IBOutlet weak var guardianCity1Lbl3: UILabel!
//    @IBOutlet weak var guardianCity1Txt3: UITextField!
//    @IBOutlet weak var guardianState1Lbl3: UILabel!
//    @IBOutlet weak var guardianState1Txt3: UITextField!
//
//
//    var nomineeCount = 0
//    var NomineeType: String = "N"
//    var isNominee1Expanded = false
//    var isNominee2Expanded = false
//    var isNominee3Expanded = false
//    var nomineedocumentType1 : String?
//    var nomineedocumentType2 : String?
//    var nomineedocumentType3 : String?
//    var guardiandocumentType1 : String?
//    var guardiandocumentType2 : String?
//    var guardiandocumentType3 : String?
//    var fetchedUserId: String?
//    var fetchedSessionID: String?
//    var mobiledecodeArray: String?
//    var identifier: String = ""
//    var RegId: String?
//    var panNo: String?
//    var isNomineeVerified = false
//    var NomineeMinor : String?
//    var regId: String?
//    var PANName: String?
//    var EmailId: String?
//    var digiIdentifier: String?
//    var relationID1:String?
//    var relationID2:String?
//    var relationID3:String?
//    var guardianRelationID1: String?
//    var guardianRelationID2: String?
//    var guardianRelationID3: String?
//    var nomineeDetailsArray: [[String: Any]] = []
//    var nominee1Allocation: String = ""
//    var nominee2Allocation: String = ""
//    var nominee3Allocation: String = ""
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        nomineeView1.isHidden = true
//        nomineeView2.isHidden = true
//        nomineeView3.isHidden = true
//        mainStack.isHidden = true
//
//        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
//            guard let self = self else { return }
//
//            if let userId = userId, let sessionID = sessionID {
//                self.fetchedUserId = userId
//                self.fetchedSessionID = sessionID
//                self.mobiledecodeArray = decodeByteArrayString
//                print("UserID: \(userId), SessionID: \(sessionID)")
//                // self.ViewAllNomineeDetails()
//            } else {
//                print("No UserID or SessionID found.")
//            }
//        }
//
//        toggleGuardianFields(for: 1, show: false)
//        toggleGuardianFields(for: 2, show: false)
//        toggleGuardianFields(for: 3, show: false)
//
//        nominee1View1.layer.cornerRadius = 10
//        nominee1View1.layer.borderWidth = 0.5
//        nominee1View1.layer.borderColor = UIColor.gray.cgColor
//
//        nominee2View2.layer.cornerRadius = 10
//        nominee2View2.layer.borderWidth = 0.5
//        nominee2View2.layer.borderColor = UIColor.gray.cgColor
//
//        nominee3View3.layer.cornerRadius = 10
//        nominee3View3.layer.borderWidth = 0.5
//        nominee3View3.layer.borderColor = UIColor.gray.cgColor
//        view.backgroundColor = .appBackground
//    }
//
//    private func fillNomineeFields(data: [String: Any], index: Int) {
//        DispatchQueue.main.async {
//
//            let name = data["NameAsPerAadhaar"] as? String ?? ""
//            let dob = data["DOB"] as? String ?? ""
//            let uid = data["Uid"] as? String ?? ""
//            let gender = data["Gender"] as? String ?? ""
//            let fatherName = data["FatherSpouseName"] as? String ?? ""
//
//            let address1 = data["Address1"] as? String ?? ""
//            let address2 = data["Address2"] as? String ?? ""
//            let address3 = data["Address3"] as? String ?? ""
//            let city = data["City"] as? String ?? ""
//            let state = data["State"] as? String ?? ""
//            let pincode = data["PinCode"] as? String ?? ""
//
//            // Optional fields if available
//            let mobile = data["Mobile"] as? String ?? ""
//            let email = data["Email"] as? String ?? ""
//
//            if !mobile.isEmpty && !self.isValidMobile(mobile) {
//                self.showAlert(message: "Invalid mobile number received from Aadhaar.")
//            }
//
//            // Validate Email
//            if !email.isEmpty && !self.isValidEmail(email) {
//                self.showAlert(message: "Invalid email received from Aadhaar.")
//            }
//
//            // Validate Pincode
//            if !pincode.isEmpty && !self.isValidPinCode(pincode) {
//                self.showAlert(message: "Invalid pincode received from Aadhaar.")
//            }
//
//            switch index {
//            case 1:
//                // Nominee fields
//                self.nomineeNameTxt1.text = name
//                self.nomineeDobTxt1.text = dob
//                self.documentIdTxt.text = uid
//                self.nomineeMobileTxt1.text = mobile
//                self.nomineeEmailTxt1.text = email
//
//                // Address fields
//                self.address1Txt1.text = address1
//                self.address2Txt1.text = address2
//                self.address3Txt1.text = address3
//                self.cityTxt1.text = city
//                self.stateTxt1.text = state
//                self.pinTxt1.text = pincode
//
//                // Set document type
//                if #available(iOS 15.0, *) {
//                    self.documentTypeBtn1.configuration?.title = "Aadhaar"
//                } else {
//                    self.documentTypeBtn1.setTitle("Aadhaar", for: .normal)
//                }
//
//                // Disable fields after verification
//                self.nomineeNameTxt1.isEnabled = false
//                self.nomineeDobTxt1.isEnabled = false
//                self.documentIdTxt.isEnabled = false
//                self.documentTypeBtn1.isEnabled = false
//                self.address1Txt1.isEnabled = false
//                self.address2Txt1.isEnabled = false
//                self.address3Txt1.isEnabled = false
//                self.pinTxt1.isEnabled = false
//                self.cityTxt1.isEnabled = false
//                self.stateTxt1.isEnabled = false
//
//            case 2:
//                // Nominee fields
//                self.nomineeNameTxt2.text = name
//                self.nomineeDobTxt2.text = dob
//                self.documentIdTxt2.text = uid
//                self.nomineeMobileTxt2.text = mobile
//                self.nomineeEmailTxt2.text = email
//
//                // Address fields
//                self.address1Txt2.text = address1
//                self.address2Txt2.text = address2
//                self.address3Txt2.text = address3
//                self.cityTxt2.text = city
//                self.stateTxt2.text = state
//                self.pinTxt2.text = pincode
//
//                // Set document type
//                if #available(iOS 15.0, *) {
//                    self.documentTypeBtn2.configuration?.title = "Aadhaar"
//                } else {
//                    self.documentTypeBtn2.setTitle("Aadhaar", for: .normal)
//                }
//
//                // Disable fields
//                self.nomineeNameTxt2.isEnabled = false
//                self.nomineeDobTxt2.isEnabled = false
//                self.documentIdTxt2.isEnabled = false
//                self.documentTypeBtn2.isEnabled = false
//                self.address1Txt2.isEnabled = false
//                self.address2Txt2.isEnabled = false
//                self.address3Txt2.isEnabled = false
//                self.pinTxt2.isEnabled = false
//                self.cityTxt2.isEnabled = false
//                self.stateTxt2.isEnabled = false
//
//            case 3:
//                // Nominee fields
//                self.nomineeNameTxt3.text = name
//                self.nomineeDobTxt3.text = dob
//                self.documentIdTxt3.text = uid
//                self.nomineeMobileTxt3.text = mobile
//                self.nomineeEmailTxt3.text = email
//
//                // Address fields
//                self.address1Txt3.text = address1
//                self.address2Txt3.text = address2
//                self.address3Txt3.text = address3
//                self.cityTxt3.text = city
//                self.stateTxt3.text = state
//                self.pinTxt3.text = pincode
//
//                // Set document type
//                if #available(iOS 15.0, *) {
//                    self.documentTypeBtn3.configuration?.title = "Aadhaar"
//                } else {
//                    self.documentTypeBtn3.setTitle("Aadhaar", for: .normal)
//                }
//
//                // Disable fields
//                self.nomineeNameTxt3.isEnabled = false
//                self.nomineeDobTxt3.isEnabled = false
//                self.documentIdTxt3.isEnabled = false
//                self.documentTypeBtn3.isEnabled = false
//                self.address1Txt3.isEnabled = false
//                self.address2Txt3.isEnabled = false
//                self.address3Txt3.isEnabled = false
//                self.pinTxt3.isEnabled = false
//                self.cityTxt3.isEnabled = false
//                self.stateTxt3.isEnabled = false
//
//            default:
//                return
//            }
//
//            // Age check and guardian visibility
//            if let age = self.calculateAge(from: dob) {
//                self.toggleGuardianFields(for: index, show: age < 18)
//            }
//
//            // Validate pincode to fetch city/state if needed
//            self.validatePinCode(pinCode: pincode, for: "nominee", index: index)
//
//            print("✅ Successfully auto-filled Nominee \(index)")
//        }
//    }
//
//    private func fillGuardianFields(data: [String: Any], index: Int) {
//        DispatchQueue.main.async {
//            print("🔧 Filling Guardian \(index) with DigiLocker data")
//
//            let name = data["NameAsPerAadhaar"] as? String ?? ""
//            let dob = data["DOB"] as? String ?? ""
//            let uid = data["Uid"] as? String ?? ""
//
//            let address1 = data["Address1"] as? String ?? ""
//            let address2 = data["Address2"] as? String ?? ""
//            let address3 = data["Address3"] as? String ?? ""
//            let city = data["City"] as? String ?? ""
//            let state = data["State"] as? String ?? ""
//            let pincode = data["PinCode"] as? String ?? ""
//
//            switch index {
//            case 1:
//                self.guardianNameTxt1.text = name
//                self.guardianDobTxt1.text = dob
//                self.guardianIdTxt.text = uid
//
//                self.guardianAddressTxt1.text = address1
//                self.guardianAddress1Txt1.text = address2
//                self.GuardianAddress2Txt1.text = address3
//                self.guardianCity1Txt1.text = city
//                self.guardianState1Txt1.text = state
//                self.guardianPin1Txt1.text = pincode
//
//                self.guardian1DocumentBtn.setTitle("Aadhaar", for: .normal)
//                self.guardiandocumentType1 = "Aadhaar"
//
//            case 2:
//                self.guardianNameTxt2.text = name
//                self.guardianDobTxt2.text = dob
//                self.guardianIdTxt2.text = uid
//
//                self.guardianAddressTxt2.text = address1
//                self.guardianAddress1Txt2.text = address2
//                self.GuardianAddress2Txt2.text = address3
//                self.guardianCity1Txt2.text = city
//                self.guardianState1Txt2.text = state
//                self.guardianPin1Txt2.text = pincode
//
//                self.guardian2DocumentBtn.setTitle("Aadhaar", for: .normal)
//                self.guardiandocumentType2 = "Aadhaar"
//
//            case 3:
//                self.guardianNameTxt3.text = name
//                self.guardianDobTxt3.text = dob
//                self.guardianIdTxt3.text = uid
//
//                self.guardianAddressTxt3.text = address1
//                self.guardianAddress1Txt3.text = address2
//                self.GuardianAddress2Txt3.text = address3
//                self.guardianCity1Txt3.text = city
//                self.guardianState1Txt3.text = state
//                self.guardianPin1Txt3.text = pincode
//
//                self.guardian3DocumentBtn.setTitle("Aadhaar", for: .normal)
//                self.guardiandocumentType3 = "Aadhaar"
//
//            default:
//                return
//            }
//
//            print("✅ Successfully auto-filled Guardian \(index)")
//        }
//    }
//
//    private func disableNomineeFieldsAfterDigiLocker(index: Int) {
//        switch index {
//        case 1:
//            nomineeNameTxt1.isEnabled   = false
//            nomineeDobTxt1.isEnabled    = false
//            documentIdTxt.isEnabled     = false
//            documentTypeBtn1.isEnabled  = false
//            address1Txt1.isEnabled      = false
//            address2Txt1.isEnabled      = false
//            address3Txt1.isEnabled      = false
//            pinTxt1.isEnabled           = false
//            // Optionally disable mobile/email too if you consider them final
//            // nomineeMobileTxt1.isEnabled = false
//            // nomineeEmailTxt1.isEnabled  = false
//
//        case 2:
//            nomineeNameTxt2.isEnabled   = false
//            nomineeDobTxt2.isEnabled    = false
//            documentIdTxt2.isEnabled    = false
//            documentTypeBtn2.isEnabled  = false
//            address1Txt2.isEnabled      = false
//            address2Txt2.isEnabled      = false
//            address3Txt2.isEnabled      = false
//            pinTxt2.isEnabled           = false
//
//        case 3:
//            nomineeNameTxt3.isEnabled   = false
//            nomineeDobTxt3.isEnabled    = false
//            documentIdTxt3.isEnabled    = false
//            documentTypeBtn3.isEnabled  = false
//            address1Txt3.isEnabled      = false
//            address2Txt3.isEnabled      = false
//            address3Txt3.isEnabled      = false
//            pinTxt3.isEnabled           = false
//
//        default: break
//        }
//
//    }
//
//    func validatePinCode(pinCode: String, for type: String, index: Int = 1) {
//        let parameters: [String: Any] = ["PinCode": pinCode]
//
//        let url = "CityState/GetCitySateOnPincode"
//
//        apiCall(url: url, method: "POST", parameters: parameters, view: self.view) { result in
//            switch result {
//            case .success(let jsonResponse):
//                if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
//                    DispatchQueue.main.async {
//                        if let countryList = jsonResponse["CountryList"] as? [[String: Any]],
//                           let firstItem = countryList.first {
//                            let city = firstItem["City"] as? String ?? ""
//                            let state = firstItem["State"] as? String ?? ""
//
//                            if type == "nominee" {
//                                switch index {
//                                case 1:
//                                    self.cityTxt1.text = city
//                                    self.stateTxt1.text = state
//                                    self.cityTxt1.isUserInteractionEnabled = false
//                                    self.stateTxt1.isUserInteractionEnabled = false
//                                case 2:
//                                    self.cityTxt2.text = city
//                                    self.stateTxt2.text = state
//                                    self.cityTxt2.isUserInteractionEnabled = false
//                                    self.stateTxt2.isUserInteractionEnabled = false
//                                case 3:
//                                    self.cityTxt3.text = city
//                                    self.stateTxt3.text = state
//                                    self.cityTxt3.isUserInteractionEnabled = false
//                                    self.stateTxt3.isUserInteractionEnabled = false
//                                default:
//                                    break
//                                }
//                            }
//                        }
//                    }
//                }
//            case .failure(let error):
//                print("API call failed: \(error.localizedDescription)")
//            }
//        }
//    }
//
//
//    @IBAction func backBtnTapped(_ sender: UIButton) {
//        // delegate?.reloadPageData()
//        let vc = ApplicationFormVC()
//        vc.panNo = panNo
//        vc.regId = regId
//        vc.PANName = PANName
//        vc.EmailId = EmailId
//
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    @IBAction func addNomineeBtnTapped(_ sender: UIButton) {
//        print("Add Nominee Clicked")
//        guard nomineeCount < 3 else { return }
//
//        nomineeCount += 1
//
//        switch nomineeCount {
//
//        case 1:
//            nomineeView1.isHidden = false
//            nomineeView2.isHidden = true
//            nomineeView3.isHidden = true
//
//        case 2:
//            nomineeView1.isHidden = false
//            nomineeView2.isHidden = false
//            nomineeView3.isHidden = true
//
//        case 3:
//            nomineeView1.isHidden = false
//            nomineeView2.isHidden = false
//            nomineeView3.isHidden = false
//
//            addNomineebtn.isHidden = true // optional (hide after 3)
//
//        default:
//            break
//        }
//    }
//
//    @IBAction func NomineeConfirmationBtn(_ sender: UIButton) {
//
//        if sender == optInBtn {
//            optInBtn.isSelected = true
//            optOutBtn.isSelected = false
//
//            NomineeType = "Y"
//            mainStack.isHidden = false
//            addNomineebtn.isHidden = false
//            addNomineebtn.isEnabled = true
//
//        } else {
//            optInBtn.isSelected = false
//            optOutBtn.isSelected = true
//
//            NomineeType = "N"
//            mainStack.isHidden = true
//
//            nomineeCount = 0
//            nomineeView1.isHidden = true
//            nomineeView2.isHidden = true
//            nomineeView3.isHidden = true
//        }
//    }
//
//    @IBAction func nominee1BtnTapped(_ sender: UIButton) {
//        print("tapped")
//        isNominee1Expanded.toggle()
//
//        stackView1.isHidden = !isNominee1Expanded
//        viewLine1.isHidden = !isNominee1Expanded
//
//        if isNominee1Expanded {
//            nomineeBtn1.setImage(UIImage(named: "upArrow"), for: .normal)
//        } else {
//            nomineeBtn1.setImage(UIImage(named: "downArrow"), for: .normal)
//        }
//    }
//
//    @IBAction func nominee2BtnTapped(_ sender: UIButton) {
//        print("tapped")
//        isNominee2Expanded.toggle()
//
//        stackView2.isHidden = !isNominee2Expanded
//        viewLine2.isHidden = !isNominee2Expanded
//
//        if isNominee1Expanded {
//            nomineeBtn2.setImage(UIImage(named: "upArrow"), for: .normal)
//        } else {
//            nomineeBtn2.setImage(UIImage(named: "downArrow"), for: .normal)
//        }
//    }
//
//    @IBAction func nominee3BtnTapped(_ sender: UIButton) {
//        print("tapped")
//        isNominee3Expanded.toggle()
//
//        stackView3.isHidden = !isNominee3Expanded
//        viewLine3.isHidden = !isNominee3Expanded
//
//        if isNominee1Expanded {
//            nomineeBtn3.setImage(UIImage(named: "upArrow"), for: .normal)
//        } else {
//            nomineeBtn3.setImage(UIImage(named: "downArrow"), for: .normal)
//        }
//    }
//
//    @IBAction func documentType1(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "NomineeDocument1"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func dobBtnTapped(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeDOB1"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func documentType2(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "NomineeDocument2"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func dobBtnTapped2(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeDOB2"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func documentType3(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "NomineeDocument3"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func dobBtnTapped3(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeDOB3"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func nomineeVerifyBtn1(_ sender: UIButton) {
//        verifyNominee(index: 1)
//    }
//
//    @IBAction func nomineeVerifyBtn2(_ sender: UIButton) {
//        verifyNominee(index: 2)
//    }
//
//    @IBAction func nomineeVerifyBtn3(_ sender: UIButton) {
//        verifyNominee(index: 3)
//    }
//
//
//    @IBAction func guardianDocumentTypeBtn1(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "guardianDocument1"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func guardianDocumentTypeBtn2(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "guardianDocument2"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func guardianDocumentTypeBtn3(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "guardianDocument3"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
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
//    @IBAction func guardianVerifyBtn1(_ sender: UIButton) {
//        verifyGuardian(index: 1)
//    }
//
//    @IBAction func guardianVerifyBtn2(_ sender: UIButton) {
//        verifyGuardian(index: 2)
//    }
//
//    @IBAction func guardianVerifyBtn3(_ sender: UIButton) {
//        verifyGuardian(index: 3)
//    }
//
//    @IBAction func guardianDobBtn1(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "guardianDOB1"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func guardianDobBtn2(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "guardianDOB2"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func guardianDobBtn3(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "guardianDOB3"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func relationBtn1(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "relationVC") as! relationVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeRelation1"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func relationBtn2(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "relationVC") as! relationVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeRelation2"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func relationBtn3(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "relationVC") as! relationVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeRelation3"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func relationGuardian1(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "guardianDocument1"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func relationGuardian2(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "guardianDocument2"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func relationGuardian3(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "guardianDocument3"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    func saveDigiLocker(identifier1 : String) {
//        digiIdentifier = identifier1
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
//                "PanNo": panNo,
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
//                                        self.navigationToVeriticsVC()
//                                        //                                        self.navigateToVeriticsVC(DigiLockerURL: DigiLockerURL ?? "", TransactionID: TransactionID ?? "",identifier1 : identifier1)
//                                    } else if digiType == "DIRECT"{
//                                        let url = "\(DigiLockerURL ?? "")?redirect_uri=\(digilockerReturnURL ?? "")&response_type=code&response_type=code&client_id=\(Client_id ?? "")&state=\(TransactionID ?? "")"
//                                        //                                        self.navigateToVeriticsVC(DigiLockerURL: url, TransactionID: TransactionID ?? "", identifier1: identifier1 )
//                                        self.navigationToVeriticsVC()
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
//
//        }
//    }
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
//                                if !isGuardian {
//
//                                    // Detect nominee index
//                                    if let index = Int(self.identifier.replacingOccurrences(of: "Nominee", with: "")) {
//
//                                        // Disable fields after PAN verification
//                                        self.disableNomineeFieldsAfterDigiLocker(index: index)
//
//                                        // Age check for guardian
//                                        if let age = self.calculateAge(from: userDOB) {
//                                            self.toggleGuardianFields(for: index, show: age < 18)
//                                        }
//                                    }
//                                }
//
//                                let storyboard = UIStoryboard(name: "DashboardVC", bundle: Bundle.module)
//
//                                guard let viewController = storyboard.instantiateViewController(withIdentifier: "PanVerifyPopupVC") as? PanVerifyPopupVC else {
//                                    print("ViewController not found")
//                                    return
//                                }
//
//                                viewController.panName = jsonResponse["PANName"] as? String
//                                viewController.dob = jsonResponse["DOB"] as? String
//                                viewController.requestId = jsonResponse["RequestId"] as? String
//                                viewController.panNo = jsonResponse["PanNo"] as? String
//                                viewController.identifier = "nomineePanVerify"
//                                viewController.modalPresentationStyle = .overCurrentContext
//                                viewController.modalTransitionStyle = .crossDissolve
//
//                                self.present(viewController, animated: true)
//                                //                            DispatchQueue.main.async {
//                                //                                if !isGuardian {
//                                //                                        if let age = self.calculateAge(from: userDOB) {
//                                //                                            if let index = Int(self.identifier.replacingOccurrences(of: "Nominee", with: "")) {
//                                //                                                self.toggleGuardianFields(for: index, show: age < 18)
//                                //                                            }
//                                //                                        }
//                                //                                    }
//                                //
//                                //                                let storyboard = UIStoryboard(name: "DashboardVC", bundle: Bundle.module)
//                                //
//                                //                                // Instantiate the view controller by its identifier
//                                //                                guard let viewController = storyboard.instantiateViewController(withIdentifier: "PanVerifyPopupVC") as? PanVerifyPopupVC else {
//                                //                                    print("ViewController not found")
//                                //                                    return
//                                //                                }
//                                //                                viewController.panName = jsonResponse["PANName"] as? String
//                                //                                viewController.dob = jsonResponse["DOB"] as? String
//                                //                                viewController.requestId = jsonResponse["RequestId"] as? String
//                                //                                viewController.panNo = jsonResponse["PanNo"] as? String
//                                //                                viewController.identifier = "nomineePanVerify"
//                                //                                viewController.modalPresentationStyle = .overCurrentContext
//                                //
//                                //                                viewController.modalTransitionStyle = .crossDissolve
//                                //                                print("present")
//                                //                                self.present(viewController, animated: true, completion: nil)
//                            }
//
//                        case "100001":
//                            DispatchQueue.main.async {
//                                self.showAlert( message: ErrorMessage ?? "")
//                            }
//                        case "300009":
//                            DispatchQueue.main.async {
//                                self.showAlert( message: ErrorMessage ?? "")
//                            }
//                        case "Pan-001":
//                            DispatchQueue.main.async {
//                                self.showAlert(message: ErrorMessage ?? "")
//                            }
//                        case "PANDOB-001":
//                            DispatchQueue.main.async {
//                                self.showAlert(message: ErrorMessage ?? "")
//                            }
//                        case "300001":
//                            DispatchQueue.main.async {
//                                self.showAlert(message: ErrorMessage ?? "")
//                            }
//                        case "300006":
//                            DispatchQueue.main.async {
//                                self.showAlert(message: ErrorMessage ?? "")
//                            }
//                        case "111111":
//                            DispatchQueue.main.async {
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
//                                //                                self.NoBtn.isSelected = true
//                                //                                self.saveNNextBtn.isHidden = false
//
//                            } else if let nomineeData = jsonResponse["NomineeDetails"] as? [[String: Any]], !nomineeData.isEmpty {
//
//                                //                                self.nomineeDetailsArray = nomineeData
//                                //                                self.updateNomineeViewsall() // Make sure this function updates the UI based on `nomineeDetailsArray`
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
//    func showAlert(message: String) {
//        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
//    }
//
//    //    func navigateToVeriticsVC(DigiLockerURL: String, TransactionID: String,identifier1 : String) {
//    //        func navigateToVeriticsVC(DigiLockerURL: String,
//    //                                  TransactionID: String,
//    //                                  identifier1: String) {
//    //
//    //            let vc = VerticsVC()
//    //
//    //                vc.DigiLockerURL = DigiLockerURL
//    //                vc.TransactionID = TransactionID
//    //                vc.identifier1 = identifier1
//    //                vc.RegId = RegId
//    //                vc.panNo = panNo
//    //                vc.flag = "1"
//    //                vc.identifier3 = "NomineeVC"
//    //                vc.delegate = self
//    //
//    //                navigationController?.pushViewController(vc, animated: true)
//    //        }
//    //    }
//
//    func navigationToVeriticsVC() {
//        let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
//        let vc = storyboard.instantiateViewController(identifier: "digiNomiVC") as! digiNomiVC
//        vc.panNo = panNo
//        vc.RegId = RegId
//        vc.digilockerDone = "Done"
//        vc.identifier3 = "NomineeVC"
//        vc.identifier1 = digiIdentifier
//        vc.delegate = self
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func toggleGuardianFields(for nomineeIndex: Int, show: Bool) {
//        switch nomineeIndex {
//        case 1:
//            gurdianLabel1.isHidden = !show
//            guardian1DocumentType.isHidden = !show
//            guardian1DocumentBtn.isHidden = !show
//            guardianName1.isHidden = !show
//            guardianNameTxt1.isHidden = !show
//            guardianDobLabel1.isHidden = !show
//            guardianDobBtn1.isHidden = !show
//            guardianDobTxt1.isHidden = !show
//            guardianIDLabel1.isHidden = !show
//            guardianIdTxt.isHidden = !show
//            guardianVerify.isHidden = !show
//            guardianMobileLabel1.isHidden = !show
//            guardianMobileTxt1.isHidden = !show
//            guardianEmailLabel1.isHidden = !show
//            guardianEmailIdTxt1.isHidden = !show
//            guardianAddressSameBtn1.isHidden = !show
//            GuardianAddressLbl1.isHidden = !show
//            guardianAddressTxt1.isHidden = !show
//            GuardianAddress1Lbl1.isHidden = !show
//            guardianAddress1Txt1.isHidden = !show
//            GuardianAddress2Lbl1.isHidden = !show
//            GuardianAddress2Txt1.isHidden = !show
//            guardianPin1Lbl1.isHidden = !show
//            guardianPin1Txt1.isHidden = !show
//            guardianCity1Lbl1.isHidden = !show
//            guardianCity1Txt1.isHidden = !show
//            guardianState1Lbl1.isHidden = !show
//            guardianState1Txt1.isHidden = !show
//
//        case 2:
//            gurdianLabel2.isHidden = !show
//            guardian2DocumentType.isHidden = !show
//            guardian2DocumentBtn.isHidden = !show
//            guardianName2.isHidden = !show
//            guardianNameTxt2.isHidden = !show
//            guardianDobLabel2.isHidden = !show
//            guardianDobBtn2.isHidden = !show
//            guardianDobTxt2.isHidden = !show
//            guardianIDLabel2.isHidden = !show
//            guardianIdTxt2.isHidden = !show
//            guardianVerify2.isHidden = !show
//            guardianMobileLabel2.isHidden = !show
//            guardianMobileTxt2.isHidden = !show
//            guardianEmailLabel2.isHidden = !show
//            guardianEmailIdTxt2.isHidden = !show
//            guardianAddressSameBtn2.isHidden = !show
//            GuardianAddressLbl2.isHidden = !show
//            guardianAddressTxt2.isHidden = !show
//            GuardianAddress1Lbl2.isHidden = !show
//            guardianAddress1Txt2.isHidden = !show
//            GuardianAddress2Lbl2.isHidden = !show
//            GuardianAddress2Txt2.isHidden = !show
//            guardianPin1Lbl2.isHidden = !show
//            guardianPin1Txt2.isHidden = !show
//            guardianCity1Lbl2.isHidden = !show
//            guardianCity1Txt2.isHidden = !show
//            guardianState1Lbl2.isHidden = !show
//            guardianState1Txt2.isHidden = !show
//
//        case 3:
//            gurdianLabel3.isHidden = !show
//            guardian3DocumentType.isHidden = !show
//            guardian3DocumentBtn.isHidden = !show
//            guardianName3.isHidden = !show
//            guardianNameTxt3.isHidden = !show
//            guardianDobLabel3.isHidden = !show
//            guardianDobBtn3.isHidden = !show
//            guardianDobTxt3.isHidden = !show
//            guardianIDLabel3.isHidden = !show
//            guardianIdTxt3.isHidden = !show
//            guardianVerify3.isHidden = !show
//            guardianMobileLabel3.isHidden = !show
//            guardianMobileTxt3.isHidden = !show
//            guardianEmailLabel3.isHidden = !show
//            guardianEmailIdTxt3.isHidden = !show
//            guardianAddressSameBtn3.isHidden = !show
//            GuardianAddressLbl3.isHidden = !show
//            guardianAddressTxt3.isHidden = !show
//            GuardianAddress1Lbl3.isHidden = !show
//            guardianAddress1Txt3.isHidden = !show
//            GuardianAddress2Lbl3.isHidden = !show
//            GuardianAddress2Txt3.isHidden = !show
//            guardianPin1Lbl3.isHidden = !show
//            guardianPin1Txt3.isHidden = !show
//            guardianCity1Lbl3.isHidden = !show
//            guardianCity1Txt3.isHidden = !show
//            guardianState1Lbl3.isHidden = !show
//            guardianState1Txt3.isHidden = !show
//
//        default:
//            break
//        }
//    }
//
//    func didSelectDate(_ date: String, identifier: String) {
//
//        switch identifier {
//
//        case "nomineeDOB1":
//            nomineeDobTxt1.text = date
//            if let age = calculateAge(from: date) {
//                toggleGuardianFields(for: 1, show: age < 18)
//            }
//
//        case "nomineeDOB2":
//            nomineeDobTxt2.text = date
//            if let age = calculateAge(from: date) {
//                toggleGuardianFields(for: 2, show: age < 18)
//            }
//
//        case "nomineeDOB3":
//            nomineeDobTxt3.text = date
//            if let age = calculateAge(from: date) {
//                toggleGuardianFields(for: 3, show: age < 18)
//                NomineeMinor = age < 18 ? "Y" : "N"
//            }
//
//        case "guardianDOB1":
//            guardianDobTxt1.text = date
//            if let age = calculateAge(from: date) {
//                // toggleGuardianHolderViews(show: age < 18)
//                NomineeMinor = "Y"
//            }
//
//        case "guardianDOB2":
//            guardianDobTxt2.text = date
//            if let age = calculateAge(from: date) {
//                // toggleGuardianHolderViews(show: age < 18)
//                NomineeMinor = "Y"
//            }
//
//        case "guardianDOB3":
//            guardianDobTxt3.text = date
//            if let age = calculateAge(from: date) {
//                // toggleGuardianHolderViews(show: age < 18)
//                NomineeMinor = "Y"
//            }
//
//        default:
//            break
//        }
//    }
//
//    func verifyNominee(index: Int) {
//
//        var panNo = ""
//        var name = ""
//        var dob = ""
//
//        switch index {
//        case 1:
//            panNo = documentIdTxt.text ?? ""
//            name = nomineeNameTxt1.text ?? ""
//            dob = nomineeDobTxt1.text ?? ""
//        case 2:
//            panNo = documentIdTxt2.text ?? ""
//            name = nomineeNameTxt2.text ?? ""
//            dob = nomineeDobTxt2.text ?? ""
//        case 3:
//            panNo = documentIdTxt3.text ?? ""
//            name = nomineeNameTxt3.text ?? ""
//            dob = nomineeDobTxt3.text ?? ""
//        default:
//            return
//        }
//
//        guard !panNo.isEmpty, !name.isEmpty, !dob.isEmpty else {
//            showAlert(message: "Please enter Guardian details.")
//            return
//        }
//
//        if let age = calculateAge(from: dob) {
//            toggleGuardianFields(for: index, show: age < 18)
//        }
//
//        self.identifier = "Nominee\(index)"
//        panValidation(panNo: panNo, name: name, userDOB: dob, isGuardian: false)
//    }
//
//    func verifyGuardian(index: Int) {
//
//        var panNo = ""
//        var name = ""
//        var dob = ""
//
//        switch index {
//        case 1:
//            panNo = guardianIdTxt.text ?? ""
//            name = guardianNameTxt1.text ?? ""
//            dob = guardianDobTxt1.text ?? ""
//        case 2:
//            panNo = guardianIdTxt2.text ?? ""
//            name = guardianNameTxt2.text ?? ""
//            dob = guardianDobTxt2.text ?? ""
//        case 3:
//            panNo = guardianIdTxt3.text ?? ""
//            name = guardianNameTxt3.text ?? ""
//            dob = guardianDobTxt3.text ?? ""
//        default:
//            return
//        }
//
//        guard !panNo.isEmpty, !name.isEmpty, !dob.isEmpty else {
//            showAlert(message: "Please enter all nominee details.")
//            return
//        }
//        self.identifier = "Nominee\(index)"
//        panValidation(panNo: panNo, name: name, userDOB: dob, isGuardian: true)
//    }
//
//    func isValidEmail(_ email: String) -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
//        return emailTest.evaluate(with: email)
//    }
//
//    func isValidMobile(_ mobile: String) -> Bool {
//        let mobileRegex = "^[0-9]{10}$"
//        return NSPredicate(format: "SELF MATCHES %@", mobileRegex).evaluate(with: mobile)
//    }
//
//    func isValidPinCode(_ pincode: String) -> Bool {
//        let pinRegex = "^[0-9]{6}$"
//        return NSPredicate(format: "SELF MATCHES %@", pinRegex).evaluate(with: pincode)
//    }
//
//    @IBAction func proceedBtn(_ sender: UIButton) {
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
//                                    //                                    nextVC.PanNo = self.panNo
//                                    //                                    nextVC.RegId = self.RegId
//                                    //                                    nextVC.delegate = self
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
//
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
//
//    func validateNomineeAllocation() {
//        // Assign values from text fields to global variables
//        nominee1Allocation = shareTxt1.text ?? ""
//        nominee2Allocation = shareTxt2.text ?? ""
//        nominee3Allocation = shareTxt3.text ?? ""
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

//    private func fillNomineeFields(data: [String: Any], index: Int) {
//        let address1   = data["Address1"]   as? String ?? ""
//        let address2   = data["Address2"]   as? String ?? ""
//        let address3   = data["Address3"]   as? String ?? ""
//        let pincode    = data["PinCode"]    as? String ?? ""
//        let city       = data["City"]       as? String ?? ""
//        let state      = data["State"]      as? String ?? ""
//        let uid        = data["Uid"]        as? String ?? ""
//        let name       = data["NameAsPerAadhaar"] as? String ?? ""
//        let dob        = data["DOB"]        as? String ?? ""
//
//        switch index {
//        case 1:
//            address1Txt1.text = address1
//            address2Txt1.text = address2
//            address3Txt1.text = address3
//            pinTxt1.text      = pincode
//            cityTxt1.text     = city
//            stateTxt1.text    = state
//            documentIdTxt.text = uid          // ← shared field? see note below
//            nomineeNameTxt1.text = name
//            nomineeDobTxt1.text = dob
//
//        case 2:
//            address1Txt2.text = address1
//            address2Txt2.text = address2
//            address3Txt2.text = address3
//            pinTxt2.text      = pincode
//            cityTxt2.text     = city
//            stateTxt2.text    = state
//            documentIdTxt2.text = uid
//            nomineeNameTxt2.text = name
//            nomineeDobTxt2.text = dob
//
//        case 3:
//            address1Txt3.text = address1
//            address2Txt3.text = address3
//            address3Txt3.text = address3
//            pinTxt3.text      = pincode
//            cityTxt3.text     = city
//            stateTxt3.text    = state
//            documentIdTxt3.text = uid
//            nomineeNameTxt3.text = name
//            nomineeDobTxt3.text = dob
//
//        default: break
//        }
//
//        // Common logic
//        if let age = calculateAge(from: dob) {
//            toggleGuardianFields(for: index, show: age < 18)
//        }
//
//        validatePinCode(pinCode: pincode, for: "nominee")
//        isNomineeVerified = true
//
//        print("✅ Auto-filled Nominee \(index) from DigiLocker")
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
//                           // let Country = firstItem["Country"] as? String
//                            if type == "nominee" {
//                                self.cityTxt1.text = city
//                                self.stateTxt1.text = state
//                                self.cityTxt1.isUserInteractionEnabled = false
//                                self.stateTxt1.isUserInteractionEnabled = false
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
//import UIKit
//
//class NomineeVC: UIViewController, @MainActor SelectionDelegate, @MainActor VerticsVCDelegate, @MainActor CalenderVCDelegate, @MainActor DigiLocker_b_VCDelegate, @MainActor ReloadPageDelegate {
//
//    func didDismissDigiLockerVC() {
//        self.dismiss(animated: true)
//    }
//
//    func reloadPageData() {
//        self.ViewAllNomineeDetails()
//    }
//
//    func didReceiveApiResponse(data: [String : Any], identifier1: String, identifier3: String){
//        // 1. Auto-fill the correct nominee's fields
//        switch identifier1 {
//        case "NomineeDocument1":
//            fillNomineeFields(data: data, index: 1)
//        case "NomineeDocument2":
//            fillNomineeFields(data: data, index: 2)
//        case "NomineeDocument3":
//            fillNomineeFields(data: data, index: 3)
//
//        case "guardianDocument1":
//            fillGuardianFields(data: data, index: 1)
//
//        case "guardianDocument2":
//            fillGuardianFields(data: data, index: 2)
//
//        case "guardianDocument3":
//            fillGuardianFields(data: data, index: 3)
//        default:
//            print("Unknown identifier: \(identifier1)")
//        }
//
//        // 2. OPTIONAL: Show DigiLocker_b_VC (summary screen) after success
//        // If you want ONLY auto-fill + back to Nominee page, comment the whole block below
//        showDigiLockerSummaryVC(data: data)
//    }
//
//    private func showDigiLockerSummaryVC(data: [String: Any]) {
//        let name = data["NameAsPerAadhaar"] as? String
//        let dob = data["DOB"] as? String
//        let gender = data["Gender"] as? String
//        let fatherName = data["FatherSpouseName"] as? String
//
//        let address = [
//            data["Address1"] as? String,
//            data["Address2"] as? String,
//            data["Address3"] as? String,
//            data["City"] as? String,
//            data["State"] as? String,
//            data["PinCode"] as? String
//        ].compactMap { $0 }.joined(separator: ", ")
//
//        let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
//        guard let vc = storyboard.instantiateViewController(withIdentifier: "DigiLocker_b_VC") as? DigiLocker_b_VC else { return }
//
//        vc.name = name
//        vc.dob = dob
//        vc.gender = gender
//        vc.fatherName = fatherName
//        vc.address = address
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//        vc.delegate = self
//
//        // Present after a slight delay
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.present(vc, animated: true)
//        }
//    }
//
//
//    func didSelectDepository(type: String, identifier: String) {
//        print("🔵 [didSelectDepository] Called → Type: \(type) | Identifier: \(identifier)")
//
//        switch identifier {
//
//            // MARK: - Nominee Documents
//        case "NomineeDocument1":
//            print("   → Setting Nominee 1 button to \(type)")
//            documentTypeBtn1.setTitle(type, for: .normal)
//            nomineedocumentType1 = type
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "NomineeDocument1")
//            }
//
//        case "NomineeDocument2":
//            print("   → Setting Nominee 2 button to \(type)")
//            documentTypeBtn2.setTitle(type, for: .normal)
//            nomineedocumentType2 = type
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "NomineeDocument2")
//            }
//
//        case "NomineeDocument3":
//            print("   → Setting Nominee 3 button to \(type)")
//            documentTypeBtn3.setTitle(type, for: .normal)
//            nomineedocumentType3 = type
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "NomineeDocument3")
//            }
//
//            // MARK: - Guardian Documents (Fixed wrong button names)
//        case "guardianDocument1":
//            print("   → Setting Guardian 1 button to \(type)")
//            guardian1DocumentBtn.setTitle(type, for: .normal)
//            guardiandocumentType1 = type
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "guardianDocument1")
//            }
//
//        case "guardianDocument2":
//            print("   → Setting Guardian 2 button to \(type)")
//            guardian2DocumentBtn.setTitle(type, for: .normal)
//            guardiandocumentType2 = type
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "guardianDocument2")
//            }
//
//        case "guardianDocument3":
//            print("   → Setting Guardian 3 button to \(type)")
//            guardian3DocumentBtn.setTitle(type, for: .normal)
//            guardiandocumentType3 = type
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "guardianDocument3")
//            }
//
//        default:
//            print("→ Unknown identifier: \(identifier)")
//            break
//        }
//    }
//
//
//    @IBOutlet weak var optInBtn: UIButton!
//    @IBOutlet weak var optOutBtn: UIButton!
//    @IBOutlet weak var mainStack: UIStackView!
//    @IBOutlet weak var nomineeView1: UIStackView!
//    @IBOutlet weak var nomineeLabel1: UILabel!
//    @IBOutlet weak var nomineeBtn1: UIButton!
//    @IBOutlet weak var viewLine1: UIView!
//    @IBOutlet weak var stackView1: UIStackView!
//    @IBOutlet weak var documentType1: UILabel!
//    @IBOutlet weak var documentTypeBtn1: UIButton!
//    @IBOutlet weak var documentIdLabel: UILabel!
//    @IBOutlet weak var documentIdTxt: UITextField!
//    @IBOutlet weak var nomineeVerifyBtn1: UIButton!
//    @IBOutlet weak var nomineeName1: UILabel!
//    @IBOutlet weak var nomineeNameTxt1: UITextField!
//    @IBOutlet weak var dob1: UILabel!
//    @IBOutlet weak var nomineeDobTxt1: UITextField!
//    @IBOutlet weak var selectDateBtn1: UIButton!
//    @IBOutlet weak var nomineeMobileLabel1: UILabel!
//    @IBOutlet weak var nomineeMobileTxt1: UITextField!
//    @IBOutlet weak var nomineeEmailLabel1: UILabel!
//    @IBOutlet weak var nomineeEmailTxt1: UITextField!
//    @IBOutlet weak var addressBtn1: UIButton!
//    @IBOutlet weak var address1Label1: UILabel!
//    @IBOutlet weak var address1Txt1: UITextField!
//    @IBOutlet weak var address2Label1: UILabel!
//    @IBOutlet weak var address3Label1: UILabel!
//    @IBOutlet weak var address2Txt1: UITextField!
//    @IBOutlet weak var address3Txt1: UITextField!
//    @IBOutlet weak var pinLabel1: UILabel!
//    @IBOutlet weak var pinTxt1: UITextField!
//    @IBOutlet weak var cityLabel1: UILabel!
//    @IBOutlet weak var cityTxt1: UITextField!
//    @IBOutlet weak var stateLabel1: UILabel!
//    @IBOutlet weak var stateTxt1: UITextField!
//    @IBOutlet weak var relationLabel1: UILabel!
//    @IBOutlet weak var relationBtn1: UIButton!
//    @IBOutlet weak var shareLabel1: UILabel!
//    @IBOutlet weak var shareTxt1: UITextField!
//    @IBOutlet weak var nominee1View1: UIView!
//
//    @IBOutlet weak var gurdianLabel1: UILabel!
//    @IBOutlet weak var guardian1DocumentType: UILabel!
//    @IBOutlet weak var guardian1DocumentBtn: UIButton!
//    @IBOutlet weak var guardianName1: UILabel!
//    @IBOutlet weak var guardianNameTxt1: UITextField!
//    @IBOutlet weak var guardianDobLabel1: UILabel!
//    @IBOutlet weak var guardianDobBtn1: UIButton!
//
//    @IBOutlet weak var guardianDobTxt1: UITextField!
//
//    @IBOutlet weak var guardianIDLabel1: UILabel!
//    @IBOutlet weak var guardianIdTxt: UITextField!
//
//    @IBOutlet weak var guardianVerify: UIButton!
//    @IBOutlet weak var guardianMobileLabel1: UILabel!
//    @IBOutlet weak var guardianMobileTxt1: UITextField!
//    @IBOutlet weak var guardianEmailLabel1: UILabel!
//    @IBOutlet weak var guardianEmailIdTxt1: UITextField!
//    @IBOutlet weak var guardianAddressSameBtn1: UIButton!
//    @IBOutlet weak var GuardianAddressLbl1: UILabel!
//    @IBOutlet weak var guardianAddressTxt1: UITextField!
//    @IBOutlet weak var GuardianAddress1Lbl1: UILabel!
//    @IBOutlet weak var guardianAddress1Txt1: UITextField!
//    @IBOutlet weak var GuardianAddress2Lbl1: UILabel!
//    @IBOutlet weak var GuardianAddress2Txt1: UITextField!
//    @IBOutlet weak var guardianPin1Lbl1: UILabel!
//    @IBOutlet weak var guardianPin1Txt1: UITextField!
//    @IBOutlet weak var guardianCity1Lbl1: UILabel!
//    @IBOutlet weak var guardianCity1Txt1: UITextField!
//    @IBOutlet weak var guardianState1Lbl1: UILabel!
//    @IBOutlet weak var guardianState1Txt1: UITextField!
//
//    @IBOutlet weak var nomineeView2: UIStackView!
//    @IBOutlet weak var nominee3View3: UIView!
//    @IBOutlet weak var viewLine2: UIView!
//    @IBOutlet weak var stackView2: UIStackView!
//    @IBOutlet weak var nomineeBtn2: UIButton!
//    @IBOutlet weak var documentType2: UILabel!
//    @IBOutlet weak var documentTypeBtn2: UIButton!
//    @IBOutlet weak var documentIdLabel2: UILabel!
//    @IBOutlet weak var documentIdTxt2:
//    UITextField!
//
//    @IBOutlet weak var nomineeName2: UILabel!
//    @IBOutlet weak var nomineeNameTxt2: UITextField!
//    @IBOutlet weak var dob2: UILabel!
//    @IBOutlet weak var selectDateBtn2: UIButton!
//    @IBOutlet weak var nomineeMobileLabel2: UILabel!
//    @IBOutlet weak var nomineeMobileTxt2: UITextField!
//    @IBOutlet weak var nomineeEmailLabel2: UILabel!
//    @IBOutlet weak var nomineeEmailTxt2: UITextField!
//    @IBOutlet weak var addressBtn2: UIButton!
//    @IBOutlet weak var address1Label2: UILabel!
//    @IBOutlet weak var address1Txt2: UITextField!
//    @IBOutlet weak var address2Label2: UILabel!
//    @IBOutlet weak var address3Label2: UILabel!
//    @IBOutlet weak var address2Txt2: UITextField!
//    @IBOutlet weak var address3Txt2: UITextField!
//    @IBOutlet weak var pinLabel2: UILabel!
//    @IBOutlet weak var pinTxt2: UITextField!
//    @IBOutlet weak var cityLabel2: UILabel!
//    @IBOutlet weak var cityTxt2: UITextField!
//    @IBOutlet weak var stateLabel2: UILabel!
//    @IBOutlet weak var stateTxt2: UITextField!
//    @IBOutlet weak var relationLabel2: UILabel!
//    @IBOutlet weak var relationBtn2: UIButton!
//    @IBOutlet weak var shareLabel2: UILabel!
//    @IBOutlet weak var shareTxt2: UITextField!
//    @IBOutlet weak var gurdianLabel2: UILabel!
//    @IBOutlet weak var guardian2DocumentType: UILabel!
//    @IBOutlet weak var guardian2DocumentBtn: UIButton!
//    @IBOutlet weak var guardianName2: UILabel!
//    @IBOutlet weak var guardianNameTxt2: UITextField!
//    @IBOutlet weak var guardianDobLabel2: UILabel!
//    @IBOutlet weak var guardianDobBtn2: UIButton!
//    @IBOutlet weak var guardianDobTxt2: UITextField!
//    @IBOutlet weak var guardianIDLabel2: UILabel!
//    @IBOutlet weak var guardianIdTxt2: UITextField!
//    @IBOutlet weak var guardianVerify2: UIButton!
//    @IBOutlet weak var guardianMobileLabel2: UILabel!
//    @IBOutlet weak var guardianMobileTxt2: UITextField!
//    @IBOutlet weak var guardianEmailLabel2: UILabel!
//    @IBOutlet weak var guardianEmailIdTxt2: UITextField!
//    @IBOutlet weak var guardianAddressSameBtn2: UIButton!
//    @IBOutlet weak var GuardianAddressLbl2: UILabel!
//    @IBOutlet weak var guardianAddressTxt2: UITextField!
//    @IBOutlet weak var GuardianAddress1Lbl2: UILabel!
//    @IBOutlet weak var guardianAddress1Txt2: UITextField!
//    @IBOutlet weak var GuardianAddress2Lbl2: UILabel!
//    @IBOutlet weak var GuardianAddress2Txt2: UITextField!
//    @IBOutlet weak var guardianPin1Lbl2: UILabel!
//    @IBOutlet weak var guardianPin1Txt2: UITextField!
//    @IBOutlet weak var guardianCity1Lbl2: UILabel!
//    @IBOutlet weak var guardianCity1Txt2: UITextField!
//    @IBOutlet weak var guardianState1Lbl2: UILabel!
//    @IBOutlet weak var guardianState1Txt2: UITextField!
//    @IBOutlet weak var nomineeDobTxt2: UITextField!
//
//    @IBOutlet weak var nomineeView3: UIStackView!
//    @IBOutlet weak var nominee2View2: UIView!
//    @IBOutlet weak var viewLine3: UIView!
//    @IBOutlet weak var stackView3: UIStackView!
//    @IBOutlet weak var nomineeBtn3: UIButton!
//    @IBOutlet weak var documentType3: UILabel!
//    @IBOutlet weak var documentTypeBtn3: UIButton!
//    @IBOutlet weak var documentIdLabel3: UILabel!
//    @IBOutlet weak var documentIdTxt3: UITextField!
//    @IBOutlet weak var nomineeVerify3: UIButton!
//    @IBOutlet weak var nomineeName3: UILabel!
//    @IBOutlet weak var nomineeNameTxt3: UITextField!
//    @IBOutlet weak var dob3: UILabel!
//    @IBOutlet weak var selectDateBtn3: UIButton!
//    @IBOutlet weak var nomineeDobTxt3: UITextField!
//    @IBOutlet weak var nomineeMobileLabel3: UILabel!
//    @IBOutlet weak var nomineeMobileTxt3: UITextField!
//    @IBOutlet weak var nomineeEmailLabel3: UILabel!
//    @IBOutlet weak var nomineeEmailTxt3: UITextField!
//    @IBOutlet weak var addressBtn3: UIButton!
//    @IBOutlet weak var address1Label3: UILabel!
//    @IBOutlet weak var address1Txt3: UITextField!
//    @IBOutlet weak var address2Label3: UILabel!
//    @IBOutlet weak var address2Txt3: UITextField!
//    @IBOutlet weak var address3Label3: UILabel!
//    @IBOutlet weak var address3Txt3: UITextField!
//    @IBOutlet weak var pinLabel3: UILabel!
//    @IBOutlet weak var pinTxt3: UITextField!
//    @IBOutlet weak var cityLabel3: UILabel!
//    @IBOutlet weak var cityTxt3: UITextField!
//    @IBOutlet weak var stateLabel3: UILabel!
//    @IBOutlet weak var stateTxt3: UITextField!
//    @IBOutlet weak var relationLabel3: UILabel!
//    @IBOutlet weak var relationBtn3: UIButton!
//    @IBOutlet weak var shareLabel3: UILabel!
//    @IBOutlet weak var shareTxt3: UITextField!
//
//    @IBOutlet weak var addNomineebtn: UIButton!
//    @IBOutlet weak var instructionLabel: UILabel!
//    @IBOutlet weak var instruction1Label: UILabel!
//    @IBOutlet weak var proceedBtn: UIButton!
//    @IBOutlet weak var gurdianLabel3: UILabel!
//    @IBOutlet weak var guardian3DocumentType: UILabel!
//    @IBOutlet weak var guardian3DocumentBtn: UIButton!
//    @IBOutlet weak var guardianName3: UILabel!
//    @IBOutlet weak var guardianNameTxt3: UITextField!
//    @IBOutlet weak var guardianDobLabel3: UILabel!
//    @IBOutlet weak var guardianDobBtn3: UIButton!
//    @IBOutlet weak var guardianDobTxt3: UITextField!
//
//    @IBOutlet weak var guardianIDLabel3: UILabel!
//    @IBOutlet weak var guardianIdTxt3: UITextField!
//    @IBOutlet weak var guardianVerify3: UIButton!
//    @IBOutlet weak var guardianMobileLabel3: UILabel!
//    @IBOutlet weak var guardianMobileTxt3: UITextField!
//    @IBOutlet weak var guardianEmailLabel3: UILabel!
//    @IBOutlet weak var guardianEmailIdTxt3: UITextField!
//    @IBOutlet weak var guardianAddressSameBtn3: UIButton!
//    @IBOutlet weak var GuardianAddressLbl3: UILabel!
//    @IBOutlet weak var guardianAddressTxt3: UITextField!
//    @IBOutlet weak var GuardianAddress1Lbl3: UILabel!
//    @IBOutlet weak var guardianAddress1Txt3: UITextField!
//    @IBOutlet weak var GuardianAddress2Lbl3: UILabel!
//    @IBOutlet weak var GuardianAddress2Txt3: UITextField!
//    @IBOutlet weak var guardianPin1Lbl3: UILabel!
//    @IBOutlet weak var guardianPin1Txt3: UITextField!
//    @IBOutlet weak var guardianCity1Lbl3: UILabel!
//    @IBOutlet weak var guardianCity1Txt3: UITextField!
//    @IBOutlet weak var guardianState1Lbl3: UILabel!
//    @IBOutlet weak var guardianState1Txt3: UITextField!
//
//
//    var nomineeCount = 0
//    var NomineeType: String = "N"
//    var isNominee1Expanded = false
//    var isNominee2Expanded = false
//    var isNominee3Expanded = false
//    var nomineedocumentType1 : String?
//    var nomineedocumentType2 : String?
//    var nomineedocumentType3 : String?
//    var guardiandocumentType1 : String?
//    var guardiandocumentType2 : String?
//    var guardiandocumentType3 : String?
//    var fetchedUserId: String?
//    var fetchedSessionID: String?
//    var mobiledecodeArray: String?
//    var identifier: String = ""
//    var RegId: String?
//    var panNo: String?
//    var isNomineeVerified = false
//    var NomineeMinor : String?
//    var regId: String?
//    var PANName: String?
//    var EmailId: String?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        nomineeView1.isHidden = true
//        nomineeView2.isHidden = true
//        nomineeView3.isHidden = true
//
//        mainStack.isHidden = true
//
//        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
//            guard let self = self else { return }
//
//            if let userId = userId, let sessionID = sessionID {
//                self.fetchedUserId = userId
//                self.fetchedSessionID = sessionID
//                self.mobiledecodeArray = decodeByteArrayString
//                print("UserID: \(userId), SessionID: \(sessionID)")
//                // self.ViewAllNomineeDetails()
//            } else {
//                print("No UserID or SessionID found.")
//            }
//        }
//
//        toggleGuardianFields(for: 1, show: false)
//        toggleGuardianFields(for: 2, show: false)
//        toggleGuardianFields(for: 3, show: false)
//
//        nominee1View1.layer.cornerRadius = 10
//        nominee1View1.layer.borderWidth = 0.5
//        nominee1View1.layer.borderColor = UIColor.gray.cgColor
//
//        nominee2View2.layer.cornerRadius = 10
//        nominee2View2.layer.borderWidth = 0.5
//        nominee2View2.layer.borderColor = UIColor.gray.cgColor
//
//        nominee3View3.layer.cornerRadius = 10
//        nominee3View3.layer.borderWidth = 0.5
//        nominee3View3.layer.borderColor = UIColor.gray.cgColor
//    }
//
//    private func fillNomineeFields(data: [String: Any], index: Int) {
//        let name = data["NameAsPerAadhaar"] as? String ?? ""
//        let dob = data["DOB"] as? String ?? ""
//        let uid = data["Uid"] as? String ?? ""
//        let gender = data["Gender"] as? String ?? ""
//        let fatherName = data["FatherSpouseName"] as? String ?? ""
//
//        let address1 = data["Address1"] as? String ?? ""
//        let address2 = data["Address2"] as? String ?? ""
//        let address3 = data["Address3"] as? String ?? ""
//        let city = data["City"] as? String ?? ""
//        let state = data["State"] as? String ?? ""
//        let pincode = data["PinCode"] as? String ?? ""
//
//        // Optional fields if available
//        let mobile = data["Mobile"] as? String ?? ""
//        let email = data["Email"] as? String ?? ""
//
//        switch index {
//        case 1:
//            // Nominee fields
//            nomineeNameTxt1.text = name
//            nomineeDobTxt1.text = dob
//            documentIdTxt.text = uid
//            nomineeMobileTxt1.text = mobile
//            nomineeEmailTxt1.text = email
//
//            // Address fields
//            address1Txt1.text = address1
//            address2Txt1.text = address2
//            address3Txt1.text = address3
//            cityTxt1.text = city
//            stateTxt1.text = state
//            pinTxt1.text = pincode
//
//            // Set document type
//            documentTypeBtn1.setTitle("Aadhaar", for: .normal)
//            nomineedocumentType1 = "Aadhaar"
//
//            // Disable fields after verification
//            nomineeNameTxt1.isEnabled = false
//            nomineeDobTxt1.isEnabled = false
//            documentIdTxt.isEnabled = false
//            documentTypeBtn1.isEnabled = false
//            address1Txt1.isEnabled = false
//            address2Txt1.isEnabled = false
//            address3Txt1.isEnabled = false
//            pinTxt1.isEnabled = false
//            cityTxt1.isEnabled = false
//            stateTxt1.isEnabled = false
//
//        case 2:
//            // Nominee fields
//            nomineeNameTxt2.text = name
//            nomineeDobTxt2.text = dob
//            documentIdTxt2.text = uid
//            nomineeMobileTxt2.text = mobile
//            nomineeEmailTxt2.text = email
//
//            // Address fields
//            address1Txt2.text = address1
//            address2Txt2.text = address2
//            address3Txt2.text = address3
//            cityTxt2.text = city
//            stateTxt2.text = state
//            pinTxt2.text = pincode
//
//            // Set document type
//            documentTypeBtn2.setTitle("Aadhaar", for: .normal)
//            nomineedocumentType2 = "Aadhaar"
//
//            // Disable fields
//            nomineeNameTxt2.isEnabled = false
//            nomineeDobTxt2.isEnabled = false
//            documentIdTxt2.isEnabled = false
//            documentTypeBtn2.isEnabled = false
//            address1Txt2.isEnabled = false
//            address2Txt2.isEnabled = false
//            address3Txt2.isEnabled = false
//            pinTxt2.isEnabled = false
//            cityTxt2.isEnabled = false
//            stateTxt2.isEnabled = false
//
//        case 3:
//            // Nominee fields
//            nomineeNameTxt3.text = name
//            nomineeDobTxt3.text = dob
//            documentIdTxt3.text = uid
//            nomineeMobileTxt3.text = mobile
//            nomineeEmailTxt3.text = email
//
//            // Address fields
//            address1Txt3.text = address1
//            address2Txt3.text = address2
//            address3Txt3.text = address3
//            cityTxt3.text = city
//            stateTxt3.text = state
//            pinTxt3.text = pincode
//
//            // Set document type
//            documentTypeBtn3.setTitle("Aadhaar", for: .normal)
//            nomineedocumentType3 = "Aadhaar"
//
//            // Disable fields
//            nomineeNameTxt3.isEnabled = false
//            nomineeDobTxt3.isEnabled = false
//            documentIdTxt3.isEnabled = false
//            documentTypeBtn3.isEnabled = false
//            address1Txt3.isEnabled = false
//            address2Txt3.isEnabled = false
//            address3Txt3.isEnabled = false
//            pinTxt3.isEnabled = false
//            cityTxt3.isEnabled = false
//            stateTxt3.isEnabled = false
//
//        default:
//            return
//        }
//
//        // Age check and guardian visibility
//        if let age = calculateAge(from: dob) {
//            toggleGuardianFields(for: index, show: age < 18)
//        }
//
//        // Validate pincode to fetch city/state if needed
//        validatePinCode(pinCode: pincode, for: "nominee", index: index)
//
//        print("✅ Successfully auto-filled Nominee \(index)")
//    }
//
//    private func fillGuardianFields(data: [String: Any], index: Int) {
//        print("🔧 Filling Guardian \(index) with DigiLocker data")
//
//        let name = data["NameAsPerAadhaar"] as? String ?? ""
//        let dob = data["DOB"] as? String ?? ""
//        let uid = data["Uid"] as? String ?? ""
//
//        let address1 = data["Address1"] as? String ?? ""
//        let address2 = data["Address2"] as? String ?? ""
//        let address3 = data["Address3"] as? String ?? ""
//        let city = data["City"] as? String ?? ""
//        let state = data["State"] as? String ?? ""
//        let pincode = data["PinCode"] as? String ?? ""
//
//        switch index {
//        case 1:
//            guardianNameTxt1.text = name
//            guardianDobTxt1.text = dob
//            guardianIdTxt.text = uid
//
//            guardianAddressTxt1.text = address1
//            guardianAddress1Txt1.text = address2
//            GuardianAddress2Txt1.text = address3
//            guardianCity1Txt1.text = city
//            guardianState1Txt1.text = state
//            guardianPin1Txt1.text = pincode
//
//            guardian1DocumentBtn.setTitle("Aadhaar", for: .normal)
//            guardiandocumentType1 = "Aadhaar"
//
//        case 2:
//            guardianNameTxt2.text = name
//            guardianDobTxt2.text = dob
//            guardianIdTxt2.text = uid
//
//            guardianAddressTxt2.text = address1
//            guardianAddress1Txt2.text = address2
//            GuardianAddress2Txt2.text = address3
//            guardianCity1Txt2.text = city
//            guardianState1Txt2.text = state
//            guardianPin1Txt2.text = pincode
//
//            guardian2DocumentBtn.setTitle("Aadhaar", for: .normal)
//            guardiandocumentType2 = "Aadhaar"
//
//        case 3:
//            guardianNameTxt3.text = name
//            guardianDobTxt3.text = dob
//            guardianIdTxt3.text = uid
//
//            guardianAddressTxt3.text = address1
//            guardianAddress1Txt3.text = address2
//            GuardianAddress2Txt3.text = address3
//            guardianCity1Txt3.text = city
//            guardianState1Txt3.text = state
//            guardianPin1Txt3.text = pincode
//
//            guardian3DocumentBtn.setTitle("Aadhaar", for: .normal)
//            guardiandocumentType3 = "Aadhaar"
//
//        default:
//            return
//        }
//
//        print("✅ Successfully auto-filled Guardian \(index)")
//    }
//
//    private func disableNomineeFieldsAfterDigiLocker(index: Int) {
//        switch index {
//        case 1:
//            nomineeNameTxt1.isEnabled   = false
//            nomineeDobTxt1.isEnabled    = false
//            documentIdTxt.isEnabled     = false
//            documentTypeBtn1.isEnabled  = false
//            address1Txt1.isEnabled      = false
//            address2Txt1.isEnabled      = false
//            address3Txt1.isEnabled      = false
//            pinTxt1.isEnabled           = false
//            // Optionally disable mobile/email too if you consider them final
//            // nomineeMobileTxt1.isEnabled = false
//            // nomineeEmailTxt1.isEnabled  = false
//
//        case 2:
//            nomineeNameTxt2.isEnabled   = false
//            nomineeDobTxt2.isEnabled    = false
//            documentIdTxt2.isEnabled    = false
//            documentTypeBtn2.isEnabled  = false
//            address1Txt2.isEnabled      = false
//            address2Txt2.isEnabled      = false
//            address3Txt2.isEnabled      = false
//            pinTxt2.isEnabled           = false
//
//        case 3:
//            nomineeNameTxt3.isEnabled   = false
//            nomineeDobTxt3.isEnabled    = false
//            documentIdTxt3.isEnabled    = false
//            documentTypeBtn3.isEnabled  = false
//            address1Txt3.isEnabled      = false
//            address2Txt3.isEnabled      = false
//            address3Txt3.isEnabled      = false
//            pinTxt3.isEnabled           = false
//
//        default: break
//        }
//    }
//
//    func validatePinCode(pinCode: String, for type: String, index: Int = 1) {
//        let parameters: [String: Any] = ["PinCode": pinCode]
//
//        let url = "CityState/GetCitySateOnPincode"
//
//        apiCall(url: url, method: "POST", parameters: parameters, view: self.view) { result in
//            switch result {
//            case .success(let jsonResponse):
//                if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
//                    DispatchQueue.main.async {
//                        if let countryList = jsonResponse["CountryList"] as? [[String: Any]],
//                           let firstItem = countryList.first {
//                            let city = firstItem["City"] as? String ?? ""
//                            let state = firstItem["State"] as? String ?? ""
//
//                            if type == "nominee" {
//                                switch index {
//                                case 1:
//                                    self.cityTxt1.text = city
//                                    self.stateTxt1.text = state
//                                    self.cityTxt1.isUserInteractionEnabled = false
//                                    self.stateTxt1.isUserInteractionEnabled = false
//                                case 2:
//                                    self.cityTxt2.text = city
//                                    self.stateTxt2.text = state
//                                    self.cityTxt2.isUserInteractionEnabled = false
//                                    self.stateTxt2.isUserInteractionEnabled = false
//                                case 3:
//                                    self.cityTxt3.text = city
//                                    self.stateTxt3.text = state
//                                    self.cityTxt3.isUserInteractionEnabled = false
//                                    self.stateTxt3.isUserInteractionEnabled = false
//                                default:
//                                    break
//                                }
//                            }
//                        }
//                    }
//                }
//            case .failure(let error):
//                print("API call failed: \(error.localizedDescription)")
//            }
//        }
//    }
//
//
//    @IBAction func backBtnTapped(_ sender: UIButton) {
//        // delegate?.reloadPageData()
//        let vc = ApplicationFormVC()
//        vc.panNo = panNo
//        vc.regId = regId
//        vc.PANName = PANName
//        vc.EmailId = EmailId
//
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    @IBAction func addNomineeBtnTapped(_ sender: UIButton) {
//        print("Add Nominee Clicked")
//        guard nomineeCount < 3 else { return }
//
//        nomineeCount += 1
//
//        switch nomineeCount {
//
//        case 1:
//            nomineeView1.isHidden = false
//            nomineeView2.isHidden = true
//            nomineeView3.isHidden = true
//
//        case 2:
//            nomineeView1.isHidden = false
//            nomineeView2.isHidden = false
//            nomineeView3.isHidden = true
//
//        case 3:
//            nomineeView1.isHidden = false
//            nomineeView2.isHidden = false
//            nomineeView3.isHidden = false
//
//            addNomineebtn.isHidden = true // optional (hide after 3)
//
//        default:
//            break
//        }
//    }
//
//    @IBAction func NomineeConfirmationBtn(_ sender: UIButton) {
//
//        if sender == optInBtn {
//            optInBtn.isSelected = true
//            optOutBtn.isSelected = false
//
//            NomineeType = "Y"
//            mainStack.isHidden = false
//            addNomineebtn.isHidden = false
//            addNomineebtn.isEnabled = true
//
//        } else {
//            optInBtn.isSelected = false
//            optOutBtn.isSelected = true
//
//            NomineeType = "N"
//            mainStack.isHidden = true
//
//            nomineeCount = 0
//            nomineeView1.isHidden = true
//            nomineeView2.isHidden = true
//            nomineeView3.isHidden = true
//        }
//    }
//
//    @IBAction func nominee1BtnTapped(_ sender: UIButton) {
//        print("tapped")
//        isNominee1Expanded.toggle()
//
//        stackView1.isHidden = !isNominee1Expanded
//        viewLine1.isHidden = !isNominee1Expanded
//
//        if isNominee1Expanded {
//            nomineeBtn1.setImage(UIImage(named: "upArrow"), for: .normal)
//        } else {
//            nomineeBtn1.setImage(UIImage(named: "downArrow"), for: .normal)
//        }
//    }
//
//    @IBAction func nominee2BtnTapped(_ sender: UIButton) {
//        print("tapped")
//        isNominee2Expanded.toggle()
//
//        stackView2.isHidden = !isNominee2Expanded
//        viewLine2.isHidden = !isNominee2Expanded
//
//        if isNominee1Expanded {
//            nomineeBtn2.setImage(UIImage(named: "upArrow"), for: .normal)
//        } else {
//            nomineeBtn2.setImage(UIImage(named: "downArrow"), for: .normal)
//        }
//    }
//
//    @IBAction func nominee3BtnTapped(_ sender: UIButton) {
//        print("tapped")
//        isNominee3Expanded.toggle()
//
//        stackView3.isHidden = !isNominee3Expanded
//        viewLine3.isHidden = !isNominee3Expanded
//
//        if isNominee1Expanded {
//            nomineeBtn3.setImage(UIImage(named: "upArrow"), for: .normal)
//        } else {
//            nomineeBtn3.setImage(UIImage(named: "downArrow"), for: .normal)
//        }
//    }
//
//    @IBAction func documentType1(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "NomineeDocument1"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func dobBtnTapped(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeDOB1"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func documentType2(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "NomineeDocument2"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func dobBtnTapped2(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeDOB2"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func documentType3(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "NomineeDocument3"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func dobBtnTapped3(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeDOB3"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func nomineeVerifyBtn1(_ sender: UIButton) {
//        verifyNominee(index: 1)
//    }
//
//    @IBAction func nomineeVerifyBtn2(_ sender: UIButton) {
//        verifyNominee(index: 2)
//    }
//
//    @IBAction func nomineeVerifyBtn3(_ sender: UIButton) {
//        verifyNominee(index: 3)
//    }
//
//
//    @IBAction func guardianDocumentTypeBtn1(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "guardianDocument1"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func guardianDocumentTypeBtn2(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "guardianDocument2"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func guardianDocumentTypeBtn3(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "guardianDocument3"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
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
//    @IBAction func guardianVerifyBtn1(_ sender: UIButton) {
//        verifyGuardian(index: 1)
//    }
//
//    @IBAction func guardianVerifyBtn2(_ sender: UIButton) {
//        verifyGuardian(index: 2)
//    }
//
//    @IBAction func guardianVerifyBtn3(_ sender: UIButton) {
//        verifyGuardian(index: 3)
//    }
//
//    @IBAction func guardianDobBtn1(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeDOB1"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func guardianDobBtn2(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeDOB2"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func guardianDobBtn3(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeDOB3"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
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
//                "PanNo": panNo,
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
//                                        self.navigationToVeriticsVC()
//                                        //                                        self.navigateToVeriticsVC(DigiLockerURL: DigiLockerURL ?? "", TransactionID: TransactionID ?? "",identifier1 : identifier1)
//                                    } else if digiType == "DIRECT"{
//                                        let url = "\(DigiLockerURL ?? "")?redirect_uri=\(digilockerReturnURL ?? "")&response_type=code&response_type=code&client_id=\(Client_id ?? "")&state=\(TransactionID ?? "")"
//                                        //                                        self.navigateToVeriticsVC(DigiLockerURL: url, TransactionID: TransactionID ?? "", identifier1: identifier1 )
//                                        self.navigationToVeriticsVC()
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
//
//        }
//    }
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
//                                if !isGuardian {
//
//                                    // Detect nominee index
//                                    if let index = Int(self.identifier.replacingOccurrences(of: "Nominee", with: "")) {
//
//                                        // Disable fields after PAN verification
//                                        self.disableNomineeFieldsAfterDigiLocker(index: index)
//
//                                        // Age check for guardian
//                                        if let age = self.calculateAge(from: userDOB) {
//                                            self.toggleGuardianFields(for: index, show: age < 18)
//                                        }
//                                    }
//                                }
//
//                                let storyboard = UIStoryboard(name: "DashboardVC", bundle: Bundle.module)
//
//                                guard let viewController = storyboard.instantiateViewController(withIdentifier: "PanVerifyPopupVC") as? PanVerifyPopupVC else {
//                                    print("ViewController not found")
//                                    return
//                                }
//
//                                viewController.panName = jsonResponse["PANName"] as? String
//                                viewController.dob = jsonResponse["DOB"] as? String
//                                viewController.requestId = jsonResponse["RequestId"] as? String
//                                viewController.panNo = jsonResponse["PanNo"] as? String
//                                viewController.identifier = "nomineePanVerify"
//                                viewController.modalPresentationStyle = .overCurrentContext
//                                viewController.modalTransitionStyle = .crossDissolve
//
//                                self.present(viewController, animated: true)
//                                //                            DispatchQueue.main.async {
//                                //                                if !isGuardian {
//                                //                                        if let age = self.calculateAge(from: userDOB) {
//                                //                                            if let index = Int(self.identifier.replacingOccurrences(of: "Nominee", with: "")) {
//                                //                                                self.toggleGuardianFields(for: index, show: age < 18)
//                                //                                            }
//                                //                                        }
//                                //                                    }
//                                //
//                                //                                let storyboard = UIStoryboard(name: "DashboardVC", bundle: Bundle.module)
//                                //
//                                //                                // Instantiate the view controller by its identifier
//                                //                                guard let viewController = storyboard.instantiateViewController(withIdentifier: "PanVerifyPopupVC") as? PanVerifyPopupVC else {
//                                //                                    print("ViewController not found")
//                                //                                    return
//                                //                                }
//                                //                                viewController.panName = jsonResponse["PANName"] as? String
//                                //                                viewController.dob = jsonResponse["DOB"] as? String
//                                //                                viewController.requestId = jsonResponse["RequestId"] as? String
//                                //                                viewController.panNo = jsonResponse["PanNo"] as? String
//                                //                                viewController.identifier = "nomineePanVerify"
//                                //                                viewController.modalPresentationStyle = .overCurrentContext
//                                //
//                                //                                viewController.modalTransitionStyle = .crossDissolve
//                                //                                print("present")
//                                //                                self.present(viewController, animated: true, completion: nil)
//                            }
//
//                        case "100001":
//                            DispatchQueue.main.async {
//                                self.showAlert( message: ErrorMessage ?? "")
//                            }
//                        case "300009":
//                            DispatchQueue.main.async {
//                                self.showAlert( message: ErrorMessage ?? "")
//                            }
//                        case "Pan-001":
//                            DispatchQueue.main.async {
//                                self.showAlert(message: ErrorMessage ?? "")
//                            }
//                        case "PANDOB-001":
//                            DispatchQueue.main.async {
//                                self.showAlert(message: ErrorMessage ?? "")
//                            }
//                        case "300001":
//                            DispatchQueue.main.async {
//                                self.showAlert(message: ErrorMessage ?? "")
//                            }
//                        case "300006":
//                            DispatchQueue.main.async {
//                                self.showAlert(message: ErrorMessage ?? "")
//                            }
//                        case "111111":
//                            DispatchQueue.main.async {
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
//                                //                                self.NoBtn.isSelected = true
//                                //                                self.saveNNextBtn.isHidden = false
//
//                            } else if let nomineeData = jsonResponse["NomineeDetails"] as? [[String: Any]], !nomineeData.isEmpty {
//
//                                //                                self.nomineeDetailsArray = nomineeData
//                                //                                self.updateNomineeViewsall() // Make sure this function updates the UI based on `nomineeDetailsArray`
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
//    func showAlert(message: String) {
//        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
//    }
//
//    //    func navigateToVeriticsVC(DigiLockerURL: String, TransactionID: String,identifier1 : String) {
//    //        func navigateToVeriticsVC(DigiLockerURL: String,
//    //                                  TransactionID: String,
//    //                                  identifier1: String) {
//    //
//    //            let vc = VerticsVC()
//    //
//    //                vc.DigiLockerURL = DigiLockerURL
//    //                vc.TransactionID = TransactionID
//    //                vc.identifier1 = identifier1
//    //                vc.RegId = RegId
//    //                vc.panNo = panNo
//    //                vc.flag = "1"
//    //                vc.identifier3 = "NomineeVC"
//    //                vc.delegate = self
//    //
//    //                navigationController?.pushViewController(vc, animated: true)
//    //        }
//    //    }
//
//    func navigationToVeriticsVC() {
//        let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
//        let vc = storyboard.instantiateViewController(identifier: "DigiLocker_a") as! DigiLocker_a
//        vc.panNo = panNo
//        vc.RegId = RegId
//        vc.digilockerDone = "Done"
//        vc.identifier3 = "NomineeVC"
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func toggleGuardianFields(for nomineeIndex: Int, show: Bool) {
//        switch nomineeIndex {
//        case 1:
//            gurdianLabel1.isHidden = !show
//            guardian1DocumentType.isHidden = !show
//            guardian1DocumentBtn.isHidden = !show
//            guardianName1.isHidden = !show
//            guardianNameTxt1.isHidden = !show
//            guardianDobLabel1.isHidden = !show
//            guardianDobBtn1.isHidden = !show
//            guardianDobTxt1.isHidden = !show
//            guardianIDLabel1.isHidden = !show
//            guardianIdTxt.isHidden = !show
//            guardianVerify.isHidden = !show
//            guardianMobileLabel1.isHidden = !show
//            guardianMobileTxt1.isHidden = !show
//            guardianEmailLabel1.isHidden = !show
//            guardianEmailIdTxt1.isHidden = !show
//            guardianAddressSameBtn1.isHidden = !show
//            GuardianAddressLbl1.isHidden = !show
//            guardianAddressTxt1.isHidden = !show
//            GuardianAddress1Lbl1.isHidden = !show
//            guardianAddress1Txt1.isHidden = !show
//            GuardianAddress2Lbl1.isHidden = !show
//            GuardianAddress2Txt1.isHidden = !show
//            guardianPin1Lbl1.isHidden = !show
//            guardianPin1Txt1.isHidden = !show
//            guardianCity1Lbl1.isHidden = !show
//            guardianCity1Txt1.isHidden = !show
//            guardianState1Lbl1.isHidden = !show
//            guardianState1Txt1.isHidden = !show
//
//        case 2:
//            gurdianLabel2.isHidden = !show
//            guardian2DocumentType.isHidden = !show
//            guardian2DocumentBtn.isHidden = !show
//            guardianName2.isHidden = !show
//            guardianNameTxt2.isHidden = !show
//            guardianDobLabel2.isHidden = !show
//            guardianDobBtn2.isHidden = !show
//            guardianDobTxt2.isHidden = !show
//            guardianIDLabel2.isHidden = !show
//            guardianIdTxt2.isHidden = !show
//            guardianVerify2.isHidden = !show
//            guardianMobileLabel2.isHidden = !show
//            guardianMobileTxt2.isHidden = !show
//            guardianEmailLabel2.isHidden = !show
//            guardianEmailIdTxt2.isHidden = !show
//            guardianAddressSameBtn2.isHidden = !show
//            GuardianAddressLbl2.isHidden = !show
//            guardianAddressTxt2.isHidden = !show
//            GuardianAddress1Lbl2.isHidden = !show
//            guardianAddress1Txt2.isHidden = !show
//            GuardianAddress2Lbl2.isHidden = !show
//            GuardianAddress2Txt2.isHidden = !show
//            guardianPin1Lbl2.isHidden = !show
//            guardianPin1Txt2.isHidden = !show
//            guardianCity1Lbl2.isHidden = !show
//            guardianCity1Txt2.isHidden = !show
//            guardianState1Lbl2.isHidden = !show
//            guardianState1Txt2.isHidden = !show
//
//        case 3:
//            gurdianLabel3.isHidden = !show
//            guardian3DocumentType.isHidden = !show
//            guardian3DocumentBtn.isHidden = !show
//            guardianName3.isHidden = !show
//            guardianNameTxt3.isHidden = !show
//            guardianDobLabel3.isHidden = !show
//            guardianDobBtn3.isHidden = !show
//            guardianDobTxt3.isHidden = !show
//            guardianIDLabel3.isHidden = !show
//            guardianIdTxt3.isHidden = !show
//            guardianVerify3.isHidden = !show
//            guardianMobileLabel3.isHidden = !show
//            guardianMobileTxt3.isHidden = !show
//            guardianEmailLabel3.isHidden = !show
//            guardianEmailIdTxt3.isHidden = !show
//            guardianAddressSameBtn3.isHidden = !show
//            GuardianAddressLbl3.isHidden = !show
//            guardianAddressTxt3.isHidden = !show
//            GuardianAddress1Lbl3.isHidden = !show
//            guardianAddress1Txt3.isHidden = !show
//            GuardianAddress2Lbl3.isHidden = !show
//            GuardianAddress2Txt3.isHidden = !show
//            guardianPin1Lbl3.isHidden = !show
//            guardianPin1Txt3.isHidden = !show
//            guardianCity1Lbl3.isHidden = !show
//            guardianCity1Txt3.isHidden = !show
//            guardianState1Lbl3.isHidden = !show
//            guardianState1Txt3.isHidden = !show
//
//        default:
//            break
//        }
//    }
//
//    func didSelectDate(_ date: String, identifier: String) {
//
//        switch identifier {
//
//        case "nomineeDOB1":
//            nomineeDobTxt1.text = date
//            if let age = calculateAge(from: date) {
//                toggleGuardianFields(for: 1, show: age < 18)
//            }
//
//        case "nomineeDOB2":
//            nomineeDobTxt2.text = date
//            if let age = calculateAge(from: date) {
//                toggleGuardianFields(for: 2, show: age < 18)
//            }
//
//        case "nomineeDOB3":
//            nomineeDobTxt3.text = date
//            if let age = calculateAge(from: date) {
//                toggleGuardianFields(for: 3, show: age < 18)
//                NomineeMinor = age < 18 ? "Y" : "N"
//            }
//
//        case "guardianDOB1":
//            guardianDobTxt1.text = date
//            if let age = calculateAge(from: date) {
//                // toggleGuardianHolderViews(show: age < 18)
//                NomineeMinor = "Y"
//            }
//
//        case "guardianDOB2":
//            guardianDobTxt2.text = date
//            if let age = calculateAge(from: date) {
//                // toggleGuardianHolderViews(show: age < 18)
//                NomineeMinor = "Y"
//            }
//
//        case "guardianDOB3":
//            guardianDobTxt3.text = date
//            if let age = calculateAge(from: date) {
//                // toggleGuardianHolderViews(show: age < 18)
//                NomineeMinor = "Y"
//            }
//
//        default:
//            break
//        }
//    }
//
//    func verifyNominee(index: Int) {
//
//        var panNo = ""
//        var name = ""
//        var dob = ""
//
//        switch index {
//        case 1:
//            panNo = documentIdTxt.text ?? ""
//            name = nomineeNameTxt1.text ?? ""
//            dob = nomineeDobTxt1.text ?? ""
//        case 2:
//            panNo = documentIdTxt2.text ?? ""
//            name = nomineeNameTxt2.text ?? ""
//            dob = nomineeDobTxt2.text ?? ""
//        case 3:
//            panNo = documentIdTxt3.text ?? ""
//            name = nomineeNameTxt3.text ?? ""
//            dob = nomineeDobTxt3.text ?? ""
//        default:
//            return
//        }
//
//        guard !panNo.isEmpty, !name.isEmpty, !dob.isEmpty else {
//            showAlert(message: "Please enter all nominee details.")
//            return
//        }
//
//        if let age = calculateAge(from: dob) {
//            toggleGuardianFields(for: index, show: age < 18)
//        }
//
//        self.identifier = "Nominee\(index)"
//        panValidation(panNo: panNo, name: name, userDOB: dob, isGuardian: false)
//    }
//
//    func verifyGuardian(index: Int) {
//
//        var panNo = ""
//        var name = ""
//        var dob = ""
//
//        switch index {
//        case 1:
//            panNo = guardianIdTxt.text ?? ""
//            name = guardianNameTxt1.text ?? ""
//            dob = guardianDobTxt1.text ?? ""
//        case 2:
//            panNo = guardianIdTxt2.text ?? ""
//            name = guardianNameTxt2.text ?? ""
//            dob = guardianDobTxt2.text ?? ""
//        case 3:
//            panNo = guardianIdTxt3.text ?? ""
//            name = guardianNameTxt3.text ?? ""
//            dob = guardianDobTxt3.text ?? ""
//        default:
//            return
//        }
//
//        guard !panNo.isEmpty, !name.isEmpty, !dob.isEmpty else {
//            showAlert(message: "Please enter all nominee details.")
//            return
//        }
//        self.identifier = "Nominee\(index)"
//        panValidation(panNo: panNo, name: name, userDOB: dob, isGuardian: true)
//    }
//}
//import UIKit
//
//class NomineeVC: UIViewController, @MainActor SelectionDelegate, @MainActor VerticsVCDelegate, @MainActor CalenderVCDelegate, @MainActor DigiLocker_b_VCDelegate, @MainActor ReloadPageDelegate {
//
//    func didDismissDigiLockerVC() {
//        self.dismiss(animated: true)
//    }
//
//    func reloadPageData() {
//        self.ViewAllNomineeDetails()
//    }
//
//    func didReceiveApiResponse(data: [String : Any], identifier1: String, identifier3: String) {
//        // 1. Auto-fill the correct nominee's fields
//        switch identifier1 {
//        case "NomineeDocument1":
//            fillNomineeFields(data: data, index: 1)
//        case "NomineeDocument2":
//            fillNomineeFields(data: data, index: 2)
//        case "NomineeDocument3":
//            fillNomineeFields(data: data, index: 3)
//        default:
//            print("Unknown identifier: \(identifier1)")
//        }
//
//        // 2. OPTIONAL: Show DigiLocker_b_VC (summary screen) after success
//        // If you want ONLY auto-fill + back to Nominee page, comment the whole block below
//        showDigiLockerSummaryVC(data: data)
//    }
//
//    private func showDigiLockerSummaryVC(data: [String: Any]) {
//        let name = data["NameAsPerAadhaar"] as? String
//        let dob = data["DOB"] as? String
//        let gender = data["Gender"] as? String
//        let fatherName = data["FatherSpouseName"] as? String
//
//        let address = [
//            data["Address1"] as? String,
//            data["Address2"] as? String,
//            data["Address3"] as? String,
//            data["City"] as? String,
//            data["State"] as? String,
//            data["PinCode"] as? String
//        ].compactMap { $0 }.joined(separator: ", ")
//
//        let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
//        guard let vc = storyboard.instantiateViewController(withIdentifier: "DigiLocker_b_VC") as? DigiLocker_b_VC else { return }
//
//        vc.name = name
//        vc.dob = dob
//        vc.gender = gender
//        vc.fatherName = fatherName
//        vc.address = address
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//        vc.delegate = self
//
//        // Present after a slight delay
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.present(vc, animated: true)
//        }
//    }
//
//
//    func didSelectDepository(type: String, identifier: String) {
//        print("🔵 [didSelectDepository] Called → Type: \(type) | Identifier: \(identifier)")
//
//        switch identifier {
//
//        // MARK: - Nominee Documents
//        case "NomineeDocument1":
//            print("   → Setting Nominee 1 button to \(type)")
//            documentTypeBtn1.setTitle(type, for: .normal)
//            nomineedocumentType1 = type
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "NomineeDocument1")
//            }
//
//        case "NomineeDocument2":
//            print("   → Setting Nominee 2 button to \(type)")
//            documentTypeBtn2.setTitle(type, for: .normal)
//            nomineedocumentType2 = type
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "NomineeDocument2")
//            }
//
//        case "NomineeDocument3":
//            print("   → Setting Nominee 3 button to \(type)")
//            documentTypeBtn3.setTitle(type, for: .normal)
//            nomineedocumentType3 = type
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "NomineeDocument3")
//            }
//
//        // MARK: - Guardian Documents (Fixed wrong button names)
//        case "guardianDocument1":
//            print("   → Setting Guardian 1 button to \(type)")
//            guardian1DocumentBtn.setTitle(type, for: .normal)
//            guardiandocumentType1 = type
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "guardianDocument1")
//            }
//
//        case "guardianDocument2":
//            print("   → Setting Guardian 2 button to \(type)")
//            guardian2DocumentBtn.setTitle(type, for: .normal)
//            guardiandocumentType2 = type
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "guardianDocument2")
//            }
//
//        case "guardianDocument3":
//            print("   → Setting Guardian 3 button to \(type)")
//            guardian3DocumentBtn.setTitle(type, for: .normal)
//            guardiandocumentType3 = type
//            if type == "Aadhaar" {
//                saveDigiLocker(identifier1: "guardianDocument3")
//            }
//
//        default:
//            print("→ Unknown identifier: \(identifier)")
//            break
//        }
//    }
//
//
//    @IBOutlet weak var optInBtn: UIButton!
//    @IBOutlet weak var optOutBtn: UIButton!
//    @IBOutlet weak var mainStack: UIStackView!
//    @IBOutlet weak var nomineeView1: UIStackView!
//    @IBOutlet weak var nomineeLabel1: UILabel!
//    @IBOutlet weak var nomineeBtn1: UIButton!
//    @IBOutlet weak var viewLine1: UIView!
//    @IBOutlet weak var stackView1: UIStackView!
//    @IBOutlet weak var documentType1: UILabel!
//    @IBOutlet weak var documentTypeBtn1: UIButton!
//    @IBOutlet weak var documentIdLabel: UILabel!
//    @IBOutlet weak var documentIdTxt: UITextField!
//    @IBOutlet weak var nomineeVerifyBtn1: UIButton!
//    @IBOutlet weak var nomineeName1: UILabel!
//    @IBOutlet weak var nomineeNameTxt1: UITextField!
//    @IBOutlet weak var dob1: UILabel!
//    @IBOutlet weak var nomineeDobTxt1: UITextField!
//    @IBOutlet weak var selectDateBtn1: UIButton!
//    @IBOutlet weak var nomineeMobileLabel1: UILabel!
//    @IBOutlet weak var nomineeMobileTxt1: UITextField!
//    @IBOutlet weak var nomineeEmailLabel1: UILabel!
//    @IBOutlet weak var nomineeEmailTxt1: UITextField!
//    @IBOutlet weak var addressBtn1: UIButton!
//    @IBOutlet weak var address1Label1: UILabel!
//    @IBOutlet weak var address1Txt1: UITextField!
//    @IBOutlet weak var address2Label1: UILabel!
//    @IBOutlet weak var address3Label1: UILabel!
//    @IBOutlet weak var address2Txt1: UITextField!
//    @IBOutlet weak var address3Txt1: UITextField!
//    @IBOutlet weak var pinLabel1: UILabel!
//    @IBOutlet weak var pinTxt1: UITextField!
//    @IBOutlet weak var cityLabel1: UILabel!
//    @IBOutlet weak var cityTxt1: UITextField!
//    @IBOutlet weak var stateLabel1: UILabel!
//    @IBOutlet weak var stateTxt1: UITextField!
//    @IBOutlet weak var relationLabel1: UILabel!
//    @IBOutlet weak var relationBtn1: UIButton!
//    @IBOutlet weak var shareLabel1: UILabel!
//    @IBOutlet weak var shareTxt1: UITextField!
//    @IBOutlet weak var nominee1View1: UIView!
//
//    @IBOutlet weak var gurdianLabel1: UILabel!
//    @IBOutlet weak var guardian1DocumentType: UILabel!
//    @IBOutlet weak var guardian1DocumentBtn: UIButton!
//    @IBOutlet weak var guardianName1: UILabel!
//    @IBOutlet weak var guardianNameTxt1: UITextField!
//    @IBOutlet weak var guardianDobLabel1: UILabel!
//    @IBOutlet weak var guardianDobBtn1: UIButton!
//
//    @IBOutlet weak var guardianDobTxt1: UITextField!
//
//    @IBOutlet weak var guardianIDLabel1: UILabel!
//    @IBOutlet weak var guardianIdTxt: UITextField!
//
//    @IBOutlet weak var guardianVerify: UIButton!
//    @IBOutlet weak var guardianMobileLabel1: UILabel!
//    @IBOutlet weak var guardianMobileTxt1: UITextField!
//    @IBOutlet weak var guardianEmailLabel1: UILabel!
//    @IBOutlet weak var guardianEmailIdTxt1: UITextField!
//    @IBOutlet weak var guardianAddressSameBtn1: UIButton!
//    @IBOutlet weak var GuardianAddressLbl1: UILabel!
//    @IBOutlet weak var guardianAddressTxt1: UITextField!
//    @IBOutlet weak var GuardianAddress1Lbl1: UILabel!
//    @IBOutlet weak var guardianAddress1Txt1: UITextField!
//    @IBOutlet weak var GuardianAddress2Lbl1: UILabel!
//    @IBOutlet weak var GuardianAddress2Txt1: UITextField!
//    @IBOutlet weak var guardianPin1Lbl1: UILabel!
//    @IBOutlet weak var guardianPin1Txt1: UITextField!
//    @IBOutlet weak var guardianCity1Lbl1: UILabel!
//    @IBOutlet weak var guardianCity1Txt1: UITextField!
//    @IBOutlet weak var guardianState1Lbl1: UILabel!
//    @IBOutlet weak var guardianState1Txt1: UITextField!
//
//    @IBOutlet weak var nomineeView2: UIStackView!
//    @IBOutlet weak var nominee3View3: UIView!
//    @IBOutlet weak var viewLine2: UIView!
//    @IBOutlet weak var stackView2: UIStackView!
//    @IBOutlet weak var nomineeBtn2: UIButton!
//    @IBOutlet weak var documentType2: UILabel!
//    @IBOutlet weak var documentTypeBtn2: UIButton!
//    @IBOutlet weak var documentIdLabel2: UILabel!
//    @IBOutlet weak var documentIdTxt2:
//    UITextField!
//
//    @IBOutlet weak var nomineeName2: UILabel!
//    @IBOutlet weak var nomineeNameTxt2: UITextField!
//    @IBOutlet weak var dob2: UILabel!
//    @IBOutlet weak var selectDateBtn2: UIButton!
//    @IBOutlet weak var nomineeMobileLabel2: UILabel!
//    @IBOutlet weak var nomineeMobileTxt2: UITextField!
//    @IBOutlet weak var nomineeEmailLabel2: UILabel!
//    @IBOutlet weak var nomineeEmailTxt2: UITextField!
//    @IBOutlet weak var addressBtn2: UIButton!
//    @IBOutlet weak var address1Label2: UILabel!
//    @IBOutlet weak var address1Txt2: UITextField!
//    @IBOutlet weak var address2Label2: UILabel!
//    @IBOutlet weak var address3Label2: UILabel!
//    @IBOutlet weak var address2Txt2: UITextField!
//    @IBOutlet weak var address3Txt2: UITextField!
//    @IBOutlet weak var pinLabel2: UILabel!
//    @IBOutlet weak var pinTxt2: UITextField!
//    @IBOutlet weak var cityLabel2: UILabel!
//    @IBOutlet weak var cityTxt2: UITextField!
//    @IBOutlet weak var stateLabel2: UILabel!
//    @IBOutlet weak var stateTxt2: UITextField!
//    @IBOutlet weak var relationLabel2: UILabel!
//    @IBOutlet weak var relationBtn2: UIButton!
//    @IBOutlet weak var shareLabel2: UILabel!
//    @IBOutlet weak var shareTxt2: UITextField!
//    @IBOutlet weak var gurdianLabel2: UILabel!
//    @IBOutlet weak var guardian2DocumentType: UILabel!
//    @IBOutlet weak var guardian2DocumentBtn: UIButton!
//    @IBOutlet weak var guardianName2: UILabel!
//    @IBOutlet weak var guardianNameTxt2: UITextField!
//    @IBOutlet weak var guardianDobLabel2: UILabel!
//    @IBOutlet weak var guardianDobBtn2: UIButton!
//    @IBOutlet weak var guardianDobTxt2: UITextField!
//    @IBOutlet weak var guardianIDLabel2: UILabel!
//    @IBOutlet weak var guardianIdTxt2: UITextField!
//    @IBOutlet weak var guardianVerify2: UIButton!
//    @IBOutlet weak var guardianMobileLabel2: UILabel!
//    @IBOutlet weak var guardianMobileTxt2: UITextField!
//    @IBOutlet weak var guardianEmailLabel2: UILabel!
//    @IBOutlet weak var guardianEmailIdTxt2: UITextField!
//    @IBOutlet weak var guardianAddressSameBtn2: UIButton!
//    @IBOutlet weak var GuardianAddressLbl2: UILabel!
//    @IBOutlet weak var guardianAddressTxt2: UITextField!
//    @IBOutlet weak var GuardianAddress1Lbl2: UILabel!
//    @IBOutlet weak var guardianAddress1Txt2: UITextField!
//    @IBOutlet weak var GuardianAddress2Lbl2: UILabel!
//    @IBOutlet weak var GuardianAddress2Txt2: UITextField!
//    @IBOutlet weak var guardianPin1Lbl2: UILabel!
//    @IBOutlet weak var guardianPin1Txt2: UITextField!
//    @IBOutlet weak var guardianCity1Lbl2: UILabel!
//    @IBOutlet weak var guardianCity1Txt2: UITextField!
//    @IBOutlet weak var guardianState1Lbl2: UILabel!
//    @IBOutlet weak var guardianState1Txt2: UITextField!
//    @IBOutlet weak var nomineeDobTxt2: UITextField!
//
//    @IBOutlet weak var nomineeView3: UIStackView!
//    @IBOutlet weak var nominee2View2: UIView!
//    @IBOutlet weak var viewLine3: UIView!
//    @IBOutlet weak var stackView3: UIStackView!
//    @IBOutlet weak var nomineeBtn3: UIButton!
//    @IBOutlet weak var documentType3: UILabel!
//    @IBOutlet weak var documentTypeBtn3: UIButton!
//    @IBOutlet weak var documentIdLabel3: UILabel!
//    @IBOutlet weak var documentIdTxt3: UITextField!
//    @IBOutlet weak var nomineeVerify3: UIButton!
//    @IBOutlet weak var nomineeName3: UILabel!
//    @IBOutlet weak var nomineeNameTxt3: UITextField!
//    @IBOutlet weak var dob3: UILabel!
//    @IBOutlet weak var selectDateBtn3: UIButton!
//    @IBOutlet weak var nomineeDobTxt3: UITextField!
//    @IBOutlet weak var nomineeMobileLabel3: UILabel!
//    @IBOutlet weak var nomineeMobileTxt3: UITextField!
//    @IBOutlet weak var nomineeEmailLabel3: UILabel!
//    @IBOutlet weak var nomineeEmailTxt3: UITextField!
//    @IBOutlet weak var addressBtn3: UIButton!
//    @IBOutlet weak var address1Label3: UILabel!
//    @IBOutlet weak var address1Txt3: UITextField!
//    @IBOutlet weak var address2Label3: UILabel!
//    @IBOutlet weak var address2Txt3: UITextField!
//    @IBOutlet weak var address3Label3: UILabel!
//    @IBOutlet weak var address3Txt3: UITextField!
//    @IBOutlet weak var pinLabel3: UILabel!
//    @IBOutlet weak var pinTxt3: UITextField!
//    @IBOutlet weak var cityLabel3: UILabel!
//    @IBOutlet weak var cityTxt3: UITextField!
//    @IBOutlet weak var stateLabel3: UILabel!
//    @IBOutlet weak var stateTxt3: UITextField!
//    @IBOutlet weak var relationLabel3: UILabel!
//    @IBOutlet weak var relationBtn3: UIButton!
//    @IBOutlet weak var shareLabel3: UILabel!
//    @IBOutlet weak var shareTxt3: UITextField!
//
//    @IBOutlet weak var addNomineebtn: UIButton!
//    @IBOutlet weak var instructionLabel: UILabel!
//    @IBOutlet weak var instruction1Label: UILabel!
//    @IBOutlet weak var proceedBtn: UIButton!
//    @IBOutlet weak var gurdianLabel3: UILabel!
//    @IBOutlet weak var guardian3DocumentType: UILabel!
//    @IBOutlet weak var guardian3DocumentBtn: UIButton!
//    @IBOutlet weak var guardianName3: UILabel!
//    @IBOutlet weak var guardianNameTxt3: UITextField!
//    @IBOutlet weak var guardianDobLabel3: UILabel!
//    @IBOutlet weak var guardianDobBtn3: UIButton!
//    @IBOutlet weak var guardianDobTxt3: UITextField!
//
//    @IBOutlet weak var guardianIDLabel3: UILabel!
//    @IBOutlet weak var guardianIdTxt3: UITextField!
//    @IBOutlet weak var guardianVerify3: UIButton!
//    @IBOutlet weak var guardianMobileLabel3: UILabel!
//    @IBOutlet weak var guardianMobileTxt3: UITextField!
//    @IBOutlet weak var guardianEmailLabel3: UILabel!
//    @IBOutlet weak var guardianEmailIdTxt3: UITextField!
//    @IBOutlet weak var guardianAddressSameBtn3: UIButton!
//    @IBOutlet weak var GuardianAddressLbl3: UILabel!
//    @IBOutlet weak var guardianAddressTxt3: UITextField!
//    @IBOutlet weak var GuardianAddress1Lbl3: UILabel!
//    @IBOutlet weak var guardianAddress1Txt3: UITextField!
//    @IBOutlet weak var GuardianAddress2Lbl3: UILabel!
//    @IBOutlet weak var GuardianAddress2Txt3: UITextField!
//    @IBOutlet weak var guardianPin1Lbl3: UILabel!
//    @IBOutlet weak var guardianPin1Txt3: UITextField!
//    @IBOutlet weak var guardianCity1Lbl3: UILabel!
//    @IBOutlet weak var guardianCity1Txt3: UITextField!
//    @IBOutlet weak var guardianState1Lbl3: UILabel!
//    @IBOutlet weak var guardianState1Txt3: UITextField!
//
//
//    var nomineeCount = 0
//    var NomineeType: String = "N"
//    var isNominee1Expanded = false
//    var isNominee2Expanded = false
//    var isNominee3Expanded = false
//    var nomineedocumentType1 : String?
//    var nomineedocumentType2 : String?
//    var nomineedocumentType3 : String?
//    var guardiandocumentType1 : String?
//    var guardiandocumentType2 : String?
//    var guardiandocumentType3 : String?
//    var fetchedUserId: String?
//    var fetchedSessionID: String?
//    var mobiledecodeArray: String?
//    var identifier: String = ""
//    var RegId: String?
//    var panNo: String?
//    var isNomineeVerified = false
//    var NomineeMinor : String?
//    var regId: String?
//    var PANName: String?
//    var EmailId: String?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        nomineeView1.isHidden = true
//        nomineeView2.isHidden = true
//        nomineeView3.isHidden = true
//
//        mainStack.isHidden = true
//
//        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
//            guard let self = self else { return }
//
//            if let userId = userId, let sessionID = sessionID {
//                self.fetchedUserId = userId
//                self.fetchedSessionID = sessionID
//                self.mobiledecodeArray = decodeByteArrayString
//                print("UserID: \(userId), SessionID: \(sessionID)")
//               // self.ViewAllNomineeDetails()
//            } else {
//                print("No UserID or SessionID found.")
//            }
//        }
//
//        toggleGuardianFields(for: 1, show: false)
//        toggleGuardianFields(for: 2, show: false)
//        toggleGuardianFields(for: 3, show: false)
//
//        nominee1View1.layer.cornerRadius = 10
//        nominee1View1.layer.borderWidth = 0.5
//        nominee1View1.layer.borderColor = UIColor.gray.cgColor
//
//        nominee2View2.layer.cornerRadius = 10
//        nominee2View2.layer.borderWidth = 0.5
//        nominee2View2.layer.borderColor = UIColor.gray.cgColor
//
//        nominee3View3.layer.cornerRadius = 10
//        nominee3View3.layer.borderWidth = 0.5
//        nominee3View3.layer.borderColor = UIColor.gray.cgColor
//    }
//
//    private func fillNomineeFields(data: [String: Any], index: Int) {
//        let name = data["NameAsPerAadhaar"] as? String ?? ""
//            let dob = data["DOB"] as? String ?? ""
//            let uid = data["Uid"] as? String ?? ""
//            let gender = data["Gender"] as? String ?? ""
//            let fatherName = data["FatherSpouseName"] as? String ?? ""
//
//            let address1 = data["Address1"] as? String ?? ""
//            let address2 = data["Address2"] as? String ?? ""
//            let address3 = data["Address3"] as? String ?? ""
//            let city = data["City"] as? String ?? ""
//            let state = data["State"] as? String ?? ""
//            let pincode = data["PinCode"] as? String ?? ""
//
//            // Optional fields if available
//            let mobile = data["Mobile"] as? String ?? ""
//            let email = data["Email"] as? String ?? ""
//
//            switch index {
//            case 1:
//                // Nominee fields
//                nomineeNameTxt1.text = name
//                nomineeDobTxt1.text = dob
//                documentIdTxt.text = uid
//                nomineeMobileTxt1.text = mobile
//                nomineeEmailTxt1.text = email
//
//                // Address fields
//                address1Txt1.text = address1
//                address2Txt1.text = address2
//                address3Txt1.text = address3
//                cityTxt1.text = city
//                stateTxt1.text = state
//                pinTxt1.text = pincode
//
//                // Set document type
//                documentTypeBtn1.setTitle("Aadhaar", for: .normal)
//                nomineedocumentType1 = "Aadhaar"
//
//                // Disable fields after verification
//                nomineeNameTxt1.isEnabled = false
//                nomineeDobTxt1.isEnabled = false
//                documentIdTxt.isEnabled = false
//                documentTypeBtn1.isEnabled = false
//                address1Txt1.isEnabled = false
//                address2Txt1.isEnabled = false
//                address3Txt1.isEnabled = false
//                pinTxt1.isEnabled = false
//                cityTxt1.isEnabled = false
//                stateTxt1.isEnabled = false
//
//            case 2:
//                // Nominee fields
//                nomineeNameTxt2.text = name
//                nomineeDobTxt2.text = dob
//                documentIdTxt2.text = uid
//                nomineeMobileTxt2.text = mobile
//                nomineeEmailTxt2.text = email
//
//                // Address fields
//                address1Txt2.text = address1
//                address2Txt2.text = address2
//                address3Txt2.text = address3
//                cityTxt2.text = city
//                stateTxt2.text = state
//                pinTxt2.text = pincode
//
//                // Set document type
//                documentTypeBtn2.setTitle("Aadhaar", for: .normal)
//                nomineedocumentType2 = "Aadhaar"
//
//                // Disable fields
//                nomineeNameTxt2.isEnabled = false
//                nomineeDobTxt2.isEnabled = false
//                documentIdTxt2.isEnabled = false
//                documentTypeBtn2.isEnabled = false
//                address1Txt2.isEnabled = false
//                address2Txt2.isEnabled = false
//                address3Txt2.isEnabled = false
//                pinTxt2.isEnabled = false
//                cityTxt2.isEnabled = false
//                stateTxt2.isEnabled = false
//
//            case 3:
//                // Nominee fields
//                nomineeNameTxt3.text = name
//                nomineeDobTxt3.text = dob
//                documentIdTxt3.text = uid
//                nomineeMobileTxt3.text = mobile
//                nomineeEmailTxt3.text = email
//
//                // Address fields
//                address1Txt3.text = address1
//                address2Txt3.text = address2
//                address3Txt3.text = address3
//                cityTxt3.text = city
//                stateTxt3.text = state
//                pinTxt3.text = pincode
//
//                // Set document type
//                documentTypeBtn3.setTitle("Aadhaar", for: .normal)
//                nomineedocumentType3 = "Aadhaar"
//
//                // Disable fields
//                nomineeNameTxt3.isEnabled = false
//                nomineeDobTxt3.isEnabled = false
//                documentIdTxt3.isEnabled = false
//                documentTypeBtn3.isEnabled = false
//                address1Txt3.isEnabled = false
//                address2Txt3.isEnabled = false
//                address3Txt3.isEnabled = false
//                pinTxt3.isEnabled = false
//                cityTxt3.isEnabled = false
//                stateTxt3.isEnabled = false
//
//            default:
//                return
//            }
//
//            // Age check and guardian visibility
//            if let age = calculateAge(from: dob) {
//                toggleGuardianFields(for: index, show: age < 18)
//            }
//
//            // Validate pincode to fetch city/state if needed
//            validatePinCode(pinCode: pincode, for: "nominee", index: index)
//
//            print("✅ Successfully auto-filled Nominee \(index)")
//        }
//
//    private func fillGuardianFields(data: [String: Any], index: Int) {
//        print("🔧 Filling Guardian \(index) with DigiLocker data")
//
//        let name = data["NameAsPerAadhaar"] as? String ?? ""
//        let dob = data["DOB"] as? String ?? ""
//        let uid = data["Uid"] as? String ?? ""
//
//        let address1 = data["Address1"] as? String ?? ""
//        let address2 = data["Address2"] as? String ?? ""
//        let address3 = data["Address3"] as? String ?? ""
//        let city = data["City"] as? String ?? ""
//        let state = data["State"] as? String ?? ""
//        let pincode = data["PinCode"] as? String ?? ""
//
//        switch index {
//        case 1:
//            guardianNameTxt1.text = name
//            guardianDobTxt1.text = dob
//            guardianIdTxt.text = uid
//
//            guardianAddressTxt1.text = address1
//            guardianAddress1Txt1.text = address2
//            GuardianAddress2Txt1.text = address3
//            guardianCity1Txt1.text = city
//            guardianState1Txt1.text = state
//            guardianPin1Txt1.text = pincode
//
//            guardian1DocumentBtn.setTitle("Aadhaar", for: .normal)
//            guardiandocumentType1 = "Aadhaar"
//
//        case 2:
//            guardianNameTxt2.text = name
//            guardianDobTxt2.text = dob
//            guardianIdTxt2.text = uid
//
//            guardianAddressTxt2.text = address1
//            guardianAddress1Txt2.text = address2
//            GuardianAddress2Txt2.text = address3
//            guardianCity1Txt2.text = city
//            guardianState1Txt2.text = state
//            guardianPin1Txt2.text = pincode
//
//            guardian2DocumentBtn.setTitle("Aadhaar", for: .normal)
//            guardiandocumentType2 = "Aadhaar"
//
//        case 3:
//            guardianNameTxt3.text = name
//            guardianDobTxt3.text = dob
//            guardianIdTxt3.text = uid
//
//            guardianAddressTxt3.text = address1
//            guardianAddress1Txt3.text = address2
//            GuardianAddress2Txt3.text = address3
//            guardianCity1Txt3.text = city
//            guardianState1Txt3.text = state
//            guardianPin1Txt3.text = pincode
//
//            guardian3DocumentBtn.setTitle("Aadhaar", for: .normal)
//            guardiandocumentType3 = "Aadhaar"
//
//        default:
//            return
//        }
//
//        print("✅ Successfully auto-filled Guardian \(index)")
//    }
////        guard index >= 1 && index <= 3 else { return }
////
////        let name     = data["NameAsPerAadhaar"]   as? String ?? ""
////        let dob      = data["DOB"]                as? String ?? ""
////        let uid      = data["Uid"]                as? String ?? ""
////        let gender   = data["Gender"]             as? String ?? ""
////
////        let address1 = data["Address1"]           as? String ?? ""
////        let address2 = data["Address2"]           as? String ?? ""
////        let address3 = data["Address3"]           as? String ?? ""
////        let pin      = data["PinCode"]            as? String ?? ""
////        let city     = data["City"]               as? String ?? ""
////        let state    = data["State"]              as? String ?? ""
////
////        // Optional – if you receive them
////        let mobile   = data["Mobile"]             as? String ?? ""
////        let email    = data["Email"]              as? String ?? ""
////
////        switch index {
////        case 1:
////            nomineeNameTxt1.text    = name
////            nomineeDobTxt1.text     = dob
////            documentIdTxt.text      = uid           // Aadhaar number
////            nomineeMobileTxt1.text  = mobile
////            nomineeEmailTxt1.text   = email
////
////            address1Txt1.text       = address1
////            address2Txt1.text       = address2
////            address3Txt1.text       = address3
////            pinTxt1.text            = pin
////            cityTxt1.text           = city
////            stateTxt1.text          = state
////
////            documentTypeBtn1.setTitle("Aadhaar", for: .normal)
////            nomineedocumentType1    = "Aadhaar"
////
////        case 2:
////            nomineeNameTxt2.text    = name
////            nomineeDobTxt2.text     = dob
////            documentIdTxt2.text     = uid
////            nomineeMobileTxt2.text  = mobile
////            nomineeEmailTxt2.text   = email
////
////            address1Txt2.text       = address1
////            address2Txt2.text       = address2
////            address3Txt2.text       = address3
////            pinTxt2.text            = pin
////            cityTxt2.text           = city
////            stateTxt2.text          = state
////
////            documentTypeBtn2.setTitle("Aadhaar", for: .normal)
////            nomineedocumentType2    = "Aadhaar"
////
////        case 3:
////            nomineeNameTxt3.text    = name
////            nomineeDobTxt3.text     = dob
////            documentIdTxt3.text     = uid
////            nomineeMobileTxt3.text  = mobile
////            nomineeEmailTxt3.text   = email
////
////            address1Txt3.text       = address1
////            address2Txt3.text       = address2
////            address3Txt3.text       = address3
////            pinTxt3.text            = pin
////            cityTxt3.text           = city
////            stateTxt3.text          = state
////
////            documentTypeBtn3.setTitle("Aadhaar", for: .normal)
////            nomineedocumentType3    = "Aadhaar"
////
////        default: return
////        }
////
////        // Disable edited fields (same UX as NomineeDocumentVC)
////        disableNomineeFieldsAfterDigiLocker(index: index)
////
////        // Age check & guardian visibility
////        if let age = calculateAge(from: dob) {
////            toggleGuardianFields(for: index, show: age < 18)
////            // You can also store NomineeMinor here if needed
////        }
////
////        // Re-validate pincode (updates city/state if API returns better data)
////        validatePinCode(pinCode: pin, for: "nominee")
////
////        isNomineeVerified = true
////
////        print("✅ Filled Nominee \(index) from DigiLocker (Aadhaar)")
////    }
//
//    private func disableNomineeFieldsAfterDigiLocker(index: Int) {
//        switch index {
//        case 1:
//            nomineeNameTxt1.isEnabled   = false
//            nomineeDobTxt1.isEnabled    = false
//            documentIdTxt.isEnabled     = false
//            documentTypeBtn1.isEnabled  = false
//            address1Txt1.isEnabled      = false
//            address2Txt1.isEnabled      = false
//            address3Txt1.isEnabled      = false
//            pinTxt1.isEnabled           = false
//            // Optionally disable mobile/email too if you consider them final
//            // nomineeMobileTxt1.isEnabled = false
//            // nomineeEmailTxt1.isEnabled  = false
//
//        case 2:
//            nomineeNameTxt2.isEnabled   = false
//            nomineeDobTxt2.isEnabled    = false
//            documentIdTxt2.isEnabled    = false
//            documentTypeBtn2.isEnabled  = false
//            address1Txt2.isEnabled      = false
//            address2Txt2.isEnabled      = false
//            address3Txt2.isEnabled      = false
//            pinTxt2.isEnabled           = false
//
//        case 3:
//            nomineeNameTxt3.isEnabled   = false
//            nomineeDobTxt3.isEnabled    = false
//            documentIdTxt3.isEnabled    = false
//            documentTypeBtn3.isEnabled  = false
//            address1Txt3.isEnabled      = false
//            address2Txt3.isEnabled      = false
//            address3Txt3.isEnabled      = false
//            pinTxt3.isEnabled           = false
//
//        default: break
//        }
//    }
//
////    private func fillNomineeFields(data: [String: Any], index: Int) {
////        let address1   = data["Address1"]   as? String ?? ""
////        let address2   = data["Address2"]   as? String ?? ""
////        let address3   = data["Address3"]   as? String ?? ""
////        let pincode    = data["PinCode"]    as? String ?? ""
////        let city       = data["City"]       as? String ?? ""
////        let state      = data["State"]      as? String ?? ""
////        let uid        = data["Uid"]        as? String ?? ""
////        let name       = data["NameAsPerAadhaar"] as? String ?? ""
////        let dob        = data["DOB"]        as? String ?? ""
////
////        switch index {
////        case 1:
////            address1Txt1.text = address1
////            address2Txt1.text = address2
////            address3Txt1.text = address3
////            pinTxt1.text      = pincode
////            cityTxt1.text     = city
////            stateTxt1.text    = state
////            documentIdTxt.text = uid          // ← shared field? see note below
////            nomineeNameTxt1.text = name
////            nomineeDobTxt1.text = dob
////
////        case 2:
////            address1Txt2.text = address1
////            address2Txt2.text = address2
////            address3Txt2.text = address3
////            pinTxt2.text      = pincode
////            cityTxt2.text     = city
////            stateTxt2.text    = state
////            documentIdTxt2.text = uid
////            nomineeNameTxt2.text = name
////            nomineeDobTxt2.text = dob
////
////        case 3:
////            address1Txt3.text = address1
////            address2Txt3.text = address3
////            address3Txt3.text = address3
////            pinTxt3.text      = pincode
////            cityTxt3.text     = city
////            stateTxt3.text    = state
////            documentIdTxt3.text = uid
////            nomineeNameTxt3.text = name
////            nomineeDobTxt3.text = dob
////
////        default: break
////        }
////
////        // Common logic
////        if let age = calculateAge(from: dob) {
////            toggleGuardianFields(for: index, show: age < 18)
////        }
////
////        validatePinCode(pinCode: pincode, for: "nominee")
////        isNomineeVerified = true
////
////        print("✅ Auto-filled Nominee \(index) from DigiLocker")
////    }
//
////    func validatePinCode(pinCode: String, for type: String) {
////        let parameters: [String: Any?] = [
////            "PinCode": pinCode
////        ]
////
////        print(parameters)
////
////        let url = "CityState/GetCitySateOnPincode"
////
////        apiCall(url: url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
////            switch result {
////            case .success(let jsonResponse):
////                print("DPSchemeName Response: \(jsonResponse)")
////                if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
////                    DispatchQueue.main.async {
////                        if let countryList = jsonResponse["CountryList"] as? [[String: Any]], let firstItem = countryList.first {
////                            let city = firstItem["City"] as? String
////                            let state = firstItem["State"] as? String
////                           // let Country = firstItem["Country"] as? String
////                            if type == "nominee" {
////                                self.cityTxt1.text = city
////                                self.stateTxt1.text = state
////                                self.cityTxt1.isUserInteractionEnabled = false
////                                self.stateTxt1.isUserInteractionEnabled = false
////                            }
////                        }
////                    }
////                } else {
////                    DispatchQueue.main.async {
////                        if let errorMessage = jsonResponse["ErrorMessage"] as? String {
////                            self.showAlert(message: errorMessage)
////                        } else {
////                            self.showAlert(message: "Unhandled error code")
////                        }
////                    }
////                }
////            case .failure(let error):
////                DispatchQueue.main.async {
////                    self.showAlert(message: "API call failed: \(error.localizedDescription)")
////                }
////            }
////        }
////    }
//
//    func validatePinCode(pinCode: String, for type: String, index: Int = 1) {
//        let parameters: [String: Any] = ["PinCode": pinCode]
//
//        let url = "CityState/GetCitySateOnPincode"
//
//        apiCall(url: url, method: "POST", parameters: parameters, view: self.view) { result in
//            switch result {
//            case .success(let jsonResponse):
//                if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
//                    DispatchQueue.main.async {
//                        if let countryList = jsonResponse["CountryList"] as? [[String: Any]],
//                           let firstItem = countryList.first {
//                            let city = firstItem["City"] as? String ?? ""
//                            let state = firstItem["State"] as? String ?? ""
//
//                            if type == "nominee" {
//                                switch index {
//                                case 1:
//                                    self.cityTxt1.text = city
//                                    self.stateTxt1.text = state
//                                    self.cityTxt1.isUserInteractionEnabled = false
//                                    self.stateTxt1.isUserInteractionEnabled = false
//                                case 2:
//                                    self.cityTxt2.text = city
//                                    self.stateTxt2.text = state
//                                    self.cityTxt2.isUserInteractionEnabled = false
//                                    self.stateTxt2.isUserInteractionEnabled = false
//                                case 3:
//                                    self.cityTxt3.text = city
//                                    self.stateTxt3.text = state
//                                    self.cityTxt3.isUserInteractionEnabled = false
//                                    self.stateTxt3.isUserInteractionEnabled = false
//                                default:
//                                    break
//                                }
//                            }
//                        }
//                    }
//                }
//            case .failure(let error):
//                print("API call failed: \(error.localizedDescription)")
//            }
//        }
//    }
//
//
//    @IBAction func backBtnTapped(_ sender: UIButton) {
//       // delegate?.reloadPageData()
//          let vc = ApplicationFormVC()
//          vc.panNo = panNo
//          vc.regId = regId
//          vc.PANName = PANName
//          vc.EmailId = EmailId
//
//          navigationController?.pushViewController(vc, animated: true)
//    }
//
//    @IBAction func addNomineeBtnTapped(_ sender: UIButton) {
//        print("Add Nominee Clicked")
//        guard nomineeCount < 3 else { return }
//
//           nomineeCount += 1
//
//           switch nomineeCount {
//
//           case 1:
//               nomineeView1.isHidden = false
//               nomineeView2.isHidden = true
//               nomineeView3.isHidden = true
//
//           case 2:
//               nomineeView1.isHidden = false
//               nomineeView2.isHidden = false
//               nomineeView3.isHidden = true
//
//           case 3:
//               nomineeView1.isHidden = false
//               nomineeView2.isHidden = false
//               nomineeView3.isHidden = false
//
//               addNomineebtn.isHidden = true // optional (hide after 3)
//
//           default:
//               break
//           }
//    }
//
//    @IBAction func NomineeConfirmationBtn(_ sender: UIButton) {
//
//          if sender == optInBtn {
//              optInBtn.isSelected = true
//              optOutBtn.isSelected = false
//
//              NomineeType = "Y"
//              mainStack.isHidden = false
//              addNomineebtn.isHidden = false
//              addNomineebtn.isEnabled = true
//
//          } else {
//              optInBtn.isSelected = false
//              optOutBtn.isSelected = true
//
//              NomineeType = "N"
//              mainStack.isHidden = true
//
//              nomineeCount = 0
//              nomineeView1.isHidden = true
//              nomineeView2.isHidden = true
//              nomineeView3.isHidden = true
//          }
//    }
//
//    @IBAction func nominee1BtnTapped(_ sender: UIButton) {
//        print("tapped")
//        isNominee1Expanded.toggle()
//
//         stackView1.isHidden = !isNominee1Expanded
//        viewLine1.isHidden = !isNominee1Expanded
//
//         if isNominee1Expanded {
//             nomineeBtn1.setImage(UIImage(named: "upArrow"), for: .normal)
//         } else {
//             nomineeBtn1.setImage(UIImage(named: "downArrow"), for: .normal)
//         }
//    }
//
//    @IBAction func nominee2BtnTapped(_ sender: UIButton) {
//        print("tapped")
//        isNominee2Expanded.toggle()
//
//         stackView2.isHidden = !isNominee2Expanded
//        viewLine2.isHidden = !isNominee2Expanded
//
//         if isNominee1Expanded {
//             nomineeBtn2.setImage(UIImage(named: "upArrow"), for: .normal)
//         } else {
//             nomineeBtn2.setImage(UIImage(named: "downArrow"), for: .normal)
//         }
//    }
//
//    @IBAction func nominee3BtnTapped(_ sender: UIButton) {
//        print("tapped")
//        isNominee3Expanded.toggle()
//
//         stackView3.isHidden = !isNominee3Expanded
//        viewLine3.isHidden = !isNominee3Expanded
//
//         if isNominee1Expanded {
//             nomineeBtn3.setImage(UIImage(named: "upArrow"), for: .normal)
//         } else {
//             nomineeBtn3.setImage(UIImage(named: "downArrow"), for: .normal)
//         }
//    }
//
//    @IBAction func documentType1(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "NomineeDocument1"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func dobBtnTapped(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeDOB1"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func documentType2(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeDocument2"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func dobBtnTapped2(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeDOB2"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func documentType3(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeDocument3"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func dobBtnTapped3(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeDOB3"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func nomineeVerifyBtn1(_ sender: UIButton) {
//        verifyNominee(index: 1)
//    }
//
//    @IBAction func nomineeVerifyBtn2(_ sender: UIButton) {
//        verifyNominee(index: 2)
//    }
//
//    @IBAction func nomineeVerifyBtn3(_ sender: UIButton) {
//        verifyNominee(index: 3)
//    }
//
//
//    @IBAction func guardianDocumentTypeBtn1(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "guardianDocument1"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func guardianDocumentTypeBtn2(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "guardianDocument2"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func guardianDocumentTypeBtn3(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "documentTypeVC") as! documentTypeVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "guardianDocument3"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
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
//    @IBAction func guardianVerifyBtn1(_ sender: UIButton) {
//        verifyGuardian(index: 1)
//    }
//
//    @IBAction func guardianVerifyBtn2(_ sender: UIButton) {
//        verifyGuardian(index: 2)
//    }
//
//    @IBAction func guardianVerifyBtn3(_ sender: UIButton) {
//        verifyGuardian(index: 3)
//    }
//
//    @IBAction func guardianDobBtn1(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeDOB1"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func guardianDobBtn2(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeDOB2"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
//    }
//
//    @IBAction func guardianDobBtn3(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "calenderVC") as! calenderVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.identifier = "nomineeDOB3"
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true)
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
//                "PanNo": panNo,
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
//                                        self.navigationToVeriticsVC()
////                                        self.navigateToVeriticsVC(DigiLockerURL: DigiLockerURL ?? "", TransactionID: TransactionID ?? "",identifier1 : identifier1)
//                                    } else if digiType == "DIRECT"{
//                                        let url = "\(DigiLockerURL ?? "")?redirect_uri=\(digilockerReturnURL ?? "")&response_type=code&response_type=code&client_id=\(Client_id ?? "")&state=\(TransactionID ?? "")"
////                                        self.navigateToVeriticsVC(DigiLockerURL: url, TransactionID: TransactionID ?? "", identifier1: identifier1 )
//                                        self.navigationToVeriticsVC()
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
//
//        }
//    }
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
//                                if !isGuardian {
//                                        if let age = self.calculateAge(from: userDOB) {
//                                            if let index = Int(self.identifier.replacingOccurrences(of: "Nominee", with: "")) {
//                                                self.toggleGuardianFields(for: index, show: age < 18)
//                                            }
//                                        }
//                                    }
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
//                                self.showAlert( message: ErrorMessage ?? "")
//                            }
//                        case "300009":
//                            DispatchQueue.main.async {
//                                self.showAlert( message: ErrorMessage ?? "")
//                            }
//                        case "Pan-001":
//                            DispatchQueue.main.async {
//                                self.showAlert(message: ErrorMessage ?? "")
//                            }
//                        case "PANDOB-001":
//                            DispatchQueue.main.async {
//                                self.showAlert(message: ErrorMessage ?? "")
//                            }
//                        case "300001":
//                            DispatchQueue.main.async {
//                                self.showAlert(message: ErrorMessage ?? "")
//                            }
//                        case "300006":
//                            DispatchQueue.main.async {
//                                self.showAlert(message: ErrorMessage ?? "")
//                            }
//                        case "111111":
//                            DispatchQueue.main.async {
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
////                                self.NoBtn.isSelected = true
////                                self.saveNNextBtn.isHidden = false
//
//                            } else if let nomineeData = jsonResponse["NomineeDetails"] as? [[String: Any]], !nomineeData.isEmpty {
//
////                                self.nomineeDetailsArray = nomineeData
////                                self.updateNomineeViewsall() // Make sure this function updates the UI based on `nomineeDetailsArray`
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
//    func showAlert(message: String) {
//        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
//    }
//
////    func navigateToVeriticsVC(DigiLockerURL: String, TransactionID: String,identifier1 : String) {
////        func navigateToVeriticsVC(DigiLockerURL: String,
////                                  TransactionID: String,
////                                  identifier1: String) {
////
////            let vc = VerticsVC()
////
////                vc.DigiLockerURL = DigiLockerURL
////                vc.TransactionID = TransactionID
////                vc.identifier1 = identifier1
////                vc.RegId = RegId
////                vc.panNo = panNo
////                vc.flag = "1"
////                vc.identifier3 = "NomineeVC"
////                vc.delegate = self
////
////                navigationController?.pushViewController(vc, animated: true)
////        }
////    }
//
//    func navigationToVeriticsVC() {
//        let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
//        let vc = storyboard.instantiateViewController(identifier: "DigiLocker_a") as! DigiLocker_a
//        vc.panNo = panNo
//        vc.RegId = RegId
//        vc.digilockerDone = "Done"
//        vc.identifier3 = "NomineeVC"
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func toggleGuardianFields(for nomineeIndex: Int, show: Bool) {
//        switch nomineeIndex {
//        case 1:
//            gurdianLabel1.isHidden = !show
//            guardian1DocumentType.isHidden = !show
//            guardian1DocumentBtn.isHidden = !show
//            guardianName1.isHidden = !show
//            guardianNameTxt1.isHidden = !show
//            guardianDobLabel1.isHidden = !show
//            guardianDobBtn1.isHidden = !show
//            guardianDobTxt1.isHidden = !show
//            guardianIDLabel1.isHidden = !show
//            guardianIdTxt.isHidden = !show
//            guardianVerify.isHidden = !show
//            guardianMobileLabel1.isHidden = !show
//            guardianMobileTxt1.isHidden = !show
//            guardianEmailLabel1.isHidden = !show
//            guardianEmailIdTxt1.isHidden = !show
//            guardianAddressSameBtn1.isHidden = !show
//            GuardianAddressLbl1.isHidden = !show
//            guardianAddressTxt1.isHidden = !show
//            GuardianAddress1Lbl1.isHidden = !show
//            guardianAddress1Txt1.isHidden = !show
//            GuardianAddress2Lbl1.isHidden = !show
//            GuardianAddress2Txt1.isHidden = !show
//            guardianPin1Lbl1.isHidden = !show
//            guardianPin1Txt1.isHidden = !show
//            guardianCity1Lbl1.isHidden = !show
//            guardianCity1Txt1.isHidden = !show
//            guardianState1Lbl1.isHidden = !show
//            guardianState1Txt1.isHidden = !show
//
//        case 2:
//            gurdianLabel2.isHidden = !show
//            guardian2DocumentType.isHidden = !show
//            guardian2DocumentBtn.isHidden = !show
//            guardianName2.isHidden = !show
//            guardianNameTxt2.isHidden = !show
//            guardianDobLabel2.isHidden = !show
//            guardianDobBtn2.isHidden = !show
//            guardianDobTxt2.isHidden = !show
//            guardianIDLabel2.isHidden = !show
//            guardianIdTxt2.isHidden = !show
//            guardianVerify2.isHidden = !show
//            guardianMobileLabel2.isHidden = !show
//            guardianMobileTxt2.isHidden = !show
//            guardianEmailLabel2.isHidden = !show
//            guardianEmailIdTxt2.isHidden = !show
//            guardianAddressSameBtn2.isHidden = !show
//            GuardianAddressLbl2.isHidden = !show
//            guardianAddressTxt2.isHidden = !show
//            GuardianAddress1Lbl2.isHidden = !show
//            guardianAddress1Txt2.isHidden = !show
//            GuardianAddress2Lbl2.isHidden = !show
//            GuardianAddress2Txt2.isHidden = !show
//            guardianPin1Lbl2.isHidden = !show
//            guardianPin1Txt2.isHidden = !show
//            guardianCity1Lbl2.isHidden = !show
//            guardianCity1Txt2.isHidden = !show
//            guardianState1Lbl2.isHidden = !show
//            guardianState1Txt2.isHidden = !show
//
//        case 3:
//            gurdianLabel3.isHidden = !show
//            guardian3DocumentType.isHidden = !show
//            guardian3DocumentBtn.isHidden = !show
//            guardianName3.isHidden = !show
//            guardianNameTxt3.isHidden = !show
//            guardianDobLabel3.isHidden = !show
//            guardianDobBtn3.isHidden = !show
//            guardianDobTxt3.isHidden = !show
//            guardianIDLabel3.isHidden = !show
//            guardianIdTxt3.isHidden = !show
//            guardianVerify3.isHidden = !show
//            guardianMobileLabel3.isHidden = !show
//            guardianMobileTxt3.isHidden = !show
//            guardianEmailLabel3.isHidden = !show
//            guardianEmailIdTxt3.isHidden = !show
//            guardianAddressSameBtn3.isHidden = !show
//            GuardianAddressLbl3.isHidden = !show
//            guardianAddressTxt3.isHidden = !show
//            GuardianAddress1Lbl3.isHidden = !show
//            guardianAddress1Txt3.isHidden = !show
//            GuardianAddress2Lbl3.isHidden = !show
//            GuardianAddress2Txt3.isHidden = !show
//            guardianPin1Lbl3.isHidden = !show
//            guardianPin1Txt3.isHidden = !show
//            guardianCity1Lbl3.isHidden = !show
//            guardianCity1Txt3.isHidden = !show
//            guardianState1Lbl3.isHidden = !show
//            guardianState1Txt3.isHidden = !show
//
//        default:
//            break
//        }
//    }
//
//    func didSelectDate(_ date: String, identifier: String) {
//
//        switch identifier {
//
//        case "nomineeDOB1":
//            nomineeDobTxt1.text = date
//            if let age = calculateAge(from: date) {
//                toggleGuardianFields(for: 1, show: age < 18)
//            }
//
//        case "nomineeDOB2":
//            nomineeDobTxt2.text = date
//            if let age = calculateAge(from: date) {
//                toggleGuardianFields(for: 2, show: age < 18)
//            }
//
//        case "nomineeDOB3":
//            nomineeDobTxt3.text = date
//            if let age = calculateAge(from: date) {
//                toggleGuardianFields(for: 3, show: age < 18)
//                NomineeMinor = age < 18 ? "Y" : "N"
//            }
//
//        case "guardianDOB1":
//            guardianDobTxt1.text = date
//            if let age = calculateAge(from: date) {
//                // toggleGuardianHolderViews(show: age < 18)
//                NomineeMinor = "Y"
//            }
//
//        case "guardianDOB2":
//            guardianDobTxt2.text = date
//            if let age = calculateAge(from: date) {
//                // toggleGuardianHolderViews(show: age < 18)
//                NomineeMinor = "Y"
//            }
//
//        case "guardianDOB3":
//            guardianDobTxt3.text = date
//            if let age = calculateAge(from: date) {
//                // toggleGuardianHolderViews(show: age < 18)
//                NomineeMinor = "Y"
//            }
//
//        default:
//            break
//        }
//    }
//
//    func verifyNominee(index: Int) {
//
//        var panNo = ""
//        var name = ""
//        var dob = ""
//
//        switch index {
//        case 1:
//            panNo = documentIdTxt.text ?? ""
//            name = nomineeNameTxt1.text ?? ""
//            dob = nomineeDobTxt1.text ?? ""
//        case 2:
//            panNo = documentIdTxt2.text ?? ""
//            name = nomineeNameTxt2.text ?? ""
//            dob = nomineeDobTxt2.text ?? ""
//        case 3:
//            panNo = documentIdTxt3.text ?? ""
//            name = nomineeNameTxt3.text ?? ""
//            dob = nomineeDobTxt3.text ?? ""
//        default:
//            return
//        }
//
//        guard !panNo.isEmpty, !name.isEmpty, !dob.isEmpty else {
//            showAlert(message: "Please enter all nominee details.")
//            return
//        }
//
//        if let age = calculateAge(from: dob) {
//            toggleGuardianFields(for: index, show: age < 18)
//        }
//
//        self.identifier = "Nominee\(index)"
//        panValidation(panNo: panNo, name: name, userDOB: dob, isGuardian: false)
//    }
//
//    func verifyGuardian(index: Int) {
//
//        var panNo = ""
//        var name = ""
//        var dob = ""
//
//        switch index {
//        case 1:
//            panNo = guardianIdTxt.text ?? ""
//            name = guardianNameTxt1.text ?? ""
//            dob = guardianDobTxt1.text ?? ""
//        case 2:
//            panNo = guardianIdTxt2.text ?? ""
//            name = guardianNameTxt2.text ?? ""
//            dob = guardianDobTxt2.text ?? ""
//        case 3:
//            panNo = guardianIdTxt3.text ?? ""
//            name = guardianNameTxt3.text ?? ""
//            dob = guardianDobTxt3.text ?? ""
//        default:
//            return
//        }
//
//        guard !panNo.isEmpty, !name.isEmpty, !dob.isEmpty else {
//            showAlert(message: "Please enter all nominee details.")
//            return
//        }
//        self.identifier = "Nominee\(index)"
//        panValidation(panNo: panNo, name: name, userDOB: dob, isGuardian: true)
//    }
//}
//
