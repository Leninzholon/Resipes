//
//  AddIngredientsController.swift
//  flavrRecipes
//
//  Created by apple on 08.09.2022.
//

import UIKit

protocol AddIngredientsControllerDelegate: AnyObject {
    func addIngredient(ingredients: [String])
}

class AddIngredientsController: UIViewController {
    //MARK: - Properties
    var ingredients = [String]()
    weak var delegate: AddIngredientsControllerDelegate?
    let bottonView: UIView = {
       let view = UIView()
        return view
    }()
    let addButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .orange
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
        button.layer.cornerRadius = 50
        button.clipsToBounds = true
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddIngredient), for: .touchUpInside)
        return button
    }()
    let topBar : UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let saveButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    let canselButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cansel", for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handledismiss), for: .touchUpInside)
        return button
    }()
    let addEmptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Add yor ingredient"
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        return label
    }()
    let tableView = UITableView()
    //MARK: - Livecycle
 
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTableView()
    }
    
    //MARK: - set ui func
    
    fileprivate func setUI() {
        view.backgroundColor = .white
        
        view.addSubview(bottonView)
        bottonView.anchor( left: view.leftAnchor, botton: view.bottomAnchor, right: view.rightAnchor, height: 200)
        bottonView.addSubview(addButton)
        addButton.anchor(right: bottonView.rightAnchor, paddingRight: 20)
        addButton.centerY(inView: bottonView)
        view.addSubview(topBar)
        topBar.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 80)
        topBar.addSubview(saveButton)
        saveButton.anchor(right: topBar.rightAnchor, paddingRight: 20, width: 50, height: 30)
        saveButton.centerY(inView: topBar)
        topBar.addSubview(canselButton)
        canselButton.anchor(left: topBar.leftAnchor, paddingLeft: 20, width: 50, height: 30)
        canselButton.centerY(inView: topBar)
        view.addSubview(tableView)
        tableView.anchor(top: topBar.bottomAnchor, left: view.leftAnchor, botton: bottonView.topAnchor, right: view.rightAnchor)
        tableView.addSubview(addEmptyLabel)
        addEmptyLabel.centerX(inView: tableView)
        addEmptyLabel.centerY(inView: tableView)
    }
    
    //MARK: - set table view
    
    
    fileprivate func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(IngredientCell.self, forCellReuseIdentifier: IngredientCell.identifier)
    }
}

//MARK: - table view
extension AddIngredientsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ingredients.count > 0 {
            addEmptyLabel.isHidden = true
        } else {
            addEmptyLabel.isHidden = false
        }
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.identifier, for: indexPath) as! IngredientCell
        let ingredient = ingredients[indexPath.row]
        cell.textIngredientLabel.text = ingredient
        print(ingredients)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            ingredients.remove(at: indexPath.row)

            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    //MARK: - selector
    @objc private func handleAddIngredient() {
        addAlert(title: "Add ingredient")
    }
    @objc private func handledismiss() {
        dismiss(animated: true)
    }
    @objc private func handleSave() {
        
        guard ingredients.count > 0 else { return }
        delegate?.addIngredient(ingredients: ingredients)
        dismiss(animated: true)
    }
    
    func addAlert(title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addTextField { tf in
          
        tf.placeholder = "add ingredient"

        }
        let add = UIAlertAction(title: "Add", style: .default) { action in
            let textField = ac.textFields?.first
            guard  let ingredient = textField?.text else { return }
            self.ingredients.append(ingredient)
            self.tableView.reloadData()
        }
        let cansel = UIAlertAction(title: "Cansel", style: .cancel)
        ac.addAction(add)
        ac.addAction(cansel)
        present(ac, animated: true)
    }

}
