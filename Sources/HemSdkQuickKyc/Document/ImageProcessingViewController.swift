//
//  ImageProcessingViewController.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

protocol ImageProcessingDelegate: AnyObject {
    func didProcessImage(identifier: String?, compressedImageData: Data)
}

class ImageProcessingViewController: UIViewController {
    // Outlets
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var saveAndSendBtn: UIButton!
    @IBOutlet weak var cropBtn: UIButton!
    
    var identifier: String?
    var croppingImageView: UIImageView!
    var cropOverlayView: ResizableCropOverlayView!
    var selectedImage: UIImage?
    var compressedImageData: Data?
    var isCroppingEnabled = false
    weak var delegate: ImageProcessingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = selectedImage {
            showImage(image: image)
        } else {
            print("No selected image found.")
        }
    }
    
    // Function to display the selected image
    func showImage(image: UIImage) {
        croppingImageView = UIImageView(image: image)
        croppingImageView.contentMode = .scaleAspectFit
        selectedImageView.image = image
        
        // Configure Auto Layout Constraints for the UIImageView
        croppingImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(croppingImageView)
        
        NSLayoutConstraint.activate([
            croppingImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            croppingImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            croppingImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            croppingImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    // Action for "Save and Send" button
    @IBAction func saveAndSendBtn(_ sender: UIButton) {
        if isCroppingEnabled {
            cropAndCompressImage()
        } else {
            sendFullImage()
        }
    }
    
    // Action for "Crop" button to enable cropping
    @IBAction func cropBtn(_ sender: UIButton) {
        enableCropping()
    }
    
    // Function to enable cropping mode
    func enableCropping() {
        isCroppingEnabled = true
        // Remove existing crop overlay if it exists
        cropOverlayView?.removeFromSuperview()
        // Calculate the visible image frame within the UIImageView
        guard let image = selectedImageView.image else { return }
        let imageViewSize = selectedImageView.bounds.size
        let imageSize = image.size
        let widthRatio = imageViewSize.width / imageSize.width
        let heightRatio = imageViewSize.height / imageSize.height
        let scaleFactor = min(widthRatio, heightRatio)
        let scaledImageWidth = imageSize.width * scaleFactor
        let scaledImageHeight = imageSize.height * scaleFactor
        let imageViewX = (imageViewSize.width - scaledImageWidth) / 2 + selectedImageView.frame.origin.x
        let imageViewY = (imageViewSize.height - scaledImageHeight) / 2 + selectedImageView.frame.origin.y
        let visibleImageFrame = CGRect(x: imageViewX, y: imageViewY, width: scaledImageWidth, height: scaledImageHeight)
        
        // Add the crop overlay on top of the visible part of the image
        cropOverlayView = ResizableCropOverlayView(frame: visibleImageFrame)
        cropOverlayView.layer.borderColor = UIColor.red.cgColor
        cropOverlayView.layer.borderWidth = 2.0
        // Add the crop overlay to the view
        self.view.addSubview(cropOverlayView)
        // Bring the crop overlay to the front
        self.view.bringSubviewToFront(cropOverlayView)
    }
    
    // Function to send the full image without cropping
    func sendFullImage() {
        if let image = selectedImage, let compressedData = image.jpegData(compressionQuality: 0.1) {
            compressedImageData = compressedData
            delegate?.didProcessImage(identifier: identifier, compressedImageData: compressedData)
            navigationController?.popViewController(animated: true)
        }
    }
    
    // Function to crop, compress, and send the cropped image
    @objc func cropAndCompressImage() {
        guard let image = croppingImageView.image else { return }
        
        // Get the cropping rectangle relative to the UIImageView
        let cropFrameInView = self.view.convert(cropOverlayView.frame, to: croppingImageView)
        let scaleFactorX = image.size.width / croppingImageView.frame.width
        let scaleFactorY = image.size.height / croppingImageView.frame.height
        
        let cropRect = CGRect(
            x: cropFrameInView.origin.x * scaleFactorX,
            y: cropFrameInView.origin.y * scaleFactorY,
            width: cropFrameInView.size.width * scaleFactorX,
            height: cropFrameInView.size.height * scaleFactorY
        )
        
        // Crop the image based on the calculated rectangle
        if let croppedCGImage = image.cgImage?.cropping(to: cropRect) {
            let croppedUIImage = UIImage(cgImage: croppedCGImage, scale: image.scale, orientation: image.imageOrientation)
            
            // Compress the cropped image
            if let compressedData = croppedUIImage.jpegData(compressionQuality: 0.1) {
                compressedImageData = compressedData
                delegate?.didProcessImage(identifier: identifier, compressedImageData: compressedData)
                navigationController?.popViewController(animated: true)
            }
            // Hide or remove the crop overlay view after cropping
            cropOverlayView.isHidden = true
        }
    }
}

