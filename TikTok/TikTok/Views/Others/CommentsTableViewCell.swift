//
//  CommentsTableViewCell.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 23.07.2021.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let identifier = "CommentsTableViewCell"
    
    private let avatarImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let commentsLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    private let dateLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(avatarImageView)
        contentView.addSubview(commentsLabel)
        contentView.addSubview(dateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commentsLabel.sizeToFit()
        dateLabel.sizeToFit()
        
        let imageSize: CGFloat = 50
        avatarImageView.frame = CGRect(x: 10,
                                       y: 5,
                                       width: imageSize,
                                       height: imageSize)
        
        
        dateLabel.frame = CGRect(x: avatarImageView.right + 10,
                                 y: commentsLabel.bottom,
                                 width: dateLabel.width,
                                 height: dateLabel.height)
        
        let commentLabelHeight = min(contentView.height - dateLabel.top, commentsLabel.height)
        commentsLabel.frame = CGRect(x: avatarImageView.right + 10,
                                     y: 5,
                                     width: contentView.width - avatarImageView.right - 10,
                                     height: commentLabelHeight)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        commentsLabel.text = nil
        dateLabel.text = nil
    }
    
    // MARK: - Helpers Function
    
    public func configure(with model: PostComments) {
        commentsLabel.text = model.text
        dateLabel.text = .date(with: model.date)
        
        if let url = model.user.profilePictureURL {
            print(url)
        } else {
            avatarImageView.image = UIImage(systemName: "person.circle")
        }
    }
}
