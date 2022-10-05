//
//  PhotoSelectorCollectionCell.swift
//  InstagramFireBase
//
//  Created by apple on 08.08.2022.
//

import UIKit

class PhotoSelectorCollectionCell: UICollectionViewCell {
   
    var currentPhoto : UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(currentPhoto)
        currentPhoto.anchor(top: topAnchor, left: leftAnchor, botton: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBotton: 0, paddingRight: 0, width: 0, height: 0)
    }
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
