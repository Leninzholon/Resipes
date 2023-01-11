//
//  DetaillCategoryCell.swift
//  flavrRecipes
//
//  Created by apple on 02.01.2023.
//

import UIKit
import SDWebImage

class DetaillCategoryCell: UICollectionViewCell {
    static let identifier = "DetaillCategoryCell"
    var recipe: Recipe? {
        didSet {
            guard let recipe = recipe else { return }
            guard let url = URL(string: recipe.imageURL) else { return }
            recipeImage.sd_setImage(with: url)
            titleRecipe.text = recipe.title
            timeLabel.text = "\(recipe.time) minutes"
            complicationLabel.text = "\(recipe.complexity)"
            amountLabel.text = "\(recipe.person) People"
        }
    }
    let recipeImage: UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .gray
        return iv
    }()
    let titleRecipe: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "Title"
        return label
    }()
    let tileImage: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "ic_duration-small")
        return iv
    }()
    let complicationImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ic_difficulty")
         return iv
    }()
    let amountImage: UIImageView = {
        let iv = UIImageView()
         iv.image = UIImage(named: "ic_recipes_small")
         return iv
    }()
    let timeLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .gray
        label.text = "60 minutes"
        return label
    }()
    let complicationLabel: UILabel = {
        let label = UILabel()
         label.font = .systemFont(ofSize: 14, weight: .light)
         label.textColor = .gray
        label.text = "Moderate"
         return label
    }()
    let amountLabel: UILabel = {
        let label = UILabel()
         label.font = .systemFont(ofSize: 14, weight: .light)
         label.textColor = .gray
        label.text = "8 People"
         return label
    }()
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //private func
    private func configureCell() {
        let timeStack = UIStackView(arrangedSubviews: [
        tileImage,
        timeLabel
        ])
        timeStack.axis = .horizontal
        timeStack.spacing = 8
        let complicationStack = UIStackView(arrangedSubviews: [
        complicationImage,
        complicationLabel
        ])
        complicationStack.axis = .horizontal
        complicationStack.distribution = .fillProportionally
        complicationStack.spacing = 8
        let amountStack = UIStackView(arrangedSubviews: [
        amountImage,
        amountLabel
        ])
        amountStack.axis = .horizontal
        amountStack.spacing = 8
        let fullStackView = UIStackView(arrangedSubviews: [
        timeStack,
        complicationStack,
        amountStack
        ])
        fullStackView.axis = .horizontal
        fullStackView.distribution = .fillEqually
        contentView.addSubview(recipeImage)
        recipeImage.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: self.height / 1.5)
        contentView.addSubview(titleRecipe)
        titleRecipe.anchor(top: recipeImage.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingLeft: 16)
        contentView.addSubview(fullStackView)
        fullStackView.anchor(top: titleRecipe.bottomAnchor, left: contentView.leftAnchor, botton: contentView.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 16, height: 20)
      
    }
    
}
