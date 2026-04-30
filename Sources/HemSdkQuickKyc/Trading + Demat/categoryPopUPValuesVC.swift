//
//  categoryPopUPValuesVC.swift
//  t5
//
//  Created by manas dutta on 20/12/25.
//

import UIKit

@MainActor
protocol CategoryPopupDelegate: AnyObject {
    func didSelectValue(_ value: String)
}

class categoryPopUPValuesVC: UIViewController {
    
    @IBOutlet weak var popupTableView: UITableView!
    
    var categoriName: String = ""
    var commodityValues: [String] = []
    weak var delegate: CategoryPopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupTableView.register(UINib(nibName: "popupValuecells", bundle: Bundle.module), forCellReuseIdentifier: "popupValuecells")
    }
}

extension categoryPopUPValuesVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commodityValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "popupValuecells", for: indexPath) as! popupValuecells
        cell.ValueLabel.text = commodityValues[indexPath.row]
        return cell
    }
    // When a row is selected, send the selected value back using the delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedValue = commodityValues[indexPath.row]
        delegate?.didSelectValue(selectedValue)
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

