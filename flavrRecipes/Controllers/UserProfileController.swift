//
//  UserProfileController.swift
//  flavrRecipes
//
//  Created by apple on 30.08.2022.
//

import UIKit
import Firebase
import FirebaseStorage

class UserProfileController: ProfileViewController {
    //MARK: - Properties
    var isEd: Bool = false
    var recipes = [Recipe]()
    var uid: String? {
        didSet {
            setupUser(uid: uid)
        }
    }
//    var user : User?{
//        didSet{
//            if user?.uid.lowercased() != FirebaseService.shared.currentUid?.lowercased(){
//                navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "baseline_arrow_back_black_36dp-1"), style: .plain, target: self, action: #selector(handleBack))
//                setupEditFollowTitle(uid: uid)
//                nameLabel.text = user?.username
//            }
//            }
//        }
    let recipeSpinner: UIActivityIndicatorView = {
        let activitiIndicator = UIActivityIndicatorView(style: .large)
        activitiIndicator.color = .black
        return activitiIndicator
    }()
    let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(ProfileRecipeCell.self, forCellWithReuseIdentifier: ProfileRecipeCell.identifier)
        return collection
    }()
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        super.viewDidLoad()
        handleRefresh()
        setupCountersUser()
        setupUI()
        setupSpiner()
        editButton.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
        editButton.delegate = self
      
        if uid == nil {
            uid = FirebaseService.shared.currentUid
        }


    }
    private func setNavBar() {
        navigationController?.navigationBar.tintColor = .black
//        if user == nil {
            navigationItem.title = "Profile".uppercased()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleSettings))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEdit))
//        }
    }
    
    //MARK: - private func
    //MARK: - UI
    fileprivate func setupUI() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .secondarySystemBackground
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
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 150, paddingRight: 40, height: 50)
        
        view.addSubview(nameLabel)
        nameLabel.anchor(top: stackView.bottomAnchor, left: stackView.leftAnchor, right: stackView.rightAnchor, paddingTop: 5,
                          paddingLeft: 10 )
        
        let selectCollectionStack = UIStackView(arrangedSubviews: [
        myCollectionButton,
        followCollectionButton
        ])
        selectCollectionStack.axis = .horizontal
        selectCollectionStack.spacing = 8
        selectCollectionStack.distribution = .fillEqually
        view.addSubview(selectCollectionStack)
        selectCollectionStack.anchor(top: photoimage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10, height: 50 )
        view.addSubview(collectionView)
        collectionView.anchor(top: selectCollectionStack.bottomAnchor, left: view.leftAnchor, botton: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10)
        setNavBar()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleAddPhoto))
        photoimage.isUserInteractionEnabled = true
        photoimage.addGestureRecognizer(tap)
        
    }
    private func setLineUI(first string: String, and textFild: UITextField) -> UIStackView {
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
    //MARK: - get data
    //??
    private func handleRefresh() {
        handleMyCollection()
        myCollectionButton.addTarget(self, action: #selector(handleMyCollection), for: .touchUpInside)
        followCollectionButton.addTarget(self, action: #selector(handleFollowCollection), for: .touchUpInside)
    }
    fileprivate func setupUser(uid: String?) {
        guard let selfUid = FirebaseService.shared.currentUid else { return }
        let currentId = uid ?? selfUid
                FirebaseService.shared.fetchUse(uid: currentId) { user in
                    print(user)
//                    self.user = user
                    self.youNameTextField.text = user.username
                    self.emailTextField.text = user.email
                    self.nameLabel.text = user.username
                    self.getImage(user: user)
                }
    }
    private func getImage(user: User? = nil)  {
        if let user = user {
            let urlString = user.photoUrl
            self.photoimage.sd_setImage(with: URL(string: urlString))
            self.photoimage.layer.cornerRadius =  self.photoimage.frame.width / 2
            self.photoimage.clipsToBounds = true
            self.photoimage.layer.borderWidth = 3
            self.photoimage.layer.borderColor = UIColor.black.cgColor
        }


    }
    private func setupSpiner() {
        collectionView.addSubview(recipeSpinner)
        recipeSpinner.centerX(inView: collectionView)
        recipeSpinner.centerY(inView: collectionView)
    }
    //MARK: - selector action
    @objc private func handleMyCollection() {
        recipes.removeAll()
        recipeSpinner.startAnimating()
        FirebaseService.shared.fetchRecipes {[weak self] resipe in
            if resipe.user.uid == FirebaseService.shared.currentUid{
                self?.recipes.append(resipe)
            }
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.recipeSpinner.stopAnimating()
            }
            self?.recipes.sort { p1, p2 in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            }
        }
    }
    @objc private func handleFollowCollection() {
        recipeSpinner.startAnimating()
        recipes.removeAll()
        FirebaseService.shared.fetchFollowingUserId { [weak self] recipe in
            if recipe.user.uid != self?.uid  {
                self?.recipes.append(recipe)
                self?.recipes.sort { p1, p2 in
                    return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                }
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.recipeSpinner.stopAnimating()

                }
            }
        }
     
    }
    @objc private func handleBack() {
        dismiss(animated: true)
    }
    @objc private func handleSettings() {
        let ash = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let exit = UIAlertAction(title: "Exit", style: .default) { [weak self] _ in
            guard let self = self else { return }
            FirebaseService.shared.SingOut(selfVC: self)
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
//        guard user != nil else {
//            return
//        }
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }

    @objc fileprivate func actionButton() {
        print("DEBAG: edit...")
//        editButton.actionButton(uid: uid)
//        loadImage()
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
        photoimage.layer.borderColor = UIColor.gray.cgColor
        loadImage()
       dismiss(animated: true)
    }
    
    }

extension UserProfileController: ProfilButtonDelegate {
    func resetCounters() {
        self.setupCountersUser()
    }
}

extension UserProfileController: SharedPhotoControllerDelegate {
    func resetUsers() {
        self.setupCountersUser()
    }
    
    
}


extension UserProfileController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileRecipeCell.identifier, for: indexPath) as? ProfileRecipeCell else { return UICollectionViewCell() }
        let recipe = recipes[indexPath.item]
        cell.recipe = recipe
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentSize: CGFloat = view.width / 2
        return .init(width: currentSize - 5, height: currentSize - 20)
    }
}
