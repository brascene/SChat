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
    func avatarError(message: String)
}

class LoginViewModel {
    var email: String = ""
    var password: String = ""
    var name: String = ""
    var userImage: UIImage?
    
    var delegate: LoginViewModelOutput?
    
    var databaseRef = Database.database().reference()
    var storageRef = Storage.storage().reference()

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
        if let userImage = self.userImage {
            Auth.auth().createUser(withEmail: email, password: password) { (result: AuthDataResult?, error: Error?) in
                guard error == nil else {
                    self.delegate?.userCreated(status: false)
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                let imageName = NSUUID().uuidString
                let imageStorageRef = self.storageRef.child("user_images").child("\(imageName).png")
                
                if let imageData = userImage.pngData() {
                    imageStorageRef.putData(imageData, metadata: nil, completion: { (metadata: StorageMetadata?, erorr: Error?) in
                        guard error == nil else { return }
                        
                        imageStorageRef.downloadURL(completion: { (url: URL?, err: Error?) in
                            guard error == nil else { return }
                            
                            if let url = url {
                                let values: [String: Any] = ["name": self.name, "email": self.email, "user_image_url": url.absoluteString]
                                self.handleSaveUserToFirebase(values: values, uid: uid)
                            }
                        })
                    })
                }
            }
        } else {
            self.delegate?.avatarError(message: "Please select your image to proceed!")
        }
    }
    
    func handleSaveUserToFirebase(values: [String: Any], uid: String) {
        let userRef = databaseRef.child("users").child(uid)
        userRef.updateChildValues(values, withCompletionBlock: { (err: Error?, dataRef: DatabaseReference) in
            guard err == nil else {
                self.delegate?.updatedChildValues(status: false)
                return
            }
            self.delegate?.updatedChildValues(status: true)
        })
    }
}
