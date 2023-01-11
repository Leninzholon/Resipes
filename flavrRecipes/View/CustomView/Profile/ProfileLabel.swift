//
//  ProfileLabel.swift
//  flavrRecipes
//
//  Created by apple on 18.12.2022.
//

import UIKit

class ProfileLabel: UILabel {
    
    let atribut: NSAttributedString
    init(atribut: NSAttributedString) {
        self.atribut = atribut
        super.init(frame: .zero)
        numberOfLines = 2
        textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
