//
//  PostCollectionViewCell.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 29.07.2021.
//

import UIKit
import AVFoundation

class PostCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PostCollectionViewCell"
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    func configure(with post: PostModel) {
        // Derive shild path
        StorageManager.shared.getDownloadURL(for: post) { result in
            switch result {
            case .success(let url):
                // generate thumnail
                DispatchQueue.main.async {
                    let asset = AVAsset(url: url)
                    let generator = AVAssetImageGenerator(asset: asset)
                    do {
                        let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
                        self.imageView.image = UIImage(cgImage: cgImage)
                    }
                    catch {
                        
                    }
                }
            case .failure(let error):
                print("Error to get download url \(error)")
            }
        }
        // get dawnload url
        
        
        
    }
    
}
