//
//  TermsConditionVC.swift
//  HemSdkQuickKyc
//
//  Created by Manas Datta on 14/05/26.
//

import UIKit
import WebKit

class TermsConditionsVC: UIViewController {
    
    // MARK: - Properties
    
    private let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private let handleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray4
        view.layer.cornerRadius = 3
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "doc.text")
        imageView.tintColor = UIColor.appPrimary
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Terms & Conditions"
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .black
        return label
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.layer.cornerRadius = 12
        webView.clipsToBounds = true
        return webView
    }()
    
    private let understandButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("I Understand", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.appPrimary
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 14
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadHTMLFile()
        understandButton.addTarget(self, action: #selector(dismissView),for: .touchUpInside)
    }
    
    @objc private func dismissView() {
        dismiss(animated: true)
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        
        view.backgroundColor = .clear
        
        view.addSubview(dimView)
        view.addSubview(bottomSheetView)
        
        dimView.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.72)
        ])
        
        // Add subviews
        
        bottomSheetView.addSubview(handleView)
        bottomSheetView.addSubview(iconImageView)
        bottomSheetView.addSubview(titleLabel)
        bottomSheetView.addSubview(webView)
        bottomSheetView.addSubview(understandButton)
        
        handleView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        understandButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            // Handle
            
            handleView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 10),
            handleView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: 60),
            handleView.heightAnchor.constraint(equalToConstant: 6),
            
            // Icon
            
            iconImageView.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 24),
            iconImageView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            // Title
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -24),
            
            // WebView
            
            webView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            webView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 5),
            webView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -5),
            
            // Button
            
            understandButton.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            understandButton.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 20),
            understandButton.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -20),
            understandButton.heightAnchor.constraint(equalToConstant: 56),
            understandButton.bottomAnchor.constraint(equalTo: bottomSheetView.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Load HTML
    
    private func loadHTMLFile() {
        
        let fileURL = URL(fileURLWithPath: "/Users/manasdatta/Downloads/tc.html")
        
        webView.loadFileURL(
            fileURL,
            allowingReadAccessTo: fileURL.deletingLastPathComponent()
        )
    }
}
