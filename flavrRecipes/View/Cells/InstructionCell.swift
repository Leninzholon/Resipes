//
//  InstructionCell.swift
//  flavrRecipes
//
//  Created by apple on 10.09.2022.
//

import UIKit

class InstructionCell: UITableViewCell {
    static let identifier = "InstructionCell"
    let pointView: UIView = {
       let view = UIView()
        view.backgroundColor = .orange
        view.widthAnchor.constraint(equalToConstant: 36).isActive = true
        view.heightAnchor.constraint(equalToConstant: 36).isActive = true
        view.layer.cornerRadius = 18
        view.clipsToBounds = true
        return view
    }()
    let textIngredientLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(pointView)
        pointView.anchor(left: leftAnchor, paddingLeft: 16)
        pointView.centerY(inView: self)
        pointView.addSubview(numberLabel)
        numberLabel.centerY(inView: pointView)
        numberLabel.centerX(inView: pointView)
        addSubview(textIngredientLabel)
        textIngredientLabel.anchor(left: pointView.rightAnchor, right: rightAnchor, paddingLeft: 16, paddingRight: 16)
        textIngredientLabel.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
