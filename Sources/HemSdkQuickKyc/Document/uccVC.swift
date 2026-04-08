//
//  uccVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

protocol didTypeUccCode : AnyObject {
    func Ucccode(ucccode:String)
}

class uccVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var holderview: UIView!
    @IBOutlet weak var uccTF: UITextField!
    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    weak var delegate : didTypeUccCode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.holderview.layer.cornerRadius = 10
        self.stackview.layer.cornerRadius = 10
        self.cancelBtn.layer.cornerRadius = 10
        self.submitBtn.layer.cornerRadius = 10
        self.uccTF.layer.cornerRadius = 10
        uccTF.delegate = self
        
    }
    
    @IBAction func quitBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func SubmitBtn(_ sender: UIButton) {
        if let uccCode = uccTF.text, !uccCode.isEmpty {
            delegate?.Ucccode(ucccode: uccCode)
            dismiss(animated: true) // Dismiss the view controller after sending data
        } else {
            // Optionally, show an alert if the text field is empty
            let alert = UIAlertController(title: "Error", message: "Please enter a UCC code", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    // UITextFieldDelegate method to restrict special characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Define allowed characters (letters and numbers only)
        let allowedCharacters = CharacterSet.alphanumerics
        let characterSet = CharacterSet(charactersIn: string)
        // Prevent special characters
        if !allowedCharacters.isSuperset(of: characterSet) {
            showAlert(title: "Invalid Input", message: "Special characters are not allowed. Please use letters and numbers only.")
            return false
        }
        // Get the updated text after user input
        if let currentText = textField.text as NSString? {
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            
            // PAN card regex pattern: 5 letters + 4 digits + 1 letter (total 10 characters)
            let panRegex = "^[A-Z]{5}[0-9]{4}[A-Z]{1}$"
            let panPredicate = NSPredicate(format: "SELF MATCHES %@", panRegex)
            
            if panPredicate.evaluate(with: updatedText.uppercased()) {
                showAlert(title: "Invalid Input", message: "Please do not enter a PAN number.")
                return false
            }
        }
        return true
    }
    
    // Helper function to show alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

