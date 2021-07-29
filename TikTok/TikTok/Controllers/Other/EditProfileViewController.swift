//
//  EditProfileViewController.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 29.07.2021.
//

import UIKit

class EditProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Profile"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(didTapClose))
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
 
}
