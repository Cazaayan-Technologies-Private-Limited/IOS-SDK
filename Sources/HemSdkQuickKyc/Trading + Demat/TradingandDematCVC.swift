//
//  TradingandDematCVC.swift
//  t5
//
//  Created by manas dutta on 18/12/25.
//

import UIKit

protocol funcCallBack: AnyObject {
    func didSelectSegmentBtn(index: Int)
}

class TradingandDematCVC: UICollectionViewCell {
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var segmentBtn: UIButton!
    
    weak var delegate: funcCallBack?
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    @IBAction func segmentBtn(_ sender: UIButton) {
        delegate?.didSelectSegmentBtn(index: index)
    }
    
    private func setupUI() {
        buttonView.layer.cornerRadius = 25
        buttonView.layer.borderWidth = 1
    }

    func configure(title: String, isSelected: Bool, index: Int) {
        self.index = index
        segmentBtn.setTitle(title, for: .normal)
        
        let imageName = isSelected ? "checkmark.circle.fill" : "circle"
             let image = UIImage(systemName: imageName)

             segmentBtn.setImage(image, for: .normal)

//        if isSelected {
//            segmentBtn.setImage(UIImage(named: "checkmark.circle"), for: .normal)
//        } else {
//            segmentBtn.setImage(UIImage(named: "circle"), for: .normal)
//        }
    }
}
