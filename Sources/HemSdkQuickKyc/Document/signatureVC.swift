////
////  signatureVC.swift
////  t5
////
////  Created by manas dutta on 22/12/25.
////
//
//import UIKit
//import SwiftSignatureView
//
//@MainActor
//class signatureVC: UIViewController {
//    
//    var onSignatureSaved: ((UIImage, [String: Any]?) -> Void)?
//    var PanNo: String?
//    var RegId: String?
//    var ocrCount: Int = 1
//    var fetchedUserId: String?
//    var prefixUrl = "https://signup.hemnxt.com:84/V4.0.0/api/"
//    var mobiledecodeArray: String?
//    var fetchedSessionID: String?
//    let signatureView = SwiftSignatureView()
//    let stackView = UIStackView()
//    let clearButton = UIButton(type: .system)
//    let saveButton = UIButton(type: .system)
//    let navigationView = UIView()
//    let navigationLbl = UILabel()
//    let backButton = UIButton(type: .system)
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupSignatureView()
//        setupButtons()
//    }
//    
//    private func setupSignatureView() {
//        navigationView.translatesAutoresizingMaskIntoConstraints = false
//        navigationView.backgroundColor = UIColor(red: 80/255, green: 99/255, blue: 191/255, alpha: 1)
//        
//        navigationLbl.translatesAutoresizingMaskIntoConstraints = false
//        navigationLbl.text = "DRAW SIGNATURE"
//        navigationLbl.textColor = .white
//        navigationLbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//        
//        backButton.translatesAutoresizingMaskIntoConstraints = false
//        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
//        backButton.tintColor = .white
//        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        
//        signatureView.translatesAutoresizingMaskIntoConstraints = false
//        signatureView.backgroundColor = UIColor(white: 0.95, alpha: 1)
//        signatureView.layer.borderWidth = 1
//        signatureView.layer.borderColor = UIColor.gray.cgColor
//        signatureView.layer.cornerRadius = 8
//        signatureView.delegate = self
//        
//        view.addSubview(navigationView)
//        navigationView.addSubview(backButton)
//        navigationView.addSubview(navigationLbl)
//        view.addSubview(signatureView)
//        
//        NSLayoutConstraint.activate([
//            navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20),
//            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            navigationView.heightAnchor.constraint(equalToConstant: 50),
//            
//            backButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor, constant: 0),
//            backButton.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 20),
//            
//            navigationLbl.centerXAnchor.constraint(equalTo: navigationView.centerXAnchor),
//            navigationLbl.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),
//            
//            signatureView.topAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 50),
//            signatureView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            signatureView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            signatureView.heightAnchor.constraint(equalToConstant: 300)
//        ])
//    }
//    
//    private func setupButtons() {
//        
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.alignment = .center
//        stackView.distribution = .fillEqually
//        stackView.spacing = 10
//        view.addSubview(stackView)
//        // Clear Button
//        clearButton.setTitle("Clear", for: .normal)
//        clearButton.translatesAutoresizingMaskIntoConstraints = false
//        clearButton.addTarget(self, action: #selector(clearSignature), for: .touchUpInside)
//        clearButton.backgroundColor = UIColor(red: 80/255, green: 99/255, blue: 191/255, alpha: 1)
//        clearButton.tintColor = .white
//        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        stackView.addArrangedSubview(clearButton)
//        
//        // Save Button
//        saveButton.setTitle("Upload", for: .normal)
//        saveButton.translatesAutoresizingMaskIntoConstraints = false
//        saveButton.addTarget(self, action: #selector(saveSignature), for: .touchUpInside)
//        saveButton.backgroundColor = UIColor(red: 80/255, green: 99/255, blue: 191/255, alpha: 1)
//        saveButton.tintColor = .white
//        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold) // 👈 font changed
//        stackView.addArrangedSubview(saveButton)
//        
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: signatureView.bottomAnchor, constant: 10),
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            stackView.heightAnchor.constraint(equalToConstant: 150),
//            
//            clearButton.heightAnchor.constraint(equalToConstant: 50),
//            
//            saveButton.heightAnchor.constraint(equalToConstant: 50),
//        ])
//    }
//    
//    @objc private func backButtonTapped() {
//        dismiss(animated: true)
//    }
//    
//    @objc private func clearSignature() {
//        signatureView.clear()
//    }
//    
//    private func showAlert(message: String) {
//        let alert = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
//    
//    @objc private func saveSignature() {
//        if let signatureImage = signatureView.getCroppedSignature(),
//           let imageData = signatureImage.jpegData(compressionQuality: 0.8) {
//            
//            // Call API upload
//            SignatureUpload(imageData: imageData) { [weak self] response in
//                guard let self = self else { return }
//                DispatchQueue.main.async {
//                    if let response = response {
//                        // Pass the API response back instead of only image
//                        self.onSignatureSaved?(signatureImage, response)
//                        self.dismiss(animated: true)
//                    } else {
//                        self.showAlert(message: "Upload failed. Please try again.")
//                    }
//                }
//            }
//        } else {
//            showAlert(message: "Please draw your signature first")
//        }
//    }
//    
//    func SignatureUpload(imageData: Data, completion: @escaping ([String: Any]?) -> Void) {
//        
//        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { tokenId in
//            guard let tokenId = tokenId else {
//                print("No token available, regenerate first")
//                return
//            }
//        }
//        guard ocrCount <= 3 else {
//            print("OCR attempts exceeded. No further attempts allowed.")
//            completion(nil)
//            return
//        }
//        
//        let imageFileName = "image.jpg"
//        let imageMimeType = "image/jpeg"
//        
//        let parameters: [String: Any?] = [
//            "PanNo": PanNo,
//            "RegId": RegId,
//            "UserId": fetchedUserId,
//            "MOBRequestID": "",
//            "Type": "IMAGE",
//            "Password": "",
//            "OCRCount": "\(ocrCount)",
//            "NewValue": "",
//            "BrowserName": "",
//            "BrowserVersion": "",
//            "OS": "",
//            "OSVersion": "",
//            "IPAddress": "",
//            "DeviceType": "",
//        ]
//        
//        let url = "\(self.prefixUrl)MultiPartImageUpload/SignatureUpload"
//        print("signature url:", url)
//        uploadDocument(
//            apiEndpoint: url,
//            parameters: parameters,
//            fileData: imageData,
//            fileName: imageFileName,
//            mimeType: imageMimeType,
//            loaderView: self.view,
//            loaderText: "Kindly wait we are verifying your Signature..."
//        ) { result in
//            switch result {
//            case .success(let jsonResponse):
//                print("SignatureUpload Response: \(jsonResponse)")
//                if let errorCode = jsonResponse["ErrorCode"] as? String, errorCode == "000000" {
//                    DispatchQueue.main.async {
//                        print("Signature upload successful")
//                        self.ocrCount = 1
//                        completion(jsonResponse)   // ✅ success response
//                    }
//                } else {
//                    completion(nil) // API returned error
//                }
//                
//            case .failure(let error):
//                print("Signature upload failed: \(error.localizedDescription)")
//                completion(nil) // network or other failure
//            }
//        }
//    }
//
//    func regenerate(imageData: Data, completion: @escaping ([String: Any]?) -> Void) {
//        CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
//        print("All TokenMobile entries deleted due to error code 999992")
//        
//        CoreDataHelper.generateToken(
//            decodeByteArrayToString: self.mobiledecodeArray ?? "",
//            USERID: self.fetchedUserId ?? "",
//            SessionId: self.fetchedSessionID ?? "",
//            entityName: "TokenMobile",
//            deviceType: "W",
//            in: self.view
//        ) { success in
//            if success {
//                // Retry upload after token regeneration
//                self.SignatureUpload(imageData: imageData, completion: completion)
//            } else {
//                print("Token generation failed.")
//                completion(nil)
//            }
//        }
//    }
//}
//
//extension signatureVC: @MainActor SwiftSignatureViewDelegate {
//    func swiftSignatureViewDidDraw(_ view: ISignatureView) {
//        print("Finished drawing stroke")
//    }
//    
//    func swiftSignatureViewDidDrawGesture(_ view: ISignatureView, _ tap: UIGestureRecognizer) {
//        print("Drawing gesture in progress")
//    }
//    
//    func swiftSignatureViewDidTapInside(_ view: SwiftSignatureView) {
//        print("Tapped inside signature view")
//    }
//}
//
import UIKit
import SwiftSignatureView

@MainActor  // ✅ Entire class isolated to MainActor
class signatureVC: UIViewController {
    
    var onSignatureSaved: ((UIImage, [String: Any]?) -> Void)?
    var PanNo: String?
    var RegId: String?
    var ocrCount: Int = 1
    var fetchedUserId: String?
    var prefixUrl = "https://signup.hemnxt.com:84/V4.0.0/api/"
    var mobiledecodeArray: String?
    var fetchedSessionID: String?
    let signatureView = SwiftSignatureView()
    let stackView = UIStackView()
    let clearButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)
    let navigationView = UIView()
    let navigationLbl = UILabel()
    let backButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSignatureView()
        setupButtons()
    }
    
    // ... setupSignatureView(), setupButtons(), backButtonTapped(),
    // ... clearSignature(), showAlert() — no changes needed
    
    private func setupSignatureView() {
           navigationView.translatesAutoresizingMaskIntoConstraints = false
           navigationView.backgroundColor = UIColor(red: 80/255, green: 99/255, blue: 191/255, alpha: 1)
   
           navigationLbl.translatesAutoresizingMaskIntoConstraints = false
           navigationLbl.text = "DRAW SIGNATURE"
           navigationLbl.textColor = .white
           navigationLbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
   
           backButton.translatesAutoresizingMaskIntoConstraints = false
           backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
           backButton.tintColor = .white
           backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
   
           signatureView.translatesAutoresizingMaskIntoConstraints = false
           signatureView.backgroundColor = UIColor(white: 0.95, alpha: 1)
           signatureView.layer.borderWidth = 1
           signatureView.layer.borderColor = UIColor.gray.cgColor
           signatureView.layer.cornerRadius = 8
           signatureView.delegate = self
   
           view.addSubview(navigationView)
           navigationView.addSubview(backButton)
           navigationView.addSubview(navigationLbl)
           view.addSubview(signatureView)
   
           NSLayoutConstraint.activate([
               navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20),
               navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
               navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
               navigationView.heightAnchor.constraint(equalToConstant: 50),
   
               backButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor, constant: 0),
               backButton.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 20),
   
               navigationLbl.centerXAnchor.constraint(equalTo: navigationView.centerXAnchor),
               navigationLbl.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),
   
               signatureView.topAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 50),
               signatureView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
               signatureView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
               signatureView.heightAnchor.constraint(equalToConstant: 300)
           ])
       }
   
       private func setupButtons() {
   
           stackView.translatesAutoresizingMaskIntoConstraints = false
           stackView.alignment = .center
           stackView.distribution = .fillEqually
           stackView.spacing = 10
           view.addSubview(stackView)
           // Clear Button
           clearButton.setTitle("Clear", for: .normal)
           clearButton.translatesAutoresizingMaskIntoConstraints = false
           clearButton.addTarget(self, action: #selector(clearSignature), for: .touchUpInside)
           clearButton.backgroundColor = UIColor(red: 80/255, green: 99/255, blue: 191/255, alpha: 1)
           clearButton.tintColor = .white
           clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
           stackView.addArrangedSubview(clearButton)
   
           // Save Button
           saveButton.setTitle("Upload", for: .normal)
           saveButton.translatesAutoresizingMaskIntoConstraints = false
           saveButton.addTarget(self, action: #selector(saveSignature), for: .touchUpInside)
           saveButton.backgroundColor = UIColor(red: 80/255, green: 99/255, blue: 191/255, alpha: 1)
           saveButton.tintColor = .white
           saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold) // 👈 font changed
           stackView.addArrangedSubview(saveButton)
   
           NSLayoutConstraint.activate([
               stackView.topAnchor.constraint(equalTo: signatureView.bottomAnchor, constant: 10),
               stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
               stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
               stackView.heightAnchor.constraint(equalToConstant: 150),
   
               clearButton.heightAnchor.constraint(equalToConstant: 50),
   
               saveButton.heightAnchor.constraint(equalToConstant: 50),
           ])
       }
    
        @objc private func backButtonTapped() {
            dismiss(animated: true)
        }
    
        @objc private func clearSignature() {
            signatureView.clear()
        }
    
        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    
    @objc private func saveSignature() {
        guard let signatureImage = signatureView.getCroppedSignature(),
              let imageData = signatureImage.jpegData(compressionQuality: 0.8) else {
            showAlert(message: "Please draw your signature first")
            return
        }

        // ✅ Use Task — we're @MainActor so no isolation crossing
        Task { @MainActor in
            let response = await signatureUploadAsync(imageData: imageData)
            if let response = response {
                self.onSignatureSaved?(signatureImage, response)
                self.dismiss(animated: true)
            } else {
                self.showAlert(message: "Upload failed. Please try again.")
            }
        }
    }

    // ✅ Renamed to async — no completion closure = no Sendable issue
    func signatureUploadAsync(imageData: Data) async -> [String: Any]? {
        guard ocrCount <= 3 else {
            print("OCR attempts exceeded.")
            return nil
        }

        let url = "\(prefixUrl)MultiPartImageUpload/SignatureUpload"
        print("Signature URL:", url)

        let parameters: [String: Any?] = [
            "PanNo": PanNo,
            "RegId": RegId,
            "UserId": fetchedUserId,
            "MOBRequestID": "",
            "Type": "IMAGE",
            "Password": "",
            "OCRCount": "\(ocrCount)",
            "NewValue": "",
            "BrowserName": "",
            "BrowserVersion": "",
            "OS": "",
            "OSVersion": "",
            "IPAddress": "",
            "DeviceType": "",
        ]

        // ✅ Direct await — no continuation, no closure, no race condition possible
        let result = await uploadDocumentAsync(
            apiEndpoint: url,
            parameters: parameters,
            fileData: imageData,
            fileName: "image.jpg",
            mimeType: "image/jpeg",
            loaderView: self.view,
            loaderText: "Kindly wait, verifying your Signature..."
        )

        switch result {
        case .success(let json):
            guard let errorCode = json["ErrorCode"] as? String,
                  errorCode == "000000" else {
                return nil
            }
            print("Signature upload successful")
            self.ocrCount = 1
            return json   // ✅ Returned directly — no boundary crossing at all

        case .failure(let error):
            print("Upload failed: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    @MainActor
    func uploadDocumentAsync(
        apiEndpoint: String,
        parameters: [String: Any?],
        fileData: Data,
        fileName: String,
        mimeType: String,
        loaderView: UIView,
        loaderText: String? = nil
    ) async -> Result<[String: Any], Error> {

        guard let (userId, sessionID, decodeArray) = await withCheckedContinuation(
            { (continuation: CheckedContinuation<(String, String, String)?, Never>) in
                CoreDataHelper.fetchUserId(entityName: "MobileUser") { userId, sessionID, decode in
                    guard let u = userId, let s = sessionID, let d = decode else {
                        continuation.resume(returning: nil); return
                    }
                    continuation.resume(returning: (u, s, d))
                }
            }
        ) else {
            return .failure(NSError(domain: "", code: -1,
                userInfo: [NSLocalizedDescriptionKey: "No UserID or SessionID"]))
        }

        LoaderView.shared.startLoader(in: loaderView, withText: loaderText)
        defer { LoaderView.shared.stopLoader() }

        let tokenId: String? = await withCheckedContinuation(
            { (continuation: CheckedContinuation<String?, Never>) in
                CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { token in
                    continuation.resume(returning: token)
                }
            }
        )

        if tokenId == nil {
            LoaderView.shared.stopLoader()
            let success: Bool = await withCheckedContinuation(
                { (continuation: CheckedContinuation<Bool, Never>) in
                    CoreDataHelper.generateToken(
                        decodeByteArrayToString: decodeArray,
                        USERID: userId, SessionId: sessionID,
                        entityName: "TokenMobile", deviceType: "W",
                        in: loaderView
                    ) { continuation.resume(returning: $0) }
                }
            )
            guard success else {
                return .failure(NSError(domain: "", code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Token generation failed"]))
            }
            return await uploadDocumentAsync(
                apiEndpoint: apiEndpoint, parameters: parameters,
                fileData: fileData, fileName: fileName, mimeType: mimeType,
                loaderView: loaderView, loaderText: loaderText
            )
        }

        var updatedParameters = parameters
        updatedParameters["TokenId"] = tokenId

        guard let url = URL(string: apiEndpoint) else {
            return .failure(NSError(domain: "", code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createMultipartBody(
            parameters: updatedParameters, fileData: fileData,
            boundary: boundary, filename: fileName, mimeType: mimeType
        )

        do {
            // ✅ Pure async — no closure, no Sendable, no race
            let (data, _) = try await URLSession.shared.data(for: request)

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                return .success(json)
            } else {
                return .failure(NSError(domain: "", code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON"]))
            }
        } catch {
            return .failure(error)
        }
    }

    // ✅ Regenerate token as async — no completion closure crossing boundaries
    func regenerateTokenAsync() async -> Bool {
        CoreDataHelper.deleteAllTokens(entityName: "TokenMobile")
        print("All TokenMobile entries deleted")

        return await withCheckedContinuation(
            { (continuation: CheckedContinuation<Bool, Never>) in
                CoreDataHelper.generateToken(
                    decodeByteArrayToString: self.mobiledecodeArray ?? "",
                    USERID: self.fetchedUserId ?? "",
                    SessionId: self.fetchedSessionID ?? "",
                    entityName: "TokenMobile",
                    deviceType: "W",
                    in: self.view
                ) { success in
                    continuation.resume(returning: success)
                }
            }
        )
    }
}

extension signatureVC: @MainActor SwiftSignatureViewDelegate {
    func swiftSignatureViewDidDraw(_ view: ISignatureView) {
        print("Finished drawing stroke")
    }
    func swiftSignatureViewDidDrawGesture(_ view: ISignatureView, _ tap: UIGestureRecognizer) {
        print("Drawing gesture in progress")
    }
    func swiftSignatureViewDidTapInside(_ view: SwiftSignatureView) {
        print("Tapped inside signature view")
    }
}
