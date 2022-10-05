//
//  MainTabBar.swift
//  flavrRecipes
//
//  Created by apple on 26.08.2022.
//

import UIKit
import Firebase

class MainTabBar: UITabBarController, UITabBarControllerDelegate  {
    //MARK: - properties
    
    
    //MARK: livecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser == nil {
            //show if not logged in
            DispatchQueue.main.async {
                let startController = StartViewController()
                let navController = UINavigationController(rootViewController: startController)
                navController.modalPresentationStyle = .fullScreen

                self.present(navController, animated: true, completion: nil)

            }
            navigationController?.setNavigationBarHidden(true, animated: false)
            return
        }
        navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupViewControllers()
    }
    //MARK: - helpers  func
    
    func setupViewControllers() {
        //home
        let homeController = HomeViewController(collectionViewLayout: UICollectionViewFlowLayout())
        homeController.view.backgroundColor = .white
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "ic_home_orange"), selectedImage: #imageLiteral(resourceName: "ic_home_grey"), rootViewController: homeController)
        
        //search
        let categoriesViewController = MyRecipesViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let categoriesController = templateNavController(unselectedImage: #imageLiteral(resourceName: "ic_recipes_orange"), selectedImage: #imageLiteral(resourceName: "ic_recipes_grey"), rootViewController: categoriesViewController)
        
      
        
        //user profile
        let favoriteViewController = FavoritesController(collectionViewLayout: UICollectionViewFlowLayout())
        let favoriteController = templateNavController(unselectedImage: #imageLiteral(resourceName: "ic_favorites_orange"), selectedImage: #imageLiteral(resourceName: "ic_favorites_grey"), rootViewController: favoriteViewController)

        
        let userViewController = UserProfileController()
        let userController = templateNavController(unselectedImage: #imageLiteral(resourceName: "ic_profile_orange"), selectedImage: #imageLiteral(resourceName: "ic_profile_grey"), rootViewController: userViewController)
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = .orange
        
        viewControllers = [homeNavController,
                           categoriesController,
                           favoriteController,
                           userController]
        
        //modify tab bar item insets
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}
