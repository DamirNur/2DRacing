//
//  UserDefaultsService.swift
//  2DRacing
//
//  Created by Damir Nuriev on 25.12.2023.
//

import UIKit

class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    func loadName() -> String? {
        UserDefaults.standard.string(forKey: "userName")
    }
    
    func saveName(_ name: String) {
        UserDefaults.standard.set(name, forKey: "userName")
    }
    
    func loadCarColor() -> String? {
        UserDefaults.standard.string(forKey: "carColor")
    }
    
    func saveCarColor(_ color: String) {
        UserDefaults.standard.set(color, forKey: "carColor")
    }
    
    func loadInitialSpeed() -> CGFloat {
        UserDefaults.standard.value(forKey: "initialSpeed") as? CGFloat ?? 0.0
    }
    
    func saveInitialSpeed(_ speed: CGFloat) {
        UserDefaults.standard.set(speed, forKey: "initialSpeed")
    }
    
    func saveColor(_ color: UIColor, forKey key: String) {
        if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) {
            UserDefaults.standard.set(colorData, forKey: key)
        }
    }
    
    func loadColor(forKey key: String) -> UIColor? {
        if let colorData = UserDefaults.standard.data(forKey: key),
           let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
            return color
        }
        return nil
    }
}
