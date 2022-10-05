//
//  UserProfileController.swift
//  flavrRecipes
//
//  Created by apple on 30.08.2022.
//

import UIKit
import Firebase
import FirebaseStorage

class UserProfileController: UIViewController {
    //MARK: - Properties
    var isEd: Bool = false
    var user : User? {
        didSet{
            getImage(user: user)
            youNameTextField.text = user?.username
            emailTextField.text = user?.email
            setupEditFollowTitle()
            title = "\(user?.username ?? "")"
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "baseline_arrow_back_black_36dp-1"), style: .plain, target: self, action: #selector(handleBack))

        }
    }
    let recipeLabel : UILabel = {
       let label = UILabel()
        let atributedText = NSMutableAttributedString(string: "11\n",
                                                      attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        atributedText.append(.init(string: "recipes", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
        label.attributedText = atributedText
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    let followersLabel : UILabel = {
       let label = UILabel()
        let atributedText = NSMutableAttributedString(string: "0\n",
                                                      attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        atributedText.append(.init(string: "followers", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
        label.attributedText = atributedText
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    let followingLabel : UILabel = {
       let label = UILabel()
        let atributedText = NSMutableAttributedString(string: "0\n",
                                                      attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        atributedText.append(.init(string: "folloving", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
        label.attributedText = atributedText
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
  lazy  var photoimage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "plus_photo")
        return imageView
}()
    lazy var youNameTextField: UITextField = {
       let tf = UITextField()
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 30))
        tf.leftView = v
        tf.leftViewMode = .always
        tf.placeholder = "Your Name"
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true
        tf.isEnabled = isEd
        return tf
    }()
    lazy var  emailTextField: UITextField = {
       let tf = UITextField()
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 30))
        tf.leftView = v
        tf.leftViewMode = .always
        tf.placeholder = "Your Email"
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true
        tf.isEnabled = isEd
        return tf
    }()
    //MAR
    let saveButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .orange
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.cornerRadius = 20
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
   
        view.addSubview(photoimage)
        photoimage.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 40, paddingLeft: 40, width: 100, height: 100)
        let stackView = UIStackView(arrangedSubviews: [
        recipeLabel,
        followersLabel,
        followingLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 8
        view.addSubview(stackView)
        stackView.anchor( left: photoimage.rightAnchor, paddingLeft: 40)
        stackView.centerY(inView: photoimage)
        let nameStack = setLine(first: "Name", and: youNameTextField)
        let emailStack = setLine(first: "Email", and: emailTextField)
        let tfStackView = UIStackView(arrangedSubviews: [
            nameStack,
            emailStack
        ])
        tfStackView.axis = .vertical
        
        view.addSubview(tfStackView)
        tfStackView.anchor(top: photoimage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingRight: 40)
        view.addSubview(saveButton)
        saveButton.anchor(top: tfStackView.bottomAnchor, paddingTop: 40, width: 200)
        saveButton.centerX(inView: view)
        if user == nil {
                    uploadUser()
                    getImage()
        }
        setNavBar()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleAddPhoto))
        photoimage.isUserInteractionEnabled = true
        photoimage.addGestureRecognizer(tap)
        
        
        guard let user = user else {
            return
        }
        youNameTextField.text = user.username
        emailTextField.text = user.email
    }
    private func setNavBar() {
        navigationController?.navigationBar.tintColor = .black
        if user == nil {
            navigationItem.title = "Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleSettings))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEdit))
        }
    }
    
    //MARK: - helpers func
    
    private func uploadUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { user in
            self.youNameTextField.text = user.username
            self.emailTextField.text = user.email
        }
    }
    private func setLine(first string: String, and textFild: UITextField) -> UIStackView {
        let label : UILabel = {
            let leb = UILabel()
            leb.text = string
            leb.widthAnchor.constraint(equalToConstant: 80).isActive = true
            return leb
        }()
        let stackView = UIStackView(arrangedSubviews: [
        label,
        textFild
        ])
        stackView.distribution = .fillProportionally
        return stackView
        
    }
    //MARK: - selector
    @objc private func handleBack() {
        dismiss(animated: true)
    }
    @objc private func handleSettings() {
        let ash = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let exit = UIAlertAction(title: "Exit", style: .default) { _ in
                    do {
                        try  Auth.auth().signOut()
                        print("Success")
                    } catch let err {
                        print(err.localizedDescription)
                    }
        }
        let cansel = UIAlertAction(title: "Cansel", style: .cancel)
        ash.addAction(exit)
        ash.addAction(cansel)
        present(ash, animated: true)
    }
    @objc private func handleEdit() {
        print("Edit..")
        isEd = !isEd
        youNameTextField.isEnabled = isEd
        emailTextField.isEnabled = isEd
    }
    @objc private func handleAddPhoto() {
        guard user == nil else {
            return
        }
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    func getImage(user: User? = nil)  {
        guard let currentUser = Auth.auth().currentUser?.uid  else { return }
        let ref = Database.database().reference().child("users").child( user?.uid ?? currentUser)
        ref.observeSingleEvent(of: .value) { snapshot, string in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            print(dictionary)
            let user = User(uid: user?.uid ?? currentUser, dictionary: dictionary)
             let urlString = user.photoUrl
            print(user.photoUrl)
            self.photoimage.sd_setImage(with: URL(string: urlString))
            self.photoimage.layer.cornerRadius =  self.photoimage.frame.width / 2
            self.photoimage.clipsToBounds = true
            self.photoimage.layer.borderWidth = 3
            self.photoimage.layer.borderColor = UIColor.black.cgColor
        }
    }
    @objc fileprivate func actionButton() {
     
        if saveButton.titleLabel?.text == "Unfollow"{
            guard  let currentLoggedUserUid = Auth.auth().currentUser?.uid else {
                return
            }
            guard let userId = user?.uid else {
                return
                
            }
            Database.database().reference().child("following").child(currentLoggedUserUid).child(userId).removeValue { err, ref in
                if let err = err {
                    print("Failed to unfollow user", err)
                    return
                } else {
                    print("Successfully, unfollow", self.user?.username ?? "")
                }
                self.saveButton.setTitle("Follow", for: .normal)
                self.saveButton.backgroundColor = #colorLiteral(red: 0, green: 0.6273162365, blue: 0.9439057708, alpha: 1)
                self.saveButton.setTitleColor(.white, for: .normal)
                self.saveButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
            }
            return
        }
        if saveButton.titleLabel?.text == "Follow" {
            guard  let currentLoggedUserUid = Auth.auth().currentUser?.uid else {
                return
            }
            guard let userId = user?.uid else {
                return
                
            }
            let ref = Database.database().reference().child("following").child(currentLoggedUserUid)
            let values = [ userId : 1 ]
            ref.updateChildValues(values) { err, ref in
                if let err = err {
                    print("Failer follow", err)
                    return
                }
                print("Seccussfully, followed user", self.user?.username ?? "")
            }
            self.saveButton.setTitle("Unfollow", for: .normal)
            self.saveButton.backgroundColor = .orange
            self.saveButton.setTitleColor(.white, for: .normal)
            
            return
        }

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
    fileprivate func setupEditFollowTitle() {
        guard  let currentLoggedUserUid = Auth.auth().currentUser?.uid else {
            return
        }
        guard let userId = user?.uid else {
            return
            
        }
        if user?.uid != Auth.auth().currentUser?.uid {
            Database.database().reference().child("following").child(currentLoggedUserUid).child(userId).observeSingleEvent(of: .value) { snapshot in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.saveButton.setTitle("Unfollow", for: .normal)
                    self.saveButton.backgroundColor = #colorLiteral(red: 0.9673562646, green: 0.6002095342, blue: 0.3723991513, alpha: 1)
                    self.saveButton.tintColor = .white
                    self.saveButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
                    
                } else {
                    self.saveButton.setTitle("Follow", for: .normal)
                    self.saveButton.backgroundColor = .orange
                    self.saveButton.tintColor = .white
                    self.saveButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
                }
               
            }
            
           
        }
    }

}


extension UserProfileController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        
        if let editedImage = info[.editedImage] as? UIImage {
            photoimage.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            photoimage.image = originalImage

        }
        photoimage.layer.cornerRadius = photoimage.frame.width / 2

        photoimage.clipsToBounds = true
        photoimage.layer.borderWidth = 3
        photoimage.layer.borderColor = UIColor.black.cgColor
       dismiss(animated: true)
    }
    
    }

