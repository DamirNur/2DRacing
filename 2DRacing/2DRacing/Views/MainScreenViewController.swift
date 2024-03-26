//
//  MainScreenViewControler.swift
//  2DRacing
//
//  Created by Damir Nuriev on 14.02.2024.
//

import UIKit

private extension CGFloat {
    static let width200: CGFloat = 200.0
    
    static let height50: CGFloat = 50.0
    
    static let constraint300: CGFloat = 300.0
    static let constraint355: CGFloat = 355.0
    static let constraint410: CGFloat = 410.0
}

protocol MainScreenViewProtocol: AnyObject {
    func presentGameViewScreen()
    func presentRecordsViewScreen()
    func presentSettingsViewScreen()
}

final class MainScreenViewControler: UIViewController, MainScreenViewProtocol {
    
    var presenter: IMainScreenPresenter?
    
    private let startButton = UIButton()
    private let recordsButton = UIButton()
    private let settingsButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainScreenPresenter(view: self)
        
        setupMainScreen()
        setupStartButton()
        setupRecordsButton()
        setupSettingsButton()
    }
    
    //MARK: - Functions
    private func setupMainScreen() {
        view.backgroundColor = .white
    }
    
    private func setupStartButton() {
        view.addSubview(startButton)
        startButton.setTitle(Constants.titleStart, for: .normal)
        startButton.backgroundColor = .red
        startButton.setTitleColor(.black, for: .normal)
        startButton.frame = CGRect(x: .zero,
                                   y: .constraint300,
                                   width: .width200,
                                   height: .height50)
        let centerX = (view.frame.width - startButton.frame.width) / 2
        startButton.frame.origin.x = centerX
        startButton.addTarget(self,
                              action: #selector(didTapStartButton),
                              for: .touchUpInside)
    }
    
    @objc private func didTapStartButton() {
        presenter?.startButtonTapped()
    }
    
    private func setupRecordsButton() {
        view.addSubview(recordsButton)
        recordsButton.setTitle(Constants.titleRecords, for: .normal)
        recordsButton.backgroundColor = .red
        recordsButton.setTitleColor(.black, for: .normal)
        recordsButton.frame = CGRect(x: .zero,
                                     y: .constraint355,
                                     width: .width200,
                                     height: .height50)
        let centerX = (view.frame.width - recordsButton.frame.width) / 2
        recordsButton.frame.origin.x = centerX
        recordsButton.addTarget(self,
                                action: #selector(didTapRecordsButton),
                                for: .touchUpInside)
    }
    
    @objc private func didTapRecordsButton() {
        presenter?.recordsButtonTapped()
    }
    
    private func setupSettingsButton() {
        view.addSubview(settingsButton)
        settingsButton.setTitle(Constants.titleSettings, for: .normal)
        settingsButton.backgroundColor = .red
        settingsButton.setTitleColor(.black, for: .normal)
        settingsButton.frame = CGRect(x: .zero,
                                      y: .constraint410,
                                      width: .width200,
                                      height: .height50)
        let centerX = (view.frame.width - settingsButton.frame.width) / 2
        settingsButton.frame.origin.x = centerX
        settingsButton.addTarget(self,
                                 action: #selector(didTapSettingsButton),
                                 for: .touchUpInside)
    }
    
    @objc private func didTapSettingsButton() {
        presenter?.settingsButtonTapped()
    }
    
    func presentGameViewScreen() {
        let vc = StartGameViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func presentRecordsViewScreen() {
        let view = RecordsViewController()
        let presenter = RecordsPresenter()
        let model = RecordsViewModel(recordsData: RecordsData.shared.recordsDataArray)
        
        view.presenter = presenter
        presenter.model = model
        
        navigationController?.pushViewController(view, animated: true)
    }
    
    func presentSettingsViewScreen() {
        let view = SettingsViewController()
        let presenter = SettingsPresenter()
        let model = UserDefaultsService.shared.loadSettings()
        
        view.presenter = presenter
        presenter.view = view
        presenter.model = model
        
        navigationController?.pushViewController(view, animated: true)
    }
}
