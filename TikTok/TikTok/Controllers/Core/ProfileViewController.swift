//
//  ProfileViewController.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 22.07.2021.
//

import UIKit
import ProgressHUD

class ProfileViewController: UIViewController {
    
    enum PicturePickerType {
        case camera
        case photoLibrary
    }
    
    // MARK: - Properties
    private var posts = [PostModel]()
    var user: User
    private var followers = [String]()
    private var following = [String]()
    private var isfollower: Bool = false
    
    var isCurrentUserProfile: Bool {
        if let username = UserDefaults.standard.string(forKey: "username") {
            return user.username.lowercased() == username.lowercased()
        }
        return false
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.showsVerticalScrollIndicator = false
        collection.register(
            ProfileHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier)
        collection.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        return collection
    }()
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = user.username.uppercased()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let username = UserDefaults.standard.string(forKey: "username") ?? "ME"
        if title?.lowercased() == username.lowercased() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(
                                                                    systemName: "gear"),
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(didTapSettings))
        }
        
        fetchPosts()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    // MARK: - Selectors
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Hepler Function
    
    func fetchPosts() {
        DatabaseManager.shared.getPosts(for: user) { [weak self] postModels in
            DispatchQueue.main.async {
                self?.posts = postModels
                self?.collectionView.reloadData()
            }
        }
    }
    
}



// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postModel = posts[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: postModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // opern post
        let post = posts[indexPath.row]
        let vc = PostViewController(model: post)
        vc.delegate = self
        vc.title = "Video"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.width - 12) / 3
        return CGSize(width: width,
                      height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
                for: indexPath) as? ProfileHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        
        header.delegate = self
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        DatabaseManager.shared.getRelationShips(for: user, type: .followers) { [weak self] followers in
            defer {
                group.leave()
            }
            self?.followers = followers
        }
        DatabaseManager.shared.getRelationShips(for: user, type: .following) { [weak self] following in
            defer {
                group.leave()
            }
            self?.following = following
        }
        
        DatabaseManager.shared.isValidRelationship(for: user,
                                                   type: .followers) { isFollower in
            defer {
                group.leave()
            }
            self.isfollower = isFollower
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let viewModel = ProfileHeaderViewModel(
                avatarImageURL: self.user.profilePictureURL,
                followerCount: self.followers.count,
                followingCount: self.following.count,
                isFollowing: self.isCurrentUserProfile ? nil : self.isfollower)
            header.configure(with: viewModel)
        }
        
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: 300)
    }
}

// MARK: - ProfileHeaderCollectionReusableViewDelegate

extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate {
    
    func ProfileHeaderCollectionReusableView1(_ header: ProfileHeaderCollectionReusableView, didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel) {
        
        if isCurrentUserProfile {
            // edit profile
            let vc = EditProfileViewController()
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true)
        } else {
            // follow or unfolow current users prfile that we are viewing
            if self.isfollower {
                // unfollow
                DatabaseManager.shared.updateRelationship(for: user, follow: false) { [weak self] success in
                    if success {
                        DispatchQueue.main.async {
                            self?.isfollower = false
                            self?.collectionView.reloadData()
                        }
                    } else {
                        // failed
                    }
                    
                }
            } else {
                // follow
                DatabaseManager.shared.updateRelationship(for: user, follow: true) { [weak self] success in
                    if success {
                    DispatchQueue.main.async {
                        self?.isfollower = true
                        self?.collectionView.reloadData()
                    }
                    } else {
                        // failed
                    }
                }
            }
        }
    }
    func ProfileHeaderCollectionReusableView2(_ header: ProfileHeaderCollectionReusableView, didTapFollowersButtonWith viewModel: ProfileHeaderViewModel) {
        let vc = UserListViewController(type: .followers, user: user)
        vc.users = followers
        navigationController?.pushViewController(vc, animated: true)
        
    }
    func ProfileHeaderCollectionReusableView3(_ header: ProfileHeaderCollectionReusableView, didTapFollowingButtonWith viewModel: ProfileHeaderViewModel) {
        let vc = UserListViewController(type: .following, user: user)
        vc.users = following
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ProfileHeaderCollectionReusableView4(_ header: ProfileHeaderCollectionReusableView, didTapAvatarFor viewModel: ProfileHeaderViewModel) {
        
        guard isCurrentUserProfile else { return }
        let actionSheet = UIAlertController(title: "Profile picture", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.presentProfilePicturePicker(type: .camera)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.presentProfilePicturePicker(type: .photoLibrary)
            }
        }))
        present(actionSheet, animated: true)
    }
    
    func presentProfilePicturePicker(type: PicturePickerType) {
        let picker = UIImagePickerController()
        picker.sourceType = type == .camera ? .camera : .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        ProgressHUD.show("Uploading")
        StorageManager.shared.uploadProfilePicture(with: image) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let downloadURL):
                    UserDefaults.standard.setValue(downloadURL.absoluteString, forKey: "profile_picture_url")
                    
                    self.user = User(username: self.user.username,
                                     profilePictureURL: downloadURL,
                                     identifier: self.user.username)
                    ProgressHUD.showSuccess("Updated!")
                    self.collectionView.reloadData()
                case .failure:
                    ProgressHUD.showError("Failed to update profile picture")
                }
            }
        }
    }
}

// MARK: - PostViewControllerDelegate

extension ProfileViewController: PostViewControllerDelegate {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel) {
        // present comments
    }
    
    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel) {
        // push another profile
    }
    
    
}
