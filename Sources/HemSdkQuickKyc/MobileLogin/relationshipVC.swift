//
//  relationshipVC.swift
//  t5
//
//  Created by manas dutta on 12/12/25.
//

import UIKit

protocol RelationshipSelectionDelegate: AnyObject {
    func didSelectRelation(_ relation: String)
}

class relationshipVC: UIViewController {
    
    var relations: [[String: Any]] = []
    weak var delegate: RelationshipSelectionDelegate?
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "relationshipTVC", bundle: Bundle.module), forCellReuseIdentifier: "relationshipTVC")
        print("data relation \(relations)")
        DispatchQueue.main.async {
            self.tableview.reloadData()
            self.adjustTableViewHeight()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustTableViewHeight()
    }
    
    func adjustTableViewHeight() {
        DispatchQueue.main.async {
            self.tableviewHeight.constant = self.tableview.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func cancelbtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension relationshipVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "relationshipTVC", for: indexPath) as! relationshipTVC
        let relation = relations[indexPath.row]["Relation"] as? String ?? ""
        cell.relationLabel.text = relation
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get the selected relation
        let selectedRelation = relations[indexPath.row]["Relation"] as? String ?? ""
        
        // Call the delegate method to send the selected relation back
        delegate?.didSelectRelation(selectedRelation)
        
        // Dismiss the relationshipVC
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

