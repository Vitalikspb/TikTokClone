//
//  CaptionViewController.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 26.07.2021.
//

import UIKit

class CaptionViewController: UIViewController {
    
    // MARK: - Properties
    
    let videoURL: URL
    
    // MARK: - Lifecycle
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Caption"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Post",
            style: .done,
            target: self,
            action: #selector(didTapPost))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Selectors
    
    @objc private func didTapPost() {
        
    }
    
}
