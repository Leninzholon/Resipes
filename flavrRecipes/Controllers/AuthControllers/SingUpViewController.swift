//
//  SingUpViewController.swift
//  flavrRecipes
//
//  Created by apple on 26.08.2022.
//

import UIKit
import Firebase

class SingUpViewController: UIViewController {
    //MARK: - Properties
    let titleMainLabel: UILabel = {
        let label = UILabel()
        label.text = "SING UP"
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica Neue", size: 36)
        return label
    }()
    let titleSupLabel: UILabel = {
        let label = UILabel()
        label.text = "Nice to meet you"
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        return label
    }()
    let youNameTextField: UITextField = {
       let tf = UITextField()
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 30))
        tf.leftView = v
        tf.leftViewMode = .always
        tf.placeholder = "Your Name"
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true

        return tf
    }()
    let emailTextField: UITextField = {
       let tf = UITextField()
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 30))
        tf.leftView = v
        tf.leftViewMode = .always
        tf.placeholder = "Your Email"
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true

        return tf
    }()
    let passwordTextField: UITextField = {
       let tf = UITextField()
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 30))
        tf.leftView = v
        tf.leftViewMode = .always
        tf.placeholder = "Password"
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.isSecureTextEntry = true
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return tf
    }()
    let createAccountButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create account", for: .normal)
        button.backgroundColor = .orange
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.cornerRadius = 20
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addGradient()
        button.addTarget(self, action: #selector(handleCreateUser), for: .touchUpInside)
        return button
    }()
    //MARK: - Livecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let titleStack = UIStackView(arrangedSubviews: [
        titleMainLabel,
        titleSupLabel
        ])
        titleStack.axis = .vertical
        
        view.addSubview(titleStack)
        titleStack.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 144, paddingLeft: 32, paddingRight: 32)
        
        let mainStack = UIStackView(arrangedSubviews: [
        youNameTextField,
        emailTextField,
        passwordTextField,
        createAccountButton
        
        ])
       
        mainStack.axis = .vertical
        mainStack.spacing = 16
        
        view.addSubview(mainStack)
        mainStack.anchor(top: titleStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 56, paddingLeft: 16, paddingRight: 16)
        
    }
    
    
    //MARK: - Selector func
    @objc private func handleCreateUser() {
        FrirebaseService.shared.createUser(emailTextField: emailTextField, passwordTextField: passwordTextField, youNameTextField: youNameTextField) { (result) in
            switch result {
            case .success(_):
                let controller = MainTabBar()
                self.navigationController?.pushViewController(controller, animated: true)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }

    
}


}



//MARK: - Auth user firebase


