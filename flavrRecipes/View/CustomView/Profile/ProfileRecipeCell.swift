//
//  ProfileRecipeCell.swift
//  flavrRecipes
//
//  Created by apple on 25.12.2022.
//

import UIKit
import SDWebImage


class ProfileRecipeCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "ProfileRecipeCell"
    var recipe: Recipe?  {
        didSet {
            guard let recipe = recipe, let url = URL(string: recipe.imageURL) else { return }
            foodImage.sd_setImage(with: url)
            recipeTitle.text = recipe.title
        }
    }
    let foodImage : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    let recipeTitle: UILabel = {
       let label = UILabel()
        label.text = "Title"
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Public
    
    public func configureCell() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(foodImage)
        foodImage.anchor(top:  contentView.topAnchor, left:  contentView.leftAnchor, right:  contentView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10, height:  contentView.height - 49)
        contentView.addSubview(recipeTitle)
        recipeTitle.anchor(top: foodImage.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingLeft: 10, paddingRight: 10, height: 44)
    }
    
  
 
}
