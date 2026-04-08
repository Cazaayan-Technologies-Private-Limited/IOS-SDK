//
//  annualIncomeVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

struct AnnualIncome {
    let id: String
    let name: String
}

protocol annualIncomeDelegate: AnyObject {
    func didselectincome(id:String,type: String)
}

class annualIncomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var holderview: UIView!
    
    weak var delegate : annualIncomeDelegate?
    var incomeList: [AnnualIncome] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "customTVC", bundle: Bundle.module), forCellReuseIdentifier: "customTVC")
        holderview.layer.cornerRadius = 10
        tableView.reloadData()
        adjustTableViewHeight()
        GetAnnualIncomeMaster()
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
    
    func GetAnnualIncomeMaster(){
        
        let Url = "DropDownManagement/GetAnnualIncomeMaster"
        
        apiCall(url: Url, method: "POST", parameters: [:] , view: self.view) { result in
            switch result {
            case .success(let jsonResponse):
                print("GetAnnualIncomeMaster Response: \(jsonResponse)")
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "000000":
                        if let incomeArray = jsonResponse["AnnualIncomeMasterList"] as? [[String: Any]] {
                            self.incomeList = incomeArray.map {
                                AnnualIncome(id: "\($0["Id"] ?? "")", name: "\($0["Name"] ?? "")")
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.tableView.rowHeight = UITableView.automaticDimension
                                self.tableView.estimatedRowHeight = 300
                                self.adjustTableViewHeight()
                            }
                        }
                    default:
                        print("Unhandled error code: \(errorCode)")
                    }
                }
            case .failure(let error):
                print("Login API call failed: \(error.localizedDescription)")
            }
        }
    }
}

extension annualIncomeVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTVC") as! customTVC
        let income = incomeList[indexPath.row]
        cell.selectLabel.text = income.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIncome = incomeList[indexPath.row]
        delegate?.didselectincome(id: selectedIncome.id, type: selectedIncome.name)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
