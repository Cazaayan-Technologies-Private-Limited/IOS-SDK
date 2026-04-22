//
//  digiNomiVC.swift
//  t5
//
//  Created by manas dutta on 20/03/26.
//

//import UIKit
//
//class digiNomiVC: UIViewController, @MainActor VerticsVC1Delegate, @MainActor DigiLocker_b_VCDelegate1 {
//
//    @IBOutlet weak var backgroundView: UIView!
//    @IBOutlet weak var holderview: UIView!
//    @IBOutlet weak var continueBtn: UIButton!
//
//    var digilockerDone:String?
//    var EmailId: String?
//    var panNo: String?
//    var PANName: String?
//    var regId: String?
//    var mobiledecodeArray: String?
//    var fetchedUserId: String?
//    var fetchedSessionID: String?
//    var transactionID: String?
//    var identifier3: String?
//    var identifier1: String?
//    weak var delegate: VerticsVCDelegate?
//    var responseData: [String: Any]?
//    var nomineeIndex: Int = 0  // 1, 2, or 3
//    var isGuardian: Bool = false
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
//     
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
//                        withIdentifier: "digiVerifyVC") as? digiVerifyVC
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
//            let savedPAN = UserDefaults.standard.string(forKey: "SavedPAN")
//            let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.panNo
//            
//            let regId = UserDefaults.standard.string(forKey: "RegId")
//            let regIdFinal = (regId?.isEmpty == false) ? regId : self.regId
//            vc.panNo = finalPAN
//            vc.regId = regIdFinal
//            //vc.delegate = self
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else if identifier3 == "NomineeVC" {
//            if identifier3 == "NomineeVC" {
//                if let data = responseData, let id = identifier1 {
//                    // Create a modified identifier that includes the index
//                    let modifiedIdentifier = "\(id)_\(nomineeIndex)_\(isGuardian)"
//                    delegate?.didReceiveApiResponse(data: data, identifier1: modifiedIdentifier, identifier3: identifier3 ?? "")
//                }
//                self.navigationController?.popViewController(animated: true)
//            }
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
//        
//        var panValue: String = panNo ?? ""
//                
//                switch identifier1 {
//                case "NomineeDocument1":
//                    panValue = "NOMINEE_1"
//                case "NomineeDocument2":
//                    panValue = "NOMINEE_2"
//                case "NomineeDocument3":
//                    panValue = "NOMINEE_3"
//                case "guardianDocument1":
//                    panValue = "NOMINEE_1G"
//                case "guardianDocument2":
//                    panValue = "NOMINEE_2G"
//                case "guardianDocument3":
//                    panValue = "NOMINEE_3G"
//                default:
//                    panValue = panNo ?? "" // fallback for main PAN
//                }
//        
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
//                "RegId": regId,
//                "PanNo": panNo,
//                "PanName": panValue,
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
//        let vc = DigiVerticsVC()
//        vc.DigiLockerURL = DigiLockerURL
//        vc.TransactionID = TransactionID
//        vc.RegId = regId
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

import UIKit

class digiNomiVC: UIViewController, @MainActor VerticsVC1Delegate  {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var holderview: UIView!
    @IBOutlet weak var continueBtn: UIButton!

    var digilockerDone:String?
    var EmailId: String?
    var panNo: String?
    var PANName: String?
    var regId: String?
    var mobiledecodeArray: String?
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var transactionID: String?
    var identifier3: String?
    var identifier1: String?
    weak var delegate: VerticsVC1Delegate?
    var responseData: [String: Any]?
    var nomineeIndex: Int = 0  // 1, 2, or 3
    var isGuardian: Bool = false

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
    }
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
//                        withIdentifier: "digiVerifyVC") as? digiVerifyVC
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
//            }
//        } else {
//            print("No ErrorCode found in the response.")
//        }
//    }

    //func didReceiveApiResponse(data: [String: Any], identifier1: String, identifier3: String) {
//        func didReceiveApiResponse(data: [String: Any], identifier1: String, identifier3: String) {
//            self.responseData = data
//            self.identifier1 = identifier1
//            print("Received data: \(data)")
//
//            if let errorCode = data["ErrorCode"] as? String, errorCode == "000000" {
//
//                let modifiedIdentifier = "\(identifier1)_\(nomineeIndex)_\(isGuardian)"
//
//                DispatchQueue.main.async {
//                    if let navController = self.navigationController {
//                        let viewControllers = navController.viewControllers
//
//                        // Find NomineeVC in the navigation stack
//                        for vc in viewControllers.reversed() {
//                            if let nomineeVC = vc as? NomineeVC {  // ← replace with your actual class name
//
//                                // ✅ Call delegate directly on the NomineeVC instance
//                                nomineeVC.didReceiveApiResponse(
//                                    data: data,
//                                    identifier1: modifiedIdentifier,
//                                    identifier3: identifier3
//                                )
//
//                                // ✅ Pop AFTER setting data
//                                navController.popToViewController(nomineeVC, animated: true)
//                                return
//                            }
//                        }
//                    }
//                }
//            } else {
//                print("No ErrorCode found or error in response.")
//            }
//        }
    
    func didReceiveApiResponse(data: [String: Any], identifier1: String, identifier3: String) {
        self.responseData = data
        self.identifier1 = identifier1
        print("Received data: \(data)")

        if let errorCode = data["ErrorCode"] as? String, errorCode == "000000" {

            // Parse the index and isGuardian from identifier1 if needed
            var nomineeIndex = 0
            var isGuardian = false
            
            switch identifier1 {
            case "NomineeDocument1":
                nomineeIndex = 1
                isGuardian = false
            case "NomineeDocument2":
                nomineeIndex = 2
                isGuardian = false
            case "NomineeDocument3":
                nomineeIndex = 3
                isGuardian = false
            case "guardianDocument1":
                nomineeIndex = 1
                isGuardian = true
            case "guardianDocument2":
                nomineeIndex = 2
                isGuardian = true
            case "guardianDocument3":
                nomineeIndex = 3
                isGuardian = true
            default:
                break
            }
            
            let modifiedIdentifier = "\(identifier1)_\(nomineeIndex)_\(isGuardian)"

            DispatchQueue.main.async {
                if let navController = self.navigationController {
                    let viewControllers = navController.viewControllers

                    for vc in viewControllers.reversed() {
                        if let nomineeVC = vc as? NomineeVC {
                            nomineeVC.didReceiveApiResponse(
                                data: data,
                                identifier1: modifiedIdentifier,
                                identifier3: identifier3
                            )
                            navController.popToViewController(nomineeVC, animated: true)
                            return
                        }
                    }
                }
            }
        } else {
            print("No ErrorCode found or error in response.")
        }
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
                "RegId": regId,
                "PanNo": panValue,
                "PanName": "N",
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
                                            TransactionID: TransactionID ?? ""
                                        )
                                    } else if digiType == "DIRECT" {
                                        let url =
                                        "\(DigiLockerURL ?? "")?redirect_uri=\(digilockerReturnURL ?? "")&response_type=code&response_type=code&client_id=\(Client_id ?? "")&state=\(TransactionID ?? "")"
                                        self.navigateToVeriticsVC(
                                            DigiLockerURL: url,
                                            TransactionID: TransactionID ?? ""
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

    func navigateToVeriticsVC(DigiLockerURL: String, TransactionID: String) {

        let vc = DigiVerticsVC()
        vc.DigiLockerURL = DigiLockerURL
        vc.TransactionID = TransactionID
        vc.RegId = regId
        vc.panNo = panNo
//        vc.identifier3 = "DigiLockerA"
//        vc.identifier3 = "NomineeVC"
        //vc.identifier1 = identifier1
        vc.identifier3 = "NomineeVC"   // NomineeVC OR DigiLockerA
        vc.identifier1 = identifier1
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

