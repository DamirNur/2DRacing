//
//  StartGameViewController.swift
//  2DRacing
//
//  Created by Damir Nuriev on 14.02.2024.
//

import UIKit

private extension String {
    static let gameOver = "Game Over"
    static let yourScore = "Your score:"
    static let exit = "EXIT"
    static let date = "dd-MM-yyyy"
}

private extension UInt32 {
    static let duration25: UInt32 = 25
    static let duration40: UInt32 = 40
}

private extension Double {
    static let timeInterval002 = 0.02
    static let timeInterval10 = 10.0
}

private extension CGFloat {
    static let width10: CGFloat = 10.0
    static let width70: CGFloat = 70.0
    
    static let height60: CGFloat = 60.0
    static let height70: CGFloat = 70.0
    static let height140: CGFloat = 140.0
    
    static let spacing30: CGFloat = 30.0
    static let spacing35: CGFloat = 35.0
    static let spacing77: CGFloat = 77.0
    static let spacing100: CGFloat = 100.0
    static let spacing120: CGFloat = 120.0
    static let spacing150: CGFloat = 150.0
    static let spacing200: CGFloat = 200.0
    
    static let constraint25: CGFloat = 25.0
    static let constraint50: CGFloat = 50.0
    static let constraint260: CGFloat = 260.0
}

private extension Int {
    static let numberOfDividingLines = 8
    static let numberOfTrees = 6
    static let numberOfCarsReadyToLaunch = 3
}

private extension UIImage {
    static let treeImage = UIImage(systemName: "tree.fill")
}

protocol StartGameViewProtocol: AnyObject {
    func mainSetup()
    func handleCollision()
    func showGameOverAlert()
}

final class StartGameViewController: UIViewController, StartGameViewProtocol {
    
    lazy var presenter: IStartGamePresenter = StartGamePresenter(view: self)
    
    private var settingsModel: SettingsModel? = UserDefaultsService.shared.loadSettings()
    
    private let leftFieldView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    
    private let rightFieldView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    
    private let roadView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private var playerCarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    private var scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.font = UIFont.systemFont(ofSize: Constants.fontSize20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    var score: CGFloat = 0 {
        didSet {
            scoreLabel.text = "\(Int(score))"
        }
    }
    
    private var dividingLineView: [UIView] = []
    
    private var roadsideTreeView: [UIImageView] = []
    
    private var enemyCarsArrayReadyToLaunch: [EnemyCarView] = []
    
    private var enemyCarsArrayLaunched: [EnemyCarView] = []
    
    private var myTimer: Timer?
    
    private var initialSpeed = Constants.minSpeedValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        presenter.startGame()
    }
    
    //MARK: - Movement for moving Views
    func createMovingDividingLineView() {
        let centerX = view.bounds.width / 2
        
        for i in 0..<Int.numberOfDividingLines {
            let movingView = UIView(frame: CGRect(x: centerX - .width10 / 2,
                                                  y: -.height60 - CGFloat(i) * .spacing120,
                                                  width: .width10,
                                                  height: .height60))
            movingView.backgroundColor = UIColor.white
            view.addSubview(movingView)
            dividingLineView.append(movingView)
        }
    }
    
    func createMovingRoadsideTreeView() {
        let leftSpacing = (view.bounds.width / 2) - .spacing200
        let rightSpacing = view.bounds.width - .spacing77
        
        for i in 0..<Int.numberOfTrees {
            let movingImageView = UIImageView(frame: CGRect(x: (i % 2 == 0) ? leftSpacing : rightSpacing,
                                                            y: -.height70 - CGFloat(i) * .spacing150,
                                                            width: .width70,
                                                            height: .height70))
            movingImageView.image = .treeImage
            movingImageView.tintColor = UIColor.gray
            view.addSubview(movingImageView)
            roadsideTreeView.append(movingImageView)
        }
        view.bringSubviewToFront(scoreLabel)
    }
    
    //MARK: - Functions for enemyCars
    func fillEnemyCarsReadyToLaunchArray() {
        for _ in 0...Int.numberOfCarsReadyToLaunch {
            let car = createMovingEnemyCarView()
            view.addSubview(car)
            enemyCarsArrayReadyToLaunch.append(car)
        }
    }
    
    private func createMovingEnemyCarView() -> EnemyCarView {
        let carView = EnemyCarView(frame: CGRect(x: .zero,
                                                 y: -.height140,
                                                 width: .width70,
                                                 height: .height140))
        carView.backgroundColor = UIColor.red
        
        return carView
    }
    
    func spawnEnemyCar() {
        guard !enemyCarsArrayReadyToLaunch.isEmpty else { return }
        
        let car = enemyCarsArrayReadyToLaunch[0]
        
        enemyCarsArrayReadyToLaunch.remove(at: 0)
        enemyCarsArrayLaunched.append(car)
        
        let leftSpacing = (view.bounds.width / 2) - .spacing100
        let rightSpacing = (view.bounds.width / 2) + .spacing30
        let randomXPosition = CGFloat([leftSpacing, rightSpacing].randomElement() ?? leftSpacing)
        
        car.frame.origin.y = -car.frame.size.height
        car.frame.origin.x = randomXPosition
        
        car.ticksBeforeSpawn = UInt(arc4random_uniform(.duration25) + .duration40)
    }
    
    func setupTimerForCars() {
        myTimer = Timer.scheduledTimer(timeInterval: .timeInterval002,
                                       target: self,
                                       selector: #selector(movingEnemyCars),
                                       userInfo: nil,
                                       repeats: true)
    }
    
    @objc func movingEnemyCars() {
        for (index, car) in enemyCarsArrayLaunched.enumerated() {
            if car.ticksBeforeSpawn == 0 {
                if checkCollision(playerCar: playerCarView, object: car) {
                    handleCollision()
                    return
                }
                
                let previousYPosition = car.frame.origin.y
                car.frame.origin.y += initialSpeed
                
                let distanceTraveled = (car.frame.origin.y - previousYPosition) / .spacing100
                score += distanceTraveled
                
                if enemyCarsArrayLaunched[enemyCarsArrayLaunched.count - 1].frame.origin.y > 0 {
                    spawnEnemyCar()
                }
                
                if car.frame.origin.y > view.frame.height {
                    enemyCarsArrayLaunched.remove(at: index)
                    enemyCarsArrayReadyToLaunch.append(car)
                }
            } else {
                car.ticksBeforeSpawn -= 1
            }
        }
    }
    
    //MARK: - Functions for dividingLine, roadsideTree
    func setupTimer() {
        myTimer = Timer.scheduledTimer(timeInterval: .timeInterval002,
                                       target: self,
                                       selector: #selector(movingViews),
                                       userInfo: nil,
                                       repeats: true)
    }
    
    @objc private func movingViews() {
        moveElements(movingElements: dividingLineView)
        moveElements(movingElements: roadsideTreeView)
    }
    
    private func moveElements(movingElements: [UIView]) {
        for movingView in movingElements {
            
            movingView.frame.origin.y += initialSpeed
            
            if movingView.frame.origin.y > view.frame.height {
                movingView.frame.origin.y = -movingView.frame.height
            }
        }
        
        if checkCollision(playerCar: playerCarView, object: leftFieldView)
            || checkCollision(playerCar: playerCarView, object: rightFieldView) {
            handleCollision()
        }
    }
    
    //MARK: - Function for collision
    private func checkCollision(playerCar: UIView, object: UIView) -> Bool {
        return playerCar.frame.intersects(object.frame)
    }
    
    func handleCollision() {
        myTimer?.invalidate()
        myTimer = nil
        
        presenter.viewLoaded(isViewLoaded: isViewLoaded,
                             presentedViewControllerIsNil: presentedViewController == nil)
    }
    
    func showGameOverAlert() {
        let alert = UIAlertController(title: .gameOver, 
                                      message: "\(String.yourScore) \(Int(score))",
                                      preferredStyle: .alert)
        let exitAction = UIAlertAction(title: .exit, style: .default) { _ in
            UserDefaultsService.shared.saveScore(Int(self.score))
            self.dismiss(animated: true, completion: nil)
            self.addInfoToRecordsDataModel()
        }
        alert.addAction(exitAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    deinit {
        myTimer?.invalidate()
        myTimer = nil
    }
    
    //MARK: - Functions for RecordsDataModel
    private func addInfoToRecordsDataModel() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = .date
        let dateString = dateFormatter.string(from: currentDate)
        
        let directory = UserImageService.shared.documentsURL
        let fileURL = directory.appendingPathComponent(Constants.selectedImage)
        
        let imageName = UUID().uuidString
        let imageURL = directory.appendingPathComponent(imageName)
        
        let imageData = try? Data(contentsOf: fileURL)
        try? imageData?.write(to: imageURL)
        
        RecordsData.shared.recordsDataArray.append(RecordsDataModel(iconImage: imageData != nil ? imageName : nil,
                                                                    nameLabel: settingsModel?.userName,
                                                                    recordLabel: "\(Int(score))",
                                                                    dateLabel: dateString))
        saveRecordsData()
    }
    
    private func saveRecordsData() {
        
        let fileURL = UserImageService.shared.documentsURL.appendingPathComponent(Constants.recordsJSON)
        
        do {
            let data = try JSONEncoder().encode(RecordsData.shared.recordsDataArray)
            try data.write(to: fileURL)
        } catch {
            print("Error saving recordsDataArray: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Functions for player Car
    func setupPlayerCarView() {
        view.addSubview(playerCarView)
        
        let viewXPosition = CGFloat(view.bounds.midX - .spacing35)
        let viewYPosition = CGFloat(view.bounds.maxY - .spacing200)
        
        playerCarView.frame = CGRect(x: viewXPosition,
                                     y: viewYPosition,
                                     width: .width70,
                                     height: .height140)
        
        if let selectedColor = settingsModel?.carColor,
           let color = getColorFromName(colorName: selectedColor) {
            playerCarView.backgroundColor = color
        }
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        playerCarView.addGestureRecognizer(panGestureRecognizer)
        playerCarView.isUserInteractionEnabled = true
    }
    
    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if let playerCar = sender.view {
            var newFrame = playerCar.frame
            newFrame.origin.x += translation.x
            newFrame.origin.y += translation.y
            
            newFrame.origin.x = max(.zero, min(view.frame.width - playerCar.frame.width, newFrame.origin.x))
            newFrame.origin.y = max(.zero, min(view.frame.height - playerCar.frame.height, newFrame.origin.y))
            
            playerCar.frame = newFrame
            sender.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    private func getColorFromName(colorName: String) -> UIColor? {
        switch colorName {
        case "red":
            return .red
        case "yellow":
            return .yellow
        case "green":
            return .green
        case "blue":
            return .blue
        case "black":
            return .black
        default:
            return nil
        }
    }
    
    //MARK: - Functions for speed
    func setupTimerForSpeedIncrease() {
        Timer.scheduledTimer(timeInterval: .timeInterval10,
                             target: self,
                             selector: #selector(increaseSpeed),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc private func increaseSpeed() {
        initialSpeed += initialSpeed * Constants.speedIncreaseFactor
        
        if initialSpeed > Constants.maxSpeedValue {
            initialSpeed = Constants.maxSpeedValue
        }
    }
    
    func loadInitialSpeed() {
        if let savedSpeed = settingsModel?.initialSpeed {
            initialSpeed = savedSpeed
        }
    }
    
    func mainSetup() {
        setupTimer()
        setupTimerForCars()
        setupTimerForSpeedIncrease()
        setupConstraintsForFixedElements()
        createMovingDividingLineView()
        createMovingRoadsideTreeView()
        fillEnemyCarsReadyToLaunchArray()
        spawnEnemyCar()
        setupPlayerCarView()
        loadInitialSpeed()
    }
    
    //MARK: - UI for fixed elements
    func setupConstraintsForFixedElements() {
        view.addSubview(roadView)
        view.addSubview(leftFieldView)
        view.addSubview(rightFieldView)
        view.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            roadView.topAnchor.constraint(equalTo: view.topAnchor),
            roadView.widthAnchor.constraint(equalToConstant: .constraint260),
            roadView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            roadView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            leftFieldView.topAnchor.constraint(equalTo: view.topAnchor),
            leftFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftFieldView.trailingAnchor.constraint(equalTo: roadView.leadingAnchor),
            leftFieldView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            rightFieldView.topAnchor.constraint(equalTo: view.topAnchor),
            rightFieldView.leadingAnchor.constraint(equalTo: roadView.trailingAnchor),
            rightFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rightFieldView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scoreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: .constraint50),
            scoreLabel.leadingAnchor.constraint(equalTo: roadView.trailingAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scoreLabel.heightAnchor.constraint(equalToConstant: .constraint25)
        ])
    }
}
