//
//  HomeViewController.swift
//  flavrRecipes
//
//  Created by apple on 27.08.2022.
//

import UIKit
import Firebase


class HomeViewController: HomeCollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        searchView.delegate = self
        let namelike = NSNotification.Name("UpdateLike")
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeeed), name: namelike, object: nil)
        let name = NSNotification.Name("UpdateFeed")
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeeed), name: name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFollowButtonPressed), name: .follow, object: nil)
        collectionView.backgroundColor = .white
        setupSpiner()
        configureNavigationBar()
        handleRefresh()
        fetchUser()
        searchView.delegate = self
        setUITableViewForViewController()
     
    }
    deinit {
         NotificationCenter.default.removeObserver(self)
     }
    
    //MARK: - selector
    @objc func handleFollowButtonPressed() {
        collectionView.reloadData()
    }
    @objc func handleUpdateFeeed() {
        handleRefresh()
    }
    @objc private func handleSearchTapped() {
        behaviorSearch()
    }
    @objc private func handleNotificationTapped() {
        getAlert(title: "Alert", massage: "Notifications")
      
    }
    private func setupSpiner() {
        view.addSubview(recipeSpinner)
        recipeSpinner.centerX(inView: view)
        recipeSpinner.centerY(inView: view)
    }
    private func handleRefresh() {
        self.recipes.removeAll()
        recipeSpinner.startAnimating()
        fetchRecipes(with: nil)
        fetchFollowingUserId()
    }
    private func fetchRecipes(with id: String?) {
       if !NetWorkMonitor.shared.isConnected {
        getCustomAlert(title: "You have not wifi", massage: "Pleace, again leter now you have not wifi")
    }
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
                    self.recipeSpinner.stopAnimating()
                case .failure(let err):
                    self.getAlert(title: "Error!", massage: err.title)
                }

            }
        }
   }
    fileprivate func fetchUser() {
        FirebaseService.shared.fetchUsers { user in
            
            DispatchQueue.main.async {
                self.users.append(user)
            }
        }
    }
    private func fetchFollowingUserId() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return getAlert(title: "Error!", massage: "Not Id")}
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let userIdsDictionary = snapshot.value as? [ String : Any ] else { return }
            userIdsDictionary.forEach { (key, value) in
                Database.fetchUserWithUID(uid: key) { user in
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
        }
    }
//    var isFinishedPaging = false
//    var curentUser: User?
//    fileprivate func paginatePosts() {
//        print("Start paging for more posts")
//
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let ref = Database.database().reference().child("posts").child(uid)
//
////        let value = "-Kh0B6AleC8OgIF-mZNT"
////        let query = ref.queryOrderedByKey().queryStarting(atValue: value).queryLimited(toFirst: 6)
//
//        var query = ref.queryOrderedByKey()
//
//        if recipes.count > 0 {
//            let value = recipes.last?.id
//            query = query.queryStarting(atValue: value)
//        }
//
//        query.queryLimited(toFirst: 4).observeSingleEvent(of: .value, with: { (snapshot) in
//
//            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
//
//            if allObjects.count < 4 {
//                self.isFinishedPaging = true
//            }
//
//            if self.recipes.count > 0 {
//                allObjects.removeFirst()
//            }
//
//            FirebaseService.shared.fetchUse(uid: uid, completion: { curentUser in
//                self.curentUser = curentUser
//            })
//            guard let curentUser = self.curentUser else { return }
//
//            allObjects.forEach({ (snapshot) in
//
//                guard let dictionary = snapshot.value as? [String: Any] else { return }
//                var recipe = Recipe(user: curentUser, dictionary: dictionary)
//                recipe.id = snapshot.key
//
//                self.recipes.append(recipe)
//
////                print(snapshot.key)
//            })
//
//            self.recipes.forEach({ (recipe) in
//                print(recipe.id ?? "")
//            })
//
//            self.collectionView?.reloadData()
//
//
//        }) { (err) in
//            print("Failed to paginate for posts:", err)
//        }
//    }
    //MARK: - set ui
    
    private func configureNavigationBar(){
        navigationItem.title = "KetoRecipes".uppercased()
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
//        print("DEBAGG: ", indexPath.item )
//        if indexPath.item > 0{
//            fetchRecipes(with: recipes[indexPath.item].id)
//            print("DEBAG: ", recipes.last?.id ?? "nil")
//        }
//        print("DEBAG: ", recipes.count)
//        paginatePosts()
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
        guard let postId = recipe.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let value = [uid: recipe.hasLiked ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(value) { err, _ in
            if let err = err {
                print("Failed to like post", err)
            }
            recipe.hasLiked = !recipe.hasLiked
            self.recipes[indexPath.item] = recipe
            self.collectionView.reloadItems(at: [indexPath])
            let name = NSNotification.Name("UpdateLike")
            NotificationCenter.default.post(name: name, object: nil)
    }
        
//        print("DEBAG: ", recipe.hasLiked)
//        let likesValue = ["likesCount": recipe.likesCount]
//        guard let uid = recipe.id else { return }
//        Database.database().reference().child("recipes").child(recipe.user.uid).child(uid).updateChildValues(likesValue) {err, _ in
//            if let err = err {
//                print("Failed to like post", err)
//            }
////            recipe.likesCount += 1
////            if recipe.likesCount > 0 {
//                recipe.likesCount =  recipe.hasLiked == true ? recipe.likesCount + 1 : recipe.likesCount - 1
//                print("DEBAG: ", recipe.likesCount)
////            }
////            self.recipes.remove(at: indexPath.item)
////            self.recipes[indexPath.item] = recipe
////            self.collectionView.reloadItems(at: [indexPath])
////            print("DEBAG: ", recipe.likesCount)
////            let name = NSNotification.Name("UpdateLike")
////            NotificationCenter.default.post(name: name, object: nil)
//        }
    }
    
    
}



//MARK: - SearchViewDelegate
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
        handleRefresh()
        behaviorSearch()
    }
    
   
}


extension HomeViewController: HomeCollectionViewControllerDelegate {
    func uploadRecipes() {
        handleRefresh()
    }
    
    
}
