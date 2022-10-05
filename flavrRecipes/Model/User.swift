//
//  User.swift
//  flavrRecipes
//
//  Created by apple on 26.08.2022.
//

import Foundation

struct User{
    let username: String
    let email: String
    let uid: String
    let photoUrl: String
    init(uid: String, dictionary: [String: Any]){
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.photoUrl = dictionary["photoUrl"] as? String ?? ""
        
    }


}
