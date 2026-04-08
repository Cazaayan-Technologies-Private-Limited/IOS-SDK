//
//  DpPlanVC.swift
//  t5
//
//  Created by manas dutta on 19/12/25.
//

import UIKit

class DpPlanVC: UIViewController {
    
    @IBOutlet weak var Holderview1: UIView!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var mobiledecodeArray: String?
    var IsSchemeExternal: String?
    var expandedIndexPath: IndexPath?
    var viewNameDPData: [[String: Any]] = []
    var schemeData: [[String: Any]] = []
    var isHolderView1Visible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.holderView.layer.cornerRadius = 10
        //self.Holderview1.layer.cornerRadius = 10
        //self.tableview.layer.cornerRadius = 10
        CoreDataHelper.fetchUserId(entityName: "MobileUser") {
            [weak self] userId, sessionID, decodeByteArrayString in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.fetchedUserId = userId
                self.fetchedSessionID = sessionID
                self.mobiledecodeArray = decodeByteArrayString
                print("UserID: \(userId), SessionID: \(sessionID)")
            } else {
                print("No UserID or SessionID found.")
            }
        }
        tableview.register(
            UINib(nibName: "viewAllTVC", bundle: Bundle.module),
            forCellReuseIdentifier: "viewAllTVC")
        tableview.reloadData()
        adjustTableViewHeight()
        self.ViewDPScheme()
    }
    func adjustTableViewHeight() {
        DispatchQueue.main.async {
            self.tableviewHeight.constant = self.tableview.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func CancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func ViewDPScheme() {
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
            [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(decodeByteArrayToString: self.mobiledecodeArray ?? "", USERID: self.fetchedUserId ?? "", SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                    if success {
                        // Call SIXTHAPI after tokenMobile API call is successful
                        self.ViewDPScheme()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "UserId": fetchedUserId,
                "SessionID": fetchedSessionID,
                "DPSchemeCode": "",
                "DPSchemeName": "",
                "TokenId": tokenId,
                "IsSchemeExternal": "0",
                "ALL": true,
            ]
            print(parameters)
            let Url = "DPScheme/ViewDPScheme"
            
            apiCall(
                url: Url, method: "POST",
                parameters: parameters as [String: Any], view: self.view
            ) { result in
                switch result {
                case .success(let jsonResponse):
                    print("DPSchemeName Response: \(jsonResponse)")
                    if let errorCode = jsonResponse["ErrorCode"] as? String
                    {
                        switch errorCode {
                        case "000000":
                            DispatchQueue.main.async {
                                if let viewNameDP = jsonResponse["ViewNameDP"] as? [[String: Any]] {
                                    self.schemeData = viewNameDP
                                    self.tableview.reloadData()
                                    self.tableview.rowHeight = UITableView.automaticDimension
                                    self.tableview.estimatedRowHeight = 300
                                    
                                    self.adjustTableViewHeight()
                                }
                                
                            }
                        default:
                            print("Unhandled error code: \(errorCode)")
                        }
                    }
                case .failure(let error):
                    print(
                        "Login API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension DpPlanVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
    -> Int
    {
        return schemeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "viewAllTVC") as! viewAllTVC
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewAllTVC") as! viewAllTVC
        let scheme = schemeData[indexPath.row]
        
        if let schemeName = scheme["DPSchemeName"] as? String {
            cell.schemeNameLbl.text = schemeName
        }
        cell.viewDPData = scheme["ViewDP"] as? [[String: Any]] ?? []
        cell.schemeIdentifier = scheme["DPSchemeName"] as? String
        
        let isExpanded = indexPath == expandedIndexPath
        cell.holderView2.isHidden = !isExpanded
        cell.cellTableview.isHidden = !isExpanded
        cell.layer.cornerRadius = 10
        // Reload inner table view only when expanded
        if isExpanded {
            cell.reloadCellData()
        }
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        if let previousIndexPath = expandedIndexPath, previousIndexPath != indexPath {
            expandedIndexPath = indexPath
            tableView.reloadRows(at: [previousIndexPath, indexPath], with: .automatic)
        } else if expandedIndexPath == indexPath {
            expandedIndexPath = nil
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            expandedIndexPath = indexPath
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        DispatchQueue.main.async {
            self.adjustTableViewHeight()
        }
    }
}

