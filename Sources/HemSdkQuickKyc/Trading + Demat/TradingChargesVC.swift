//
//  UpiLinkVC.swift
//  HemSdkQuickKyc
//
//  Created by Manas Datta on 15/05/26.
//

//import UIKit
//
//class TradingChargesVC: UIViewController {
//
//    private let dimView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
//        return view
//    }()
//
//    private let bottomSheetView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 24
//        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        view.clipsToBounds = true
//        return view
//    }()
//
//    private let handleView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.systemGray4
//        view.layer.cornerRadius = 3
//        return view
//    }()
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Fees & Charges"
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//        label.textAlignment = .center
//        return label
//    }()
//
//    private let logo: UIImageView = {
//        let image = UIImageView()
//        image.image = UIImage(systemName: "doc.text")
//        image.tintColor = UIColor.appPrimary
//        image.contentMode = .scaleAspectFit
//        image.clipsToBounds = true
//        return image
//    }()
//
//    private let rupeeLabel: UILabel = {
//           let label = UILabel()
//           label.text = "₹"
//           label.font = UIFont.systemFont(ofSize: 18)
//        label.textColor = .black
//           return label
//       }()
//
//    private let accountLabel: UILabel = {
//           let label = UILabel()
//           label.text = "Account maintanance charges"
//           label.font = UIFont.systemFont(ofSize: 18)
//
//           return label
//       }()
//
//    private let accountSubLabel: UILabel = {
//            let label = UILabel()
//            label.text = "No account maintanance charges for the first year"
//        label.numberOfLines = 0
//            label.font = UIFont.systemFont(ofSize: 12)
//            label.textColor = .systemGray2
//            return label
//        }()
//
//    private let accountRupeeLabel: UILabel = {
//            let label = UILabel()
//            label.text = "0"
//            label.font = UIFont.systemFont(ofSize: 18)
//            return label
//        }()
//
//    private let equityLabel: UILabel = {
//           let label = UILabel()
//           label.text = "Equity Delivery, Intraday, F&O,Currencies & Commodities"
//        label.numberOfLines = 0
//           label.font = UIFont.systemFont(ofSize: 18)
//
//           return label
//       }()
//
//    private let equitySubLabel: UILabel = {
//            let label = UILabel()
//            label.text = "Flat ₹ 20 or 0.03%(whichever is lower) ₹20 on all option trades."
//            label.font = UIFont.systemFont(ofSize: 12)
//        label.numberOfLines = 0
//            label.textColor = .systemGray2
//            return label
//        }()
//
//    private let equityRupeeLabel: UILabel = {
//            let label = UILabel()
//            label.text = "20"
//            label.font = UIFont.systemFont(ofSize: 18)
//            return label
//        }()
//
//    private let agreeButton: UIButton = {
//              let button = UIButton()
//        button.setTitle("I Agree", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .appPrimary
//        button.layer.cornerRadius = 20
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//              return button
//          }()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupUI()
//        agreeButton.addTarget(self, action: #selector(agreeButtonTapped), for: .touchUpInside)
//    }
//
//    @objc private func agreeButtonTapped() {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    // MARK: - Setup UI
//
//    private func setupUI() {
//
//        view.backgroundColor = .clear
//
//        view.addSubview(dimView)
//        view.addSubview(bottomSheetView)
//
//        dimView.translatesAutoresizingMaskIntoConstraints = false
//        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//
//            dimView.topAnchor.constraint(equalTo: view.topAnchor),
//            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//
//            bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            bottomSheetView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40)
//        ])
//
//        bottomSheetView.addSubview(handleView)
//        bottomSheetView.addSubview(logo)
//        bottomSheetView.addSubview(titleLabel)
//        bottomSheetView.addSubview(rupeeLabel)
//        bottomSheetView.addSubview(accountLabel)
//        bottomSheetView.addSubview(accountSubLabel)
//        bottomSheetView.addSubview(accountRupeeLabel)
//        bottomSheetView.addSubview(equityLabel)
//        bottomSheetView.addSubview(equitySubLabel)
//        bottomSheetView.addSubview(equityRupeeLabel)
//        bottomSheetView.addSubview(agreeButton)
//
//        handleView.translatesAutoresizingMaskIntoConstraints = false
//        logo.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        rupeeLabel.translatesAutoresizingMaskIntoConstraints = false
//        accountLabel.translatesAutoresizingMaskIntoConstraints = false
//        accountSubLabel.translatesAutoresizingMaskIntoConstraints = false
//        equityLabel.translatesAutoresizingMaskIntoConstraints = false
//        equitySubLabel.translatesAutoresizingMaskIntoConstraints = false
//        equityRupeeLabel.translatesAutoresizingMaskIntoConstraints = false
//        agreeButton.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//
//            handleView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 10),
//            handleView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
//            handleView.widthAnchor.constraint(equalToConstant: 60),
//            handleView.heightAnchor.constraint(equalToConstant: 6),
//
//            logo.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 20),
//            logo.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 10),
//            logo.heightAnchor.constraint(equalToConstant: 40),
//            logo.widthAnchor.constraint(equalToConstant: 40),
//
//            titleLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 10),
//            titleLabel.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 10),
//
//            rupeeLabel.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 20),
//            rupeeLabel.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -10),
//
//            accountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
//            accountLabel.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 10),
//            accountLabel.trailingAnchor.constraint(equalTo: rupeeLabel.leadingAnchor, constant: -10),
//
//            accountRupeeLabel.topAnchor.constraint(equalTo: rupeeLabel.bottomAnchor, constant: 30),
//            accountRupeeLabel.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -10),
//
//            accountSubLabel.bottomAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 10),
//            accountSubLabel.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 10),
//
//            equityLabel.topAnchor.constraint(equalTo: accountSubLabel.bottomAnchor, constant: 10),
//            equityLabel.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 10),
//            equityLabel.trailingAnchor.constraint(equalTo: equityRupeeLabel.leadingAnchor, constant: -10),
//
//
//            equityRupeeLabel.topAnchor.constraint(equalTo: accountRupeeLabel.bottomAnchor, constant: 130),
//            equityRupeeLabel.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -10),
//
//            equitySubLabel.topAnchor.constraint(equalTo: equityLabel.bottomAnchor, constant: 10),
//            equitySubLabel.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 10),
//
//            agreeButton.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor, constant: -40),
//            agreeButton.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 10),
//            agreeButton.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -10),
//            agreeButton.heightAnchor.constraint(equalToConstant: 50),
//
//        ])
//    }
//}


import UIKit

class TradingChargesVC: UIViewController {
    
    // MARK: - Background Dim View
    private let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        view.alpha = 0
        return view
    }()
    
    // MARK: - Bottom Sheet
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 28
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Grabber
    private let grabber: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray4
        view.layer.cornerRadius = 3
        return view
    }()
    
    // MARK: - Icon
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "doc.text")
        iv.tintColor = UIColor.systemIndigo
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    // MARK: - Title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Fee and Charges - Hem Nxt Plan"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Divider
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        return view
    }()
    
    // MARK: - Left Section
    private let leftTitle: UILabel = {
        let label = UILabel()
        label.text = "Demat AMC"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        return label
    }()
    
    private let leftPrice: UILabel = {
        let label = UILabel()
        label.text = "₹0"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Right Section
    private let rightTitle: UILabel = {
        let label = UILabel()
        label.text = "Equity, F&O, Currencies &\nCommodities"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        return label
    }()
    
//    private let rightPrice: UILabel = {
//        let label = UILabel()
//        label.text = "₹10Perorder"
//        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
//      label.textColor = .black
//        return label
//    }()
    
    private let rightPrice: UILabel = {
        let label = UILabel()

        let fullText = "₹10 Perorder"
        let attributedText = NSMutableAttributedString(
            string: "₹10",
            attributes: [
                .font: UIFont.systemFont(ofSize: 28, weight: .bold),
                .foregroundColor: UIColor.black
            ]
        )

        attributedText.append(
            NSAttributedString(
                string: " Perorder",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 11, weight: .regular),
                    .foregroundColor: UIColor.black
                ]
            )
        )

        label.attributedText = attributedText
        return label
    }()
    
    // MARK: - Footer
    private let footerLabel: UILabel = {
        let label = UILabel()
        label.text = "No account maintenance charges for the first year"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .lightGray
        return label
    }()
    
//    private let knowMoreButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Know More", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
//        return button
//    }()
    
    // MARK: - Agree Button
    private let agreeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Proceed", for: .normal)
        button.backgroundColor = UIColor.appPrimary
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return button
    }()
    
    // MARK: - Constraints
    private var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        setupViews()
        animateSheet()
        agreeButton.addTarget(self, action: #selector(agreeButtonTapped), for: .touchUpInside)
    }
    
    private func setupViews() {
        
        // Dim View
        view.addSubview(dimView)
        dimView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Bottom Sheet
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 400)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomConstraint,
            containerView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        // Grabber
        containerView.addSubview(grabber)
        grabber.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            grabber.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            grabber.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            grabber.widthAnchor.constraint(equalToConstant: 60),
            grabber.heightAnchor.constraint(equalToConstant: 6)
        ])
        
        // Icon
        containerView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: grabber.bottomAnchor, constant: 22),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 26),
            iconImageView.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        // Title
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 10),
            
        ])
        
        // Divider
        containerView.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            divider.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            divider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        // Left Section
        containerView.addSubview(leftTitle)
        containerView.addSubview(leftPrice)
        
        leftTitle.translatesAutoresizingMaskIntoConstraints = false
        leftPrice.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftTitle.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 24),
            leftTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            
            leftPrice.topAnchor.constraint(equalTo: leftTitle.bottomAnchor, constant: 10),
            leftPrice.centerXAnchor.constraint(equalTo: leftTitle.centerXAnchor)
        ])
        
        // Right Section
        containerView.addSubview(rightTitle)
        containerView.addSubview(rightPrice)
        
        rightTitle.translatesAutoresizingMaskIntoConstraints = false
        rightPrice.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rightTitle.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 24),
            rightTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            
            rightPrice.topAnchor.constraint(equalTo: rightTitle.bottomAnchor, constant: 10),
            rightPrice.centerXAnchor.constraint(equalTo: rightTitle.centerXAnchor)
        ])
        
        // Footer
        containerView.addSubview(footerLabel)
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            footerLabel.topAnchor.constraint(equalTo: leftPrice.bottomAnchor, constant: 30),
            footerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24)
        ])
        
//        containerView.addSubview(knowMoreButton)
//        knowMoreButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            knowMoreButton.topAnchor.constraint(equalTo: footerLabel.bottomAnchor, constant: 4),
//            knowMoreButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20)
       // ])
        
        // Agree Button
        containerView.addSubview(agreeButton)
        agreeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            agreeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            agreeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            agreeButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            agreeButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    @objc private func agreeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func animateSheet() {
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.35) {
            self.dimView.alpha = 1
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
