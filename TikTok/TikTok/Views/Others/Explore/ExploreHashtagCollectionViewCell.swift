//
//  ExploreHashtagCollectionViewCell.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 26.07.2021.
//

import UIKit

class ExploreHashtagCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ExploreHashtagCollectionViewCell"
    
    private let iconImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let hashtagLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        contentView.addSubview(iconImageView)
        contentView.addSubview(hashtagLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let iconSize: CGFloat = contentView.height / 3
        iconImageView.frame = CGRect(x: 10,
                                     y: (contentView.height - iconSize) / 2,
                                     width: iconSize,
                                     height: iconSize)
        
        hashtagLabel.sizeToFit()
        hashtagLabel.frame = CGRect(x: iconImageView.right + 10,
                                    y: 0,
                                    width: contentView.width - iconImageView.right - 10,
                                    height: contentView.height)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hashtagLabel.text = nil
        iconImageView.image = nil
    }
    
    func configure(with viewModel: ExploreHashtagViewModel) {
        hashtagLabel.text = viewModel.text
        iconImageView.image = viewModel.icon
    }
}
