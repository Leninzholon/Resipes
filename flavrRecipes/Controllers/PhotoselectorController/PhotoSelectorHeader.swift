//
//  PhotoSelectorHeader.swift
//  InstagramFireBase
//
//  Created by apple on 08.08.2022.
//

import UIKit

class PhotoSelectorHeader: UICollectionViewCell {
    let mainPhotoImage : UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .brown
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainPhotoImage)
        mainPhotoImage.anchor(top: topAnchor, left: leftAnchor, botton: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBotton: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

