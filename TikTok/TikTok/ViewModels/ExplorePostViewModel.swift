//
//  ExplorePostViewModel.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 23.07.2021.
//

import Foundation
import UIKit

struct ExplorePostViewModel {
    let thumbnailImage: UIImage?
    let caption: String
    let handler: (() -> Void)
}
