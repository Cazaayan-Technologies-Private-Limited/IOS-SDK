//
//  incomeproofDocumentVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

class incomeproofDocumentVC: UIViewController {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var BankStatementBtn: UIButton!
    @IBOutlet weak var latestITRBtn: UIButton!
    @IBOutlet weak var SelectLbl: UILabel!
    @IBOutlet weak var form16Btn: UIButton!
    @IBOutlet weak var salarySlipBtn: UIButton!
    
    weak var delegate : didselectdocumentType?
    var identifier: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        holderView.layer.cornerRadius = 10
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func bankstatementBtn(_ sender: UIButton) {
        delegate?.didselectdocument(documenttype: "Six Month Bank Statement", identifier: identifier)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func latestITRBtn(_ sender: UIButton) {
        delegate?.didselectdocument(documenttype: "Latest ITR", identifier: identifier)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func form16Btn(_ sender: UIButton) {
        delegate?.didselectdocument(documenttype: "Form 16", identifier: identifier)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func salarySlipBtnTapped(_ sender: UIButton) {
        delegate?.didselectdocument(documenttype: "Salary Slip", identifier: identifier)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func dematAccountBtn(_ sender: UIButton) {
        delegate?.didselectdocument(documenttype: "Demat Account Holding with Value", identifier: identifier)
        dismiss(animated: true, completion: nil)
    }
}

