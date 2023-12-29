//
//  SettingsPresenter.swift
//  2DRacing
//
//  Created by Damir Nuriev on 17.12.2023.
//

import UIKit

protocol ISettingsPresenter {
    func loadModel()
}

class SettingsPresenter: ISettingsPresenter {
    
    weak var view: SettingsViewProtocol?
    
    init(view: SettingsViewProtocol) {
        self.view = view
    }
    
    func loadModel() {
        let model = SettingsModel(
            userName: UserDefaultsService.shared.loadName() ?? "User",
            carColor: UserDefaultsService.shared.loadCarColor() ?? "blue",
            selectedImage: UserImageService.shared.loadImageData("selectedImage"),
            initialSpeed: UserDefaultsService.shared.loadInitialSpeed()
        )
        view?.updateView(with: model)
    }
}
