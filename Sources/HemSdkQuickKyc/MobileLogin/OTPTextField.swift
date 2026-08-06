//
//  OTPTextField.swift
//  HemSdkQuickKyc
//
//  Created by Manas Datta on 05/08/26.
//

import UIKit

class OTPTextField: UITextField {

    var onDeleteBackward: (() -> Void)?

    override func deleteBackward() {
        if text?.isEmpty == true {
            onDeleteBackward?()
        }
        super.deleteBackward()
    }
}
