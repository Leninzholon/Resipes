//
//  CustomAlert.swift
//  flavrRecipes
//
//  Created by apple on 08.01.2023.
//

import UIKit

class CustomAlert: UIViewController {
    let containerView: UIView = {
       let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 16
        view.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1).cgColor
        view.layer.borderWidth = 2
        return view
    }()
    let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    let massageLabel: UILabel = {
       let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 4
        return label
    }()
    lazy var aletButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 16
        button.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.tintColor = .black
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return button
    }()
    
    var alertTitle: String?
    var alertMassage: String?
    
    init(title: String, massage: String){
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.alertMassage = massage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        titleLabel.text = alertTitle
        massageLabel.text = alertMassage
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        view.addSubview(containerView)
        containerView.centerX(inView: view)
        containerView.centerY(inView: view)
        containerView.anchor(width: 280, height: 220)
        containerView.addSubview(titleLabel)
        titleLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16, height: 25)
        containerView.addSubview(aletButton)
        aletButton.centerX(inView: containerView)
        aletButton.anchor(botton: containerView.bottomAnchor,paddingBotton: 16, width: 150, height: 44)
        containerView.addSubview(massageLabel)
        massageLabel.anchor(top: titleLabel.bottomAnchor, left: containerView.leftAnchor, botton: aletButton.topAnchor, right: containerView.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBotton: 20, paddingRight: 20)
        
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
   

}

