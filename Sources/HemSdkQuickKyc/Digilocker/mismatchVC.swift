//
//  mismatchVC.swift
//  t5
//
//  Created by manas dutta on 12/12/25.
//

//import UIKit
//
//class mismatchVC: UIViewController {
//    
//    @IBOutlet weak var errorLbl: UILabel!
//    @IBOutlet weak var AadhaarLbl: UILabel!
//    @IBOutlet weak var holderView: UIView!
//    @IBOutlet weak var panLbl: UILabel!
//    @IBOutlet weak var confirmBtn: UIButton!
//    @IBOutlet weak var CancelBtn: UIButton!
//    
//    var errorMessage: String?
//    var aadhaarName: String?
//    var panName: String?
//    weak var delegate: DigiLocker_b_VCDelegate?
//    var panNo : String?
//    var regid : String?
//    var trasactionid : String?
//    var userid : String?
//    var mobiledecodeArray: String?
//    var fetchedUserId: String?
//    var fetchedSessionID: String?
//    var identifier3: String?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        confirmBtn.layer.cornerRadius = 20
//        holderView.layer.cornerRadius = 10
//        CancelBtn.layer.cornerRadius = 20
//        let errorText = "Aadhaar Name Error! \(errorMessage ?? "Aadhar PAN doesn't match")"
//        errorLbl.text = errorText
//        errorLbl.textColor = .black  // Keep whole text black
//        
//        // Configure AadhaarLbl with attributed text
//        let aadhaarAttributedText = NSMutableAttributedString(string: "Aadhaar Name: ", attributes: [.foregroundColor: UIColor.black])
//        let aadhaarNameText = NSAttributedString(string: "\(aadhaarName ?? "aadhaar name")", attributes: [.foregroundColor: UIColor.red])
//        aadhaarAttributedText.append(aadhaarNameText)
//        AadhaarLbl.attributedText = aadhaarAttributedText
//        
//        // Configure panLbl with attributed text
//        let panAttributedText = NSMutableAttributedString(string: "PAN Name: ", attributes: [.foregroundColor: UIColor.black])
//        let panNameText = NSAttributedString(string: "\(panName ?? "pan name")", attributes: [.foregroundColor: UIColor.red])
//        panAttributedText.append(panNameText)
//        panLbl.attributedText = panAttributedText
//        
//        CoreDataHelper.fetchUserId(entityName: "MobileUser") {
//            [weak self] userId, sessionID, decodeByteArrayString in
//            guard let self = self else { return }
//            
//            if let userId = userId, let sessionID = sessionID {
//                self.fetchedUserId = userId
//                self.fetchedSessionID = sessionID
//                self.mobiledecodeArray = decodeByteArrayString
//                print("UserID: \(userId), SessionID: \(sessionID)")
//            } else {
//                print("No UserID or SessionID found.")
//            }
//        }
//    }
//    
//    @IBAction func cancelBtn(_ sender: UIButton) {
//        dismiss(animated: true)
//    }
//    
//    @IBAction func confirmBtn(_ sender: Any) {
////        self.dismiss(animated: true) {
////            //            self.delegate?.didDismissDigiLockerVC()
////            self.ValidatesaveDigiLocker()
////        }
//        self.ValidatesaveDigiLocker()
//    }
//    //    func ValidatesaveDigiLocker(completion: @escaping (Bool) -> Void) {
//    //            CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//    //                guard let tokenId = tokenId else {
//    //                    print("No tokens available. Please reload the tokens.")
//    //                    completion(false)
//    //                    return
//    //                }
//    //                let parameters: [String: Any?] = [
//    //                    "UserId": userid,
//    //                    "TokenId": tokenId,
//    //                     "PanNo": panno,
//    //                     "RegId": regid,
//    //                     "TransactionID": trasactionid,
//    //                     "Flag": 0,
//    //                     "ThirdPartyRequest": ""
//    //                ]
//    //                print("\(parameters)")
//    //                let Url = "AadhaarData/ConfirmAadharName"
//    //
//    //                apiCall(url: Url, method: "POST", parameters: parameters as [String: Any], view: self.view) { result in
//    //                    switch result {
//    //                    case .success(let jsonResponse):
//    //                        print("ValidateIsDigiLockerDone Response: \(jsonResponse)")
//    //                        if let errorCode = jsonResponse["ErrorCode"] as? String {
//    //                            switch errorCode {
//    //                            case "000000":
//    //                                DispatchQueue.main.async {
//    //                                    print("API is running")
//    //                                    self.delegate?.didDismissDigiLockerVC()
//    //                                    completion(true)
//    //                                }
//    //                            default:
//    //                                print("Unhandled error code: \(errorCode)")
//    //                                completion(false)
//    //                            }
//    //                        }
//    //                    case .failure(let error):
//    //                        print("Login API call failed: \(error.localizedDescription)")
//    //                        completion(false)
//    //                    }
//    //                }
//    //            }
//    //        }
//    
//    func ValidatesaveDigiLocker(){
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//            guard let tokenId = tokenId else {
//                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                    if success {
//                        // Call SIXTHAPI after tokenMobile API call is successful
//                        self.ValidatesaveDigiLocker()
//                        //self.panValidation(panNo: panNo, name: name, userDOB: userDOB, isGuardian: isGuardian)
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                
//                return
//            }
//            let parameters: [String: Any] = [
//                "UserId": userid,
//                "TokenId": tokenId,
//                "PanNo": panNo,
//                "RegId": regid,
//                "TransactionID": trasactionid,
//                "Flag": 0,
//                "ThirdPartyRequest": ""
//            ]
//            
//            let URL = "AadhaarData/ConfirmAadharName"
//            
//            apiCall(url: URL, method: "POST", parameters: parameters, view: self.view) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("DigiLocker mismatch Response: \(jsonResponse)")
//                    
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "000000":
//                            DispatchQueue.main.async {
//                                self.delegate?.didDismissDigiLockerVC()
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
//}
//import UIKit
//
//class mismatchVC: UIViewController {
//    
//    @IBOutlet weak var errorLbl: UILabel!
//    @IBOutlet weak var AadhaarLbl: UILabel!
//    @IBOutlet weak var holderView: UIView!
//    @IBOutlet weak var panLbl: UILabel!
//    @IBOutlet weak var confirmBtn: UIButton!
//    @IBOutlet weak var CancelBtn: UIButton!
//    
//    var errorMessage: String?
//    var aadhaarName: String?
//    var panName: String?
//    weak var delegate: DigiLocker_b_VCDelegate?
//    var panNo : String?
//    var regid : String?
//    var trasactionid : String?
//    var userid : String?
//    var mobiledecodeArray: String?
//    var fetchedUserId: String?
//    var fetchedSessionID: String?
//    var identifier3: String?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        confirmBtn.layer.cornerRadius = 20
//        holderView.layer.cornerRadius = 10
//        CancelBtn.layer.cornerRadius = 20
//        let errorText = "Aadhaar Name Error! \(errorMessage ?? "Aadhar PAN doesn't match")"
//        errorLbl.text = errorText
//        errorLbl.textColor = .black  // Keep whole text black
//        
//        // Configure AadhaarLbl with attributed text
//        let aadhaarAttributedText = NSMutableAttributedString(string: "Aadhaar Name: ", attributes: [.foregroundColor: UIColor.black])
//        let aadhaarNameText = NSAttributedString(string: "\(aadhaarName ?? "aadhaar name")", attributes: [.foregroundColor: UIColor.red])
//        aadhaarAttributedText.append(aadhaarNameText)
//        AadhaarLbl.attributedText = aadhaarAttributedText
//        
//        // Configure panLbl with attributed text
//        let panAttributedText = NSMutableAttributedString(string: "PAN Name: ", attributes: [.foregroundColor: UIColor.black])
//        let panNameText = NSAttributedString(string: "\(panName ?? "pan name")", attributes: [.foregroundColor: UIColor.red])
//        panAttributedText.append(panNameText)
//        panLbl.attributedText = panAttributedText
//        
//        CoreDataHelper.fetchUserId(entityName: "MobileUser") {
//            [weak self] userId, sessionID, decodeByteArrayString in
//            guard let self = self else { return }
//            
//            if let userId = userId, let sessionID = sessionID {
//                self.fetchedUserId = userId
//                self.fetchedSessionID = sessionID
//                self.mobiledecodeArray = decodeByteArrayString
//                print("UserID: \(userId), SessionID: \(sessionID)")
//            } else {
//                print("No UserID or SessionID found.")
//            }
//        }
//    }
//    
//    @IBAction func cancelBtn(_ sender: UIButton) {
//        dismiss(animated: true)
//    }
//    
//    @IBAction func confirmBtn(_ sender: Any) {
////        self.dismiss(animated: true) {
////            //            self.delegate?.didDismissDigiLockerVC()
////            self.ValidatesaveDigiLocker()
////        }
//        self.ValidatesaveDigiLocker()
//    }
//    //    func ValidatesaveDigiLocker(completion: @escaping (Bool) -> Void) {
//    //            CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//    //                guard let tokenId = tokenId else {
//    //                    print("No tokens available. Please reload the tokens.")
//    //                    completion(false)
//    //                    return
//    //                }
//    //                let parameters: [String: Any?] = [
//    //                    "UserId": userid,
//    //                    "TokenId": tokenId,
//    //                     "PanNo": panno,
//    //                     "RegId": regid,
//    //                     "TransactionID": trasactionid,
//    //                     "Flag": 0,
//    //                     "ThirdPartyRequest": ""
//    //                ]
//    //                print("\(parameters)")
//    //                let Url = "AadhaarData/ConfirmAadharName"
//    //
//    //                apiCall(url: Url, method: "POST", parameters: parameters as [String: Any], view: self.view) { result in
//    //                    switch result {
//    //                    case .success(let jsonResponse):
//    //                        print("ValidateIsDigiLockerDone Response: \(jsonResponse)")
//    //                        if let errorCode = jsonResponse["ErrorCode"] as? String {
//    //                            switch errorCode {
//    //                            case "000000":
//    //                                DispatchQueue.main.async {
//    //                                    print("API is running")
//    //                                    self.delegate?.didDismissDigiLockerVC()
//    //                                    completion(true)
//    //                                }
//    //                            default:
//    //                                print("Unhandled error code: \(errorCode)")
//    //                                completion(false)
//    //                            }
//    //                        }
//    //                    case .failure(let error):
//    //                        print("Login API call failed: \(error.localizedDescription)")
//    //                        completion(false)
//    //                    }
//    //                }
//    //            }
//    //        }
//    
//    func ValidatesaveDigiLocker(){
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
//            guard let tokenId = tokenId else {
//                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                    if success {
//                        // Call SIXTHAPI after tokenMobile API call is successful
//                        self.ValidatesaveDigiLocker()
//                        //self.panValidation(panNo: panNo, name: name, userDOB: userDOB, isGuardian: isGuardian)
//                    } else {
//                        print("Token generation failed.")
//                    }
//                }
//                print("No tokens available. Please reload the tokens.")
//                
//                return
//            }
//            let parameters: [String: Any] = [
//                "UserId": userid,
//                "TokenId": tokenId,
//                "PanNo": panNo,
//                "RegId": regid,
//                "TransactionID": trasactionid,
//                "Flag": 0,
//                "ThirdPartyRequest": ""
//            ]
//            
//            let URL = "AadhaarData/ConfirmAadharName"
//            
//            apiCall(url: URL, method: "POST", parameters: parameters, view: self.view) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("DigiLocker mismatch Response: \(jsonResponse)")
//                    
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
//                        case "000000":
//                            DispatchQueue.main.async {
//                                self.delegate?.didDismissDigiLockerVC()
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
//}
import UIKit

class mismatchVC: UIViewController {
    
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var AadhaarLbl: UILabel!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var panLbl: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var CancelBtn: UIButton!
    
    var errorMessage: String?
    var aadhaarName: String?
    var panName: String?
    weak var delegate: DigiLocker_b_VCDelegate?
    var panNo : String?
    var regId : String?
    var trasactionid : String?
    var userid : String?
    var mobiledecodeArray: String?
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var identifier3: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmBtn.layer.cornerRadius = 20
        holderView.layer.cornerRadius = 10
        CancelBtn.layer.cornerRadius = 20
        let errorText = "Aadhaar Name Error! \(errorMessage ?? "Aadhar PAN doesn't match")"
        errorLbl.text = errorText
        errorLbl.textColor = .black  // Keep whole text black
        
        // Configure AadhaarLbl with attributed text
        let aadhaarAttributedText = NSMutableAttributedString(string: "Aadhaar Name: ", attributes: [.foregroundColor: UIColor.black])
        let aadhaarNameText = NSAttributedString(string: "\(aadhaarName ?? "aadhaar name")", attributes: [.foregroundColor: UIColor.red])
        aadhaarAttributedText.append(aadhaarNameText)
        AadhaarLbl.attributedText = aadhaarAttributedText
        
        // Configure panLbl with attributed text
        let panAttributedText = NSMutableAttributedString(string: "PAN Name: ", attributes: [.foregroundColor: UIColor.black])
        let panNameText = NSAttributedString(string: "\(panName ?? "pan name")", attributes: [.foregroundColor: UIColor.red])
        panAttributedText.append(panNameText)
        panLbl.attributedText = panAttributedText
        
        CoreDataHelper.fetchUserId(entityName: "MobileUser") {
            [weak self] userId, sessionID, decodeByteArrayString in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.fetchedUserId = userId
                self.fetchedSessionID = sessionID
                self.mobiledecodeArray = decodeByteArrayString
                print("UserID: \(userId), SessionID: \(sessionID)")
            } else {
                print("No UserID or SessionID found.")
            }
        }
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        //        self.dismiss(animated: true) {
        //            //            self.delegate?.didDismissDigiLockerVC()
        //            self.ValidatesaveDigiLocker()
        //        }
        self.ValidatesaveDigiLocker()
    }
    //    func ValidatesaveDigiLocker(completion: @escaping (Bool) -> Void) {
    //            CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
    //                guard let tokenId = tokenId else {
    //                    print("No tokens available. Please reload the tokens.")
    //                    completion(false)
    //                    return
    //                }
    //                let parameters: [String: Any?] = [
    //                    "UserId": userid,
    //                    "TokenId": tokenId,
    //                     "PanNo": panno,
    //                     "RegId": regid,
    //                     "TransactionID": trasactionid,
    //                     "Flag": 0,
    //                     "ThirdPartyRequest": ""
    //                ]
    //                print("\(parameters)")
    //                let Url = "AadhaarData/ConfirmAadharName"
    //
    //                apiCall(url: Url, method: "POST", parameters: parameters as [String: Any], view: self.view) { result in
    //                    switch result {
    //                    case .success(let jsonResponse):
    //                        print("ValidateIsDigiLockerDone Response: \(jsonResponse)")
    //                        if let errorCode = jsonResponse["ErrorCode"] as? String {
    //                            switch errorCode {
    //                            case "000000":
    //                                DispatchQueue.main.async {
    //                                    print("API is running")
    //                                    self.delegate?.didDismissDigiLockerVC()
    //                                    completion(true)
    //                                }
    //                            default:
    //                                print("Unhandled error code: \(errorCode)")
    //                                completion(false)
    //                            }
    //                        }
    //                    case .failure(let error):
    //                        print("Login API call failed: \(error.localizedDescription)")
    //                        completion(false)
    //                    }
    //                }
    //            }
    //        }
    
    func ValidatesaveDigiLocker(){
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                    if success {
                        // Call SIXTHAPI after tokenMobile API call is successful
                        self.ValidatesaveDigiLocker()
                        //self.panValidation(panNo: panNo, name: name, userDOB: userDOB, isGuardian: isGuardian)
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                
                return
            }
            let parameters: [String: Any] = [
                "UserId": userid,
                "TokenId": tokenId,
                "PanNo": panNo,
                "RegId": regId,
                "TransactionID": trasactionid,
                "Flag": 0,
                "ThirdPartyRequest": ""
            ]
            
            let URL = "AadhaarData/ConfirmAadharName"
            
            apiCall(url: URL, method: "POST", parameters: parameters, view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("DigiLocker mismatch Response: \(jsonResponse)")
                    
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            DispatchQueue.main.async {
                                
                                //                                  let storyboard = UIStoryboard(name: "TradingandDemat", bundle: Bundle.module)
                                //                                  let vc = storyboard.instantiateViewController(identifier: "TradingandDematVC") as! TradingandDematVC
                                //                                  vc.panNo = self.panNo
                                //                                  vc.regId = self.regid
                                //
                                //                                  self.navigationController?.pushViewController(vc, animated: true)
                                if self.identifier3 == "NomineeVC" {
                                    
                                    self.navigationController?.popViewController(animated: true)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        self.delegate?.didDismissDigiLockerVC()
                                    }
                                    
                                } else {
                                    
                                    let storyboard = UIStoryboard(name: "TradingandDemat", bundle: Bundle.module)
                                    let vc = storyboard.instantiateViewController(identifier: "TradingandDematVC") as! TradingandDematVC
                                    let savedPAN = UserDefaults.standard.string(forKey: "PanNo")
                                    let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.panNo
                                    
                                    let regId = UserDefaults.standard.string(forKey: "RegId")
                                    let regIdFinal = (regId?.isEmpty == false) ? regId : self.regId
                                    
                                    vc.panNo = finalPAN
                                    vc.regId = regIdFinal
                                    
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                            //                            DispatchQueue.main.async {
                            //                                 self.dismiss(animated: true) {
                            //                                     //self.delegate?.didDismissDigiLockerVC()
                            //                                     let storyboard = UIStoryboard(name: "TradingandDemat", bundle: Bundle.module)
                            //                                     let vc = storyboard.instantiateViewController(identifier: "TradingandDematVC") as! TradingandDematVC
                            //                                     vc.panNo = self.panNo
                            //                                     vc.regId = self.regid
                            //                                     self.navigationController?.pushViewController(vc, animated: true)
                            //                                 }
                            //                            
                            //                             }
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
