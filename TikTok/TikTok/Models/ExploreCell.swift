//
//  ExploreCell.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 23.07.2021.
//

import Foundation
import UIKit

enum ExploreCell {
    case banner(viewModel: ExplorBannerViewModel)
    case post(viewModel: ExplorPostViewModel)
    case hashtag(viewModel: ExplorHashtagViewModel)
    case user(viewModel: ExplorUserViewModel)
}
