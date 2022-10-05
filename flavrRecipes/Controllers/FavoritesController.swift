//
//  FavoritesController.swift
//  flavrRecipes
//
//  Created by apple on 01.09.2022.
//

import UIKit
import Firebase

class FavoritesController : UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    //MARK: - Porerties
    var favorites = [Recipe]()
    //MARK: - Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        let nameForLike = NSNotification.Name("UpdateFeedLike")
//        NotificationCenter.default.post(name: nameForLike, object: nil)
        let name = NSNotification.Name("UpdateLike")
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeeed), name: name, object: nil)
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.identifier)
        fetchFaworiteRecipes()
        navigationItem.title = "Favorites"
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.identifier, for: indexPath) as! RecipeCell
        cell.delegate = self
        let favorite = favorites[indexPath.item]
        cell.configureCell(with: favorite)
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = DetaillViewController()
        controller.recipe = favorites[indexPath.row]
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 232)
    }
    
    //MARK: Firebase
    func fetchFaworiteRecipes() {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let dictionaries = snapshot.value as? [String : Any] else { return }
            dictionaries.forEach { key, value in

                guard let dictionary = value as? [String : Any] else { return }
                
                let user = User(uid: key, dictionary: dictionary)
                DispatchQueue.main.async {
                    FrirebaseService.shared.fetchRecipeWithUser(user: user) { recipe in
                        if recipe.hasLiked == true {
                                           self.favorites.append(recipe)
                                            }
                        self.collectionView.reloadData()
                    }
                }
            }
        }
   }

    //MARK: - selector
    
    
    @objc private func handleUpdateFeeed() {
        self.favorites.removeAll()
        fetchFaworiteRecipes()
        
    }
}

extension FavoritesController: RecipeCellDelegate {
    func didLike(from cell: RecipeCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var recipe = self.favorites[indexPath.item]
        print(recipe.title)
        guard let postId = recipe.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let value = [uid: recipe.hasLiked ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(value) { err, _ in
            if let err = err {
                print("Failed to like post", err)
            }
            print("Successfully, liked post")
            
            recipe.hasLiked = !recipe.hasLiked
            self.favorites[indexPath.item] = recipe
            let name = NSNotification.Name("UpdateLike")
            NotificationCenter.default.post(name: name, object: nil)
            self.collectionView.reloadItems(at: [indexPath])
          
    }
    }
    
    
}
