//
//  DigiLocker_b_VC.swift
//  t5
//
//  Created by manas dutta on 12/12/25.
//

//import UIKit
//protocol DigiLocker_b_VCDelegate: AnyObject {
//    func didDismissDigiLockerVC()
//}
//
//class DigiLocker_b_VC: UIViewController {
//
//    @IBOutlet weak var NAMELabel: UILabel!
//    @IBOutlet weak var dobLabel: UILabel!
//    @IBOutlet weak var genderLabel: UILabel!
//    @IBOutlet weak var fathernameLabel: UILabel!
//    @IBOutlet weak var addresssLabel: UILabel!
//    @IBOutlet weak var submitBtn: UIButton!
//    @IBOutlet weak var mainView: UIView!
//    
//    var name: String?
//    var dob: String?
//    var gender: String?
//    var fatherName: String?
//    var address: String?
//    weak var delegate: DigiLocker_b_VCDelegate?
//    var identifier3: String?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.submitBtn.layer.cornerRadius = 20
//        NAMELabel.text = name
//        dobLabel.text = dob
//        genderLabel.text = gender
//        fathernameLabel.text = fatherName
//        addresssLabel.text = address
//        mainView.layer.cornerRadius = 20
//        submitBtn.layer.cornerRadius = 20
//        submitBtn.backgroundColor = .appPrimary
//        view.backgroundColor = .appBackground
//    }
//    
//    @IBAction func SubmitBtn(_ sender: UIButton) {
//        self.dismiss(animated: true) {
//            self.delegate?.didDismissDigiLockerVC()
//        }
//    }
//}
import UIKit
protocol DigiLocker_b_VCDelegate: AnyObject {
    func didDismissDigiLockerVC()
}

class DigiLocker_b_VC: UIViewController {

    @IBOutlet weak var NAMELabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var fathernameLabel: UILabel!
    @IBOutlet weak var addresssLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    var name: String?
    var dob: String?
    var gender: String?
    var fatherName: String?
    var address: String?
    weak var delegate: DigiLocker_b_VCDelegate?
    var identifier3: String?
    var panNo: String?
    var regId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.submitBtn.layer.cornerRadius = 20
        NAMELabel.text = name
        dobLabel.text = dob
        genderLabel.text = gender
        fathernameLabel.text = fatherName
        addresssLabel.text = address
        mainView.layer.cornerRadius = 20
        submitBtn.layer.cornerRadius = 20
        submitBtn.backgroundColor = .appPrimary
        view.backgroundColor = .appBackground
    }
    
    @IBAction func SubmitBtn(_ sender: UIButton) {
        //        self.navigationController?.popViewController(animated: true)
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        //            self.delegate?.didDismissDigiLockerVC()
        //        }
        //        let storyboard = UIStoryboard(name: "TradingandDemat", bundle: Bundle.module)
        //        let vc = storyboard.instantiateViewController(identifier: "TradingandDematVC") as! TradingandDematVC
        //        vc.panNo = self.panNo
        //        vc.regId = self.RegId
        //
        //        if let nav = self.navigationController {
        //            nav.pushViewController(vc, animated: true)
        //        } else if let nav = self.presentingViewController?.navigationController {
        //            self.dismiss(animated: true) {
        //                nav.pushViewController(vc, animated: true)
        //            }
        //        }
        //
        //        self.navigationController?.pushViewController(vc, animated: true)
        //    }
        if identifier3 == "NomineeVC" {
            // ✅ Call delegate instead of navigation
            self.navigationController?.popViewController(animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.delegate?.didDismissDigiLockerVC()
            }
            
        } else {
            // ✅ Existing flow for DigiLockerA
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
}
//import UIKit
//protocol DigiLocker_b_VCDelegate: AnyObject {
//    func didDismissDigiLockerVC()
//}
//
//class DigiLocker_b_VC: UIViewController {
//
//    @IBOutlet weak var NAMELabel: UILabel!
//    @IBOutlet weak var dobLabel: UILabel!
//    @IBOutlet weak var genderLabel: UILabel!
//    @IBOutlet weak var fathernameLabel: UILabel!
//    @IBOutlet weak var addresssLabel: UILabel!
//    @IBOutlet weak var submitBtn: UIButton!
//    
//    var name: String?
//    var dob: String?
//    var gender: String?
//    var fatherName: String?
//    var address: String?
//    weak var delegate: DigiLocker_b_VCDelegate?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.submitBtn.layer.cornerRadius = 20
//        NAMELabel.text = name
//        dobLabel.text = dob
//        genderLabel.text = gender
//        fathernameLabel.text = fatherName
//        addresssLabel.text = address
//    }
//    
//    @IBAction func SubmitBtn(_ sender: UIButton) {
//        self.dismiss(animated: true) {
//            self.delegate?.didDismissDigiLockerVC()
//        }
//    }
//}
