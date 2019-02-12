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
    
    func fetchedUserData(user: UserModel?) {
        guard let user = user else { return }
        setupNavbarWithUser(user: user)
    }
    
    func setupNavbarWithUser(user: UserModel) {
        self.navigationItem.title = user.name
        let titleView = CustomTitleView()
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatLogController)))

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.loadImageCacheWithUrl(imageUrl: user.avatar_url)
        avatar.contentMode = .scaleAspectFill
        avatar.layer.cornerRadius = 20
        avatar.clipsToBounds = true
        
        containerView.addSubview(avatar)
        
        avatar.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        avatar.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 40).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = user.name
        
        containerView.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 8).isActive = true
        label.centerYAnchor.constraint(equalTo: avatar.centerYAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        label.heightAnchor.constraint(equalTo: avatar.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    
    @objc func showChatLogController() {
        let chatVC = ChatLogController(collectionViewLayout: UICollectionViewLayout())
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}

class CustomTitleView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: 100.0, height: 40.0)
        self.isUserInteractionEnabled = true
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100.0, height: 40.0)
    }
}
