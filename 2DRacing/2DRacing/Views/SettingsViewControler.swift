//
//  SettingsViewControler..swift
//  2DRacing
//
//  Created by Damir Nuriev on 22.11.2023.
//

import UIKit

protocol SettingsViewProtocol: AnyObject {
    func updateView(with model: SettingsModel)
}

class SettingsViewControler: UIViewController, SettingsViewProtocol {
    
    var presenter: ISettingsPresenter!
    
    var model: SettingsModel = SettingsModel(userName: "", carColor: "", selectedImage: nil, initialSpeed: 0.0)
    
    private var colorArray = ["red", "yellow", "green", "blue", "black"]
    
    private lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UserImageService.shared.loadImageData("selectedImage")
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.black.cgColor
        return imageView
    }()
    
    private let nameTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "User Name:"
        label.textColor = .systemGray
        label.textAlignment = .left
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 26)
        textField.text = UserDefaultsService.shared.loadName()
        textField.textAlignment = .left
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let carColorTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Car Color:"
        label.textColor = .systemGray
        label.textAlignment = .left
        return label
    }()
    
    private lazy var carColorTextField: NMTextField = {
        let text = NMTextField(frame: .zero)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 26)
        text.text = UserDefaultsService.shared.loadCarColor() ?? "blue"
        text.autocorrectionType = .no
        text.tintColor = .clear
        return text
    }()
    
    private lazy var carColorPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    private let speedTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Speed:"
        label.textColor = .systemGray
        label.textAlignment = .left
        return label
    }()
    
    private let speedSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let speedValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private var initialSpeed: CGFloat = 4.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        presenter = SettingsPresenter(view: self)
        presenter.loadModel()
        configureUI()
        addTapOnViewGesture()
        addViewToPickerView()
        addTapOnPhotoView()
        setupSpeedSlider()
    }
    
    //MARK: - Configure UI
    private func configureUI() {
        view.addSubview(photoView)
        view.addSubview(nameTitleLabel)
        view.addSubview(nameTextField)
        view.addSubview(carColorTitleLabel)
        view.addSubview(carColorTextField)
        view.addSubview(speedTitleLabel)
        view.addSubview(speedSlider)
        view.addSubview(speedValueLabel)
        
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoView.widthAnchor.constraint(equalToConstant: 160),
            photoView.heightAnchor.constraint(equalToConstant: 160),
            
            nameTitleLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 10),
            nameTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTitleLabel.widthAnchor.constraint(equalToConstant: 110),
            nameTitleLabel.heightAnchor.constraint(equalToConstant: 35),
            
            nameTextField.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor, constant: 5),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 35),
            
            carColorTitleLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 10),
            carColorTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            carColorTitleLabel.widthAnchor.constraint(equalToConstant: 95),
            carColorTitleLabel.heightAnchor.constraint(equalToConstant: 35),
            
            carColorTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            carColorTextField.leadingAnchor.constraint(equalTo: carColorTitleLabel.trailingAnchor, constant: 5),
            carColorTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            carColorTextField.heightAnchor.constraint(equalToConstant: 35),
            
            speedTitleLabel.topAnchor.constraint(equalTo: carColorTitleLabel.bottomAnchor, constant: 10),
            speedTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            speedTitleLabel.widthAnchor.constraint(equalToConstant: 65),
            speedTitleLabel.heightAnchor.constraint(equalToConstant: 35),
            
            speedSlider.topAnchor.constraint(equalTo: carColorTextField.bottomAnchor, constant: 10),
            speedSlider.leadingAnchor.constraint(equalTo: speedTitleLabel.trailingAnchor, constant: 5),
            speedSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            speedSlider.heightAnchor.constraint(equalToConstant: 35),
            
            speedValueLabel.topAnchor.constraint(equalTo: speedSlider.bottomAnchor),
            speedValueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            speedValueLabel.widthAnchor.constraint(equalToConstant: 100),
            speedValueLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func updateView(with model: SettingsModel) {
        self.model = model
        nameTextField.text = model.userName
        carColorTextField.text = model.carColor
        
        if let selectedImage = model.selectedImage {
            photoView.image = selectedImage
        }
        
        speedSlider.value = Float(model.initialSpeed)
        speedValueLabel.text = String(format: "%.1f", model.initialSpeed)
    }
    
    //MARK: - Functions for photoView
    private func addTapOnPhotoView() {
        let image = photoView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func imageViewTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openCamera()
        }
        
        let actionGallery = UIAlertAction(title: "Media library", style: .default) { _ in
            self.openMediaLibrary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(actionCamera)
        actionSheet.addAction(actionGallery)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func openMediaLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Functions for carColor
    private func addViewToPickerView() {
        carColorTextField.inputView = carColorPickerView
    }
    
    private func addTapOnViewGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if let selectedColor = carColorTextField.text,
           let color = getColorFromName(colorName: selectedColor) {
            UserDefaultsService.shared.saveCarColor(selectedColor)
            UserDefaultsService.shared.saveColor(color, forKey: "selectedColor")
        }
        UserDefaultsService.shared.saveName(nameTextField.text ?? "")
        view.endEditing(true)
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
    
    //MARK: - Functions for speedSlider
    private func setupSpeedSlider() {
        speedSlider.addTarget(self, action: #selector(speedSliderValueChanged), for: .valueChanged)
        loadInitialSpeed()
        speedValueLabel.text = String(format: "%.1f", initialSpeed)
        speedSlider.minimumValue = 4.0
        speedSlider.maximumValue = 40.0
    }
    
    @objc private func speedSliderValueChanged() {
        updateInitialSpeed()
        UserDefaultsService.shared.saveInitialSpeed(initialSpeed)
        speedValueLabel.text = String(format: "%.1f", initialSpeed)
    }
    
    private func loadInitialSpeed() {
        if let savedSpeed = UserDefaults.standard.value(forKey: "initialSpeed") as? CGFloat {
            initialSpeed = savedSpeed
            speedSlider.value = Float(initialSpeed)
        }
    }
    
    private func updateInitialSpeed() {
        initialSpeed = CGFloat(speedSlider.value)
    }
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension SettingsViewControler: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        colorArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        colorArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedColor = colorArray[row]
        carColorTextField.text = selectedColor
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension SettingsViewControler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            photoView.image = selectedImage
            
            UserImageService.shared.saveImageData(selectedImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
