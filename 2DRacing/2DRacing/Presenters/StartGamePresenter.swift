//
//  StartGamePresenter.swift
//  2DRacing
//
//  Created by Damir Nuriev on 14.02.2024.
//

import Foundation

protocol IStartGamePresenter {
    func startGame()
    func handleCollision()
    func viewLoaded(isViewLoaded: Bool, presentedViewControllerIsNil: Bool)
}

final class StartGamePresenter: IStartGamePresenter {
    
    weak var view: StartGameViewProtocol?
    
    init(view: StartGameViewProtocol) {
        self.view = view
    }
    
    func handleCollision() {
        view?.handleCollision()
    }
    
    func startGame() {
        view?.mainSetup()
    }
    
    func viewLoaded(isViewLoaded: Bool, presentedViewControllerIsNil: Bool) {
        if isViewLoaded == true {
            guard presentedViewControllerIsNil == true else {
                return
            }
            view?.showGameOverAlert()
        }
    }
}
