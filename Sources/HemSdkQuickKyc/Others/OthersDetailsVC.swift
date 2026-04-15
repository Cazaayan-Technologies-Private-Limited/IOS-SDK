//
//  OthersDetailsVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

class OtherDetailsVC: UIViewController, @MainActor MaritatlSelectionDelegate ,  @MainActor EducationSelectionDelegate,@MainActor OccupationSelectedDelegate, @MainActor annualIncomeDelegate, UITextFieldDelegate, @MainActor ReloadPageDelegate, @MainActor NetworthCalendarDelegate{
    
    func reloadPageData() {
        self.ViewOtherData()
    }
    
    @IBOutlet weak var creditYes: UIButton!
    @IBOutlet weak var creditNo: UIButton!
    @IBOutlet weak var yesDdpiBtn: UIButton!
    @IBOutlet weak var noDdpiBtn: UIButton!
    @IBOutlet weak var DISYesBtn: UIButton!
    @IBOutlet weak var DISNoBtn: UIButton!
    @IBOutlet weak var PEPYesBtn: UIButton!
    @IBOutlet weak var PEPNoBtn: UIButton!
    @IBOutlet weak var instructionsYesBtn: UIButton!
    @IBOutlet weak var instructionsNoBtn: UIButton!
    @IBOutlet weak var dailyBtn: UIButton!
    @IBOutlet weak var weeklyBtn: UIButton!
    @IBOutlet weak var fortnightlyBtn: UIButton!
    @IBOutlet weak var monthlyBtn: UIButton!
    @IBOutlet weak var holdingYesBtn: UIButton!
    @IBOutlet weak var holdingNoBtn: UIButton!
    @IBOutlet weak var RTAYesBtn: UIButton!
    @IBOutlet weak var RTANoBtn: UIButton!
    @IBOutlet weak var physicalBtn: UIButton!
    @IBOutlet weak var electronicBtn: UIButton!
    @IBOutlet weak var bothP_EBtn: UIButton!
    @IBOutlet weak var ECSYesBtn: UIButton!
    @IBOutlet weak var ECSNoBtn: UIButton!
    //@IBOutlet weak var fatherNameTF: UITextField!
    @IBOutlet weak var motherNameTF: UITextField!
    @IBOutlet weak var tradingExperienceTF: UITextField!
    @IBOutlet weak var annualIncomeBtn: UIButton!
    @IBOutlet weak var OccupationBtn: UIButton!
    @IBOutlet weak var EducationBtn: UIButton!
    @IBOutlet weak var MaritalBtn: UIButton!
    @IBOutlet weak var saveNnextBtn: UIButton!
    @IBOutlet weak var networthTxt: UITextField!
    @IBOutlet weak var networthDateTxt: UITextField!
    @IBOutlet weak var networthDatebtn: UIButton!
    @IBOutlet weak var nameOfNominee: UIButton!
    @IBOutlet weak var nominationYesNo: UIButton!
    @IBOutlet weak var maritalView: UIView!
    @IBOutlet weak var educationView: UIView!
    @IBOutlet weak var occupationView: UIView!
    @IBOutlet weak var annualIncomeView: UIView!
    ///changes SDK

    @IBOutlet weak var applicantNameLbl: UILabel!
    @IBOutlet weak var marriedBtn: UIButton!
    @IBOutlet weak var singleBtn: UIButton!
    @IBOutlet weak var runningAccountBtn: UIButton!
    @IBOutlet weak var understandBtn: UIButton!
    @IBOutlet weak var politicallyYes: UIButton!
    @IBOutlet weak var politicallyNo: UIButton!
    @IBOutlet weak var runningAccountView: UIView!
    @IBOutlet weak var fatherNameTF: UITextField!
    @IBOutlet weak var networthDateLbl: UILabel!
    
    
    var RTA : String?
    var Dividend_Interest:String?
    var ElectronicTransaction_Cum_Holding : String?
    var AccountStatementRequirement:String?
    var PEPType: String?
    var All_thePledgeInstructions:String?
    var AnnualReport:String?
    var annual:String?
    var education:String?
    var maritalStatus:String?
    var occupation:String?
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var mobiledecodeArray: String?
    var panNo: String?
    var regId: String?
    var DIS: String?
    var educationDictionary: [String: String] = [:]
    var OccupationDictionary : [String: String] = [:]
    var annualDictionary : [String : String] = [:]
    var networth: String?
    var networthDate : String?
    let datePicker = UIDatePicker()
    var fatherName: String?
    var motherName: String?
    var tradingExperience: String?
    weak var delegate: ReloadPageDelegate?
    var ddpi: String?
    var credit: String?
    var nameNominee: String = ""
    var PANName: String?
    var EmailId: String?
    var IsDerivative: String = ""
    var politically: String?
    var runningAccountAuthorization: String?
  
  
    // @IBOutlet weak var SaveBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(panNo ?? "pan is not coming") and \(regId ?? "its missing")")
        // self.SaveBtn.layer.cornerRadius = 15
        saveNnextBtn.layer.cornerRadius = 25
       // fatherNameTF.delegate = self
        motherNameTF.delegate = self
        tradingExperienceTF.delegate = self
        if networthTxt.state.isEmpty {
            networthDateTxt.isHidden = true
            networthDatebtn.isHidden = true
           // networthDateLbl.isHidden = true
        } else {
            networthDateTxt.isHidden = false
            networthDatebtn.isHidden = false
          //  networthDateLbl.isHidden = false
        }
//        motherNameTF.layer.cornerRadius = 10
        tradingExperienceTF.layer.cornerRadius = 10
        //maritalView.layer.cornerRadius = 10
        occupationView.layer.cornerRadius = 10
        educationView.layer.cornerRadius = 10
        annualIncomeView.layer.cornerRadius = 10
        
        GetAnnualIncomeMaster()
        fetchUserId()
        GetEducationMaster()
        GetOccupationMaster()
        //GetRelation()
        ViewOtherData()
       
        networthTxt.addTarget(self, action: #selector(networthTextChanged), for: .editingChanged)
//        PEPNoBtn.isSelected = true
//        PEPNoBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
//        PEPYesBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        PEPType = "N"
        
        AccountStatementRequirement = "Monthly"
//        monthlyBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        
//        holdingYesBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        ElectronicTransaction_Cum_Holding = "Y"
//        electronicBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        AnnualReport = "Electronic"
        
        DIS = "N"
        DISNoBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        
        //DISNoBtn.isSelected = true
        ddpi = "Y"
//        yesDdpiBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        
      credit = "Y"
//        creditYes.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        
        Dividend_Interest = "Y"
//        ECSYesBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        
        RTA = "Y"
//        RTAYesBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        
        All_thePledgeInstructions = "N"
//        instructionsNoBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
       SIXTHAPI(userID: fetchedUserId ?? "")
        navigationItem.hidesBackButton = true
        
        //fatherNameTF.layer.cornerRadius = 10
        //fatherNameTF.layer.borderWidth = 1
        //fatherNameTF.layer.borderColor = UIColor.gray.cgColor
        
        motherNameTF.layer.cornerRadius = 10
        motherNameTF.layer.borderWidth = 1
        motherNameTF.layer.borderColor = UIColor.appBorder.cgColor
        
//        MaritalBtn.layer.cornerRadius = 10
//        MaritalBtn.layer.borderWidth = 1
//        MaritalBtn.layer.borderColor = UIColor.gray.cgColor
        
        educationView.layer.cornerRadius = 10
        educationView.layer.borderWidth = 1
        educationView.layer.borderColor = UIColor.appBorder.cgColor
        
        occupationView.layer.cornerRadius = 10
        occupationView.layer.borderWidth = 1
        occupationView.layer.borderColor = UIColor.appBorder.cgColor
        
        annualIncomeView.layer.cornerRadius = 10
        annualIncomeView.layer.borderWidth = 1
        annualIncomeView.layer.borderColor = UIColor.appBorder.cgColor
        
        runningAccountView.layer.cornerRadius = 10
        runningAccountView.layer.borderWidth = 1
        runningAccountView.layer.borderColor = UIColor.appBorder.cgColor
        
        tradingExperienceTF.layer.cornerRadius = 10
        tradingExperienceTF.layer.borderWidth = 1
        tradingExperienceTF.layer.borderColor = UIColor.appBorder.cgColor
        
        networthTxt.layer.cornerRadius = 10
        networthTxt.layer.borderWidth = 1
        networthTxt.layer.borderColor = UIColor.appBorder.cgColor
        
        networthDatebtn.layer.cornerRadius = 10
        networthDatebtn.layer.borderWidth = 1
        networthDatebtn.layer.borderColor = UIColor.appBorder.cgColor
        
        nameNominee = "NM"
        runningAccountAuthorization = "90days"
    
        marriedBtn.tintColor = .appPrimary
        singleBtn.tintColor = .appPrimary
        politicallyYes.tintColor = .appPrimary
        politicallyNo.tintColor = .appPrimary
        ECSYesBtn.tintColor = .appPrimary
        ECSNoBtn.tintColor = .appPrimary
        DISYesBtn.tintColor = .appPrimary
        DISNoBtn.tintColor = .appPrimary
        view.backgroundColor = .appBackground
    }

    func updateDisSelection() {
        if DIS == "Y" {
            DISYesBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
            DISNoBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        } else if DIS == "N" {
            DISYesBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            DISNoBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        }
    }
    
    func updatePoliticallySelection() {
        if politically == "Y" {
            politicallyYes.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
            politicallyNo.setImage(UIImage(systemName: "circle"), for: .normal)
        } else if politically == "N" {
            politicallyYes.setImage(UIImage(systemName: "circle"), for: .normal)
            politicallyNo.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        }
    }
    
    @objc func networthTextChanged() {
        let text = networthTxt.text ?? ""
        if !text.isEmpty {
            networthDateTxt.isHidden = false
            networthDatebtn.isHidden = false
            
            // Set today's date by default
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let formattedDate = formatter.string(from: Date())
            print("Formatted Date: \(formattedDate)")
            networthDateTxt.text = formattedDate
        } else {
            networthDateTxt.isHidden = true
            networthDatebtn.isHidden = true
            networthDateTxt.text = ""
        }
    }
    
    private func fetchUserId() {
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.fetchedUserId = userId
                self.fetchedSessionID = sessionID
                self.mobiledecodeArray = decodeByteArrayString
                print("UserID: \(userId), SessionID: \(sessionID)")
                self.ValidateToken()
            } else {
                print("No UserID or SessionID found.")
            }
        }
    }
    
    @IBAction func homeBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        delegate?.reloadPageData()

          let vc = ApplicationFormVC()
          vc.panNo = panNo
          vc.regId = regId
          vc.PANName = PANName
          vc.EmailId = EmailId

          navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func annualIncomebtn(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "annualIncomeVC") as? annualIncomeVC {
            vc.modalPresentationStyle = .overCurrentContext
            
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func EducationBtn(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EducationVC") as? EducationVC {
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    @IBAction func OccupationBtn(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "OccupationVC") as? OccupationVC {
            vc.modalPresentationStyle = .overCurrentContext
            
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }

    @IBAction func MaritalStatusBtnTapped(_ sender: UIButton) {
        if sender == marriedBtn {
            marriedBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
            singleBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            maritalStatus = "1"
        } else if sender == singleBtn {
            marriedBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            singleBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
            maritalStatus = "2"
        }
    }
    
    @IBAction func DISBtn(_ sender: UIButton) {
        if sender == DISYesBtn {
            DIS = "Y"
        } else if sender == DISNoBtn {
            DIS = "N"
        }
        updateDisSelection()
    }
    
    @IBAction func PoliticallyExposedBtn(_ sender: UIButton) {
        if sender == politicallyYes {
            politically = "Y"
        } else if sender == politicallyNo {
            politically = "N"
        }
        updatePoliticallySelection()
    }

    func updateECSSelection() {
        if Dividend_Interest == "Y" {
            ECSYesBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
            ECSNoBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        } else if Dividend_Interest == "N" {
            ECSYesBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            ECSNoBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        }
    }
    
    @IBAction func ECSBtn(_ sender: UIButton) {
        if sender == ECSYesBtn {
            Dividend_Interest = "Y"
        } else if sender == ECSNoBtn {
            Dividend_Interest = "N"
        }
        updateECSSelection()
    }

    func didSelectNetworthDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        networthDateTxt.text = formatter.string(from: date)
    }
    
    func didSelectMarital(id:String,type: String) {
        MaritalBtn.setTitle(type, for: .normal)
        maritalStatus = id
    }
    func didselectEducation(id: String,type: String) {
        EducationBtn.setTitle(type, for: .normal)
        education = id
    }
    func didSelectOccupation(id:String,name: String) {
        OccupationBtn.setTitle(name, for: .normal)
        occupation = id
    }
    func didselectincome(id: String, type: String) {
        annualIncomeBtn.setTitle(type, for: .normal)
        annual = id
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Handle 'fatherNameTF' and 'motherNameTF' for alphabetic input only
        if textField.tag == 1 || textField.tag == 2 {
            // Allowed character set: alphabetic letters (both uppercase and lowercase)
            let allowedCharacterSet = CharacterSet.letters.union(CharacterSet.whitespaces)
            
            // Characters in the input
            let replacementCharacterSet = CharacterSet(charactersIn: string)
            
            // Check if the replacement string consists of letters and spaces only
            let isReplacementStringValid = allowedCharacterSet.isSuperset(of: replacementCharacterSet)
            
            // Allow the change only if valid characters (letters/spaces) are entered
            return isReplacementStringValid
        }
        
        // Handle 'tradingExperienceTF' for numeric input with maximum 2 digits
        if textField.tag == 3 {
            // Maximum length for tradingExperienceTF is 2 digits
            let maxLength = 2
            
            // Current text in the text field
            let currentString: NSString = textField.text as NSString? ?? ""
            
            // New string after applying the replacement
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            // Allowed character set: digits (numbers only)
            let allowedCharacterSet = CharacterSet.decimalDigits
            
            // Characters in the input
            let replacementCharacterSet = CharacterSet(charactersIn: string)
            
            // Check if the replacement string consists of digits only
            let isReplacementStringNumeric = allowedCharacterSet.isSuperset(of: replacementCharacterSet)
            
            // Ensure the new string is numeric and doesn't exceed the maximum length
            return newString.length <= maxLength && isReplacementStringNumeric
        }
        
        if textField.tag == 4 {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        return true // Default return if no conditions match
    }
    
    @IBAction func saveNnext(_ sender: UIButton) {
//        fatherName = fatherNameTF.text
//        motherName = motherNameTF.text
//        tradingExperience = tradingExperienceTF.text
//        networth = networthTxt.text
//        networthDate = networthDateTxt.text
//        
//        // Validate the input values one by one with individual alerts
//        if fatherName == nil || fatherName!.isEmpty {
//            showAlert(message: "Please fill in Father's Name.")
//            return
//        }
//        
//        if let networth = networthTxt.text, !networth.isEmpty {
//            // Networth is filled, so check for date
//            guard let networthDate = networthDateTxt.text, !networthDate.isEmpty else {
//                // Date is missing, show alert
//                showAlert(message: "Please select Networth Date.")
//                return
//            }
//        }
//        
//        if let networthText = networthTxt.text,
//           let networthValue = Int(networthText),
//           networthValue < 100000 {
//            
//            showAlert(message: "Networth should not be less than 1,00,000")
//            return
//        }
//        
//        if fatherName == nil || fatherName!.isEmpty {
//            showAlert(message: "Please fill in Father's Name.")
//            return
//        }
//        
//        if maritalStatus == nil || maritalStatus!.isEmpty {
//            showAlert(message: "Please select Marital Status.")
//            return
//        }
//        
//        // Check for education - skip alert if it's "0"
//        if education == nil || (education! == "0") {
//            showAlert(message: "Please select Education.")
//        } else if education!.isEmpty {
//            showAlert(message: "Please select Education.")
//            return
//        }
//        
//        // Check for occupation - skip alert if it's "0"
//        if occupation == nil || (occupation! == "0") {
//            showAlert(message: "Please select Occupation.")
//        } else if occupation!.isEmpty {
//            showAlert(message: "Please select Occupation.")
//            return
//        }
//        
//        if annual == nil || (annual! == "0") {
//            showAlert(message: "Please select Annual Income.")
//        } else if occupation!.isEmpty {
//            showAlert(message: "Please select Annual Income.")
//            return
//        }
//        
//        if tradingExperience == nil || tradingExperience!.isEmpty || tradingExperience! == "0" {
//             showAlert(message: "Please select Trading Experience.")
//             return
//         }
//        SaveOtherData()
        
        fatherName = fatherNameTF.text
            motherName = motherNameTF.text
            tradingExperience = tradingExperienceTF.text
            networth = networthTxt.text
        networthDate = networthDateTxt.text

        guard let fatherName = fatherName, !fatherName.isEmpty else {
               showAlert(message: "Please fill in Father's Name.")
               return
           }

           // ✅ Marital Status
           guard let maritalStatus = maritalStatus, !maritalStatus.isEmpty else {
               showAlert(message: "Please select Marital Status.")
               return
           }

           // ✅ Education
           guard let education = education, !education.isEmpty, education != "0" else {
               showAlert(message: "Please select Education.")
               return
           }

           // ✅ Occupation
           guard let occupation = occupation, !occupation.isEmpty, occupation != "0" else {
               showAlert(message: "Please select Occupation.")
               return
           }

           // ✅ Annual Income
           guard let annual = annual, !annual.isEmpty, annual != "0" else {
               showAlert(message: "Please select Annual Income.")
               return
           }

           // ✅ Trading Experience (ALLOW 0 ✅)
           guard let tradingExperience = tradingExperience, !tradingExperience.isEmpty else {
               showAlert(message: "Please enter Trading Experience.")
               return
           }

           // ✅ Networth (MANDATORY)
//           guard let networth = networth, !networth.isEmpty else {
//               showAlert(message: "Please enter Networth.")
//               return
//           }

           // ✅ Networth Date (MANDATORY)
//           guard let networthDate = networthDate, !networthDate.isEmpty else {
//               showAlert(message: "Please select Networth Date.")
//               return
//           }

           // ✅ Networth Minimum Check
//           if let networthValue = Int(networth), networthValue < 100000 {
//               showAlert(message: "Networth should not be less than 1,00,000")
//               return
//           }

           // ✅ Running Account Authorization
           guard let runningAccountAuthorization = runningAccountAuthorization, !runningAccountAuthorization.isEmpty else {
               showAlert(message: "Please select Running Account Authorization.")
               return
           }

           // ✅ Dividend Interest
           guard let dividend = Dividend_Interest, !dividend.isEmpty else {
               showAlert(message: "Please select Dividend/Interest option.")
               return
           }

           // ✅ DIS
           guard let dis = DIS, !dis.isEmpty else {
               showAlert(message: "Please select DIS option.")
               return
           }
        
        if self.IsDerivative.uppercased() == "Y" {
            if let networthText = networthTxt.text, !networthText.isEmpty,
               let networthValue = Double(networthText.replacingOccurrences(of: ",", with: "")) {
                
                if networthValue < 100000 {
                    showAlert(message: "Networth must be at least 1 Lakh.")
                    return
                }
                
                // Networth date is mandatory
                if networthDate == nil || networthDate!.isEmpty {
                    showAlert(message: "Please select Networth Date.")
                    return
                }
                
            } else {
                showAlert(message: "Please fill in Networth.")
                return
            }
        }

           // ✅ All validations passed
           SaveOtherData()
       }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension OtherDetailsVC{
    func ValidateToken(){
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                    if success {
                        // Call SIXTHAPI after tokenMobile API call is successful
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
    
    func GetEducationMaster() {
        let url = "DropDownManagement/GetEducationMaster"
        
        apiCall(url: url, method: "POST", parameters: [:], view: self.view) { result in
            switch result {
            case .success(let jsonResponse):
                print("GetEducationMaster Response: \(jsonResponse)")
                if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
                    DispatchQueue.main.async {
                        if let educationList = jsonResponse["EducationMasterList"] as? [[String: Any]] {
                            // Populate the dictionary with the education ID and names (both as String)
                            for education in educationList {
                                if let id = education["Id"] as? String, let name = education["Name"] as? String {
                                    self.educationDictionary[id] = name
                                }
                            }
                            print("Education dictionary populated: \(self.educationDictionary)")
                        }
                    }
                }
            case .failure(let error):
                print("GetEducationMaster API call failed: \(error.localizedDescription)")
            }
        }
    }
 
    func GetOccupationMaster(){
        
        let Url = "DropDownManagement/GetOccupationMaster"
        
        apiCall(url: Url, method: "POST", parameters: [:] , view: self.view) { result in
            switch result {
            case .success(let jsonResponse):
                print("GetOccupationMaster Response: \(jsonResponse)")
                if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
                    DispatchQueue.main.async {
                        if let occupationList = jsonResponse["OccupationMasterList"] as? [[String: Any]] {
                            // Populate the dictionary with the education ID and names (both as String)
                            for occupation in occupationList {
                                if let id = occupation["Id"] as? String, let name = occupation["Name"] as? String {
                                    self.OccupationDictionary[id] = name
                                }
                            }
                            print("Education dictionary populated: \(self.OccupationDictionary)")
                        }
                    }
                }
            case .failure(let error):
                print("Login API call failed: \(error.localizedDescription)")
            }
        }
    }
    func GetAnnualIncomeMaster(){
        
        let Url = "DropDownManagement/GetAnnualIncomeMaster"
        
        apiCall(url: Url, method: "POST", parameters: [:] , view: self.view) { result in
            switch result {
            case .success(let jsonResponse):
                print("GetAnnualIncomeMaster Response: \(jsonResponse)")
                if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
                    DispatchQueue.main.async {
                        if let annualList = jsonResponse["AnnualIncomeMasterList"] as? [[String: Any]] {
                            // Populate the dictionary with the education ID and names (both as String)
                            for annual in annualList {
                                if let id = annual["Id"] as? String, let name = annual["Name"] as? String {
                                    self.annualDictionary[id] = name
                                }
                            }
                            print("Education dictionary populated: \(self.annualDictionary)")
                        }
                    }
                }
            case .failure(let error):
                print("Login API call failed: \(error.localizedDescription)")
            }
        }
    }
    func ViewOtherData(){
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                    if success {
                        // Call SIXTHAPI after tokenMobile API call is successful
                        self.ViewOtherData()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "UserId":  fetchedUserId,
                "TokenId": tokenId,
                "RegId": regId,
                "PanNo": panNo
                
            ]
            print(parameters)
            let Url = "Client/ViewOtherData"
            
            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any] , view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("ViewOtherData Response: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            DispatchQueue.main.async {
                                print("api is running")
                                self.updateui(with: jsonResponse)
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
    func updateui(with response: [String: Any]){
        
        // Ensure the EducationID is fetched and matched correctly
        if let educationID = response["EducationID"] as? Int {
            let educationIDString = String(educationID) // Convert Int to String
            self.education = educationIDString
            
            if let educationName = self.educationDictionary[educationIDString] {
                // Update the button title with the education name on the main thread
                DispatchQueue.main.async {
                    self.EducationBtn.setTitle(educationName, for: .normal)
                }
            } else {
                print("No matching education name found for ID: \(educationIDString)")
            }
        }
        
        // Ensure the occupationID is fetched and matched correctly
        if let occupationId = response["OccupationID"] as? Int {
            let occupationIDString = String(occupationId) // Convert Int to String
            self.occupation = occupationIDString
            
            if let occupationName = self.OccupationDictionary[occupationIDString] {
                // Update the button title with the education name on the main thread
                DispatchQueue.main.async {
                    self.OccupationBtn.setTitle(occupationName, for: .normal)
                }
            } else {
                print("No matching education name found for ID: \(occupationIDString)")
            }
        }
        
        // Ensure the annualID is fetched and matched correctly
        if let annualId = response["AnnualIncomeID"] as? Int {
            let annualIDString = String(annualId) // Convert Int to String
            self.annual = annualIDString
            
            if let annualName = self.annualDictionary[annualIDString] {
                // Update the button title with the education name on the main thread
                DispatchQueue.main.async {
                    self.annualIncomeBtn.setTitle(annualName, for: .normal)
                }
            } else {
                print("No matching education name found for ID: \(annualIDString)")
            }
        }

        if let DIS = response["DIS"] as? String {
            self.DIS = DIS
            print("DIS: \(self.DIS ?? "mulan")")
            self.DIS = DIS
            self.DISYesBtn.isEnabled = true
            self.DISNoBtn.isEnabled = true
            updateDisSelection()
        }
        
        if let politically = response["ReceiveEach_EveryCredits"] as? String {
            self.politically = politically
            print("ReceiveEach_EveryCredits: \(self.DIS ?? "mulan")")
            self.politically = politically
            self.politicallyYes.isEnabled = true
            self.politicallyNo.isEnabled = true
            updatePoliticallySelection()
            
        }
        
        if maritalStatus == "1" {
            marriedBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
            singleBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        } else if maritalStatus == "2" {
            marriedBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            singleBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        }
        
        if let MotherName = response["MotherName"] as? String, let FatherSpouseName=response["FatherSpouseName"] as? String,let InvestmentExperience=response["InvestmentExperience"] as? String,
           let Networth = response["Networth"] as? String,
           let NetworthDate = response["NetworthDate"] as? String
        {
            self.fatherNameTF.text  = FatherSpouseName
            self.motherNameTF.text  = MotherName
            self.tradingExperienceTF.text  = InvestmentExperience
            self.networthTxt.text = Networth
            self.networthDateTxt.text = NetworthDate
            if !Networth.isEmpty {
                    self.networthDateTxt.isHidden = false
                    self.networthDatebtn.isHidden = false
                } else {
                    self.networthDateTxt.isHidden = true
                    self.networthDatebtn.isHidden = true
                }
        }
        
        if let ecs = response["Dividend_Interest"] as? String {
            self.Dividend_Interest = ecs
            self.ECSYesBtn.isEnabled = true
            self.ECSNoBtn.isEnabled = true
            updateECSSelection()
        }
    }
    
    func SaveOtherData(){
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                    if success {
                        // Call SIXTHAPI after tokenMobile API call is successful
                        self.SaveOtherData()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "UserId":  fetchedUserId,
                "TokenId": tokenId,
                "RegId": regId,
                "PanNo": panNo,
                "ClientProfile": "",
                "IsDDPI": ddpi,
                "Marital_Status": maritalStatus,
                "NatureOfBussiness": "",
                "Client_Designation": "",
                "AnnualReport": AnnualReport,
                "All_thePledgeInstructions": All_thePledgeInstructions,
                "PEPType": "N",
                "MotherName": motherName,
                "NameOfAP": "",
                "InvestmentExperience": tradingExperience,
                "NameOfExchange": "",
                "DealingWithSB": "",
                "CommodityCategoriValue": "",
                "FatherSpouseName": fatherName,
                "PastAction": "",
                "ReceiveEach_EveryCredits": credit,
                "SourceOfWealth": "",
                "AccountStatementRequirement": AccountStatementRequirement,
                "AnnualIncomeID": annual,
                "isCommodityCategoriDone": "0",
                "ElectronicTransaction_Cum_Holding": ElectronicTransaction_Cum_Holding,
                "HighValueTransactions": "",
                "OccupationId": occupation,
                "EducationID": education,
                "Dividend_Interest": Dividend_Interest,
                "CommodityCategoriKey": "",
                "RTA": RTA,
                "NameOfEmployer": "",
                "DetailsOfDisputes": "",
                "DIS": DIS,
                "Networth": networth,
                "NetworthDate": networthDate,
                "Nom_Details_statement": nameNominee,
                "RunningAccountAuthorization": runningAccountAuthorization
            ]
            if let jsonData = try? JSONSerialization.data(withJSONObject: parameters.compactMapValues { $0 }, options: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Request Body JSON:\n\(jsonString)")
                let Url = "Client/SaveOtherData"
                
                apiCall(url: Url, method: "POST", parameters: parameters as [String : Any] , view: self.view,loaderText: "please wait...") { result in
                    switch result {
                    case .success(let jsonResponse):
                        print("SaveOtherData Response: \(jsonResponse)")
                        if let errorCode = jsonResponse["ErrorCode"] as? String {
                            switch errorCode {
                            case "000000":
                                DispatchQueue.main.async {
                                    let storyboard = UIStoryboard(name: "Nominee", bundle: Bundle.module)
                                    if let nextVC = storyboard.instantiateViewController(withIdentifier: "NomineeVC") as? NomineeVC {
                                        nextVC.panNo = self.panNo
                                        nextVC.RegId = self.regId
                                        self.navigationController?.pushViewController(nextVC, animated: true)
                                    }
                                }
                            case "001010":
                                if let errorMessage = jsonResponse["ErrorMessage"] as? String {
                                    DispatchQueue.main.async {
                                        self.showAlert(message: errorMessage)
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        self.showAlert(message: "Experience cannot be greater than age.")
                                    }
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
                                            // Retry SIXTHAPI after token regeneration
                                            self.ValidateToken()
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
                        print("Login API call failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

extension OtherDetailsVC {
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
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
                                print("All TokenMobile entries deleted due to error code 999992")
                                
                                // Regenerate tokens
                                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: userID, SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
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
                            self.IsDerivative = (jsonResponse["IsDerivative"] as? String ?? "N").uppercased()
                            if let panName = jsonResponse["PANName"] as? String {
                                DispatchQueue.main.async {
                                    self.applicantNameLbl.text = panName
                                }
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


