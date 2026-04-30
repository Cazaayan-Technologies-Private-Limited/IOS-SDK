//
//  File.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import Foundation
import UIKit

@MainActor
func uploadDocument(
    apiEndpoint: String,
    parameters: [String: Any?],
    fileData: Data,
    fileName: String,
    mimeType: String,
    loaderView: UIView,
    loaderText: String? = nil,
    completion: @escaping (Result<[String: Any], Error>) -> Void
) {
    Task { @MainActor in
        await uploadDocumentAsync(
            apiEndpoint: apiEndpoint,
            parameters: parameters,
            fileData: fileData,
            fileName: fileName,
            mimeType: mimeType,
            loaderView: loaderView,
            loaderText: loaderText,
            completion: completion
        )
    }
}

// ✅ Core logic extracted into async function — no closure boundary crossings
@MainActor
private func uploadDocumentAsync(
    apiEndpoint: String,
    parameters: [String: Any?],
    fileData: Data,
    fileName: String,
    mimeType: String,
    loaderView: UIView,
    loaderText: String? = nil,
    completion: @escaping (Result<[String: Any], Error>) -> Void
) async {

    // ✅ Step 1: Fetch user credentials using async wrapper
    guard let (userId, sessionID, decodeArray) = await withCheckedContinuation(
        { (continuation: CheckedContinuation<(String, String, String)?, Never>) in
            CoreDataHelper.fetchUserId(entityName: "MobileUser") { userId, sessionID, decodeByteArrayString in
                guard let userId = userId,
                      let sessionID = sessionID,
                      let decodeArray = decodeByteArrayString else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: (userId, sessionID, decodeArray))
            }
        }
    ) else {
        print("No UserID or SessionID found.")
        return
    }

    print("UserID: \(userId), SessionID: \(sessionID)")
    LoaderView.shared.startLoader(in: loaderView, withText: loaderText)
    defer { LoaderView.shared.stopLoader() }  // ✅ Always stops loader on exit

    // ✅ Step 2: Fetch token using async wrapper
    let tokenId: String? = await withCheckedContinuation { continuation in
        CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { token in
            continuation.resume(returning: token)
        }
    }

    // ✅ Step 3: Handle missing token — regenerate and retry
    guard let tokenId = tokenId else {
        print("No tokens available. Regenerating...")
        LoaderView.shared.stopLoader()

        let tokenSuccess: Bool = await withCheckedContinuation { continuation in
            CoreDataHelper.generateToken(
                decodeByteArrayToString: decodeArray,
                USERID: userId,
                SessionId: sessionID,
                entityName: "TokenMobile",
                deviceType: "W",
                in: loaderView
            ) { success in
                continuation.resume(returning: success)
            }
        }

        guard tokenSuccess else {
            print("Token generation failed.")
            completion(.failure(NSError(
                domain: "", code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Token generation failed"]
            )))
            return
        }

        // ✅ Recursive retry — safe because we're already @MainActor async
        await uploadDocumentAsync(
            apiEndpoint: apiEndpoint,
            parameters: parameters,
            fileData: fileData,
            fileName: fileName,
            mimeType: mimeType,
            loaderView: loaderView,
            loaderText: loaderText,
            completion: completion
        )
        return
    }

    // ✅ Step 4: Build request
    var updatedParameters = parameters
    updatedParameters["TokenId"] = tokenId

    guard let url = URL(string: apiEndpoint) else {
        completion(.failure(NSError(
            domain: "", code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]
        )))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let boundary = UUID().uuidString
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpBody = createMultipartBody(
        parameters: updatedParameters,
        fileData: fileData,
        boundary: boundary,
        filename: fileName,
        mimeType: mimeType
    )

    // ✅ Step 5: Network call using async/await — no Sendable closure issues
    do {
        let (data, _) = try await URLSession.shared.data(for: request)

        if let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            completion(.success(jsonResponse))
        } else {
            completion(.failure(NSError(
                domain: "", code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON"]
            )))
        }
    } catch {
        completion(.failure(error))
    }
}

// ✅ Nonisolated — pure data transformation, no actor needed
func createMultipartBody(
    parameters: [String: Any?],
    fileData: Data,
    boundary: String,
    filename: String,
    mimeType: String
) -> Data {
    var body = Data()

    for (key, value) in parameters {
        guard let value = value else { continue }
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(value)\r\n".data(using: .utf8)!)
    }

    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
    body.append(fileData)
    body.append("\r\n".data(using: .utf8)!)
    body.append("--\(boundary)--\r\n".data(using: .utf8)!)

    return body
}

// Helper functions for loader
func showLoader(on view: UIView) {
    let loader = UIActivityIndicatorView(style: .large)
    loader.center = view.center
    loader.tag = 999 // Unique tag to identify the loader
    loader.startAnimating()
    view.addSubview(loader)
}

func hideLoader(from view: UIView) {
    if let loader = view.viewWithTag(999) as? UIActivityIndicatorView {
        loader.stopAnimating()
        loader.removeFromSuperview()
    }
}
