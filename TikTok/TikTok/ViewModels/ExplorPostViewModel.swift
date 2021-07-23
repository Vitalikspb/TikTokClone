//
//  ExplorPostViewModel.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 23.07.2021.
//

import Foundation
import UIKit

struct ExplorPostViewModel {
    let thumbnailImage: UIImage?
    let caption: String
    let handler: (() -> Void)?
}
