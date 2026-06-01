//
//  commodityCategoryVC.swift
//  t5
//
//  Created by manas dutta on 20/12/25.
//

import UIKit

protocol CommodityCategoryVCDelegate: AnyObject {
    func didSelectCommodityValues(selectedValues: [String: String])
}

class commodityCategoryVC: UIViewController {
    
    @IBOutlet weak var commodityCategoryTableview: UITableView!
    @IBOutlet weak var selectCategory: UIButton!
    
    weak var delegate: CommodityCategoryVCDelegate?
    var selectedCommodityKeys: [String] = []
    var selectedCommodityValuesArray: [String] = []
    var panNo: String?
    var regId: String?
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var mobiledecodeArray: String?
    var selectedCommodityValues: [String: String] = [:]
    var commodityCategories: [[String: Any]] = []
    var currentCell: CommodityTVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commodityCategoryTableview.register(UINib(nibName: "CommodityTVC", bundle: Bundle.module), forCellReuseIdentifier: "CommodityTVC")
        self.selectCategory.layer.cornerRadius = 15
        
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
            Task { @MainActor in
                guard let self = self else { return }
                if let userId = userId, let sessionID = sessionID {
                    self.fetchedUserId = userId
                    self.fetchedSessionID = sessionID
                    self.mobiledecodeArray = decodeByteArrayString
                    print("UserID: \(userId), SessionID: \(sessionID)")
                    
                    // ✅ Fetch category master first, then trading details
                    self.GetCommodityCategoriMaster {
                        self.ViewTradingDetails()
                    }
                } else {
                    print("No UserID or SessionID found.")
                }
            }
        }
    }
    
    func GetCommodityCategoriMaster(completion: (@Sendable () -> Void)? = nil) {
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { [self] tokenId in
            guard let tokenId = tokenId else {
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self
                        .mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W",
                    in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.GetCommodityCategoriMaster()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "UserId": fetchedUserId,
                "PanNo": panNo,
                "RegId": regId,
                "TokenId": tokenId
            ]
            print(parameters)
            
            let Url = "TradingDetails/GetCommodityCategoriMaster"
            
            apiCall(url: Url, method: "POST", parameters: parameters as [String: Any], view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("GetCommodityCategoriMaster Response: \(jsonResponse)")
                    
                    // Check for a valid response
                    if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000",
                       let categories = jsonResponse["CommodityCategori"] as? [[String: Any]] {
                        
                        let safeCategories = categories   // ✅ copy outside
                        
                        self.commodityCategories = safeCategories
                        self.commodityCategoryTableview.reloadData()
                        completion?()
                        //}
                    } else {
                        print("Error: \(jsonResponse)")
                        
                    }
                case .failure(let error):
                    print("API call failed: \(error.localizedDescription)")
                    
                }
            }
        }
    }
    
    func ViewTradingDetails() {
        
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") {
            [self] tokenId in
            guard let tokenId = tokenId else {
                // Handle the case where no tokens are available
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self
                        .mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile", deviceType: "W",
                    in: self.view
                ) { success in
                    if success {
                        // Retry SIXTHAPI after token regeneration
                        self.ViewTradingDetails()
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any?] = [
                "UserId": fetchedUserId,
                "PanNo": panNo,
                "RegId": regId,
                "TokenId": tokenId,
            ]
            print(parameters)
            let Url = "TradingDetails/ViewTradingDetails"
            Task { @MainActor in
                apiCall(
                    url: Url, method: "POST",
                    parameters: parameters as [String: Any], view: self.view
                ) { result in
                    switch result {
                    case .success(let jsonResponse):
                        guard let errorCode = jsonResponse["ErrorCode"] as? String else { return }
                        
                        if errorCode == "000000" {
                            
                            let safeResponse = jsonResponse // snapshot
                            
                            Task { @MainActor in
                                self.updateui(with: safeResponse)
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
    

    func updateui(with response: [String: Any]) {
        if let rawKeys = response["CommodityCategoriKey"] as? [Any],
           let rawValues = response["CommodityCategoriValue"] as? [Any] {
            
            let keys = flattenArray(rawKeys)
            let values = flattenArray(rawValues)
            
            selectedCommodityKeys = keys
            selectedCommodityValuesArray = values
            
            // Build dictionary (Key → Value mapping from API)
            selectedCommodityValues.removeAll()
            for (index, key) in keys.enumerated() {
                if index < values.count {
                    selectedCommodityValues[key] = values[index]
                }
            }
            
            // 🔑 Reconcile with commodityCategories (to match categoryName)
            for category in commodityCategories {
                if let categoryName = category["CategoriName"] as? String,
                   let savedValue = selectedCommodityValues[categoryName] {
                    selectedCommodityValues[categoryName] = savedValue
                }
            }
            print("Final Mapped Commodity Values: \(selectedCommodityValues)")
            DispatchQueue.main.async {
                self.commodityCategoryTableview.reloadData()
            }
        }
    }
    
    // Recursive function to flatten nested arrays
    func flattenArray(_ array: [Any]) -> [String] {
        var result: [String] = []
        for item in array {
            if let str = item as? String, !str.trimmingCharacters(in: .whitespaces).isEmpty {
                result.append(str)
            } else if let nested = item as? [Any] {
                result.append(contentsOf: flattenArray(nested))
            }
        }
        return result
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func selectCategoryBtn(_ sender: UIButton) {
        
        for category in commodityCategories {
            if let categoryName = category["CategoriName"] as? String,
               selectedCommodityValues[categoryName] == nil {
                selectedCommodityValues[categoryName] = "Others"
            }
        }
        
        delegate?.didSelectCommodityValues(selectedValues: selectedCommodityValues)
        self.navigationController?.popViewController(animated: true)
    }
    
    func formatArrayAsString(_ array: [String]) -> String {
        return "[\(array.joined(separator: ", "))]"
    }
}


extension commodityCategoryVC: UITableViewDelegate,UITableViewDataSource, CommodityTVCDelegate,  CategoryPopupDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commodityCategories.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CommodityTVC",
            for: indexPath
        ) as! CommodityTVC
        
        let category = commodityCategories[indexPath.row]
        
        guard
            let categoryName = category["CategoriName"] as? String,
            let commodityValue = category["CommodityValue"] as? [[String: Any]]
        else {
            return cell
        }
        
        let values = commodityValue.compactMap {
            $0["CategoriValueName"] as? String
        }
        
        cell.commodityNameLabel?.text = categoryName
        cell.commodityValues = values
        cell.delegate = self
        
        let selectedValue =
        selectedCommodityValues[categoryName] ?? "Others"
        
        cell.updateCommodityButton(with: selectedValue)
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "CommodityTVC", for: indexPath) as! CommodityTVC
    //        let category = commodityCategories[indexPath.row]
    //        if let categoryName = category["CategoriName"] as? String,
    //           let commodityValue = category["CommodityValue"] as? [[String: Any]] {
    //
    //            let values = commodityValue.compactMap { $0["CategoriValueName"] as? String }
    //            cell.commodityNameLabel.text = categoryName
    //            cell.commodityValues = values
    //            cell.delegate = self // Set delegate
    //
    //            // Set the button title based on the selected value or default to "Select"
    //            let selectedValue = selectedCommodityValues[categoryName] ?? "Others"
    //            cell.updateCommodityButton(with: selectedValue)
    //
    //            cell.layer.cornerRadius = 10
    //        }
    //        return cell
    //    }
    
    func didTapDropdown(for cell: CommodityTVC, with values: [String]) {
        if let popupVC = storyboard?.instantiateViewController(withIdentifier: "categoryPopUPValuesVC") as? categoryPopUPValuesVC {
            popupVC.commodityValues = values
            popupVC.delegate = self // Set the delegate to receive the selected value
            
            // Pass the cell reference
            popupVC.modalPresentationStyle = .overCurrentContext
            self.present(popupVC, animated: true, completion: nil)
            
            // Store the current cell for reference
            self.currentCell = cell
        }
    }
    // Protocol method when value is selected in popup
    func didSelectValue(_ value: String) {
        if let currentCell = currentCell,
           let indexPath = commodityCategoryTableview.indexPath(for: currentCell),
           let category = commodityCategories[indexPath.row]["CategoriName"] as? String {
            // Update dictionary
            selectedCommodityValues[category] = value
            // Update the button title
            currentCell.updateCommodityButton(with: value)
            // Update arrays (keys and values)
            if !selectedCommodityKeys.contains(category) {
                selectedCommodityKeys.append(category)
                selectedCommodityValuesArray.append(value)
            } else {
                if let index = selectedCommodityKeys.firstIndex(of: category) {
                    selectedCommodityValuesArray[index] = value
                }
            }
        }
    }
    
    func didSelectCommodityValue(_ value: String, for cell: CommodityTVC) {
        if let indexPath = commodityCategoryTableview.indexPath(for: cell) {
            let cell = commodityCategoryTableview.cellForRow(at: indexPath) as? CommodityTVC
            cell?.updateCommodityButton(with: value)
        }
    }
}
