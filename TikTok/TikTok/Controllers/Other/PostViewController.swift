//
//  PostViewController.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 22.07.2021.
//

import UIKit

class PostViewController: UIViewController {

    let model: PostModel
    
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colors: [UIColor] = [.red, .black, .blue, .yellow, .white]
        view.backgroundColor = colors.randomElement()
    }
    
}
