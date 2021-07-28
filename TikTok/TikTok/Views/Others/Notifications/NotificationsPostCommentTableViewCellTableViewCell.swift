//
//  NotificationsPostCommentTableViewCellTableViewCell.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 28.07.2021.
//

import UIKit

class NotificationsPostCommentTableViewCellTableViewCell: UITableViewCell {

    static let identifier = "NotificationsPostCommentTableViewCellTableViewCell"
    
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
    
    func configure(with postFileName: String, model: Notification) {
        postThumbnailImageView.image = UIImage(named: "test")
        label.text = model.text
        datelabel.text = .date(with: model.date)
    }
    
}
