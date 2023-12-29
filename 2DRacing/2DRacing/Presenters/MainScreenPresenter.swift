//
//  MainScreenPresenter.swift
//  2DRacing
//
//  Created by Damir Nuriev on 16.12.2023.
//

import Foundation

protocol IMainScreenPresenter {
    
}

class MainScreenPresenter: IMainScreenPresenter {
    
    weak var view: MainScreenViewControler?
    
    init(view: MainScreenViewControler) {
        self.view = view
    }
}
