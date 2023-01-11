//
//  searchView.swift
//  flavrRecipes
//
//  Created by apple on 01.09.2022.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func searchText(searchText: String)
    func dismissSearchView()
}

class SearchView: UIView {
    //MARK: - Properties
    weak var delegate: SearchViewDelegate?
    var isShow = false
    private lazy var backButton : UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "baseline_arrow_back_black_36dp-1"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    private lazy var searchTextField : UITextField = {
       let tf = UITextField()
        let view = UIView()
        view.setDimentions(height: 50, width: 12)
        tf.leftViewMode = .always
        tf.leftView = view
        tf.placeholder = "Search.."
        tf.delegate = self
        return tf
    }()
    
    //MARK: livecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(searchTextField)
      
        addSubview(backButton)
        backButton.anchor(top: self.safeAreaLayoutGuide.topAnchor, left: leftAnchor,  paddingTop: 20, paddingLeft: 16, width: 24, height: 24)
        searchTextField.anchor(top: backButton.bottomAnchor, left: leftAnchor, botton: bottomAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 16, paddingBotton: 5, paddingRight: 16)
    }
    //MARK: - selector
    @objc private func handleDismiss() {
        delegate?.dismissSearchView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SearchView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        delegate?.searchText(searchText: newString)
        return true
    }
}


