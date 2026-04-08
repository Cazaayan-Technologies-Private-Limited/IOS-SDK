//
//  yearVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

class yearVC: UIViewController {

    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var secondYear: UIButton!
    @IBOutlet weak var firstYear: UIButton!
    
    var identifier: String = ""
    weak var delegate : didselectdocumentType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        holderView.layer.cornerRadius = 10
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func firstYearBtn(_ sender: UIButton) {
        delegate?.didselectdocument(documenttype: "2024-25", identifier: identifier)
        dismiss(animated: true)
    }
    
    @IBAction func secondYearBtn(_ sender: UIButton) {
        delegate?.didselectdocument(documenttype: "2025-26", identifier: identifier)
        dismiss(animated: true)
    }
}
