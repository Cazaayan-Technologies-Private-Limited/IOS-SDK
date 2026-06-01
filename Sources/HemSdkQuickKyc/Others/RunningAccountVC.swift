//
//  RunningAccountVC.swift
//  HemSdkQuickKyc
//
//  Created by APPLE on 26/05/26.
//

import UIKit

struct RunningAccount {
    let id: String
    let name: String
}

protocol runningAccountDelegate: AnyObject {
    func didselectrunning(id:String,type: String)
}

class RunningAccountVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var holderview: UIView!
    
    weak var delegate : runningAccountDelegate?
    var runningList: [RunningAccount] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "customTVC", bundle: Bundle.module), forCellReuseIdentifier: "customTVC")
        
        runningList = [
             RunningAccount(id: "0", name: "Select"),
             RunningAccount(id: "30", name: "30 Days"),
             RunningAccount(id: "90", name: "90 Days")
         ]
        
        holderview.layer.cornerRadius = 10
        tableView.reloadData()
       // adjustTableViewHeight()
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
}

    extension RunningAccountVC:UITableViewDelegate,UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return runningList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customTVC") as! customTVC
            let income = runningList[indexPath.row]
            cell.selectLabel.text = income.name
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedIncome = runningList[indexPath.row]
            delegate?.didselectrunning(id: selectedIncome.id, type: selectedIncome.name)
            dismiss(animated: true)
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 40
            
        }
    }

