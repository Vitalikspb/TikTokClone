//
//  PostViewController.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 22.07.2021.
//

import AVFoundation
import UIKit

protocol PostViewControllerDelegate: AnyObject {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel)
    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel)
}

class PostViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: PostViewControllerDelegate?
    var model: PostModel
    var player: AVPlayer?
    private var playerDidFinishObserver: NSObjectProtocol?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }()
    private let videoView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        return view
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "test"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.masksToBounds = true
        button.tintColor = .white
        return button
    }()
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Check out this video!! #five #video #ASDAS #ASA"
        label.font = .systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(videoView)
        videoView.addSubview(spinner)
        view.backgroundColor = .black
        view.addSubview(captionLabel)
        view.addSubview(profileButton)
        
        configureVideo()
        setUpButtons()
        setUpDubleTapToLike()
        
        profileButton.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        videoView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = videoView.center
        
        let size: CGFloat = 40
        let yStart: CGFloat = view.height - (size * 4) - 30 - view.safeAreaInsets.bottom
        for (index, button) in [likeButton, commentButton, shareButton].enumerated() {
            button.frame = CGRect(x: view.width-size-10,
                                  y: yStart + (CGFloat(index) * 10) + (CGFloat(index) * size),
                                  width: size,
                                  height: size)
        }
        captionLabel.sizeToFit()
        let labelSize = captionLabel.sizeThatFits(CGSize(width: view.width - size - 12, height: view.height))
        captionLabel.frame = CGRect(x: 5,
                                    y: view.height - 10 - view.safeAreaInsets.bottom - labelSize.height,
                                    width: view.width - size - 12,
                                    height: labelSize.height)
        profileButton.frame = CGRect(x: likeButton.left,
                                     y: likeButton.top - 10 - size,
                                     width: size,
                                     height: size)
        profileButton.layer.cornerRadius = size / 2
    }
    
    // MARK: - Selectors
    
    @objc func didTapLike() {
        model.isLikedByCurrentUser = !model.isLikedByCurrentUser
        likeButton.tintColor = model.isLikedByCurrentUser ? .systemRed : .white
    }
    
    @objc func didTapComment() {
        delegate?.postViewController(self, didTapCommentButtonFor: model)
    }
    
    @objc func didTapShare() {
        guard let url = URL(string: "Https://Tiktok.com") else { return }
        let vc = UIActivityViewController(activityItems: [url],
                                          applicationActivities: [])
        present(vc, animated: true)
    }
    
    @objc func didTapProfileButton() {
        delegate?.postViewController(self, didTapProfileButtonFor: model)
    }
    
    @objc func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        if !model.isLikedByCurrentUser {
            model.isLikedByCurrentUser = true
            likeButton.tintColor = .systemRed
        }
        HapticManager.shared.vibrateForSelection()
        let touchPoint = gesture.location(in: view)
        
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .systemRed
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = touchPoint
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 1
        view.addSubview(imageView)
        
        UIView.animate(withDuration: 0.2) {
            imageView.alpha = 1
        } completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIView.animate(withDuration: 0.5) {
                        imageView.alpha = 0
                    } completion: { done in
                        imageView.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers Function
    
    private func configureVideo() {
        StorageManager.shared.getDownloadURL(for: model) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.spinner.removeFromSuperview()
                
                switch result {
                case .success(let url):
                    self.player = AVPlayer(url: url)
                    
                    let playerLayer = AVPlayerLayer(player: self.player)
                    playerLayer.frame = self.view.bounds
                    playerLayer.videoGravity = .resizeAspectFill
                    self.videoView.layer.addSublayer(playerLayer)
                    self.player?.volume = 0
                    self.player?.play()
                    
                case .failure:
//                    dummy data
                    guard let path = Bundle.main.path(forResource: "ferrari", ofType: "mp4") else { return }
                    let url = URL(fileURLWithPath: path)
                    
                    self.player = AVPlayer(url: url)
                    
                    let playerLayer = AVPlayerLayer(player: self.player)
                    playerLayer.frame = self.view.bounds
                    playerLayer.videoGravity = .resizeAspectFill
                    self.videoView.layer.addSublayer(playerLayer)
                    
                    self.player?.volume = 0
                    self.player?.play()
                }
            }
        }
        
        guard let player = player else { return }
        
        playerDidFinishObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }
    }
    
    func setUpButtons() {
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        view.addSubview(shareButton)
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
    }
    
    func setUpDubleTapToLike() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
}
