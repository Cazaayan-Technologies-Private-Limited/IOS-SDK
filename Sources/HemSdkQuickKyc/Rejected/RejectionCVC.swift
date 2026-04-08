//
//  RejectionCVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

class RejectionCVC: UICollectionViewCell {
  
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var pageNamelabel: UILabel!
    @IBOutlet weak var RectifyBtn: UIButton!
    @IBOutlet weak var rectifiedBtn: UIButton!
    
    weak var delegate: ReloadPageDelegate?
    var documentName: String?
    var panNo: String?
    var regId: String?
    var navigationController: UINavigationController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.RectifyBtn.layer.cornerRadius = 10
        self.rectifiedBtn.isHidden = true
    }
    
    @IBAction func rectifyBtn(_ sender: UIButton) {
        guard let documentName = documentName else { return }
        
        guard RectifyBtn.isEnabled else {
            print("Navigation is disabled for this cell.")
            return
        }
        
        switch documentName {
        case "BANK DETAILS":
            // Navigate to BankVC
            let storyboard = UIStoryboard(name: "Bank", bundle: Bundle.module)
            if let vc = storyboard.instantiateViewController(identifier: "BankVC") as? BankVC {
                vc.panNo = panNo
                vc.rejection = "Rejection"
                vc.regId = regId
                vc.delegate = delegate
                //vc.delegate = delegate as? ReloadPageDelegate
                navigationController?.pushViewController(vc, animated: true)
            }
        case "DOCUMENT DETAILS":
            // Navigate to DocumentVC
            let storyboard = UIStoryboard(name: "Document", bundle: Bundle.module)
            if let nextVC = storyboard.instantiateViewController(withIdentifier: "DocumentVC") as? DocumentVC {
//                nextVC.PanNo = panNo
//                nextVC.rejection = "Rejection"
//                nextVC.RegId = regId
//                nextVC.delegate = delegate
//                nextVC.isFromRejectionFlow = true
                navigationController?.pushViewController(nextVC, animated: true)
            }
        default:
            print("No matching document name found.\(documentName)")
        }
    }
}

