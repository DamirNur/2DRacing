//
//  StartGameViewController.swift
//  2DRacing
//
//  Created by Damir Nuriev on 22.11.2023.
//

import UIKit

class EnemyCarView: UIView {
    var isReadyToSpawn: Bool {
        guard let superview = superview else { return false }
        return frame.origin.y >= superview.frame.height
    }
    var ticksBeforeSpawn: UInt = 0
}

class StartGameViewController: UIViewController {
    
    lazy var presenter: IStartGamePresenter = StartGamePresenter(view: self)
    
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
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
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
    
    var myTimer: Timer?
    
    var initialSpeed: CGFloat = 4.0
    var speedIncreaseInterval: TimeInterval = 10.0
    var speedIncreaseFactor: CGFloat = 0.2
    var maxSpeed: CGFloat = 40.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        presenter.startGame()
    }
    
    //MARK: - Movement for moving Views
    func createMovingDividingLineView() {
        let centerX = view.bounds.width / 2
        let viewWidth = 10.0
        let viewHeight = 60.0
        let verticalSpacing = 120.0
        
        for i in 0..<8 {
            let movingView = UIView(frame: CGRect(x: centerX - viewWidth / 2,
                                                  y: -viewHeight - CGFloat(i) * verticalSpacing,
                                                  width: viewWidth,
                                                  height: viewHeight))
            movingView.backgroundColor = UIColor.white
            view.addSubview(movingView)
            dividingLineView.append(movingView)
        }
    }
    
    func createMovingRoadsideTreeView() {
        let leftSpasing = (view.bounds.width / 2) - 200
        let rightSpasing = view.bounds.width - 77
        let viewWidth = 70.0
        let viewHeight = 70.0
        let verticalSpacing = 150.0
        
        for i in 0..<6 {
            let movingImageView = UIImageView(frame: CGRect(x: (i % 2 == 0) ? leftSpasing : rightSpasing,
                                                            y: -viewHeight - CGFloat(i) * verticalSpacing,
                                                            width: viewWidth,
                                                            height: viewHeight))
            movingImageView.image = UIImage(systemName: "tree.fill")
            movingImageView.tintColor = UIColor.gray
            view.addSubview(movingImageView)
            roadsideTreeView.append(movingImageView)
        }
        view.bringSubviewToFront(scoreLabel)
    }
    
    //MARK: - Functions for enemyCars
    func fillEnemyCarsReadyToLaunchArray() {
        for _ in 0...3 {
            let car = createMovingEnemyCarView()
            view.addSubview(car)
            enemyCarsArrayReadyToLaunch.append(car)
        }
    }
    
    private func createMovingEnemyCarView() -> EnemyCarView {
        let viewWidth = 70.0
        let viewHeight = 140.0
        
        let carView = EnemyCarView(frame: CGRect(x: 0,
                                                 y: -viewHeight,
                                                 width: viewWidth,
                                                 height: viewHeight))
        carView.backgroundColor = UIColor.red
        
        return carView
    }
    
    func spawnEnemyCar() {
        guard !enemyCarsArrayReadyToLaunch.isEmpty else { return }
        
        let car = enemyCarsArrayReadyToLaunch[0]
        
        enemyCarsArrayReadyToLaunch.remove(at: 0)
        enemyCarsArrayLaunched.append(car)
        
        let leftSpasing = (view.bounds.width / 2) - 100
        let rightSpasing = (view.bounds.width / 2) + 30
        let randomXPosition = CGFloat([leftSpasing, rightSpasing].randomElement() ?? leftSpasing)
        
        car.frame.origin.y = -car.frame.size.height
        car.frame.origin.x = randomXPosition
        
        car.ticksBeforeSpawn = UInt(arc4random_uniform(25) + 40)
    }
    
    func setupTimerForCars() {
        myTimer = Timer.scheduledTimer(timeInterval: 0.02,
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
                
                let distanceTraveled = (car.frame.origin.y - previousYPosition)/100
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
        myTimer = Timer.scheduledTimer(timeInterval: 0.02,
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
        
        if checkCollision(playerCar: playerCarView, object: leftFieldView) || checkCollision(playerCar: playerCarView, object: rightFieldView) {
            handleCollision()
        }
    }
    
    //MARK: - Function for collision
    private func checkCollision(playerCar: UIView, object: UIView) -> Bool {
        return playerCar.frame.intersects(object.frame)
    }
    
    private func handleCollision() {
        myTimer?.invalidate()
        myTimer = nil
        
        presenter.handleCollision()
    }
    
    func showGameOverAlert(score: Int, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Game Over", message: "Your score: \(score)", preferredStyle: .alert)
        let exitAction = UIAlertAction(title: "EXIT", style: .default) { _ in
            UserDefaults.standard.set(score, forKey: "savedScore")
            self.dismiss(animated: true, completion: completion)
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
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: currentDate)
        
        let directory = UserImageService.shared.documentsURL
        let fileURL = directory.appendingPathComponent("selectedImage")
        
        let imageName = UUID().uuidString
        let imageURL = directory.appendingPathComponent(imageName)
        
        let imageData = try? Data(contentsOf: fileURL)
        try? imageData?.write(to: imageURL)
        
        recordsDataArray.append(RecordsDataModel(iconImage: imageData != nil ? imageName : nil,
                                                 nameLabel: UserDefaults.standard.string(forKey: "userName"),
                                                 recordLabel: "\(Int(score))",
                                                 dateLabel: dateString))
        saveRecordsData()
    }
    
    private func saveRecordsData() {
        
        let fileURL = UserImageService.shared.documentsURL.appendingPathComponent("recordsDataArray.json")
        
        do {
            let data = try JSONEncoder().encode(recordsDataArray)
            try data.write(to: fileURL)
        } catch {
            print("Error saving recordsDataArray: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Functions for player Car
    func setupPlayerCarView() {
        view.addSubview(playerCarView)
        
        let viewWidth = CGFloat(70)
        let viewHeight = CGFloat(140)
        let viewXPosition = CGFloat(view.bounds.midX - 35)
        let viewYPosition = CGFloat(view.bounds.maxY - 200)
        
        playerCarView.frame = CGRect(x: viewXPosition,
                                     y: viewYPosition,
                                     width: viewWidth,
                                     height: viewHeight)
        
        if let selectedColor = UserDefaults.standard.string(forKey: "carColor"),
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
            
            newFrame.origin.x = max(0, min(view.frame.width - playerCar.frame.width, newFrame.origin.x))
            newFrame.origin.y = max(0, min(view.frame.height - playerCar.frame.height, newFrame.origin.y))
            
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
        Timer.scheduledTimer(timeInterval: speedIncreaseInterval,
                             target: self,
                             selector: #selector(increaseSpeed),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc private func increaseSpeed() {
        initialSpeed += initialSpeed * speedIncreaseFactor
        
        if initialSpeed > maxSpeed {
            initialSpeed = maxSpeed
        }
    }
    
    func loadInitialSpeed() {
        if let savedSpeed = UserDefaults.standard.value(forKey: "initialSpeed") as? CGFloat {
            initialSpeed = savedSpeed
        }
    }
    
    //MARK: - UI for fixed elements
    func setupConstraintsForFixedElements() {
        view.addSubview(roadView)
        view.addSubview(leftFieldView)
        view.addSubview(rightFieldView)
        view.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            roadView.topAnchor.constraint(equalTo: view.topAnchor),
            roadView.widthAnchor.constraint(equalToConstant: 260),
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
            
            scoreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            scoreLabel.leadingAnchor.constraint(equalTo: roadView.trailingAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scoreLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
