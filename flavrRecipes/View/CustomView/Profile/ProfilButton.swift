//
//  ProfilButton.swift
//  flavrRecipes
//
//  Created by apple on 18.12.2022.
//

import UIKit
import Firebase
import FirebaseStorage

protocol ProfilButtonDelegate: AnyObject {
    func resetCounters()
}

class ProfilButton: UIButton {
    weak var delegate: ProfilButtonDelegate?
    let titleButton: String
    init(titleButton: String){
        self.titleButton = titleButton
        super.init(frame: .zero)
        setTitle(titleButton, for: .normal)
        backgroundColor = .orange
        tintColor = .black
        titleLabel?.font = .systemFont(ofSize: 16)
        layer.cornerRadius = 20
        heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func actionButton(uid: String?){
     
        if titleLabel?.text == "Unfollow"{
            guard  let currentLoggedUserUid = Auth.auth().currentUser?.uid else {
                return
            }
            guard let userId = uid else {
                return
                
            }
            Database.database().reference().child("following").child(currentLoggedUserUid).child(userId).removeValue { err, ref in
                if let err = err {
                    print("Failed to unfollow user", err)
                    return
                } else {
                    print("Successfully, unfollow")
                }
                self.setTitle("Follow", for: .normal)
                self.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
                self.setTitleColor(.white, for: .normal)
                self.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
                self.delegate?.resetCounters()
            }
            return
        }
        if self.titleLabel?.text == "Follow" {
            guard  let currentLoggedUserUid = Auth.auth().currentUser?.uid else {
                return
            }
            guard let userId = uid else {
                return
                
            }
            let ref = Database.database().reference().child("following").child(currentLoggedUserUid)
            let values = [ userId : 1 ]
            ref.updateChildValues(values) { err, ref in
                if let err = err {
                    print("Failer follow", err)
                    return
                }
                print("Seccussfully, followed user")
            }
            self.setTitle("Unfollow", for: .normal)
            self.backgroundColor = .orange
            self.setTitleColor(.white, for: .normal)
            self.delegate?.resetCounters()
            return
        }




    }

}
