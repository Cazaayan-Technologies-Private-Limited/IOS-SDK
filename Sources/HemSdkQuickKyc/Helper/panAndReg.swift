//
//  File.swift
//  HemSdkQuickKyc
//
//  Created by Manas Datta on 18/04/26.
//

import Foundation


struct UserSession {
    static var panNo: String? {
        return UserDefaults.standard.string(forKey: "PanNo")
    }
    
    static var regId: String? {
         return UserDefaults.standard.string(forKey: "RegId")
     }
}
