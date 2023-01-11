//
//  AuthField.swift
//  flavrRecipes
//
//  Created by apple on 11.12.2022.
//

import UIKit

class AuthField: UITextField {
    enum TypeField {
        case username
        case email
        case password
        var title: String {
            switch self {
            case .email:
                return "Enter email"
            case .password:
                return "Enter password"
            case .username:
                return "Enter username"
            }
        }
    }
    let type: TypeField
    //MARK: - init
    init(type: TypeField) {
        self.type = type
        super.init(frame: .zero)
        self.configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure() {
        placeholder = type.title
        autocorrectionType = .no
        autocapitalizationType = .none
        leftView = UIView(frame: .init(x: 0, y: 0, width: 16, height: height))
        leftViewMode = .always
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.gray.cgColor
        if type == .password {
            let widthSize: CGFloat = 30
            let rV = RightView(frame: .init(x: width - widthSize, y: 0, width: widthSize + 16, height: height))
            rV.delegate = self
            rightView = rV
            rightViewMode = .always
            isSecureTextEntry = true
        }
        if type == .email {
            keyboardType = .emailAddress
        }
        
    }
}

//MARK: - extension delegate

extension AuthField: RightViewDelegate {
    func didChangeSecure(isSecure: Bool) {
        isSecureTextEntry = !isSecure
    }
    
    
}
