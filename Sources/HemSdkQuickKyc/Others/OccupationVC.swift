//
//  OccupationVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

protocol OccupationSelectedDelegate:AnyObject {
    func didSelectOccupation(id: String, name: String)
}

class OccupationVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var holderview: UIView!
    
    var occupationList: [[String: Any]] = []
    weak var delegate : OccupationSelectedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "customTVC", bundle: Bundle.module), forCellReuseIdentifier: "customTVC")
        holderview.layer.cornerRadius = 10
        GetOccupationMaster()
        tableView.reloadData()
        adjustTableViewHeight()
    }
    
    func adjustTableViewHeight() {
        DispatchQueue.main.async {
            self.tableviewHeight.constant = (self.tableView.contentSize.height-30)
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func GetOccupationMaster(){
        let Url = "DropDownManagement/GetOccupationMaster"
        apiCall(url: Url, method: "POST", parameters: [:] , view: self.view) { result in
            switch result {
            case .success(let jsonResponse):
                print("GetOccupationMaster Response: \(jsonResponse)")
                if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
                    if let occupationList = jsonResponse["OccupationMasterList"] as? [[String: Any]] {
                        self.occupationList = occupationList
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.tableView.rowHeight = UITableView.automaticDimension
                            self.tableView.estimatedRowHeight = 100
                            self.adjustTableViewHeight()
                        }
                    }
                } else {
                    print("Unhandled error code: \(String(describing: jsonResponse["ErrorCode"]))")
                }
            case .failure(let error):
                print("Login API call failed: \(error.localizedDescription)")
            }
        }
    }
}

extension OccupationVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return occupationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTVC") as! customTVC
        let occupation = occupationList[indexPath.row]
        cell.selectLabel.text = occupation["Name"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOccupation = occupationList[indexPath.row]
        if let id = selectedOccupation["Id"] as? String, let name = selectedOccupation["Name"] as? String {
            delegate?.didSelectOccupation(id: id, name: name)
        }
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
