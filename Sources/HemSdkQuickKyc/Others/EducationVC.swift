//
//  EducationVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

protocol EducationSelectionDelegate: AnyObject {
    func didselectEducation(id:String,type: String)
}

class EducationVC: UIViewController {
    
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var holderview: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var educationList: [[String: Any]] = []
    weak var delegate: EducationSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "customTVC", bundle: Bundle.module), forCellReuseIdentifier: "customTVC")
        holderview.layer.cornerRadius = 10
        GetEducationMaster()
        tableView.reloadData()
        adjustTableViewHeight()
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func adjustTableViewHeight() {
        DispatchQueue.main.async {
            self.tableviewHeight.constant = (self.tableView.contentSize.height-30)
            self.view.layoutIfNeeded()
        }
    }
    
    func GetEducationMaster(){
        let Url = "DropDownManagement/GetEducationMaster"
        apiCall(url: Url, method: "POST", parameters: [:] , view: self.view) { result in
            switch result {
            case .success(let jsonResponse):
                print("GetEducationMaster Response: \(jsonResponse)")
                if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
                    if let educationList = jsonResponse["EducationMasterList"] as? [[String: Any]] {
                        self.educationList = educationList
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.tableView.rowHeight = UITableView.automaticDimension
                            self.tableView.estimatedRowHeight = 300
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

extension EducationVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return educationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTVC") as! customTVC
        let education = educationList[indexPath.row]
        
        if let name = education["Name"] as? String {
            cell.selectLabel.text = name
        } else {
            print("Name not found for index: \(indexPath.row)")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEducation = educationList[indexPath.row]
        if let id = selectedEducation["Id"] as? String, let name = selectedEducation["Name"] as? String {
            delegate?.didselectEducation(id: id, type: name)
        }
        dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
