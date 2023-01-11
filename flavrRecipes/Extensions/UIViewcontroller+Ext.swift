//
//  UIViewcontroller+Ext.swift
//  flavrRecipes
//
//  Created by apple on 22.12.2022.
//

import UIKit

extension UIViewController {
    //alert
    public func getAlert(title: String?, massage: String?){
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        present(alert, animated: true)
    }
    public func getCustomAlert(title: String, massage: String) {
        DispatchQueue.main.async {
            let alert = CustomAlert(title: title, massage: massage)
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: true)
        }
    }
}
