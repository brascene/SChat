//
//  NewMessageController.swift
//  SwiftFireChat
//
//  Created by Dino Pelic on 2/10/19.
//  Copyright © 2019 Dino Pelic. All rights reserved.
//

import UIKit

class NewMessageController: UITableViewController {
    
    let cellID = "cellID"
    var viewModel: NewMessageViewModel = NewMessageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.handleCancel))
        
        viewModel.delegate = self
        viewModel.fetchAllUsers()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        let currentUser = viewModel.allUsers[indexPath.row]
        cell.textLabel?.text = currentUser.name
        cell.detailTextLabel?.text = currentUser.email
        
        let avatar_url = currentUser.avatar_url
        cell.userImageView.loadImageCacheWithUrl(imageUrl: avatar_url)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
}

extension NewMessageController: NewMessageViewModelOutput {
    func usersRetrieved() {
        self.tableView.reloadData()
    }
}

class UserCell: UITableViewCell {
    let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 20.0
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(userImageView)
        setupImageView()
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
}
