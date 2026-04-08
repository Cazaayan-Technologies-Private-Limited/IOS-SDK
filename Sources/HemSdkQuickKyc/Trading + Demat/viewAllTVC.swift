//
//  viewAllTVC.swift
//  t5
//
//  Created by manas dutta on 19/12/25.
//

import UIKit

class viewAllTVC: UITableViewCell {
    
    @IBOutlet weak var schemeNameLbl: UILabel!
    @IBOutlet weak var holderView1: UIView!
    @IBOutlet weak var holderView2: UIView!
    @IBOutlet weak var celltableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var cellTableview: UITableView!
    
    var viewDPData: [[String: Any]] = []
    var schemeIdentifier: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.holderView2.isHidden = true
        self.cellTableview.isHidden = true
        holderView1.layer.cornerRadius = 10
        holderView2.layer.cornerRadius = 10
//        cellTableview.delegate = self
//        cellTableview.dataSource = self
        cellTableview.register(UINib(nibName: "viewPlanTVC", bundle: Bundle.module), forCellReuseIdentifier: "viewPlanTVC")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func reloadCellData() {
        DispatchQueue.main.async {
            self.cellTableview.reloadData()
            self.adjustTableViewHeight()
        }
    }
    
    func adjustTableViewHeight() {
        DispatchQueue.main.async {
            self.cellTableview.layoutIfNeeded()
            self.celltableviewHeight.constant = self.cellTableview.contentSize.height
            self.layoutIfNeeded()
            if let parentTableView = self.superview as? UITableView {
                parentTableView.beginUpdates()
                parentTableView.endUpdates()
            }
        }
    }
    
    @IBAction func expandBtn(_ sender: UIButton) {
    }
}

//extension viewAllTVC : UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewDPData.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "viewPlanTVC") as! viewPlanTVC
//        let dpData = viewDPData[indexPath.row]
//        
//        cell.label1.text = dpData["Particulars"] as? String
//        cell.label2.text = dpData["Charges"] as? String
//        
//        if let chargeable = dpData["ChargeableForAccOpening"] as? String {
//            cell.label3.text = chargeable == "1" ? "Yes" : "No"
//        }
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//}


