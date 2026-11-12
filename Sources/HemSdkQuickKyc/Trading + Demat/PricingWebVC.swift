import UIKit
import WebKit

class PricingWebVC: UIViewController, WKNavigationDelegate {

    var urlString = "https://uatkyc.hemsecurities.com:96/Content/hem-nxt-pricing/pricing.html"
    var onProceed: (() -> Void)?

    private let cardView = UIView()
    private let handleView = UIView()
    private let webView = WKWebView()
    private let loader = UIActivityIndicatorView(style: .medium)
    private let proceedBtn = UIButton(type: .system)
    private let closeBtn = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupUI()
        loadPage()

        // Tap outside the card to close
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func setupUI() {
        // Card
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 24
        cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cardView.clipsToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)

        // Handle
        handleView.backgroundColor = .darkGray
        handleView.layer.cornerRadius = 2.5
        handleView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(handleView)

        // Web view
        webView.navigationDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(webView)

        // Loader
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(loader)

        // Proceed button
        proceedBtn.setTitle("Proceed", for: .normal)
        proceedBtn.setTitleColor(.white, for: .normal)
        proceedBtn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        proceedBtn.backgroundColor = UIColor(red: 0.27, green: 0.35, blue: 0.93, alpha: 1)
        proceedBtn.layer.cornerRadius = 12
        proceedBtn.translatesAutoresizingMaskIntoConstraints = false
        proceedBtn.addTarget(self, action: #selector(proceedTapped), for: .touchUpInside)
        proceedBtn.isHidden = true      // shown only after the page has loaded
        proceedBtn.alpha = 0
        cardView.addSubview(proceedBtn)
        
        // Close button
        closeBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeBtn.tintColor = .darkGray
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        cardView.addSubview(closeBtn)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            cardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            handleView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            handleView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: 60),
            handleView.heightAnchor.constraint(equalToConstant: 5),

            webView.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 10),
            webView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: proceedBtn.topAnchor, constant: -12),

            loader.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: webView.centerYAnchor),

            proceedBtn.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            proceedBtn.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            proceedBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            proceedBtn.heightAnchor.constraint(equalToConstant: 50),
            
            closeBtn.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            closeBtn.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            closeBtn.widthAnchor.constraint(equalToConstant: 32),
            closeBtn.heightAnchor.constraint(equalToConstant: 32),
        ])
    }

    private func loadPage() {
        guard let url = URL(string: urlString) else { return }
        loader.startAnimating()
        webView.load(URLRequest(url: url))
    }

    // MARK: - Actions
    @objc private func proceedTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onProceed?()
        }
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func backgroundTapped(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: view)
        if !cardView.frame.contains(point) {
            dismiss(animated: true)
        }
    }

    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loader.stopAnimating()
        showProceedButton()
    }

    private func showProceedButton() {
        guard proceedBtn.isHidden else { return }
        proceedBtn.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.proceedBtn.alpha = 1
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loader.stopAnimating()
        print("Web load failed:", error.localizedDescription)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        loader.stopAnimating()
        print("Web load failed:", error.localizedDescription)
    }
}
