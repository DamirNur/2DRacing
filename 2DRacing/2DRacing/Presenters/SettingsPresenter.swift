//
//  SettingsPresenter.swift
//  2DRacing
//
//  Created by Damir Nuriev on 14.02.2024.
//

import Foundation

protocol ISettingsPresenter {
    func loadModel()
}

final class SettingsPresenter: ISettingsPresenter {
    
    weak var view: SettingsViewProtocol?
    var model: SettingsModel?
    
    func loadModel() {
        guard let model else { return }
        view?.updateView(with: model)
    }
}
