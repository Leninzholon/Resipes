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

class SharedPhotoController: UIViewController {
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
   
    let imageView : UIImageView = {
      let iv = UIImageView()
        iv.image = UIImage(named: "DummyPhoto")
        iv.heightAnchor.constraint(equalToConstant: 150).isActive = true

        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    let titleTextField : UITextView = {
       let tf = UITextView()
        tf.text = "Title"
        tf.font = .systemFont(ofSize: 14)

        return tf
    }()
 
    let pikerLabel : UILabel = {
       let label = UILabel()
        label.text = "Minutes"
        label.textAlignment = .center
        return label
    }()
    let personLabel : UILabel = {
       let label = UILabel()
        label.text = "People"
        label.textAlignment = .center
        return label
    }()
    let timeArray = ["10", "20",  "30", "40", "50", "60" ]
    let persons = ["2", "4", "6", "8"]
    lazy var timePiker : UIPickerView = {
        let piker = UIPickerView()
        return piker
    }()
    let ingredientsButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Ingredients", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .orange
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleIngredientts), for: .touchUpInside)
        return button
    }()
    let instructionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Instruction", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .orange
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleInstruction), for: .touchUpInside)
        return button
    }()
    lazy var personPiker : UIPickerView = {
        let piker = UIPickerView()
        return piker
    }()
    lazy var accountTypeSegmentetControll : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Easy", "Medium", "Hard"])
        sc.selectedSegmentIndex = 0
        return sc
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9411765933, green: 0.9411765337, blue: 0.9411765337, alpha: 1)
        navBarSetting()
        setupImageAndTextView()
        timePiker.delegate = self
        timePiker.dataSource = self
        personPiker.delegate = self
        personPiker.dataSource = self
        guard let uid = Auth.auth().currentUser?.uid else { return }
        

    }
    fileprivate func setupImageAndTextView() {
     
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, botton: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBotton: 0, paddingRight: 0, width: 0)
        containerView.addSubview(imageView)
        
        
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, height: 200)
        containerView.addSubview(titleTextField)
        titleTextField.anchor(top: imageView.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16, height: 50)

        
        let buttonStuck = UIStackView(arrangedSubviews: [
        ingredientsButton,
        instructionButton
        ])
        buttonStuck.axis = .horizontal
        buttonStuck.distribution = .fillProportionally
        buttonStuck.spacing = 12
        containerView.addSubview(buttonStuck)
        buttonStuck.anchor(top: titleTextField.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16, height: 50)
        containerView.addSubview(timePiker)
        timePiker.anchor(top: buttonStuck.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 10, width: 50, height: 50)
        timePiker.centerX(inView: containerView)
                containerView.addSubview(pikerLabel)
                pikerLabel.anchor(top: timePiker.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingRight: 16, height: 20)
        containerView.addSubview(personPiker)
        personPiker.anchor(top: pikerLabel.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 10, width: 50, height: 50)
        containerView.addSubview(personLabel)
        personLabel.anchor(top: personPiker.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingRight: 16, height: 20)
        containerView.addSubview(accountTypeSegmentetControll)
        accountTypeSegmentetControll.anchor(top: personLabel.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16, height: 40)

    }
    fileprivate func navBarSetting() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
    }
//MARK: - selector
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
        guard let image = seledtedImage else { return }
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
                self.saveToDatabaseWithURLInfo(imageURL: urlString)
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
        let values = ["imageURL": imageURL, "title": title,  "time" : time, "person" : person, "complexity" : complexity, "creationDate": Date().timeIntervalSince1970, "ingredients": ingredients, "instructions": instructions] as [String : Any]
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



extension SharedPhotoController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == timePiker {
           return timeArray.count
        } else {
           return persons.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == timePiker {
       time = timeArray[row]
        } else {
        person = persons[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == timePiker {
        return  timeArray[row]
        } else {
            return persons[row]
        }
    }
 
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }

   


}


extension SharedPhotoController: AddIngredientsControllerDelegate {
    func addIngredient(ingredients: [String]) {
        self.ingredients = ingredients
        if self.ingredients.count > 0 {
            ingredientsButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            ingredientsButton.backgroundColor = .green
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
            instructionButton.backgroundColor = .green
        } else {
            return
        }
    }
    
    
    
    
}
