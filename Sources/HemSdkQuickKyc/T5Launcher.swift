//
//  File.swift
//  t5
//
//  Created by manas dutta on 11/12/25.
//

//import UIKit
//
//public class T5Launcher {
//    @MainActor public static func show(from presenter: UIViewController) {
//        let bundle = Bundle.module
//        
//        // Debug: print what bundles Xcode sees
//        print("Bundle.module path:", bundle.bundlePath)
//        
//        guard bundle.path(forResource: "Main", ofType: "storyboardc") != nil ||
//              bundle.path(forResource: "Main", ofType: "storyboard") != nil else {
//            print("Main.storyboard not found in bundle!")
//            return
//        }
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
//        
//        guard let rootVC = storyboard.instantiateInitialViewController() else {
//            print("No initial view controller set in Main.storyboard!")
//            return
//        }
//        
//        rootVC.modalPresentationStyle = .fullScreen
//        presenter.present(rootVC, animated: true)
//    }
//}

//import UIKit
//
//public class T5Launcher {
//    
//    private init() { } // optional – prevent direct init
//    
//    @MainActor public static func show(from presenter: UIViewController) {  // Renamed param for clarity
//        let storyboard = UIStoryboard(name: "DashboardVC", bundle: Bundle.module)  // or Bundle.main
//        let vc = storyboard.instantiateViewController(withIdentifier: "NewAccountVC")
//        vc.modalPresentationStyle = .fullScreen
//        presenter.present(vc, animated: true)
//    }
//}

import UIKit

public class T5Launcher {

    private init() { }

    
    @MainActor public static func show(from presenter: UIViewController, transactionId: String? = nil) {
        let storyboard = UIStoryboard(name: "DashboardVC", bundle: Bundle.module)
        
        // Instantiate the NAVIGATION CONTROLLER (not NewAccountVC)
        guard let navController = storyboard.instantiateViewController(withIdentifier: "NewAccountNavigationController") as? UINavigationController else {
            fatalError("Failed to instantiate Navigation Controller with ID 'NewAccountNavigationController'")
        }
        
        if let newAccountVC = navController.viewControllers.first(where: { $0 is NewAccountVC }) as? NewAccountVC {
            newAccountVC.txnId = transactionId
        }
        
        navController.modalPresentationStyle = .fullScreen
        presenter.present(navController, animated: true)
    }
}
