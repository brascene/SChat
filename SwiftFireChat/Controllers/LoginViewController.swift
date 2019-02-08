//
//  LoginViewController.swift
//  SwiftFireChat
//
//  Created by Dino Pelic on 2/8/19.
//  Copyright © 2019 Dino Pelic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let inputsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let registerBtn: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        return v
    }()
    
    let emailSeparatorView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        return v
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "gameofthrones_splash")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(inputsContainer)
        view.addSubview(registerBtn)
        view.addSubview(profileImageView)
        
        setupInputContainer()
        setupRegisterButton()
        setupProfileImageView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: inputsContainer.topAnchor, constant: -12).isActive = true
    }
    
    func setupSeparatorConstraints(v: UIView, for textField: UITextField) {
        v.leftAnchor.constraint(equalTo: inputsContainer.leftAnchor).isActive = true
        v.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
        v.heightAnchor.constraint(equalToConstant: 1).isActive = true
        v.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor).isActive = true
    }
    
    func setupRegisterButton() {
        registerBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerBtn.topAnchor.constraint(equalTo: inputsContainer.bottomAnchor, constant: 12).isActive = true
        registerBtn.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor).isActive = true
        registerBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupInputContainer() {
        inputsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainer.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        
        inputsContainer.addSubview(nameTextField)
        inputsContainer.addSubview(nameSeparatorView)
        
        nameTextField.leftAnchor.constraint(equalTo: inputsContainer.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainer.topAnchor, constant: 0).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/3).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor).isActive = true
        
        setupSeparatorConstraints(v: nameSeparatorView, for: nameTextField)
        
        inputsContainer.addSubview(emailTextField)
        inputsContainer.addSubview(emailSeparatorView)
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainer.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 0).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/3).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor).isActive = true
        
        setupSeparatorConstraints(v: emailSeparatorView, for: emailTextField)
        
        inputsContainer.addSubview(passTextField)
        
        passTextField.leftAnchor.constraint(equalTo: inputsContainer.leftAnchor, constant: 12).isActive = true
        passTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 0).isActive = true
        passTextField.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/3).isActive = true
        passTextField.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor).isActive = true
    }

}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
