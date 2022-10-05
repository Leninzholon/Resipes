//
//  LoginViewController.swift
//  flavrRecipes
//
//  Created by apple on 26.08.2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    let titleMainLabel: UILabel = {
        let label = UILabel()
        label.text = "LOG IN"
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica Neue", size: 36)
        return label
    }()
    let titleSupLabel: UILabel = {
        let label = UILabel()
        label.text = "Good to see you again"
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        return label
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
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return tf
    }()
    let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("LOG IN", for: .normal)
        button.backgroundColor = .orange
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.cornerRadius = 20
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addGradient()
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    let questionLabel: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don’t have an account?", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleHaveAccount), for: .touchUpInside)
        return button
    }()
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
        let textFieldStack = UIStackView(arrangedSubviews: [
        emailTextField,
        passwordTextField
        ])
        textFieldStack.axis = .vertical
        textFieldStack.spacing = 16
        view.addSubview(textFieldStack)
        textFieldStack.anchor(top: titleStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 120, paddingLeft: 16, paddingRight: 16)
        let buttonQuestinStack = UIStackView(arrangedSubviews: [
        loginButton,
        questionLabel
        ])
        buttonQuestinStack.axis = .vertical
        buttonQuestinStack.spacing = 24
        view.addSubview(buttonQuestinStack)
        buttonQuestinStack.anchor(top: textFieldStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingRight: 16)
    }
    
    //MARK: - selector
    @objc private func handleHaveAccount() {
        let controller = SingUpViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    @objc private func handleLogin() {

        FrirebaseService.shared.login(emailTextField: emailTextField, passwordTextField: passwordTextField) { result in
            switch result {
                
            case .success(let success):
                print(success)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
}
