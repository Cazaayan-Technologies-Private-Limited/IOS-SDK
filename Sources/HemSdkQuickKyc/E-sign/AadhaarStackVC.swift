//
//  AadhaarStackVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

protocol AadhaarStackDelegate: AnyObject {
    func didAcceptTerms(segmentName: String, signKey: String)
}

class AadhaarStackVC: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var holderview: UIView!
    @IBOutlet weak var termsAndConditionBtn: UIButton!
    
    var segmentName:String?
    var signkey:String?
    weak var delegate: AadhaarStackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackView.layer.cornerRadius = 20
        self.holderview.layer.cornerRadius = 20
        textView.text = """
I hereby authorize NSDL e-Governance Infrastructure Ltd. (ESP) on behalf of Scrabble Technologies Pvt. Ltd. (ASP) to-\n\n1. Use my Aadhaar details for eSigning the digital document(s) and digital Form(s) for Completing KYC Processes for and authenticate my identity through the Aadhaar Authentication system (Aadhaar based e-KYC services of UIDAI) in accordance with the provisions of the Aadhaar (Targeted Delivery of Financial and other Subsidies, Benefits and Services) Act, 2016 and the allied rules and regulations notified there-under and for no other purpose.\n\n2. Authenticate my Aadhaar through OTP or Biometric for authenticating my identity through the Aadhaar Authentication system for obtaining my e-KYC through Aadhaar based e-KYC services of UIDAI and use my Photo and Demographic details (Name, Gender, Date of Birth and Address,whichever is allowed by UIDAI) for eSigning the digital document(s) and digital Form(s) for Completing KYC Processes for .\n\n3. I understand that Security and confidentiality of personal identity data provided, for the purpose of Aadhaar based authentication is ensured by NSDL e-Gov and the data will be stored by NSDL e-Gov till such time as mentioned in guidelines from UIDAI from time to time.
"""
        // Optional: Customize the textView appearance
        textView.isEditable = false // Make it read-only
        textView.font = UIFont.systemFont(ofSize: 14)
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func TermsAndonditionBtn(_ sender: UIButton) {
        sender.isSelected.toggle() // Toggle the selected state
        print("Button isSelected: \(sender.isSelected)") // Debug log
        if let segmentName = segmentName, let signKey = signkey {
            delegate?.didAcceptTerms(segmentName: segmentName, signKey: signKey)
        }
        dismiss(animated: true, completion: nil)
    }
}
