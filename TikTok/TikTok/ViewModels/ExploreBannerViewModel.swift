//
//  ExplorBannerViewModel.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 23.07.2021.
//

import Foundation
import UIKit

struct ExplorBannerViewModel {
    let image: UIImage?
    let title: String
    let handler: (() -> Void)?
}
