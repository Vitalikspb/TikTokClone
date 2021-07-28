//
//  NotificationsPostCommentTableViewCell.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 28.07.2021.
//

import UIKit

protocol NotificationsPostCommentTableViewCellDelegate: AnyObject {
    func notificationsPostCommentTableViewCell(_ cell: NotificationsPostCommentTableViewCell,
                                           didTapPostWith identifier: String)
}

class NotificationsPostCommentTableViewCell: UITableViewCell {

    static let identifier = "NotificationsPostCommentTableViewCell"
    weak var delegate: NotificationsPostCommentTableViewCellDelegate?
    var postID: String?
    
    private let postThumbnailImageView: UIImageView = {
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postThumbnailImageView)
        contentView.addSubview(label)
        contentView.addSubview(datelabel)
        
        selectionStyle = .none
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPost))
        postThumbnailImageView.addGestureRecognizer(tap)
        postThumbnailImageView.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        postThumbnailImageView.frame = CGRect(x: contentView.width - 50,
                                       y: 3,
                                       width: 50,
                                       height: contentView.height - 6)
        label.sizeToFit()
        datelabel.sizeToFit()
        let labelSize = label.sizeThatFits(CGSize(
                                            width: contentView.width - 10 - postThumbnailImageView.width - 5,
                                            height: contentView.height - 40))
        label.frame = CGRect(x: 10,
                             y: 5,
                             width: labelSize.width,
                             height: labelSize.height)
        datelabel.frame = CGRect(x: 10,
                                 y: label.bottom + 3,
                                 width: contentView.width - postThumbnailImageView.width,
                                 height: 40)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postThumbnailImageView.image = nil
        label.text = nil
        datelabel.text = nil
    }
    
    // MARK: - Selectors
    
    @objc func didTapPost() {
        guard let id = postID else { return }
        delegate?.notificationsPostCommentTableViewCell(self, didTapPostWith: id)
    }
    
    // MARK: - Helper Function
    
    func configure(with postFileName: String, model: Notification) {
        postThumbnailImageView.image = UIImage(named: "test")
        label.text = model.text
        datelabel.text = .date(with: model.date)
        postID = postFileName
    }
    
}
