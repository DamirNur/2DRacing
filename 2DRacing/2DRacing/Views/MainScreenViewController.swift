//
//  MainScreenViewControler.swift
//  2DRacing
//
//  Created by Damir Nuriev on 21.11.2023.
//

import UIKit

class MainScreenViewControler: UIViewController {
    
    lazy var presenter: IMainScreenPresenter = MainScreenPresenter(view: self)
    
    private let startButton = UIButton()
    private let recordsButton = UIButton()
    private let settingsButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        startButton.setTitle("Start", for: .normal)
        startButton.backgroundColor = .red
        startButton.setTitleColor(.black, for: .normal)
        startButton.frame = CGRect(x: .zero, y: 300, width: 200, height: 50)
        let centerX = (view.frame.width - startButton.frame.width) / 2
        startButton.frame.origin.x = centerX
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
    }
    
    @objc private func didTapStartButton() {
        let vc = StartGameViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    private func setupRecordsButton() {
        view.addSubview(recordsButton)
        recordsButton.setTitle("Records", for: .normal)
        recordsButton.backgroundColor = .red
        recordsButton.setTitleColor(.black, for: .normal)
        recordsButton.frame = CGRect(x: .zero, y: 355, width: 200, height: 50)
        let centerX = (view.frame.width - recordsButton.frame.width) / 2
        recordsButton.frame.origin.x = centerX
        recordsButton.addTarget(self, action: #selector(didTapRecordsButton), for: .touchUpInside)
    }
    
    @objc private func didTapRecordsButton() {
        let vc = RecordsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupSettingsButton() {
        view.addSubview(settingsButton)
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.backgroundColor = .red
        settingsButton.setTitleColor(.black, for: .normal)
        settingsButton.frame = CGRect(x: .zero, y: 410, width: 200, height: 50)
        let centerX = (view.frame.width - settingsButton.frame.width) / 2
        settingsButton.frame.origin.x = centerX
        settingsButton.addTarget(self, action: #selector(didTapSettingsButton), for: .touchUpInside)
    }
    
    @objc private func didTapSettingsButton() {
        let vc = SettingsViewControler()
        navigationController?.pushViewController(vc, animated: true)
    }
}

