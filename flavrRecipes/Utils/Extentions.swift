//
//  Extentions.swift
//  flavrRecipes
//
//  Created by apple on 26.08.2022.
//

import UIKit
import Firebase

//MARK: - Anchor
extension UIView {
    func anchor ( top: NSLayoutYAxisAnchor? = nil,
                  left: NSLayoutXAxisAnchor? = nil,
                  botton: NSLayoutYAxisAnchor? = nil,
                  right: NSLayoutXAxisAnchor? = nil,
                  paddingTop: CGFloat = 0,
                  paddingLeft: CGFloat = 0,
                  paddingBotton: CGFloat = 0,
                  paddingRight: CGFloat = 0,
                  width: CGFloat? = nil,
                  height: CGFloat? = nil){
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
            
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let botton = botton {
            bottomAnchor.constraint(equalTo: botton, constant: -paddingBotton).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    func centerX(inView view: UIView, constant: CGFloat = 0){
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).isActive = true
    }
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0, constant: CGFloat = 0){
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
}

//MARK: - set dimentions
extension UIView {
    func setDimentions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}
//MARK: - make shadow

extension UIView {
    func addShadow() {
        layer.shadowColor =  UIColor.black.cgColor
        layer.shadowOpacity = 0.55
        layer.shadowOffset = .init(width: 0.5, height: 0.5)
        layer.masksToBounds = false
    }
}

//MARK: - gradient

extension UIView {
    func addGradient() {
        let gradient = CAGradientLayer()
        
        gradient.colors = [UIColor.white.cgColor, UIColor.orange.cgColor]
        gradient.startPoint = CGPoint(x: 0.3, y: 0.9)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
}


//MARK: - strok line

extension UIView {
    func strokLine(color: UIColor = .black, width: CGFloat = 1, corner: CGFloat?) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        guard let cornerRarius = corner else { return }
        layer.cornerRadius = cornerRarius
        clipsToBounds = true
    }
}


//MARK: - firebase

extension Database {
    
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
            
        }) { (err) in
            print("Failed to fetch user for posts:", err)
        }
    }
}

//MARK: - scaledToSafeUploadSize
extension UIImage {
    
    var scaledToSafeUploadSize: UIImage? {
      let maxImageSideLength: CGFloat = 480
      
      let largerSide: CGFloat = max(size.width, size.height)
      let ratioScale: CGFloat = largerSide > maxImageSideLength ? largerSide / maxImageSideLength : 1
      let newImageSize = CGSize(width: size.width / ratioScale, height: size.height / ratioScale)
      
      return image(scaledTo: newImageSize)
    }
    
    func image(scaledTo size: CGSize) -> UIImage? {
      defer {
        UIGraphicsEndImageContext()
      }
      
      UIGraphicsBeginImageContextWithOptions(size, true, 0)
      draw(in: CGRect(origin: .zero, size: size))

      return UIGraphicsGetImageFromCurrentImageContext()
    }
}


