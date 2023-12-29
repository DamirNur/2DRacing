//
//  StartGamePresenter.swift
//  2DRacing
//
//  Created by Damir Nuriev on 18.12.2023.
//

import UIKit

protocol IStartGamePresenter {
    func startGame()
    func handleCollision()
}

class StartGamePresenter: IStartGamePresenter {
    
    weak var view: StartGameViewController?
    
    init(view: StartGameViewController) {
        self.view = view
    }
    
    func handleCollision() {
        
        if view?.isViewLoaded == true, let window = view?.view.window {
            guard view?.presentedViewController == nil else {
                return
            }
            if let score = view?.score {
                view?.showGameOverAlert(score: Int(score)) { }
            }
        }
    }
    
    func startGame() {
        view?.setupTimer()
        view?.setupTimerForCars()
        view?.setupTimerForSpeedIncrease()
        view?.setupConstraintsForFixedElements()
        view?.createMovingDividingLineView()
        view?.createMovingRoadsideTreeView()
        view?.fillEnemyCarsReadyToLaunchArray()
        view?.spawnEnemyCar()
        view?.setupPlayerCarView()
        view?.loadInitialSpeed()
    }
}
