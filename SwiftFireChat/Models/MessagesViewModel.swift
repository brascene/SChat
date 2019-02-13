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
    func messagesRetrieved(messages: [MessageModel])
}

class MessageModel {
    var message: String = ""
    var fromID: String = ""
    var toID: String = ""
    var timestamp: Int = -1
    
    init(message: String, from: String, to: String, time: Int) {
        self.message = message
        self.fromID = from
        self.toID = to
        self.timestamp = time
    }
}

class MessagesViewModel {
    var delegate: MessagesViewModelOutput?
    var messages: [MessageModel] = []
    
    func checkUserLogged() {
        let userLogged = Auth.auth().currentUser?.uid != nil
        self.delegate?.checkedIfUserLogged(logged: userLogged)
    }
    
    func observeMessages() {
        Database.database().reference().child("messages").observe(.childAdded, with: { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                let msg = MessageModel(message: dict["text"] as! String, from: dict["fromId"] as! String, to: dict["toId"] as! String, time: dict["timestamp"] as! Int)
                self.messages.append(msg)
                self.delegate?.messagesRetrieved(messages: self.messages)
            }
        }, withCancel: nil)
    }
    
    func getNavigationTitle() {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot: DataSnapshot) in
                if let dict = snapshot.value as? [String: AnyObject] {
                    if let name = dict["name"] as? String, let email = dict["email"] as? String, let avatar = dict["user_image_url"] as? String {
                        let user = UserModel(name: name, email: email, avatar: avatar)
                        user.id = snapshot.key
                        self.delegate?.fetchedUserData(user: user)
                    }
                }
            }, withCancel: nil)
        }
    }
}
