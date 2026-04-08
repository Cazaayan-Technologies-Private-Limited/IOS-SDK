//
//  networthCalender.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

protocol NetworthCalendarDelegate: AnyObject {
    func didSelectNetworthDate(_ date: Date)
}

class networthCalender: UIViewController {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: NetworthCalendarDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        let today = Date()
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: today)!
        datePicker.minimumDate = oneYearAgo
        datePicker.maximumDate = today
        datePicker.date = today
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func okBtnTapped(_ sender: UIButton) {
        let selectedDate = datePicker.date
        delegate?.didSelectNetworthDate(selectedDate)
        dismiss(animated: true)
    }
}
