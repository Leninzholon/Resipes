//
//  Recipes.swift
//  flavrRecipes
//
//  Created by apple on 28.08.2022.
//

import UIKit


struct Recipe {
    var id: String?
    let user: User
    let imageURL : String
    let title : String
    let time : String
    let person : String
    let complexity: String
    let ingredients: [String]
    let instructions: [String]
    let creationDate : Date
    var hasLiked = false
    init(user: User, dictionary: [String : Any]) {
        self.user = user
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.time = dictionary["time"] as? String ?? ""
        self.person = dictionary["person"] as? String ?? ""
        self.complexity = dictionary["complexity"] as? String ?? ""
        self.ingredients = dictionary["ingredients"] as? [String] ?? ["",]
        self.instructions =  dictionary["instructions"] as? [String] ?? ["", ]
        let secondsForm1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsForm1970)
    }
}
