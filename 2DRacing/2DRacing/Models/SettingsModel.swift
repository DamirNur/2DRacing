//
//  SettingsModel.swift
//  2DRacing
//
//  Created by Damir Nuriev on 14.02.2024.
//

import UIKit

struct SettingsModel: Codable {
    var userName: String
    var carColor: String
    var selectedImageName: String
    var initialSpeed: CGFloat
}
