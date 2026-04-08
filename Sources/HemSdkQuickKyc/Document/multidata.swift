//
//  File.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import Foundation
import UIKit

@MainActor func uploadDocument(apiEndpoint: String, parameters: [String: Any?], fileData: Data, fileName: String, mimeType: String, loaderView: UIView, loaderText: String? = nil, completion: @escaping (Result<[String: Any], Error>) -> Void) {
    // Show the loader with optional text
    CoreDataHelper.fetchUserId(entityName: "MobileUser") {
        userId, sessionID, decodeByteArrayString in
        if let userId = userId, let sessionID = sessionID , let decodearray = decodeByteArrayString {
            print("UserID: \(userId), SessionID: \(sessionID)")
            
            DispatchQueue.main.async {
                LoaderView.shared.startLoader(in: loaderView, withText: loaderText)
            }
            
            CoreDataHelper.fetchAndRemoveFirstToken(entityName: "TokenMobile") { tokenId in
                guard let tokenId = tokenId else {
                    DispatchQueue.main.async {
                        LoaderView.shared.stopLoader()
                    }
                    CoreDataHelper.generateToken(
                        decodeByteArrayToString: decodeByteArrayString ?? "",
                        USERID: userId,
                        SessionId: sessionID,
                        entityName: "TokenMobile", deviceType: "W", in: loaderView
                    ) { success in
                        if success {
                            // Retry SIXTHAPI after token regeneration
                            uploadDocument(apiEndpoint: apiEndpoint, parameters: parameters, fileData: fileData, fileName: fileName, mimeType: mimeType, loaderView: loaderView, loaderText: loaderText) { success in
                                if let jsonResponse = try? JSONSerialization.jsonObject(with: fileData, options: []) as? [String: Any] {
                                    completion(.success(jsonResponse))
                                } else {
                                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON"])))
                                }
                            }
                        } else {
                            print("Token generation failed.")
                        }
                    }
                    print("No tokens available. Please reload the tokens.")
                    return
                }
                
                var updatedParameters = parameters
                updatedParameters["TokenId"] = tokenId
                
                guard let url = URL(string: apiEndpoint) else {
                    DispatchQueue.main.async {
                        LoaderView.shared.stopLoader()
                    }
                    print("Invalid URL")
                    return
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                let boundary = UUID().uuidString
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                
                let body = createMultipartBody(parameters: updatedParameters, fileData: fileData, boundary: boundary, filename: fileName, mimeType: mimeType)
                request.httpBody = body
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    DispatchQueue.main.async {
                        LoaderView.shared.stopLoader()
                    }
                    
                    guard let data = data, error == nil else {
                        completion(.failure(error ?? NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                        return
                    }
                    
                    if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        completion(.success(jsonResponse))
                    } else {
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON"])))
                    }
                }.resume()
            }
        } else {
            print("No UserID or SessionID found.")
        }
    }
}

func createMultipartBody(parameters: [String: Any?], fileData: Data, boundary: String, filename: String, mimeType: String) -> Data {
    var body = Data()
    
    for (key, value) in parameters {
        if let value = value {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
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
