//
//  FirebaseService.swift
//  flavrRecipes
//
//  Created by apple on 11.09.2022.
//

import UIKit
import Firebase

class FirebaseService {
    static let shared = FirebaseService()
    enum AuthError: Error {
        case bedLoginOrPass
        case bedSaveUser
        case bedCreateUser
    }
    enum NetworkError: Error {
        case networkProblem
        
        var title: String {
            switch self {
                
            case .networkProblem:
                return "Networking problem, try agen.. "
            }
        }
    }

    //MARK: - registration and login user
    func createUser(emailTextField: UITextField, passwordTextField: UITextField, youNameTextField: UITextField, completion: @escaping (Result<String, AuthError>) -> Void){
        guard let email = emailTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        guard let youName = youNameTextField.text else { return }
        guard youName.count < 6 else {
            completion(.failure(AuthError.bedLoginOrPass))
            return
        }
            
            Auth.auth().createUser(withEmail: email, password: password) { user, err in
        if let err = err {
                    print("Failed, err: \(err.localizedDescription)")
            completion(.failure(AuthError.bedCreateUser))
                }
                guard let uid = user?.user.uid else { return }
                let dictionaryValues = [ "username" : youName, "email" : email, "password" : password]
               let values = [uid : dictionaryValues]
               Database.database().reference().child("users").updateChildValues(values) { (err, ref) in
                   if let error = err {
                       print("Fain to save user info in db", error)
                       completion(.failure(AuthError.bedSaveUser))
                       return
                   } else {
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
    func SingOut(selfVC: ProfileViewController) {
        do {
            try  Auth.auth().signOut()
            let vc = StartViewController()
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            selfVC.present(navVC, animated: true)
            print("Success")
        } catch let err {
            print(err.localizedDescription)
        }
    }
    //MARK: - fetch user
    var currentUid: String? {
        return Auth.auth().currentUser?.uid
    }
     func fetchUse(uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
            
        }) { (err) in
            print("Failed to fetch user for posts:", err)
        }
    }
    func fetchUsers(complition: @escaping (User) -> ()) {

      let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value) { snapshot in
           guard let dictionaries = snapshot.value as? [String: Any] else
            {
               return
               
           }
            dictionaries.forEach { (key, value) in
                if key == Auth.auth().currentUser?.uid {
                    return
                }
                guard let userDictionary = value as? [ String: Any ] else {
                    return
                    
                }
                let user = User(uid: key, dictionary: userDictionary)
                complition(user)
            }

        } withCancel: { error in
            
            print("Failed fetch user", error)
        }


    }
    func fetchRecipeWithUser(vc: UIViewController?, user: User?, paginationNumber: String?, recipesLast: Recipe? = nil, complition: @escaping (Result<Recipe, NetworkError>) -> ()) {
        guard let user = user else {
            let alert = UIAlertController(title: "Error!", message: "Not user", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            guard let vc = vc else { return }
            vc.present(alert, animated: true)
            return }

        let ref = Database.database().reference().child("recipes").child(user.uid)
        
//        var query = ref.queryOrderedByKey()
        
//        if let recipesLast = recipesLast {
//            let value = recipesLast.id
//            query = query.queryStarting(atValue: value)
//        }
        ref.observeSingleEvent(of: .value) { snapshot in
//            let allObjectts = snapshot.children.allObjects  as? [DataSnapshot]
//            allObjectts?.forEach{ snapshot in
//                guard let dictionary = snapshot.value as? [String: Any] else { return }
//                let recipe = Recipe(user: user, dictionary: dictionary)
//                print("DEBAG: ",snapshot.key)
//            }
             guard let dictionaries = snapshot.value as? [String: Any] else { return }
             dictionaries.forEach { (key, value) in
                 guard let dictionary = value as? [String: Any] else { return }
                 let dummyUser = user
                 var recipe =  Recipe(user: dummyUser, dictionary: dictionary)
                 recipe.id = key
                 guard let uid = Auth.auth().currentUser?.uid else { return complition(.failure(NetworkError.networkProblem))}
                 Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value) { snapshot in
                     if let value = snapshot.value as? Int, value == 1 {
                         recipe.hasLiked = true
                     } else {
                         recipe.hasLiked = false
                     }
                     complition(.success(recipe))
                 } withCancel: { err in
                     complition(.failure(NetworkError.networkProblem))
                     print("Failed, to fetch like", err)
                 }
             }
             
    } withCancel: { err in
        print("Failed, user to posts", err)
    }
    }
    func countFolloving(completion: @escaping (Int?) -> ()) {
        guard let currentUid = self.currentUid else  { return }
        let ref = Database.database().reference().child("following").child(currentUid)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else {  return completion(nil) }
            completion(dictionaries.count)
        }
    }
    func countResipes(completion: @escaping (Int?) -> ()) {
        guard let currentUid = self.currentUid else  { return }
        let ref = Database.database().reference().child("recipes").child(currentUid)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else { return  completion(nil)}
            print("Resipes-------------", dictionaries.count)
            completion(dictionaries.count)
        }
    }
    func countFollowers(completion: @escaping (Int?) -> ()) {
        let ref = Database.database().reference().child("following")
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else { return completion(nil) }
            var counter: Int = 0
            dictionaries.forEach { key, value in
                guard let value = value as? [String: Any] else { return }
                        value.forEach { key, value in
                            if key == self.currentUid {
                                counter += 1
                            }
                        }
            }
            completion(counter)
        }
    }
     func fetchRecipes(comletion: @escaping (Recipe) -> Void) {
       guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { user in
            self.fetchRecipeWithUser(vc: nil, user: user, paginationNumber: nil) { result in
                switch result {
                case .success(let recipe):
                    comletion(recipe)                    
                case .failure(let err):
//                    UIViewController.getAlert(title: "Error!", massage: err.title)
                    print("Error: ", err)
                }

            }
        }
   }
    func fetchFollowingUserId(completion: @escaping (Recipe) -> Void) {
       guard let uid = FirebaseService.shared.currentUid else {
           return }
       Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value) { snapshot  in
           guard let userIdsDictionary = snapshot.value as? [ String : Any ] else { return }
           userIdsDictionary.forEach { (key, value) in
               Database.fetchUserWithUID(uid: key) { user in
                   FirebaseService.shared.fetchRecipeWithUser(vc: nil, user: user, paginationNumber: nil) { result in
                       switch result {
                           
                       case .success(let recipe):
                           completion(recipe)
                       case .failure(let err):
//                           self?.getAlert(title: "Error!", massage: err.title)
                           print("Error: ", err)
                       }
                   }
               }
           }
       }
   }
}
