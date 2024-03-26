//
//  MainScreenPresenter.swift
//  2DRacing
//
//  Created by Damir Nuriev on 25.03.2024.
//

import Foundation

protocol IMainScreenPresenter {
    func startButtonTapped()
    func recordsButtonTapped()
    func settingsButtonTapped()
}

final class MainScreenPresenter: IMainScreenPresenter {
    
    weak var view: MainScreenViewProtocol?
    
    init(view: MainScreenViewProtocol) {
        self.view = view
    }
        
    func startButtonTapped() {
        view?.presentGameViewScreen()
    }
    
    func recordsButtonTapped() {
        view?.presentRecordsViewScreen()
    }
    
    func settingsButtonTapped() {
        view?.presentSettingsViewScreen()
    }
}
