//
//  FavoriteCell.swift
//  flavrRecipes
//
//  Created by apple on 29.12.2022.
//

import UIKit
import SDWebImage

protocol FavoriteCellDelegate: AnyObject {
    func didLike(from cell: FavoriteCell)
}

class FavoriteCell: UICollectionViewCell {
    //MARK - Properties
    static let identifier = "FavoriteCell"
    weak var delegate: FavoriteCellDelegate?
    static let height: CGFloat = 232
    var recipe: Recipe? {
        didSet{
            guard let recipe = recipe else { return }
            titleLabel.text = recipe.title
            guard let url = URL(string: recipe.imageURL) else { return }
            recipeImage.sd_setImage(with: url)
        }
    }
    let recipeImage: UIImageView = {
       let image = UIImageView()
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.widthAnchor.constraint(equalToConstant: height - 50).isActive = true
        return image
    }()
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Title"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    let counterLabel: UILabel = {
       let label = UILabel()
        label.text = "345"
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "like_selected")?.withTintColor(.systemPink), for: .normal)
        button.addTarget(self, action: #selector(didUnkike), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }()
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        congigureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - private
    private func congigureCell() {
        let likeStack = UIStackView(arrangedSubviews: [
            counterLabel,
            likeButton
        ])
        likeStack.axis = .vertical
        likeStack.widthAnchor.constraint(equalToConstant: 35).isActive = true
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 6
        let titleLikeStack = UIStackView(arrangedSubviews: [
        titleLabel,
       likeStack
        ])
        titleLikeStack.spacing = 8
        titleLikeStack.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let favoriteStack = UIStackView(arrangedSubviews: [
            recipeImage,
            titleLikeStack
        ])

        favoriteStack.axis = .vertical
        favoriteStack.distribution = .fillProportionally
        favoriteStack.spacing = 8
        contentView.addSubview(favoriteStack)
        favoriteStack.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
                                botton: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingRight: 5)
    }
    //selector
    @objc private func didUnkike() {
        delegate?.didLike(from: self)
    }
}
