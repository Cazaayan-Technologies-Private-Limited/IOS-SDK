//
//  TradingExperienceVC.swift
//  HemSdkQuickKyc
//
//  Created by Manas Datta on 21/05/26.
//

import UIKit

struct TradingExperience {
      let id: String
      let name: String
  }

  protocol tradingExperienceDelegate: AnyObject {
      func didselectExperience(id:String,type: String)
  }

class TradingExperienceVC: UIViewController {

        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
        @IBOutlet weak var holderview: UIView!
        
        weak var delegate : tradingExperienceDelegate?
        var experienceList: [TradingExperience] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.register(UINib(nibName: "customTVC", bundle: Bundle.module), forCellReuseIdentifier: "customTVC")
            holderview.layer.cornerRadius = 10
            tableView.reloadData()
            adjustTableViewHeight()
            
            experienceList = (0...30).map {
                 TradingExperience(
                     id: "\($0)",
                     name: "\($0)"
                 )
             }
            
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
        
      }
    

    extension TradingExperienceVC:UITableViewDelegate,UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return experienceList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customTVC") as! customTVC
            let income = experienceList[indexPath.row]
            cell.selectLabel.text = income.name
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedExperience = experienceList[indexPath.row]
            delegate?.didselectExperience(id: selectedExperience.id, type: selectedExperience.name)
            dismiss(animated: true)
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 40
        }
    }
