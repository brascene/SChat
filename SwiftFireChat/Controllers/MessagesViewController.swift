//
//  ViewController.swift
//  SwiftFireChat
//
//  Created by Dino Pelic on 2/8/19.
//  Copyright © 2019 Dino Pelic. All rights reserved.
//

import UIKit
import Firebase

class MessagesViewController: UITableViewController {
    var viewModel: MessagesViewModel = MessagesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.handleLogout))
        let newMessageImage = UIImage(named: "new_message")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: newMessageImage, style: .plain, target: self, action: #selector(handleNewMessageBtn))
        
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkUserLogged()
    }
    
    @objc func handleNewMessageBtn() {
        let newMessageVC = NewMessageController()
        let navigationVC = UINavigationController(rootViewController: newMessageVC)
        self.present(navigationVC, animated: true, completion: nil)
    }

    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
    }
}

extension MessagesViewController: MessagesViewModelOutput {
    func checkedIfUserLogged(logged: Bool) {
        if logged {
            viewModel.getNavigationTitle()
        } else {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    func fetchedUserData(name: String?) {
        guard let name = name else { return }
        self.navigationItem.title = name
    }
}

