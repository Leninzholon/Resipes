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
    let youNameTextField: AuthField = {
        let tf = AuthField(type: .username)
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true

        return tf
    }()
    let emailTextField: AuthField = {
        let tf = AuthField(type: .email)
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return tf
    }()
    let passwordTextField: AuthField = {
        let tf = AuthField(type: .password)
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return tf
    }()
    lazy var createAccountButton : CustomButton = {
        let button = CustomButton(setTitle: "Create account")
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: #selector(handleCreateUser), for: .touchUpInside)
        return button
    }()
    //MARK: - Livecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "baseline_arrow_back_black_36dp-1"), style: .plain, target: self, action: #selector(handleBackWard))
        navigationController?.navigationBar.tintColor = .black
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
    @objc private func handleBackWard() {
        navigationController?.popToRootViewController(animated: true)
    }
    @objc private func handleCreateUser() {
        FirebaseService.shared.createUser(emailTextField: emailTextField, passwordTextField: passwordTextField, youNameTextField: youNameTextField) { (result) in
            switch result {
            case .success(_):
                let controller = MainTabBar()
                self.navigationController?.pushViewController(controller, animated: true)
            case .failure(let err):
                let ac = UIAlertController(title: "Alert", message: "Failerd, user doesn't create, try ", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ok", style: .default))
                self.present(ac, animated: true)
                print("err.localizedDescription", err)
            }
        }

    
}


}



//MARK: - Auth user firebase


