//
//  DocumentTypeVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

protocol didselectdocumentType : AnyObject {
    func didselectdocument(documenttype:String,identifier:String)
}

class DocumentTypeVC: UIViewController {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var BankStatementBtn: UIButton!
    @IBOutlet weak var SignedCancelledChequeBtn: UIButton!
    @IBOutlet weak var SelectLbl: UILabel!
    @IBOutlet weak var bankPassbookBtn: UIButton!
    
    var identifier: String = ""
    weak var delegate : didselectdocumentType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        holderView.layer.cornerRadius = 10
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func bankstatementBtn(_ sender: UIButton) {
        delegate?.didselectdocument(documenttype: "Bank Statement", identifier: identifier)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signedCancelledChequeBtn(_ sender: UIButton) {
        delegate?.didselectdocument(documenttype: "Signed Cancelled Cheque", identifier: identifier)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BankPassbookBtn(_ sender: UIButton) {
        delegate?.didselectdocument(documenttype: "Bank Passbook", identifier: identifier)
        dismiss(animated: true, completion: nil)
    }
}

