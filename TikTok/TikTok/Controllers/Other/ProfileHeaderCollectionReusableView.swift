//
//  ProfileHeaderCollectionReusableView.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 28.07.2021.
//

import UIKit
import SDWebImage

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func ProfileHeaderCollectionReusableView1(_ header: ProfileHeaderCollectionReusableView,
                                             didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel)
    func ProfileHeaderCollectionReusableView2(_ header: ProfileHeaderCollectionReusableView,
                                             didTapFollowersButtonWith viewModel: ProfileHeaderViewModel)
    func ProfileHeaderCollectionReusableView3(_ header: ProfileHeaderCollectionReusableView,
                                             didTapFollowingButtonWith viewModel: ProfileHeaderViewModel)
    func ProfileHeaderCollectionReusableView4(_ header: ProfileHeaderCollectionReusableView,
                                             didTapAvatarFor viewModel: ProfileHeaderViewModel)
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    //MARK: - Properties
    
    static let identifier = "ProfileHeaderCollectionReusableView"
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    var viewModel: ProfileHeaderViewModel?
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let primaryButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .systemPink
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let followersButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("0\nFollowers", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    private let followingButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("0\nFollowing", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
        
        addSubviews()
        configureButtons()
        avatarImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarImageView.addGestureRecognizer(tap)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let avatarSize: CGFloat = 110
        avatarImageView.frame = CGRect(x: (width - avatarSize) / 2,
                                       y: 5,
                                       width: avatarSize,
                                       height: avatarSize)
        avatarImageView.layer.cornerRadius = avatarImageView.height / 2
        
        followersButton.frame = CGRect(x: (width - 210) / 2,
                                       y: avatarImageView.bottom + 10,
                                       width: 100,
                                       height: 60)
        followingButton.frame = CGRect(x: followersButton.right + 10,
                                       y: avatarImageView.bottom + 10,
                                       width: 100,
                                       height: 60)
        primaryButton.frame = CGRect(x: (width - 220) / 2,
                                     y: followingButton.bottom + 15,
                                     width: 220,
                                     height: 45)
    }
    
    //MARK: - Selectors
    
    @objc func didTapAvatar() {
        guard let viewModel = self.viewModel else { return }
        delegate?.ProfileHeaderCollectionReusableView4(self,
                                                       didTapAvatarFor: viewModel)
    }
    
    @objc func didTapPrimaryButton() {
        guard let viewModel = self.viewModel else { return }
        delegate?.ProfileHeaderCollectionReusableView1(self,
                                                      didTapPrimaryButtonWith: viewModel)
    }
    
    @objc func didTapFollowersButton() {
        guard let viewModel = self.viewModel else { return }
        delegate?.ProfileHeaderCollectionReusableView2(self,
                                                      didTapFollowersButtonWith: viewModel)
    }
    
    @objc func didTapFollowingButton() {
        guard let viewModel = self.viewModel else { return }
        delegate?.ProfileHeaderCollectionReusableView3(self,
                                                      didTapFollowingButtonWith: viewModel)
    }
    
    //MARK: - helpers Function
    
    private func addSubviews() {
        addSubview(avatarImageView)
        addSubview(primaryButton)
        addSubview(followersButton)
        addSubview(followingButton)
    }
    private func configureButtons() {
        primaryButton.addTarget(self, action: #selector(didTapPrimaryButton), for: .touchUpInside)
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
    }
    
    func configure(with viewModel: ProfileHeaderViewModel) {
        self.viewModel = viewModel
        
        followersButton.setTitle("\(viewModel.followerCount)\nFollowers", for: .normal)
        followingButton.setTitle("\(viewModel.followingCount)\nFollowing", for: .normal)
        
        if let avatarURL = viewModel.avatarImageURL {
            avatarImageView.sd_setImage(with: avatarURL, completed: nil)
        } else {
            avatarImageView.image = UIImage(named: "test")
        }
        
        if let isFollowing = viewModel.isFollowing {
            primaryButton.backgroundColor = isFollowing ? .secondarySystemBackground : .systemPink
            primaryButton.setTitle(isFollowing ? "Unfollow" : "Follow", for: .normal)
        } else {
            primaryButton.backgroundColor = .secondarySystemBackground
            primaryButton.setTitle("Edit Profile", for: .normal)
        }
    }
    
}
