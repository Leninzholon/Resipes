//
//  CategoryDetaillController.swift
//  flavrRecipes
//
//  Created by apple on 01.01.2023.
//

import UIKit

class CategoryDetaillController: UIViewController {
    //MARK: - Properties
    var recipes: [Recipe]? {
        didSet{
            guard let recipes = recipes else { return }
            counterOfRecipeLabel.text = "\(recipes.count) Recipes"
        }
    }
    var category: Categories? {
        didSet {
            guard let category = category else { return }
            categoryImage.image = category.image
            titleCategoryLabel.text = category.rawValue
           
        }
    }
    var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(DetaillCategoryCell.self, forCellWithReuseIdentifier: DetaillCategoryCell.identifier)
        return collection
    }()
    let categoryImage: UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .systemPink
        return iv
    }()
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category".uppercased()
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    let counterOfRecipeLabel: UILabel = {
       let label = UILabel()
        label.text = "418 Recipes"
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    let titleCategoryLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    lazy var beckButton: UIButton = {
       let button = UIButton()
        button.setBackgroundImage(UIImage(named: "ic_arrow_back_white"), for: .normal)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    let searchButton: UIButton = {
       let button = UIButton()
        button.setBackgroundImage(UIImage(named: "ic_notification 1"), for: .normal)
        return button
    }()
    //MARK: - live cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupUI()
        
    }
    //MARK: - pivate
    //ui
    private func setupUI() {
        view.backgroundColor = .white
        setupHeaderUI()
        let headerStack = UIStackView(arrangedSubviews: [
        categoryLabel,
        titleCategoryLabel,
        counterOfRecipeLabel
        ])
        headerStack.axis = .vertical
        headerStack.spacing = 10
        view.addSubview(headerStack)
        headerStack.anchor(top: categoryImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16)
        view.addSubview(collectionView)
        collectionView.anchor(top: headerStack.bottomAnchor, left: view.leftAnchor, botton: view.bottomAnchor, right: view.rightAnchor)
    }
    private func setupHeaderUI() {
        view.addSubview(categoryImage)
        categoryImage.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 200)
        view.addSubview(beckButton)
        beckButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 30, paddingLeft: 20, width: 30, height: 30)
        view.addSubview(searchButton)
        searchButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 30, paddingRight: 20, width: 30, height: 30)
    }
    
    //selector

    @objc private func handleBack() {
        print("Back..")
        navigationController?.popToRootViewController(animated: true)
    }
}


//MARK: - ext uicollectionView

extension CategoryDetaillController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetaillCategoryCell.identifier, for: indexPath) as? DetaillCategoryCell else { return UICollectionViewCell() }
        if let recipes = recipes {
            let recipe = recipes[indexPath.item]
            cell.recipe = recipe
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.width
        return .init(width: size, height: 200)
    }
    
}
