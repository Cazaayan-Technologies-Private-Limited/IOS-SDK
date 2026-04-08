//
//  File.swift
//  t5
//
//  Created by manas dutta on 12/12/25.
//

import Foundation
import UIKit

class LoaderView {
    @MainActor static let shared = LoaderView()
    public var blurView: UIVisualEffectView?
    
    public init() {}
    
   @MainActor func startLoader(in view: UIView, withText text: String? = nil) {
        guard blurView == nil else {
            print("Loader already running")
            return
        }
        
        print("Starting loader...")
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .purple
        activityIndicator.startAnimating()
        activityIndicator.center = CGPoint(x: blurView.contentView.center.x, y: blurView.contentView.center.y - 20) // Adjusted vertically
        blurView.contentView.addSubview(activityIndicator)
        
        if let text = text {
            let label = UILabel()
            label.text = text
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            
            blurView.contentView.addSubview(label)
            // Constraints for the label
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor),
                label.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 10),
                label.leadingAnchor.constraint(greaterThanOrEqualTo: blurView.contentView.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(lessThanOrEqualTo: blurView.contentView.trailingAnchor, constant: -16)
            ])
        }
        
        view.addSubview(blurView)
        
        self.blurView = blurView
        print("Loader started")
    }
    
    @MainActor func stopLoader() {
        DispatchQueue.main.async {
            print("Stopping loader...")
            self.blurView?.removeFromSuperview()
            self.blurView = nil
            print("Loader stopped")
        }
    }
}

@MainActor func apiCall(
    url: String,
    method: String,
    parameters: [String: Any],
    view: UIView,
    loaderText: String? = nil,
    completion: @escaping (Result<[String: Any], Error>) -> Void
) {//https://uatinsta.plindia.com:85/V4.0.0/api/  http://ekyc.sgssl.co.in:85/V4.0.0/api/  http://ekyc.sgssl.co.in:85/V4.0.0/api/
    let prefixURL = "https://signup.hemnxt.com:84/V4.0.0/api/" //"http://uatinsta.plindia.com:85/V4.0.0/api/" //"http://instakyc.plindia.com:85/V4.0.0/api/" //https://ekyc.cazaayan.com:8024/V4.0.0/api/
    //SDK:- https://signup.hemnxt.com:84/V4.0.0/api/
    let completeURLString = prefixURL + url
    
    guard let url = URL(string: completeURLString) else {
        print("Invalid URL")
        return
    }
      
    var request = URLRequest(url: url, timeoutInterval: 60)
    request.httpMethod = method
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        print("Request Body: \(String(data: request.httpBody!, encoding: .utf8) ?? "")")
    } catch {
        print("Error serializing JSON: \(error.localizedDescription)")
        completion(.failure(error))
        return
    }
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Start loader on the main thread
    DispatchQueue.main.async {
        LoaderView.shared.startLoader(in: view, withText: loaderText)
    }
    URLSession.shared.dataTask(with: request) { data, response, error in
        // Ensure we stop the loader and handle the response on the main thread
        DispatchQueue.main.async {
            LoaderView.shared.stopLoader()
        }
        
        if let error = error {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            return
        }
        guard let data = data else {
            let error = NSError(
                domain: "",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Empty response data"]
            )
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            return
        }
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                DispatchQueue.main.async {
                    completion(.success(jsonResponse))
                }
            } else {
                let error = NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"]
                )
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }.resume()
}
