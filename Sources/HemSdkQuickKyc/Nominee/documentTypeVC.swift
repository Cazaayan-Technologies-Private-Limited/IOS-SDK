//
//  documentTypeVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

protocol SelectionDelegate: AnyObject {
    func didSelectDepository(type: String,identifier: String)
}

class documentTypeVC: UIViewController {
    
    @IBOutlet weak var holderview: UIView!
    
    weak var delegate: SelectionDelegate?
    var identifier: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        holderview.layer.cornerRadius = 10
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func AadhaarTapped(_ sender: UIButton) {
        delegate?.didSelectDepository(type: "Aadhaar", identifier: identifier)
        dismiss(animated: true, completion: nil)   // Let delegate handle navigation
    }

    @IBAction func PANTapped(_ sender: UIButton) {
        delegate?.didSelectDepository(type: "PAN", identifier: identifier)
        dismiss(animated: true, completion: nil)
    }
}

