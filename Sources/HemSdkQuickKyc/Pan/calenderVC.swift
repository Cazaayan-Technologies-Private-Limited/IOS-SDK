//
//  calenderVC.swift
//  t5
//
//  Created by manas dutta on 12/12/25.
//

import UIKit

protocol CalenderVCDelegate: AnyObject {
    func didSelectDate(_ date: String,identifier: String)
}

class calenderVC: UIViewController {
    
    @IBOutlet weak var HOLDERVIEW: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var identifier: String = ""
    weak var delegate: CalenderVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackView.layer.cornerRadius = 10
        self.HOLDERVIEW.layer.cornerRadius = 10
        datePicker.datePickerMode = .date
        //To
        if identifier == "guardianDOB" {
            let calendar = Calendar.current
            let currentDate = Date()
            let eighteenYearsAgo = calendar.date(byAdding: .year, value: -18, to: currentDate)
            datePicker.maximumDate = eighteenYearsAgo // Set maximum selectable date to 18 years ago
        }else if identifier == "To" {
            let calendar = Calendar.current
            let currentDate = Date()
            let eighteenYearsAgo = calendar.date(byAdding: .year, value: -18, to: currentDate)
            datePicker.maximumDate = eighteenYearsAgo // Set maximum selectable date to 18 years ago
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideHolderView(_:)))
        tapGesture.cancelsTouchesInView = false // Allow touches to propagate to other views
        view.addGestureRecognizer(tapGesture)
    }
    @objc func handleTapOutsideHolderView(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.view)
        
        // Check if the tap is outside the HOLDERVIEW
        if !HOLDERVIEW.frame.contains(tapLocation) {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        
        delegate?.didSelectDate(selectedDate, identifier: identifier)
        dismiss(animated: true)
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
