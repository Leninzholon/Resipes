//
//  CategoryCell.swift
//  flavrRecipes
//
//  Created by apple on 28.12.2022.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    static let identifier = "CategoryCell"
    var category: Categories? {
        didSet {
            guard let category = category else { return }
            titleLabel.text = category.rawValue.uppercased()
        }
    }
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.backgroundColor = .white
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, botton: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBotton: 5, paddingRight: 20 )
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
