//
//  SwitchCellViewModel.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 29.07.2021.
//

import Foundation

struct SwitchCellViewModel {
    let title: String
    var isOn: Bool
    
    mutating func setOn(_ on: Bool) {
        self.isOn = on
    }
}
