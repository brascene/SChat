//
//  LoginViewModel.swift
//  SwiftFireChat
//
//  Created by Dino Pelic on 2/8/19.
//  Copyright © 2019 Dino Pelic. All rights reserved.
//

import Foundation
import Firebase

protocol LoginViewModelOutput {
    func userCreated(status: Bool)
    func updatedChildValues(status: Bool)
    func loginFinishedWith(status: Bool)
}

class LoginViewModel {
    var email: String = ""
    var password: String = ""
    var name: String = ""
    
    var delegate: LoginViewModelOutput?
    
    func setFormValues(email: String, password: String, name: String) {
        self.email = email
        self.password = password
        self.name = name
    }
    
    func handleLogin() {
        Auth.auth().signIn(withEmail: email, password: password) { (authRes: AuthDataResult?, error: Error?) in
            guard error == nil else {
                self.delegate?.loginFinishedWith(status: false)
                return
            }
            self.delegate?.loginFinishedWith(status: true)
        }
    }
    
    func handleRegister() {
        Auth.auth().createUser(withEmail: email, password: password) { (result: AuthDataResult?, error: Error?) in
            guard error == nil else {
                self.delegate?.userCreated(status: false)
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let ref = Database.database().reference()
            let userRef = ref.child("users").child(uid)
            
            let values: [String: Any] = ["name": self.name, "email": self.email]
            
            userRef.updateChildValues(values, withCompletionBlock: { (err: Error?, dataRef: DatabaseReference) in
                guard err == nil else {
                    self.delegate?.updatedChildValues(status: false)
                    return
                }
                self.delegate?.updatedChildValues(status: true)
            })
        }
    }
}
