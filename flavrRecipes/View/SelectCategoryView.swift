//
//  SelectCategory.swift
//  flavrRecipes
//
//  Created by apple on 02.01.2023.
//

import UIKit

class SelectCategoryView: UITableView {
     let categries: [Categories] = Categories.allCases
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
