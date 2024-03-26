//
//  UserDefaultsService.swift
//  2DRacing
//
//  Created by Damir Nuriev on 14.02.2024.
//

import UIKit

private extension String {
    static let settings = "settings"
    static let blueColor = "blue"
    static let savedScore = "savedScore"
}

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    func saveScore(_ score: Int) {
        UserDefaults.standard.set(score, forKey: .savedScore)
    }
    
    func saveSettings(_ model: SettingsModel) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(model) {
            UserDefaults.standard.set(encoded, forKey: .settings)
        }
    }
    
    func loadSettings() -> SettingsModel? {
        guard let model = UserDefaults.standard.data(forKey: .settings) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(SettingsModel.self, from: model)
    }
    
    func createDefaultSettingsModelIfNeeded() {
        if loadSettings() == nil {
            let settingsModel = SettingsModel(userName: Constants.defaultName,
                                              carColor: .blueColor,
                                              selectedImageName: Constants.selectedImage,
                                              initialSpeed: Constants.minSpeedValue)
            saveSettings(settingsModel)
        }
    }
}
