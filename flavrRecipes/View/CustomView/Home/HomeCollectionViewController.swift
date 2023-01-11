//
//  HomeCollectionViewController.swift
//  flavrRecipes
//
//  Created by apple on 22.12.2022.
//

import UIKit
import Firebase


private let reuseIdentifier = "Cell"

protocol HomeCollectionViewControllerDelegate: AnyObject {
    func uploadRecipes()
}

class HomeCollectionViewController: UICollectionViewController {
    //MARK: - Properties
    weak var delegate: HomeCollectionViewControllerDelegate?
    var users = [User]()
    var filterUser = [User]()
    var recipes = [Recipe]()
    var isShow = false
    lazy var locationInputViewHeight : CGFloat = 140
    lazy var searchView = SearchView()
    let tableView = UITableView()
    let recipeSpinner: UIActivityIndicatorView = {
        let activitiIndicator = UIActivityIndicatorView(style: .large)
        activitiIndicator.color = .black
        return activitiIndicator
    }()
    let searchStartLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Enter username"
       return label
    }()
    let topRecipeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Top recipes", for: .normal)
        return button
    }()
    let followRecipeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Following recipes", for: .normal)
        return button
    }()
    //MARK: - livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.identifier)
        configureSearchView()
    }
    
     func setUITableViewForViewController() {
        tableView.addSubview(searchStartLabel)
        searchStartLabel.centerY(inView: tableView)
        searchStartLabel.centerX(inView: tableView)
    }

     func configureSearchView() {
        view.addSubview(searchView)
        searchView.anchor(top: view.topAnchor, left: view.leftAnchor, botton: nil, right: view.rightAnchor, height: 140)
        searchView.alpha = 0
    }
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        view.addSubview(tableView)
        tableView.frame = .init(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height - 150)
    }
  
     func behaviorSearch() {
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

}
//MARK:  - ext uitableview
extension HomeCollectionViewController: UITableViewDelegate, UITableViewDataSource {
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
        let userController = FollowViewController()
        userController.delegate = self
        let user = filterUser[indexPath.row]
        userController.uid = user.uid
        let navUserController = UINavigationController(rootViewController: userController)
        navUserController.modalPresentationStyle = .fullScreen
       present(navUserController, animated: true)
    }
}

extension HomeCollectionViewController: FollowViewControllerDelegate  {
    
    func didClose() {
        behaviorSearch()
        delegate?.uploadRecipes()
    }
    
    
}

