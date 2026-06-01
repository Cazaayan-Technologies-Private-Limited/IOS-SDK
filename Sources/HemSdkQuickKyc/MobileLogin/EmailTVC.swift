//
//  EmailTVC.swift
//  HemSdkQuickKyc
//
//  Created by Manas Datta on 06/05/26.
//

import UIKit

class EmailTVC: UITableViewCell {
    
    @IBOutlet weak var emailBtn: UIButton!
    
    var onTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
          onTap?()
      }
    
}
