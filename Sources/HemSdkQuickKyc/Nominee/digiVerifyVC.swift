//
//  digiVerifyVC.swift
//  t5
//
//  Created by manas dutta on 20/03/26.
//

import UIKit

protocol DigiLocker_b_VCDelegate1: AnyObject {
    func didDismissDigiLockerVC()
}

class digiVerifyVC: UIViewController {

    @IBOutlet weak var NAMELabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var fathernameLabel: UILabel!
    @IBOutlet weak var addresssLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var mainView: UIView!

    var name: String?
    var dob: String?
    var gender: String?
    var fatherName: String?
    var address: String?
    weak var delegate: DigiLocker_b_VCDelegate1?
    var identifier3: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.submitBtn.layer.cornerRadius = 20
        NAMELabel.text = name
        dobLabel.text = dob
        genderLabel.text = gender
        fathernameLabel.text = fatherName
        addresssLabel.text = address
        mainView.layer.cornerRadius = 20
        submitBtn.layer.cornerRadius = 20
        submitBtn.backgroundColor = .appPrimary
        view.backgroundColor = .appBackground
    }

    @IBAction func SubmitBtn(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.didDismissDigiLockerVC()
        }
    }
}
