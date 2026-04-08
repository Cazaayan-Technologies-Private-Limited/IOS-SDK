//
//  DepositoryVC.swift
//  t5
//
//  Created by manas dutta on 19/12/25.
//

import UIKit

protocol DepositorySelectionDelegate: AnyObject {
    func didSelectDepository(type: String,IsDpAccountNew:String)
}

class DepositoryVC: UIViewController {

    @IBOutlet weak var CDSLbtn: UIButton!
    @IBOutlet weak var NSDLbtn: UIButton!
    
    weak var delegate: DepositorySelectionDelegate?
    var IsDpAccountNew:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func CDSLBtnTapped(_ sender: UIButton) {
        delegate?.didSelectDepository(type: "CDSL", IsDpAccountNew: IsDpAccountNew ?? "Y")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func NSDLBtnTapped(_ sender: UIButton) {
        delegate?.didSelectDepository(type: "NSDL", IsDpAccountNew: IsDpAccountNew ?? "Y")
        dismiss(animated: true, completion: nil)
    }
}
