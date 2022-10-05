//
//  MyRecipesViewController.swift
//  flavrRecipes
//
//  Created by apple on 28.08.2022.
//

import UIKit
import Firebase


class MyRecipesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: - properties
    var recipes = [Recipe]()
    let emptyLabel : UILabel = {
       let label = UILabel()
        label.text = "ADD YOUR RECIPES"
        return label
    }()
    
    //MARK: - livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        collectionView.register(MyRecipe.self, forCellWithReuseIdentifier: MyRecipe.identifier)
        let name = NSNotification.Name("UpdateFeed")
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeeed), name: name, object: nil)
        let nameLike = NSNotification.Name("UpdateLike")
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeeed), name: nameLike, object: nil)
        fetchRecipes()
    }

    //MARK: - set ui
    private func configureNavBar() {
        navigationItem.title = "My Recipes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddRecipes))

        navigationController?.navigationBar.tintColor = .black
        
        collectionView.addSubview(emptyLabel)
        emptyLabel.centerY(inView: collectionView)
        emptyLabel.centerX(inView: collectionView)
    }
    
    //MARK: - helpers func
    private func fetchRecipes() {
       guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { user in
            FrirebaseService.shared.fetchRecipeWithUser(user: user) { recipe in
                self.recipes.append(recipe)
                self.recipes.sort { p1, p2 in
                    return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                }
                self.collectionView.reloadData()
            }
        }
   }


    // MARK: - Selector
    @objc private func handleUpdateFeeed() {
        self.recipes.removeAll()
        fetchRecipes()
    }
    @objc private func handleAddRecipes() {
        print("DEBAG: add object")
        let navController = UINavigationController(rootViewController: PhotoSelectorController(collectionViewLayout: UICollectionViewFlowLayout()))
        navController.modalPresentationStyle = .fullScreen

        self.present(navController, animated: true) {
            print("back..")
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if recipes.count > 0 {
            emptyLabel.isHidden = true
        } else {
            emptyLabel.isHidden = false
        }
        return recipes.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyRecipe.identifier, for: indexPath) as! MyRecipe
        cell.delegate = self
        cell.photoImage.image = UIImage(named: "MyDummyPhoto")
        let recipe = recipes[indexPath.item]
        cell.recipe = recipe
        cell.configureCell(with: recipe)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 232)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = DetaillViewController()
        controller.recipe = recipes[indexPath.row]
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
}

//MARK: - present Edit controller

extension MyRecipesViewController: MyRecipeDelegate {
    func addEdit(recipe: Recipe) {
        let controller = SharedPhotoController()
        controller.recipe = recipe
        present(controller, animated: true)
    }
    
   
    
    
}
