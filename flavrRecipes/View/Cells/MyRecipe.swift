//
//  MyRecipe.swift
//  flavrRecipes
//
//  Created by apple on 01.09.2022.
//


import UIKit
import SDWebImage

protocol MyRecipeDelegate: AnyObject {
    func addEdit(recipe: Recipe)
}

class MyRecipe: UICollectionViewCell {
    //MARK: - properties
    weak var delegate: MyRecipeDelegate?
    var recipe : Recipe?
    let photoImage : UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "DummyPhoto")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    let usernameLabel : UILabel = {
       let label = UILabel()
        label.text = "Cutegory"
        return label
    }()
    let nameLabel : UILabel = {
       let label = UILabel()
        label.text = "Pasta Salad"
        return label
    }()
    let editButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("***", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        return button
    }()
    static let identifier = "RecipeCell"
    //MARK: Life cycle

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: - set ui
    
    fileprivate func setUI() {
        self.addSubview(photoImage)
        photoImage.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 160)
        self.addSubview(editButton)
        editButton.anchor(top: photoImage.topAnchor, left: nil, botton: nil, right: photoImage.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBotton: 0, paddingRight: 12, height: 25)
        self.addSubview(nameLabel)
        nameLabel.anchor(top: photoImage.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 20)
    }
//MARK: - set Model
    
    func configureCell(with model: Recipe){
        nameLabel.text = model.title
        usernameLabel.text = model.user.username
        guard let urlString = URL(string: model.imageURL) else { return }
        photoImage.sd_setImage(with: urlString)
        
        
        //MARK: - bottom view
        lazy var peopleView = makeImageText(imageName: "ic_recipes_small", text: "\(model.person) people")
        lazy var timeView = makeImageText(imageName: "ic_duration-small", text: "\(model.time) minutes")
        lazy var complexityView = makeImageText(imageName: "ic_difficulty_small", text: "\(model.complexity )")
        let stackView = UIStackView(arrangedSubviews: [
        timeView,
        complexityView,
        peopleView
        ])
        stackView.distribution = .fillProportionally
        self.addSubview(stackView)
        stackView.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 20, paddingRight: 20)
    }
    
//MARK: - helpers func
     func makeImageText(imageName: String, text: String) -> UIView {
        let view = UIView()
        let iv = UIImageView()
         iv.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
         iv.contentMode = .scaleAspectFill
        view.addSubview(iv)
        iv.anchor(top: view.topAnchor, left: view.leftAnchor, botton: view.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingBotton: 0, width: 24, height: 24)
        let label : UILabel = {
           let label = UILabel()
            label.text = text
            return label
        }()
         view.addSubview(label)
         label.anchor( left: iv.rightAnchor, right: view.rightAnchor,  paddingLeft: 5,  paddingRight: 5)
         label.centerY(inView: view)
      return view
    }
    //MARK: - selector
    
    @objc private func handleEdit() {
        print("DEBAG: edit")
        guard let recipe = recipe else {
            return
        }

        delegate?.addEdit(recipe: recipe)
        
    }
}
