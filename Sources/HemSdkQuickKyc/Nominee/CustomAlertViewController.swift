import UIKit

final class CustomAlertViewController: UIViewController {

    // MARK: - UI

    private let containerView = UIView()

    private let titleLabel = UILabel()

    private let scrollView = UIScrollView()
    private let messageLabel = UILabel()

    private let cancelButton = UIButton(type: .system)
    private let proceedButton = UIButton(type: .system)


    // MARK: - Callbacks

    var onCancel: (() -> Void)?
    var onProceed: (() -> Void)?


    // MARK: - Message

    private let alertMessage = """
    I hereby confirm that I do not wish to appoint any nominee(s) to my demat account/mutual fund folio at this point of time.
    
    I understand that –
    
    (i) the nomination helps to quickly identify the person for transfer of securities and helps in faster and smoother transmission of my securities to my legal heir(s) after my demise.
    
    (ii) in the absence of a nomination, my legal heir(s) may require the submission of certain additional legal or court-issued documents which may delay the process of transmission of securities to my legal heir(s).
    
    (iii) if no claim is made on the account / folio for a prolonged period after my demise, the holdings may be treated as unclaimed assets and they may be transferred to Investor Education and protection Fund Authority (IEPF) in accordance with the applicable regulatory framework.
    
    I confirm that I have understood the above implications and that my decision to opt out of nomination is voluntary.
    """


    // MARK: - View Did Load

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupUI()
        setupConstraints()
    }


    // MARK: - Setup View

    private func setupView() {

        // Black transparent overlay
        view.backgroundColor = UIColor.black.withAlphaComponent(0.55)


        // IMPORTANT
        // This was missing in the previous code.

        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.backgroundColor = .white

        containerView.layer.cornerRadius = 22

        containerView.clipsToBounds = true

        view.addSubview(containerView)
    }


    // MARK: - Setup UI

    private func setupUI() {

        // ==================================================
        // TITLE
        // ==================================================

        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = "Alert!"

        titleLabel.font = UIFont.systemFont(
            ofSize: 22,
            weight: .bold
        )

        titleLabel.textColor = UIColor(
            red: 0.12,
            green: 0.12,
            blue: 0.16,
            alpha: 1
        )

        titleLabel.textAlignment = .left

        containerView.addSubview(titleLabel)


        // ==================================================
        // SCROLL VIEW
        // ==================================================

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.backgroundColor = .clear

        scrollView.showsVerticalScrollIndicator = true

        scrollView.alwaysBounceVertical = false

        scrollView.bounces = true

        containerView.addSubview(scrollView)


        // ==================================================
        // MESSAGE
        // ==================================================

        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        messageLabel.text = alertMessage

        messageLabel.font = UIFont.systemFont(
            ofSize: 15,
            weight: .regular
        )

        messageLabel.textColor = UIColor(
            red: 0.20,
            green: 0.20,
            blue: 0.24,
            alpha: 1
        )

        messageLabel.numberOfLines = 0

        messageLabel.lineBreakMode = .byWordWrapping

        messageLabel.textAlignment = .left

        scrollView.addSubview(messageLabel)


        // ==================================================
        // CANCEL BUTTON
        // ==================================================

        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        configureButton(
            cancelButton,
            title: "Cancel"
        )

        containerView.addSubview(cancelButton)


        // ==================================================
        // PROCEED BUTTON
        // ==================================================

        proceedButton.translatesAutoresizingMaskIntoConstraints = false

        configureButton(
            proceedButton,
            title: "Proceed"
        )

        containerView.addSubview(proceedButton)


        // ==================================================
        // ACTIONS
        // ==================================================

        cancelButton.addTarget(
            self,
            action: #selector(cancelTapped),
            for: .touchUpInside
        )

        proceedButton.addTarget(
            self,
            action: #selector(proceedTapped),
            for: .touchUpInside
        )
    }


    // MARK: - Button Design

    private func configureButton(
        _ button: UIButton,
        title: String
    ) {

        button.setTitle(
            title,
            for: .normal
        )

        button.setTitleColor(
            .white,
            for: .normal
        )

        button.titleLabel?.font = UIFont.systemFont(
            ofSize: 15,
            weight: .semibold
        )

        button.backgroundColor = UIColor(
            red: 0.38,
            green: 0.42,
            blue: 0.86,
            alpha: 1
        )

        button.layer.cornerRadius = 12

        button.clipsToBounds = true
    }


    // MARK: - Constraints

    private func setupConstraints() {

        NSLayoutConstraint.activate([

            // ==================================================
            // ALERT CARD
            // ==================================================

            containerView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            containerView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),

            containerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 28
            ),

            containerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -28
            ),

            // Maximum height of alert
            containerView.heightAnchor.constraint(
                lessThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor,
                multiplier: 0.80
            ),


            // ==================================================
            // TITLE
            // ==================================================

            titleLabel.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 26
            ),

            titleLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 28
            ),

            titleLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -28
            ),

            titleLabel.heightAnchor.constraint(
                equalToConstant: 28
            ),


            // ==================================================
            // SCROLL VIEW
            // ==================================================

            scrollView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 16
            ),

            scrollView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 28
            ),

            scrollView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -28
            ),

            scrollView.heightAnchor.constraint(
                equalToConstant: 250
            ),


            // ==================================================
            // MESSAGE INSIDE SCROLL VIEW
            // ==================================================

            messageLabel.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor
            ),

            messageLabel.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor
            ),

            messageLabel.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor
            ),

            messageLabel.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor
            ),

            // Very important
            // Keeps text width equal to visible scroll area

            messageLabel.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor
            ),


            // ==================================================
            // CANCEL BUTTON
            // ==================================================

            cancelButton.topAnchor.constraint(
                equalTo: scrollView.bottomAnchor,
                constant: 20
            ),

            cancelButton.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 28
            ),

            cancelButton.heightAnchor.constraint(
                equalToConstant: 48
            ),


            // ==================================================
            // PROCEED BUTTON
            // ==================================================

            proceedButton.topAnchor.constraint(
                equalTo: scrollView.bottomAnchor,
                constant: 20
            ),

            proceedButton.leadingAnchor.constraint(
                equalTo: cancelButton.trailingAnchor,
                constant: 16
            ),

            proceedButton.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -28
            ),

            proceedButton.heightAnchor.constraint(
                equalToConstant: 48
            ),

            proceedButton.widthAnchor.constraint(
                equalTo: cancelButton.widthAnchor
            ),


            // ==================================================
            // BOTTOM OF CARD
            // ==================================================

            cancelButton.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: -26
            )
        ])
    }


    // MARK: - Cancel

    @objc private func cancelTapped() {

        dismiss(
            animated: true
        ) { [weak self] in

            self?.onCancel?()
        }
    }


    // MARK: - Proceed

    @objc private func proceedTapped() {

        dismiss(
            animated: true
        ) { [weak self] in

            self?.onProceed?()
        }
    }
}
