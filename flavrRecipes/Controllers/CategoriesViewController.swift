//
//  MyRecipesViewController.swift
//  flavrRecipes
//
//  Created by apple on 28.08.2022.
//

import UIKit
import Firebase

enum Categories : String, CaseIterable {
    case Appetizer
    case Breakfast = "Breakfast & Brunch"
    case Dessert
    case Beverages
    case MainDish = "Main Dish"
    case Pasta
    case Salad
    case Soup
    
    var image: UIImage? {
        switch self {
        case .Appetizer:
            return UIImage(named: "Appetizer")
        case .Breakfast:
           return  UIImage(named: "Breakfast & Brunch")
        case .Dessert:
            return UIImage(named: "Dessert")
        case .Beverages:
            return UIImage(named: "Beverages")
        case .MainDish:
            return UIImage(named: "Main Dish")
        case .Pasta:
            return UIImage(named: "Pasta")
        case .Salad:
            return UIImage(named: "Salad")
        case .Soup:
            return UIImage(named: "Soup")
        }
    }

    
}
class CategoriesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: - properties
    var recipes = [Recipe]()
    var filterCategories = [Categories]()
    var categories: [Categories] = Categories.allCases.map{ $0 }
//    var isSearch = true
    //MARK: - livecycle
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          navigationController?.setNavigationBarHidden(false, animated: animated)
      }

      override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          navigationController?.setNavigationBarHidden(true, animated: animated)
      }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        navigationItem.title = "Categoies".uppercased()
        navigationController?.navigationBar.tintColor = .black
        configureSearchController()
        fetchRecipes()
    }
    //MARK: - Private
    
    private func fetchRecipes() {
       guard let uid = Auth.auth().currentUser?.uid else { return getAlert(title: "Error!", massage: "Not user") }
        Database.fetchUserWithUID(uid: uid) { user in
            FirebaseService.shared.fetchRecipeWithUser(vc: self, user: user, paginationNumber: nil) { result in
                switch result {
                    
                case .success(let recipe):
                    self.recipes.append(recipe)
                    self.recipes.sort { p1, p2 in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    }
                    self.collectionView.reloadData()
                case .failure(let err):
                    self.getAlert(title: "Error!", massage: err.title)
                }

            }
        }
   }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        let category = categories[indexPath.item]
        cell.category = category
        return cell
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = CategoryDetaillController()
        let category = categories[indexPath.item]
        detailController.category = category
        let categoryRecipes = recipes.filter{$0.category == category.rawValue}
        detailController.recipes = categoryRecipes
        navigationController?.pushViewController(detailController, animated: true)
    }
    
}

//MARK: - present Edit controller

extension CategoriesViewController: MyRecipeDelegate {
    func addEdit(recipe: Recipe) {
        let controller = SharedPhotoController()
        controller.recipe = recipe
        present(controller, animated: true)
    }
    
   
    
    
}
//ext search controller
extension CategoriesViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        filterCategories = categories.filter{$0.rawValue.lowercased().contains(filter.lowercased())}
        categories = filterCategories
        collectionView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        categories = Categories.allCases.map{ $0 }
        collectionView.reloadData()
    }
}
