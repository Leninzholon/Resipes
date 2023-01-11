//
//  AuthButton.swift
//  flavrRecipes
//
//  Created by apple on 12.12.2022.
//

import UIKit

class CustomButton: UIButton {
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(setTitle: String) {
        self.init(type: .system)
        self.setTitle(setTitle, for: .normal)
        configure()
    }
    convenience init(setTitle: String, fontSize: CGFloat, backgroundColor: UIColor, tintColor: UIColor, cornerRadius: CGFloat) {
        self.init(type: .system)
        self.setTitle(setTitle, for: .normal)
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.titleLabel?.font = .systemFont(ofSize: fontSize)
        self.layer.cornerRadius = cornerRadius
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure() {
        backgroundColor = .orange
        tintColor = .white
        titleLabel?.font = .systemFont(ofSize: 16)
        layer.cornerRadius = 20
    }
}
