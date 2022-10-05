//
//  FirebaseService.swift
//  flavrRecipes
//
//  Created by apple on 11.09.2022.
//

import UIKit
import Firebase

class FrirebaseService {
    static let shared = FrirebaseService()
    
    //MARK: - registration and login user
    func createUser(emailTextField: UITextField, passwordTextField: UITextField, youNameTextField: UITextField, completion: @escaping (Result<String, Error>) -> Void){
        guard let email = emailTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        guard let youName = youNameTextField.text else { return }
        if youName.count > 3 {
            Auth.auth().createUser(withEmail: email, password: password) { user, err in
                if let err = err {
                    print("Failed, err: \(err.localizedDescription)")
                }
                print("Successfull, created user", user?.user.uid ?? "nil")
                guard let uid = user?.user.uid else { return }
                let dictionaryValues = [ "username" : youName, "email" : email, "password" : password]
               let values = [uid : dictionaryValues]
               Database.database().reference().child("users").updateChildValues(values) { (err, ref) in
                   if let error = err {
                       print("Fain to save user info in db", error)
                       completion(.failure(error))
                       return
                   }
                print("Success..")
                   completion(.success("Success.."))
                 
            }
            
        }
    }
    }
    func login(emailTextField: UITextField, passwordTextField: UITextField, completion: @escaping (Result<String, Error>) -> Void) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else { return }
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let err = error {
                print("Failed, to sing in", err)
                completion(.failure(err))
                return
            }
            print("Successfully, logged user id: ", user?.user.uid ?? "")
            completion(.success("Success.."))
         
            
        }
    }
    
    //MARK: - fetch user
    

    func fetchUser(complition: @escaping (User) -> ()) {

      let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value) { snapshot in
           guard let dictionaries = snapshot.value as? [String: Any] else
            { return }
            dictionaries.forEach { (key, value) in
                if key == Auth.auth().currentUser?.uid {
                    return
                }
                guard let userDictionary = value as? [ String: Any ] else { return }
                let user = User(uid: key, dictionary: userDictionary)
//                self.users.append(user)
                complition(user)
            }

        } withCancel: { error in
            print("Failed fetch user", error)
        }


    }
     func fetchRecipeWithUser(user: User?, complition: @escaping (Recipe) -> ()) {
        guard let user = user else { return }
        let ref = Database.database().reference().child("recipes").child(user.uid)
         ref.observeSingleEvent(of: .value) { snapshot in
             guard let dictionaries = snapshot.value as? [String: Any] else { return }
             dictionaries.forEach { (key, value) in
                 guard let dictionary = value as? [String: Any] else { return }
                 let dummyUser = user

                 var recipe =  Recipe(user: dummyUser, dictionary: dictionary)
                 recipe.id = key
                 guard let uid = Auth.auth().currentUser?.uid else { return }
                 Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value) { snapshot in
                     if let value = snapshot.value as? Int, value == 1 {
                         recipe.hasLiked = true
                     } else {
                         recipe.hasLiked = false
                     }
                     complition(recipe)
//                     self.recipes.append(recipe)
//                     self.recipes.sort { p1, p2 in
//                         return p1.creationDate.compare(p2.creationDate) == .orderedDescending
//                     }
                    
                 } withCancel: { err in
                     print("Failed, to fetch like", err)
                 }
             }
             
    } withCancel: { err in
        print("Failed, user to posts", err)
    }
    }
}
