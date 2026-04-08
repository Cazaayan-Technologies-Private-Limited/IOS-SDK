//
//  File 2.swift
//  t5
//
//  Created by manas dutta on 12/12/25.
//

//import Foundation
//import CoreData
//import UIKit
//
//public class CoreDataHelper {
//
//    @MainActor static var context: NSManagedObjectContext {
//        return CoreDataManager.shared.managedContext
//    }
//
//    // MARK: Save Token IDs
//    @MainActor public static func saveTokenIds(_ tokenIds: [String], entityName: String) {
//        for id in tokenIds {
//            let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)!
//            let token = NSManagedObject(entity: entity, insertInto: context)
//            token.setValue(id, forKey: "tokenId")
//        }
//
//        CoreDataManager.shared.saveContext()
//        print("Token IDs saved.")
//    }
//
//    // MARK: Fetch & Remove First Token
//    @MainActor public static func fetchAndRemoveFirstToken(entityName: String) -> String? {
//        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
//        request.fetchLimit = 1
//
//        do {
//            let results = try context.fetch(request)
//            if let first = results.first,
//               let id = first.value(forKey: "tokenId") as? String {
//
//                context.delete(first)
//                CoreDataManager.shared.saveContext()
//                return id
//            }
//        } catch {
//            print("Fetch error: \(error)")
//        }
//        return nil
//    }
//
//    // MARK: Are Tokens Available?
//    @MainActor public static func areTokensAvailable(entityName: String) -> Bool {
//        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
//        request.fetchLimit = 1
//
//        do {
//            return try context.count(for: request) > 0
//        } catch {
//            print("Check count error: \(error)")
//            return false
//        }
//    }
//
//    // MARK: Delete All Tokens
//    @MainActor public static func deleteAllTokens(entityName: String) {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
//
//        do {
//            try context.execute(batchDelete)
//            CoreDataManager.shared.saveContext()
//        } catch {
//            print("Delete error: \(error)")
//        }
//    }
//
//    @MainActor static func generateToken(decodeByteArrayToString: String, USERID: String, SessionId: String, entityName: String, deviceType: String, in view: UIView, completion: @escaping (Bool) -> Void) {
//        let tokenParameters: [String: Any] = [
//            "UserId": USERID,
//            "Password": decodeByteArrayToString,
//            "DeviceType": deviceType,
//            "SessionId": SessionId
//        ]
//        print(tokenParameters)
//        let tokenURL = "TokenAuthentication/GenerateToken"
//
//        apiCall(url: tokenURL, method: "POST", parameters: tokenParameters, view: view) { result in
//            switch result {
//            case .success(let jsonResponse):
//                print("TOKEN Response: \(jsonResponse)")
//
//                if let errorCode = jsonResponse["ErrorCode"] as? String {
//                    switch errorCode {
//                    case "000000":
//                        if let tokenList = jsonResponse["TokenList"] as? [[String: Any]] {
//                            var tokenIds: [String] = []
//                            for tokenDict in tokenList {
//                                if let tokenId = tokenDict["TokenId"] as? String {
//                                    tokenIds.append(tokenId)
//                                }
//                            }
//
//                            DispatchQueue.main.async {
//                                saveTokenIds(tokenIds, entityName: entityName)
//                                print("Token IDs saved successfully.")
//                                completion(true)
//                            }
//                        } else {
//                            completion(false)
//                        }
//                    case "999993":
//
//                        print("SessionId Expired. Error Code: \(errorCode)")
//
//                        // Handle session expiration
//                        DispatchQueue.main.async {
//
//                            let alertController = UIAlertController(title: "Session Expired",
//                                                                    message: "Your session has expired. Please log in again.",
//                                                                    preferredStyle: .alert)
//                            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
//                                // Clear stored user data or session tokens
//                                UserDefaults.standard.set(false, forKey: "isLoggedIn")
//                                UserDefaults.standard.removeObject(forKey: "EmailAddress")
//                                UserDefaults.standard.removeObject(forKey: "UserType")
//                                UserDefaults.standard.removeObject(forKey: "userId")
//                                UserDefaults.standard.removeObject(forKey: "loginName")
//                                UserDefaults.standard.removeObject(forKey: "BranchCode")
//                                CoreDataHelper.deleteAllUserIds(entityName: "LoginUser")
//
//                                // Navigate to login screen
//                                let loginStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                                if let loginViewController = loginStoryboard.instantiateViewController(withIdentifier: "NewAccountVC") as? NewAccountVC {
//                                    if let window = UIApplication.shared.windows.first {
//                                        window.rootViewController = loginViewController
//                                        UIView.transition(with: window, duration: 0.5, options: [.transitionFlipFromRight], animations: nil, completion: nil)
//                                        window.makeKeyAndVisible()
//                                    }
//                                } else {
//                                    print("Failed to instantiate view controller with identifier 'ViewController'")
//                                }
//                                // Complete the function
//                                completion(false)
//                            }
//                            alertController.addAction(okAction)
//
//                            // Present the alert
//                            if let window = UIApplication.shared.windows.first?.rootViewController {
//                                window.present(alertController, animated: true, completion: nil)
//                            } else {
//                                print("Failed to present alert")
//                            }
//                        }
//                    default:
//                        print("Unhandled error code: \(errorCode)")
//                        completion(false)
//                    }
//                } else {
//                    completion(false)
//                }
//            case .failure(let error):
//                print("Token generation API call failed: \(error.localizedDescription)")
//                completion(false)
//            }
//        }
//    }
//
//    @MainActor static func deleteAllUserIds(entityName: String) {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
//
//        do {
//            try context.execute(batchDelete)
//            CoreDataManager.shared.saveContext()
//        } catch {
//            print("Delete error: \(error)")
//        }
//    }
//
//    // MARK: Save User
//    @MainActor public static func saveUserId(_ userId: String, sessionID: String, decodeByteArrayString: String, entityName: String) {
//        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)!
//        let user = NSManagedObject(entity: entity, insertInto: context)
//
//        user.setValue(userId, forKey: "userID")
//        user.setValue(sessionID, forKey: "sessionID")
//        user.setValue(decodeByteArrayString, forKey: "decodeByteArrayString")
//
//        CoreDataManager.shared.saveContext()
//    }
//
//    // MARK: Fetch User
//    @MainActor public static func fetchUserId(entityName: String) -> (String?, String?, String?) {
//        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
//        request.fetchLimit = 1
//
//        do {
//            if let user = try context.fetch(request).first {
//                let id = user.value(forKey: "userID") as? String
//                let sid = user.value(forKey: "sessionID") as? String
//                let dec = user.value(forKey: "decodeByteArrayString") as? String
//                return (id, sid, dec)
//            }
//        } catch {
//            print("Fetch user error: \(error)")
//        }
//
//        return (nil, nil, nil)
//    }
//
//    // MARK: Delete All Users
//    @MainActor public static func deleteAllUsers(entityName: String) {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        let batch = NSBatchDeleteRequest(fetchRequest: request)
//
//        do {
//            try context.execute(batch)
//            CoreDataManager.shared.saveContext()
//        } catch {
//            print("Delete user error: \(error)")
//        }
//    }
//}
import UIKit
import CoreData

public class CoreDataHelper {
    
    // MARK: - Shared Managed Context (must be set by the host app)
    @MainActor public static var managedContext: NSManagedObjectContext!
    
    // MARK: - Setup
    /// Call this **once** from the host app (AppDelegate or SceneDelegate)
    @MainActor public static func configure(context: NSManagedObjectContext) {
        self.managedContext = context
    }
    
    // MARK: - Token Management
    
    @MainActor public static func saveTokenIds(_ tokenIds: [String], entityName: String) {
        guard let managedContext = managedContext else {
            print("❌ CoreDataHelper not configured. Call configure(context:) first.")
            return
        }
        
        DispatchQueue.main.async {
            let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
            for tokenId in tokenIds {
                let token = NSManagedObject(entity: entity, insertInto: managedContext)
                token.setValue(tokenId, forKey: "tokenId")
            }
            do {
                try managedContext.save()
                print("✅ Token IDs saved successfully.")
            } catch {
                print("❌ Could not save tokens: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor public static func fetchAndRemoveFirstToken(entityName: String, completion: @escaping (String?) -> Void) {
        guard let managedContext = managedContext else {
            print("❌ CoreDataHelper not configured.")
            completion(nil)
            return
        }
        
        DispatchQueue.main.async {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            fetchRequest.fetchLimit = 1
            
            do {
                let tokens = try managedContext.fetch(fetchRequest)
                if let firstToken = tokens.first,
                   let tokenId = firstToken.value(forKey: "tokenId") as? String {
                    managedContext.delete(firstToken)
                    try managedContext.save()
                    completion(tokenId)
                } else {
                    completion(nil)
                }
            } catch {
                print("❌ Could not fetch or delete token: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    @MainActor public static func areTokensAvailable(entityName: String) -> Bool {
        guard let managedContext = managedContext else {
            print("❌ CoreDataHelper not configured.")
            return false
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try managedContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("❌ Could not fetch token count: \(error.localizedDescription)")
            return false
        }
    }
    
    @MainActor public static func deleteAllTokens(entityName: String) {
        guard let managedContext = managedContext else {
            print("❌ CoreDataHelper not configured.")
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            print("✅ All tokens deleted.")
        } catch {
            print("❌ Could not delete tokens: \(error.localizedDescription)")
        }
    }
    
    // MARK: - UserID Management
    
    @MainActor public static func saveUserId(_ userId: String, sessionID: String, decodeByteArrayString: String, entityName: String) {
        guard let managedContext = managedContext else {
            print("❌ CoreDataHelper not configured.")
            return
        }
        DispatchQueue.main.async {
            let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
            let newUser = NSManagedObject(entity: entity, insertInto: managedContext)
            newUser.setValue(userId, forKey: "userID")
            newUser.setValue(sessionID, forKey: "sessionID")
            newUser.setValue(decodeByteArrayString, forKey: "decodeByteArrayString")
            
            do {
                try managedContext.save()
                print("✅ UserID and SessionID saved successfully.")
            } catch {
                print("❌ Could not save user info: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor public static func areUserIdsAvailable(entityName: String, completion: @escaping (Bool) -> Void) {
        guard let managedContext = managedContext else {
            print("❌ CoreDataHelper not configured.")
            completion(false)
            return
        }
        DispatchQueue.main.async {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            fetchRequest.fetchLimit = 1
            
            do {
                let count = try managedContext.count(for: fetchRequest)
                completion(count > 0)
            } catch {
                print("❌ Could not fetch userID count: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    @MainActor public static func fetchUserId(entityName: String, completion: @escaping (String?, String?, String?) -> Void) {
        guard let managedContext = managedContext else {
            print("❌ CoreDataHelper not configured.")
            completion(nil, nil, nil)
            return
        }
        DispatchQueue.main.async {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            fetchRequest.fetchLimit = 1
            
            do {
                let result = try managedContext.fetch(fetchRequest)
                if let user = result.first,
                   let userId = user.value(forKey: "userID") as? String,
                   let sessionID = user.value(forKey: "sessionID") as? String,
                   let decodeString = user.value(forKey: "decodeByteArrayString") as? String {
                    completion(userId, sessionID, decodeString)
                } else {
                    completion(nil, nil, nil)
                }
            } catch {
                print("❌ Could not fetch user info: \(error.localizedDescription)")
                completion(nil, nil, nil)
            }
        }
    }
    
    @MainActor public static func deleteAllUserIds(entityName: String) {
        guard let managedContext = managedContext else {
            print("❌ CoreDataHelper not configured.")
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            print("✅ All userIDs deleted.")
        } catch {
            print("❌ Could not delete userIDs: \(error.localizedDescription)")
        }
    }
    
    @MainActor static func generateToken(decodeByteArrayToString: String, USERID: String, SessionId: String, entityName: String, deviceType: String, in view: UIView, completion: @escaping (Bool) -> Void) {
        let tokenParameters: [String: Any] = [
            "UserId": USERID,
            "Password": decodeByteArrayToString,
            "DeviceType": deviceType,
            "SessionId": SessionId
        ]
        print(tokenParameters)
        let tokenURL = "TokenAuthentication/GenerateToken"
        
        apiCall(url: tokenURL, method: "POST", parameters: tokenParameters, view: view) { result in
            switch result {
            case .success(let jsonResponse):
                print("TOKEN Response: \(jsonResponse)")
                
                if let errorCode = jsonResponse["ErrorCode"] as? String {
                    switch errorCode {
                    case "000000":
                        if let tokenList = jsonResponse["TokenList"] as? [[String: Any]] {
                            var tokenIds: [String] = []
                            for tokenDict in tokenList {
                                if let tokenId = tokenDict["TokenId"] as? String {
                                    tokenIds.append(tokenId)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                saveTokenIds(tokenIds, entityName: entityName)
                                print("Token IDs saved successfully.")
                                completion(true)
                            }
                        } else {
                            completion(false)
                        }
                    case "999993":
                        
                        print("SessionId Expired. Error Code: \(errorCode)")
                        
                        // Handle session expiration
                        DispatchQueue.main.async {
                            
                            let alertController = UIAlertController(title: "Session Expired",
                                                                    message: "Your session has expired. Please log in again.",
                                                                    preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                                // Clear stored user data or session tokens
                                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                                UserDefaults.standard.removeObject(forKey: "EmailAddress")
                                UserDefaults.standard.removeObject(forKey: "UserType")
                                UserDefaults.standard.removeObject(forKey: "userId")
                                UserDefaults.standard.removeObject(forKey: "loginName")
                                UserDefaults.standard.removeObject(forKey: "BranchCode")
                                CoreDataHelper.deleteAllUserIds(entityName: "MobileUser")
                                
                                // Navigate to login screen
                                let storyboard = UIStoryboard(name: "DashboardVC", bundle: Bundle.module)
                                if let loginVC = storyboard.instantiateViewController(withIdentifier: "NewAccountVC") as? NewAccountVC {
                                    
                                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                       let window = windowScene.windows.first {
                                        
                                        window.rootViewController = loginVC
                                        UIView.transition(
                                            with: window,
                                            duration: 0.5,
                                            options: .transitionFlipFromRight,
                                            animations: nil
                                        )
                                        window.makeKeyAndVisible()
                                    }
                                }
                                
                                completion(false)
                            }
                            
                            alertController.addAction(okAction)
                            
                            // ✅ INLINE top-most VC detection
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = windowScene.windows.first {

                                let storyboard = UIStoryboard(name: "DashboardVC", bundle: Bundle.module)
                                if let loginVC = storyboard.instantiateViewController(withIdentifier: "NewAccountVC") as? NewAccountVC {

                                    let navController = UINavigationController(rootViewController: loginVC)
                                    navController.navigationBar.isHidden = true

                                    window.rootViewController = navController
                                    window.makeKeyAndVisible()
                                }
                            } else {
                                print("❌ Unable to find window to present alert")
                            }
                        }
                    default:
                        print("Unhandled error code: \(errorCode)")
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            case .failure(let error):
                print("Token generation API call failed: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
}
