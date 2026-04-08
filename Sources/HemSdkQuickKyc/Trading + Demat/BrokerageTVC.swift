//
//  BrokerageTVC.swift
//  t5
//
//  Created by manas dutta on 19/12/25.
//

import UIKit

struct BrokeragePlan {
    let id: Int
    let name: String
    let segment: String
    let raw: [String: Any]

    init(dict: [String: Any]) {
        self.id = dict["BrokerageId"] as? Int ?? 0
        self.name = dict["BrokeragePlanName"] as? String ?? ""
        self.segment = dict["Segment"] as? String ?? ""
        self.raw = dict
    }
}

protocol BrokerageCellDelegate: AnyObject {
    func didTapClose()
    func didSelectPlan(_ plan: BrokeragePlan)
}

class BrokerageTVC: UITableViewCell {
    
    @IBOutlet weak var testLbl: UILabel!
    @IBOutlet weak var intraLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var futureLbl: UILabel!
    @IBOutlet weak var optionLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var currencyOptionLbl: UILabel!
    
    weak var delegate: BrokerageCellDelegate?
    var plan: BrokeragePlan?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func selectBrokerage(_ sender: UIButton) {
        if let plan = plan {
                  delegate?.didSelectPlan(plan)
              }
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        delegate?.didTapClose()
    }
}
