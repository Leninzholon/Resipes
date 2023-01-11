//
//  RecipeCell.swift
//  flavrRecipes
//
//  Created by apple on 27.08.2022.
//

import UIKit
import SDWebImage
import Firebase

protocol RecipeCellDelegate: AnyObject {
    func didLike(from cell: RecipeCell)
}

class RecipeCell: UICollectionViewCell {
    //MARK: - properties
    weak var delegate: RecipeCellDelegate?
   
    let foodImage : UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "DummyPhoto")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    lazy var likeImage: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemPink
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "like_unselected"), for: .normal)
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    let userImage : UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "plus_photo")
        iv.tintColor = .black
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
    let saveButton : UIButton = {
       let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .orange
        button.layer.cornerRadius = 10
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
       

        self.addSubview(foodImage)
        foodImage.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 128)
        addSubview(likeImage)
        likeImage.anchor(top: foodImage.bottomAnchor, left: nil, botton: nil, right: foodImage.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBotton: 0, paddingRight: 12, width: 36, height: 36)
        self.addSubview(usernameLabel)
        usernameLabel.anchor(top: foodImage.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 20 )
        self.addSubview(userImage)
        userImage.centerY(inView: usernameLabel, leftAnchor: usernameLabel.rightAnchor, paddingLeft: 12, constant: 0)
        userImage.anchor(width: 24, height: 24)
        self.addSubview(nameLabel)
        nameLabel.anchor(top: usernameLabel.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 20)

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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: - set Model
    
    func configureCell(with model: Recipe){
        likeImage.setImage(model.hasLiked ? UIImage(named: "icon-like-selected") : UIImage(named: "Normal"), for: .normal)
        
        nameLabel.text = model.title
        usernameLabel.text = model.user.username
        getImage(user: model.user)
        guard let urlString = URL(string: model.imageURL) else { return }
        foodImage.sd_setImage(with: urlString)
        timeLabel.text = "\(model.time) minutes"
        complexityLabel.text = "\(model.complexity)"
        peopleLabel.text = "\(model.person) People"
    }

    func getImage(user: User? = nil)  {
        guard let currentUser = Auth.auth().currentUser?.uid  else { return }
        let ref = Database.database().reference().child("users").child( user?.uid ?? currentUser)
        ref.observeSingleEvent(of: .value) { snapshot, string in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            print(dictionary)
            let user = User(uid: user?.uid ?? currentUser, dictionary: dictionary)
             let urlString = user.photoUrl
            print(user.photoUrl)
            self.userImage.sd_setImage(with: URL(string: urlString))
            self.userImage.layer.cornerRadius =  self.userImage.frame.width / 2
            self.userImage.clipsToBounds = true
            self.userImage.layer.borderWidth = 3
            self.userImage.layer.borderColor = UIColor.black.cgColor
        }
    }

    //MARK: - selector
    
    @objc fileprivate func handleLike() {
        delegate?.didLike(from: self)
    }
}
