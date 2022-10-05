//
//  DetaillViewController.swift
//  flavrRecipes
//
//  Created by apple on 06.09.2022.
//

import UIKit
import SDWebImage
import Firebase


class DetaillViewController: UIViewController {
    var ingredients = [String]()
    var instructions = [String]()
    var recipe : Recipe? {
        didSet {
            guard let recipe = recipe  else {
                return
            }
            recipreImage.sd_setImage(with: URL(string: recipe.imageURL))
            titleLabel.text = recipe.title
            complexityView = makeImageText(imageName: "ic_difficulty_small", text: "\(recipe.complexity)")
            timeView = makeImageText(imageName: "ic_duration-small", text: "\(recipe.time) minutes")
            peopleView = makeImageText(imageName: "ic_recipes_small", text: "\(recipe.person) people")
            ingredients = recipe.ingredients
            instructions = recipe.instructions
            likeImage.image = recipe.hasLiked ? UIImage(named: "ic_favorite_white") : UIImage(named: "ic_favorite")
        }
    }
    let darckView : UIView = {
       let v = UIView()
        v.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return v
    }()
    let recipreImage : UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "DummyPhoto")
        iv.contentMode = .scaleToFill
                return iv
    }()
    lazy var likeImage : UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "ic_favorite")
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLike))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    lazy var backArrow : UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "ic_arrow_back_white")
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    let titleLabel : UILabel = {
       let label = UILabel()
        label.text = "Pasta Salad"
        label.font = UIFont(name: "Helvetica Neue", size: 20)
        label.textAlignment = .center
        return label
    }()
    let tabView = UITableView()
    lazy var peopleView = makeImageText(imageName: "ic_recipes_small", text: " people")
    lazy var timeView = makeImageText(imageName: "ic_duration-small", text: " minutes")
    lazy var complexityView = makeImageText(imageName: "ic_difficulty_small", text: "\(recipe?.complexity  ?? "Easy")")
    //MARK: live cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        tabView.register(InstructionCell.self, forCellReuseIdentifier: InstructionCell.identifier)
        tabView.register(IngredientCell.self, forCellReuseIdentifier: IngredientCell.identifier)
        tabView.dataSource = self
        tabView.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }
  //MARK: - UI
    
    
    fileprivate func setUI() {
        view.backgroundColor = .white
        view.addSubview(recipreImage)
        recipreImage.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 192)
        view.addSubview(darckView)
        darckView.anchor(top: recipreImage.topAnchor, left: recipreImage.leftAnchor, botton: recipreImage.bottomAnchor, right: recipreImage.rightAnchor)
        view.addSubview(likeImage)
        likeImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: recipreImage.rightAnchor, paddingTop: 16, paddingRight: 16, width: 24, height: 24)
        view.addSubview(backArrow)
        backArrow.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: recipreImage.leftAnchor, paddingTop: 16, paddingLeft: 16, width: 24, height: 24)
        view.addSubview(titleLabel)
        titleLabel.anchor(top: recipreImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 48, paddingLeft: 16, paddingRight: 16)
        let stacView = UIStackView(arrangedSubviews: [
            timeView,
            complexityView,
            peopleView
        ])
        stacView.distribution = .fillProportionally
        stacView.axis = .horizontal
        view.addSubview(stacView)
        stacView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16, height: 30)
        view.addSubview(tabView)
        tabView.anchor(top: stacView.bottomAnchor, left: view.leftAnchor, botton: view.bottomAnchor, right: view.rightAnchor)
    }
    
    func makeImageText(imageName: String, text: String) -> UIView {
       let view = UIView()
       let iv = UIImageView()
        iv.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleToFill
       view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, width: 24, height: 24)
        iv.centerY(inView: view)
       var label : UILabel = {
          let label = UILabel()
           label.text = text
           return label
       }()
        view.addSubview(label)
        label.anchor( left: iv.rightAnchor, right: view.rightAnchor,  paddingLeft: 5,  paddingRight: 5)
        label.centerY(inView: view)
     return view
    }

//MARK: - Selector func
    
    @objc private func handleLike() {
       
        guard var recipe = recipe else { return }
        guard let postId = recipe.id else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let value = [uid: recipe.hasLiked ? 0 : 1]
            Database.database().reference().child("likes").child(postId).updateChildValues(value) { err, _ in
                if let err = err {
                    print("Failed to like post", err)
                }
                print("Successfully, liked post")
                recipe.hasLiked = !recipe.hasLiked
                self.likeImage.image = recipe.hasLiked ? UIImage(named: "ic_favorite_white") : UIImage(named: "ic_favorite")
                let name = NSNotification.Name("UpdateLike")
                NotificationCenter.default.post(name: name, object: nil)
        
        }
    }
    @objc private func handleDismiss() {
        dismiss(animated: true)
    }
}



//MARK: - table view

extension DetaillViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
           return ingredients.count
        } else {
            return instructions.count
        }
           
        
        
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.identifier , for: indexPath) as! IngredientCell
            cell.textIngredientLabel.text = ingredients[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: InstructionCell.identifier , for: indexPath) as! InstructionCell
            cell.textIngredientLabel.text = instructions[indexPath.row]
            cell.numberLabel.text = "\(indexPath.row + 1)"
            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Ingredients".capitalized
        } else {
            return "Instructions".capitalized

        }
    }
    
}
