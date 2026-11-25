//
//  incomeCVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//
import UIKit
import AVFoundation

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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeDeleteButtonOnImage()
    }
    
    /// The image is drawn "aspect fit", so it is usually narrower than the image view.
    /// The ✕ was pinned to the cell's top-right corner and looked detached from the picture.
    /// Move it onto the top-right corner of the picture that is actually drawn.
    private func placeDeleteButtonOnImage() {
        guard let imageview = imageview, let deleteButton = deleteButton,
              let container = deleteButton.superview else { return }
        deleteButton.transform = .identity
        
        var drawn = imageview.bounds
        if let image = imageview.image, image.size.width > 0, image.size.height > 0 {
            drawn = AVMakeRect(aspectRatio: image.size, insideRect: imageview.bounds)
            // Some scans (e.g. the bank statement) have a white/blank band at the top of the
            // picture itself → start the corner where the visible content starts.
            let blankTop = Self.blankTopFraction(of: image) * drawn.height
            drawn.origin.y += blankTop
            drawn.size.height -= blankTop
        }
        let drawnInContainer = imageview.convert(drawn, to: container)
        
        // Same as Android: the ✕ centre sits exactly on the picture's top-right corner
        // (half on the picture, half outside). It always stays inside the cell,
        // which clips its content – the image view leaves 10 pt free at top and right.
        let half = deleteButton.bounds.width / 2
        var target = CGPoint(x: drawnInContainer.maxX, y: drawnInContainer.minY)
        target.x = min(max(target.x, half), container.bounds.width - half)
        target.y = min(max(target.y, half), container.bounds.height - half)
        
        let current = deleteButton.center
        deleteButton.transform = CGAffineTransform(translationX: target.x - current.x,
                                                   y: target.y - current.y)
    }
    
    /// Fraction (0…0.3) of the image height at the top that is blank (near-white or transparent).
    /// Measured once per image on a small 48×48 copy, then cached.
    private static var blankTopCache: [ObjectIdentifier: CGFloat] = [:]
    private static func blankTopFraction(of image: UIImage) -> CGFloat {
        let key = ObjectIdentifier(image)
        if let cached = blankTopCache[key] { return cached }
        let side = 48
        var pixels = [UInt8](repeating: 0, count: side * side * 4)
        var result: CGFloat = 0
        let drawnOK: Bool = pixels.withUnsafeMutableBytes { buffer in
            guard let cg = image.cgImage,
                  let ctx = CGContext(data: buffer.baseAddress, width: side, height: side, bitsPerComponent: 8,
                                      bytesPerRow: side * 4, space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return false }
            ctx.draw(cg, in: CGRect(x: 0, y: 0, width: side, height: side))
            return true
        }
        if drawnOK {
            // CGContext memory starts with the TOP row of the drawn image
            var firstContentRow = 0
            rows: for row in 0..<side {
                for col in 0..<side {
                    let i = (row * side + col) * 4
                    let a = Int(pixels[i + 3])
                    let brightness = (Int(pixels[i]) + Int(pixels[i + 1]) + Int(pixels[i + 2])) / 3
                    if a > 40 && brightness < 240 { firstContentRow = row; break rows }   // only (near-)white counts as blank
                }
            }
            result = min(CGFloat(firstContentRow) / CGFloat(side), 0.3)
        }
        if blankTopCache.count > 50 { blankTopCache.removeAll() }
        blankTopCache[key] = result
        return result
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        if let indexPath = indexPath, let collectionView = parentCollectionView {
            delegate?.didTapDeleteButton(at: indexPath, in: collectionView)
        }
    }
}

extension UIView {
    /// The collection view cell this view is inside (used to re-place the ✕ after a thumbnail loads)
    var enclosingCollectionCell: UICollectionViewCell? {
        var view = superview
        while let v = view {
            if let cell = v as? UICollectionViewCell { return cell }
            view = v.superview
        }
        return nil
    }
}
