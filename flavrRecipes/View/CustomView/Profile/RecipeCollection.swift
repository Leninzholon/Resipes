//
//  RecipeCollection.swift
//  flavrRecipes
//
//  Created by apple on 26.12.2022.
//

import UIKit



class RecipeCollection: UICollectionView {
    enum CollectionType {
        case myRecipe
        case followingRecipe
    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
