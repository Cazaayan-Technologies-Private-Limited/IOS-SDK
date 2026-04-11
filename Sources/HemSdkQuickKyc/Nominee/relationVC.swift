//
//  relationVC.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

protocol RelationshipScheme: AnyObject {
    func didSelectRelation(type:String,id:String,identifier: String)
}

class relationVC: UIViewController {
    
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var holderview: UIView!
    
    var mobiledecodeArray: String?
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var identifier: String = ""
    weak var delegate:RelationshipScheme?
    var relations: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "relationTVC", bundle: Bundle.module), forCellReuseIdentifier: "relationTVC")
        holderview.layer.cornerRadius = 10
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID,decodeByteArrayString  in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.fetchedUserId = userId
                self.fetchedSessionID = sessionID
                self.mobiledecodeArray = decodeByteArrayString
                print("UserID: \(userId), SessionID: \(sessionID)")
                //                self.GetRelation()
            } else {
                print("No UserID or SessionID found.")
            }
        }
        tableView.reloadData()
        adjustTableViewHeight()
        GetRelation()
    }
    
    func adjustTableViewHeight() {
        DispatchQueue.main.async {
            self.tableviewHeight.constant = (self.tableView.contentSize.height-40)
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func GetRelation() {
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W", in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.GetRelation()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                
                "TokenId": tokenId,
                "RelationType":"N"
            ]
            ///DropDownManagement/GetRelation
            print(parameters)
            let Url = "DropDownManagement/GetRelation"
            
            apiCall(url: Url, method: "POST", parameters: parameters as [String : Any], view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("GetRelation Response: \(jsonResponse)")
                    
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                            
                        case "000000":
                            if let relationList = jsonResponse["RelationList"] as? [[String: Any]] {
                                DispatchQueue.main.async {
                                    self.relations = relationList
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
                    print("GetRelation API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension relationVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "relationTVC") as! relationTVC
        let relation = relations[indexPath.row]
        cell.relationLbl.text = relation["Relation"] as? String
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRelation = relations[indexPath.row]
        if let relationType = selectedRelation["Relation"] as? String,
           let relationId = selectedRelation["Id"] as? String {
            delegate?.didSelectRelation(type: relationType, id: relationId, identifier: identifier)
            dismiss(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

