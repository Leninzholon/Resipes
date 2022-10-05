//
//  HomeViewController.swift
//  flavrRecipes
//
//  Created by apple on 27.08.2022.
//

import UIKit
import Firebase


class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
//MARK: - Properties
    var isShow = false
    var users = [User]()
    var filterUser = [User]()
    var recipes = [Recipe]()
    lazy var searchView = SearchView()
    let tableView = UITableView()
    let searchStartLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Enter username"
       return label
    }()
    lazy var locationInputViewHeight : CGFloat = 140

//MARK: - lifecycle
    
    fileprivate func setUITableViewForViewController() {
        tableView.addSubview(searchStartLabel)
        searchStartLabel.centerY(inView: tableView)
        searchStartLabel.centerX(inView: tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let nameForLike = NSNotification.Name("UpdateFeedLike")
//        NotificationCenter.default.post(name: nameForLike, object: nil)
        let namelike = NSNotification.Name("UpdateLike")
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeeed), name: namelike, object: nil)
        let name = NSNotification.Name("UpdateFeed")
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeeed), name: name, object: nil)
        collectionView.backgroundColor = .white
        configureNavigationBar()
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.identifier)
        handleRefresh() 
        fetchUser()
        configureSearchView()
        
        searchView.delegate = self
        setUITableViewForViewController()
    }
    
    //MARK: - selector
   
    @objc func handleUpdateFeeed() {
        handleRefresh()
    }
    @objc private func handleSearchTapped() {
        print("DEBAG: handleSearchTapped")
        behaviorSearch()
    }
    @objc private func handleNotificationTapped() {
        print("DEBAG: handleNotificationTapped")
      
    }

    fileprivate func behaviorSearch() {
        isShow = !isShow
                self.configureTableView()
                self.tableView.frame.origin.y = self.locationInputViewHeight
                self.tableView.frame.origin.y = self.view.frame.height
                self.tableView.removeFromSuperview()
        if isShow == true{
            navigationController?.setNavigationBarHidden(true, animated: false)
        
        UIView.animate(withDuration: 0.3) {
            self.searchView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.configureTableView()
                self.tableView.frame.origin.y = self.locationInputViewHeight
            }
        }
        } else {
            navigationController?.setNavigationBarHidden(false, animated: false)
            UIView.animate(withDuration: 0.3) {
                self.searchView.alpha = 0
            } completion: { _ in
                UIView.animate(withDuration: 0.3) {
                    self.tableView.frame.origin.y = self.view.frame.height
                    self.tableView.removeFromSuperview()
                }
            }
        }
    }
    private func handleRefresh() {
        self.recipes.removeAll()
        fetchRecipes()
        fetchFollowingUserId()
    }
    fileprivate func configureSearchView() {
        view.addSubview(searchView)
        searchView.anchor(top: view.topAnchor, left: view.leftAnchor, botton: nil, right: view.rightAnchor, height: 140)
        searchView.alpha = 0
        searchView.delegate = self
    }
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        view.addSubview(tableView)
        tableView.frame = .init(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height - 150)
    }
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
    fileprivate func fetchUser() {
        FrirebaseService.shared.fetchUser { user in
            DispatchQueue.main.async {
                self.users.append(user)
            }
        }


    }
    
    private func fetchFollowingUserId() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let userIdsDictionary = snapshot.value as? [ String : Any ] else { return }
            userIdsDictionary.forEach { (key, value) in
                Database.fetchUserWithUID(uid: key) { user in
                    FrirebaseService.shared.fetchRecipeWithUser(user: user) { recipe in
                        self.recipes.append(recipe)
                        self.recipes.sort { p1, p2 in
                            return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                        }
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }

    //MARK: - set ui
    
    private func configureNavigationBar(){
        navigationItem.title = "KetoRecipes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSearchTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_notification")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleNotificationTapped))
    }
    
    //MARK: - set collection
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.identifier, for: indexPath) as! RecipeCell
        cell.delegate = self
        let resipe = recipes[indexPath.item]
        cell.configureCell(with: resipe)
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



extension HomeViewController: RecipeCellDelegate {
    func didLike(from cell: RecipeCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var recipe = self.recipes[indexPath.item]
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
            self.recipes[indexPath.item] = recipe
            self.collectionView.reloadItems(at: [indexPath])
            let name = NSNotification.Name("UpdateLike")
            NotificationCenter.default.post(name: name, object: nil)
    }
    }
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterUser.count > 0 {
            searchStartLabel.isHidden = true
        } else {
            searchStartLabel.isHidden = false
        }
        return filterUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as! SearchCell
        let user = filterUser[indexPath.row]
        cell.nameLabel.text = user.username
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchCell.height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userController = UserProfileController()
        let user = filterUser[indexPath.row]
        userController.user = user
        let navUserController = UINavigationController(rootViewController: userController)
        navUserController.modalPresentationStyle = .fullScreen
       present(navUserController, animated: true)
    }
}
extension HomeViewController: SearchViewDelegate {
    func searchText(searchText: String) {
        if searchText.isEmpty {
            filterUser = users
        } else {
            self.filterUser = self.users.filter({ user in

                return user.username.lowercased().contains(searchText.lowercased())

            })
        }
        self.tableView.reloadData()
    }
    
    func dismissSearchView() {
        behaviorSearch()
    }
    
   
}



