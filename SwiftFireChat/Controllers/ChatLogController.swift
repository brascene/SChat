//
//  ChatLogController.swift
//  SwiftFireChat
//
//  Created by Dino Pelic on 2/12/19.
//  Copyright © 2019 Dino Pelic. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController {
    var currentKeyboardHeight: CGFloat = 0
    var containerViewBottomAnchor: NSLayoutConstraint?
    var user: UserModel? {
        didSet {
            navigationItem.title = user!.name
        }
    }
    
    lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter message..."
        tf.delegate = self
        return tf
    }()
    
    var containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.isUserInteractionEnabled = true
        setupTextInputComponents()
        observeKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func setupTextInputComponents() {
        self.view.addSubview(containerView)
        
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Add send button
        
        let sendBtn = UIButton(type: .system)
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.setTitle("Send", for: .normal)
        sendBtn.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendBtn)
        
        sendBtn.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendBtn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        sendBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendBtn.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        // Add input text field
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendBtn.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        // Add separator view
        
        let separatorLineView = UIView()
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        containerView.addSubview(separatorLineView)
        
        separatorLineView.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
    }
    
    @objc func handleSend() {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let timestamp = Int(NSDate().timeIntervalSince1970)
        if let toId = user?.id, let fromID = Auth.auth().currentUser?.uid {
            let values = ["text": inputTextField.text!, "toId": toId, "fromId": fromID, "timestamp": timestamp] as [String : Any]
            childRef.updateChildValues(values)
        }
    }
}

extension ChatLogController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        inputTextField.resignFirstResponder()
        return true
    }
}

// MARK: Observe keyboard

extension ChatLogController {
    func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentKeyboardHeight = keyboardSize.height - self.view.safeAreaInsets.bottom
            moveTextInputFieldUp(by: currentKeyboardHeight)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            moveTextInputDown(by: currentKeyboardHeight)
            currentKeyboardHeight = 0.0
        }
    }
    
    func moveTextInputFieldUp(by value: CGFloat) {
        containerViewBottomAnchor?.isActive = false
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -value)
        containerViewBottomAnchor?.isActive = true
    }
    
    func moveTextInputDown(by value: CGFloat) {
        containerViewBottomAnchor?.isActive = false
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
    }
}
