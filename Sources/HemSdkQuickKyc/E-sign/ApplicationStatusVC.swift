//
//  ApplicationStatusVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

class EsignVC: UIViewController, @MainActor AadhaarStackDelegate {
    
    func didAcceptTerms(segmentName: String, signKey: String) {
        print("Terms accepted for segment: \(segmentName)")
        NSDLEsign(segmentName: segmentName, signKey: signKey)
    }
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var onBordingView: UIView!
    @IBOutlet weak var applicationView: UIView!
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var approveView: UIView!
    @IBOutlet weak var onBordingDateLbl: UILabel!
    @IBOutlet weak var applicationDateLbl: UILabel!
    @IBOutlet weak var waitingDateLbl: UILabel!
    @IBOutlet weak var approveDateLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var pdfLbl: UILabel!
    @IBOutlet weak var holderview1: UIView!
    @IBOutlet weak var holderview2: UIView!
    @IBOutlet weak var holderview3: UIView!
    @IBOutlet weak var ekraBtn: UIButton!
    @IBOutlet weak var aofBtn: UIButton!
    @IBOutlet weak var ddpiBtn: UIButton!
    
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var mobiledecodeArray: String?
    var decodeArray:String?
    var panNo: String?
    var regId: String?
    var PANName : String?
    var EmailId : String?
    var isDerivative: String = "N"
    var networth: String?
    var networthDate: String?
    var finalStatus: String?
    var ekraSign: String = "0"
    var aofSign: String = "0"
    var ddpiSign: String = "0"
    var ekraID: String?
    var aofID: String?
    var ddpiID: String?
    var PanNo : String?
    var RegId : String?
    var signedResponse: String?
    var msg : String?
    var env : String?
    var pdfDataList: [[String: Any]] = []
    var esignRetryCount = 10
    var companyName: String?
    var returnurl: String?
    var txnId: String?
    var esignType: String?
    var currentEsignSegment: String?
    public var onStartEsign: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGroupedBackground
        navigationController?.isNavigationBarHidden = true
//        pdfLbl.isHidden = true
//        secondView.isHidden = true
//        mainView.layer.cornerRadius = 20
//        secondView.layer.cornerRadius = 20
//        secondView.layer.borderColor = UIColor.black.cgColor
//        secondView.layer.borderWidth = 1.0
        SIXTHAPI(userID: fetchedUserId ?? "" )
//        onBordingView.layer.cornerRadius = 25
//        applicationView.layer.cornerRadius = 25
//        waitingView.layer.cornerRadius = 25
//        approveView.layer.cornerRadius = 25
        
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.fetchedUserId = userId
                self.fetchedSessionID = sessionID
                self.decodeArray = decodeByteArrayString
                self.ValidateToken()
                print("UserID: \(userId), SessionID: \(sessionID)")
                self.ViewAllMultiPDF()
            } else {
                print("No UserID or SessionID found.")
            }
        }
       // ViewAllMultiPDF()
    }
    
    @IBAction func ekraBtnTapped(_ sender: UIButton) {
        handleSegmentBasedOnSignValue(segmentName: "EKRA", signKey: "ekraSign")
    }
    
    private func handleSegmentTap(segmentName: String, signKey: String) {
        var signValue = getSignValue(forKey: signKey)
        
        if signValue == "1" {
            // Construct URL
            let baseUrl = "https://signup.hemnxt.com:84/V4.0.0/api/MultiPartImageUpload/PDFDownload"
            guard let regId = RegId, let userId = fetchedUserId, let panNo = PanNo else {
                print("Missing parameters for URL construction")
                return
            }
            // Get dynamic ID based on segmentName
            guard let dynamicID = getDynamicID(forSegment: segmentName) else {
                print("No valid ID found for segment \(segmentName)")
                return
            }
            
            CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
                guard let self = self else { return }
                guard let tokenId = tokenId else {
                    CoreDataHelper.generateToken(
                        decodeByteArrayToString: self.decodeArray ?? "",
                        USERID: self.fetchedUserId ?? "",
                        SessionId: self.fetchedSessionID ?? "",
                        entityName: "TokenMobile", deviceType: "W", in: self.view
                    ) { success in
                        if success {
                            // Retry SIXTHAPI after token regeneration
                            self.handleSegmentTap(segmentName: segmentName, signKey: signKey)
                        } else {
                            print("Token generation failed.")
                        }
                    }
                    print("No tokens available. Please reload the tokens.")
                    return
                }
                
                let urlString = "\(baseUrl)?id=\(dynamicID)&RegId=\(regId)&UserId=\(userId)&PanNo=\(panNo)&PDFSegment=\(segmentName)&TokenId=\(tokenId)"
                print("Constructed URL: \(urlString)")
                self.openURLInSystemBrowser(urlString: urlString)
            }
        } else {
            print("\(segmentName) button tapped")
            //NSDLEsign(segmentName: segmentName, signKey: signKey)
            let sb = UIStoryboard(name: "Esign", bundle: Bundle.module)
            let vc = sb.instantiateViewController(
                withIdentifier: "AadhaarStackVC"
            ) as! AadhaarStackVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
            vc.segmentName = segmentName
            vc.signkey = signKey
            present(vc, animated: true)
        }
    }
    
    private func handleSegmentBasedOnSignValue(segmentName: String, signKey: String) {
        let signValue = getSignValue(forKey: signKey)
        
        if signValue == "0" {
            // If eSign value is 0, present the terms screen
            presentTermsScreen(segmentName: segmentName, signKey: signKey)
        } else {
            // Otherwise, directly handle the segment
            handleSegmentTap(segmentName: segmentName, signKey: signKey)
        }
    }
    
    private func presentTermsScreen(segmentName: String, signKey: String) {
        let sb = UIStoryboard(name: "Esign", bundle: Bundle.module)
        let vc = sb.instantiateViewController(
            withIdentifier: "AadhaarStackVC"
        ) as! AadhaarStackVC
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        vc.segmentName = segmentName
        vc.signkey = signKey
        
        present(vc, animated: true)
    }
    
    private func getSignValue(forKey key: String) -> String {
        switch key {
        case "ekraSign": return ekraSign
        case "aofSign": return aofSign
        case "ddpiSign": return ddpiSign
        default: return "0"
        }
    }
    
    private func updateSignValue(forKey key: String, value: String) {
        switch key {
        case "ekraSign": ekraSign = value
        case "aofSign": aofSign = value
        case "ddpiSign": ddpiSign = value
        default: break
        }
    }
    
    private func getDynamicID(forSegment segmentName: String) -> String? {
        switch segmentName {
        case "EKRA": return ekraID
        case "E": return aofID
        case "DDPI": return ddpiID
        default: return nil
        }
    }
    
    private func openURLInSystemBrowser(urlString: String) {
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            print("Invalid URL or cannot open URL")
            return
        }
        
        UIApplication.shared.open(url, options: [:]) { success in
            if success {
                print("Successfully opened URL in system browser")
            } else {
                print("Failed to open URL in system browser")
            }
        }
    }
    
    @IBAction func aofBtn(_ sender: UIButton) {
        if ekraSign == "0" {
            showAlert(message: "You need to sign the EKRA segment first.")
        } else {
            handleSegmentBasedOnSignValue(segmentName: "E", signKey: "aofSign")
        }
    }
    @IBAction func ddpiBtn(_ sender: UIButton) {
        if ekraSign == "0" && aofSign == "0" {
            showAlert(message: "You need to sign EKRA & AOF segments.")
        } else if ekraSign == "0" {
            showAlert(message: "You need to sign the EKRA segment first.")
        } else if aofSign == "0" {
            showAlert(message: "You need to sign the AOF segment first.")
        } else {
            handleSegmentBasedOnSignValue(segmentName: "DDPI", signKey: "ddpiSign")
        }
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func QuitBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func ValidateToken(){
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
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
                // Handle the case where no tokens are available
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
    
    func NSDLEsign(segmentName: String, signKey: String) {
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
            guard let self = self else { return }
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.decodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.NSDLEsign(segmentName: segmentName, signKey: signKey)
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
                "PanNo": PanNo,
                "RegId": RegId,
                "AuthMode": "1",
                "SegmentName": segmentName,
                "IsMobOrWeb": "1",
                "DeviceType": "IOS"
            ]
            
            let url = "NSDLEsign/NSDLEsignRquest"
            apiCall(url: url, method: "POST", parameters: parameters as [String: Any], view: self.view,loaderText: "processing data for esign,kindly wait until completed...") { result in
                switch result {
                case .success(let jsonResponse):
                    print("NSDLEsignRquest Response: \(jsonResponse)")
                    self.msg = jsonResponse["eXml"] as? String
                    self.env = "PROD"
                    let ErrorMessage = jsonResponse["ErrorMessage"] as? String
                    self.returnurl = jsonResponse["ReturnURL"] as? String
                    self.esignType = jsonResponse["EsignType"] as? String ?? ""
                    let esignUrl = jsonResponse["EsignUrl"] as? String ?? ""
                    self.txnId = jsonResponse["txn"] as? String ?? ""
                    let requestURL = jsonResponse["RquestURL"] as? String ?? ""
                    self.companyName = jsonResponse["CompanyName"] as? String
                    self.currentEsignSegment = segmentName
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            
                            if segmentName == "DDPI", self.msg == nil {
                                if !esignUrl.isEmpty {
                                    DispatchQueue.main.async {
                                        self.openURLInSystemBrowser(urlString: esignUrl)
                                    }
                                    return
                                }
                            }

                            if self.esignType == "SELF" {
                                DispatchQueue.main.async {
                                    let vc = WebviewAutoSubmitVC()
                                    vc.xmlMsg = self.msg ?? ""
                                    vc.CompanyName = self.companyName ?? ""
                                    vc.ReturnURL = self.returnurl ?? ""
                                    vc.txn = self.txnId ?? ""
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                return
                            }

                        case "111111":
                            DispatchQueue.main.async {
                                print("API is running for segment: \(segmentName)")
                            }
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(
                                    entityName: "TokenMobile")
                                print("All TokenMobile entries deleted due to error code 999992")
                                
                                CoreDataHelper.generateToken(
                                    decodeByteArrayToString: self.decodeArray ?? "",
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
                            self.showAlert(message: "\(String(describing: ErrorMessage))")
                        }
                    }
                case .failure(let error):
                    print("API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func esignDone(segmentName: String, transactionID: String, completion: @escaping (Bool) -> Void) {
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
            guard let self = self else { return }
            
            guard let tokenId = tokenId else {
                completion(false)
                return
            }
            
            let parameters: [String: Any?] = [
                "PanNo": self.PanNo,
                "RegId": self.RegId,
                "Segment": segmentName,
                "SessionId": self.fetchedSessionID,
                "UserId": self.fetchedUserId,
                "TokenId": tokenId,
                "TransactionID": transactionID
            ]
            
            apiCall(url: "NSDLEsign/ValidateIsEsignDone", method: "POST", parameters: parameters as [String: Any], view: self.view) { result in
                
                switch result {
                case .success(let jsonResponse):
                    let ErrorMessage = jsonResponse["ErrorMessage"] as? String
                    print("ValidateIsEsignDone: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                            
                        case "000000":
                            DispatchQueue.main.async {
                                print("api is running")
                                completion(true)
                                
                                self.showAlert(message: "E-sign completed successfully!")
                                
                                self.ViewAllMultiPDF()
                            }
                            
                        case "000002":
                            DispatchQueue.main.async {
                                print("api is running")
                                completion(true)
                                
                                if let nav = self.navigationController,
                                   let webVC = nav.viewControllers.last as? WebviewAutoSubmitVC {
                                    nav.popViewController(animated: true)
                                }
                                
                                self.showAlert(message: "Your e-signature name does not match the name on your PAN.")
                            }
                            
                        default:
                            print("Unhandled error code: \(errorCode)")
                            DispatchQueue.main.async {
                                completion(false)
                                //self.showAlert(message: ErrorMessage ?? "Unknown error occurred")
                            }
                        }
                    }
                case .failure(let error):
                    //self.showAlert(message: "Esign page:api failed--- \(error.localizedDescription)")
                    print("Login API call failed: \(error.localizedDescription)")
                    
                }
            }
        }
    }
    
    func NSDLEsignResponse(decodedResponse: String){
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.decodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "M", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.NSDLEsignResponse(decodedResponse: decodedResponse)
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
                "XMLResponse":decodedResponse
            ]
            //print(parameters)
            
            let Url = "NSDLEsign/NSDLEsignResponse"
            
            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view,loaderText: "please wait...") { result in
                switch result {
                case .success(let jsonResponse):
                    let ErrorMessage = jsonResponse["ErrorMessage"] as? String
                    print("NSDLEsignResponse Response: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            DispatchQueue.main.async {
                                print("api is running")
                                self.showAlert(message: "Esign page:successfully submitted")
                                self.ViewAllMultiPDF()
                            }
                        default:
                            print("Unhandled error code: \(errorCode)")
                            self.showAlert(message: "Esign page:failed to submit")
                            self.showAlert(message: ErrorMessage ?? "error occured")
                        }
                    }
                case .failure(let error):
                    self.showAlert(message: "Esign page:api failed--- \(error.localizedDescription)")
                    print("Login API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func  ViewAllMultiPDF(){
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.decodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "M", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.ViewAllMultiPDF()
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
                "PanNo":PanNo,
                "RegId":RegId,
                "SessionId":fetchedSessionID
            ]
            print(parameters)
            let Url = "/KYC/ViewAllMultiPDF"
            //KYC/ViewAllMultiPDF
            
            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view,loaderText: "please wait...") { result in
                switch result {
                case .success(let jsonResponse):
                    print("jsonresponse:-> \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
                        if let pdfList = jsonResponse["PDFForEsignList"] as? [[String: Any]] {
                            self.pdfDataList = pdfList
                            DispatchQueue.main.async {
                                // Default state: hide all views
                                self.holderview1.isHidden = true
                                self.holderview2.isHidden = true
                                self.holderview3.isHidden = true
                                
                                // Iterate through the PDF list
                                for pdf in pdfList {
                                    if let pdfSegment = pdf["PDFSegment"] as? String,
                                       let isPDFSign = pdf["IsPDFSign"] as? String,
                                       let id = pdf["Id"] as? String {
                                        switch pdfSegment {
                                        case "EKRA":
                                            self.holderview1.isHidden = false
                                            self.ekraSign = isPDFSign
                                            self.ekraID = id
                                            if isPDFSign == "1" {
                                                self.ekraBtn.setImage(UIImage(named: "Icon-29", in: Bundle.module, compatibleWith: nil),
                                                for: .normal)
                                                //self.ekraBtn.isUserInteractionEnabled = false
                                            }
                                        case "E":
                                            self.holderview2.isHidden = false
                                            self.aofSign = isPDFSign
                                            self.aofID = id
                                            if isPDFSign == "1" {
                                                //self.aofBtn.imageView?.contentMode = .scaleToFill
                                                self.aofBtn.setImage(UIImage(named: "Icon-29", in: Bundle.module, compatibleWith: nil),
                                                                     for: .normal)
                                                //self.aofBtn.isUserInteractionEnabled = false
                                            }
                                        case "DDPI":
                                            self.holderview3.isHidden = false
                                            self.ddpiSign = isPDFSign
                                            self.ddpiID = id
                                            if isPDFSign == "1" {
                                                self.ddpiBtn.setImage(UIImage(named: "Icon-29", in: Bundle.module, compatibleWith: nil),
                                                                      for: .normal)
                                                //self.ddpiBtn.isUserInteractionEnabled = false
                                            }
                                        default:
                                            break
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        print("Unhandled error code: \(jsonResponse["ErrorCode"] ?? "Unknown Error")")
                    }
                case .failure(let error):
                    print("Login API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension EsignVC {
    
    func SIXTHAPI(userID:String){
        
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.fetchedUserId = userId
                self.fetchedSessionID = sessionID
                self.decodeArray = decodeByteArrayString
                print("UserID: \(userId), SessionID: \(sessionID)")
            } else {
                print("No UserID or SessionID found.")
            }
        }
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { tokenId in
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
            apiCall(url: sixthUrl, method: "POST", parameters: parameters, view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("SIXTHAPI Response: \(jsonResponse)")
                    self.panNo = jsonResponse["PanNo"] as? String
                    self.regId = jsonResponse["RegId"] as? String
                    self.PANName = jsonResponse["PANName"] as? String
                    self.EmailId = jsonResponse["EmailId"] as? String
                    self.finalStatus = jsonResponse["FinalStatus"] as? String
                    
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
                                print("All TokenMobile entries deleted due to error code 999992")
                                
                                // Regenerate tokens
                                CoreDataHelper.generateToken(decodeByteArrayToString: self.decodeArray ?? "", USERID: userID, SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
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
                            DispatchQueue.main.async{
                                
                                self.isDerivative = (jsonResponse["IsDerivative"] as? String ?? "N").uppercased()
                                self.panNo = jsonResponse["PanNo"] as? String
                                self.regId = jsonResponse["RegId"] as? String
                                self.PANName = jsonResponse["PANName"] as? String
                               // self.updateUIFromSixthAPI(jsonResponse)
                                if self.finalStatus == "4"{
                                    DispatchQueue.main.async {
                                        self.pdfLbl.isHidden = false
                                        self.secondView.isHidden = false
                                    }
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
    
//    func updateUIFromSixthAPI(_ json: [String: Any]) {
//        
//        DispatchQueue.main.async {
//            
//            // MARK: - Name
//            self.nameLbl.text = json["PANName"] as? String ?? "-"
//            
//            // MARK: - Dates
//            self.onBordingDateLbl.text = json["OnBoardingStartedOn"] as? String ?? "-"
//            self.applicationDateLbl.text = json["ApplicationSubmittedOn"] as? String ?? "-"
//            self.waitingDateLbl.text = json["WaitingForVerificationOn"] as? String ?? "-"
//            self.approveDateLbl.text = json["ApplicationApprovedOn"] as? String ?? "-"
//            
//            // MARK: - Status Color Handling
//            self.resetAllStepColors()
//            
//            let finalStatus = "\(json["FinalStatus"] ?? "")"
//            
//            switch finalStatus {
//            case "3":
//                // Waiting
//                self.waitingView.backgroundColor = UIColor.systemYellow
//                self.approveView.backgroundColor = UIColor.gray
//                
//            case "4":
//                // Approved
//                self.approveView.backgroundColor = UIColor.systemYellow
//                self.pdfLbl.isHidden = false
//                self.secondView.isHidden = false
//                
//            default:
//                break
//            }
//        }
//    }
    
//    func resetAllStepColors() {
//        let defaultColor = UIColor.blue
//        onBordingView.backgroundColor = defaultColor
//        applicationView.backgroundColor = defaultColor
//        waitingView.backgroundColor = defaultColor
//        approveView.backgroundColor = defaultColor
//    }
}
