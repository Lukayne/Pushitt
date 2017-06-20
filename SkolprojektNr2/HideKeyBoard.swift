//
//  HideKeyBoard.swift
//  SkolprojektNr2
//
//  Created by Richard Smith on 2017-06-20.
//  Copyright © 2017 Richard Smith. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyBoardWhenTappedOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
}