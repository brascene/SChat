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
    func messagesRetrieved()
}

class MessageModel {
    var message: String = ""
    var fromID: String = ""
    var toID: String = ""
    var timestamp: Int = -1
    
    var toUserAvatarURL: String?
    
    init(message: String, from: String, to: String, time: Int) {
        self.message = message
        self.fromID = from
        self.toID = to
        self.timestamp = time
    }
    
    func getAvatar(for userId: String, successClosure: @escaping (Bool) -> Void) {
        Database.database().reference().child("users").child(userId).observe(.value, with: { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? [String: AnyObject] {
                let avatar_url = data["user_image_url"] as! String
                self.toUserAvatarURL = avatar_url
                successClosure(true)
            }
        }, withCancel: nil)
    }
}

class MessagesViewModel {
    var delegate: MessagesViewModelOutput?
    var groupedMessages: Dictionary<String, MessageModel> = [:]
    
    var messages: [MessageModel] = []
    
    func checkUserLogged() {
        let userLogged = Auth.auth().currentUser?.uid != nil
        self.delegate?.checkedIfUserLogged(logged: userLogged)
    }
    
    func observeMessages() {
        Database.database().reference().child("messages").observe(.childAdded, with: { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                let msg = MessageModel(message: dict["text"] as! String, from: dict["fromId"] as! String, to: dict["toId"] as! String, time: dict["timestamp"] as! Int)
                self.groupedMessages[msg.toID] = msg
                self.messages = Array(self.groupedMessages.values).sorted(by: { (m1, m2) -> Bool in
                    return m1.timestamp > m2.timestamp
                })
                msg.getAvatar(for: dict["toId"] as! String) { [unowned self] success in
                    if (success) {
                        self.delegate?.messagesRetrieved()
                    }
                }
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
