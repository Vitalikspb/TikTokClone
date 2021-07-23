//
//  CommentsViewController.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 22.07.2021.
//

import UIKit

protocol CommentsViewControllerDelegate: AnyObject {
    func didTapCloseForComments(with viewController: CommentsViewController)
}

class CommentsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let post: PostModel
    private var comments = [PostComments]()
    weak var delegate: CommentsViewControllerDelegate?
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: CommentsTableViewCell.identifier)
        return tableView
    }()
    
    private let closeButton: UIButton = {
       let button = UIButton()
        button.tintColor = .black
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    // MARK: - LifeCysle
    
    init(post: PostModel) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        view.backgroundColor = .white
        fetchPostComments()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.frame = CGRect(x: view.width - 45, y: 10, width: 35, height: 35)
        
        tableView.frame = CGRect(x: 0,
                                 y: closeButton.bottom,
                                 width: view.width,
                                 height: view.height - closeButton.bottom)
    }
    
    // MARK: - Selectors
    
    @objc private func didTapClose() {
        delegate?.didTapCloseForComments(with: self)
    }
    
    // MARK: - Helpers Function
    
    func fetchPostComments() {
//        DatabaseManager.shared.fetchComments()
        self.comments = PostComments.mockComments()
    }
    
}

    // MARK: - UITableViewDelegate, UITableViewDataSource

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentsTableViewCell.identifier, for: indexPath) as? CommentsTableViewCell else { return UITableViewCell()}
        cell.configure(with: comment)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


