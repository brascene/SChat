//
//  MessagesViewModel.swift
//  SwiftFireChat
//
//  Created by Dino Pelic on 2/10/19.
//  Copyright © 2019 Dino Pelic. All rights reserved.
//

import Foundation
import Firebase

protocol MessagesViewModelOutput {
    func checkedIfUserLogged(logged: Bool)
    func fetchedUserData(user: UserModel?)
}

class MessagesViewModel {
    var delegate: MessagesViewModelOutput?
    
    func checkUserLogged() {
        let userLogged = Auth.auth().currentUser?.uid != nil
        self.delegate?.checkedIfUserLogged(logged: userLogged)
    }
    
    func getNavigationTitle() {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot: DataSnapshot) in
                if let dict = snapshot.value as? [String: AnyObject] {
                    if let name = dict["name"] as? String, let email = dict["email"] as? String, let avatar = dict["user_image_url"] as? String {
                        let user = UserModel(name: name, email: email, avatar: avatar)
                        self.delegate?.fetchedUserData(user: user)
                    }
                }
            }, withCancel: nil)
        }
    }
}
