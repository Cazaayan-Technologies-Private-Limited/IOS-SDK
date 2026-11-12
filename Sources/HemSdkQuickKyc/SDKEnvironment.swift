//
//  SDKEnvironment.swift
//  HemSdkQuickKyc
//
//  Created by Manas Datta on 23/09/26.
//

import Foundation

enum SDKEnvironment: Sendable {
    case uat
    case live

    var baseURL: String {
        switch self {
        case .uat:
            return "http://uatkyc.hemsecurities.com:98/V4.0.0/api/"

        case .live:
            return "https://signup.hemnxt.com:84/V4.0.0/api/"
        }
    }
}
