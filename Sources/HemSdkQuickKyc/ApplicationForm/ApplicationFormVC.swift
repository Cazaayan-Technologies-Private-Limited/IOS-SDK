//
//  ApplicationFormVC.swift
//  t5
//
//  Created by manas dutta on 12/12/25.
//

import UIKit

protocol ReloadPageDelegate: AnyObject {
    func reloadPageData()
}

struct StepItem {
    let title: String
    let index: Int
    let status: StepStatus
}

enum StepStatus: String {
    case pending = "PENDING"
    case approved = "APPROVED"
    case rejected = "REJECTED"
    
    var color: UIColor {
        switch self {
        case .pending:
            return .systemGray5
        case .approved:
            return .systemBlue
        case .rejected:
            return .systemRed
        }
    }
}

class ApplicationFormVC: UIViewController {
    
    private let navigationView = UIView()
    private let cardView = UIView()
    private let stackView = UIStackView()
    private let termsButton = UIButton(type: .system)
    private let nameLabel = UILabel()
    
    var fetchedUserId: String?
    var fetchedSessionID: String?
    var mobiledecodeArray: String?
    var decodeArray:String?
    var panNo: String?
    var regId: String?
    var PANName : String?
    var EmailId : String?
    var sectionStatus: [String: String] = [:]
    var isDerivative: String = "N"
    var networth: String?
    var networthDate: String?
    private var steps: [StepItem] = []
    var isDataLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGroupedBackground
        setupCustomNavigationBar()
        setupCard()
        setupBottomTermsView()
        SIXTHAPI(userID: fetchedUserId ?? "")
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .appBackground
        
        if let savedPan = UserDefaults.standard.string(forKey: "SavedPAN") {
            self.panNo = savedPan
            print("✅ Retrieved PAN: \(savedPan)")
        } else {
            print("❌ No PAN found in UserDefaults")
        }
    }
    
    
    
    private func reloadSteps(_ steps: [StepItem]) {
        self.steps = steps
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for step in steps {
            let view = StepView(step: step)
            view.onTap = { [weak self] in
                self?.handleStepTap(step)
            }
            stackView.addArrangedSubview(view)
        }
    }
    
    private func handleStepTap(_ step: StepItem) {
        
        //        let previousSteps = steps.filter { $0.index < step.index }
        //
        //        // ❗ Block ONLY if any previous step is PENDING
        //        let hasPendingPreviousStep = previousSteps.contains {
        //            $0.status == .pending
        //        }
        //
        //        if hasPendingPreviousStep {
        //            showAlert("Please complete previous step first")
        //            return
        //        }
        
        //  ✅ Approved OR Rejected → allow navigation
        
        guard isDataLoaded else {
            showAlert("Please wait, loading data...")
            return
        }
        
        navigateToStep(step)
    }
    
    private func navigateToStep(_ step: StepItem) {
        
        guard let pan = panNo, !pan.isEmpty,
              let reg = regId, !reg.isEmpty else {
            showAlert("PAN or RegId missing. Please wait.")
            return
        }
        
        let vc: UIViewController
        
        switch step.title {
        case "Basic":
            let storyboard = UIStoryboard(name: "DigiLocker", bundle: Bundle.module)
            let vc = storyboard.instantiateViewController(identifier: "DigiLocker_a") as! DigiLocker_a
            vc.panNo = panNo
            vc.RegId = regId
            vc.PANName = PANName
            vc.EmailId = EmailId
            vc.digilockerDone = "Done"
            self.navigationController?.pushViewController(vc, animated: true)
        case "Trading":
            let storyboard = UIStoryboard(name: "TradingandDemat", bundle: Bundle.module)
            let vc = storyboard.instantiateViewController(identifier: "TradingandDematVC") as! TradingandDematVC
            let savedPAN = UserDefaults.standard.string(forKey: "SavedPAN")
            let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.panNo
            vc.panNo = finalPAN
            vc.regId = regId
            self.navigationController?.pushViewController(vc, animated: true)
        case "Bank":
            let storyboard = UIStoryboard(name: "Bank", bundle: Bundle.module)
            let vc = storyboard.instantiateViewController(identifier: "BankVC") as! BankVC
            let savedPAN = UserDefaults.standard.string(forKey: "SavedPAN")
            let finalPAN = (savedPAN?.isEmpty == false) ? savedPAN : self.panNo
            vc.panNo = finalPAN
            vc.regId = regId
            self.navigationController?.pushViewController(vc, animated: true)
        case "Others":
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "OtherDetails", bundle: Bundle.module)
                let vc = storyboard.instantiateViewController(identifier: "OtherDetailsVC") as! OtherDetailsVC
                vc.panNo = self.panNo
                vc.regId = self.regId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case "Nominee":
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Nominee", bundle: Bundle.module)
                let vc = storyboard.instantiateViewController(identifier: "NomineeVC") as! NomineeVC
                vc.panNo = self.panNo
                vc.RegId = self.regId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case "Documents":
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Document", bundle: Bundle.module)
                let vc = storyboard.instantiateViewController(identifier: "DocumentVC") as! DocumentVC
                vc.PanNo = self.panNo
                vc.RegId = self.regId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            return
        }
    }
    
    
    private func setupCard() {
        
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 16),
            //cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
        
        let title = UILabel()
        title.text = "Application Status"
        title.font = .boldSystemFont(ofSize: 18)
        
        nameLabel.text = ""
        nameLabel.font = .systemFont(ofSize: 14)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(title)
        cardView.addSubview(nameLabel)
        cardView.addSubview(stackView)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            title.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            nameLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor)
        ])
    }
    
    private func setupCustomNavigationBar() {
        
        navigationView.backgroundColor = .appPrimary
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationView)
        
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        // Back Button
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = "Application Form"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Home Button
        let homeButton = UIButton(type: .system)
        homeButton.setImage(UIImage(systemName: "house.fill"), for: .normal)
        homeButton.tintColor = .white
        homeButton.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        
        navigationView.addSubview(backButton)
        navigationView.addSubview(titleLabel)
        navigationView.addSubview(homeButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32),
            
            homeButton.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor, constant: -16),
            homeButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),
            homeButton.widthAnchor.constraint(equalToConstant: 32),
            homeButton.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.centerXAnchor.constraint(equalTo: navigationView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor)
        ])
    }
    
    private func setupBottomTermsView() {
        
        // ✅ Terms Button
        termsButton.setTitle("  I agree to Terms & Conditions", for: .normal)
        termsButton.setImage(UIImage(systemName: "square"), for: .normal)
        termsButton.tintColor = .appBorder
        termsButton.setTitleColor(.black, for: .normal)
        termsButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        termsButton.contentHorizontalAlignment = .leading
        termsButton.addTarget(self, action: #selector(TermsAndConditionsBtn(_:)), for: .touchUpInside)
        termsButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(termsButton)
        
        NSLayoutConstraint.activate([
            //            termsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            //            termsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            termsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            termsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            termsButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func TermsAndConditionsBtn(_ sender: UIButton) {
        
        // Open terms every time user taps
        let storyboard = UIStoryboard(name: "terms", bundle: Bundle.module)
        if let vc = storyboard.instantiateViewController(
            withIdentifier: "termsVC") as? termsVC {
            
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            
            vc.dismissHandler = { [weak self] in
                guard let self = self else { return }
                
                sender.isSelected = true
                sender.setImage(
                    UIImage(systemName: "checkmark.square.fill"),
                    for: .normal
                )
            }
            
            present(vc, animated: true)
        }
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func homeTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
class StepView: UIView {
    
    private let circle = UILabel()
    private let titleLabel = UILabel()
    private let step: StepItem
    var onTap: (() -> Void)?
    
    init(step: StepItem) {
        self.step = step
        super.init(frame: .zero)
        setupUI()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        circle.text = "\(step.index)"
        circle.textAlignment = .center
        circle.layer.cornerRadius = 18
        circle.clipsToBounds = true
        circle.font = .boldSystemFont(ofSize: 14)
        circle.backgroundColor = step.status.color
        circle.textColor = .white
        circle.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = step.title
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(circle)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            circle.leadingAnchor.constraint(equalTo: leadingAnchor),
            circle.topAnchor.constraint(equalTo: topAnchor),
            circle.widthAnchor.constraint(equalToConstant: 36),
            circle.heightAnchor.constraint(equalToConstant: 36),
            
            titleLabel.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
            bottomAnchor.constraint(equalTo: circle.bottomAnchor)
        ])
    }
    
    @objc private func didTap() {
        onTap?()
    }
    
}

extension ApplicationFormVC {
    
    func mapStepStatus(_ value: Any?) -> StepStatus {
        
        // NSNumber (most common from JSON)
        if let number = value as? NSNumber {
            return number.intValue == 1 ? .approved : .pending
        }
        
        // Int
        if let intValue = value as? Int {
            return intValue == 1 ? .approved : .pending
        }
        
        // String
        if let stringValue = value as? String {
            let status = stringValue.uppercased()
            
            if status == "1" {
                return .approved
            } else if status.contains("APPROVED") {
                return .approved
            } else if status.contains("REJECT") {
                return .rejected
            } else {
                return .pending   // PAGE PENDING
            }
        }
        return .pending
    }
    
    func SIXTHAPI(userID:String){
        
        CoreDataHelper.fetchUserId(entityName: "MobileUser") { [weak self] userId, sessionID , decodeByteArrayString in
            guard let self = self else { return }
            
            if let userId = userId, let sessionID = sessionID {
                self.fetchedUserId = userId
                self.fetchedSessionID = sessionID
                self.decodeArray = decodeByteArrayString
                print("UserID: \(userId), SessionID: \(sessionID)")
                
            } else {
                print("No UserID or SessionID found.")
            }
        }
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { tokenId in
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
                        self.SIXTHAPI(userID: userID)
                    } else {
                        print("Token generation failed.")
                    }
                }
                print("No tokens available. Please reload the tokens.")
                return
            }
            let parameters: [String: Any] = [
                "UserId": self.fetchedUserId as Any,
                "TokenId": tokenId
            ]
            print("6th api params\(parameters)")
            let sixthUrl = "ActiveApplication/GetActiveApplicationCL"
            // API call
            apiCall(url: sixthUrl, method: "POST", parameters: parameters, view: self.view) { result in
                switch result {
                case .success(let jsonResponse):
                    print("SIXTHAPI Response: \(jsonResponse)")
                    self.panNo = jsonResponse["PanNo"] as? String
                    self.regId = jsonResponse["RegId"] as? String
                    self.PANName = jsonResponse["PANName"] as? String
                    self.EmailId = jsonResponse["EmailId"] as? String
                    self.sectionStatus["Trading_Status"] = jsonResponse["Trading_Status"] as? String
                    self.sectionStatus["DP_Status"] = jsonResponse["DP_Status"] as? String
                    self.sectionStatus["BankDpTradStatus"] = jsonResponse["BankDpTradStatus"] as? String
                    self.sectionStatus["OtherStatus"] = jsonResponse["OtherStatus"] as? String
                    self.sectionStatus["NomineeStatus"] = jsonResponse["NomineeStatus"] as? String
                    self.sectionStatus["DocumentStatus"] = jsonResponse["DocumentStatus"] as? String
                    if let errorCode = jsonResponse["ErrorCode"] as? String {
                        switch errorCode {
                        case "999992":
                            DispatchQueue.main.async {
                                CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
                                print("All TokenMobile entries deleted due to error code 999992")
                                
                                // Regenerate tokens
                                CoreDataHelper.generateToken(decodeByteArrayToString: self.decodeArray ?? "", USERID: userID, SessionId: self.fetchedSessionID ?? "", entityName: "TokenMobile", deviceType: "W",in: self.view) { success in
                                    if success {
                                        // Retry SIXTHAPI after token regeneration
                                        self.SIXTHAPI(userID: userID)
                                    } else {
                                        print("Token generation failed.")
                                    }
                                }
                            }
                        case "000000":
                            print("errorcode 000000 called")
                            DispatchQueue.main.async{
                                
                                self.isDerivative = (jsonResponse["IsDerivative"] as? String ?? "N").uppercased()
                                self.panNo = jsonResponse["PanNo"] as? String
                                self.regId = jsonResponse["RegId"] as? String
                                self.PANName = jsonResponse["PANName"] as? String
                                self.nameLabel.text = jsonResponse["PANName"] as? String ?? "-"
                                self.isDataLoaded = true
                                
                                let steps: [StepItem] = [
                                    StepItem(title: "Basic", index: 1,
                                             status: self.mapStepStatus(jsonResponse["AadhaarStatus"])),
                                    
                                    StepItem(title: "Trading", index: 2,
                                             status: self.mapStepStatus(jsonResponse["Trading_Status"])),
                                    
                                    StepItem(title: "Bank", index: 4,
                                             status: self.mapStepStatus(jsonResponse["BankDpTradStatus"])),
                                    
                                    StepItem(title: "Others", index: 5,
                                             status: self.mapStepStatus(jsonResponse["OtherStatus"])),
                                    
                                    StepItem(title: "Nominee", index: 6,
                                             status: self.mapStepStatus(jsonResponse["NomineeStatus"])),
                                    
                                    StepItem(title: "Documents", index: 7,
                                             status: self.mapStepStatus(jsonResponse["DocumentStatus"]))
                                ]
                                
                                self.reloadSteps(steps)
                                
                            }
                        default:
                            print("Unhandled error code: \(errorCode)")
                        }
                    }
                case .failure(let error):
                    print("SIXTHAPI API call failed: \(error.localizedDescription)")
                }
            }
        }
    }
}
