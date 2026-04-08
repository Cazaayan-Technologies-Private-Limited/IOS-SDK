//
//  incomeCVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//
import UIKit

protocol IncomeCVCDelegate: AnyObject {
    func didTapDeleteButton(at indexPath: IndexPath, in collectionView: UICollectionView)
}

class incomeCVC: UICollectionViewCell {
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: IncomeCVCDelegate?
    var indexPath: IndexPath?
    var parentCollectionView: UICollectionView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageview.layer.cornerRadius = 10
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        if let indexPath = indexPath, let collectionView = parentCollectionView {
            delegate?.didTapDeleteButton(at: indexPath, in: collectionView)
        }
    }
}
