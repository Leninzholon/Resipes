//
//  SharedPhotoController.swift
//  InstagramFireBase
//
//  Created by apple on 09.08.2022.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import Firebase

protocol SharedPhotoControllerDelegate: AnyObject {
    func resetUsers()
}

class SharedPhotoController: UIViewController {
    weak var delegate: SharedPhotoControllerDelegate?
    var recipe: Recipe? {
        didSet {
            guard let recipe = recipe else {
                return
            }
            
            imageView.sd_setImage(with: URL(string: recipe.imageURL))
            titleTextField.text = recipe.title
            accountTypeSegmentetControll.selectedSegmentIndex = Int(recipe.complexity) ?? 0
            ingredients = recipe.ingredients
            instructions = recipe.instructions
            time = recipe.time
            person = recipe.person
            
        }
    }
    let categoryView: SelectCategoryView = {
        let tv = SelectCategoryView()
        tv.alpha = 0
        tv.layer.cornerRadius = 20
        tv.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        tv.layer.borderWidth = 1
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()

    var isShowChangeTime = false
    var isShowPersonCounter = false
    var isShowCategory = false
    var time: String =  "10"
    var person : String = "2"
    var ingredients = [String]()
    var instructions = [String]()
    var seledtedImage: UIImage? {
        didSet {
            imageView.image = seledtedImage
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
        }
    }
  
    lazy var imageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "folder.fill.badge.plus")
        iv.heightAnchor.constraint(equalToConstant: 150).isActive = true
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleAddImage))
        iv.addGestureRecognizer(tap)
        iv.layer.borderWidth = 1
        iv.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor
        return iv
    }()
    let titleTextField : UITextView = {
        let tf = UITextView()
        tf.text = "Title"
        tf.font = .systemFont(ofSize: 14)
        return tf
    }()
    let timeView: TimePeopleController = {
        let tv = TimePeopleController()
        tv.view.layer.cornerRadius = 6
        tv.view.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor
        tv.view.layer.borderWidth = 1
        tv.view.alpha = 0
        return tv
    }()
    let personView: PersonsCounterController = {
        let tv = PersonsCounterController()
        tv.view.layer.cornerRadius = 6
        tv.view.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor
        tv.view.layer.borderWidth = 1
        tv.view.alpha = 0
        return tv
    }()
    lazy var timeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("10", for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleChangeTime), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }()
    lazy var personButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("2", for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handlePersonNumber), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }()
    let timeLabel : UILabel = {
        let label = UILabel()
        label.text = "Minutes"
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    let personLabel : UILabel = {
        let label = UILabel()
        label.text = "People"
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    let timeArray = ["10", "20",  "30", "40", "50", "60" ]
    let persons = ["2", "4", "6", "8"]
    lazy var ingredientsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ingredients", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .orange
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleIngredientts), for: .touchUpInside)
        return button
    }()
    lazy var instructionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Instruction", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .orange
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleInstruction), for: .touchUpInside)
        return button
    }()
    lazy var accountTypeSegmentetControll : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Easy", "Medium", "Hard"])
        sc.selectedSegmentIndex = 0
        return sc
    }()
    //add fild category
    lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Category", for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(handleShowCategory), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9411765933, green: 0.9411765337, blue: 0.9411765337, alpha: 1)
        navBarSetting()
        setupImageAndTextView()
        categoryView.delegate = self
        categoryView.dataSource = self
    }
    fileprivate func setupImageAndTextView() {
        let timeStack = UIStackView(arrangedSubviews: [
            timeButton,
            timeLabel
        ])
        timeStack.axis = .horizontal
        timeStack.distribution = .fillProportionally
        let peopleStack = UIStackView(arrangedSubviews: [
            personButton,
            personLabel
        ])
        peopleStack.axis = .horizontal
        peopleStack.distribution = .fillProportionally
     
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, botton: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBotton: 0, paddingRight: 0, width: 0)
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingLeft: 5, paddingRight: 5, height: 200)
        containerView.addSubview(categoryButton)
        categoryButton.anchor(top: imageView.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16, height: 50)
        
        containerView.addSubview(titleTextField)
        titleTextField.anchor(top: categoryButton.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16, height: 50)
        let buttonStuck = UIStackView(arrangedSubviews: [
            ingredientsButton,
            instructionButton
        ])
        buttonStuck.axis = .horizontal
        buttonStuck.distribution = .fillProportionally
        buttonStuck.spacing = 12
        containerView.addSubview(buttonStuck)
        buttonStuck.anchor(top: titleTextField.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16, height: 50)
        
        containerView.addSubview(accountTypeSegmentetControll)
        accountTypeSegmentetControll.anchor(top: buttonStuck.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16, height: 40)
        
      
                containerView.addSubview(timeStack)
        timeStack.anchor(top: accountTypeSegmentetControll.bottomAnchor, left: containerView.leftAnchor, paddingTop: 16, paddingLeft: 16, width: 100, height: 20)
        containerView.addSubview(peopleStack)
        containerView.addSubview(categoryView)
        categoryView.anchor(top: categoryButton.bottomAnchor, left: containerView.leftAnchor, botton: containerView.bottomAnchor, right: containerView.rightAnchor, paddingLeft: 40, paddingBotton: 40, paddingRight: 40)
        peopleStack.anchor(top: accountTypeSegmentetControll.bottomAnchor, right: containerView.rightAnchor, paddingTop: 16, paddingRight: 16, width: 90, height: 20)
                containerView.addSubview(timeView.view)
                timeView.view.anchor(top: timeStack.bottomAnchor, left: containerView.leftAnchor, botton: containerView.bottomAnchor, paddingLeft: 16, paddingBotton: 40, width: 120)
        containerView.addSubview(personView.view)
        personView.view.anchor(top: timeStack.bottomAnchor, left: peopleStack.leftAnchor, botton: containerView.bottomAnchor, paddingLeft: -20, paddingBotton: 40, width: 120)
    }
    fileprivate func navBarSetting() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cansel", style: .plain, target: self, action: #selector(handleCansel))
        navigationController?.navigationBar.tintColor = .black
    }
    //MARK: - selector
    @objc private func handleChangeTime() {
        isShowChangeTime.toggle()
        timeView.view.alpha = isShowChangeTime ? 1 : 0
        timeView.delegate = self
        timeView.timeArray = self.timeArray
        timeView.tableView.reloadData()
    }
    @objc private func handlePersonNumber() {
        isShowPersonCounter.toggle()
        personView.view.alpha = isShowPersonCounter
        ? 1 : 0
        personView.delegate = self
        personView.numberPersons = self.persons
        personView.tableView.reloadData()
    }
    @objc private func handleShowCategory() {
        isShowCategory.toggle()
        categoryView.alpha = isShowCategory ? 1 : 0
    }
    @objc fileprivate func handleCansel() {
        dismiss(animated: true)
    }
    @objc fileprivate func handleAddImage() {
        print("Add photo..")
        let imagePiker = UIImagePickerController()
        imagePiker.delegate = self
        self.present(imagePiker, animated: true)
    }
    @objc fileprivate func handleIngredientts() {
        titleTextField.isSelectable = false
        let controller = AddIngredientsController()
        if recipe != nil{
            controller.ingredients = ingredients
        }
        controller.delegate = self
        present(controller, animated: true)
    }
    @objc fileprivate func handleInstruction() {
        titleTextField.isSelectable = false
        let controller =  AddInstructionController()
        if recipe != nil{
            controller.instructions = instructions
        }
        controller.delegate = self
        present(controller, animated: true)
    }
    @objc fileprivate func handleShare() {
        guard instructions.count > 0 else { return }
        guard ingredients.count > 0 else { return }
        guard let image = imageView.image else { return }
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        let filename = NSUUID().uuidString
        
        Storage.storage().reference().child("recipes").child(filename).putData(uploadData, metadata: nil) { metadata, error in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                
                print("Failed, to uploadimage", error)
                return
            }
            Storage.storage().reference().child("recipes").child(filename).downloadURL { url, err in
                if let err =  err {
                    print("Failed, get url image", err)
                    return
                }
                guard let urlString = url?.absoluteString else { return }
                print("Successfully, upload image in db", urlString )
                self.delegate?.resetUsers()
                self.saveToDatabaseWithURLInfo(imageURL: urlString)
                self.dismiss(animated: true)
            }
        }
    }
    
    fileprivate func saveToDatabaseWithURLInfo(imageURL: String) {
        let acountTypeIndex = accountTypeSegmentetControll.selectedSegmentIndex
        let complexity = getAcountTypeIndex(acountTypeIndex: acountTypeIndex)
        if complexity == "" {
            return
        }
        guard let title = titleTextField.text , title.count > 0 else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userRecipeRef = Database.database().reference().child("recipes").child(uid)
        let ref = userRecipeRef.childByAutoId()
        let values = ["imageURL": imageURL, "title": title,  "time" : time, "person" : person, "complexity" : complexity, "creationDate": Date().timeIntervalSince1970, "ingredients": ingredients, "instructions": instructions, "category": categoryButton.title(for: .normal) ?? "Category"] as [String : Any]
        ref.updateChildValues(values) { (error, ref) in
            if let err = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed, save image to db", err)
                return
            }
            print("Successfully, save image to db")
            self.dismiss(animated: true)
            let name = NSNotification.Name("UpdateFeed")
            NotificationCenter.default.post(name: name, object: nil)
        }
    }
    //MARK: - helpers func
    fileprivate func getAcountTypeIndex(acountTypeIndex: Int) -> String {
        switch acountTypeIndex {
        case 0:
            return "Easy"
        case 1:
            return "Medium"
        case 2:
            return "Hard"
            
        default:
            break
        }
        return ""
    }
}


//MARK: - extension
extension SharedPhotoController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let editedImage = info[.editedImage] as? UIImage {
            imageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage
            
        }
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.gray.cgColor
        dismiss(animated: true)
    }
    
}
extension SharedPhotoController: AddIngredientsControllerDelegate {
    func addIngredient(ingredients: [String]) {
        self.ingredients = ingredients
        if self.ingredients.count > 0 {
            ingredientsButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            ingredientsButton.backgroundColor = .systemGreen
        } else {
            return
        }
    }
    
    
}

extension SharedPhotoController: AddInstructionControllerDelegate {
    func addInstruction(instructions: [String]) {
        self.instructions = instructions
        if self.instructions.count > 0 {
            instructionButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            instructionButton.backgroundColor = .systemGreen
        } else {
            return
        }
    }
    
    
    
    
}


//ext categoryView

extension SharedPhotoController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryView.categries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let category = categoryView.categries[indexPath.item]
            cell.textLabel?.text = category.rawValue
            cell.textLabel?.textAlignment = .center
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoryView.categries[indexPath.item]
        categoryButton.setTitle(category.rawValue, for: .normal)
        handleShowCategory()
    }
    
    
}


//ext timeView

extension SharedPhotoController: TimePeopleControllerDelegate {
    func didSelectTime(with time: String) {
        self.time = time
        timeButton.setTitle(time, for: .normal)
        handleChangeTime()
    }
}

//ext personView

extension SharedPhotoController: PersonsCounterControllerDelegate {
    func getNumberPerson(number: String) {
        self.person = number
        personButton.setTitle(number, for: .normal)
        handlePersonNumber()
    }
    
    
}
