//
//  DigiLocker_a.swift
//  t5
//
//  Created by manas dutta on 12/12/25.
//

//import UIKit
//
//class DigiLocker_a: UIViewController, @MainActor VerticsVCDelegate, @MainActor DigiLocker_b_VCDelegate {
//
//    @IBOutlet weak var backgroundView: UIView!
//    @IBOutlet weak var holderview: UIView!
//    @IBOutlet weak var continueBtn: UIButton!
//
//    var digilockerDone:String?
//    var EmailId: String?
//    var panNo: String?
//    var PANName: String?
//    var RegId: String?
//    var mobiledecodeArray: String?
//    var fetchedUserId: String?
//    var fetchedSessionID: String?
//    var transactionID: String?
//    var identifier3: String?
//    var identifier1: String?
//    weak var delegate: VerticsVCDelegate?
//    var responseData: [String: Any]?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
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
//        print(
//            "\(EmailId ?? "" ) and \(panNo  ?? "") and \(PANName ?? "") and \(RegId ?? "")"
//        )
//        //backgroundView.isHidden = true
//        backgroundView.backgroundColor = UIColor.gray
//        backgroundView.alpha = 0.9
//        holderview.layer.cornerRadius = 25
//        holderview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        holderview.clipsToBounds = true
//        holderview.backgroundColor = .white
//        continueBtn.backgroundColor = .appPrimary
//        continueBtn.layer.cornerRadius = 10
//        view.backgroundColor = .appBackground
//    }
//    func didReceiveApiResponse(data: [String: Any], identifier1: String, identifier3: String) {
//        // Handle the received data
//        self.responseData = data
//        print("Received data: \(data)")
//
//        // Check the error code in the response
//        if let errorCode = data["ErrorCode"] as? String {
//            if errorCode == "000000" {
//                // Proceed with existing functionality
//                let name = data["NameAsPerAadhaar"] as? String
//                let dob = data["DOB"] as? String
//                let gender = data["Gender"] as? String
//                let fatherName = data["FatherSpouseName"] as? String
//                let address =
//                "\(data["Address1"] as? String ?? ""), \(data["Address2"] as? String ?? ""), \(data["Address3"] as? String ?? ""), \(data["City"] as? String ?? ""), \(data["State"] as? String ?? ""), \(data["PinCode"] as? String ?? "")"
//
//                // Automatically present the DigiLocker_b_VC screen with the data
//
//                self.navigationController?.popViewController(animated: true)
//
//                // 2. Delay presentation until pop finishes
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
//                    if let digiLockerVC = storyboard.instantiateViewController(
//                        withIdentifier: "DigiLocker_b_VC") as? DigiLocker_b_VC
//                    {
//                        digiLockerVC.name = name
//                        digiLockerVC.dob = dob
//                        digiLockerVC.gender = gender
//                        digiLockerVC.fatherName = fatherName
//                        digiLockerVC.address = address
//                        digiLockerVC.modalPresentationStyle = .overCurrentContext
//                        digiLockerVC.modalTransitionStyle = .crossDissolve
//                        digiLockerVC.delegate = self
//                        self.present(digiLockerVC, animated: true, completion: nil)
//                    }
//                }
//            } else if errorCode == "000023" {
//                self.navigationController?.popViewController(animated: true)
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    let errorMessage = data["ErrorMessage"] as? String
//                    let aadhaarName = data["NameAsPerAadhaar"] as? String
//                    let panName = data["PANName"] as? String
//
//                    let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
//                    let vc =
//                    storyboard.instantiateViewController(
//                        withIdentifier: "mismatchVC") as! mismatchVC
//                    vc.modalPresentationStyle = .overCurrentContext
//                    vc.modalTransitionStyle = .crossDissolve
//                    vc.errorMessage = errorMessage
//                    vc.aadhaarName = aadhaarName
//                    vc.panName = panName
//                    vc.userid = self.fetchedUserId
//                    vc.panNo = self.panNo
//                    vc.regid = self.RegId
//                    vc.trasactionid = self.transactionID
//                    vc.delegate = self
//                    self.present(vc, animated: true)
//                    print("Error: \(data)")
//                }
//            }
//        } else {
//            print("No ErrorCode found in the response.")
//        }
//    }
//
//    func didDismissDigiLockerVC() {
//        print("Forwarding data to NomineeVC")
//        print("responseData:", responseData)
//        print("identifier1:", identifier1)
//
//        if identifier3 == "DigiLockerA" {
//            let storyboard = UIStoryboard(name: "TradingandDemat", bundle: Bundle.module)
//            let vc = storyboard.instantiateViewController(identifier: "TradingandDematVC") as! TradingandDematVC
//            vc.panNo = panNo
//            vc.regId = RegId
//            //vc.delegate = self
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else if identifier3 == "NomineeVC" {
//            if let data = responseData, let id = identifier1 {
//                delegate?.didReceiveApiResponse(data: data, identifier1: id, identifier3: identifier3 ?? "")
//                 }
//            self.navigationController?.popViewController(animated: true)
//        }
//    }
//
//    @IBAction func ConnectToDigiLockerBtn(_ sender: UIButton) {
//        saveDigiLocker()
//    }
//
//    func tokenAuthentication() {
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
//            [self] tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self
//                        .mobiledecodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile", deviceType: "W",
//                    in: self.view
//                ) { success in
//                    if success {
//                        // Retry SIXTHAPI after token regeneration
//                        self.tokenAuthentication()
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
//                    print("TOKEN Authentication Response: \(jsonResponse)")
//
//                case .failure(let error):
//                    print(
//                        "Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//    func saveDigiLocker() {
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
//            [self] tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                    if success {
//                        self.saveDigiLocker()
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
//                "RegId": RegId,
//                "PanNo": panNo,
//                "PanName": PANName,
//                "Flag": "INSERT",
//                "ThirdPartyRequest": "",
//            ]
//            print(parameters)
//            let Url = "AadhaarData/SaveDigiLockerAuditLogDetails"
//
//            apiCall(
//                url: Url, method: "POST",
//                parameters: parameters as [String: Any], view: self.view,
//                loaderText: "please wait..."
//            ) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("SAVE-DIGILOCKER Response: \(jsonResponse)")
//                    let DigiLockerURL = jsonResponse["DigiLockerURL"] as? String
//                    let digilockerReturnURL =
//                    jsonResponse["DigiLockeReturnURL"] as? String
//                    let Client_id = jsonResponse["Client_id"] as? String
//                    let TransactionID = jsonResponse["TransactionID"] as? String
//                    self.transactionID = TransactionID
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
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
//                                    USERID: self.self.fetchedUserId ?? "",
//                                    SessionId: self.fetchedSessionID ?? "",
//                                    entityName: "TokenMobile", deviceType: "W",
//                                    in: self.view
//                                ) { success in
//                                    if success {
//                                        self.saveDigiLocker()
//                                    } else {
//                                        print("Token generation failed.")
//                                    }
//                                }
//                            }
//                        case "000000":
//                            DispatchQueue.main.async { [self] in
//                                if let digiType = jsonResponse["DigiType"]
//                                    as? String
//                                {
//                                    if digiType == "VERITICS" {
//                                        // Perform the action for VERITICSVC
//                                        navigateToVeriticsVC(
//                                            DigiLockerURL: DigiLockerURL ?? "",
//                                            TransactionID: TransactionID ?? ""
//                                        )
//                                    } else if digiType == "DIRECT" {
//                                        let url =
//                                        "\(DigiLockerURL ?? "")?redirect_uri=\(digilockerReturnURL ?? "")&response_type=code&response_type=code&client_id=\(Client_id ?? "")&state=\(TransactionID ?? "")"
//                                        self.navigateToVeriticsVC(
//                                            DigiLockerURL: url,
//                                            TransactionID: TransactionID ?? ""
//                                        )
//                                    } else {
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
//                    print(
//                        "Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//    func navigateToVeriticsVC(DigiLockerURL: String, TransactionID: String) {
//
//        let vc = VerticsVC()
//        vc.DigiLockerURL = DigiLockerURL
//        vc.TransactionID = TransactionID
//        vc.RegId = RegId
//        vc.panNo = panNo
////        vc.identifier3 = "DigiLockerA"
////        vc.identifier3 = "NomineeVC"
//        //vc.identifier1 = identifier1
//        vc.identifier3 = identifier3   // NomineeVC OR DigiLockerA
//        vc.identifier1 = identifier1
//        vc.delegate = self
//        navigationController?.pushViewController(vc, animated: true)
//    }
//}
//
//import UIKit
//
//class DigiLocker_a: UIViewController, @MainActor VerticsVCDelegate, @MainActor DigiLocker_b_VCDelegate {
//
//    @IBOutlet weak var backgroundView: UIView!
//    @IBOutlet weak var holderview: UIView!
//    @IBOutlet weak var continueBtn: UIButton!
//
//    var digilockerDone:String?
//    var EmailId: String?
//    var panNo: String?
//    var PANName: String?
//    var RegId: String?
//    var mobiledecodeArray: String?
//    var fetchedUserId: String?
//    var fetchedSessionID: String?
//    var transactionID: String?
//    var identifier3: String?
//    var identifier1: String?
//    weak var delegate: VerticsVCDelegate?
//    var responseData: [String: Any]?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
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
//        print(
//            "\(EmailId ?? "" ) and \(panNo  ?? "") and \(PANName ?? "") and \(RegId ?? "")"
//        )
//        //backgroundView.isHidden = true
//        backgroundView.backgroundColor = UIColor.gray
//        backgroundView.alpha = 0.9
//        holderview.layer.cornerRadius = 25
//        holderview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        holderview.clipsToBounds = true
//        holderview.backgroundColor = .white
//        continueBtn.backgroundColor = .appPrimary
//        continueBtn.layer.cornerRadius = 10
//        view.backgroundColor = .appBackground
//    }
//    func didReceiveApiResponse(data: [String: Any], identifier1: String, identifier3: String) {
//        // Handle the received data
//        self.responseData = data
//        print("Received data: \(data)")
//
//        // Check the error code in the response
//        if let errorCode = data["ErrorCode"] as? String {
//            if errorCode == "000000" {
//                // Proceed with existing functionality
//                let name = data["NameAsPerAadhaar"] as? String
//                let dob = data["DOB"] as? String
//                let gender = data["Gender"] as? String
//                let fatherName = data["FatherSpouseName"] as? String
//                let address =
//                "\(data["Address1"] as? String ?? ""), \(data["Address2"] as? String ?? ""), \(data["Address3"] as? String ?? ""), \(data["City"] as? String ?? ""), \(data["State"] as? String ?? ""), \(data["PinCode"] as? String ?? "")"
//
//                // Automatically present the DigiLocker_b_VC screen with the data
//
////                self.navigationController?.popViewController(animated: true)
//
//                // 2. Delay presentation until pop finishes
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
//                    if let digiLockerVC = storyboard.instantiateViewController(
//                        withIdentifier: "DigiLocker_b_VC") as? DigiLocker_b_VC
//                    {
//                        digiLockerVC.name = name
//                        digiLockerVC.dob = dob
//                        digiLockerVC.gender = gender
//                        digiLockerVC.fatherName = fatherName
//                        digiLockerVC.address = address
//                        digiLockerVC.modalPresentationStyle = .overCurrentContext
//                        digiLockerVC.modalTransitionStyle = .crossDissolve
//                        digiLockerVC.delegate = self
//                        digiLockerVC.identifier3 = self.identifier3
//                        self.navigationController?.pushViewController(digiLockerVC, animated: true)
//                    }
//                }
//            } else if errorCode == "000023" {
//                //self.navigationController?.popViewController(animated: true)
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    let errorMessage = data["ErrorMessage"] as? String
//                    let aadhaarName = data["NameAsPerAadhaar"] as? String
//                    let panName = data["PANName"] as? String
//
//                    let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
//                    let vc =
//                    storyboard.instantiateViewController(
//                        withIdentifier: "mismatchVC") as! mismatchVC
//                    vc.modalPresentationStyle = .overCurrentContext
//                    vc.modalTransitionStyle = .crossDissolve
//                    vc.errorMessage = errorMessage
//                    vc.aadhaarName = aadhaarName
//                    vc.panName = panName
//                    vc.userid = self.fetchedUserId
//                    vc.panNo = self.panNo
//                    vc.regid = self.RegId
//                    vc.trasactionid = self.transactionID
//                    vc.identifier3 = self.identifier3
//                    vc.delegate = self
//                    self.present(vc, animated: true)
//                    print("Error: \(data)")
//                }
//            }
//        } else {
//            print("No ErrorCode found in the response.")
//        }
//    }
//
//    func didDismissDigiLockerVC() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                if self.identifier3 == "DigiLockerA" {
//                    let storyboard = UIStoryboard(name: "TradingandDemat", bundle: Bundle.module)
//                    let vc = storyboard.instantiateViewController(identifier: "TradingandDematVC") as! TradingandDematVC
//                    vc.panNo = self.panNo
//                    vc.regId = self.RegId
//
//                    self.navigationController?.setViewControllers([vc], animated: true)
//
//                } else if self.identifier3 == "NomineeVC" {
//                    if let data = self.responseData, let id = self.identifier1 {
//                        self.delegate?.didReceiveApiResponse(data: data, identifier1: id, identifier3: self.identifier3 ?? "")
//                    }
//                    self.navigationController?.popViewController(animated: true)
//                }
//            }
////        print("Forwarding data to NomineeVC")
////        print("responseData:", responseData)
////        print("identifier1:", identifier1)
////
////        if identifier3 == "DigiLockerA" {
////            let storyboard = UIStoryboard(name: "TradingandDemat", bundle: Bundle.module)
////            let vc = storyboard.instantiateViewController(identifier: "TradingandDematVC") as! TradingandDematVC
////            vc.panNo = panNo
////            vc.regId = RegId
////            //vc.delegate = self
////            self.navigationController?.setViewControllers([vc], animated: true)
////        } else if identifier3 == "NomineeVC" {
////            if let data = responseData, let id = identifier1 {
////                delegate?.didReceiveApiResponse(data: data, identifier1: id, identifier3: identifier3 ?? "")
////                 }
////            self.navigationController?.popViewController(animated: true)
////        }
//    }
//
//    @IBAction func ConnectToDigiLockerBtn(_ sender: UIButton) {
//        saveDigiLocker()
//    }
//
//    func tokenAuthentication() {
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
//            [self] tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(
//                    decodeByteArrayToString: self
//                        .mobiledecodeArray ?? "",
//                    USERID: self.fetchedUserId ?? "",
//                    SessionId: self.fetchedSessionID ?? "",
//                    entityName: "TokenMobile", deviceType: "W",
//                    in: self.view
//                ) { success in
//                    if success {
//                        // Retry SIXTHAPI after token regeneration
//                        self.tokenAuthentication()
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
//                    print("TOKEN Authentication Response: \(jsonResponse)")
//
//                case .failure(let error):
//                    print(
//                        "Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//    func saveDigiLocker() {
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
//            [self] tokenId in
//            guard let tokenId = tokenId else {
//                // Handle the case where no tokens are available
//                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
//                    if success {
//                        self.saveDigiLocker()
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
//                "RegId": RegId,
//                "PanNo": panNo,
//                "PanName": PANName,
//                "Flag": "INSERT",
//                "ThirdPartyRequest": "",
//            ]
//            print(parameters)
//            let Url = "AadhaarData/SaveDigiLockerAuditLogDetails"
//
//            apiCall(
//                url: Url, method: "POST",
//                parameters: parameters as [String: Any], view: self.view,
//                loaderText: "please wait..."
//            ) { result in
//                switch result {
//                case .success(let jsonResponse):
//                    print("SAVE-DIGILOCKER Response: \(jsonResponse)")
//                    let DigiLockerURL = jsonResponse["DigiLockerURL"] as? String
//                    let digilockerReturnURL =
//                    jsonResponse["DigiLockeReturnURL"] as? String
//                    let Client_id = jsonResponse["Client_id"] as? String
//                    let TransactionID = jsonResponse["TransactionID"] as? String
//                    self.transactionID = TransactionID
//                    if let errorCode = jsonResponse["ErrorCode"] as? String {
//                        switch errorCode {
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
//                                    USERID: self.self.fetchedUserId ?? "",
//                                    SessionId: self.fetchedSessionID ?? "",
//                                    entityName: "TokenMobile", deviceType: "W",
//                                    in: self.view
//                                ) { success in
//                                    if success {
//                                        self.saveDigiLocker()
//                                    } else {
//                                        print("Token generation failed.")
//                                    }
//                                }
//                            }
//                        case "000000":
//                            DispatchQueue.main.async { [self] in
//                                if let digiType = jsonResponse["DigiType"]
//                                    as? String
//                                {
//                                    if digiType == "VERITICS" {
//                                        // Perform the action for VERITICSVC
//                                        navigateToVeriticsVC(
//                                            DigiLockerURL: DigiLockerURL ?? "",
//                                            TransactionID: TransactionID ?? ""
//                                        )
//                                    } else if digiType == "DIRECT" {
//                                        let url =
//                                        "\(DigiLockerURL ?? "")?redirect_uri=\(digilockerReturnURL ?? "")&response_type=code&response_type=code&client_id=\(Client_id ?? "")&state=\(TransactionID ?? "")"
//                                        self.navigateToVeriticsVC(
//                                            DigiLockerURL: url,
//                                            TransactionID: TransactionID ?? ""
//                                        )
//                                    } else {
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
//                    print(
//                        "Login API call failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//    func navigateToVeriticsVC(DigiLockerURL: String, TransactionID: String) {
//
//        let vc = VerticsVC()
//        vc.DigiLockerURL = DigiLockerURL
//        vc.TransactionID = TransactionID
//        vc.RegId = RegId
//        vc.panNo = panNo
////        vc.identifier3 = "DigiLockerA"
////        vc.identifier3 = "NomineeVC"
//        //vc.identifier1 = identifier1
//        vc.identifier3 = identifier3  // NomineeVC OR DigiLockerA
//        vc.identifier1 = identifier1
//        vc.delegate = self
//        navigationController?.pushViewController(vc, animated: true)
//    }
//}

import UIKit

class DigiLocker_a: UIViewController, @MainActor VerticsVCDelegate, @MainActor DigiLocker_b_VCDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var holderview: UIView!
    @IBOutlet weak var continueBtn: UIButton!
    
    var digilockerDone:String?
    var EmailId: String?
    var panNo: String?
    var PANName: String?
    var RegId: String?
    var mobiledecodeArray: String?
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var transactionID: String?
    var identifier3: String?
    var identifier1: String?
    weak var delegate: VerticsVCDelegate?
    var responseData: [String: Any]?
    var digiIdentifier1: String?
    var regId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        print(
            "\(EmailId ?? "" ) and \(panNo  ?? "") and \(PANName ?? "") and \(RegId ?? "")"
        )
        //backgroundView.isHidden = true
        backgroundView.backgroundColor = UIColor.gray
        backgroundView.alpha = 0.9
        holderview.layer.cornerRadius = 25
        holderview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        holderview.clipsToBounds = true
        holderview.backgroundColor = .white
        continueBtn.backgroundColor = .appPrimary
        continueBtn.layer.cornerRadius = 10
        view.backgroundColor = .appBackground
        navigationItem.hidesBackButton = true
    }
    func didReceiveApiResponse(data: [String: Any], identifier1: String, identifier3: String) {
        // Handle the received data
        self.responseData = data
        print("Received data: \(data)")
        
        // Check the error code in the response
        if let errorCode = data["ErrorCode"] as? String {
            if errorCode == "000000" {
                // Proceed with existing functionality
                let name = data["NameAsPerAadhaar"] as? String
                let dob = data["DOB"] as? String
                let gender = data["Gender"] as? String
                let fatherName = data["FatherSpouseName"] as? String
                let address =
                "\(data["Address1"] as? String ?? ""), \(data["Address2"] as? String ?? ""), \(data["Address3"] as? String ?? ""), \(data["City"] as? String ?? ""), \(data["State"] as? String ?? ""), \(data["PinCode"] as? String ?? "")"
                
                // Automatically present the DigiLocker_b_VC screen with the data
                
                //                self.navigationController?.popViewController(animated: true)
                
                // 2. Delay presentation until pop finishes
                DispatchQueue.main.async {
                    guard let nav = self.navigationController else { return }
                    
                    let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
                    if let digiLockerVC = storyboard.instantiateViewController(
                        withIdentifier: "DigiLocker_b_VC"
                    ) as? DigiLocker_b_VC {
                        
                        digiLockerVC.name = name
                        digiLockerVC.dob = dob
                        digiLockerVC.gender = gender
                        digiLockerVC.fatherName = fatherName
                        digiLockerVC.address = address
                        digiLockerVC.delegate = self
                        
                        // ✅ VERY IMPORTANT
                        digiLockerVC.identifier3 = identifier3
                        
                        nav.pushViewController(digiLockerVC, animated: true)
                    }
                }
            } else if errorCode == "000023" {
                //self.navigationController?.popViewController(animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let errorMessage = data["ErrorMessage"] as? String
                    let aadhaarName = data["NameAsPerAadhaar"] as? String
                    let panName = data["PANName"] as? String
                    
                    let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
                    let vc =
                    storyboard.instantiateViewController(
                        withIdentifier: "mismatchVC") as! mismatchVC
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    vc.errorMessage = errorMessage
                    vc.aadhaarName = aadhaarName
                    vc.panName = panName
                    vc.userid = self.fetchedUserId
                    vc.panNo = self.panNo
                    vc.regId = self.RegId
                    vc.trasactionid = self.transactionID
                    vc.identifier3 = self.identifier3
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                    print("Error: \(data)")
                }
            }
        } else {
            print("No ErrorCode found in the response.")
        }
    }
    
    func didDismissDigiLockerVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            guard let pan = self.panNo, !pan.isEmpty else {
                print("❌ PAN missing, not navigating")
                return
            }
            
            if self.identifier3 == "DigiLockerA" {
                let storyboard = UIStoryboard(name: "TradingandDemat", bundle: Bundle.module)
                let vc = storyboard.instantiateViewController(identifier: "TradingandDematVC") as! TradingandDematVC
                let savedPAN = UserDefaults.standard.string(forKey: "PanNo")
                let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.panNo
                
                let regId = UserDefaults.standard.string(forKey: "RegId")
                let regIdFinal = (regId?.isEmpty == false) ? regId : self.regId
                
                vc.panNo = finalPAN
                vc.regId = regIdFinal
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else if self.identifier3 == "NomineeVC" {
                if let data = self.responseData, let id = self.identifier1 {
                    self.delegate?.didReceiveApiResponse(data: data, identifier1: id, identifier3: self.identifier3 ?? "")
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
        //        print("Forwarding data to NomineeVC")
        //        print("responseData:", responseData)
        //        print("identifier1:", identifier1)
        //
        //        if identifier3 == "DigiLockerA" {
        //            let storyboard = UIStoryboard(name: "TradingandDemat", bundle: Bundle.module)
        //            let vc = storyboard.instantiateViewController(identifier: "TradingandDematVC") as! TradingandDematVC
        //            vc.panNo = panNo
        //            vc.regId = RegId
        //            //vc.delegate = self
        //            self.navigationController?.setViewControllers([vc], animated: true)
        //        } else if identifier3 == "NomineeVC" {
        //            if let data = responseData, let id = identifier1 {
        //                delegate?.didReceiveApiResponse(data: data, identifier1: id, identifier3: identifier3 ?? "")
        //                 }
        //            self.navigationController?.popViewController(animated: true)
        //        }
    }
    
    @IBAction func ConnectToDigiLockerBtn(_ sender: UIButton) {
        saveDigiLocker()
    }
    
    func tokenAuthentication() {
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
            [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
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
                        self.tokenAuthentication()
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
                    print("TOKEN Authentication Response: \(jsonResponse)")
                    
                case .failure(let error):
                    print(
                        "Login API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func saveDigiLocker() {
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
            [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                    if success {
                        self.saveDigiLocker()
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
                "RegId": RegId,
                "PanNo": panNo,
                "PanName": PANName,
                "Flag": "INSERT",
                "ThirdPartyRequest": "",
            ]
            print(parameters)
            let Url = "AadhaarData/SaveDigiLockerAuditLogDetails"
            
            apiCall(
                url: Url, method: "POST",
                parameters: parameters as [String: Any], view: self.view,
                loaderText: "please wait..."
            ) { result in
                switch result {
                case .success(let jsonResponse):
                    print("SAVE-DIGILOCKER Response: \(jsonResponse)")
                    let DigiLockerURL = jsonResponse["DigiLockerURL"] as? String
                    let digilockerReturnURL =
                    jsonResponse["DigiLockeReturnURL"] as? String
                    let Client_id = jsonResponse["Client_id"] as? String
                    let TransactionID = jsonResponse["TransactionID"] as? String
                    self.transactionID = TransactionID
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
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
                                    USERID: self.self.fetchedUserId ?? "",
                                    SessionId: self.fetchedSessionID ?? "",
                                    entityName: "TokenMobile", deviceType: "W",
                                    in: self.view
                                ) { success in
                                    if success {
                                        self.saveDigiLocker()
                                    } else {
                                        print("Token generation failed.")
                                    }
                                }
                            }
                        case "000000":
                            DispatchQueue.main.async { [self] in
                                if let digiType = jsonResponse["DigiType"]
                                    as? String
                                {
                                    if digiType == "VERITICS" {
                                        // Perform the action for VERITICSVC
                                        navigateToVeriticsVC(
                                            DigiLockerURL: DigiLockerURL ?? "",
                                            TransactionID: TransactionID ?? "", identifier3: identifier3 ?? ""
                                        )
                                    } else if digiType == "DIRECT" {
                                        let url =
                                        "\(DigiLockerURL ?? "")?redirect_uri=\(digilockerReturnURL ?? "")&response_type=code&response_type=code&client_id=\(Client_id ?? "")&state=\(TransactionID ?? "")"
                                        self.navigateToVeriticsVC(
                                            DigiLockerURL: url,
                                            TransactionID: TransactionID ?? "", identifier3: identifier3 ?? ""
                                        )
                                    } else {
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
                    print(
                        "Login API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func navigateToVeriticsVC(DigiLockerURL: String, TransactionID: String, identifier3: String) {
        
        let vc = VerticsVC()
        vc.DigiLockerURL = DigiLockerURL
        vc.TransactionID = TransactionID
        vc.RegId = RegId
        vc.panNo = panNo
        //        vc.identifier3 = "DigiLockerA"
        //        vc.identifier3 = "NomineeVC"
        //vc.identifier1 = identifier1
        vc.identifier3 = "DigiLockerA"
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}
