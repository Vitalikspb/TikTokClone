//
//  UserListViewController.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 22.07.2021.
//

import UIKit

class UserListViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let noUsersLabel: UILabel = {
       let label = UILabel()
        label.text = "No users"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()

    enum ListType: String {
        case followers
        case following
    }
    let user: User
    let type: ListType
    public var users = [String]()
    
    init(type: ListType, user: User) {
        self.type = type
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        switch type {
        case .followers: title = "Followers"
        case .following: title = "Following"
        }
        if users.isEmpty {
            view.addSubview(noUsersLabel)
            noUsersLabel.sizeToFit()
        } else {
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if tableView.superview == view {
            tableView.frame = view.bounds
        } else {
            noUsersLabel.center = view.center
        }
    }

}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].lowercased()
        return cell
    }
    
    
}
