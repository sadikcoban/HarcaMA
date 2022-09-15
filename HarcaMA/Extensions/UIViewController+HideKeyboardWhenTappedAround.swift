//
//  UIViewController+HideKeyboardWhenTappedAround.swift
//  HarcaMA
//
//  Created by Sadık Çoban on 15.09.2022.
//

import UIKit
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
