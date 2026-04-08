//
//  MaritalVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

protocol MaritatlSelectionDelegate: AnyObject {
    func didSelectMarital(id:String,type: String)
}

class MaritalVC: UIViewController {
    
    @IBOutlet weak var holderView: UIView!
    
    weak var delegate: MaritatlSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.holderView.layer.cornerRadius = 10
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func marriedLBtnTapped(_ sender: UIButton) {
        delegate?.didSelectMarital(id: "1", type: "MARRIED")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SingleBtnTapped(_ sender: UIButton) {
        delegate?.didSelectMarital(id: "2", type: "SINGLE")
        dismiss(animated: true, completion: nil)
    }
}
