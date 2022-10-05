//
//  SearchCell.swift
//  flavrRecipes
//
//  Created by apple on 01.09.2022.
//

import UIKit

class SearchCell : UITableViewCell {
    static let identifier = "SearchCell"
    static let height: CGFloat = 50
    let nameLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor, left: leftAnchor, botton: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 16, paddingBotton: 5, paddingRight: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
