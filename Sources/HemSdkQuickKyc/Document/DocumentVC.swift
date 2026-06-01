//
//  DocumentVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import AVFoundation
import CoreLocation
//import TOCropViewController
import MobileCoreServices
import PDFKit
import UIKit
import CropViewController

class DocumentVC: UIViewController, UIImagePickerControllerDelegate,
                  UINavigationControllerDelegate, UIDocumentPickerDelegate,
                  @MainActor AVCapturePhotoCaptureDelegate, @MainActor CLLocationManagerDelegate,
                  @MainActor ImageProcessingDelegate, @MainActor didselectdocumentType, CropViewControllerDelegate,
                  @MainActor IncomeCVCDelegate, @MainActor doneapplicationprotocol, @MainActor WebViewDelegate
{
    //    func Ucccode(ucccode: String) {
    //        print("Received UCC Code: \(ucccode)")
    //        self.UpdateFinalStatus(ucccode: ucccode)
    //    }
    
    func webViewDidFinishLoad(ocrcount: Int, response: [String: Any]?) {
        print("numberCount:-\(ocrcount)")
        self.webcount = ocrcount
        guard let errorCode = response?["ErrorCode"] as? String else {
            print("Error: No ErrorCode found in response")
            return
        }
        switch errorCode {
        case "801005", "801006":
            if let errorMessage = response?["ErrorMessage"] as? String {
                showAlert(title: "Verification Failed", message: errorMessage)
            } else {
                showAlert(title: "Verification Failed", message: "Unknown error occurred.")
            }
        case "000000":
            DispatchQueue.main.async{ [self] in
                self.ViewDocumentDetails()
            }
        default:
            print("Unhandled ErrorCode: \(errorCode)")
        }
    }
    
    func doneapplication(ispdfgenerated: String) {
        self.navigationController?.popToRootViewController(animated: true)
        if ispdfgenerated == "1" {
            // Navigate to esignVC
            let storyboard = UIStoryboard(name: "Esign", bundle: .main)
            let vc =
            storyboard.instantiateViewController(identifier: "ApplicationStatusVC")
            as! ApplicationStatusVC
            vc.PanNo = PanNo
            vc.RegId = RegId
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            // Pop to root view controller
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    //    func Ucccode(ucccode: String) {
    //        print("Received UCC Code: \(ucccode)")
    //        self.UpdateFinalStatus(ucccode: ucccode)
    //    }
    
    func didProcessImage(identifier: String?, compressedImageData: Data) {
        guard let identifier = identifier else { return }
        switch identifier {
        case "Signature":
            print("Processed Signature Image: \(compressedImageData)")
            SignatureUpload(imageData: compressedImageData)
        case "IncomeProof":
            print("Processed Income Proof Image: \(compressedImageData)")
            DerivativeUpload(imageData: compressedImageData, password: "")
        case "BankProof":
            print("Processed Bank Proof Image: \(compressedImageData)")
            BankUpload(imageData: compressedImageData, password: "")
        case "PanCopy":
            print("Processed Pan Copy Image: \(compressedImageData)")
            PANUpload(imageData: compressedImageData, password: "")
        case "Demat":
            print("Demat Copy Image: \(compressedImageData)")
            dematUpload(imageData: compressedImageData, password: "")
        case "ClientPhoto":
            print("ClientPhoto Copy Image: \(compressedImageData)")
            CLIENTPHOTOUpload(imageData: compressedImageData)
        case "NOMINEE_1":
            print("Nominee1 Copy Image: \(compressedImageData)")
            NomineeUpload(imageData: compressedImageData)
        case "NOMINEE_2":
            print("Nominee2 Copy Image: \(compressedImageData)")
            NomineeUpload(imageData: compressedImageData)
        case "NOMINEE_3":
            print("Nominee3 Copy Image: \(compressedImageData)")
            NomineeUpload(imageData: compressedImageData)
        default:
            print("none of identifier match \(identifier)")
            break
        }
    }
    
    //    func didProcessImage(compressedImageData: Data) {
    //            // Handle the compressed image data received from ImageProcessingViewController
    //            SignatureUpload(imageData: compressedImageData)
    //        }
    var panDelete: String?
    var location: String?
    var viewDocumentTimer: Timer?
    var IPVStatus: String?
    weak var delegate: ReloadPageDelegate?
    var webcount : Int? = 1
    var panImageUrl: String?
    var signatureUrl: String?
    var clientPhotoUrl: String?
    var nominee1Url: String?
    var nominee2Url: String?
    var nominee3Url: String?
    var rejection: String?
    var rejection1: String?
    var rejection2: String?
    var rejection3: String?
    var prefixUrl = "https://signup.hemnxt.com:84/V4.0.0/api/"
    var bpverify: String?
    var diVerify: String?
    var DP_IMAGEID_Verify: Int?
    var BankImages_Verify: String?
    var DerivativeImages_Verify: String?
    var ipverify: String?
    var year: String?
    var nominee1ImagesVerify: String?
    var nominee2ImagesVerify: String?
    var nominee3ImagesVerify: String?
    var PANImage_Verify: String?
    var ClientPhotoImageID_Verify: String?
    var SignatureImage_Verify: String?
    var bankOcrCount = 0
    var incomeProofOcrCount = 0
    var dematOcrCount = 0
    var ocrCount: Int = 1
    var ocrpancount: Int = 1
    var lastPanCopyDocumentType: String?
    var lastDematDocumentType: String?
    var lastderivativeDocumentType: String?
    var lastbankDocumentType: String?
    var imageUrls: [String] = []
    var bpImageUrls: [String] = []
    var dematimageUrls: [String] = []
    var jsonResponse: [String: Any] = [:]
    var visibleSections: [String: Bool] = [:]
    var imageCache = NSCache<NSString, UIImage>()
    // Global variable to store the Base64 compressed image
    var compressedImageUTF8String: String?
    // ImageView to display the selected image
    var croppingImageView: UIImageView!
    var identifier: String?
    // Crop overlay view (rectangle that can be resized)
    var cropOverlayView: UIView!
    var PanNo: String?
    var RegId: String?
    var captureSession: AVCaptureSession!
    var photoOutput: AVCapturePhotoOutput!
    // Location variables
    var locationManager: CLLocationManager!
    var Latitude: String?
    var Longitude: String?
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var mobiledecodeArray: String?
    var dematDocumentType: String?
    var incomeproofDocumenttype: String?
    var incomeproofDocumenttypetext: String?
    var bankproofDocumentType: String?
    var bankproofDocumentTypetext: String?
    var panCopyDocumentType: String?
    //incomeProof
    var isIncomeProofVerified = false
    var isFromRejectionFlow: Bool = false
    var PANName: String?
    var EmailId: String?
    var decodeArray:String?
    var isPdfGenerated: String?
    var userId: String?
    var transactionId: String?
    var selectedClientImage: UIImage?
    
    
    @IBOutlet weak var pandeleteBtn: UIButton!
    @IBOutlet weak var signaturedeleteBtn: UIButton!
    @IBOutlet weak var clientphotodeleteBtn: UIButton!
    @IBOutlet weak var nominee1deleteBtn: UIButton!
    @IBOutlet weak var nominee2deleteBtn: UIButton!
    @IBOutlet weak var nominee3deleteBtn: UIButton!
    
    @IBOutlet weak var ButtonHolderView1: UIView!
    @IBOutlet weak var IncomeProof: UIStackView!
    @IBOutlet weak var IPLabel1: UILabel!
    @IBOutlet weak var IpView1: UIView!
    @IBOutlet weak var IPLabel2: UILabel!
    @IBOutlet weak var iplabel3: UILabel!
    @IBOutlet weak var yearBtn: UIButton!
    
    @IBOutlet weak var IPStackView1: UIStackView!
    @IBOutlet weak var IPStackView2: UIStackView!
    @IBOutlet weak var IPCollectionView: UICollectionView!
    @IBOutlet weak var IPDocumentView: UIView!
    @IBOutlet weak var incomeproofDocumentTypeLabel: UILabel!
    @IBOutlet weak var incomeProofDocumentTypeBtn: UIButton!
    
    @IBOutlet weak var incomeProofYesBtn: UIButton!
    @IBOutlet weak var incomeProofNoBtn: UIButton!
    @IBOutlet weak var incomeProofVerifyBtn: UIButton!
    @IBOutlet weak var incomeProofuploadBtn: UIButton!
    @IBOutlet weak var incomeProofCollectionView: UICollectionView!
    @IBOutlet weak var incomeproofStatusLabel: UILabel!
    @IBOutlet weak var incomeProofYearBtn: UIButton!
    
    @IBOutlet weak var incomeProofStatusBtn: UIButton!
    @IBOutlet weak var bankProofStatusBtn: UIButton!
    @IBOutlet weak var currentSignatureStatusBtn: UIButton!
    @IBOutlet weak var panCopyStatusBtn: UIButton!
    @IBOutlet weak var clientPhotoStatusBtn: UIButton!
    @IBOutlet weak var dematStatusBtn: UIButton!
    @IBOutlet weak var nominee1StatusBtn: UIButton!
    @IBOutlet weak var nominee2StatusBtn: UIButton!
    @IBOutlet weak var nominee3StatusBtn: UIButton!
    
    @IBOutlet weak var BankProof: UIStackView!
    @IBOutlet weak var ButtonHolderView2: UIView!
    @IBOutlet weak var BPLabel1: UILabel!
    @IBOutlet weak var BPView1: UIView!
    @IBOutlet weak var BPlabel2: UILabel!
    @IBOutlet weak var BPStackview1: UIStackView!
    @IBOutlet weak var BPStackview2: UIStackView!
    @IBOutlet weak var BpCollectionView: UICollectionView!
    @IBOutlet weak var BPDocumentView: UIView!
    @IBOutlet weak var BankProofDocumentTypelbl: UILabel!
    @IBOutlet weak var BankProofDocumentTypeBtn: UIButton!
    @IBOutlet weak var BankProofYesBtn: UIButton!
    @IBOutlet weak var BankProofNoBtn: UIButton!
    @IBOutlet weak var BPdescriptionLabel: UILabel!
    
    @IBOutlet weak var bankProofVerifyBtn: UIButton!
    
    @IBOutlet weak var currentSignatureBtn: UIStackView!
    @IBOutlet weak var ButtonHolderView3: UIView!
    @IBOutlet weak var CSLabel1: UILabel!
    @IBOutlet weak var CSStackView1: UIStackView!
    @IBOutlet weak var CurrentSignBtn: UIButton!
    @IBOutlet weak var CSDocumentView: UIView!
    @IBOutlet weak var signatureImageview: UIImageView!
    
    @IBOutlet weak var PANCopy: UIStackView!
    @IBOutlet weak var ButtonHolderView4: UIView!
    @IBOutlet weak var PCLabel1: UILabel!
    @IBOutlet weak var PCLabel2: UILabel!
    @IBOutlet weak var PCLabel3: UILabel!
    @IBOutlet weak var PCLabel4: UILabel!
    @IBOutlet weak var PCStackView1: UIStackView!
    
    //@IBOutlet weak var PCcollectionView: UICollectionView!
    @IBOutlet weak var panCopyImageView: UIImageView!
    @IBOutlet weak var pancopymessagelabel: UILabel!
    @IBOutlet weak var PCStackView: UIStackView!
    @IBOutlet weak var PANCopyBtn: UIButton!
    @IBOutlet weak var PCHolderView: UIView!
    @IBOutlet weak var PCYesBtn: UIButton!
    @IBOutlet weak var PCNoBtn: UIButton!
    
    @IBOutlet weak var ClientPhoto: UIStackView!
    @IBOutlet weak var ButtonHolderView5: UIView!
    @IBOutlet weak var CPLabel1: UILabel!
    @IBOutlet weak var CPLabel2: UILabel!
    @IBOutlet weak var CPLabel3: UILabel!
    @IBOutlet weak var CPStackView: UIStackView!
    @IBOutlet weak var CPHolderView1: UIView!
    @IBOutlet weak var CPImageView: UIImageView!
    @IBOutlet weak var CP_Long_Lat_Lbl: UILabel!
    @IBOutlet weak var CpHolderView2: UIView!
    @IBOutlet weak var CP_Location_label: UILabel!
    @IBOutlet weak var CP_CaptureImgBtn: UIButton!
    @IBOutlet weak var CP_IPVLinkBtn: UIButton!
    
    @IBOutlet weak var DematImage: UIStackView!
    @IBOutlet weak var ButtonHolderView6: UIView!
    @IBOutlet weak var DILabel1: UILabel!
    @IBOutlet weak var DILabel2: UILabel!
    @IBOutlet weak var DIStackView1: UIStackView!
    @IBOutlet weak var DIStackView2: UIStackView!
    @IBOutlet weak var DICollectionView: UICollectionView!
    @IBOutlet weak var DIDocumentView: UIView!
    @IBOutlet weak var dematNoBtn: UIButton!
    @IBOutlet weak var dematYesBtn: UIButton!
    @IBOutlet weak var DematImageVerifyBtn: UIButton!
    @IBOutlet weak var dematDescriptionLabel: UILabel!
    
    @IBOutlet weak var NomineeDetails1: UIStackView!
    @IBOutlet weak var ButtonHolderView7: UIView!
    @IBOutlet weak var NM1Label1: UILabel!
    @IBOutlet weak var NM1Label2: UILabel!
    @IBOutlet weak var NM1view1: UIView!
    @IBOutlet weak var NM1View2: UIView!
    @IBOutlet weak var NM1StackView: UIStackView!
    @IBOutlet weak var nominee_1nameLabel: UILabel!
    @IBOutlet weak var nominee_1DocumentTypelbl: UILabel!
    @IBOutlet weak var Nominee1bTn: UIButton!
    @IBOutlet weak var nominee1ImageView: UIImageView!
    @IBOutlet weak var NM1DocumentView: UIView!
    @IBOutlet weak var nominee1infolbl: UILabel!
    
    @IBOutlet weak var NomineeDetails2: UIStackView!
    @IBOutlet weak var ButtonHolderView8: UIView!
    @IBOutlet weak var NM2Label1: UILabel!
    @IBOutlet weak var NM2Label2: UILabel!
    @IBOutlet weak var NM2Label3: UILabel!
    @IBOutlet weak var nominee_2DocumentTypelbl: UILabel!
    @IBOutlet weak var NM2view1: UIView!
    @IBOutlet weak var NM2View2: UIView!
    @IBOutlet weak var NM2StackView: UIStackView!
    @IBOutlet weak var NM2DocumentView: UIView!
    @IBOutlet weak var nominee2infolbl: UILabel!
    @IBOutlet weak var Nominee2Btn: UIButton!
    @IBOutlet weak var nominee2ImageView: UIImageView!
    
    @IBOutlet weak var NomineeDetails3: UIStackView!
    @IBOutlet weak var ButtonHolderView9: UIView!
    @IBOutlet weak var NM3Label1: UILabel!
    @IBOutlet weak var NM3Label2: UILabel!
    @IBOutlet weak var NM3Label3: UILabel!
    @IBOutlet weak var NM3view1: UIView!
    @IBOutlet weak var NM3View2: UIView!
    @IBOutlet weak var NM3StackView: UIStackView!
    @IBOutlet weak var nominee_3DocumentTypelbl: UILabel!
    @IBOutlet weak var nominee3infolbl: UILabel!
    @IBOutlet weak var NM3DocumentView: UIView!
    @IBOutlet weak var Nominee3BTn: UIButton!
    @IBOutlet weak var nominee3ImageView: UIImageView!
    @IBOutlet weak var SubmitBtn: UIButton!
    @IBOutlet weak var HolderView: UIView!
    @IBOutlet weak var IPUploadBtn: UIButton!
    @IBOutlet weak var BANKPROOFBTN: UIButton!
    @IBOutlet weak var DematImgBtn: UIButton!
    @IBOutlet weak var termsnconditionBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var drawBtn: UIButton!
    
    @IBOutlet weak var signatureAttemptLabel: UILabel!
    @IBOutlet weak var incomeProofmsg: UILabel!
    @IBOutlet weak var bankMsg: UILabel!
    @IBOutlet weak var panMsg: UILabel!
    @IBOutlet weak var panCopyBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var holder1: UIView!
    
    
    @IBOutlet weak var stackView1: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        navigationItem.hidesBackButton = true
        NomineeDetails1.isHidden = true
        NomineeDetails2.isHidden = true
        NomineeDetails3.isHidden = true
        
        drawBtn.layer.cornerRadius = 10
        termsnconditionBtn.isSelected = true
        termsnconditionBtn.isHidden = true
        SubmitBtn.layer.cornerRadius = 10
        
        incomeProofCollectionView.register(
            UINib(nibName: "incomeCVC", bundle: Bundle.module),
            forCellWithReuseIdentifier: "incomeCVC")
        BpCollectionView.register(
            UINib(nibName: "incomeCVC", bundle: Bundle.module),
            forCellWithReuseIdentifier: "incomeCVC")
        DICollectionView.register(
            UINib(nibName: "incomeCVC", bundle: Bundle.module),
            forCellWithReuseIdentifier: "incomeCVC")
        self.ButtonHolderView1.layer.cornerRadius = 10
        self.ButtonHolderView2.layer.cornerRadius = 10
        self.ButtonHolderView3.layer.cornerRadius = 10
        self.ButtonHolderView4.layer.cornerRadius = 10
        self.ButtonHolderView5.layer.cornerRadius = 10
        self.ButtonHolderView6.layer.cornerRadius = 10
        self.ButtonHolderView7.layer.cornerRadius = 10
        self.ButtonHolderView7.layer.cornerRadius = 10
        self.ButtonHolderView8.layer.cornerRadius = 10
        self.ButtonHolderView9.layer.cornerRadius = 10
        self.SubmitBtn.layer.cornerRadius = 10
        self.HolderView.layer.cornerRadius = 10
        self.incomeProofuploadBtn.layer.cornerRadius = 10
        self.BANKPROOFBTN.layer.cornerRadius = 10
        self.CurrentSignBtn.layer.cornerRadius = 10
        self.CurrentSignBtn.layer.cornerRadius = 10
        self.CP_CaptureImgBtn.layer.cornerRadius = 10
        self.CP_IPVLinkBtn.layer.cornerRadius = 10
        self.DematImgBtn.layer.cornerRadius = 10
        self.Nominee1bTn.layer.cornerRadius = 10
        self.Nominee2Btn.layer.cornerRadius = 10
        self.Nominee3BTn.layer.cornerRadius = 10
        self.PANCopy.layer.cornerRadius = 10
        self.incomeProofVerifyBtn.layer.cornerRadius = 15
        self.CPHolderView1.layer.cornerRadius = 10
        self.CpHolderView2.layer.cornerRadius = 10
        self.CPImageView.layer.cornerRadius = 10
        self.DematImageVerifyBtn.layer.cornerRadius = 15
        //
        ButtonHolderView1.isHidden = false
        ButtonHolderView6.isHidden = false
        ButtonHolderView7.isHidden = false
        ButtonHolderView8.isHidden = false
        ButtonHolderView9.isHidden = false
        
        //        BPStackview2.isHidden = true
        //        BpCollectionView.isHidden = true
        //        BPDocumentView.isHidden = true
        year = ""
        //IncomeProofBtn
        //IPLabel1.isHidden = true
        //IpView1.isHidden = true
        //IPLabel2.isHidden = true
        iplabel3.isHidden = true
        yearBtn.isHidden = true
        //IPStackView1.isHidden = true
        IPStackView2.isHidden = true
        IPCollectionView.isHidden = true
        IPDocumentView.isHidden = true
        IncomeProof.isHidden = true
        //incomeProofVerifyBtn.isHidden = true
        //IPUploadBtn.isHidden = true
        //BankProof
        // BPLabel1.isHidden = true
        //BPView1.isHidden = true
        //BPlabel2.isHidden = true
        //BPStackview1.isHidden = true
        BPStackview2.isHidden = true
        BpCollectionView.isHidden = true
        BPDocumentView.isHidden = true
        bankProofVerifyBtn.layer.cornerRadius = 15
        //CurrentSignature
        //CSLabel1.isHidden = true
        //CSStackView1.isHidden = true
        // CsCollectionView.isHidden = true
        CSDocumentView.isHidden = true
        
        //PAN Copy
        //        PCLabel1.isHidden = true
        //        PCLabel2.isHidden = true
        //        PCLabel3.isHidden = true
        // PCLabel4.isHidden = true
        // PCStackView1.isHidden = true
        PCStackView.isHidden = true
        //PCcollectionView.isHidden = true
        PCHolderView.isHidden = true
        //PANCopyBtn.isHidden = true
        //Client Photo
        // CPLabel1.isHidden = true
        //CPLabel2.isHidden = true
        //CPLabel3.isHidden = true
        // CPStackView.isHidden = true
        CPHolderView1.isHidden = true
        CPImageView.isHidden = true
        CP_Long_Lat_Lbl.isHidden = true
        CpHolderView2.isHidden = true
        CP_Location_label.isHidden = true
        
        //DematImage
        //DILabel1.isHidden = true
        //DILabel2.isHidden = true
        //DIStackView1.isHidden = true
        DIStackView2.isHidden = true
        DICollectionView.isHidden = true
        DIDocumentView.isHidden = true
        
        //NomineeDetails1
        NM1Label1.isHidden = true
        NM1Label2.isHidden = true
        NM1view1.isHidden = true
        NM1View2.isHidden = true
        NM1StackView.isHidden = true
        //nominee1infolbl.isHidden = true
        NM1DocumentView.isHidden = true
        
        //NomineeDetails2
        NM2Label1.isHidden = true
        NM2Label2.isHidden = true
        NM2view1.isHidden = true
        NM2View2.isHidden = true
        NM2StackView.isHidden = true
        //NM2CollectionView.isHidden = true
        NM2DocumentView.isHidden = true
        
        //NomineeDetails3
        NM3Label1.isHidden = true
        NM3Label2.isHidden = true
        NM3view1.isHidden = true
        NM3View2.isHidden = true
        NM3StackView.isHidden = true
        //NM3CollectionView.isHidden = true
        NM3DocumentView.isHidden = true
        panMsg.isHidden = true
        incomeProofmsg.isHidden = true
        bankMsg.isHidden = true
        
        IpView1.layer.cornerRadius = 10
        incomeProofYearBtn.layer.cornerRadius = 10
        BPView1.layer.cornerRadius = 10
        NM2View2.layer.cornerRadius = 10
        NM3View2.layer.cornerRadius = 10
        
        updateClientPhotoUI(with: jsonResponse)
        
        if rejection == "Rejection" {
            rejection1 = "Rejection"
            rejection2 = "Rejection"
            rejection3 = "Rejection"
        } else {
            rejection1 = nil
            rejection2 = nil
            rejection3 = nil
        }
        CoreDataHelper.fetchUserId(entityName: "MobileUser") {
            [weak self] userId, sessionID, decodeByteArrayString in
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
        
        
        GetNomineeDocTypeMaster()
        ViewDocumentDetails()
        MediaDownload()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //        if CLLocationManager.authorizationStatus() == .notDetermined {
        //                 locationManager.requestWhenInUseAuthorization()
        //             } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        //                       CLLocationManager.authorizationStatus() == .authorizedAlways {
        //                 locationManager.startUpdatingLocation()
        //             }
        
        //hide done button
        
        if isFromRejectionFlow {
            termsnconditionBtn.isHidden = true
            SubmitBtn.isHidden = true
            doneBtn.isHidden = false
        } else {
            termsnconditionBtn.isHidden = true
            SubmitBtn.isHidden = false
            doneBtn.isHidden = true
        }
        
        //new sdk formate changes
        IncomeProof.layer.cornerRadius = 20
        IncomeProof.layer.borderWidth = 0.5
        IncomeProof.layer.borderColor = UIColor.appBorder.cgColor
        
        BankProof.layer.cornerRadius = 20
        BankProof.layer.borderWidth = 0.5
        BankProof.layer.borderColor = UIColor.appBorder.cgColor
        
        currentSignatureBtn.layer.cornerRadius = 20
        currentSignatureBtn.layer.borderWidth = 0.5
        currentSignatureBtn.layer.borderColor = UIColor.appBorder.cgColor
        
        ClientPhoto.layer.cornerRadius = 20
        ClientPhoto.layer.borderWidth = 0.5
        ClientPhoto.layer.borderColor = UIColor.appBorder.cgColor
        
        DematImage.layer.cornerRadius = 20
        DematImage.layer.borderWidth = 0.5
        DematImage.layer.borderColor = UIColor.appBorder.cgColor
        
        //BANKPROOFBTN.isHidden = true
        PANCopy.isHidden = true
        DematImage.isHidden = true
        
        BankProof.isLayoutMarginsRelativeArrangement = true
        BankProof.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        
        currentSignatureBtn.isLayoutMarginsRelativeArrangement = true
        currentSignatureBtn.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        
        ClientPhoto.isLayoutMarginsRelativeArrangement = true
        ClientPhoto.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        
        PANCopy.isLayoutMarginsRelativeArrangement = true
        PANCopy.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        
        IncomeProof.isLayoutMarginsRelativeArrangement = true
        IncomeProof.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        
        DematImage.isLayoutMarginsRelativeArrangement = true
        DematImage.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        
        IpView1.layer.cornerRadius = 10
        IpView1.layer.borderWidth = 0.5
        IpView1.layer.borderColor = UIColor.appBorder.cgColor
        
        BPView1.layer.cornerRadius = 10
        BPView1.layer.borderWidth = 0.5
        BPView1.layer.borderColor = UIColor.appBorder.cgColor
        
        PANCopy.layer.cornerRadius = 20
        PANCopy.layer.borderWidth = 0.5
        PANCopy.layer.borderColor = UIColor.appBorder.cgColor
        
        incomeProofuploadBtn.backgroundColor = .documentBackground
        
        incomeProofYesBtn.tintColor = .appPrimary
        incomeProofNoBtn.tintColor = .appPrimary
        incomeProofVerifyBtn.backgroundColor = .documentBackground
        
        panCopyBtn.tintColor = .appPrimary
        panCopyBtn.backgroundColor = .documentBackground
        
        BankProofYesBtn.tintColor = .appPrimary
        BankProofNoBtn.tintColor = .appPrimary
        BANKPROOFBTN.backgroundColor = .documentBackground
        bankProofVerifyBtn.backgroundColor = .documentBackground
        CurrentSignBtn.backgroundColor = .documentBackground
        drawBtn.backgroundColor = .documentBackground
        CP_CaptureImgBtn.backgroundColor = .documentBackground
        CP_IPVLinkBtn.backgroundColor = .documentBackground
        doneBtn.backgroundColor = .appPrimary
        SubmitBtn.backgroundColor = .appPrimary
        view.backgroundColor = .appBackground
        
        BankProofYesBtn.tintColor = .appPrimary
        BankProofNoBtn.tintColor = .appPrimary
        BANKPROOFBTN.backgroundColor = .documentBackground
        
        dematNoBtn.tintColor = .appPrimary
        dematYesBtn.tintColor = .appPrimary
        
        DematImgBtn.backgroundColor = .documentBackground
        DematImageVerifyBtn.backgroundColor = .documentBackground
        //DematImage.backgroundColor = .documentBackground
        //DematImage.isHidden = true
        
        //        IncomeProofBtn.isSelected = true
        //        IncomeProof(shouldShow: true)
        
        // IncomeProof(shouldShow: true)
        scrollView.backgroundColor = .appBackground
        holder1.backgroundColor = .appBackground
        view1.backgroundColor = .appBackground
        //stackView1.backgroundColor = UIColor.white
        IncomeProof.backgroundColor = UIColor.white
        BankProof.backgroundColor =  UIColor.white
        currentSignatureBtn.backgroundColor = UIColor.white
        ClientPhoto.backgroundColor = UIColor.white
        DematImage.backgroundColor = UIColor.white
        
        CurrentSignBtn.isHidden = true
        CP_IPVLinkBtn.isHidden = true
        CPLabel2.isHidden = true
        CPLabel3.isHidden = true
        
    }
    
    
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?
    ) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: imageData)
        // Use captured image here
    }
    
    @IBAction func incomeProofYearBtn(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(
            withIdentifier: "yearVC") as? yearVC
        {
            vc.modalPresentationStyle = .overCurrentContext
            vc.identifier = "IncomeYear"
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func homeBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func currentSignatureBtnTapped(_ sender: UIButton) {
        identifier = "Signature"
        showImageSourceSelection()
    }
    
    @IBAction func drawSignatureBtn(_ sender: UIButton) {
        let signatureVC = signatureVC()
        
        // Pass required parameters if needed
        signatureVC.PanNo = PanNo
        signatureVC.RegId = RegId
        signatureVC.fetchedUserId = fetchedUserId
        signatureVC.mobiledecodeArray = mobiledecodeArray
        signatureVC.fetchedSessionID = fetchedSessionID
        
        // Handle the saved signature + API response
        signatureVC.onSignatureSaved = { [weak self] image, response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                // ✅ Show the drawn signature in your UIImageView
                self.signatureImageview.image = image
                
                // ✅ Also call your existing UI update method with response
                if let response = response {
                    self.signatureupdateUI(with: response)
                }
            }
        }
        // Present the signature screen
        //present(signatureVC, animated: true)
        let nav = UINavigationController(rootViewController: signatureVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    
    @IBAction func incomeProofUploadBtn(_ sender: UIButton) {
        identifier = "IncomeProof"
        
        switch incomeproofDocumenttype {
        case "PDF":
            openPDFPicker()
        case "IMAGE":
            showImageSourceSelection()
        default:
            break
        }
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
        // UpdateFinalDoneStatus()
        if !validateLocalDocuments() {
            return // Alert will be shown by validateLocalDocuments
        }
        
        if panDelete == "PAN deleted" {
            showAlert(title: "Alert", message: "upload your PAN Image")
            return
        }
        
        // Then check server verification status
        self.ViewDocumentDetails()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            
            var unverifiedSections: [String] = []
            
            // Check visible sections dynamically
            for (section, isVisible) in visibleSections {
                guard isVisible else { continue }
                
                switch section {
                case "IncomeProof":
                    // First check local collection view
                    if imageUrls.isEmpty {
                        unverifiedSections.append("Income Proof (No images uploaded)")
                    } else if let status = jsonResponse["DerivativeImages_Verify"] as? String,
                              status != "1" && status != "2" {
                        unverifiedSections.append("Income Proof")
                    } else if let status = jsonResponse["DerivativeImages_Verify"] as? Int,
                              status != 1 && status != 2 {
                        unverifiedSections.append("Income Proof")
                    }
                    
                case "BankProof":
                    if bpImageUrls.isEmpty {
                        unverifiedSections.append("Bank Proof (No images uploaded)")
                    } else if let status = jsonResponse["BankImages_Verify"] as? String,
                              status != "1" && status != "2" {
                        unverifiedSections.append("Bank Proof")
                    } else if let status = jsonResponse["BankImages_Verify"] as? Int,
                              status != 1 && status != 2 {
                        unverifiedSections.append("Bank Proof")
                    }
                    
                case "DematImage":
                    if dematimageUrls.isEmpty {
                        unverifiedSections.append("Demat (No images uploaded)")
                    } else if let status = jsonResponse["DP_IMAGEID_Verify"] as? String,
                              status != "1" && status != "2" {
                        unverifiedSections.append("Demat")
                    } else if let status = jsonResponse["DP_IMAGEID_Verify"] as? Int,
                              status != 1 && status != 2 {
                        unverifiedSections.append("Demat")
                    }
                    
                default:
                    break
                }
            }
            
            // Check Signature (check local image)
            if signatureImageview.image == nil || signatureImageview.image == UIImage(systemName: "person.crop.circle.badge.xmark") {
                unverifiedSections.append("Signature (No image uploaded)")
            } else if let status = jsonResponse["SignatureImage_Verify"] as? String,
                      status != "1" && status != "2" {
                unverifiedSections.append("Signature")
            } else if let status = jsonResponse["SignatureImage_Verify"] as? Int,
                      status != 1 && status != 2 {
                unverifiedSections.append("Signature")
            }
            
            // Check PAN Copy (check local image)
            //               if panCopyImageView.image == nil || panCopyImageView.image == UIImage(systemName: "person.crop.circle.badge.xmark") {
            //                   unverifiedSections.append("PAN Copy (No image uploaded)")
            //               } else if let status = jsonResponse["PANImage_Verify"] as? String,
            //                         status != "1" && status != "2" {
            //                   unverifiedSections.append("PAN Copy")
            //               } else if let status = jsonResponse["PANImage_Verify"] as? Int,
            //                         status != 1 && status != 2 {
            //                   unverifiedSections.append("PAN Copy")
            //               }
            
            // Check Client Photo (check local image)
            if CPImageView.image == nil || CPImageView.image == UIImage(systemName: "person.crop.circle.badge.xmark") {
                unverifiedSections.append("Client Photo (No image uploaded)")
            } else if let status = jsonResponse["ClientPhotoImageID_Verify"] as? String,
                      status != "1" && status != "2" {
                unverifiedSections.append("Client Photo")
            } else if let status = jsonResponse["ClientPhotoImageID_Verify"] as? Int,
                      status != 1 && status != 2 {
                unverifiedSections.append("Client Photo")
            }
            
            // Check Nominees if they exist and have images
            //               if !NomineeDetails1.isHidden {
            //                   if nominee1ImageView.image == nil || nominee1ImageView.image == UIImage(systemName: "person.crop.circle") {
            //                       unverifiedSections.append("Nominee 1 (No image uploaded)")
            //                   } else if let status = jsonResponse["NOMINEE_1Images_Verify"] as? String,
            //                             status != "1" && status != "2" {
            //                       unverifiedSections.append("Nominee 1")
            //                   }
            //               }
            
            //               if !NomineeDetails2.isHidden {
            //                   if nominee2ImageView.image == nil || nominee2ImageView.image == UIImage(systemName: "person.crop.circle") {
            //                       unverifiedSections.append("Nominee 2 (No image uploaded)")
            //                   } else if let status = jsonResponse["NOMINEE_2Images_Verify"] as? String,
            //                             status != "1" && status != "2" {
            //                       unverifiedSections.append("Nominee 2")
            //                   }
            //               }
            
            //               if !NomineeDetails3.isHidden {
            //                   if nominee3ImageView.image == nil || nominee3ImageView.image == UIImage(systemName: "person.crop.circle") {
            //                       unverifiedSections.append("Nominee 3 (No image uploaded)")
            //                   } else if let status = jsonResponse["NOMINEE_3Images_Verify"] as? String,
            //                             status != "1" && status != "2" {
            //                       unverifiedSections.append("Nominee 3")
            //                   }
            //               }
            
            // Show alert if there are unverified sections
            DispatchQueue.main.async {
                if !unverifiedSections.isEmpty {
                    let message = "Please upload/verify the following sections before proceeding:\n"
                    + unverifiedSections.joined(separator: "\n")
                    self.showAlert(title: "Verification Required", message: message)
                } else {
                    // Proceed with final status update if all verifications are complete
                    self.UpdateFinalDoneStatus()
                }
            }
        }
    }
    
    // Add this helper method to validate local documents
    func validateLocalDocuments() -> Bool {
        var missingDocuments: [String] = []
        
        // Check Income Proof
        if IncomeProof.isHidden == false {
            if imageUrls.isEmpty {
                missingDocuments.append("Income Proof")
            }
        }
        
        // Check Bank Proof
        if BankProof.isHidden == false {
            if bpImageUrls.isEmpty {
                missingDocuments.append("Bank Proof")
            }
        }
        
        // Check Demat
        if DematImage.isHidden == false {
            if dematimageUrls.isEmpty {
                missingDocuments.append("Demat")
            }
        }
        
        // Check Signature
        if signatureImageview.image == nil || signatureImageview.image == UIImage(systemName: "person.crop.circle.badge.xmark") {
            missingDocuments.append("Signature")
        }
        
        // Check PAN Copy
        //           if panCopyImageView.image == nil || panCopyImageView.image == UIImage(systemName: "person.crop.circle.badge.xmark") {
        //               missingDocuments.append("PAN Copy")
        //           }
        
        // Check Client Photo
        if CPImageView.image == nil || CPImageView.image == UIImage(systemName: "person.crop.circle.badge.xmark") {
            missingDocuments.append("Client Photo")
        }
        
        // Check Nominees
        //           if !NomineeDetails1.isHidden {
        //               if nominee1ImageView.image == nil || nominee1ImageView.image == UIImage(systemName: "person.crop.circle") {
        //                   missingDocuments.append("Nominee 1")
        //               }
        //           }
        
        //           if !NomineeDetails2.isHidden {
        //               if nominee2ImageView.image == nil || nominee2ImageView.image == UIImage(systemName: "person.crop.circle") {
        //                   missingDocuments.append("Nominee 2")
        //               }
        //           }
        
        //           if !NomineeDetails3.isHidden {
        //               if nominee3ImageView.image == nil || nominee3ImageView.image == UIImage(systemName: "person.crop.circle") {
        //                   missingDocuments.append("Nominee 3")
        //               }
        //           }
        
        if !missingDocuments.isEmpty {
            let message = "Please upload the following documents:\n" + missingDocuments.joined(separator: "\n")
            showAlert(title: "Missing Documents", message: message)
            return false
        }
        
        return true
    }
    //        if panDelete == "PAN deleted" {
    //               showAlert(title: "Alert", message: "upload your PAN Image")
    //               return
    //           }
    //
    //           self.ViewDocumentDetails()
    //
    //           DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) { [weak self] in
    //               guard let self = self else { return }
    //
    //               var unverifiedSections: [String] = []
    //
    //               // Check visible sections dynamically
    //               for (section, isVisible) in visibleSections {
    //                   guard isVisible else { continue }
    //
    //                   switch section {
    //                   case "IncomeProof":
    //                       if let status = jsonResponse["DerivativeImages_Verify"] as? String,
    //                          status != "1" && status != "2" {
    //                           unverifiedSections.append("Income Proof")
    //                       } else if let status = jsonResponse["DerivativeImages_Verify"] as? Int,
    //                                 status != 1 && status != 2 {
    //                           unverifiedSections.append("Income Proof")
    //                       }
    //
    //                   case "BankProof":
    //                       if let status = jsonResponse["BankImages_Verify"] as? String,
    //                          status != "1" && status != "2" {
    //                           unverifiedSections.append("Bank Proof")
    //                       } else if let status = jsonResponse["BankImages_Verify"] as? Int,
    //                                 status != 1 && status != 2 {
    //                           unverifiedSections.append("Bank Proof")
    //                       }
    //
    //                   case "DematImage":
    //                       if let status = jsonResponse["DP_IMAGEID_Verify"] as? String,
    //                          status != "1" && status != "2" {
    //                           unverifiedSections.append("Demat")
    //                       } else if let status = jsonResponse["DP_IMAGEID_Verify"] as? Int,
    //                                 status != 1 && status != 2 {
    //                           unverifiedSections.append("Demat")
    //                       }
    //
    //                   default:
    //                       break
    //                   }
    //               }
    //
    //               // Explicitly check Signature, PAN Copy, and Client Photo
    //               let additionalChecks: [String: String] = [
    //                   "DerivativeImages_Verify": "IncomeProof",
    //                   "SignatureImage_Verify": "Signature",
    //                   "ClientPhotoImageID_Verify": "Client Photo",
    //                   "PANImage_Verify": "PAN Copy"
    //               ]
    //
    //               for (key, sectionName) in additionalChecks {
    //                   if let status = jsonResponse[key] as? String,
    //                      status != "1" && status != "2" {
    //                       unverifiedSections.append(sectionName)
    //                   } else if let status = jsonResponse[key] as? Int,
    //                             status != 1 && status != 2 {
    //                       unverifiedSections.append(sectionName)
    //                   }
    //               }
    //
    //               // Show alert if there are unverified sections
    //               DispatchQueue.main.async {
    //                   if !unverifiedSections.isEmpty {
    //                       let message = "Please upload/verify the following sections before proceeding:\n"
    //                                   + unverifiedSections.joined(separator: "\n")
    //                       self.showAlert(title: "Verification Required", message: message)
    //                   } else {
    //                       // Proceed with final status update if all verifications are complete
    //                       self.UpdateFinalDoneStatus()
    //                   }
    //               }
    //           }
    //    }
    //
    func UpdateFinalDoneStatus() {
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "M", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.UpdateFinalDoneStatus()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            
            let parameters: [String: Any] = [
                "PanNo": self.PanNo,
                "RegId": self.RegId,
                "DocumentName": "Documents"
            ]
            
            print("6th api params\(parameters)")
            let sixthUrl = "MultipartImageUpload/UpdateDocumentModificationStatus"
            
            // API call
            apiCall(url: sixthUrl, method: "POST", parameters: parameters, view: self.view,loaderText: "Kindly wait we are fetching your details...") { result in
                switch result {
                case .success(let jsonResponse):
                    print("UpdateDocumentModificationStatus: \(jsonResponse)")
                    
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            print("errorcode 000000 called")
                            DispatchQueue.main.async{
                                print("done")
                                self.UpdateFinalStatus()
                                //                                let storyboard = UIStoryboard(name: "Rejection", bundle: Bundle.module)
                                //                                let vc = storyboard.instantiateViewController(identifier: "RejectionVC") as! RejectionVC
                                //                                self.navigationController?.pushViewController(vc, animated: true)
                                let vc =
                                self.storyboard?.instantiateViewController(
                                    withIdentifier: "applicationDoneVC")
                                as! applicationDoneVC
                                vc.modalPresentationStyle = .overCurrentContext
                                vc.modalTransitionStyle = .crossDissolve
                                vc.delegate = self
                                self.present(vc, animated: true)
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
    
    @IBAction func submitBtn(_ sender: UIButton) {
        if panDelete == "PAN deleted" {
            showAlert(title: "Alert", message: "upload your PAN Image")
            return
        }
        self.ViewDocumentDetails()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            [weak self] in
            guard let self = self else { return }
            
            var unverifiedSections: [String] = []
            
            // Check visible sections dynamically
            for (section, isVisible) in visibleSections {
                guard isVisible else { continue }
                
                switch section {
                case "IncomeProof":
                    if let status = jsonResponse["DerivativeImages_Verify"]
                        as? String, status != "1" && status != "2"
                    {
                        unverifiedSections.append("Income Proof")
                    } else if let status = jsonResponse[
                        "DerivativeImages_Verify"] as? Int,
                              status != 1 && status != 2
                    {
                        unverifiedSections.append("Income Proof")
                    }
                    
                case "BankProof":
                    if let status = jsonResponse["BankImages_Verify"]
                        as? String, status != "1" && status != "2"
                    {
                        unverifiedSections.append("Bank Proof")
                    } else if let status = jsonResponse["BankImages_Verify"]
                                as? Int, status != 1 && status != 2
                    {
                        unverifiedSections.append("Bank Proof")
                    }
                    
                case "DematImage":
                    if let status = jsonResponse["DP_IMAGEID_Verify"]
                        as? String, status != "1" && status != "2"
                    {
                        unverifiedSections.append("Demat")
                    } else if let status = jsonResponse["DP_IMAGEID_Verify"]
                                as? Int, status != 1 && status != 2
                    {
                        unverifiedSections.append("Demat")
                    }
                    
                default:
                    break
                }
            }
            
            // Explicitly check Signature, PAN Copy, and Client Photo
            let additionalChecks: [String: String] = [
                "SignatureImage_Verify": "Signature",
                "ClientPhotoImageID_Verify": "Client Photo"
            ]
            
            for (key, sectionName) in additionalChecks {
                if let status = jsonResponse[key] as? String,
                   status != "1" && status != "2"
                {
                    unverifiedSections.append(sectionName)
                } else if let status = jsonResponse[key] as? Int,
                          status != 1 && status != 2
                {
                    unverifiedSections.append(sectionName)
                }
            }
            
            // Show alert if there are unverified sections
            DispatchQueue.main.async {
                if !unverifiedSections.isEmpty {
                    let message =
                    "Please verify the following sections before proceeding:\n"
                    + unverifiedSections.joined(separator: "\n")
                    self.showAlert(
                        title: "Verification Required", message: message)
                } else {
                    // Proceed to next step if all verifications are complete
                    self.UpdateFinalStatus()
                }
            }
        }
    }
    
    //        func navigateToNextStep() {
    //            if let rejectionValue = rejection, !rejectionValue.isEmpty {
    //                UpdateDocumentModificationStatus()
    //            } else {
    //                let vc =
    //                self.storyboard?.instantiateViewController(
    //                    withIdentifier: "uccVC")
    //                as! uccVC
    //                vc.modalPresentationStyle = .overCurrentContext
    //                vc.modalTransitionStyle = .crossDissolve
    //
    //                vc.delegate = self
    //
    //                self.present(vc, animated: true)
    //            }
    //        }
    
    @IBAction func incomeProofDocumentTypeBtn(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(
            withIdentifier: "incomeproofDocumentVC") as? incomeproofDocumentVC
        {
            vc.modalPresentationStyle = .overCurrentContext
            vc.identifier = "incomeProof"
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func incomeproofYesNoBtnPressed(_ sender: UIButton) {
        if sender == incomeProofYesBtn {
            incomeProofYesBtn.isSelected = true
            incomeProofNoBtn.isSelected = false
            incomeproofDocumenttype = "PDF"
            IPStackView2.isHidden = false
            
        } else if sender == incomeProofNoBtn {
            incomeProofYesBtn.isSelected = false
            incomeProofNoBtn.isSelected = true
            incomeproofDocumenttype = "IMAGE"
            IPStackView2.isHidden = false
        }
    }
    
    @IBAction func incomeProofVerifyBtn(_ sender: UIButton) {
        incomeProofOcrCount += 1
        DocumentVerify(
            DocumentName: "INCOMEPROOF",
            DocumentType: incomeproofDocumenttypetext ?? "",
            ocrCount: incomeProofOcrCount)
    }
    
    func didselectdocument(documenttype: String, identifier: String) {
        switch identifier {
        case "incomeProof":
            self.incomeproofDocumentTypeLabel.text = documenttype
            incomeproofDocumenttypetext = documenttype
            
            print("income", incomeproofDocumenttypetext!)
            switch documenttype {
            case "Six Month Bank Statement":
                //incomeproofStatusLabel.isHidden = true
                incomeProofVerifyBtn.isHidden = true
                iplabel3.isHidden = true
                yearBtn.isHidden = true
                incomeProofNoBtn.isEnabled = true
                incomeProofYesBtn.isSelected = false
                IPStackView2.isHidden = true
                incomeproofDocumenttype = "PDF"
                print("income", incomeproofDocumenttypetext!)
            case "Latest ITR":
                //incomeproofStatusLabel.isHidden = true
                incomeProofVerifyBtn.isHidden = true
                iplabel3.isHidden = false
                yearBtn.isHidden = false
                incomeProofYesBtn.isSelected = true
                incomeProofNoBtn.isEnabled = false
                IPStackView2.isHidden = false
                incomeproofDocumenttype = "PDF"
                print("income", incomeproofDocumenttypetext!)
            case "Form 16":
                //incomeproofStatusLabel.isHidden = true
                incomeProofVerifyBtn.isHidden = true
                iplabel3.isHidden = false
                yearBtn.isHidden = false
                incomeProofYesBtn.isSelected = true
                incomeProofNoBtn.isEnabled = false
                IPStackView2.isHidden = false
                incomeproofDocumenttype = "PDF"
                print("income", incomeproofDocumenttypetext!)
            case "Salary Slip":
                incomeProofVerifyBtn.isHidden = true
                iplabel3.isHidden = true
                yearBtn.isHidden = true
                IPStackView1.isHidden = false
                
            case "Demat Account Holding with Value":
                incomeProofVerifyBtn.isHidden = true
                iplabel3.isHidden = true
                yearBtn.isHidden = true
                IPStackView1.isHidden = false
            default:
                break
            }
        case "BankProof":
            self.BankProofDocumentTypelbl.text = documenttype
            bankproofDocumentTypetext = documenttype
            switch documenttype {
            case "Bank Passbook":
                BPStackview2.isHidden = false
                BankProofYesBtn.isSelected = false
                BankProofNoBtn.isSelected = true
                BankProofYesBtn.isEnabled = false
                bankproofDocumentType = "IMAGE"
                //                BpCollectionView.isHidden = false
                //                BPDocumentView.isHidden = false
                print("document")
            default:
                BPStackview2.isHidden = true
                bankproofDocumentType = ""
                BankProofNoBtn.isSelected = false
                BankProofYesBtn.isEnabled = true
                //                BpCollectionView.isHidden = false
                //                BPDocumentView.isHidden = false
                break
            }
        case "IncomeYear":
            self.incomeProofYearBtn.setTitle(documenttype, for: .normal)
            year = documenttype
            
            //bankproofDocumentTypetext = documenttype
        default:
            break
        }
    }
    
    @IBAction func bankProofMediaUploadButton(_ sender: UIButton) {
        identifier = "BankProof"
        
        //bankproofDocumentType
        switch bankproofDocumentType {
        case "PDF":
            openPDFPicker()
        case "IMAGE":
            showImageSourceSelection()
        default:
            break
        }
    }
    @IBAction func BankProofDocumentTypeBtn(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(
            withIdentifier: "DocumentTypeVC") as? DocumentTypeVC
        {
            vc.modalPresentationStyle = .overCurrentContext
            vc.identifier = "BankProof"
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    @IBAction func bankproofYesNoBtnPressed(_ sender: UIButton) {
        if sender == BankProofYesBtn {
            BankProofYesBtn.isSelected = true
            BankProofNoBtn.isSelected = false
            bankproofDocumentType = "PDF"
            BPStackview2.isHidden = false
            
        } else if sender == BankProofNoBtn {
            BankProofYesBtn.isSelected = false
            BankProofNoBtn.isSelected = true
            bankproofDocumentType = "IMAGE"
            BPStackview2.isHidden = false
            
        }
    }
    @IBAction func bankProofVerifyBtn(_ sender: UIButton) {
        bankOcrCount += 1
        DocumentVerify(
            DocumentName: "BANK", DocumentType: bankproofDocumentTypetext ?? "",
            ocrCount: bankOcrCount)
    }
    
    @IBAction func panCopyUploadBtn(_ sender: UIButton) {
        //           identifier = "PanCopy"
        //           showImageSourceSelection()
        identifier = "PanCopy"
        showImageSourceSelection()
        //bankproofDocumentType
        //        switch panCopyDocumentType {
        //        case "PDF":
        //            openPDFPicker()
        //        case "IMAGE":
        //            showImageSourceSelection()
        //        default:
        //            break
        //        }
    }
    @IBAction func pcYesNoBtn(_ sender: UIButton) {
        if sender == PCYesBtn {
            PCYesBtn.isSelected = true
            PCNoBtn.isSelected = false
            panCopyDocumentType = "PDF"
            if PANImage_Verify == nil {
                PCStackView.isHidden = false
            } else {
                PCStackView.isHidden = true
            }
            //            PCStackView.isHidden = false
            
        } else if sender == PCNoBtn {
            PCYesBtn.isSelected = false
            PCNoBtn.isSelected = true
            panCopyDocumentType = "IMAGE"
            //PCStackView.isHidden = false
            
        }
        
    }
    
    // Function to show the alert for camera and gallery selection
    func showImageSourceSelection() {
        let alertController = UIAlertController(
            title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {
            _ in
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) {
            _ in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        
        // For iPad compatibility
        if let popoverController = alertController.popoverPresentationController
        {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(
                x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0,
                height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Open Camera
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            showAlert(title: "Error", message: "Camera not available.")
        }
    }
    
    // Open Gallery
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        } else {
            showAlert(title: "Error", message: "Gallery not available.")
        }
    }
    
    // UIImagePickerController delegate function to handle selected image
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:
                                                Any]
    ) {
        //        if let pickedImage = info[.originalImage] as? UIImage {
        //            picker.dismiss(animated: true) {
        //                // Navigate to ImageProcessingViewController with selected image
        //                let storyboard = UIStoryboard(name: "Document", bundle: nil)
        //                if let imageProcessingVC = storyboard.instantiateViewController(withIdentifier: "ImageProcessingViewController") as? ImageProcessingViewController {
        //                    imageProcessingVC.selectedImage = pickedImage
        //                    imageProcessingVC.identifier = self.identifier
        //                    imageProcessingVC.delegate = self // Set the delegate to receive processed image
        //                    self.navigationController?.pushViewController(imageProcessingVC, animated: true)
        //                }
        //            }
        //        }
        
        if let capturedImage = info[.originalImage] as? UIImage {
            // ✅ Now send this capturedImage to your API
            ValidateIsPhotoDone(image: capturedImage)
        }
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true)
        
        showCrop(image: image)
    }
    
    func showCrop(image: UIImage) {
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = false
        vc.toolbarPosition = .top
        vc.doneButtonTitle = "Done"
        vc.cancelButtonTitle = "Back"
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func cropViewController(
        _ cropViewController: CropViewController,
        didFinishCancelled cancelled: Bool
    ) {
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(
        _ cropViewController: CropViewController, didCropToImage image: UIImage,
        withRect cropRect: CGRect, angle: Int
    ) {
        cropViewController.dismiss(animated: true)
        print("did Crop")
        
        // let imageView = UIImageView(frame: view.frame)
        guard let compressedData = image.jpegData(compressionQuality: 0.1)
        else { return }
        //imageView.contentMode = .scaleAspectFit
        //imageView.image = image
        //view.addSubview(imageView)
        didProcessImage(
            identifier: self.identifier, compressedImageData: compressedData)
    }
    // Handle the case when the user cancels image selection
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Helper function to show alert messages
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(
        _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
    ) {
        //        guard let location = locations.last else { return }
        //        let latitude = location.coordinate.latitude
        //        let longitude = location.coordinate.longitude
        //        print("Latitude: \(latitude), Longitude: \(longitude)")
        //
        //        CP_Long_Lat_Lbl.text = "Latitude: \(latitude), Longitude: \(longitude)"
        //        CP_Location_label.text = "Latitude: \(latitude), Longitude: \(longitude)"
        // Use location.coordinate.latitude and location.coordinate.longitude
        
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        print("Latitude: \(latitude), Longitude: \(longitude)")
        
        // Update labels
        CP_Long_Lat_Lbl.text = "Latitude: \(latitude), Longitude: \(longitude)"
        CP_Location_label.text =
        "Latitude: \(latitude), Longitude: \(longitude)"
        
        // Store location for later use
        self.Latitude = "\(latitude)"
        self.Longitude = "\(longitude)"
        
        // Stop location updates to conserve battery
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func capturePhotoButtonPressed(_ sender: UIButton) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        identifier = "ClientPhoto"
        DispatchQueue.main.async { [self] in
            
            
            self.GetUserLocation(Longitude: Longitude ?? "", Latitude: Latitude ?? "")
            self.SavePhotoAuditLogDetails()
        }
    }
    //            print("photoOutput is nil")
    //
    //            return
    //        }
    //
    //        let settings = AVCapturePhotoSettings()
    //        photoOutput.capturePhoto(with: settings, delegate: self)
    
    
    @IBAction func IPVlinkBtn(_ sender: UIButton) {
        InsertUpdateIPVAuditLog()
    }
    
    @IBAction func dematUploadBtn(_ sender: UIButton) {
        identifier = "Demat"
        
        //dematDocumentType
        switch dematDocumentType {
        case "PDF":
            openPDFPicker()
        case "IMAGE":
            showImageSourceSelection()
        default:
            break
        }
        
    }
    @IBAction func DematYesNoBtnPressed(_ sender: UIButton) {
        if sender == dematYesBtn {
            dematYesBtn.isSelected = true
            dematNoBtn.isSelected = false
            dematDocumentType = "PDF"
            DIStackView2.isHidden = false
            DematImageVerifyBtn.isHidden = true
            
        } else if sender == dematNoBtn {
            dematYesBtn.isSelected = false
            dematNoBtn.isSelected = true
            dematDocumentType = "IMAGE"
            DIStackView2.isHidden = false
            
        }
    }
    @IBAction func DematVerifyBtn(_ sender: UIButton) {
        dematOcrCount += 1
        DocumentVerify(
            DocumentName: "DP_IMAGE", DocumentType: "DP_IMAGE",
            ocrCount: dematOcrCount)
    }
    
    @IBAction func nominee1UploadBtn(_ sender: UIButton) {
        identifier = "NOMINEE_1"
        showImageSourceSelection()
    }
    @IBAction func nominee2UploadBtn(_ sender: UIButton) {
        identifier = "NOMINEE_2"
        showImageSourceSelection()
    }
    @IBAction func nominee3UploadBtn(_ sender: UIButton) {
        print("button tapped")
        identifier = "NOMINEE_3"
        showImageSourceSelection()
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Nominee", bundle: Bundle.module)
            let vc = storyboard.instantiateViewController(identifier: "NomineeVC") as! NomineeVC
            let savedPAN = UserDefaults.standard.string(forKey: "PanNo")
            let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.PanNo
            let regId = UserDefaults.standard.string(forKey: "RegId")
        let regIdFinal = (regId?.isEmpty == false) ? regId : self.RegId
                                           vc.panNo = finalPAN
                                           vc.RegId = regIdFinal
                                           self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func TermsAndConditionsBtn(_ sender: UIButton) {
        if sender.isSelected {
            // If the button is selected and user clicks, deselect it and show terms and conditions page
            sender.isSelected = false
            let storyboard = UIStoryboard(name: "terms", bundle: Bundle.module)
            if let vc = storyboard.instantiateViewController(
                withIdentifier: "termsVC") as? termsVC
            {
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                
                // Closure or delegate to set the button to selected when termsVC is dismissed
                vc.dismissHandler = { [weak self] in
                    self?.termsnconditionBtn.isSelected = true
                }
                
                present(vc, animated: true, completion: nil)
            }
        }
    }
    
}

extension DocumentVC {
    
    @IBAction func IncomeProofBtn(_ sender: UIButton) {
        //        if sender.isSelected {
        //            sender.isSelected = false
        //            IncomeProof(shouldShow: false)
        //        } else {
        //            sender.isSelected = true
        //            IncomeProof(shouldShow: true)
        //        }
        IncomeProof(shouldShow: true)
    }
    
    @IBAction func BankProofBtn(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            BankProof(shouldShow: false)
        } else {
            sender.isSelected = true
            BankProof(shouldShow: true)
        }
    }
    @IBAction func CurrentSignatureBtn(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            CurrentSignature(shouldShow: false)
        } else {
            sender.isSelected = true
            CurrentSignature(shouldShow: true)
        }
    }
    @IBAction func PAN_CopyBtn(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            PANCopy(shouldShow: false)
        } else {
            sender.isSelected = true
            PANCopy(shouldShow: true)
        }
    }
    @IBAction func ClientPhotoBtn(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            ClientPhoto(shouldShow: false)
        } else {
            sender.isSelected = true
            ClientPhoto(shouldShow: true)
        }
    }
    @IBAction func DematImageBtn(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            DematImage(shouldShow: false)
        } else {
            sender.isSelected = true
            DematImage(shouldShow: true)
        }
    }
    @IBAction func NomineeDetail1Btn(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            NomineeDetail1(shouldShow: false)
        } else {
            sender.isSelected = true
            NomineeDetail1(shouldShow: true)
        }
    }
    @IBAction func NomineeDetail2Btn(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            NomineeDetail2(shouldShow: false)
        } else {
            sender.isSelected = true
            NomineeDetail2(shouldShow: true)
        }
    }
    @IBAction func NomineeDetail3Btn(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            NomineeDetail3(shouldShow: false)
        } else {
            sender.isSelected = true
            NomineeDetail3(shouldShow: true)
        }
    }
    
}

extension DocumentVC {
    func ValidateToken() {
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
            [self] tokenId in
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "M", in: self.view
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
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(
                                    entityName: "TokenMobile")
                                print(
                                    "All TokenMobile entries deleted due to error code 999992"
                                )
                                
                                // Regenerate tokens
                                CoreDataHelper.generateToken(
                                    decodeByteArrayToString: self
                                        .mobiledecodeArray ?? "",
                                    USERID: self.fetchedUserId ?? "",
                                    SessionId: self.fetchedSessionID ?? "",
                                    entityName: "TokenMobile", deviceType: "M",
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
                    print(
                        "Login API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func GetNomineeDocTypeMaster() {
        
        let Url = "DropDownManagement/GetNomineeDocTypeMaster"
        
        apiCall(url: Url, method: "POST", parameters: [:], view: self.view) {
            result in
            switch result {
            case .success(let jsonResponse):
                print("GetNomineeDocTypeMaster Response: \(jsonResponse)")
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
    
    func ViewDocumentDetails() {
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
            [self] tokenId in
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "M", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.ViewDocumentDetails()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "PanNo": PanNo,
                "RegId": RegId,
                "UserId": fetchedUserId,
                "TokenId": tokenId,
            ]
            print(parameters)
            let Url = "Client/ViewDocumentDetails"
            
            apiCall(
                url: Url, method: "POST",
                parameters: parameters as [String: Any], view: self.view,
                loaderText: "Kindly wait we are verifying your document"
            ) { result in
                switch result {
                case .success(let jsonResponse):
                    print("ViewDocumentDetails Response: \(jsonResponse)")
                    self.jsonResponse = jsonResponse
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            DispatchQueue.main.async {
                                
                                print("api is running")
                                self.updateButtonImages(with: jsonResponse)
                                self.updateViewVisibility(with: jsonResponse)
                                
                                if let panDocumentSource = jsonResponse["PanDocumentSource"] as? String, panDocumentSource.uppercased() == "DIGILOCKER" {
                                    self.panMsg.text = "PAN card has been fetched successfully."
                                } else {
                                    self.panMsg.text = ""
                                }
                                
                                // Bank statement fetched
                                if let bankProofSource = jsonResponse["BankProofSource"] as? String, bankProofSource.uppercased() == "CAMS" {
                                    self.bankMsg.text = "Bank statement fetched successfully."
                                } else {
                                    self.bankMsg.text = ""
                                }
                                
                                // Income proof fetched (if available)
                                let incomeproofSource = jsonResponse["IncomeproofSource"] as? String
                                     if incomeproofSource == "Y" {
                                         self.incomeProofmsg.text = "Income proof fetched successfully."
                                         self.IncomeProof.isHidden = true
                                     } else {
                                         self.incomeProofmsg.text = ""
                                         // Don't hide - let user upload
                                     }
                                
                                if self.IPVStatus == "IPV" {
                                    if let clientPhotoID = jsonResponse["ClientPhotoImageID"] as? String, !clientPhotoID.isEmpty {
                                        self.updateClientPhotoUI(with: jsonResponse) // Update only Client Photo UI
                                        self.IPVStatus = nil // Reset IPVStatus after getting valid data
                                        self.stopPeriodicViewDocumentDetails() // Stop the timer
                                    }
                                } else {
                                    self.updateUI(with: jsonResponse) // Normal UI update
                                }
                            }
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(
                                    entityName: "TokenMobile")
                                print(
                                    "All TokenMobile entries deleted due to error code 999992"
                                )
                                
                                // Regenerate tokens
                                CoreDataHelper.generateToken(
                                    decodeByteArrayToString: self
                                        .mobiledecodeArray ?? "",
                                    USERID: self.fetchedUserId ?? "",
                                    SessionId: self.fetchedSessionID ?? "",
                                    entityName: "TokenMobile", deviceType: "M",
                                    in: self.view
                                ) { success in
                                    if success {
                                        // Retry SIXTHAPI after token regeneration
                                        self.ViewDocumentDetails()
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
    func updateViewVisibility(with jsonResponse: [String: Any]) {
        // Check for "BankImages_Verify" field
        if let isPennyDropDone = jsonResponse["IsPennyDropDone"] as? String,
           isPennyDropDone == "Y"
        {
            BankProof.isHidden = true
            visibleSections["BankProof"] = false
        } else {
            BankProof.isHidden = false
            visibleSections["BankProof"] = true
        }
        
        let incomeproofSource = jsonResponse["IncomeproofSource"] as? String
        
        if incomeproofSource == nil || incomeproofSource == "N" {
            // Show Income Proof section (user needs to upload)
            IncomeProof.isHidden = false
            visibleSections["IncomeProof"] = true
        } else if incomeproofSource == "Y" {
            // Hide Income Proof section (already fetched from CAMS/Digilocker)
            IncomeProof.isHidden = true
            visibleSections["IncomeProof"] = false
        } else {
            // Fallback: Check Segments for derivative trading requirement
            if let segments = jsonResponse["Segments"] as? String {
                let segmentsArray = segments.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                
                let derivativeSegments = ["EQUITY DERIVATIVE", "COMMODITY", "CURRENCY"]
                let hasDerivativeSegment = segmentsArray.contains { derivativeSegments.contains($0) }
                
                if hasDerivativeSegment {
                    IncomeProof.isHidden = false
                    visibleSections["IncomeProof"] = true
                } else {
                    IncomeProof.isHidden = true
                    visibleSections["IncomeProof"] = false
                }
            } else {
                IncomeProof.isHidden = true
                visibleSections["IncomeProof"] = false
            }
        }
        
        // Check for "DerivativeImages_Verify" field
//        if let segments = jsonResponse["Segments"] as? String {
//            let segmentsArray = segments.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
//            
//            let derivativeSegments = ["EQUITY DERIVATIVE", "COMMODITY", "CURRENCY"]
//            let hasDerivativeSegment = segmentsArray.contains { derivativeSegments.contains($0) }
//            
//            // Show DerivativeButton if any derivative-related segment is found
//            if hasDerivativeSegment {
//                IncomeProof.isHidden = false
//                visibleSections["IncomeProof"] = true
//            } else {
//                IncomeProof.isHidden = true
//                visibleSections["IncomeProof"] = false
//            }
//        } else {
//            // Default case: Hide if "Segments" key is missing
//            IncomeProof.isHidden = true
//            visibleSections["IncomeProof"] = false
//        }
        
        // DematImage.isHidden = true
        visibleSections["DematImage"] = false
        
        // Check for "DP_IMAGEID_Verify" field
        if let isDpAccountNew = jsonResponse["IsDpAccountNew"] as? String,
           isDpAccountNew == "Y"
        {
            DematImage.isHidden = true
            visibleSections["DematImage"] = false
        } else {
            DematImage.isHidden = false
            visibleSections["DematImage"] = true
        }
        
        // Check for "NOMINEE_1Images_Verify" field
        //        if let nominee1ImagesVerify = jsonResponse["Nom1NomineeOrGuardianName"]
        //            as? String, nominee1ImagesVerify.isEmpty
        //        {
        //            NomineeDetails1.isHidden = true
        //            visibleSections["NomineeDetails1"] = false
        //        } else {
        //            NomineeDetails1.isHidden = false
        //            visibleSections["NomineeDetails1"] = true
        //        }
        //
        //        // Check for "NOMINEE_2Images_Verify" field
        //        if let nominee2ImagesVerify = jsonResponse["Nom2NomineeOrGuardianName"]
        //            as? String, nominee2ImagesVerify.isEmpty
        //        {
        //            NomineeDetails2.isHidden = true
        //            visibleSections["NomineeDetails2"] = false
        //        } else {
        //            NomineeDetails2.isHidden = false
        //            visibleSections["NomineeDetails2"] = true
        //        }
        //
        //        // Check for "NOMINEE_3Images_Verify" field
        //        if let nominee3ImagesVerify = jsonResponse["Nom3NomineeOrGuardianName"]
        //            as? String, nominee3ImagesVerify.isEmpty
        //        {
        //            NomineeDetails3.isHidden = true
        //            visibleSections["NomineeDetails3"] = false
        //        } else {
        //            NomineeDetails3.isHidden = false
        //            visibleSections["NomineeDetails3"] = true
        //        }
    }
    
    func updateButtonImages(with jsonResponse: [String: Any]) {
        updateButtonImage(
            button: bankProofStatusBtn, statusKey: "BankImages_Verify",
            jsonResponse: jsonResponse)
        updateButtonImage(
            button: incomeProofStatusBtn, statusKey: "DerivativeImages_Verify",
            jsonResponse: jsonResponse)
        updateButtonImage(
            button: panCopyStatusBtn, statusKey: "PANImage_Verify",
            jsonResponse: jsonResponse)
        updateButtonImage(
            button: currentSignatureStatusBtn,
            statusKey: "SignatureImage_Verify", jsonResponse: jsonResponse)
        updateButtonImage(
            button: clientPhotoStatusBtn,
            statusKey: "ClientPhotoImageID_Verify", jsonResponse: jsonResponse)
        updateButtonImage(
            button: dematStatusBtn, statusKey: "DP_IMAGEID_Verify",
            jsonResponse: jsonResponse)
        
        updateButtonImage(
            button: nominee1StatusBtn, statusKey: "NOMINEE_1Images_Verify",
            jsonResponse: jsonResponse)
        updateButtonImage(
            button: nominee2StatusBtn, statusKey: "NOMINEE_2Images_Verify",
            jsonResponse: jsonResponse)
        updateButtonImage(
            button: nominee3StatusBtn, statusKey: "NOMINEE_3Images_Verify",
            jsonResponse: jsonResponse)
        
        handleDeleteButtonVisibility(with: jsonResponse)
    }
    func handleDeleteButtonVisibility(with jsonResponse: [String: Any]) {
        // Ensure rejection has a value
        guard let rejection = rejection else {
            // Hide all delete buttons if rejection is nil
            pandeleteBtn.isHidden = true
            signaturedeleteBtn.isHidden = true
            clientphotodeleteBtn.isHidden = true
            nominee1deleteBtn.isHidden = true
            nominee2deleteBtn.isHidden = true
            nominee3deleteBtn.isHidden = true
            return
        }
        
        // If rejection is not "Rejection", hide all delete buttons
        if rejection != "Rejection" {
            pandeleteBtn.isHidden = true
            signaturedeleteBtn.isHidden = true
            clientphotodeleteBtn.isHidden = true
            nominee1deleteBtn.isHidden = true
            nominee2deleteBtn.isHidden = true
            nominee3deleteBtn.isHidden = true
            return
        }
        
        // Check respective verify values from the JSON response
        if let panVerify = jsonResponse["PANImage_Verify"] as? String {
            pandeleteBtn.isHidden = panVerify != "2"
        }
        
        if let signatureVerify = jsonResponse["SignatureImage_Verify"]
            as? String
        {
            signaturedeleteBtn.isHidden = signatureVerify != "2"
        }
        
        if let clientPhotoVerify = jsonResponse["ClientPhotoImageID_Verify"]
            as? String
        {
            clientphotodeleteBtn.isHidden = clientPhotoVerify != "2"
        }
        
        if let nominee1Verify = jsonResponse["NOMINEE_1Images_Verify"]
            as? String
        {
            nominee1deleteBtn.isHidden = nominee1Verify != "2"
        }
        
        if let nominee2Verify = jsonResponse["NOMINEE_2Images_Verify"]
            as? String
        {
            nominee2deleteBtn.isHidden = nominee2Verify != "2"
        }
        
        if let nominee3Verify = jsonResponse["NOMINEE_3Images_Verify"]
            as? String
        {
            nominee3deleteBtn.isHidden = nominee3Verify != "2"
        }
    }
    
    private func updateButtonImage(
        button: UIButton, statusKey: String, jsonResponse: [String: Any]
    ) {
        // Check if the value exists as an Int, otherwise try as a String
        let statusValue: String
        if let intValue = jsonResponse[statusKey] as? Int {
            statusValue = String(intValue)
        } else if let stringValue = jsonResponse[statusKey] as? String {
            statusValue = stringValue
        } else {
            button.setImage(nil, for: .normal)  // No image if status is unavailable
            return
        }
        
        // Now, use the `statusValue` as a string for comparison
        switch statusValue {
        case "0":
            print("zero is the value")
            // button.isHidden = true // No image for pending
        case "1":
            button.setImage(
                UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            button.tintColor = .green  // Green for approved
        case "2":
            button.setImage(
                UIImage(systemName: "multiply.circle.fill"), for: .normal)
            button.tintColor = .red  // Red for rejected
        default:
            button.setImage(nil, for: .normal)  // Default to no image for unexpected values
        }
    }
    
    func ValidateIsPhotoDone(image: UIImage) {
        let parameters: [String: Any?] = [
            "TransactionID": transactionId,
            "URL": "",
            "ErrorMessage": "",
            "ErrorCode": "",
            "RegId": RegId,
            "PanNo": PanNo,
            "UserId": userId,
            "Flag": "Insert",
            "Latitude": Latitude,
            "Longitude": Longitude,
            "Location": location,
            "OCR_Count": "\(ocrCount ?? 1)",
        ]
        
        let apiUrl = "MultiPartImageUpload/ValidateIsPhotoDone"
        
        DispatchQueue.main.async {
            apiCall(url: apiUrl, method: "POST", parameters: parameters as [String: Any], view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("ValidateIsPhotoDone:-\(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        DispatchQueue.main.async {
                            switch errorCode {
                            case "000000":
                                self.ocrCount = 0
                                
                                self.navigationController?.popViewController(animated: true)
                                
                            case "801005":
                                if self.ocrCount ?? 0 < 2 {
                                    self.ocrCount += 1 // Increase count correctly
                                }
                                
                                self.navigationController?.popViewController(animated: true)
                                
                            default:
                                print("Unhandled error code: \(errorCode)")
                            }
                        }
                    }
                case .failure:
                    print("Unhandled error code")
                }
            }
        }
    }
    
    
    func updateClientPhotoUI(with response: [String: Any]) {
        let latitude = response["Latitude"] as? String ?? "Latitude"
        let longitude = response["Longitude"] as? String ?? "Longitude"
        
        guard let ClientPhotoImageID = response["ClientPhotoImageID"] as? String, !ClientPhotoImageID.isEmpty else {
            DispatchQueue.main.async {
                self.CPImageView.image = UIImage(systemName: "person.crop.circle.badge.xmark")
            }
            return
        }
        
        // Fetch token from CoreData before building the image URL
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { tokenId in
            guard let tokenId = tokenId else {
                print("No token available")
                DispatchQueue.main.async {
                    self.CPImageView.image = UIImage(systemName: "person.crop.circle.badge.xmark")
                }
                return
            }
            
            let userIdEncoded = self.fetchedUserId?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let imageUrlString = "\(self.prefixUrl)MultiPartImageUpload/MediaDownload?id=\(ClientPhotoImageID)&ImageType=ThumbNail&UserId=\(userIdEncoded)&TokenId=\(tokenId)"
            
            print("Full Client Photo URL: \(imageUrlString)")
            
            DispatchQueue.main.async {
                self.clientPhotoUrl = imageUrlString
                self.CP_Long_Lat_Lbl.text = "Your Lat/Long \n \(latitude), \(longitude)"
                self.GetUserLocation(Longitude: longitude, Latitude: latitude)
                self.CPImageView.restorationIdentifier = "CLIENTPHOTO"
                
                // Load image into CPImageView
                self.loadImage(from: imageUrlString, into: self.CPImageView, with: "CLIENTPHOTO")
                
                // Force UI refresh
                self.CPImageView.setNeedsDisplay()
                self.CPImageView.setNeedsLayout()
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                
                if let clientImageVerify = response["ClientPhotoImageID_Verify"] as? String {
                    self.ClientPhotoImageID_Verify = clientImageVerify
                    self.ClientPhoto(shouldShow: false)
                    print("Client Photo UI updated successfully.")
                }
                
                // Stop any periodic timer after updating
                self.stopPeriodicViewDocumentDetails()
            }
        }
    }
    
    func updateUI(with response: [String: Any]) {
        // Update Signature Image
        if let signatureImageID = response["SignatureImageID"] as? String,
           !signatureImageID.isEmpty
        {
            let userId =
            fetchedUserId?.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed) ?? ""
            let ImageUrlString =
            "\(self.prefixUrl)MultiPartImageUpload/MediaDownload?id=\(signatureImageID)&ImageType=ThumbNail&UserId=\(userId)&TokenId={tokenId}"
            self.signatureUrl = ImageUrlString
            // Print to debug the formed URL
            //print("Formed Signature URL: \(ImageUrlString)")
            self.signatureImageview.restorationIdentifier = "signatureview"
            loadImage(
                from: ImageUrlString, into: self.signatureImageview,
                with: "signatureview")
            if let SignatureImage_Verify = response["SignatureImage_Verify"]
                as? String
            {
                // If the value is 0, show the buttons, otherwise hide t
                self.SignatureImage_Verify = SignatureImage_Verify
                DispatchQueue.main.async {
                    if SignatureImage_Verify == "0" {
                        // Pending - show upload buttons
                        self.CSStackView1.isHidden = false
                        self.CSDocumentView.isHidden = true
                        //self.CurrentSignBtn.isHidden = false
                        self.drawBtn.isHidden = false
                    } else {
                        // Verified or Rejected - show the image
                        self.CSStackView1.isHidden = true
                        self.CSDocumentView.isHidden = false
                        //self.CurrentSignBtn.isHidden = true
                        self.drawBtn.isHidden = true
                    }
                }
            }
        } else {
            // No signature exists - show upload buttons
            DispatchQueue.main.async {
                self.CSStackView1.isHidden = false
                self.CSDocumentView.isHidden = true
                //self.CurrentSignBtn.isHidden = false
                self.drawBtn.isHidden = false
                self.signatureImageview.image = nil
            }
            
        }
        
        // Update NOMINEE_1ImageID Image
        if let NOMINEE_1ImageID = response["NOMINEE_1ImageID"] as? String,
           !NOMINEE_1ImageID.isEmpty
        {
            let userId =
            fetchedUserId?.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed) ?? ""
            let ImageUrlString =
            "\(self.prefixUrl)MultiPartImageUpload/MediaDownload?id=\(NOMINEE_1ImageID)&ImageType=ThumbNail&UserId=\(userId)&TokenId={tokenId}"
            self.nominee1Url = ImageUrlString
            // Print to debug the formed URL
            //print("Formed Signature URL: \(ImageUrlString)")
            self.nominee1ImageView.restorationIdentifier = "nominee1"
            loadImage(
                from: ImageUrlString, into: self.nominee1ImageView,
                with: "nominee1")
            self.nominee_1nameLabel.text =
            response["Nom1NomineeOrGuardianName"] as? String
            if let isMinor = response["Nom1NomineeMinor"] as? String {
                if isMinor == "Y" {
                    self.NM1Label1.text = "Guardian1Document"
                } else {
                    self.NM1Label1.text = "Nominee1Document"
                }
            }
            //NM1Label1
            
            
            self.nominee_1DocumentTypelbl.text =
            response["NOMINEE_1DocumentType"] as? String
            if let nominee1ImagesVerify = response["NOMINEE_1Images_Verify"]
                as? String
            {
                // If the value is 0, show the buttons, otherwise hide them
                self.nominee1ImagesVerify = nominee1ImagesVerify
                //                if nominee1ImagesVerify == "0"  {
                //                    NM1StackView.isHidden = false
                //                    nominee1infolbl.isHidden = false
                //                    Nominee1bTn.isHidden = false
                //                    NM1DocumentView.isHidden = false
                //                } else {
                //                    NM1StackView.isHidden = true
                //                   //nominee1infolbl.isHidden = true
                //                    Nominee1bTn.isHidden = true
                //                    NM1DocumentView.isHidden = true
                //
                //                }
            } else {
                // Handle the case where the key is not present or is not an integer
                print("NOMINEE_1Images_Verify key not found or invalid type")
            }
            
        } else {
            DispatchQueue.main.async {
                self.nominee_1nameLabel.text =
                response["Nom1NomineeOrGuardianName"] as? String
                self.nominee_1DocumentTypelbl.text =
                response["NOMINEE_1DocumentType"] as? String
                if let isMinor = response["Nom1NomineeMinor"] as? String {
                    if isMinor == "Y" {
                        self.NM1Label1.text = "Guardian1Document"
                    } else {
                        self.NM1Label1.text = "Nominee1Document"
                    }
                }
                //                self.nominee1ImageView.image = UIImage(systemName: "person.crop.circle.badge.xmark")
            }
        }
        
        //nominee2
        if let NOMINEE_2ImageID = response["NOMINEE_2ImageID"] as? String,
           !NOMINEE_2ImageID.isEmpty
        {
            let userId =
            fetchedUserId?.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed) ?? ""
            let ImageUrlString =
            "\(self.prefixUrl)MultiPartImageUpload/MediaDownload?id=\(NOMINEE_2ImageID)&ImageType=ThumbNail&UserId=\(userId)&TokenId={tokenId}"
            print("nominee 2 works")
            self.nominee2Url = ImageUrlString
            // Print to debug the formed URL
            //print("Formed Signature URL: \(ImageUrlString)")
            if let isMinor = response["Nom2NomineeMinor"] as? String {
                if isMinor == "Y" {
                    self.NM2Label1.text = "Guardian2Document"
                } else {
                    self.NM2Label1.text = "Nominee2Document"
                }
            }
            self.nominee2ImageView.restorationIdentifier = "nominee2"
            loadImage(
                from: ImageUrlString, into: self.nominee2ImageView,
                with: "nominee2")
            self.NM2Label3.text =
            response["Nom2NomineeOrGuardianName"] as? String
            self.nominee_2DocumentTypelbl.text =
            response["NOMINEE_2DocumentType"] as? String
            if let nominee2ImagesVerify = response["NOMINEE_2Images_Verify"]
                as? String
            {
                
                self.nominee2ImagesVerify = nominee2ImagesVerify
                
            } else {
                // Handle the case where the key is not present or is not an integer
                print("NOMINEE_2Image key not found or invalid type")
            }
            
        } else {
            DispatchQueue.main.async {
                self.NM2Label3.text = response["Nom2NomineeOrGuardianName"] as? String
                self.nominee_2DocumentTypelbl.text =
                response["NOMINEE_2DocumentType"] as? String
                
                //                self.nominee2ImageView.image = UIImage(systemName: "person.crop.circle.badge.xmark")
            }
        }
        
        //nominee3
        if let NOMINEE_3ImageID = response["NOMINEE_3ImageID"] as? String,
           !NOMINEE_3ImageID.isEmpty
        {
            let userId =
            fetchedUserId?.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed) ?? ""
            let ImageUrlString =
            "\(self.prefixUrl)MultiPartImageUpload/MediaDownload?id=\(NOMINEE_3ImageID)&ImageType=ThumbNail&UserId=\(userId)&TokenId={tokenId}"
            self.nominee3Url = ImageUrlString
            
            self.nominee3ImageView.restorationIdentifier = "nominee3"
            loadImage(
                from: ImageUrlString, into: self.nominee3ImageView,
                with: "nominee3")
            if let isMinor = response["Nom3NomineeMinor"] as? String {
                if isMinor == "Y" {
                    self.NM3Label1.text = "Guardian3Document"
                } else {
                    self.NM3Label1.text = "Nominee3Document"
                }
            }
            self.NM3Label3.text =
            response["Nom3NomineeOrGuardianName"] as? String
            self.nominee_3DocumentTypelbl.text =
            response["NOMINEE_3DocumentType"] as? String
            if let nominee3ImagesVerify = response["NOMINEE_3Images_Verify"]
                as? String
            {
                // If the value is 0, show the buttons, otherwise hide them
                self.nominee3ImagesVerify = nominee3ImagesVerify
                
            } else {
                // Handle the case where the key is not present or is not an integer
                print("NOMINEE_3Images_Verify key not found or invalid type")
            }
            
        } else {
            DispatchQueue.main.async {
                //                self.nominee3ImageView.image = UIImage(systemName: "person.crop.circle.badge.xmark")
                self.NM3Label3.text =
                response["Nom3NomineeOrGuardianName"] as? String
                self.nominee_3DocumentTypelbl.text =
                response["NOMINEE_3DocumentType"] as? String
                if let isMinor = response["Nom3NomineeMinor"] as? String {
                    if isMinor == "Y" {
                        self.NM3Label1.text = "Guardian3Document"
                    } else {
                        self.NM3Label1.text = "Nominee3Document"
                    }
                }
            }
        }
        
        // Update ClientPhotoImageID Image
        let Latitude = response["Latitude"] as? String
        let Longitude = response["Longitude"] as? String
        if let ClientPhotoImageID = response["ClientPhotoImageID"] as? String,
           !ClientPhotoImageID.isEmpty
        {
            let userId =
            fetchedUserId?.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed) ?? ""
            let ImageUrlString =
            "\(self.prefixUrl)MultiPartImageUpload/MediaDownload?id=\(ClientPhotoImageID)&ImageType=ThumbNail&UserId=\(userId)&TokenId={tokenId}"
            self.clientPhotoUrl = ImageUrlString
            
            self.CPImageView.restorationIdentifier = "CLIENTPHOTO"
            loadImage(
                from: ImageUrlString, into: self.CPImageView,
                with: "CLIENTPHOTO")
            self.CP_Long_Lat_Lbl.text =
            "Your Lat/Long \n \(Latitude ?? "Longitude"),\(Longitude ?? "Longitude")"
            self.GetUserLocation(
                Longitude: Longitude ?? "", Latitude: Latitude ?? "")
            if let clientimage = response["ClientPhotoImageID_Verify"]
                as? String
            {
                self.ClientPhotoImageID_Verify = clientimage
                self.ClientPhoto(shouldShow: false)
            } else {
                // Handle the case where the key is not present or is not an integer
                print("NOMINEE_1Images_Verify key not found or invalid type")
            }
        } else {
            DispatchQueue.main.async {
                self.CPImageView.image = UIImage(
                    systemName: "person.crop.circle.badge.xmark")
            }
        }
        
        // Update Pan Image
        if let PANImageID = response["PANImageID"] as? String,
           !PANImageID.isEmpty
        {
            let userId =
            fetchedUserId?.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed) ?? ""
            let ImageUrlString =
            "\(self.prefixUrl)MultiPartImageUpload/MediaDownload?id=\(PANImageID)&ImageType=ThumbNail&UserId=\(userId)&TokenId={tokenId}"
            self.panImageUrl = ImageUrlString
            self.panCopyImageView.restorationIdentifier = "PANCOPY"
            loadImage(
                from: ImageUrlString, into: self.panCopyImageView,
                with: "PANCOPY")
            if let PANImage_Verify = response["PANImage_Verify"] as? String {
                // If the value is 0, show the buttons,
                self.PANImage_Verify = PANImage_Verify
            }
        } else {
            DispatchQueue.main.async {
                self.panCopyImageView.image = UIImage(
                    systemName: "person.crop.circle.badge.xmark")
            }
        }
        
        let incomeproofSource = response["IncomeproofSource"] as? String
            
            if incomeproofSource == nil || incomeproofSource == "N" {
                // Show Income Proof upload section
                DispatchQueue.main.async {
                    self.IncomeProof.isHidden = false
                    // Reset UI to allow upload
                    self.incomeProofuploadBtn.isHidden = false
                    self.incomeProofDocumentTypeBtn.isEnabled = true
                    self.incomeProofYearBtn.isEnabled = true
                    self.incomeProofNoBtn.isEnabled = true
                    self.incomeProofYesBtn.isEnabled = true
                    
                    // Clear any success message
                    self.incomeProofmsg.text = ""
                }
            } else if incomeproofSource == "Y" {
                // Income proof already fetched
                DispatchQueue.main.async {
                    self.IncomeProof.isHidden = true
                    self.incomeProofmsg.text = "Income proof fetched successfully."
                }
            }
        
        // Update Collection View Images
        if let derivativeImageIDsString = response["DerivativeImageID"]
            as? String, !derivativeImageIDsString.isEmpty
        {
            let userId =
            fetchedUserId?.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            // Split the IDs and form URLs for each
            let derivativeImageIDs = derivativeImageIDsString.split(
                separator: ","
            ).map { $0.trimmingCharacters(in: .whitespaces) }
            
            // Clear previous images
            imageUrls.removeAll()
            
            // Generate URLs and update the imageUrls array
            for imageID in derivativeImageIDs {
                let imageUrlString =
                "\(self.prefixUrl)MultiPartImageUpload/MediaDownload?id=\(imageID)&ImageType=ThumbNail&UserId=\(userId)&TokenId={tokenId}"
                imageUrls.append(imageUrlString)
            }
            //documentType incomeproofDocumentTypeLabel
            let documentType = response["DerivativeDocumentType"] as? String
            incomeproofDocumenttypetext = documentType
            incomeproofDocumentTypeLabel.text = documentType
            // Handle DerivativeType selection for PDF or IMAGE
            if let derivativeType = response["DerivativeType"] as? String {
                incomeproofDocumenttype = derivativeType
                if derivativeType == "PDF" {
                    incomeProofYesBtn.isSelected = true
                    incomeProofNoBtn.isSelected = false
                } else if derivativeType == "IMAGE" {
                    incomeProofYesBtn.isSelected = false
                    incomeProofNoBtn.isSelected = true
                }
            }
            
            if let assesmentYear = response["AssesmentYear"] as? String,
               !assesmentYear.isEmpty {
                self.incomeProofYearBtn.setTitle(assesmentYear, for: .normal)
                self.year = assesmentYear
            }
            
            if let DerivativeImages_Verify = response["DerivativeImages_Verify"]
                as? String
            {
                self.DerivativeImages_Verify = DerivativeImages_Verify
                // If the value is 0, show the buttons, otherwise hide them
                if DerivativeImages_Verify == "0" {
                    incomeProofVerifyBtn.isHidden = false
                } else {
                    IPStackView2.isHidden = true
                    incomeProofuploadBtn.isHidden = true
                    incomeproofStatusLabel.isHidden = true
                    incomeProofVerifyBtn.isHidden = true
                    self.incomeProofDocumentTypeBtn.isEnabled = false
                    self.incomeProofYearBtn.isEnabled = false
                    incomeProofVerifyBtn.isHidden = true
                    
                    if incomeproofDocumenttype == "PDF" {
                        incomeProofNoBtn.isEnabled = false
                    } else if incomeproofDocumenttype == "IMAGE" {
                        incomeProofYesBtn.isEnabled = false
                    }
                }
            } else {
                // Handle the case where the key is not present or is not an integer
                print("NOMINEE_1Images_Verify key not found or invalid type")
            }
            
            DispatchQueue.main.async {
                self.incomeProofCollectionView.reloadData()
            }
        }
        // Update Bank Proof Collection View Images
        if let bankImageIDsString = response["BankImageID"] as? String,
           !bankImageIDsString.isEmpty
        {
            let userId =
            fetchedUserId?.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            // Split the IDs and form URLs for each
            let bankImageIDs = bankImageIDsString.split(separator: ",").map {
                $0.trimmingCharacters(in: .whitespaces)
            }
            
            // Clear previous images
            bpImageUrls.removeAll()
            
            // Generate URLs and update the bpImageUrls array
            for imageID in bankImageIDs {
                let imageUrlString =
                "\(self.prefixUrl)MultiPartImageUpload/MediaDownload?id=\(imageID)&ImageType=ThumbNail&UserId=\(userId)&TokenId={tokenId}"
                bpImageUrls.append(imageUrlString)
            }
            let documentType = response["BankDocumentType"] as? String
            self.BankProofDocumentTypelbl.text = documentType
            self.bankproofDocumentTypetext = documentType
            
            if let derivativeType = response["BankType"] as? String {
                bankproofDocumentType = derivativeType
                if derivativeType == "PDF" {
                    BankProofYesBtn.isSelected = true
                    BankProofNoBtn.isSelected = false
                } else if derivativeType == "IMAGE" {
                    BankProofYesBtn.isSelected = false
                    BankProofNoBtn.isSelected = true
                }
            }
            if let BankImages_Verify = response["BankImages_Verify"] as? String
            {
                // If the value is 0, show the buttons, otherwise hide them
                self.BankImages_Verify = BankImages_Verify
                if BankImages_Verify == "0" {
                    bankProofVerifyBtn.isHidden = false
                } else {
                    self.BankProofDocumentTypeBtn.isEnabled = false
                    BPStackview2.isHidden = true
                    BPdescriptionLabel.isHidden = true
                    BANKPROOFBTN.isHidden = true
                    bankProofVerifyBtn.isHidden = true
                    if bankproofDocumentType == "PDF" {
                        BankProofNoBtn.isEnabled = false
                        //
                    } else if bankproofDocumentType == "IMAGE" {
                        BankProofYesBtn.isEnabled = false
                    }
                }
            } else {
                // Handle the case where the key is not present or is not an integer
                print("NOMINEE_1Images_Verify key not found or invalid type")
            }
            // Reload the collection view to show updated images
            DispatchQueue.main.async {
                self.BpCollectionView.reloadData()
            }
        }
        
        // Update demat Proof Collection View Images
        if let dematImageIDsString = response["DP_IMAGEID"] as? String,
           !dematImageIDsString.isEmpty
        {
            let userId = fetchedUserId?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            // Split the IDs and form URLs for each
            let dematImageIDs = dematImageIDsString.split(separator: ",").map {
                $0.trimmingCharacters(in: .whitespaces)
            }
            
            // Clear previous images
            dematimageUrls.removeAll()
            
            // Generate URLs and update the bpImageUrls array
            for imageID in dematImageIDs {
                let imageUrlString = "\(self.prefixUrl)MultiPartImageUpload/MediaDownload?id=\(imageID)&ImageType=ThumbNail&UserId=\(userId)&TokenId={tokenId}"
                dematimageUrls.append(imageUrlString)
            }
            
            if let DP_IMAGEType = response["DP_IMAGEType"] as? String {
                dematDocumentType = DP_IMAGEType
                if DP_IMAGEType == "PDF" {
                    dematYesBtn.isSelected = true
                    dematNoBtn.isSelected = false
                } else if DP_IMAGEType == "IMAGE" {
                    dematYesBtn.isSelected = false
                    dematNoBtn.isSelected = true
                }
            }
            
            if let DPVerify = response["DP_IMAGEID_Verify"] as? Int {
                self.DP_IMAGEID_Verify = DPVerify
                print("DP_IMAGEID_Verify: \(DP_IMAGEID_Verify)")
                
                if DP_IMAGEID_Verify == 0 {
                    // Pending verification - show verify button
                    DispatchQueue.main.async {
                        self.DematImageVerifyBtn.isHidden = false
                        self.DIStackView2.isHidden = false
                        self.dematDescriptionLabel.isHidden = false
                        self.DematImgBtn.isHidden = false
                        // Keep collection view visible
                        self.DICollectionView.isHidden = false
                        self.DIDocumentView.isHidden = false
                    }
                } else {
                    // Already verified (1 or 2) - hide verify button but keep collection view visible
                    DispatchQueue.main.async {
                        self.DematImageVerifyBtn.isHidden = true
                        self.DIStackView2.isHidden = true
                        self.dematDescriptionLabel.isHidden = true
                        self.DematImgBtn.isHidden = true
                        
                        // ✅ IMPORTANT: Keep collection view visible to show uploaded images
                        self.DICollectionView.isHidden = false
                        self.DIDocumentView.isHidden = false
                        
                        if self.dematDocumentType == "PDF" {
                            self.dematNoBtn.isEnabled = false
                        } else if self.dematDocumentType == "IMAGE" {
                            self.dematYesBtn.isEnabled = false
                        }
                    }
                }
            }
            
            // Reload the collection view to show updated images
            DispatchQueue.main.async {
                self.DICollectionView.reloadData()
            }
        }
        
    }
    
    func MediaDownload() {
        
        let Url = "MultiPartImageUpload/MediaDownload"
        
        apiCall(url: Url, method: "POST", parameters: [:], view: self.view) {
            result in
            switch result {
            case .success(let jsonResponse):
                print("MediaDownload Response: \(jsonResponse)")
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
    
    func SignatureUpload(imageData: Data) {
        guard ocrCount <= 3 else {
            print("OCR attempts exceeded. No further attempts allowed.")
            return
        }
        let imageFileName = "image.jpg"
        let imageMimeType = "image/jpeg"
        
        let parameters: [String: Any?] = [
            "PanNo": PanNo,
            "RegId": RegId,
            "UserId": fetchedUserId,
            "MOBRequestID": "",
            "Type": "IMAGE",
            "Password": "",
            "OCRCount": "\(ocrCount)",
            "NewValue": "",
            "BrowserName": "",
            "BrowserVersion": "",
            "OS": "",
            "OSVersion": "",
            "IPAddress": "",
            "DeviceType": "",
        ]
        
        let url = "\(self.prefixUrl)MultiPartImageUpload/SignatureUpload"
        print("signature url:", url)
        uploadDocument(
            apiEndpoint: url, parameters: parameters, fileData: imageData,
            fileName: imageFileName, mimeType: imageMimeType,
            loaderView: self.view,
            loaderText: "Kindly wait we are verifying your Signature..."
        ) { result in
            switch result {
            case .success(let jsonResponse):
                print("SignatureUpload Response: \(jsonResponse)")
                let ErrorMessage = jsonResponse["ErrorMessage"] as? String
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "000000":
                        DispatchQueue.main.async {
                            print("Signature upload successful")
                            let signature_verify =
                            jsonResponse["DocumentImages_Verify"] as? String
                            print(
                                "signature_verify\(signature_verify ?? "not found may be its integer")"
                            )
                            self.SignatureImage_Verify = signature_verify
                            //                            self.updateButtonImage(button: self.currentSignatureStatusBtn, statusKey: "DocumentImages_Verify", jsonResponse: jsonResponse)
                            self.signatureupdateUI(with: jsonResponse)
                            self.ocrCount = 1
                            
                        }
                    case "801005":
                        // Increment OCR count and retry if less than 3
                        DispatchQueue.main.async { [self] in
                            if self.ocrCount < 3 {
                                self.ocrCount += 1
                                self.signatureAttemptLabel.text =
                                jsonResponse["ErrorMessage"] as? String
                                ?? "1 attempt failed."
                                print(
                                    "Retrying with OCRCount: \(self.ocrCount)")
                                //self.SignatureUpload(imageData: imageData) // Retry API call
                            } else {
                                print("Maximum OCR attempts reached.")
                                signatureupdateUI(with: jsonResponse)
                            }
                        }
                    case "801006":
                        DispatchQueue.main.async { [self] in
                            let errorMessage = jsonResponse["ErrorMessage"] as? String
                            ?? "Signature verification failed. Please try again."
                            if self.ocrCount < 3 {
                                self.ocrCount += 1
                                self.signatureAttemptLabel.text =
                                jsonResponse["ErrorMessage"] as? String
                                ?? "1 attempt failed."
                                print(
                                    "Retrying with OCRCount: \(self.ocrCount)")
                                
                                self.showAlert(title: "Invalid Signature", message: errorMessage)
                                //self.SignatureUpload(imageData: imageData) // Retry API call
                            } else {
                                print("Maximum OCR attempts reached.")
                                signatureupdateUI(with: jsonResponse)
                            }
                        }
                    case "999992":
                        DispatchQueue.main.async {
                            self.regenerate(imageData: imageData)
                        }
                    default:
                        print("Unhandled error code: \(errorCode)")
                        // Handle error
                    }
                }
            case .failure(let error):
                print("Signature upload failed: \(error.localizedDescription)")
                // Handle failure (e.g., show an alert)
            }
        }
    }
    func regenerate(imageData: Data) {
        CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
        print("All TokenMobile entries deleted due to error code 999992")
        
        // Regenerate tokens
        CoreDataHelper.generateToken(
            decodeByteArrayToString: self.mobiledecodeArray ?? "",
            USERID: self.fetchedUserId ?? "",
            SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile",
            deviceType: "M", in: self.view
        ) { success in
            if success {
                // Retry SIXTHAPI after token regeneration
                self.SignatureUpload(imageData: imageData)
            } else {
                print("Token generation failed.")
            }
        }
    }
    
    func signatureupdateUI(with response: [String: Any]) {
        DispatchQueue.main.async {
            CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
                guard let tokenId = tokenId else {
                    // Handle no token case → regenerate and retry
                    CoreDataHelper.generateToken(
                        decodeByteArrayToString: self.mobiledecodeArray ?? "",
                        USERID: self.fetchedUserId ?? "",
                        SessionId: self.fetchedSessionID ?? "",
                        entityName: "TokenMobile",
                        deviceType: "M",
                        in: self.view
                    ) { success in
                        if success {
                            self.signatureupdateUI(with: self.jsonResponse)
                        } else {
                            print("Token generation failed.")
                        }
                    }
                    return
                }
                
                if let signatureImageID = response["RequestID"] as? Int {
                    let userId = fetchedUserId?.addingPercentEncoding(
                        withAllowedCharacters: .urlQueryAllowed
                    ) ?? ""
                    
                    // ✅ Use IMAGE instead of ThumbNail for actual signature
                    let imageUrlString =
                    "\(self.prefixUrl)MultiPartImageUpload/MediaDownload?id=\(signatureImageID)&ImageType=IMAGE&UserId=\(userId)&TokenId=\(tokenId)"
                    
                    self.signatureUrl = imageUrlString
                    print("Formed signature URL: \(imageUrlString)")
                    
                    self.signatureImageview.restorationIdentifier = "signatureview"
                    
                    loadImage(
                        from: imageUrlString,
                        into: self.signatureImageview,
                        with: "signatureview"
                    )
                    
                    DispatchQueue.main.async {
                        self.updateButtonImage(
                            button: self.currentSignatureStatusBtn,
                            statusKey: "DocumentImages_Verify",
                            jsonResponse: response
                        )
                    }
                    
                    // Hide/Show UI
                    self.drawBtn.isHidden = true
                    //self.CurrentSignBtn.isHidden = true
                    self.CSDocumentView.isHidden = false
                    
                } else {
                    self.signatureImageview.image = UIImage(
                        systemName: "person.crop.circle.badge.xmark"
                    )
                }
            }
        }
    }
    
    func DerivativeUpload(imageData: Data, password: String?) {
        
        var fileName: String = ""
        var mimeType: String = ""
        
        switch incomeproofDocumenttype {
        case "PDF":
            if incomeproofDocumenttype != lastderivativeDocumentType {
                incomeProofOcrCount = 1  // Reset to 1 for PDFs
            }
            lastderivativeDocumentType = incomeproofDocumenttype
            fileName = "document.pdf"
            mimeType = "application/pdf"
            
            if incomeproofDocumenttypetext == "Latest ITR"
                || incomeproofDocumenttypetext == "Form 16"
            {
                guard let year = year, !year.isEmpty else {
                    self.showAlert(
                        title: "Alert",
                        message: "Please select assessment year.")
                    return
                }
            }
            if incomeproofDocumenttypetext == "Salary Slip" || incomeproofDocumenttypetext == "Demat Account Holding with Value" {
                incomeProofOcrCount = 2 // Start with 1, allowing only 1 attempt
            }
            //
            //            if incomeproofDocumenttypetext == "Six Month Bank Statement" {
            //                           incomeProofOcrCount = 1 // Start with 1, allowing only 1 attempt
            //                       }
            
        case "IMAGE":
            if incomeproofDocumenttype != lastderivativeDocumentType {
                incomeProofOcrCount = 0  // Reset to 1 for PDFs
            }
            lastderivativeDocumentType = incomeproofDocumenttype
            fileName = "image.jpg"
            mimeType = "image/jpeg"
            
            if incomeproofDocumenttypetext == "Salary Slip" || incomeproofDocumenttypetext == "Demat Account Holding with Value" {
                incomeProofOcrCount = 1 // Start with 1, allowing only 1 attempt
            }
            
            
        default:
            break
        }
        
        let parameters: [String: Any?] = [
            "PanNo": PanNo,
            "RegId": RegId,
            "UserId": fetchedUserId,
            "MOBRequestID": "",
            "Type": incomeproofDocumenttype,
            "Password": password,
            "DocumentType": incomeproofDocumenttypetext,
            "DocumentName": "IncomeProof",
            "Status": "",
            "OCRCount": "\(incomeProofOcrCount)",
            "NewValue": "",
            "AssesmentYear": year ?? "",
            "BrowserName": "",
            "BrowserVersion": "",
            "OS": "",
            "OSVersion": "",
            "IPAddress": "",
            "DeviceType": "",
        ]
        print("income uploads", parameters)
        let url = "\(self.prefixUrl)MultiPartImageUpload/DerivativeUpload"
        uploadDocument(
            apiEndpoint: url, parameters: parameters, fileData: imageData,
            fileName: fileName, mimeType: mimeType, loaderView: self.view,
            loaderText: "Kindly wait we are verifying your Income Proof..."
        ) { result in
            switch result {
            case .success(let jsonResponse):
                print("DerivativeUpload Response: \(jsonResponse)")
                //print("DerivativeUpload Response: \(jsonResponse)")
                let ErrorMessage = jsonResponse["ErrorMessage"] as? String
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "000000":
                        self.isIncomeProofVerified = true
                        DispatchQueue.main.async {
                            print("Derivative upload successful")
                            self.rejection2 = nil
                            self.IPCollectionView.isHidden = false
                            //self.incomeproofStatusLabel.isHidden = true
                            self.incomeProofuploadBtn.isHidden = true
                            self.incomeProofYearBtn.isHidden = true
                            self.yearBtn.isHidden = true
                            self.iplabel3.isHidden = true
                            
                            //self.IPStackView2.isHidden = true
                            
                            self.IPDocumentView.isHidden = false
                            self.updateCollectionViewWithUploadedImage(
                                from: jsonResponse, identifier: "IncomeProof")
                            
                        }
                    case "801005":
                        // Increment OCR count and retry if less than 3
                        DispatchQueue.main.async {
                            if self.incomeProofOcrCount < 2 {
                                self.incomeProofOcrCount += 1
                                self.incomeproofStatusLabel.isHidden = false
                                self.incomeproofStatusLabel.text =
                                jsonResponse["ErrorMessage"] as? String
                                ?? "1 attempt failed."
                                print(
                                    "Retrying with OCRCount: \(self.incomeProofOcrCount)"
                                )
                                //self.DerivativeUpload(imageData: imageData) // Retry API call
                            } else {
                                print("Maximum OCR attempts reached.")
                                self.updateCollectionViewWithUploadedImage(
                                    from: jsonResponse,
                                    identifier: "IncomeProof")
                            }
                        }
                    case "999992":
                        DispatchQueue.main.async {
                            self.regenerate(imageData: imageData)
                        }
                    case "111111":
                        DispatchQueue.main.async {
                            self.showAlert(
                                title: "Alert", message: ErrorMessage ?? "")
                        }
                    default:
                        print("Unhandled error code: \(errorCode)")
                    }
                }
            case .failure(let error):
                print("API call failed: \(error.localizedDescription)")
            }
        }
    }
//    func updateCollectionViewWithUploadedImage(
//        from jsonResponse: [String: Any], identifier: String
//    ) {
//        var imageIdString: String?
//        if let imageId = jsonResponse["RequestID"] as? Int {
//            imageIdString = String(imageId)
//        } else {
//            print("Image id not available in response.")
//            return
//        }
//        print("update ui calll...")
//        
//        let userId =
//        fetchedUserId?.addingPercentEncoding(
//            withAllowedCharacters: .urlQueryAllowed) ?? ""
//        //let imageUrlString = "\(imageUrlString)?UserId=\(userId)&TokenId=\(tokenId)"
//        let ImageUrlString =
//        "\(self.prefixUrl)MultiPartImageUpload/MediaDownload?id=\(imageIdString ?? "")&ImageType=ThumbNail&UserId=\(userId)&TokenId={tokenId}"
//        // Update the image in the collection view
//        //
//        //
//        //
//        
//        print("identifier document demat:\(identifier)")
//        
//        DispatchQueue.main.async {
//            switch identifier {
//            case "IncomeProof":
//                self.counts(shouldShow: true)
//                self.updateButtonImage(
//                    button: self.incomeProofStatusBtn,
//                    statusKey: "DocumentImages_Verify",
//                    jsonResponse: jsonResponse)
//                self.imageUrls.append(ImageUrlString)
//                self.incomeProofCollectionView.reloadData()
//                self.incomeProofVerifyBtn.isHidden = false
//            case "Bank":
//                self.bpcounts(shouldShow: true)
//                self.updateButtonImage(
//                    button: self.bankProofStatusBtn,
//                    statusKey: "DocumentImages_Verify",
//                    jsonResponse: jsonResponse)
//                self.bpImageUrls.append(ImageUrlString)
//                self.BpCollectionView.reloadData()
//                self.bankProofVerifyBtn.isHidden = false
//            case "Demat":
//                self.diCounts(shouldShow: true)
//                
//                let DP_IMAGEID_Verify =
//                jsonResponse["DocumentImages_Verify"] as? String
//                self.DP_IMAGEID_Verify = Int(DP_IMAGEID_Verify ?? "0")
//                self.updateButtonImage(
//                    button: self.dematStatusBtn,
//                    statusKey: "DocumentImages_Verify",
//                    jsonResponse: jsonResponse)
//                print("below update button demat")
//                self.dematimageUrls.append(ImageUrlString)
//                //self.updateButtondpimage(button: self.dematStatusBtn, statusKey: "DocumentImages_Verify", jsonResponse: jsonResponse)
//                self.DICollectionView.reloadData()
//                if let verifyStatus = jsonResponse["DocumentImages_Verify"] as? String {
//                    if verifyStatus == "0" {
//                        self.DematImageVerifyBtn.isHidden = false
//                    } else {
//                        self.DematImageVerifyBtn.isHidden = true  // ✅ Hide when verified (1 or 2)
//                    }
//                } else if let verifyStatus = jsonResponse["DocumentImages_Verify"] as? Int {
//                    if verifyStatus == 0 {
//                        self.DematImageVerifyBtn.isHidden = false
//                    } else {
//                        self.DematImageVerifyBtn.isHidden = true  // ✅ Hide when verified (1 or 2)
//                    }
//                } else {
//                    self.DematImageVerifyBtn.isHidden = false
//                }
//            default:
//                break
//            }
//        }
//    }
    
    func updateCollectionViewWithUploadedImage(
        from jsonResponse: [String: Any], identifier: String
    ) {
        var imageIdString: String?
        if let imageId = jsonResponse["RequestID"] as? Int {
            imageIdString = String(imageId)
        } else {
            print("Image id not available in response.")
            return
        }
        
        let userId = fetchedUserId?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let ImageUrlString = "\(self.prefixUrl)MultiPartImageUpload/MediaDownload?id=\(imageIdString ?? "")&ImageType=ThumbNail&UserId=\(userId)&TokenId={tokenId}"
        
        DispatchQueue.main.async {
            switch identifier {
            case "IncomeProof":
                // Check if image already exists to avoid duplicates
                if !self.imageUrls.contains(ImageUrlString) {
                    self.imageUrls.append(ImageUrlString)
                }
                self.counts(shouldShow: true)
                self.updateButtonImage(button: self.incomeProofStatusBtn, statusKey: "DocumentImages_Verify", jsonResponse: jsonResponse)
                self.incomeProofCollectionView.reloadData()
                self.incomeProofVerifyBtn.isHidden = false
                
            case "Bank":
//                if !self.bpImageUrls.contains(ImageUrlString) {
//                    self.bpImageUrls.append(ImageUrlString)
//                }
//                self.bpcounts(shouldShow: true)
//                self.updateButtonImage(button: self.bankProofStatusBtn, statusKey: "DocumentImages_Verify", jsonResponse: jsonResponse)
//                self.BpCollectionView.reloadData()
//                self.bankProofVerifyBtn.isHidden = false
                if !self.bpImageUrls.contains(ImageUrlString) {
                        self.bpImageUrls.append(ImageUrlString)
                    }
                    
                    // Update verification status from response
                    if let bankVerifyStatus = jsonResponse["DocumentImages_Verify"] as? String {
                        self.BankImages_Verify = bankVerifyStatus
                    } else if let bankVerifyStatus = jsonResponse["DocumentImages_Verify"] as? Int {
                        self.BankImages_Verify = String(bankVerifyStatus)
                    }
                    
                    // Hide upload button after upload
                    self.BANKPROOFBTN.isHidden = true
                    
                    // Show/hide verify button based on verification status
                    if self.BankImages_Verify == "0" {
                        // Pending verification - show verify button
                        self.bankProofVerifyBtn.isHidden = false
                    } else {
                        // Already verified or rejected - hide verify button
                        self.bankProofVerifyBtn.isHidden = true
                    }
                    
                    // Disable document type selection after upload
                    self.BankProofDocumentTypeBtn.isEnabled = false
                    
                    // Update button states based on document type
                    if self.bankproofDocumentType == "PDF" {
                        self.BankProofNoBtn.isEnabled = false
                        self.BankProofYesBtn.isEnabled = true
                    } else if self.bankproofDocumentType == "IMAGE" {
                        self.BankProofNoBtn.isEnabled = true
                        self.BankProofYesBtn.isEnabled = false
                    }
                    
                    // Hide description label
                    self.BPdescriptionLabel.isHidden = true
                    
                    // Update button image status
                    self.updateButtonImage(button: self.bankProofStatusBtn, statusKey: "DocumentImages_Verify", jsonResponse: jsonResponse)
                    
                    self.BpCollectionView.reloadData()
                
            case "Demat":
                if !self.dematimageUrls.contains(ImageUrlString) {
                    self.dematimageUrls.append(ImageUrlString)
                }
                self.diCounts(shouldShow: true)
                let DP_IMAGEID_Verify = jsonResponse["DocumentImages_Verify"] as? String
                self.DP_IMAGEID_Verify = Int(DP_IMAGEID_Verify ?? "0")
                self.updateButtonImage(button: self.dematStatusBtn, statusKey: "DocumentImages_Verify", jsonResponse: jsonResponse)
                self.DICollectionView.reloadData()
                
                if let verifyStatus = jsonResponse["DocumentImages_Verify"] as? String {
                    self.DematImageVerifyBtn.isHidden = (verifyStatus != "0")
                } else if let verifyStatus = jsonResponse["DocumentImages_Verify"] as? Int {
                    self.DematImageVerifyBtn.isHidden = (verifyStatus != 0)
                }
                
            default:
                break
            }
        }
    }
    
    func BankUpload(imageData: Data, password: String?) {
        
        var fileName: String = ""
        var mimeType: String = ""
        
        
        
        switch bankproofDocumentType {
        case "PDF":
            if bankproofDocumentType != lastbankDocumentType {
                bankOcrCount = 1  // Reset count if document type changes
            }
            
            lastbankDocumentType = bankproofDocumentType
            fileName = "document.pdf"
            mimeType = "application/pdf"
        case "IMAGE":
            if bankproofDocumentType != lastbankDocumentType {
                bankOcrCount = 1  // Reset count if document type changes
            }
            
            lastbankDocumentType = bankproofDocumentType
            fileName = "image.jpg"
            mimeType = "image/jpeg"
        default:
            break
        }
        
        let parameters: [String: Any?] = [
            "PanNo": PanNo,
            "RegId": RegId,
            "UserId": fetchedUserId,
            "MOBRequestID": "",
            "Type": bankproofDocumentType,
            "Password": password,
            "DocumentType": bankproofDocumentTypetext,
            "DocumentName": "Bank",
            "Status": "",
            "OCRCount": bankOcrCount,
            "NewValue": "",
            "BrowserName": "",
            "BrowserVersion": "",
            "OS": "",
            "OSVersion": "",
            "IPAddress": "",
            "DeviceType": "",
        ]
        print("bank uploads", parameters)
        let url = "\(self.prefixUrl)MultiPartImageUpload/BankUpload"
        //uploadDocument(apiEndpoint: "http://yourapi.com/upload", parameters: yourParameters, fileData: pdfData, fileName: pdfFileName, mimeType: pdfMimeType)
        uploadDocument(
            apiEndpoint: url, parameters: parameters, fileData: imageData,
            fileName: fileName, mimeType: mimeType, loaderView: self.view,
            loaderText: "Kindly wait we are verifying your Bank Proof..."
        ) { result in
            switch result {
            case .success(let jsonResponse):
                print("BankUpload Response: \(jsonResponse)")
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "000000":
                        DispatchQueue.main.async {
                            print("bankupload upload successful")
                            let bankImageVerify =
                            jsonResponse["DocumentImages_Verify"] as? String
                            self.rejection1 = nil
                            self.BPdescriptionLabel.isHidden = true
                            self.updateButtonImage(
                                button: self.bankProofStatusBtn,
                                statusKey: "DocumentImages_Verify" ?? "",
                                jsonResponse: jsonResponse)
                            //self.rejection = ""
                            self.BankImages_Verify = bankImageVerify
                            self.BpCollectionView.isHidden = false
                            self.BPDocumentView.isHidden = false
                            self.updateCollectionViewWithUploadedImage(
                                from: jsonResponse, identifier: "Bank")
                        }
                    case "801005":
                        // Increment OCR count and retry if less than 3
                        DispatchQueue.main.async {
                            if self.bankOcrCount < 2 {
                                self.bankOcrCount += 1
                                self.BPdescriptionLabel.isHidden = false
                                self.BPdescriptionLabel.text =
                                jsonResponse["ErrorMessage"] as? String
                                ?? "1 attempt failed."
                                print(
                                    "Retrying with OCRCount: \(self.bankOcrCount)"
                                )
                                //self.SignatureUpload(imageData: imageData) // Retry API call
                            } else {
                                self.BankImages_Verify =
                                jsonResponse["DocumentImages_Verify"]
                                as? String
                                self.updateCollectionViewWithUploadedImage(
                                    from: jsonResponse, identifier: "Bank")
                                print("Maximum OCR attempts reached.")
                            }
                        }
                    case "999992":
                        DispatchQueue.main.async {
                            self.regenerate(imageData: imageData)
                        }
                    default:
                        print("Unhandled error code: \(errorCode)")
                        // Handle error
                    }
                }
            case .failure(let error):
                print("API call failed: \(error.localizedDescription)")
            }
        }
    }
    
    func dematUpload(imageData: Data, password: String?) {
        
        var fileName: String = ""
        var mimeType: String = ""
        
        if dematDocumentType != lastDematDocumentType {
            dematOcrCount = 1  // Reset count if document type changes
        }
        
        // Update the last document type to the current one
        lastDematDocumentType = dematDocumentType
        
        switch dematDocumentType {
        case "PDF":
            fileName = "document.pdf"
            mimeType = "application/pdf"
        case "IMAGE":
            fileName = "image.jpg"
            mimeType = "image/jpeg"
        default:
            break
        }
        /*
         UserId
         RegId
         PanNo
         MOBRequestID=""
         DocumentName="DP_IMAGE"
         Type = IMAGE/PDF
         Password=''"
         OCRCount
         NewValue=""
         RejectRemark=""
         Status=""
         */
        
        let parameters: [String: Any?] = [
            "PanNo": PanNo,
            "RegId": RegId,
            "UserId": fetchedUserId,
            "MOBRequestID": "",
            "Type": dematDocumentType,
            "Password": password,
            
            "DocumentName": "DP_IMAGE",
            "Status": "",
            "OCRCount": "\(dematOcrCount)",
            "NewValue": "",
            "BrowserName": "",
            "BrowserVersion": "",
            "OS": "",
            "OSVersion": "",
            "IPAddress": "",
            "DeviceType": "",
        ]
        print("DPImageUpload5454", parameters)
        let url = "\(self.prefixUrl)MultiPartImageUpload/DPImageUpload"
        //uploadDocument(apiEndpoint: "http://yourapi.com/upload", parameters: yourParameters, fileData: pdfData, fileName: pdfFileName, mimeType: pdfMimeType)
        uploadDocument(
            apiEndpoint: url, parameters: parameters, fileData: imageData,
            fileName: fileName, mimeType: mimeType, loaderView: self.view,
            loaderText: "Kindly wait we are verifying your Demat document..."
        ) { result in
            switch result {
            case .success(let jsonResponse):
                print("DPImageUpload Response: \(jsonResponse)")
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "000000":
                        DispatchQueue.main.async {
                            print("DPImageUpload upload successful")
                            self.dematDescriptionLabel.isHidden = true
                            let DP_IMAGEID_Verify =
                            jsonResponse["DocumentImages_Verify"] as? String
                            self.rejection3 = nil
                            self.DP_IMAGEID_Verify =
                            jsonResponse["DocumentImages_Verify"] as? Int
                            print("stringvalue:", DP_IMAGEID_Verify)
                            print("integer\(self.DP_IMAGEID_Verify)")
                            self.updateButtonImage(
                                button: self.dematStatusBtn,
                                statusKey: DP_IMAGEID_Verify ?? "",
                                jsonResponse: jsonResponse)
                            self.DICollectionView.isHidden = false
                            self.DIDocumentView.isHidden = false
                            self.updateCollectionViewWithUploadedImage(
                                from: jsonResponse, identifier: "Demat")
                        }
                    case "801005":
                        // Increment OCR count and retry if less than 3
                        DispatchQueue.main.async {
                            if self.dematOcrCount < 2 {
                                self.dematOcrCount += 1
                                self.dematDescriptionLabel.isHidden = false
                                self.dematDescriptionLabel.text =
                                jsonResponse["ErrorMessage"] as? String
                                ?? "1 attempt failed."
                                print(
                                    "Retrying with OCRCount: \(self.dematOcrCount)"
                                )
                                //self.SignatureUpload(imageData: imageData) // Retry API call
                            } else {
                                self.DP_IMAGEID_Verify =
                                jsonResponse["DocumentImages_Verify"]
                                as? Int
                                print("Maximum OCR attempts reached.")
                            }
                        }
                    case "999992":
                        DispatchQueue.main.async {
                            self.regenerate(imageData: imageData)
                        }
                    default:
                        print("Unhandled error code: \(errorCode)")
                        // Handle error
                    }
                }
            case .failure(let error):
                print(
                    "DPImageUpload API call failed: \(error.localizedDescription)"
                )
            }
        }
    }
    
    func PANUpload(imageData: Data, password: String?) {
        
        var fileName: String = "image.jpg"
        var mimeType: String = "image/jpeg"
        //var ocrpancount = 1
        
        //            switch panCopyDocumentType {
        //            case "PDF":
        //                fileName = "document.pdf"
        //                mimeType = "application/pdf"
        //
        //            case "IMAGE":
        //fileName = "image.jpg"
        //            mimeType = "image/jpeg"
        //            default:
        //                break
        //            }
        
        let parameters: [String: Any?] = [
            "PanNo": PanNo,
            "RegId": RegId,
            "UserId": fetchedUserId,
            "MOBRequestID": "",
            "Type": "IMAGE",
            "Password": password,
            "OCRCount": "\(ocrpancount)",
            "NewValue": "",
            "BrowserName": "",
            "BrowserVersion": "",
            "OS": "",
            "OSVersion": "",
            "IPAddress": "",
            "DeviceType": "",
        ]
        print("PAN uploads", parameters)
        let url = "\(self.prefixUrl)MultiPartImageUpload/PANUpload"
        //uploadDocument(apiEndpoint: "http://yourapi.com/upload", parameters: yourParameters, fileData: pdfData, fileName: pdfFileName, mimeType: pdfMimeType)
        uploadDocument(
            apiEndpoint: url, parameters: parameters, fileData: imageData,
            fileName: fileName, mimeType: mimeType, loaderView: self.view,
            loaderText: "Kindly wait we are verifying your PAN Details..."
        ) { result in
            switch result {
            case .success(let jsonResponse):
                print("PANUpload Response: \(jsonResponse)")
                let errorMessage = jsonResponse["ErrorMessage"] as? String
                if let errorCode = jsonResponse["ErrorCode"] as? String{
                    switch errorCode {
                    case "000000":
                        DispatchQueue.main.async {
                            print("PANUpload upload successful")
                            self.panDelete = ""
                            self.ocrpancount = 0
                            self.PanupdateUI(with: jsonResponse)
                        }
                    case "801005","801006":
                        // Increment OCR count and retry if less than 3
                        DispatchQueue.main.async {
                            if self.ocrpancount < 2 {
                                self.ocrpancount += 1
                                self.pancopymessagelabel.text =
                                jsonResponse["ErrorMessage"] as? String
                                ?? "1 attempt failed."
                                print(
                                    "Retrying with OCRCount: \(self.ocrCount)")
                                self.showAlert(title: "Alert", message: errorMessage ?? "")
                                //self.PANUpload(imageData: imageData) // Retry API call
                            } else {
                                print("Maximum OCR attempts reached.")
                            }
                        }
                    case "999992":
                        DispatchQueue.main.async {
                            self.regenerate(imageData: imageData)
                        }
                    default:
                        print("Unhandled error code: \(errorCode)")
                        // Handle error
                    }
                }
            case .failure(let error):
                print("API call failed: \(error.localizedDescription)")
            }
        }
    }
    func PanupdateUI(with response: [String: Any]) {
        
        // Signature Image
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
            [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "M", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.PanupdateUI(with: self.jsonResponse)
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            //print("signature update \(response)")
            //            print("signature update \(response["RequestID"] as? Int)")
            if let PanimageID = response["RequestID"] as? Int {
                //                        print("if is called")// Construct the URL safely
                let userId =
                fetchedUserId?.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                
                let imageUrlString =
                "\(self.prefixUrl)MultiPartImageUpload/MediaDownload?id=\(PanimageID)&ImageType=ThumbNail&UserId=\(userId)&TokenId=\(tokenId)"
                self.panImageUrl = imageUrlString
                self.PCHolderView.isHidden = false
                self.PCStackView.isHidden = true
                if panCopyDocumentType == "PDF" {
                    //                        PCYesBtn.isSelected = true
                    //                        PCNoBtn.isSelected = false
                    PCNoBtn.isEnabled = false
                    PCYesBtn.isEnabled = true
                } else if panCopyDocumentType == "IMAGE" {
                    //                        PCYesBtn.isSelected = false
                    //                        PCNoBtn.isSelected = true
                    PCYesBtn.isEnabled = false
                    PCNoBtn.isEnabled = true
                }
                // Print to debug the formed URL
                self.PANImage_Verify =
                response["DocumentImages_Verify"] as? String
                print("Formed panView URL: \(imageUrlString)")
                self.panCopyImageView.restorationIdentifier = "PanView"
                loadImage(
                    from: imageUrlString, into: self.panCopyImageView,
                    with: "PanView")
                DispatchQueue.main.async {
                    self.updateButtonImage(
                        button: self.panCopyStatusBtn,
                        statusKey: "DocumentImages_Verify",
                        jsonResponse: response)
                }
            } else {
                panCopyImageView.image = UIImage(
                    systemName: "person.crop.circle.badge.xmark")
            }
            
        }
    }
    
    //    func CLIENTPHOTOUpload(imageData: Data) {
    //
    //        var fileName: String = ""
    //        var mimeType: String = ""
    //        fileName = "image.jpg"
    //        mimeType = "image/jpeg"
    //
    //        let parameters: [String: Any?] = [
    //            "PanNo": PanNo,
    //            "RegId": RegId,
    //            "UserId": fetchedUserId,
    //            "MOBRequestID": "",
    //            "Type": "IMAGE",
    //            "Latitude": Latitude,
    //            "Longitude": Longitude,
    //            "Location": "",
    //            "OCRCount": ocrCount,
    //            "NewValue": "",
    //            "BrowserName": "",
    //            "BrowserVersion": "",
    //            "OS": "",
    //            "OSVersion": "",
    //            "IPAddress": "",
    //            "DeviceType": "",
    //        ]
    //        print("client photo uploads", parameters)
    //        let url = "\(self.prefixUrl)MultiPartImageUpload/CLIENTPHOTOUpload"
    //        //uploadDocument(apiEndpoint: "http://yourapi.com/upload", parameters: yourParameters, fileData: pdfData, fileName: pdfFileName, mimeType: pdfMimeType)
    //        uploadDocument(
    //            apiEndpoint: url, parameters: parameters, fileData: imageData,
    //            fileName: fileName, mimeType: mimeType, loaderView: self.view,
    //            loaderText: "Kindly wait we are verifying your client image..."
    //        ) { result in
    //            switch result {
    //            case .success(let jsonResponse):
    //                print("CLIENTPHOTOUpload Response: \(jsonResponse)")
    //                let ClientPhotoImageID_Verify =
    //                jsonResponse["DocumentImages_Verify"] as? String
    //                if let errorCode = jsonResponse["ErrorCode"] as? String {
    //                    switch errorCode {
    //                    case "000000":
    //                        DispatchQueue.main.async {
    //                            print("Image upload successful")
    //                            // Call GetUserLocation API
    //                            self.ocrpancount = 0
    //                            if let latitude = self.Latitude,
    //                               let longitude = self.Longitude
    //                            {
    //                                self.GetUserLocation(
    //                                    Longitude: longitude, Latitude: latitude)
    //                                self.clientImageUpdateUI(with: jsonResponse)
    //                                //                                    self.ClientPhotoImageID_Verify = ClientPhotoImageID_Verify
    //                            }
    //                            self.CP_CaptureImgBtn.isHidden = true
    //                            self.CP_IPVLinkBtn.isHidden = true
    //                        }
    //
    //                    case "801005":
    //                        print("OCR Error hit, current count = \(self.ocrCount)")
    //                        if self.ocrCount == 1 {
    //                            // 1st failure → show alert
    //                            let errorMessage = (jsonResponse["RejectRemark"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
    //                            ?? (jsonResponse["ErrorMessage"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
    //                            ?? "OCR failed."
    //
    //                            DispatchQueue.main.async {
    //                                self.showAlert(title: "Error", message: errorMessage)
    //                            }
    //                            self.ocrCount += 1
    //                        } else if self.ocrCount == 1 {
    //                            // 2nd failure → allow user to retry
    //                            self.ocrCount += 1
    //                            let errorMessage = (jsonResponse["RejectRemark"] as? String)
    //                            ?? (jsonResponse["ErrorMessage"] as? String)
    //                            ?? "Second attempt failed. Please try again."
    //
    //                            DispatchQueue.main.async {
    //                                self.signatureAttemptLabel.text = errorMessage
    //                                print("Retry allowed for OCRCount: \(self.ocrCount)")
    //                            }
    //                        } else {
    //                            // After 2 failures → upload anyway
    //                            print("Invalid OCR but forcing upload.")
    //                            DispatchQueue.main.async {
    //                                if let validImage = self.selectedClientImage {
    //                                    self.CPImageView.image = validImage
    //                                }
    //                                self.showAlert(title: "Notice", message: "OCR failed multiple times, proceeding with upload.")
    //                                self.CLIENTPHOTOUpload(imageData: imageData)
    //                            }
    //                        }
    //                    case "111111":
    //                        // Increment OCR count and retry if less than 3
    //                        let errorMessage = (jsonResponse["ErrorMessage"] as? String) ?? "Something went wrong."
    //                        DispatchQueue.main.async {
    //                            print("Image upload successful")
    //                            self.showAlert(title: "Alert", message: errorMessage)
    //                            // Call GetUserLocation API
    //                            self.ocrpancount = 0
    //                            if let latitude = self.Latitude,
    //                               let longitude = self.Longitude
    //                            {
    //                                self.GetUserLocation(
    //                                    Longitude: longitude, Latitude: latitude)
    //                                self.clientImageUpdateUI(with: jsonResponse)
    //                                //                                    self.ClientPhotoImageID_Verify = ClientPhotoImageID_Verify
    //                            }
    //                        }
    //                    case "999992":
    //                        DispatchQueue.main.async {
    //                            self.regenerate(imageData: imageData)
    //                        }
    //                    default:
    //                        print("Unhandled error code: \(errorCode)")
    //                        // Handle error
    //                    }
    //                }
    //            case .failure(let error):
    //                print("API call failed: \(error.localizedDescription)")
    //            }
    //        }
    //    }
    //
    //    func clientImageUpdateUI(with response: [String: Any]) {
    //        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
    //            [self] tokenId in
    //            guard let tokenId = tokenId else {
    //                // Handle the case where no tokens are available
    //                CoreDataHelper.generateToken(
    //                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
    //                    USERID: self.fetchedUserId ?? "",
    //                    SessionId: self.fetchedSessionID ?? "",
    //                    entityName: "TokenMobile", deviceType: "M", in: self.view
    //                ) { success in
    //                    if success {
    //                        // Retry SIXTHAPI after token regeneration
    //                        self.clientImageUpdateUI(with: response)
    //                    } else {
    //                        print("Token generation failed.")
    //                    }
    //                }
    //                print("No tokens available. Please reload the tokens.")
    //                return
    //            }
    //            if let clientImageID = response["RequestID"] as? Int {
    //                //                        print("if is called")// Construct the URL safely
    //                let userId =
    //                fetchedUserId?.addingPercentEncoding(
    //                    withAllowedCharacters: .urlQueryAllowed) ?? ""
    //
    //                let imageUrlString =
    //                "\(self.prefixUrl)MultiPartImageUpload/MediaDownload?id=\(clientImageID)&ImageType=ThumbNail&UserId=\(userId)&TokenId=\(tokenId)"
    //                self.clientPhotoUrl = imageUrlString
    //                self.CPHolderView1.isHidden = false
    //
    //                CPImageView.isHidden = false
    //                CP_Long_Lat_Lbl.isHidden = false
    //                CP_Location_label.isHidden = false
    //                CpHolderView2.isHidden = false
    //                // Print to debug the formed URL
    //                self.ClientPhotoImageID_Verify =
    //                response["DocumentImages_Verify"] as? String
    //
    //
    //                print("Formed panView URL: \(imageUrlString)")
    //                self.CPImageView.restorationIdentifier = "clientPhoto"
    //                loadImage(
    //                    from: imageUrlString, into: self.CPImageView,
    //                    with: "clientPhoto")
    //                DispatchQueue.main.async {
    //                    self.updateButtonImage(
    //                        button: self.clientPhotoStatusBtn,
    //                        statusKey: "DocumentImages_Verify",
    //                        jsonResponse: response)
    //
    //
    //                }
    //            } else {
    //                CPImageView.image = UIImage(
    //                    systemName: "person.crop.circle.badge.xmark")
    //            }
    //
    //        }
    //    }
    //
    //    func InsertUpdateIPVAuditLog() {
    //
    //        let parameters: [String: Any?] = [
    //            "RegId": RegId,
    //            "PanNo": PanNo,
    //            "CreatedBy": fetchedUserId,
    //            "Flag": "INSERT",
    //        ]
    //        print(parameters)
    //        let Url = "MultiPartImageUpload/InsertUpdateIPVAuditLog"
    //
    //        apiCall(
    //            url: Url, method: "POST", parameters: parameters as [String: Any],
    //            view: self.view
    //        ) { result in
    //            switch result {
    //            case .success(let jsonResponse):
    //                print("InsertUpdateIPVAuditLog Response: \(jsonResponse)")
    //                if let errorCode = jsonResponse["ErrorCode"] as? String {
    //                    switch errorCode {
    //                    case "000000":
    //                        DispatchQueue.main.async { [self] in
    //                            self.IPVStatus = "IPV"  // Store IPV status
    //                            self.startPeriodicViewDocumentDetails()
    //                            showAlert(
    //                                title: "Alert",
    //                                message:
    //                                    "You get email in your verified email id..."
    //                            )
    //                            print("api is running")
    //                        }
    //                    default:
    //                        print("Unhandled error code: \(errorCode)")
    //                    }
    //                }
    //            case .failure(let error):
    //                print("Login API call failed: \(error.localizedDescription)")
    //            }
    //
    //        }
    //    }
    
    func CLIENTPHOTOUpload(imageData: Data) {
        
        var fileName: String = ""
        var mimeType: String = ""
        fileName = "image.jpg"
        mimeType = "image/jpeg"
        
        let parameters: [String: Any?] = [
            "PanNo": PanNo,
            "RegId": RegId,
            "UserId": fetchedUserId,
            "MOBRequestID": "",
            "Type": "IMAGE",
            "Latitude": Latitude,
            "Longitude": Longitude,
            "Location": "",
            "OCRCount": ocrCount,
            "NewValue": "",
            "BrowserName": "",
            "BrowserVersion": "",
            "OS": "",
            "OSVersion": "",
            "IPAddress": "",
            "DeviceType": "",
        ]
        print("client photo uploads", parameters)
        let url = "\(self.prefixUrl)MultiPartImageUpload/CLIENTPHOTOUpload"
        //uploadDocument(apiEndpoint: "http://yourapi.com/upload", parameters: yourParameters, fileData: pdfData, fileName: pdfFileName, mimeType: pdfMimeType)
        uploadDocument(
            apiEndpoint: url, parameters: parameters, fileData: imageData,
            fileName: fileName, mimeType: mimeType, loaderView: self.view,
            loaderText: "Kindly wait we are verifying your client image..."
        ) { result in
            switch result {
            case .success(let jsonResponse):
                print("CLIENTPHOTOUpload Response: \(jsonResponse)")
                let ClientPhotoImageID_Verify =
                jsonResponse["DocumentImages_Verify"] as? String
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "000000":
                        DispatchQueue.main.async {
                            print("Image upload successful")
                            // Call GetUserLocation API
                            self.ocrpancount = 0
                            if let latitude = self.Latitude,
                               let longitude = self.Longitude
                            {
                                self.GetUserLocation(
                                    Longitude: longitude, Latitude: latitude)
                                self.clientImageUpdateUI(with: jsonResponse)
                                //                                    self.ClientPhotoImageID_Verify = ClientPhotoImageID_Verify
                            }
                            self.CP_CaptureImgBtn.isHidden = true
                            self.CP_IPVLinkBtn.isHidden = true
                        }
                        
                    case "801005":
                        print("OCR Error hit, current count = \(self.ocrCount)")
                        if self.ocrCount == 1 {
                            // 1st failure → show alert
                            let errorMessage = (jsonResponse["RejectRemark"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
                            ?? (jsonResponse["ErrorMessage"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
                            ?? "OCR failed."
                            
                            DispatchQueue.main.async {
                                self.showAlert(title: "Error", message: errorMessage)
                            }
                            self.ocrCount += 1
                        } else if self.ocrCount == 1 {
                            // 2nd failure → allow user to retry
                            self.ocrCount += 1
                            let errorMessage = (jsonResponse["RejectRemark"] as? String)
                            ?? (jsonResponse["ErrorMessage"] as? String)
                            ?? "Second attempt failed. Please try again."
                            
                            DispatchQueue.main.async {
                                self.signatureAttemptLabel.text = errorMessage
                                print("Retry allowed for OCRCount: \(self.ocrCount)")
                            }
                        } else {
                            // After 2 failures → upload anyway
                            print("Invalid OCR but forcing upload.")
                            DispatchQueue.main.async {
                                if let validImage = self.selectedClientImage {
                                    self.CPImageView.image = validImage
                                }
                                self.showAlert(title: "Notice", message: "OCR failed multiple times, proceeding with upload.")
                                self.CLIENTPHOTOUpload(imageData: imageData)
                            }
                        }
                    case "111111":
                        // Increment OCR count and retry if less than 3
                        let errorMessage = (jsonResponse["ErrorMessage"] as? String) ?? "Something went wrong."
                        DispatchQueue.main.async {
                            print("Image upload successful")
                            self.showAlert(title: "Alert", message: errorMessage)
                            // Call GetUserLocation API
                            self.ocrpancount = 0
                            if let latitude = self.Latitude,
                               let longitude = self.Longitude
                            {
                                self.GetUserLocation(
                                    Longitude: longitude, Latitude: latitude)
                                self.clientImageUpdateUI(with: jsonResponse)
                                //                                    self.ClientPhotoImageID_Verify = ClientPhotoImageID_Verify
                            }
                        }
                    case "999992":
                        DispatchQueue.main.async {
                            self.regenerate(imageData: imageData)
                        }
                    default:
                        print("Unhandled error code: \(errorCode)")
                        // Handle error
                    }
                }
            case .failure(let error):
                print("API call failed: \(error.localizedDescription)")
            }
        }
    }
    
    func clientImageUpdateUI(with response: [String: Any]) {
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
                        self.clientImageUpdateUI(with: self.jsonResponse)
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            if let clientImageID = response["RequestID"] as? Int {
                //                        print("if is called")// Construct the URL safely
                let userId =
                fetchedUserId?.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                
                let imageUrlString =
                "\(self.prefixUrl)MultiPartImageUpload/MediaDownload?id=\(clientImageID)&ImageType=ThumbNail&UserId=\(userId)&TokenId=\(tokenId)"
                self.clientPhotoUrl = imageUrlString
                self.CPHolderView1.isHidden = false
                
                CPImageView.isHidden = false
                CP_Long_Lat_Lbl.isHidden = false
                CP_Location_label.isHidden = false
                CpHolderView2.isHidden = false
                // Print to debug the formed URL
                self.ClientPhotoImageID_Verify =
                response["DocumentImages_Verify"] as? String
                
                
                print("Formed panView URL: \(imageUrlString)")
                self.CPImageView.restorationIdentifier = "clientPhoto"
                loadImage(
                    from: imageUrlString, into: self.CPImageView,
                    with: "clientPhoto")
                DispatchQueue.main.async {
                    self.updateButtonImage(
                        button: self.clientPhotoStatusBtn,
                        statusKey: "DocumentImages_Verify",
                        jsonResponse: response)
                    
                    
                }
            } else {
                CPImageView.image = UIImage(
                    systemName: "person.crop.circle.badge.xmark")
            }
            
        }
    }
    
    func InsertUpdateIPVAuditLog() {
        
        let parameters: [String: Any?] = [
            "RegId": RegId,
            "PanNo": PanNo,
            "CreatedBy": fetchedUserId,
            "Flag": "INSERT",
        ]
        print(parameters)
        let Url = "MultiPartImageUpload/InsertUpdateIPVAuditLog"
        
        apiCall(
            url: Url, method: "POST", parameters: parameters as [String: Any],
            view: self.view
        ) { result in
            switch result {
            case .success(let jsonResponse):
                print("InsertUpdateIPVAuditLog Response: \(jsonResponse)")
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "000000":
                        DispatchQueue.main.async { [self] in
                            self.IPVStatus = "IPV"  // Store IPV status
                            self.startPeriodicViewDocumentDetails()
                            showAlert(
                                title: "Alert",
                                message:
                                    "You get email in your verified email id..."
                            )
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
    
    func startPeriodicViewDocumentDetails() {
        DispatchQueue.main.async {
            self.viewDocumentTimer?.invalidate() // Ensure existing timer is stopped
            self.viewDocumentTimer = Timer.scheduledTimer(withTimeInterval: 20.0, repeats: true) { _ in
                self.ViewDocumentDetails()
            }
        }
    }
    
    func stopPeriodicViewDocumentDetails() {
        DispatchQueue.main.async {
            self.viewDocumentTimer?.invalidate()
            self.viewDocumentTimer = nil
            print("Timer stopped.")
        }
    }
    
    
    func GetUserLocation(Longitude: String, Latitude: String) {
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
                        self.GetUserLocation(Longitude: Longitude, Latitude: Latitude)
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "RegId": RegId,
                "PanNo": PanNo,
                "UserId": fetchedUserId,
                "Latitude": Latitude,
                "Longitude": Longitude,
                "TokenId": tokenId,
            ]
            print(parameters)
            let Url = "Client/GetUserLocation"
            
            apiCall(
                url: Url, method: "POST",
                parameters: parameters as [String: Any], view: self.view
            ) { result in
                switch result {
                case .success(let jsonResponse):
                    print("GetUserLocation Response: \(jsonResponse)")
                    self.location = jsonResponse["Location"] as? String
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            DispatchQueue.main.async { [self] in
                                self.CP_Location_label.text =
                                jsonResponse["Location"] as? String
                                ?? "location not found"
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
    
    func NomineeUpload(imageData: Data) {
        
        var fileName: String = ""
        var mimeType: String = ""
        fileName = "image.jpg"
        mimeType = "image/jpeg"
        /*
         
         DocumentName="NOMINEE_1/NOMINEE_2/NOMINEE_3"
         
         */
        let parameters: [String: Any?] = [
            "PanNo": PanNo,
            "RegId": RegId,
            "UserId": fetchedUserId,
            "MOBRequestID": "",
            "Type": "IMAGE",
            "Password": "",
            "DocumentType": "PAN",
            "DocumentName": identifier,
            "Status": "",
            "OCRCount": ocrCount,
            "NewValue": "",
            "RejectRemark": "",
            "BrowserName": "",
            "BrowserVersion": "",
            "OS": "",
            "OSVersion": "",
            "IPAddress": "",
            "DeviceType": "",
        ]
        print("Nominee uploads", parameters)
        let url = "\(self.prefixUrl)MultiPartImageUpload/NomineeUpload"
        //uploadDocument(apiEndpoint: "http://yourapi.com/upload", parameters: yourParameters, fileData: pdfData, fileName: pdfFileName, mimeType: pdfMimeType)
        uploadDocument(
            apiEndpoint: url, parameters: parameters, fileData: imageData,
            fileName: fileName, mimeType: mimeType, loaderView: self.view,
            loaderText:
                "Kindly wait we are verifying your Nominee/Guardian Image..."
        ) { result in
            switch result {
            case .success(let jsonResponse):
                print("NomineeUpload Response: \(jsonResponse)")
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "000000":
                        DispatchQueue.main.async {
                            print("NomineeUpload upload successful")
                            self.updateNomineeUI(
                                identifier: self.identifier ?? "",
                                jsonResponse: jsonResponse)
                            self.ocrCount = 1
                        }
                    case "801005":
                        // Increment OCR count and retry if less than 3
                        DispatchQueue.main.async {
                            if self.ocrCount < 2 {
                                self.ocrCount += 1
                                switch self.identifier {
                                case "NOMINEE_1":
                                    
                                    self.nominee1infolbl.isHidden = false
                                    self.nominee1infolbl.text =
                                    jsonResponse["ErrorMessage"] as? String
                                    ?? "1 attempt failed."
                                    print(
                                        "Retrying with OCRCount: \(self.ocrCount)"
                                    )
                                    print("aayega aayega sabar rakho")
                                case "NOMINEE_2":
                                    self.nominee2infolbl.isHidden = false
                                    self.nominee2infolbl.text =
                                    jsonResponse["ErrorMessage"] as? String
                                    ?? "1 attempt failed."
                                    print(
                                        "Retrying with OCRCount: \(self.ocrCount)"
                                    )
                                    print("aayega aayega sabar rakho")
                                case "NOMINEE_3":
                                    self.nominee3infolbl.isHidden = false
                                    self.nominee3infolbl.text =
                                    jsonResponse["ErrorMessage"] as? String
                                    ?? "1 attempt failed."
                                    print(
                                        "Retrying with OCRCount: \(self.ocrCount)"
                                    )
                                    print("aayega aayega sabar rakho")
                                default:
                                    break
                                }
                            } else {
                                self.updateNomineeUI(
                                    identifier: self.identifier ?? "",
                                    jsonResponse: jsonResponse)
                                
                                print("Maximum OCR attempts reached.")
                            }
                        }
                    case "801006":
                        DispatchQueue.main.async {
                            self.showAlert(
                                title: "Alert",
                                message:
                                    "Due to technical reason we are unable to verify your document, please try after sometime."
                            )
                            //                            DispatchQueue.main.async {
                            //                                if self.ocrCount < 3 {
                            //                                    self.ocrCount += 1
                            //                                    switch self.identifier {
                            //                                    case "NOMINEE_1":
                            //                                        self.nominee1infolbl.isHidden = false
                            //                                        self.nominee1infolbl.text = jsonResponse["ErrorMessage"] as? String ?? "1 attempt failed."
                            //                                        print("Retrying with OCRCount: \(self.ocrCount)")
                            //                                        print("aayega aayega sabar rakho")
                            //                                    case "NOMINEE_2":
                            //                                        self.nominee2infolbl.isHidden = false
                            //                                        self.nominee2infolbl.text = jsonResponse["ErrorMessage"] as? String ?? "1 attempt failed."
                            //                                        print("Retrying with OCRCount: \(self.ocrCount)")
                            //                                        print("aayega aayega sabar rakho")
                            //                                    case "NOMINEE_3":
                            //                                        self.nominee3infolbl.isHidden = false
                            //                                        self.nominee3infolbl.text = jsonResponse["ErrorMessage"] as? String ?? "1 attempt failed."
                            //                                        print("Retrying with OCRCount: \(self.ocrCount)")
                            //                                        print("aayega aayega sabar rakho")
                            //                                    default :
                            //                                        break
                            //                                    }
                            //
                            //
                            //                                } else {
                            //                                    print("Maximum OCR attempts reached.")
                            //                                }
                            //                            }
                        }
                    case "999992":
                        DispatchQueue.main.async {
                            self.regenerate(imageData: imageData)
                            
                        }
                    default:
                        print("Unhandled error code: \(errorCode)")
                        // Handle error
                    }
                }
            case .failure(let error):
                print("API call failed: \(error.localizedDescription)")
            }
        }
    }
    
    func updateNomineeUI(identifier: String, jsonResponse: [String: Any]) {
        guard let errorCode = jsonResponse["ErrorCode"] as? String else {
            print("Invalid response: no error code found")
            return
        }
        
        let errorMessage =
        jsonResponse["ErrorMessage"] as? String ?? "Unknown error"
        let statusMessage =
        jsonResponse["Status"] as? String ?? "No status available"
        
        // Fetch the token ID for image loading
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
            [self] tokenId in
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.updateNomineeUI(identifier: identifier, jsonResponse: self.jsonResponse)
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            
            // Check if RequestID exists in the response
            if let nomineeImageID = jsonResponse["RequestID"] as? Int {
                let userId =
                fetchedUserId?.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                let imageUrlString =
                "\(self.prefixUrl)MultiPartImageUpload/MediaDownload?id=\(nomineeImageID)&ImageType=ThumbNail&UserId=\(userId)&TokenId=\(tokenId)"
                
                // Print to debug the formed URL
                print("Formed nominee image URL: \(imageUrlString)")
                
                DispatchQueue.main.async {
                    switch identifier {
                    case "NOMINEE_1":
                        self.nominee1Url = imageUrlString
                        self.Nominee1bTn.isHidden = true
                        self.nominee1infolbl.isHidden = false
                        //nominee1ImageView,ishid
                        self.nominee1infolbl.text =
                        statusMessage != "No status available"
                        ? statusMessage : errorMessage
                        self.NM1DocumentView.isHidden = false
                        self.nominee1ImageView.isHidden = false
                        self.nominee1ImageView.restorationIdentifier =
                        "nominee1view"
                        self.loadImage(
                            from: imageUrlString, into: self.nominee1ImageView,
                            with: "nominee1view")
                        self.nominee1ImagesVerify =
                        jsonResponse["DocumentImages_Verify"] as? String
                        self.updateButtonImage(
                            button: self.nominee1StatusBtn,
                            statusKey: "DocumentImages_Verify",
                            jsonResponse: jsonResponse)
                    case "NOMINEE_2":
                        self.nominee2Url = imageUrlString
                        self.Nominee2Btn.isHidden = true
                        self.nominee2infolbl.text =
                        statusMessage != "No status available"
                        ? statusMessage : errorMessage
                        self.nominee2ImageView.restorationIdentifier =
                        "nominee2view"
                        self.loadImage(
                            from: imageUrlString, into: self.nominee2ImageView,
                            with: "nominee2view")
                        self.nominee2ImagesVerify =
                        jsonResponse["DocumentImages_Verify"] as? String
                        self.updateButtonImage(
                            button: self.nominee2StatusBtn,
                            statusKey: "DocumentImages_Verify",
                            jsonResponse: jsonResponse)
                    case "NOMINEE_3":
                        self.nominee3Url = imageUrlString
                        self.Nominee3BTn.isHidden = true
                        self.nominee3infolbl.text =
                        statusMessage != "No status available"
                        ? statusMessage : errorMessage
                        self.nominee3ImageView.restorationIdentifier =
                        "nominee3view"
                        self.loadImage(
                            from: imageUrlString, into: self.nominee3ImageView,
                            with: "nominee3view")
                        self.nominee3ImagesVerify =
                        jsonResponse["DocumentImages_Verify"] as? String
                        self.updateButtonImage(
                            button: self.nominee3StatusBtn,
                            statusKey: "DocumentImages_Verify",
                            jsonResponse: jsonResponse)
                    default:
                        print("Unhandled identifier: \(identifier)")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    switch identifier {
                    case "NOMINEE_1":
                        self.nominee1infolbl.text = errorMessage
                        self.nominee1ImageView.image = UIImage(
                            systemName: "person.crop.circle.badge.xmark")
                        
                    case "NOMINEE_2":
                        self.nominee2infolbl.text = errorMessage
                        self.nominee2ImageView.image = UIImage(
                            systemName: "person.crop.circle.badge.xmark")
                        
                    case "NOMINEE_3":
                        self.nominee3infolbl.text = errorMessage
                        self.nominee3ImageView.image = UIImage(
                            systemName: "person.crop.circle.badge.xmark")
                        
                    default:
                        print("Unhandled identifier: \(identifier)")
                    }
                }
            }
        }
    }
    
    func DocumentVerify(
        DocumentName: String, DocumentType: String, ocrCount: Int
    ) {
        //var count = 1
        let parameters: [String: Any?] = [
            "RegId": RegId,
            "PanNo": PanNo,
            "CreatedBy": fetchedUserId,
            "UserId": fetchedUserId,
            "DocumentName": DocumentName,
            "DocumentType": DocumentType,
            "OCRCount": "\(ocrCount)",
            "OCRValue": "",
        ]
        print(parameters)
        let Url = "MultiPartImageUpload/DocumentVerify"
        
        apiCall(
            url: Url, method: "POST", parameters: parameters as [String: Any],
            view: self.view,
            loaderText: "Kindly wait we are verifying your images..."
        ) { result in
            switch result {
            case .success(let jsonResponse):
                print("DocumentVerify Response: \(jsonResponse)")
                let ErrorMessage = jsonResponse["ErrorMessage"] as? String
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "000000":
                        DispatchQueue.main.async {
                            
                            switch DocumentName {
                                
                            case "INCOMEPROOF":
                                self.IPDocumentView.isHidden = true
                                self.counts(shouldShow: true)
                                
                                self.rejection2 = nil
                                self.ViewDocumentDetails()
                                self.incomeProofCollectionView.reloadData()
                                
                            case "BANK":
                                self.BPDocumentView.isHidden = true
                                self.bpcounts(shouldShow: true)
                                self.ViewDocumentDetails()
                                self.rejection1 = nil
                            case "DP_IMAGE":
                                self.diCounts(shouldShow: true)
                                self.ViewDocumentDetails()
                                self.rejection3 = nil
                            default:
                                break
                            }
                            print("api is running")
                        }
                    case "801005":
                        // Increment OCR count and retry if less than 3
                        DispatchQueue.main.async {
                            if ocrCount < 2 {
                                //ocrCount += 1
                                let errorMessage =
                                jsonResponse["ErrorMessage"] as? String
                                ?? "1 attempt failed."
                                
                                // Switch based on DocumentName to show relevant label message
                                switch DocumentName {
                                case "BANK":
                                    self.bpverify = "Y"
                                    self.verifyBP()
                                    self.BPdescriptionLabel.text = errorMessage
                                case "INCOMEPROOF":
                                    self.ipverify = "Y"
                                    self.verifyIP()
                                    self.incomeproofStatusLabel.text =
                                    errorMessage
                                case "DP_IMAGE":
                                    self.diVerify = "Y"
                                    self.verifyDI()
                                    self.dematDescriptionLabel.text =
                                    errorMessage
                                default:
                                    print("Unknown DocumentName")
                                }
                                
                                print("Retrying with OCRCount: \(ocrCount)")
                                // Retry API call if needed
                                // self.DocumentVerify(DocumentName: DocumentName, DocumentType: DocumentType)
                            } else {
                                switch DocumentName {
                                    
                                case "INCOMEPROOF":
                                    self.DerivativeImages_Verify =
                                    jsonResponse["DocumentImages_Verify"]
                                    as? String
                                    self.IPDocumentView.isHidden = true
                                    self.counts(shouldShow: true)
                                    self.ViewDocumentDetails()
                                    
                                case "BANK":
                                    self.BankImages_Verify =
                                    jsonResponse["DocumentImages_Verify"]
                                    as? String
                                    self.BPDocumentView.isHidden = true
                                    self.bpcounts(shouldShow: true)
                                    self.ViewDocumentDetails()
                                    
                                case "DP_IMAGE":
                                    self.diCounts(shouldShow: true)
                                    self.ViewDocumentDetails()
                                    
                                default:
                                    break
                                }
                                print("Maximum OCR attempts reached.")
                                
                            }
                        }
                    case "801006":
                        DispatchQueue.main.async {
                            
                            self.showAlert(
                                title: "Alert",
                                message: ErrorMessage
                                ?? "something error in reaching to server")
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
    
    func deleteImageFromServer(requestId: String, documentType: String, completion: @escaping (Bool) -> Void) {
        let parameters: [String: Any] = [
            "RegId": RegId ?? "",
            "PanNo": PanNo ?? "",
            "RequestId": requestId,
            "Documents": documentType
        ]
        
        let url = "ImageManagement/DeleteDocumentsImageOnRequestID"
        
        apiCall(url: url, method: "POST", parameters: parameters, view: self.view, loaderText: "Deleting Image...") { result in
            switch result {
            case .success(let jsonResponse):
                print("DeleteDocumentsImageOnRequestID Response: \(jsonResponse)")
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    if errorCode == "000000" {
                        completion(true)
                    } else {
                        print("Delete failed with error code: \(errorCode)")
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            case .failure(let error):
                print("Failed to delete image: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    //    func deleteImageFromServer(
    //        requestId: String, documentType: String,
    //        completion: @escaping (Bool) -> Void
    //    ) {
    //        let parameters: [String: Any?] = [
    //            "RegId": RegId,
    //            "PanNo": PanNo,
    //            "RequestId": requestId,
    //            "Documents": documentType,
    //        ]
    //
    //        let url = "ImageManagement/DeleteDocumentsImageOnRequestID"
    //        apiCall(
    //            url: url, method: "POST", parameters: parameters as [String: Any],
    //            view: self.view, loaderText: "Deleting Image..."
    //        ) { result in
    //            switch result {
    //            case .success(let jsonResponse):
    //                print(
    //                    "DeleteDocumentsImageOnRequestID Response: \(jsonResponse)")
    //                if let errorCode = jsonResponse["ErrorCode"] as? String,
    //                   errorCode == "000000"
    //                {
    //                    DispatchQueue.main.async { [self] in
    //                        switch documentType {
    //                        case "DERIVATIVE":
    //                            DispatchQueue.main.async {
    //                                self.counts(shouldShow: true)
    //                                self.showAlert(
    //                                    title: "Success",
    //                                    message: "Image deleted successfully.")
    //                            }
    //                        case "BANK":
    //                            DispatchQueue.main.async {
    //                                self.bpcounts(shouldShow: true)
    //                                BPStackview2.isHidden = false
    //                                self.showAlert(
    //                                    title: "Success",
    //                                    message: "Image bank deleted successfully.")
    //                            }
    //                        case "DP_IMAGE":
    //                            self.diCounts(shouldShow: true)
    //                            self.showAlert(
    //                                title: "Success",
    //                                message: "Image DP_IMAGE deleted successfully.")
    //                        default:
    //                            break
    //                        }
    //                        completion(true)  // Indicate success
    //                    }
    //                } else {
    //                    print("Unhandled error code: \(jsonResponse)")
    //                    completion(false)  // Indicate failure
    //                }
    //            case .failure(let error):
    //                print("Failed to delete image: \(error.localizedDescription)")
    //                completion(false)  // Indicate failure
    //            }
    //        }
    //    }
    
    func UpdateFinalStatus() {
        
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
                        self.UpdateFinalStatus()
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
                "PanNo": PanNo,
                "isTermsAndCondition": "true",
                // "UCCCode": ucccode,
                "isCommodityCategoriDone": "0",
                "CommodityCategoriValue": "",
                "CommodityCategoriKey": "",
                "DeviceType": "M",
            ]
            print(parameters)
            let Url = "ClientSLFinalStatus/UpdateFinalStatus"
            
            apiCall(
                url: Url, method: "POST",
                parameters: parameters as [String: Any], view: self.view,
                loaderText: "Kindly wait we are verifying your document..."
            ) { result in
                switch result {
                case .success(let jsonResponse):
                    print("UpdateFinalStatus Response: \(jsonResponse)")
                    let ErrorMessage = jsonResponse["ErrorMessage"] as? String
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            DispatchQueue.main.async {
                                let vc =
                                self.storyboard?.instantiateViewController(
                                    withIdentifier: "applicationDoneVC")
                                as! applicationDoneVC
                                vc.modalPresentationStyle = .overCurrentContext
                                vc.modalTransitionStyle = .crossDissolve
                                vc.delegate = self
                                self.present(vc, animated: true)
                            }
                        case "000001":
                            DispatchQueue.main.async {
                                self.showAlert(
                                    title: "Alert!", message: ErrorMessage ?? ""
                                )
                            }
                        case "111111":
                            DispatchQueue.main.async {
                                self.showAlert(
                                    title: "Alert!", message: ErrorMessage ?? ""
                                )
                            }
                        default:
                            print("Unhandled error code: \(errorCode)")
                        }
                    }
                case .failure(let error):
                    print(
                        "UpdateFinalStatus API call failed: \(error.localizedDescription)"
                    )
                }
            }
        }
    }
    
}

extension DocumentVC {
    //    func IncomeProof(shouldShow: Bool) {
    //        IPLabel1.isHidden = !shouldShow
    //        IpView1.isHidden = !shouldShow
    //        IPLabel2.isHidden = !shouldShow
    //        IPStackView1.isHidden = !shouldShow
    //        incomeProofmsg.isHidden = !shouldShow
    //        //IPStackView2.isHidden = !shouldShow
    //        IPCollectionView.isHidden = false
    //        //IPDocumentView.isHidden = !shouldShow
    //        if let documentType = incomeproofDocumenttype, !documentType.isEmpty {
    //            IPStackView2.isHidden = !shouldShow
    //        } else {
    //            IPStackView2.isHidden = true
    //        }
    //
    //        // Conditionally hide or show additional elements based on incomeproofDocumenttypetext
    //        if let documentTypeText = incomeproofDocumenttypetext,
    //           !documentTypeText.isEmpty,
    //           documentTypeText == "Latest ITR" || documentTypeText == "Form 16"
    //        {
    //
    //            // Show the relevant elements if conditions are met
    //            iplabel3.isHidden = !shouldShow
    //           // yearBtn.isHidden = !shouldShow
    //            // incomeProofVerifyBtn.isHidden = !shouldShow // Uncomment if needed
    //        } else {
    //            // Hide the elements if conditions are not met
    //            iplabel3.isHidden = true
    //            yearBtn.isHidden = true
    //            // incomeProofVerifyBtn.isHidden = true // Uncomment if needed
    //        }
    //
    //        // New condition to check imageUrls count and set visibility for IPCollectionView and IPDocumentView
    //        self.counts(shouldShow: shouldShow)
    //        if imageUrls.isEmpty {
    //            IPCollectionView.isHidden = true
    //            IPDocumentView.isHidden = true
    //        } else {
    //            IPCollectionView.isHidden = !shouldShow
    //            IPDocumentView.isHidden = !shouldShow
    //        }
    //        if ipverify == "Y" {
    //            self.verifyIP()
    //        }
    //
    //        if DerivativeImages_Verify == "0" {
    //            print("varify is pending")
    //        } else {
    //            IPDocumentView.isHidden = true
    //        }
    //    }
    
    func IncomeProof(shouldShow: Bool) {
        
        IPLabel1.isHidden = !shouldShow
        IpView1.isHidden = !shouldShow
        IPLabel2.isHidden = !shouldShow
        IPStackView1.isHidden = !shouldShow
        incomeProofmsg.isHidden = !shouldShow
        
        // StackView2 logic
        if let documentType = incomeproofDocumenttype, !documentType.isEmpty {
            IPStackView2.isHidden = !shouldShow
        } else {
            IPStackView2.isHidden = true
        }
        
        // Document type condition
        if let documentTypeText = incomeproofDocumenttypetext,
           documentTypeText == "Latest ITR" || documentTypeText == "Form 16" {
            
            iplabel3.isHidden = !shouldShow
            yearBtn.isHidden = !shouldShow
        } else {
            iplabel3.isHidden = true
            yearBtn.isHidden = true
        }
        
        // Collection view visibility
        if imageUrls.isEmpty {
            IPCollectionView.isHidden = true
            IPDocumentView.isHidden = true
        } else {
            IPCollectionView.isHidden = false
            IPDocumentView.isHidden = false
        }
        
        // Verification logic
        if ipverify == "Y" {
            self.verifyIP()
        }
        //        if DerivativeImages_Verify != "0" {
        //            IPDocumentView.isHidden = false
        //        }
        //        if !imageUrls.isEmpty {
        //               IPCollectionView.isHidden = false
        //               IPDocumentView.isHidden = false
        //           }
    }
    
    func counts(shouldShow: Bool) {
        switch incomeproofDocumenttype {
        case "PDF":
            DispatchQueue.main.async { [self] in
                let requiredCount: Int
                if incomeproofDocumenttypetext == "Salary Slip" || incomeproofDocumenttypetext == "Six Month Bank Statement" || incomeproofDocumenttypetext == "Form 16" || incomeproofDocumenttypetext == "Latest ITR" || incomeproofDocumenttypetext == "Demat Account Holding with Value"{
                    requiredCount = 1
                } else {
                    requiredCount = 2
                }
                
                if imageUrls.count >= requiredCount {
                    incomeProofuploadBtn.isHidden = (incomeproofDocumenttypetext == "Salary Slip" || incomeproofDocumenttypetext == "Six Month Bank Statement" || incomeproofDocumenttypetext == "Form 16" || incomeproofDocumenttypetext == "Latest ITR" || incomeproofDocumenttypetext == "Demat Account Holding with Value")
                    self.incomeProofDocumentTypeBtn.isEnabled = false
                    self.incomeProofYearBtn.isEnabled = false
                    incomeProofNoBtn.isEnabled = false
                    incomeProofYesBtn.isEnabled = true
                    IPCollectionView.isHidden = !shouldShow
                    
                    if DerivativeImages_Verify != "0" {
                        incomeProofVerifyBtn.isHidden = true
                    } else {
                        incomeProofVerifyBtn.isHidden = false
                    }
                } else if imageUrls.isEmpty {
                    incomeProofuploadBtn.isHidden = false
                    IPCollectionView.isHidden = true
                    IPDocumentView.isHidden = true
                    self.incomeProofDocumentTypeBtn.isEnabled = true
                    self.incomeProofYearBtn.isEnabled = true
                    incomeProofNoBtn.isEnabled = true
                    incomeProofYesBtn.isEnabled = true
                    incomeProofVerifyBtn.isHidden = true  // Always hide Verify button when no images are present
                } else {
                    IPStackView2.isHidden = !shouldShow
                    incomeProofuploadBtn.isHidden = false
                    incomeProofVerifyBtn.isHidden = true  // Hide Verify button when count is less than required
                    if DerivativeImages_Verify != "0" {
                        incomeProofVerifyBtn.isHidden = true
                    } else {
                        incomeProofVerifyBtn.isHidden = false
                    }
                    self.incomeProofDocumentTypeBtn.isEnabled = false
                    incomeProofNoBtn.isEnabled = false
                }
            }
        case "IMAGE":
            DispatchQueue.main.async { [self] in
                if imageUrls.count >= 5 {
                    IPStackView2.isHidden = true
                    incomeProofVerifyBtn.isHidden = false
                    incomeProofuploadBtn.isHidden = true
                } else if imageUrls.isEmpty {
                    IPCollectionView.isHidden = true
                    IPDocumentView.isHidden = true
                    self.incomeProofDocumentTypeBtn.isEnabled = true
                    self.incomeProofYearBtn.isEnabled = true
                    incomeProofNoBtn.isEnabled = true
                    incomeProofYesBtn.isEnabled = true
                } else {
                    incomeProofuploadBtn.isHidden = false
                    IPStackView2.isHidden = !shouldShow
                    incomeProofVerifyBtn.isHidden = false
                    self.incomeProofDocumentTypeBtn.isEnabled = false
                    self.incomeProofYearBtn.isEnabled = false
                    incomeProofNoBtn.isEnabled = true
                    incomeProofYesBtn.isEnabled = false
                }
            }
        default:
            break
        }
    }
    func verifyIP() {
        //self.incomeProofuploadBtn.isHidden = true
        
        self.IPStackView2.isHidden = false
        
        self.incomeproofStatusLabel.isHidden = false
    }
    
    func BankProof(shouldShow: Bool) {
        BPLabel1.isHidden = !shouldShow
        BPView1.isHidden = !shouldShow
        BPlabel2.isHidden = !shouldShow
        BPStackview1.isHidden = !shouldShow
        BPStackview2.isHidden = !shouldShow
        bankMsg.isHidden = !shouldShow
        if let documentType = bankproofDocumentType, !documentType.isEmpty {
            BPStackview2.isHidden = !shouldShow
        } else {
            BPStackview2.isHidden = true
        }
        
        self.bpcounts(shouldShow: shouldShow)
        if bpImageUrls.isEmpty {
            BpCollectionView.isHidden = true
            BPDocumentView.isHidden = true
        } else {
            BpCollectionView.isHidden = !shouldShow
            BPDocumentView.isHidden = !shouldShow
        }
        if bpverify == "Y" {
            self.verifyBP()
        }
        
        if BankImages_Verify == "0" {
            
            print("varify is pending")
        } else {
            BPDocumentView.isHidden = true
        }
    }
    
    func bpcounts(shouldShow: Bool) {
        print("documenttype:-\(bankproofDocumentType ?? "empty")")
        switch bankproofDocumentType {
        case "PDF":
            DispatchQueue.main.async { [self] in
                if bpImageUrls.count >= 1 {
                    BANKPROOFBTN.isHidden = true
                    bankProofVerifyBtn.isHidden = true
                    self.BankProofDocumentTypeBtn.isEnabled = false
                    BankProofNoBtn.isEnabled = false
                    BankProofYesBtn.isEnabled = true
                } else if bpImageUrls.isEmpty {
                    BpCollectionView.isHidden = true
                    BPDocumentView.isHidden = true
                    BANKPROOFBTN.isHidden = false
                    self.BankProofDocumentTypeBtn.isEnabled = true
                    BankProofNoBtn.isEnabled = true
                    BankProofYesBtn.isEnabled = true
                    BANKPROOFBTN.isHidden = false
                } else {
                    BPStackview2.isHidden = false
                    bankProofVerifyBtn.isHidden = true
                    BANKPROOFBTN.isHidden = false
                }
            }
        case "IMAGE":
            DispatchQueue.main.async { [self] in
                if bpImageUrls.count >= 5 {
                    BPStackview2.isHidden = true
                    bankProofVerifyBtn.isHidden = false
                } else if bpImageUrls.isEmpty {
                    BpCollectionView.isHidden = true
                    BPDocumentView.isHidden = true
                    self.BankProofDocumentTypeBtn.isEnabled = true
                    BankProofNoBtn.isEnabled = true
                    BankProofYesBtn.isEnabled = true
                    BANKPROOFBTN.isHidden = false
                } else {
                    BPStackview2.isHidden = !shouldShow
                    self.BankProofDocumentTypeBtn.isEnabled = false
                    BankProofNoBtn.isEnabled = true
                    BankProofYesBtn.isEnabled = false
                    bankProofVerifyBtn.isHidden = false
                }
            }
        default:
            break
        }
    }
    func verifyBP() {
        BPStackview2.isHidden = false
        
        self.BPdescriptionLabel.isHidden = false
    }
    
    func CurrentSignature(shouldShow: Bool) {
        CSLabel1.isHidden = !shouldShow
        
        // Check if signature exists and is verified from the API response
        if let signatureVerifyStatus = SignatureImage_Verify {
            // Signature has been uploaded and has a status (1 = approved, 2 = rejected, etc.)
            if signatureVerifyStatus == "0" {
                // Pending verification - show upload buttons
                CSStackView1.isHidden = false
                CSDocumentView.isHidden = true
            } else {
                // Already uploaded (verified or rejected) - show the image
                CSStackView1.isHidden = true
                CSDocumentView.isHidden = !shouldShow
            }
        } else {
            // No signature uploaded yet - show upload buttons
            CSStackView1.isHidden = !shouldShow
            CSDocumentView.isHidden = true
        }
    }
    
    //    func CurrentSignature(shouldShow: Bool) {
    //        CSLabel1.isHidden = !shouldShow
    //        //        CSStackView1.isHidden = !shouldShow
    //        // CsCollectionView.isHidden = !shouldShow
    //        //CSDocumentView.isHidden = !shouldShow
    //        if SignatureImage_Verify == nil {
    //            print("varify is pending")
    //            CSDocumentView.isHidden = true
    //            CSStackView1.isHidden = !shouldShow
    //        } else {
    //            CSDocumentView.isHidden = !shouldShow
    //            CSStackView1.isHidden = true
    //        }
    //        //        if panCopyDocumentType == ""{
    //        //            CSStackView1.isHidden = true
    //        //        }else{
    //        //            CSStackView1.isHidden = !shouldShow
    //        //        }
    //    }
    func PANCopy(shouldShow: Bool) {
        PCLabel1.isHidden = !shouldShow
        PCLabel2.isHidden = !shouldShow
        PCLabel3.isHidden = !shouldShow
        panMsg.isHidden = !shouldShow
        //PCLabel4.isHidden = !shouldShow
        //PCStackView1.isHidden = !shouldShow
        //PCStackView.isHidden = !shouldShow
        //PCcollectionView.isHidden = !shouldShow
        //PCHolderView.isHidden = !shouldShow
        //        if let documentType = self.panCopyDocumentType, !documentType.isEmpty {
        //            PCStackView.isHidden = !shouldShow
        //            } else {
        //                PCStackView.isHidden = true
        //
        //               // PCStackView.isHidden = !shouldShow
        //            }
        if PANImage_Verify == nil {
            print("varify is pending")
            PCHolderView.isHidden = true
            
            PCStackView.isHidden = !shouldShow
        } else if rejection == "Rejection" {
            PCHolderView.isHidden = !shouldShow
            
            PCStackView.isHidden = true
            //
        } else {
            PCHolderView.isHidden = !shouldShow
            //            //PANCopyBtn.isHidden = true
            
            PCStackView.isHidden = true
        }
        //        if PANImage_Verify == nil{
        //            PCStackView.isHidden = false
        //        }else {
        //            PCStackView.isHidden = true
        //        }
        
    }
    func ClientPhoto(shouldShow: Bool) {
        CPLabel1.isHidden = !shouldShow
        //CPLabel2.isHidden = !shouldShow
        //CPLabel3.isHidden = !shouldShow
        //CPStackView.isHidden = !shouldShow
        
        //        CPImageView.isHidden = !shouldShow
        //        CP_Long_Lat_Lbl.isHidden = !shouldShow
        //        CpHolderView2.isHidden = !shouldShow
        print("ClientPhotoImageID_Verify", ClientPhotoImageID_Verify)
        if ClientPhotoImageID_Verify == nil {
            CPHolderView1.isHidden = true
            CPStackView.isHidden = !shouldShow
        } else {
            CPStackView.isHidden = true
            CPHolderView1.isHidden = !shouldShow
            CPImageView.isHidden = !shouldShow
            CP_Long_Lat_Lbl.isHidden = !shouldShow
            CpHolderView2.isHidden = !shouldShow
            CP_Location_label.isHidden = !shouldShow
            //CPStackView.isHidden = !shouldShow
        }
    }
    func DematImage(shouldShow: Bool) {
        DILabel1.isHidden = !shouldShow
        DILabel2.isHidden = !shouldShow
        DIStackView1.isHidden = !shouldShow
        //        DIStackView2.isHidden = !shouldShow
        //        DICollectionView.isHidden = !shouldShow
        //        DIDocumentView.isHidden = !shouldShow
        if let documentType = dematDocumentType, !documentType.isEmpty {
            DIStackView2.isHidden = !shouldShow
        } else {
            DIStackView2.isHidden = true
        }
        
        self.diCounts(shouldShow: shouldShow)
        if dematimageUrls.isEmpty {
            DICollectionView.isHidden = true
            DIDocumentView.isHidden = true
        } else {
            DICollectionView.isHidden = !shouldShow
            DIDocumentView.isHidden = !shouldShow
        }
        if diVerify == "Y" {
            self.verifyDI()
        }
        if dematimageUrls.isEmpty {
            DICollectionView.isHidden = true
            DIDocumentView.isHidden = true
        } else {
            DICollectionView.isHidden = false
            DIDocumentView.isHidden = false
        }
        
        if diVerify == "Y" {
            self.verifyDI()
        }
        if DP_IMAGEID_Verify != 0 {
            DispatchQueue.main.async {
                self.DematImageVerifyBtn.isHidden = true
            }
        }
        
    }
    func diCounts(shouldShow: Bool) {
        switch dematDocumentType {
        case "PDF":
            DispatchQueue.main.async { [self] in
                if dematimageUrls.count >= 1 {
                    DematImgBtn.isHidden = true
                    DIStackView2.isHidden = true
                    if DP_IMAGEID_Verify == 0 {
                        DematImageVerifyBtn.isHidden = false
                    } else {
                        DematImageVerifyBtn.isHidden = true  // ✅ Hide when verified
                    }
                    
                    dematNoBtn.isEnabled = false
                    dematYesBtn.isEnabled = true
                } else if dematimageUrls.isEmpty {
                    DICollectionView.isHidden = true
                    DIDocumentView.isHidden = true
                    dematNoBtn.isEnabled = true
                    dematYesBtn.isEnabled = true
                    DematImgBtn.isHidden = false
                    DematImageVerifyBtn.isHidden = true
                } else {
                    DIStackView2.isHidden = !shouldShow
                    
                    // Only show verify button if not already verified
                    if DP_IMAGEID_Verify == 0 {
                        DematImageVerifyBtn.isHidden = false
                    } else {
                        DematImageVerifyBtn.isHidden = true
                    }
                }
            }
        case "IMAGE":
            DispatchQueue.main.async { [self] in
                if dematimageUrls.count >= 5 {
                    DIStackView2.isHidden = true
                    DematImageVerifyBtn.isHidden = false
                    
                    if DP_IMAGEID_Verify == 0 {
                        DematImageVerifyBtn.isHidden = false
                    } else {
                        DematImageVerifyBtn.isHidden = true
                    }
                } else if dematimageUrls.isEmpty {
                    DICollectionView.isHidden = true
                    DIDocumentView.isHidden = true
                    dematNoBtn.isEnabled = true
                    dematYesBtn.isEnabled = true
                    DematImgBtn.isHidden = false
                    DematImageVerifyBtn.isHidden = true
                } else {
                    DIStackView2.isHidden = !shouldShow
                    
                    // Only show verify button if not already verified
                    if DP_IMAGEID_Verify == 0 {
                        DematImageVerifyBtn.isHidden = false
                    } else {
                        DematImageVerifyBtn.isHidden = true
                    }
                    
                    dematNoBtn.isEnabled = true
                    dematYesBtn.isEnabled = false
                }
            }
        default:
            break
        }
    }
    func verifyDI() {
        //self.incomeProofuploadBtn.isHidden = true
        
        self.DIStackView2.isHidden = false
        
        self.dematDescriptionLabel.isHidden = false
    }
    
    func NomineeDetail1(shouldShow: Bool) {
        NM1Label1.isHidden = !shouldShow
        NM1Label2.isHidden = !shouldShow
        NM1view1.isHidden = !shouldShow
        NM1View2.isHidden = !shouldShow
        //NM1StackView.isHidden = !shouldShow
        //NM1CollectionView.isHidden = !shouldShow
        //NM1DocumentView.isHidden = !shouldShow
        if nominee1ImagesVerify == nil {
            NM1StackView.isHidden = !shouldShow
            NM1DocumentView.isHidden = true
        } else {
            NM1DocumentView.isHidden = !shouldShow
            NM1StackView.isHidden = true
            
        }
        // NM1DocumentView.isHidden = false
    }
    func NomineeDetail2(shouldShow: Bool) {
        NM2Label1.isHidden = !shouldShow
        NM2Label2.isHidden = !shouldShow
        NM2view1.isHidden = !shouldShow
        NM2View2.isHidden = !shouldShow
        //NM2StackView.isHidden = !shouldShow
        //NM2CollectionView.isHidden = !shouldShow
        //NM2DocumentView.isHidden = !shouldShow
        if nominee2ImagesVerify == nil {
            NM2StackView.isHidden = !shouldShow
            NM2DocumentView.isHidden = true
        } else {
            NM2DocumentView.isHidden = !shouldShow
            NM2StackView.isHidden = true
            
        }
        
    }
    func NomineeDetail3(shouldShow: Bool) {
        NM3Label1.isHidden = !shouldShow
        NM3Label2.isHidden = !shouldShow
        NM3view1.isHidden = !shouldShow
        NM3View2.isHidden = !shouldShow
        //NM3StackView.isHidden = !shouldShow
        //NM3CollectionView.isHidden = !shouldShow
        //NM3DocumentView.isHidden = !shouldShow
        if nominee3ImagesVerify == nil {
            NM3StackView.isHidden = !shouldShow
            NM3DocumentView.isHidden = true
        } else {
            NM3DocumentView.isHidden = !shouldShow
            NM3StackView.isHidden = true
            
        }
    }
}

extension DocumentVC {
    func openPDFPicker() {
        let documentPicker = UIDocumentPickerViewController(
            documentTypes: [kUTTypePDF as String], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(
        _ controller: UIDocumentPickerViewController,
        didPickDocumentsAt urls: [URL]
    ) {
        guard let selectedURL = urls.first else { return }
        
        do {
            // Check if the PDF is password-protected
            if let pdfDocument = PDFDocument(url: selectedURL) {
                if pdfDocument.isEncrypted {
                    // Prompt for password
                    requestPassword { [weak self] password in
                        guard let self = self else { return }
                        
                        if pdfDocument.unlock(withPassword: password) {
                            // Successfully unlocked PDF
                            self.handlePDF(url: selectedURL, password: password)
                        } else {
                            // Invalid password
                            self.showAlert(
                                title: "Error",
                                message: "Invalid password for the PDF.")
                        }
                    }
                } else {
                    // Handle non-password-protected PDF
                    handlePDF(url: selectedURL, password: "")
                }
            } else {
                showAlert(title: "Error", message: "Unable to read PDF file.")
            }
        } catch {
            showAlert(title: "Error", message: "Unable to read PDF file.")
        }
    }
    
    func handlePDF(url: URL, password: String?) {
        do {
            let pdfData = try Data(contentsOf: url)
            let byteArray = [UInt8](pdfData)
            uploadPDFByteArray(byteArray, password: password)
        } catch {
            showAlert(title: "Error", message: "Unable to read PDF file.")
        }
    }
    
    func requestPassword(completion: @escaping (String) -> Void) {
        let alertController = UIAlertController(
            title: "Enter Password",
            message:
                "This PDF is password-protected. Please enter the password to unlock it.",
            preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            _ in
            let password = alertController.textFields?.first?.text ?? ""
            completion(password)
        }
        let cancelAction = UIAlertAction(
            title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(
        _ controller: UIDocumentPickerViewController
    ) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func uploadPDFByteArray(_ byteArray: [UInt8], password: String?) {
        let pdfData = Data(byteArray)
        // let identifier = "IncomeProof" // Adjust this as needed
        
        switch identifier {
        case "IncomeProof":
            DerivativeUpload(imageData: pdfData, password: password)
        case "BankProof":
            BankUpload(imageData: pdfData, password: password)
        case "Demat":
            dematUpload(imageData: pdfData, password: password)
        case "PanCopy":
            PANUpload(imageData: pdfData, password: password)
        default:
            break
        }
    }
}

extension DocumentVC {
    
    func loadImage(
        from urlString: String, into imageView: UIImageView,
        with identifier: String?
    ) {
        // Check the cache for the image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async {
                imageView.image = cachedImage
            }
            return
        }
        
        // Reset the image view to a placeholder while loading
        DispatchQueue.main.async {
            imageView.image = UIImage(named: "pdf")
            // imageView.image = UIImage(systemName: "pdf") // Placeholder image
        }
        
        // Fetch a fresh token each time for every image load request
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
            tokenId in
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W", in: self.view
                ) { success in
                    if success {
                        // Call SIXTHAPI after tokenMobile API call is successful
                        self.loadImage(from: urlString, into: imageView, with: identifier)
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            
            // Construct the final URL with the token
            guard
                let completeUrl = URL(
                    string: urlString.replacingOccurrences(
                        of: "{tokenId}", with: tokenId))
            else {
                print("Invalid URL after inserting token.")
                return
            }
            
            // Create a data task to download the image
            let task = URLSession.shared.dataTask(with: completeUrl) {
                data, response, error in
                if let error = error {
                    print(
                        "Failed to download image: \(error.localizedDescription)"
                    )
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse,
                   !(200...299).contains(httpResponse.statusCode)
                {
                    print("Invalid status code: \(httpResponse.statusCode)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    // Cache the image
                    self.imageCache.setObject(
                        image, forKey: urlString as NSString)
                    
                    DispatchQueue.main.async {
                        // Ensure the image is set only if the identifier matches
                        if let imageViewIdentifier = imageView
                            .restorationIdentifier,
                           imageViewIdentifier == identifier
                        {
                            imageView.image = image
                            print(
                                "Updated image for identifier: \(imageViewIdentifier)"
                            )
                        } else {
                            print(
                                "Mismatch in identifiers or nil identifier for image view."
                            )
                        }
                    }
                } else {
                    print("Failed to create image from data.")
                }
            }
            task.resume()
        }
    }
    
}

//colection view
extension DocumentVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == incomeProofCollectionView {
            return imageUrls.count
        } else if collectionView == BpCollectionView {
            return bpImageUrls.count
        } else if collectionView == DICollectionView {
            return dematimageUrls.count
        }
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell =
        collectionView.dequeueReusableCell(
            withReuseIdentifier: "incomeCVC", for: indexPath) as! incomeCVC
        
        let imageUrlString: String
        if collectionView == incomeProofCollectionView {
            imageUrlString = imageUrls[indexPath.row]
            print("DerivativeImages_Verify: \(DerivativeImages_Verify)")
//            if rejection2 == "Rejection", DerivativeImages_Verify == "2"{
//                cell.deleteButton.isHidden = false  // Show button
//            } else if rejection2 == "Rejection"
//                        || DerivativeImages_Verify != "0"
//            {
//                cell.deleteButton.isHidden = true  // Hide button
//            } else if rejection2 == nil && DerivativeImages_Verify != "0" {
//                cell.deleteButton.isHidden = true  // Hide button
//            } else {
//                cell.deleteButton.isHidden = false  // Default case
//            }
            
            if DerivativeImages_Verify == "1" {
                       // Already verified/approved - hide delete button
                       cell.deleteButton.isHidden = true
                   } else if rejection2 == "Rejection" && DerivativeImages_Verify == "2" {
                       // Rejected in rejection flow - show delete button
                       cell.deleteButton.isHidden = false
                   } else if DerivativeImages_Verify == "0" || DerivativeImages_Verify == nil {
                       // Pending verification or just uploaded - show delete button
                       cell.deleteButton.isHidden = false
                   } else {
                       // Any other case - hide delete button
                       cell.deleteButton.isHidden = true
                   }
            
        } else if collectionView == BpCollectionView {
            imageUrlString = bpImageUrls[indexPath.row]
            if rejection1 == "Rejection", BankImages_Verify == "2" {
                cell.deleteButton.isHidden = false  // Show button
            } else if rejection1 == "Rejection" || BankImages_Verify != "0" {
                cell.deleteButton.isHidden = true  // Hide button
            } else if rejection1 == nil && BankImages_Verify != "0" {
                cell.deleteButton.isHidden = true  // Hide button
            } else {
                cell.deleteButton.isHidden = false  // Default case
            }
            
            //cell.deleteButton.isHidden = !(BankImages_Verify == "0" || BankImages_Verify == nil)
        } else if collectionView == DICollectionView {
            imageUrlString = dematimageUrls[indexPath.row]
            print("DP_IMAGEID_Verify: \(DP_IMAGEID_Verify)")
            if rejection3 == "Rejection", DP_IMAGEID_Verify == 2 {
                cell.deleteButton.isHidden = false  // Show button
            } else if rejection3 == "Rejection" || DP_IMAGEID_Verify != 0 {
                cell.deleteButton.isHidden = true  // Hide button
            } else if rejection3 == nil && DP_IMAGEID_Verify != 0 {
                cell.deleteButton.isHidden = true  // Hide button
            } else {
                cell.deleteButton.isHidden = false  // Default case
            }
            //cell.deleteButton.isHidden = !(DP_IMAGEID_Verify == 0 || DP_IMAGEID_Verify == nil)
        } else {
            imageUrlString = ""  // Fallback if needed
        }
        
        // Set the delegate, indexPath, and parent collection view
        cell.delegate = self
        cell.indexPath = indexPath
        cell.parentCollectionView = collectionView
        
        cell.imageview.restorationIdentifier = imageUrlString
        loadImage(
            from: imageUrlString, into: cell.imageview, with: imageUrlString)
        
        return cell
    }
    
    //    func didTapDeleteButton(
    //        at indexPath: IndexPath, in collectionView: UICollectionView
    //    ) {
    //        if collectionView == incomeProofCollectionView {
    //            // Handle deletion for incomeProofCollectionView
    //            if indexPath.row < imageUrls.count {
    //                imageUrls.remove(at: indexPath.row)
    //                //DerivativeImages_Verify = "0"
    //                DispatchQueue.main.async {
    //                    self.incomeProofCollectionView.reloadData()
    //                    self.showAlert(title: "Deleted", message: "Income proof image removed successfully.")
    //                }
    //                print("Locally deleted image at index: \(indexPath.row) from incomeProofCollectionView")
    //            }
    //        } else if collectionView == BpCollectionView {
    //        // Handle deletion for BpCollectionView
    //        if indexPath.row < bpImageUrls.count {
    //            bpImageUrls.remove(at: indexPath.row)
    //           // BankImages_Verify = "0"
    //            DispatchQueue.main.async {
    //                self.BpCollectionView.reloadData()
    //                self.showAlert(title: "Deleted", message: "Bank proof image removed successfully.")
    //            }
    //            print("Locally deleted image at index: \(indexPath.row) from BpCollectionView")
    //        }
    //    } else if collectionView == DICollectionView {
    //        // Handle deletion for DICollectionView
    //        if indexPath.row < dematimageUrls.count {
    //            dematimageUrls.remove(at: indexPath.row)
    //           // DP_IMAGEID_Verify = 0
    //            DispatchQueue.main.async {
    //                self.DICollectionView.reloadData()
    //                self.showAlert(title: "Deleted", message: "Demat image removed successfully.")
    //            }
    //            print("Locally deleted image at index: \(indexPath.row) from DICollectionView")
    //        }
    //    }
    //}
//    func didTapDeleteButton(at indexPath: IndexPath, in collectionView: UICollectionView) {
//        var imageUrlString: String?
//        var documentType: String?
//        var documentVerifyStatus: Any?
//        
//        // Get the image URL and document type based on collection view
//        if collectionView == incomeProofCollectionView {
//            guard indexPath.row < imageUrls.count else { return }
//            imageUrlString = imageUrls[indexPath.row]
//            documentType = "DERIVATIVE"
//            documentVerifyStatus = DerivativeImages_Verify
//        } else if collectionView == BpCollectionView {
//            guard indexPath.row < bpImageUrls.count else { return }
//            imageUrlString = bpImageUrls[indexPath.row]
//            documentType = "BANK"
//            documentVerifyStatus = BankImages_Verify
//        } else if collectionView == DICollectionView {
//            guard indexPath.row < dematimageUrls.count else { return }
//            imageUrlString = dematimageUrls[indexPath.row]
//            documentType = "DP_IMAGE"
//            documentVerifyStatus = DP_IMAGEID_Verify
//        }
//        
//        guard let urlString = imageUrlString, let docType = documentType else { return }
//        
//        // Check if we're in rejection flow and the document is rejected (status = "2")
//        let shouldDeleteFromServer: Bool
//        
//        if rejection == "Rejection" {
//            if let stringStatus = documentVerifyStatus as? String {
//                shouldDeleteFromServer = (stringStatus == "2")
//            } else if let intStatus = documentVerifyStatus as? Int {
//                shouldDeleteFromServer = (intStatus == 2)
//            } else {
//                shouldDeleteFromServer = false
//            }
//        } else {
//            shouldDeleteFromServer = false
//        }
//        
//        if shouldDeleteFromServer {
//            // Extract RequestID and delete from server
//            guard let requestId = extractRequestId(from: urlString) else {
//                print("Failed to extract RequestID from URL")
//                return
//            }
//            
//            // Show confirmation alert before deleting
//            let alert = UIAlertController(
//                title: "Delete Document",
//                message: "Are you sure you want to delete this document? This will permanently remove it from the server.",
//                preferredStyle: .alert
//            )
//            
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
//                self?.deleteImageFromServer(requestId: requestId, documentType: docType) { success in
//                    if success {
//                        DispatchQueue.main.async {
//                            self?.removeImageLocally(at: indexPath, in: collectionView)
//                            self?.resetDocumentUIAfterDelete(documentType: docType)
//                            self?.showAlert(title: "Success", message: "Document deleted successfully.")
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            self?.showAlert(title: "Error", message: "Failed to delete document. Please try again.")
//                        }
//                    }
//                }
//            })
//            
//            present(alert, animated: true)
//        } else {
//            // For non-rejection flow or non-rejected documents, just remove locally
//            removeImageLocally(at: indexPath, in: collectionView)
//            resetDocumentUIAfterDelete(documentType: docType)
//            showAlert(title: "Deleted", message: "Image removed locally.")
//        }
//    }
    
//    func resetDocumentUIAfterDelete(documentType: String) {
//        switch documentType {
//        case "DERIVATIVE":
//            // Reset Income Proof UI
//            DispatchQueue.main.async { [self] in
//                // Reset verification status
//                DerivativeImages_Verify = nil
//                ipverify = nil
//                
//                // Show upload button
//                incomeProofuploadBtn.isHidden = false
//                
//                // Hide verify button until new upload
//                incomeProofVerifyBtn.isHidden = true
//                
//                // Reset document type button state
//                incomeProofDocumentTypeBtn.isEnabled = true
//                incomeProofYearBtn.isEnabled = true
//                
//                // Reset PDF/Image buttons
//                incomeProofNoBtn.isEnabled = true
//                incomeProofYesBtn.isEnabled = true
//                
//                // Show stack views again
//                IPStackView2.isHidden = false
//                
//                // Hide collection view if no images left
//                if imageUrls.isEmpty {
//                    IPCollectionView.isHidden = true
//                    IPDocumentView.isHidden = true
//                }
//                
//                // Reset status label
//                incomeproofStatusLabel.isHidden = true
//                incomeproofStatusLabel.text = ""
//                
//                // Reload collection view
//                incomeProofCollectionView.reloadData()
//                
//                // Refresh from server to get updated status
//                ViewDocumentDetails()
//            }
//            
//        case "BANK":
//            // Reset Bank Proof UI
//            DispatchQueue.main.async { [self] in
//                // Reset verification status
//                BankImages_Verify = nil
//                bpverify = nil
//                
//                // Show upload button
//                BANKPROOFBTN.isHidden = false
//                
//                // Hide verify button until new upload
//                bankProofVerifyBtn.isHidden = true
//                
//                // Reset document type button state
//                BankProofDocumentTypeBtn.isEnabled = true
//                
//                // Reset PDF/Image buttons
//                BankProofNoBtn.isEnabled = true
//                BankProofYesBtn.isEnabled = true
//                
//                // Show stack views again
//                BPStackview2.isHidden = false
//                
//                // Hide collection view if no images left
//                if bpImageUrls.isEmpty {
//                    BpCollectionView.isHidden = true
//                    BPDocumentView.isHidden = true
//                }
//                
//                // Reset description label
//                BPdescriptionLabel.isHidden = true
//                BPdescriptionLabel.text = ""
//                
//                // Reload collection view
//                BpCollectionView.reloadData()
//                
//                // Refresh from server to get updated status
//                ViewDocumentDetails()
//            }
//            
//        case "DP_IMAGE":
//            // Reset Demat UI
//            DispatchQueue.main.async { [self] in
//                // Reset verification status
//                DP_IMAGEID_Verify = nil
//                diVerify = nil
//                
//                // Show upload button
//                DematImgBtn.isHidden = false
//                
//                // Hide verify button until new upload
//                DematImageVerifyBtn.isHidden = true
//                
//                // Reset PDF/Image buttons
//                dematNoBtn.isEnabled = true
//                dematYesBtn.isEnabled = true
//                
//                // Show stack views again
//                DIStackView2.isHidden = false
//                
//                // Hide collection view if no images left
//                if dematimageUrls.isEmpty {
//                    DICollectionView.isHidden = true
//                    DIDocumentView.isHidden = true
//                }
//                
//                // Reset description label
//                dematDescriptionLabel.isHidden = true
//                dematDescriptionLabel.text = ""
//                
//                // Reload collection view
//                DICollectionView.reloadData()
//                
//                // Refresh from server to get updated status
//                ViewDocumentDetails()
//            }
//            
//        default:
//            break
//        }
//    }
    
    // Helper function to remove image locally
//    func removeImageLocally(at indexPath: IndexPath, in collectionView: UICollectionView) {
//        if collectionView == incomeProofCollectionView {
//            imageUrls.remove(at: indexPath.row)
//            if imageUrls.isEmpty {
//                DerivativeImages_Verify = nil
//                incomeProofuploadBtn.isHidden = false
//                IPCollectionView.isHidden = true
//                IPDocumentView.isHidden = true
//            }
//            DispatchQueue.main.async {
//                self.incomeProofCollectionView.reloadData()
//            }
//        } else if collectionView == BpCollectionView {
//            bpImageUrls.remove(at: indexPath.row)
//            if bpImageUrls.isEmpty {
//                BankImages_Verify = nil
//                BANKPROOFBTN.isHidden = false
//                BpCollectionView.isHidden = true
//                BPDocumentView.isHidden = true
//            }
//            DispatchQueue.main.async {
//                self.BpCollectionView.reloadData()
//            }
//        } else if collectionView == DICollectionView {
//            dematimageUrls.remove(at: indexPath.row)
//            if dematimageUrls.isEmpty {
//                DP_IMAGEID_Verify = nil
//                DematImgBtn.isHidden = false
//                DICollectionView.isHidden = true
//                DIDocumentView.isHidden = true
//            }
//            DispatchQueue.main.async {
//                self.DICollectionView.reloadData()
//            }
//        }
//    }
    
    func didTapDeleteButton(at indexPath: IndexPath, in collectionView: UICollectionView) {
        var imageUrlString: String?
        var documentType: String?
        var documentVerifyStatus: Any?
        
        // Get the image URL and document type based on collection view
        if collectionView == incomeProofCollectionView {
            guard indexPath.row < imageUrls.count else { return }
            imageUrlString = imageUrls[indexPath.row]
            documentType = "DERIVATIVE"
            documentVerifyStatus = DerivativeImages_Verify
        } else if collectionView == BpCollectionView {
            guard indexPath.row < bpImageUrls.count else { return }
            imageUrlString = bpImageUrls[indexPath.row]
            documentType = "BANK"
            documentVerifyStatus = BankImages_Verify
        } else if collectionView == DICollectionView {
            guard indexPath.row < dematimageUrls.count else { return }
            imageUrlString = dematimageUrls[indexPath.row]
            documentType = "DP_IMAGE"
            documentVerifyStatus = DP_IMAGEID_Verify
        }
        
        guard let urlString = imageUrlString, let docType = documentType else { return }
        
        // Show confirmation alert before deleting
        let alert = UIAlertController(
            title: "Delete Document",
            message: "Are you sure you want to delete this document?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            // Extract RequestID from URL
            if let requestId = self.extractRequestId(from: urlString) {
                // Delete from server
                self.deleteImageFromServer(requestId: requestId, documentType: docType) { success in
                    DispatchQueue.main.async {
                        if success {
                            // Remove from local array and refresh from server
                            self.removeImageLocally(at: indexPath, in: collectionView)
                            self.resetDocumentUIAfterDelete(documentType: docType)
                            // Refresh from server to get updated state
                            self.ViewDocumentDetails()
                            self.showAlert(title: "Success", message: "Document deleted successfully.")
                        } else {
                            // If server deletion fails, still remove locally but show warning
                            self.removeImageLocally(at: indexPath, in: collectionView)
                            self.showAlert(title: "Warning", message: "Document removed locally but server sync may be incomplete.")
                        }
                    }
                }
            } else {
                // If can't extract RequestID, just remove locally
                self.removeImageLocally(at: indexPath, in: collectionView)
                self.showAlert(title: "Deleted", message: "Image removed locally.")
            }
        })
        
        present(alert, animated: true)
    }

    func removeImageLocally(at indexPath: IndexPath, in collectionView: UICollectionView) {
        if collectionView == incomeProofCollectionView {
            imageUrls.remove(at: indexPath.row)
            if imageUrls.isEmpty {
                DerivativeImages_Verify = nil
                incomeProofuploadBtn.isHidden = false
                incomeProofVerifyBtn.isHidden = true
                IPStackView2.isHidden = false
                IPCollectionView.isHidden = true
                IPDocumentView.isHidden = true
                
                // Reset document type button states
                incomeProofDocumentTypeBtn.isEnabled = true
                incomeProofYearBtn.isEnabled = true
                incomeProofNoBtn.isEnabled = true
                incomeProofYesBtn.isEnabled = true
            }
            DispatchQueue.main.async {
                self.incomeProofCollectionView.reloadData()
            }
        } else if collectionView == BpCollectionView {
            bpImageUrls.remove(at: indexPath.row)
            if bpImageUrls.isEmpty {
                BankImages_Verify = nil
                BANKPROOFBTN.isHidden = false
                bankProofVerifyBtn.isHidden = true
                BPStackview2.isHidden = false
                BpCollectionView.isHidden = true
                BPDocumentView.isHidden = true
                
                // Reset document type button states
                BankProofDocumentTypeBtn.isEnabled = true
                BankProofNoBtn.isEnabled = true
                BankProofYesBtn.isEnabled = true
            }
            DispatchQueue.main.async {
                self.BpCollectionView.reloadData()
            }
        } else if collectionView == DICollectionView {
            dematimageUrls.remove(at: indexPath.row)
            if dematimageUrls.isEmpty {
                DP_IMAGEID_Verify = nil
                DematImgBtn.isHidden = false
                DematImageVerifyBtn.isHidden = true
                DIStackView2.isHidden = false
                DICollectionView.isHidden = true
                DIDocumentView.isHidden = true
                
                // Reset PDF/Image button states
                dematNoBtn.isEnabled = true
                dematYesBtn.isEnabled = true
            }
            DispatchQueue.main.async {
                self.DICollectionView.reloadData()
            }
        }
    }

    func resetDocumentUIAfterDelete(documentType: String) {
        switch documentType {
        case "DERIVATIVE":
            DispatchQueue.main.async { [self] in
                DerivativeImages_Verify = nil
                ipverify = nil
                incomeProofVerifyBtn.isHidden = true
                incomeProofuploadBtn.isHidden = false
                incomeProofDocumentTypeBtn.isEnabled = true
                incomeProofYearBtn.isEnabled = true
                incomeProofNoBtn.isEnabled = true
                incomeProofYesBtn.isEnabled = true
                IPStackView2.isHidden = false
                incomeproofStatusLabel.isHidden = true
                incomeproofStatusLabel.text = ""
            }
            
        case "BANK":
            DispatchQueue.main.async { [self] in
                BankImages_Verify = nil
                bpverify = nil
                bankProofVerifyBtn.isHidden = true
                BANKPROOFBTN.isHidden = false
                BankProofDocumentTypeBtn.isEnabled = true
                BankProofNoBtn.isEnabled = true
                BankProofYesBtn.isEnabled = true
                BPStackview2.isHidden = false
                BPdescriptionLabel.isHidden = true
                BPdescriptionLabel.text = ""
            }
            
        case "DP_IMAGE":
            DispatchQueue.main.async { [self] in
                DP_IMAGEID_Verify = nil
                diVerify = nil
                DematImageVerifyBtn.isHidden = true
                DematImgBtn.isHidden = false
                dematNoBtn.isEnabled = true
                dematYesBtn.isEnabled = true
                DIStackView2.isHidden = false
                dematDescriptionLabel.isHidden = true
                dematDescriptionLabel.text = ""
            }
            
        default:
            break
        }
    }
    
    func extractRequestId(from imageUrlString: String) -> String? {
        // Encode the URL string to handle any special characters
        let encodedUrlString = imageUrlString.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed)
        
        // Ensure the URL string is valid
        guard encodedUrlString != nil,
              let url = URL(string: encodedUrlString ?? "no value")
        else {
            print("Invalid URL string.")
            return nil
        }
        
        // Create URLComponents from the URL
        guard
            let urlComponents = URLComponents(
                url: url, resolvingAgainstBaseURL: false)
        else {
            print("Failed to create URLComponents from the given string.")
            return nil
        }
        
        // Find the query item with the name "id"
        if let requestId = urlComponents.queryItems?.first(where: {
            $0.name == "id"
        })?.value {
            print("Successfully extracted RequestId: \(requestId)")
            return requestId
        } else {
            print("Failed to extract RequestId from imageUrlString.")
            return nil
        }
    }
}

extension DocumentVC: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        //let width = 200
        let height = (collectionView.frame.height - 20) / 1
        return CGSize(width: 200, height: height)
    }
}

extension DocumentVC {
    
    @IBAction func pandeleteBtn(_ sender: UIButton) {
        guard let panImageUrl = self.panImageUrl else {
            print("No image URL available to delete.")
            return
        }
        
        // Extract RequestID from the URL
        guard let requestId = extractRequestId(from: panImageUrl) else {
            print("Failed to extract RequestID from the image URL.")
            return
        }
        
        // Call the delete API
        deleteImageFromServer(requestId: requestId, documentType: "PANCOPY") {
            success in
            if success {
                DispatchQueue.main.async {
                    // Hide the image view and reset any related variables
                    self.panCopyImageView.image = nil
                    self.panImageUrl = nil
                    self.PCHolderView.isHidden = true
                    self.PANCopyBtn.isHidden = false
                    self.pandeleteBtn.isHidden = true
                    self.PCStackView.isHidden = false
                    self.panDelete = "PAN deleted"
                    //self.PCNoBtn.isEnabled = true
                    //self.PCYesBtn.isEnabled = true
                    //self.PCNoBtn.isSelected = false
                    //self.PCYesBtn.isSelected = false
                    self.ViewDocumentDetails()
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(
                        title: "Error",
                        message: "Failed to delete the image. Please try again."
                    )
                }
            }
        }
    }
    @IBAction func signaturedeleteBtn(_ sender: UIButton) {
        guard let signatureUrl = self.signatureUrl else {
            print("No signature URL available to delete.")
            return
        }
        
        // Extract RequestID from the URL
        guard let requestId = extractRequestId(from: signatureUrl) else {
            print("Failed to extract RequestID from the signature URL.")
            return
        }
        
        // Call the delete API
        deleteImageFromServer(requestId: requestId, documentType: "SIGNATURE") {
            success in
            if success {
                DispatchQueue.main.async {
                    // Hide the signature view and reset any related variables
                    //self.CPStackView.isHidden = true
                    self.signaturedeleteBtn.isHidden = true
                    self.CSStackView1.isHidden = false
                    self.signatureImageview.image = nil
                    self.signatureUrl = nil
                    self.drawBtn.isHidden = false
                    //self.CurrentSignBtn.isHidden = false
                    self.CSDocumentView.isHidden = true
                    self.showAlert(
                        title: "Success",
                        message: "Signature image deleted successfully.")
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(
                        title: "Error",
                        message:
                            "Failed to delete the signature image. Please try again."
                    )
                }
            }
        }
    }
    @IBAction func clientPhotodeleteBtn(_ sender: UIButton) {
        guard let clientPhotoUrl = self.clientPhotoUrl else {
            print("No client photo URL available to delete.")
            return
        }
        
        // Extract RequestID from the URL
        guard let requestId = extractRequestId(from: clientPhotoUrl) else {
            print("Failed to extract RequestID from the client photo URL.")
            return
        }
        
        // Call the delete API
        deleteImageFromServer(
            requestId: requestId, documentType: "CLIENT_PHOTO"
        ) { success in
            if success {
                DispatchQueue.main.async { [self] in
                    // Reset the image and related UI components
                    self.CPImageView.image = UIImage(
                        systemName: "person.crop.circle")
                    self.clientPhotoUrl = nil
                    self.CP_Long_Lat_Lbl.text = "Lat/Long not available"
                    // Show buttons or stacks for new image capture
                    self.CPStackView.isHidden = false
                    self.CP_CaptureImgBtn.isHidden = false
                    self.CP_IPVLinkBtn.isHidden = false
                    CPHolderView1.isHidden = true
                    CPImageView.isHidden = true
                    CP_Long_Lat_Lbl.isHidden = true
                    CpHolderView2.isHidden = true
                    CP_Location_label.isHidden = true
                    self.showAlert(
                        title: "Success",
                        message: "Client photo deleted successfully.")
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(
                        title: "Error",
                        message:
                            "Failed to delete the client photo. Please try again."
                    )
                }
            }
        }
        
    }
    @IBAction func nominee1deleteBtn(_ sender: UIButton) {
        guard let nominee1Url = self.nominee1Url else {
            print("No nominee 1 URL available to delete.")
            return
        }
        
        // Extract RequestID from the URL
        guard let requestId = extractRequestId(from: nominee1Url) else {
            print("Failed to extract RequestID from nominee 1 URL.")
            return
        }
        
        // Call the delete API
        deleteImageFromServer(requestId: requestId, documentType: "NOMINEE_1") {
            success in
            if success {
                DispatchQueue.main.async {
                    // Reset nominee 1 image and related UI components
                    self.nominee1ImagesVerify = nil
                    self.nominee1ImageView.isHidden = true
                    self.nominee1ImageView.image = UIImage(
                        systemName: "person.crop.circle")
                    self.nominee1Url = nil
                    self.Nominee1bTn.isHidden = false
                    self.nominee1deleteBtn.isHidden = true
                    self.NM1StackView.isHidden = false
                    //self.nominee_1nameLabel.text = ""
                    //self.nominee_1DocumentTypelbl.text = ""
                    self.showAlert(
                        title: "Success",
                        message: "Nominee 1 image deleted successfully.")
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(
                        title: "Error",
                        message:
                            "Failed to delete nominee 1 image. Please try again."
                    )
                }
            }
        }
    }
    @IBAction func nominee2deleteBtn(_ sender: UIButton) {
        guard let nominee2Url = self.nominee2Url else {
            print("No nominee 2 URL available to delete.")
            return
        }
        
        // Extract RequestID from the URL
        guard let requestId = extractRequestId(from: nominee2Url) else {
            print("Failed to extract RequestID from nominee 2 URL.")
            return
        }
        
        // Call the delete API
        deleteImageFromServer(requestId: requestId, documentType: "NOMINEE_2") {
            success in
            if success {
                DispatchQueue.main.async {
                    // Reset nominee 2 image and related UI components
                    self.nominee2ImagesVerify = nil
                    self.nominee2ImageView.isHidden = true
                    self.nominee2ImageView.image = UIImage(
                        systemName: "person.crop.circle")
                    self.nominee2Url = nil
                    self.NM2Label3.text = ""
                    self.Nominee2Btn.isHidden = false
                    self.nominee2deleteBtn.isHidden = true
                    self.NM2StackView.isHidden = false
                    self.nominee_2DocumentTypelbl.text = ""
                    self.showAlert(
                        title: "Success",
                        message: "Nominee 2 image deleted successfully.")
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(
                        title: "Error",
                        message:
                            "Failed to delete nominee 2 image. Please try again."
                    )
                }
            }
        }
    }
    @IBAction func nominee3deleteBtn(_ sender: UIButton) {
        guard let nominee3Url = self.nominee3Url else {
            print("No nominee 3 URL available to delete.")
            return
        }
        
        // Extract RequestID from the URL
        guard let requestId = extractRequestId(from: nominee3Url) else {
            print("Failed to extract RequestID from nominee 3 URL.")
            return
        }
        
        // Call the delete API
        deleteImageFromServer(requestId: requestId, documentType: "NOMINEE_3") {
            success in
            if success {
                DispatchQueue.main.async {
                    // Reset nominee 3 image and related UI components
                    self.nominee3ImagesVerify = nil
                    self.nominee3ImageView.isHidden = true
                    self.nominee3ImageView.image = UIImage(
                        systemName: "person.crop.circle")
                    self.nominee3Url = nil
                    self.NM3Label3.text = ""
                    self.Nominee3BTn.isHidden = false
                    self.nominee3deleteBtn.isHidden = true
                    self.NM3StackView.isHidden = false
                    self.nominee_3DocumentTypelbl.text = ""
                    self.showAlert(
                        title: "Success",
                        message: "Nominee 3 image deleted successfully.")
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(
                        title: "Error",
                        message:
                            "Failed to delete nominee 3 image. Please try again."
                    )
                }
            }
        }
    }
    func UpdateDocumentModificationStatus() {
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
            [self] tokenId in
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.UpdateDocumentModificationStatus()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                //                "UserId":  fetchedUserId,
                //                "TokenId": tokenId,
                "PanNo": PanNo,
                "RegId": RegId,
                "DocumentName": "Documents",
                
            ]
            print(parameters)
            let Url = "MultiPartImageUpload/UpdateDocumentModificationStatus"
            
            apiCall(
                url: Url, method: "POST",
                parameters: parameters as [String: Any], view: self.view,
                loaderText: "Kindly wait we are verifying your document..."
            ) { result in
                switch result {
                case .success(let jsonResponse):
                    print(
                        "UpdateDocumentModificationStatus Response: \(jsonResponse)"
                    )
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "000000":
                            DispatchQueue.main.async {
                                print("api is running")
                                self.delegate?.reloadPageData()
                                self.navigationController?.popViewController(
                                    animated: true)
                            }
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(
                                    entityName: "TokenMobile")
                                print(
                                    "All TokenMobile entries deleted due to error code 999992"
                                )
                                
                                // Regenerate tokens
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
                    print(
                        "UpdateDocumentModificationStatus API call failed: \(error.localizedDescription)"
                    )
                }
            }
        }
    }
    
    func SavePhotoAuditLogDetails() {
        
        let parameters: [String: Any?] = [
            "Flag":"Insert"
        ]
        print("\(parameters)")
        let Url = "MultiPartImageUpload/SavePhotoAuditLogDetails"
        
        apiCall(url: Url, method: "POST", parameters: parameters as [String: Any], view: self.view) { result in
            switch result {
            case .success(let jsonResponse):
                print("SavePhotoAuditLogDetails Response: \(jsonResponse)")
                let TransactionID = jsonResponse["TransactionID"] as? String
                let URL = jsonResponse["URL"] as? String
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "000000":
                        DispatchQueue.main.async { [self] in
                            print("API is running")
                            openCamera()
                        }
                    case "000023" :
                        DispatchQueue.main.async {
                            print("API is running")
                            
                            //                                    self.navigationController?.popViewController(animated: true)
                            //completion(true)
                        }
                    default:
                        print("Unhandled error code: \(errorCode)")
                        //completion(false)
                    }
                }
            case .failure(let error):
                print("Login API call failed: \(error.localizedDescription)")
                //completion(false)
            }
        }
    }
}
