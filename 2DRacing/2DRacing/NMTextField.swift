//
//  NMTextField.swift
//  2DRacing
//
//  Created by Damir Nuriev on 18.12.2023.
//

import UIKit

class NMTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }
}
