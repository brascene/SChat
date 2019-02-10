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
    func fetchedUserData(name: String?)
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
                    let name = dict["name"] as? String
                    self.delegate?.fetchedUserData(name: name)
                }
            }, withCancel: nil)
        }
    }
}
