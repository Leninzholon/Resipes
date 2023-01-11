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
    var filterCategories = [Recipe]()
    var favorites = [Recipe]()
    let recipeSpinner: UIActivityIndicatorView = {
        let activitiIndicator = UIActivityIndicatorView(style: .large)
        activitiIndicator.color = .black
        return activitiIndicator
    }()
    //MARK: - Livecycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .secondarySystemBackground
        let name = NSNotification.Name("UpdateLike")
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeeed), name: name, object: nil)
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.identifier)
        setupSpiner() 
        fetchFaworiteRecipes()
        configureNavigationBar()
        configureSearchController()
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.identifier, for: indexPath) as! FavoriteCell
        cell.delegate = self
        let recipe = favorites[indexPath.item]
        cell.recipe = recipe
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = DetaillViewController()
        controller.recipe = favorites[indexPath.row]
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.width / 2 - 5, height: 232)
    }
    
    //MARK: Firebase
    func fetchFaworiteRecipes() {
        recipeSpinner.startAnimating()
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let dictionaries = snapshot.value as? [String : Any] else { return }
            dictionaries.forEach { key, value in

                guard let dictionary = value as? [String : Any] else { return }
                
                let user = User(uid: key, dictionary: dictionary)
                DispatchQueue.main.async {
                    FirebaseService.shared.fetchRecipeWithUser(vc: self, user: user, paginationNumber: nil) { result in
                        switch result {
                            
                        case .success(let recipe):
                            if recipe.hasLiked == true {
                                               self.favorites.append(recipe)
                                                }
                            self.collectionView.reloadData()
                            self.recipeSpinner.stopAnimating()
                        case .failure(let err):
                            self.getAlert(title: "Error!", massage: err.title)
                        }

                        
                    }
                }
            }
        }
   }
        //MARK: - private func
    private func setupSpiner() {
        view.addSubview(recipeSpinner)
        recipeSpinner.centerX(inView: view)
        recipeSpinner.centerY(inView: view)
    }
    private func configureNavigationBar() {
        navigationItem.title = "Favorites".uppercased()
        navigationController?.navigationBar.tintColor = .black
    }
    private func configureSearchController() {
        navigationItem.hidesSearchBarWhenScrolling = false
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search category"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    //MARK: - selector
    
    @objc private func handleUpdateFeeed() {
        self.favorites.removeAll()
        fetchFaworiteRecipes()
        
    }
}

//MARK: Ext delegate
extension FavoritesController: FavoriteCellDelegate {
    func didLike(from cell: FavoriteCell) {
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

//ext search controller
extension FavoritesController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        filterCategories = favorites.filter{$0.title.lowercased().contains(filter.lowercased())}
        favorites = filterCategories
        collectionView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        handleUpdateFeeed()
        collectionView.reloadData()
    }
}
