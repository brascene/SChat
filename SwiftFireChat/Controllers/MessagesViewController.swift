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
    var currentUser: UserModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.handleLogout))
        let newMessageImage = UIImage(named: "new_message")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: newMessageImage, style: .plain, target: self, action: #selector(handleNewMessageBtn))
        
        viewModel.delegate = self
        viewModel.observeMessages()
        
        tableView.register(MessagePreviewCell.self, forCellReuseIdentifier: "messagePreviewCellID")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkUserLogged()
    }
    
    @objc func handleNewMessageBtn() {
        let newMessageVC = NewMessageController()
        newMessageVC.messagesVC = self
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
    
    func messagesRetrieved() {
        print("Message retrieved")
        if viewModel.messages.count > 0 {
            tableView.reloadData()
        }
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
        if let user = currentUser {
            chatVC.user = user
        }
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

extension MessagesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messagePreviewCellID", for: indexPath) as! MessagePreviewCell
        let currentMessage = viewModel.messages[indexPath.row]
        cell.setupCell(with: currentMessage)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
}

class MessagePreviewCell: UITableViewCell {
    let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 24.0
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let timeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "HH:MM:SS"
        l.textColor = UIColor.lightGray
        l.font = UIFont.systemFont(ofSize: 12)
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(userImageView)
        addSubview(timeLabel)
        setupImageView()
        setupTimeLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImageView() {
        userImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    func setupTimeLabel() {
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: (self.textLabel?.centerYAnchor)!).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
    }
    
    func setupCell(with message: MessageModel) {
        if let toUserAvatarURL = message.toUserAvatarURL {
            self.userImageView.loadImageCacheWithUrl(imageUrl: toUserAvatarURL)
        }
        
        self.textLabel?.setCechedNameFor(id: message.toID)
        self.detailTextLabel?.text = message.message
        
        let seconds = Double(message.timestamp)
        let timestampDate = Date(timeIntervalSince1970: seconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        let formatedString = dateFormatter.string(from: timestampDate)
        self.timeLabel.text = formatedString
    }
}
