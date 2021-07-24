//
//  ExplorHashtagViewModel.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 23.07.2021.
//

import Foundation
import UIKit

struct ExplorHashtagViewModel {
    let text: String
    let icon: UIImage?
    let count: Int             // number of post associated with tag
    let handler: (() -> Void)?
}
