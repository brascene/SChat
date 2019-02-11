//
//  NewMessageViewModel.swift
//  SwiftFireChat
//
//  Created by Dino Pelic on 2/10/19.
//  Copyright © 2019 Dino Pelic. All rights reserved.
//

import Foundation
import Firebase

class UserModel {
    var name: String = ""
    var email: String = ""
    var avatar_url: String = ""
    
    init(name: String, email: String, avatar: String) {
        self.name = name
        self.email = email
        self.avatar_url = avatar
    }
}

protocol NewMessageViewModelOutput {
    func usersRetrieved()
}

class NewMessageViewModel {
    var delegate: NewMessageViewModelOutput?
    var allUsers: [UserModel] = []
    
    func fetchAllUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                let user = UserModel(name: dict["name"] as! String, email: dict["email"] as! String, avatar: dict["user_image_url"] as! String)
                self.allUsers.append(user)
                self.delegate?.usersRetrieved()
            }
        }, withCancel: nil)
    }
}
