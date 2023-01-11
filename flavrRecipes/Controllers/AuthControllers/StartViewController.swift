//
//  ViewController.swift
//  flavrRecipes
//
//  Created by apple on 26.08.2022.
//

import UIKit

class StartViewController: UIViewController {
    //MARK: - Propertis
    let logoView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Flavr_logo")?.withRenderingMode(.alwaysOriginal)
        return iv
    }()
    lazy var loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .orange
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.layer.cornerRadius = 20
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addGradient()
        button.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
        return button
    }()
    let questionLabel: UILabel = {
       let label = UILabel()
        label.text = "Don’t have an account?"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    lazy var SingUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .white
        button.tintColor = .orange
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.orange.cgColor
        button.layer.borderWidth = 1
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: #selector(handleGoToSingup), for: .touchUpInside)
        return button
    }()
    //MARK: - life cycle
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .white
        
        setUI()
    }

    
    //MARK: - SetUI
    fileprivate func setUI() {
        view.addSubview(logoView)
        logoView.anchor(top: view.topAnchor, paddingTop: 166, width: 140, height: 28)
        logoView.centerX(inView: view)
        
        let stackView = UIStackView(arrangedSubviews: [
        loginButton,
        questionLabel,
        SingUpButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 25
        view.addSubview(stackView)
        stackView.anchor(top: logoView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 160, paddingLeft: 15, paddingRight: 15)
    }
    
    //MARK: - selector
    
    @objc private func handleGoToLogin() {
        let controller = LoginViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    @objc private func handleGoToSingup() {
        let controller = SingUpViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

