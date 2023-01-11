//
//  PrifileViewController.swift
//  flavrRecipes
//
//  Created by apple on 18.12.2022.
//

import UIKit
import Firebase
import FirebaseStorage



class ProfileViewController: UIViewController {
//MARK: - Properties
    var countFollovers: Int?
    let recipeLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    let followersLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    lazy var followingLabel : UILabel = {
     
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
  lazy  var photoimage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "plus_photo")
        return imageView
}()
    lazy var youNameTextField: ProfileField = {
        let tf = ProfileField(type: .username)
        return tf
    }()
    lazy var  emailTextField: ProfileField = {
        let tf = ProfileField(type: .email)
        return tf
    }()
    let nameLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    lazy var editButton : ProfilButton = {
        let button = ProfilButton(titleButton: "Edit")
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor
        button.layer.cornerRadius = 10
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var myCollectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("My collection", for: .normal)
        button.tintColor = .black
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor
        button.layer.cornerRadius = 10
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    lazy var followCollectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow collection", for: .normal)
        button.tintColor = .black
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor
        button.layer.cornerRadius = 10
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCountersUser()
    }
 //MARK: - Public func
     func setupCountersUser() {
        FirebaseService.shared.countFolloving { count in
            let atributedText = NSMutableAttributedString(string: "\(count ?? 0)\n",
                                                          attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            atributedText.append(.init(string: "folloving", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
            
            self.followingLabel.attributedText = atributedText
        }
        FirebaseService.shared.countFollowers { count in
            let atributedText = NSMutableAttributedString(string: "\(count ?? 0)\n",
                                                          attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            atributedText.append(.init(string: "followers", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
            self.followersLabel.attributedText = atributedText
            
        }
        FirebaseService.shared.countResipes { count in
            let atributedText = NSMutableAttributedString(string: "\(count ?? 0)\n",
                                                          attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            atributedText.append(.init(string: "recipes", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
            self.recipeLabel.attributedText = atributedText
        }
    }
     func setupEditFollowTitle(uid: String?) {
        guard  let currentLoggedUserUid = Auth.auth().currentUser?.uid else {
            return
        }
        guard let uid = uid else {
            return

        }
        if uid != Auth.auth().currentUser?.uid {
            Database.database().reference().child("following").child(currentLoggedUserUid).child(uid).observeSingleEvent(of: .value) { [weak self] snapshot in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self?.editButton.setTitle("Unfollow", for: .normal)
                    self?.editButton.backgroundColor = #colorLiteral(red: 0.9673562646, green: 0.6002095342, blue: 0.3723991513, alpha: 1)
                    self?.editButton.tintColor = .white
                    self?.editButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
                    self?.setupCountersUser()
                    NotificationCenter.default.post(name: .follow, object: nil, userInfo: nil)
                } else {
                    self?.editButton.setTitle("Follow", for: .normal)
                    self?.editButton.backgroundColor = .orange
                    self?.editButton.tintColor = .white
                    self?.editButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
                    self?.setupCountersUser()
                }
               
            }
            
           
        }
    }
     func loadImage() {
        guard let email = emailTextField.text, email.count > 0 else { return }
           guard let username = youNameTextField.text, username.count > 0 else { return }

            guard let image = self.photoimage.image else { return }
            guard let uploadData = image.scaledToSafeUploadSize, let imageData = uploadData.jpegData(compressionQuality: 0.3) else { return }
            let fileName = NSUUID().uuidString
            let storeRef = Storage.storage().reference().child("profile_image").child(fileName)
            storeRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Failed to uploud image", error)
                    return
                }

                storeRef.downloadURL { url, err in
                    if err != nil {
                           print("Failed to download url:", err!)
                           return
                       } else {
                          //Do something with url
                           guard let url = url?.absoluteString else { return }
                           guard let user = Auth.auth().currentUser else { return }
                            let uid = user.uid
                           let dictionaryValues = [ "username" : username, "email" : email, "photoUrl" : url]
                          let values = [uid : dictionaryValues]
                          Database.database().reference().child("users").updateChildValues(values) { (err, ref) in
                              if let error = err {
                                  print("Fain to save user info in db", error)
                                  return
                              }
                              print("Successfull saved user to db")

                          }
                           }
                }
                print("Successfully, upload image")
            }
    }

}


extension Notification.Name{
    static let follow = Notification.Name("follow")
}
