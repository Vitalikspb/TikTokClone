//
//  ExploreUserViewModel.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 23.07.2021.
//

import Foundation
import UIKit

struct ExploreUserViewModel {
    let profilePicture: UIImage?
    let username: String
    let followerCount: Int
    let handler: (() -> Void)
}
