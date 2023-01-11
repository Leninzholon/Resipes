//
//  ProfileField.swift
//  flavrRecipes
//
//  Created by apple on 18.12.2022.
//

import UIKit

class ProfileField: UITextField {
    enum TypeField {
        case username
        case email
        var title: String {
            switch self {
            case .email:
                return "Your Email"
            case .username:
                return "Your Name"
            }
        }
    }
    let type: TypeField
    init(type: TypeField) {
        self.type = type
         super.init(frame: .zero)
         let v = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 30))
         leftView = v
         leftViewMode = .always
        placeholder = type.title
         layer.borderWidth = 0.5
         layer.borderColor = UIColor.gray.cgColor
         heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
