//
//  CongratulationVC.swift
//  HemSdkQuickKyc
//
//  Created by Manas Datta on 16/06/26.
//

import UIKit

class CongratulationVC: UIViewController {
    
    var onOkTapped: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func okBtn(_ sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.onOkTapped?()
        }
    }
}
