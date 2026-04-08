//
//  BrokerageVC.swift
//  t5
//
//  Created by manas dutta on 19/12/25.
//

import UIKit

enum BrokerageFilter {
    case equity
    case commodity
}

class BrokerageVC: UIViewController, @MainActor BrokerageCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var brokeragePlans: [[String: Any]] = []
    var allPlans: [BrokeragePlan] = []
     var filteredPlans: [BrokeragePlan] = []
  
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var mobiledecodeArray: String?
    var regId: String?
    var filter: BrokerageFilter = .equity
    weak var delegate: BrokerageSelectionDelegate?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "BrokerageTVC", bundle: Bundle.module), forCellReuseIdentifier: "BrokerageTVC")
            
            fetchBrokeragePlans()
            
            CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self]
                userId, sessionID, decodeByteArrayString in
                
                guard let self = self else { return }
                
                guard let userId = userId,
                      let sessionID = sessionID else {
                    print("❌ No UserID or SessionID found.")
                    return
                }
                
                self.fetchedUserId = userId
                self.fetchedSessionID = sessionID
                self.mobiledecodeArray = decodeByteArrayString
                
                print("✅ UserID: \(userId), SessionID: \(sessionID)")
                
                // ✅ NOW SAFE TO CALL APIs
                fetchBrokeragePlans()
            }
        }
    
    func didTapClose() {
         dismiss(animated: true)
     }
    
    
    func didSelectPlan(_ plan: BrokeragePlan) {
        delegate?.didSelectBrokerage(plan, filter: filter)
        dismiss(animated: true)
    }
    
    func applyFilter() {
        switch filter {
        case .equity:
            filteredPlans = allPlans.filter {
                $0.segment.uppercased() == "EQUITY" ||
                $0.segment.uppercased() == "BOTH"
            }

        case .commodity:
            filteredPlans = allPlans.filter {
                $0.segment.uppercased() == "COMMODITY" ||
                $0.segment.uppercased() == "BOTH"
            }
        }

        tableView.reloadData()
    }
        
        func fetchBrokeragePlans() {
            CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [weak self] tokenId in
                guard let self = self, let tokenId = tokenId else {
                    // Handle no token
                    print("No token available")
                    return
                }
                
                let parameters: [String: Any] = [
                    "RegId": self.regId ?? "",
                    "UserId": self.fetchedUserId ?? "",
                    "TokenId": tokenId,
                    "SessionId": self.fetchedSessionID ?? ""
                ]
                
                let Url = "BrokeragePlan/ViewNONAPIBrokeragePlanClientForClient"
                
                apiCall(url: Url, method: "POST", parameters: parameters, view: self.view, loaderText: "Loading plans...") { result in
                    switch result {
                    case .success(let jsonResponse):
                        print("BrokeragePlan Response: \(jsonResponse)")
                        
                        if let list = jsonResponse["List"] as? [[String: Any]] {
                            DispatchQueue.main.async {

                                // ✅ convert dictionary → model
                                self.allPlans = list.map { BrokeragePlan(dict: $0) }

                                // ✅ apply segment filter
                                self.applyFilter()
                            }
                        }
                        
                    case .failure(let error):
                        print("API Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    extension BrokerageVC: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredPlans.count
        }
        
        func tableView(_ tableView: UITableView,
                       cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(
                withIdentifier: "BrokerageTVC",
                for: indexPath
            ) as! BrokerageTVC

            let plan = filteredPlans[indexPath.row]   // ✅ CORRECT

            cell.testLbl.text = plan.name

            let raw = plan.raw

            cell.intraLbl.text =
                "\(raw["EquityCashIntradayPlan"] ?? "") \(raw["EquityCashIntradayType"] ?? "")"

            cell.deliveryLbl.text =
                "\(raw["EquityCashDeliveryPlan"] ?? "") \(raw["EquityCashDeliveryType"] ?? "")"

            cell.futureLbl.text =
                "\(raw["EquityFNOFuturePlan"] ?? "") \(raw["EquityFNOFutureType"] ?? "")"

            cell.optionLbl.text =
                "\(raw["EquityFNOOptionPlan"] ?? "") \(raw["EquityFNOOptionType"] ?? "")"

            cell.currencyLbl.text =
                "\(raw["CurrencyFuturePlan"] ?? "") \(raw["CurrencyFutureType"] ?? "")"

            cell.currencyOptionLbl.text =
                "\(raw["CurrencyOptionPlan"] ?? "") \(raw["CurrencyOptionType"] ?? "")"

            // ✅ THESE TWO LINES WERE MISSING
            cell.plan = plan
            cell.delegate = self

            return cell
        }

        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 450 // Adjust based on your cell design
        }
    }
