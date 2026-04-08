//
//  CommodityTVC.swift
//  t5
//
//  Created by manas dutta on 20/12/25.
//

import UIKit

protocol CommodityTVCDelegate: AnyObject {
    func didTapDropdown(for cell: CommodityTVC, with values: [String])
}

class CommodityTVC: UITableViewCell {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var commodityNameLabel: UILabel!
    @IBOutlet weak var CommodityDropdownButton: UIButton!
    @IBOutlet weak var commodityLbl: UILabel!
    @IBOutlet weak var otherView: UIView!
    
    weak var delegate: CommodityTVCDelegate?
    var commodityValues: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.CommodityDropdownButton.layer.cornerRadius = 10
        self.holderView.layer.cornerRadius = 10
        self.commodityLbl.layer.cornerRadius = 10
        otherView.layer.cornerRadius = 10

    }
    
    @IBAction func commodityDropdownButtonClicked(_ sender: UIButton) {
        delegate?.didTapDropdown(for: self, with: commodityValues)
    }
    
    func updateCommodityButton(with value: String) {
        commodityLbl.text = value
    }
}

