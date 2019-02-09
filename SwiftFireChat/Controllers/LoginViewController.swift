//
//  LoginViewController.swift
//  SwiftFireChat
//
//  Created by Dino Pelic on 2/8/19.
//  Copyright © 2019 Dino Pelic. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    var viewModel: LoginViewModel = LoginViewModel()
    
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
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
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
    
    let segControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleSegControl), for: .valueChanged)
        return sc
    }()
    
    var inputContainerHeightConstraint: NSLayoutConstraint?
    var nameTextFieldHeightConstraint: NSLayoutConstraint?
    var emailHeightConstraint: NSLayoutConstraint?
    var passHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(inputsContainer)
        view.addSubview(registerBtn)
        view.addSubview(profileImageView)
        view.addSubview(segControl)
        
        setupInputContainer()
        setupRegisterButton()
        setupProfileImageView()
        setupSegControl()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func handleRegister() {
        guard let password = passTextField.text, let email = emailTextField.text, let name = nameTextField.text else {
            return
        }
        viewModel.setFormValues(email: email, password: password, name: name)
        if segControl.selectedSegmentIndex == 0 {
            viewModel.handleLogin()
        } else {
            viewModel.handleRegister()
        }
    }
    
    @objc func handleSegControl() {
        let title = segControl.titleForSegment(at: segControl.selectedSegmentIndex)
        registerBtn.setTitle(title, for: .normal)
        
        nameTextFieldHeightConstraint?.isActive = false
        emailHeightConstraint?.isActive = false
        passHeightConstraint?.isActive = false
        
        if segControl.selectedSegmentIndex == 0 {
            inputContainerHeightConstraint?.constant = 100
            nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 0)
            emailHeightConstraint = emailTextField.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/2)
            passHeightConstraint = passTextField.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/2)
        }
        
        if segControl.selectedSegmentIndex == 1 {
            inputContainerHeightConstraint?.constant = 150
            nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/3)
            emailHeightConstraint = emailTextField.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/3)
            passHeightConstraint = passTextField.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/3)
        }

        emailHeightConstraint?.isActive = true
        passHeightConstraint?.isActive = true
        nameTextFieldHeightConstraint?.isActive = true
    }
    
    func setupSegControl() {
        segControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segControl.bottomAnchor.constraint(equalTo: inputsContainer.topAnchor, constant: -12).isActive = true
        segControl.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor, multiplier: 0.5).isActive = true
        segControl.heightAnchor.constraint(equalToConstant: 50)
    }
    
    func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: segControl.topAnchor, constant: -12).isActive = true
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
        inputContainerHeightConstraint = inputsContainer.heightAnchor.constraint(equalToConstant: 150.0)
        inputContainerHeightConstraint?.isActive = true
        
        inputsContainer.addSubview(nameTextField)
        inputsContainer.addSubview(nameSeparatorView)
        
        nameTextField.leftAnchor.constraint(equalTo: inputsContainer.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainer.topAnchor, constant: 0).isActive = true
        nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightConstraint?.isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor).isActive = true
        
        setupSeparatorConstraints(v: nameSeparatorView, for: nameTextField)
        
        inputsContainer.addSubview(emailTextField)
        inputsContainer.addSubview(emailSeparatorView)
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainer.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 0).isActive = true
        
        emailHeightConstraint =  emailTextField.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/3)
        emailHeightConstraint?.isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor).isActive = true
        
        setupSeparatorConstraints(v: emailSeparatorView, for: emailTextField)
        
        inputsContainer.addSubview(passTextField)
        
        passTextField.leftAnchor.constraint(equalTo: inputsContainer.leftAnchor, constant: 12).isActive = true
        passTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 0).isActive = true
        passHeightConstraint = passTextField.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/3)
        passHeightConstraint?.isActive = true
        passTextField.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor).isActive = true
    }

}

extension LoginViewController: LoginViewModelOutput {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func userCreated(status: Bool) {
        if status {
            showAlert(title: "Success", message: "User created")
        } else {
            showAlert(title: "Failed", message: "User not created")
        }
    }
    
    func updatedChildValues(status: Bool) {
        if status {
            self.dismiss(animated: true, completion: nil)
        } else {
            showAlert(title: "Failed", message: "User data not saved")
        }
    }
    
    func loginFinishedWith(status: Bool) {
        if status {
            self.dismiss(animated: true, completion: nil)
        } else {
            showAlert(title: "Failed", message: "User login failed")
        }
    }
}
