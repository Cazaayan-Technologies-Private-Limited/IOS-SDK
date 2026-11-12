//
//  documentTypeVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

protocol SelectionDelegate: AnyObject {
    func didSelectDepository(type: String,identifier: String,isView: Bool)
}

class documentTypeVC: UIViewController {
    
    @IBOutlet weak var holderview: UIView!
    @IBOutlet weak var panBtn: UIButton!
    @IBOutlet weak var adhaarBtn: UIButton!
    @IBOutlet weak var licenceBtn: UIButton!
    @IBOutlet weak var passportBtn: UIButton!
    
    weak var delegate: SelectionDelegate?
    var identifier: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        holderview.layer.cornerRadius = 10
//        adhaarBtn.isHidden = true
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func AadhaarTapped(_ sender: UIButton) {
        delegate?.didSelectDepository(type: "Aadhaar", identifier: identifier, isView: false)
        dismiss(animated: true, completion: nil)   // Let delegate handle navigation
    }

    @IBAction func PANTapped(_ sender: UIButton) {
        delegate?.didSelectDepository(type: "PAN", identifier: identifier, isView: false)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func LicenceTapped(_ sender: UIButton) {
            delegate?.didSelectDepository(type: "Driving Licence", identifier: identifier, isView: false)
            dismiss(animated: true, completion: nil)
        }
    
    @IBAction func PassportTapped(_ sender: UIButton) {
                delegate?.didSelectDepository(type: "Passport", identifier: identifier, isView: false)
                dismiss(animated: true, completion: nil)
            }
}

