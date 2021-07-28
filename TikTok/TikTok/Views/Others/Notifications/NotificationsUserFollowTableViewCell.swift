//
//  NotificationsUserFollowTableViewCell.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 28.07.2021.
//

import UIKit

protocol NotificationsUserFollowTableViewCellDelegate: AnyObject {
    func notificationsUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell,
                                             didTapFollowFor username: String)
    func notificationUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell,
                                             didTapAvatarFor username: String)
}

class NotificationsUserFollowTableViewCell: UITableViewCell {
    
    // MARK: - Properties

    static let identifier = "NotificationsUserFollowTableViewCell"
    weak var delegate: NotificationsUserFollowTableViewCellDelegate?
    var username: String?
    
    // avatar, label, follow button
    
    private let avatarImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    private let datelabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    private let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(avatarImageView)
        contentView.addSubview(label)
        contentView.addSubview(followButton)
        contentView.addSubview(datelabel)
        
        selectionStyle = .none
        followButton.addTarget(self, action: #selector(didTapFollow), for: .touchUpInside)
        avatarImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarImageView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let iconSize: CGFloat = 50
        avatarImageView.frame = CGRect(x: 10,
                                       y: 5,
                                       width: iconSize,
                                       height: iconSize)
        avatarImageView.layer.cornerRadius = iconSize / 2
        avatarImageView.layer.masksToBounds = true
        followButton.sizeToFit()
        followButton.frame = CGRect(x: contentView.width - 110,
                                    y: 10,
                                    width: 100,
                                    height: 30)
        label.sizeToFit()
        datelabel.sizeToFit()
        let labelSize = label.sizeThatFits(CGSize(
                                            width: contentView.width - 30 - followButton.width - iconSize,
                                            height: contentView.height - 40))
        label.frame = CGRect(x: avatarImageView.right + 10,
                             y: 5,
                             width: labelSize.width,
                             height: labelSize.height)
        datelabel.frame = CGRect(x: avatarImageView.right + 10,
                                 y: label.bottom + 3,
                                 width: contentView.width - avatarImageView.width - followButton.width,
                                 height: 40)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImageView.image = nil
        label.text = nil
        datelabel.text = nil
        
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = .systemBlue
        followButton.layer.borderWidth = 0
        followButton.layer.borderColor = nil
        followButton.setTitleColor(.white, for: .normal)
    }
    
    // MARK: - Selectors
    
    @objc func didTapAvatar() {
        guard let username = username else { return }
        delegate?.notificationUserFollowTableViewCell(self, didTapAvatarFor: username)
    }
    
    @objc func didTapFollow() {
        guard let username = username else { return }
        
        followButton.setTitle("Following", for: .normal)
        followButton.backgroundColor = .clear
        followButton.layer.borderWidth = 1
        followButton.setTitleColor(.lightGray, for: .normal)
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        
        delegate?.notificationsUserFollowTableViewCell(self, didTapFollowFor: username)
        
    }
    
    // MARK: - Helper Functions

    func configure(with username: String, model: Notification) {
        self.username = username
        avatarImageView.image = UIImage(named: "test")
        label.text = model.text
        datelabel.text = .date(with: model.date)
    }
}
