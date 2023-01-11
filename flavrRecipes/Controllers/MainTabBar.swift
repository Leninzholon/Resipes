//
//  MainTabBar.swift
//  flavrRecipes
//
//  Created by apple on 26.08.2022.
//

import UIKit
import Firebase


class MainTabBar: UITabBarController  {
    //MARK: - properties
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "plus.app.fill"), for: .normal)
        button.tintColor = .systemGray
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        
        return button
    }()
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
        checkInternet()
        self.delegate = self
        setupViewControllers()
        addButton.addTarget(self, action: #selector(handleAddRecipe), for: .touchUpInside)
        view.addSubview(addButton)
        addButton.bringSubviewToFront(tabBar)
        addButton.anchor(botton: tabBar.topAnchor, paddingBotton: -40, width: 60, height: 60)
        addButton.centerX(inView: view)
       
    }
    //MARK: - helpers  func
    func checkInternet() {
        if !NetWorkMonitor.shared.isConnected {
            getCustomAlert(title: "You have not internet", massage: "Pleace, again leter now you have not internet🙃")
        }
    }
    func setupViewControllers() {
        //home
        let homeController = HomeViewController(collectionViewLayout: UICollectionViewFlowLayout())
        homeController.view.backgroundColor = .white
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "ic_home_orange"), selectedImage: #imageLiteral(resourceName: "ic_home_grey"), rootViewController: homeController)
        
        //search
        let categoriesViewController = CategoriesViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let categoriesController = templateNavController(unselectedImage: #imageLiteral(resourceName: "ic_recipes_orange"), selectedImage: #imageLiteral(resourceName: "ic_recipes_grey"), rootViewController: categoriesViewController)
        
        let addController = HomeViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: addController)
        navController.tabBarItem.image = nil
        navController.tabBarItem.selectedImage = nil
      let addRecipeViewController = PhotoSelectorController(collectionViewLayout: UICollectionViewFlowLayout())
        
        
        //user profile
        let favoriteViewController = FavoritesController(collectionViewLayout: UICollectionViewFlowLayout())
        let favoriteController = templateNavController(unselectedImage: #imageLiteral(resourceName: "ic_favorites_orange"), selectedImage: #imageLiteral(resourceName: "ic_favorites_grey"), rootViewController: favoriteViewController)

        
        let userViewController = UserProfileController()
        let userController = templateNavController(unselectedImage: #imageLiteral(resourceName: "ic_profile_orange"), selectedImage: #imageLiteral(resourceName: "ic_profile_grey"), rootViewController: userViewController)
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = .orange
        
        viewControllers = [homeNavController,
                           categoriesController,
                           navController,
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
    //MARK: - selector func
    
    @objc private func handleAddRecipe() {
        let navPhotoController = UINavigationController(rootViewController: SharedPhotoController())
        navPhotoController.modalPresentationStyle = .fullScreen
        self.present(navPhotoController, animated: true)
    }
}


extension MainTabBar: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewControllers?.firstIndex(of: viewController) == 0{
            viewDidLoad()
        }
        else if viewControllers?.firstIndex(of: viewController) == 1{
            viewDidLoad()
        }
        else if viewControllers?.firstIndex(of: viewController) == 2{
            viewDidLoad()
        }
        else if viewControllers?.firstIndex(of: viewController) == 3{
            viewDidLoad()
        }
        else if viewControllers?.firstIndex(of: viewController) == 4{
            viewDidLoad()
        }
    }
}


