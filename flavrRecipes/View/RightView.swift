//
//  RightView.swift
//  flavrRecipes
//
//  Created by apple on 11.12.2022.
//

import UIKit

protocol RightViewDelegate: AnyObject{
    func didChangeSecure(isSecure: Bool)
}

class RightView: UIView {
    //MARK: - Properties
    weak var delegate: RightViewDelegate?
    var isSecure = false
    lazy var securityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(handleSecure), for: .touchUpInside)
        return button
    }()
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     func configure() {
        addSubview(securityButton)
         securityButton.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            securityButton.topAnchor.constraint(equalTo: topAnchor),
            securityButton.leftAnchor.constraint(equalTo: leftAnchor),
            securityButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            securityButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
         ])
    }
    @objc func handleSecure() {
        isSecure.toggle()
        isSecure ? securityButton.setBackgroundImage(UIImage(systemName: "eye.slash"), for: .normal) :
        securityButton.setBackgroundImage(UIImage(systemName: "eye"), for: .normal)
        delegate?.didChangeSecure(isSecure: isSecure)
    }
}
