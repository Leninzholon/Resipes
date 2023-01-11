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
    lazy var editButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("***", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        return button
    }()
    let peopleView : UIView = {
       let view = UIView()
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_recipes_small")
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        view.addSubview(imageView)
        imageView.anchor(left: view.leftAnchor, paddingLeft: 12)
        imageView.centerY(inView: view)
        return view
    }()
    let timeView : UIView = {
       let view = UIView()
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_duration-small")
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        view.addSubview(imageView)
        imageView.anchor(left: view.leftAnchor, paddingLeft: 12)
        imageView.centerY(inView: view)
        return view
    }()
    let complexityView : UIView = {
       let view = UIView()
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_difficulty_small")
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        view.addSubview(imageView)
        imageView.anchor(left: view.leftAnchor, paddingLeft: 12)
        imageView.centerY(inView: view)
        return view
    }()
    let peopleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.text = "5"
        return label
    }()
    let complexityLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.text = "Medium"
        return label
    }()
    let timeLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.text = "20"
        return label
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

        peopleView.addSubview(peopleLabel)
        peopleLabel.anchor(left: peopleView.leftAnchor, paddingLeft: 40)
        peopleLabel.centerY(inView: peopleView)
        complexityView.addSubview(complexityLabel)
        complexityLabel.anchor(left: complexityView.leftAnchor, paddingLeft: 40)
        complexityLabel.centerY(inView: complexityView)
        timeView.addSubview(timeLabel)
        timeLabel.anchor(left: timeView.leftAnchor, paddingLeft: 40)
        timeLabel.centerY(inView: timeView)
        let stackView = UIStackView(arrangedSubviews: [
        timeView,
        complexityView,
        peopleView
        ])
        stackView.distribution = .fillEqually
        self.addSubview(stackView)
        stackView.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 20, paddingRight: 20)
    }
//MARK: - set Model
    
    func configureCell(with model: Recipe){
        nameLabel.text = model.title
        usernameLabel.text = model.user.username
        guard let urlString = URL(string: model.imageURL) else { return }
        photoImage.sd_setImage(with: urlString)
        timeLabel.text = "\(model.time) minutes"
        complexityLabel.text = "\(model.complexity)"
        peopleLabel.text = "\(model.person) People"
        
        //MARK: - bottom view
        let stackView = UIStackView(arrangedSubviews: [
        timeView,
        complexityView,
        peopleView
        ])
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        self.addSubview(stackView)
        stackView.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 20, paddingRight: 20)
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
