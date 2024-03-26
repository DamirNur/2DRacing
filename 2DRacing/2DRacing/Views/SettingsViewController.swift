//
//  SettingsViewControler..swift
//  2DRacing
//
//  Created by Damir Nuriev on 14.02.2024.
//

import UIKit

private extension String {
    static let userNameTitle = "User Name:"
    static let carColorTitle = "Car Color:"
    static let speedTitle = "Speed:"
    static let cameraTitle = "Camera"
    static let mediaLibraryTitle = "Media library"
    static let cancelTitle = "Cancel"
}

private extension CGFloat {
    static let borderWidth1 = 1.0
    
    static let constraint5: CGFloat = 5.0
    static let constraint10: CGFloat = 10.0
    static let constraint16: CGFloat = 16.0
    static let constraint30: CGFloat = 30.0
    static let constraint35: CGFloat = 35.0
    static let constraint65: CGFloat = 65.0
    static let constraint95: CGFloat = 95.0
    static let constraint100: CGFloat = 100.0
    static let constraint110: CGFloat = 110.0
    static let constraint160: CGFloat = 160.0
}

protocol SettingsViewProtocol: AnyObject {
    func updateView(with model: SettingsModel)
}

final class SettingsViewController: UIViewController, SettingsViewProtocol {
    
    var presenter: ISettingsPresenter!
    
    private var settingsModel: SettingsModel? = UserDefaultsService.shared.loadSettings()
    
    private var colorArray = ["red", "yellow", "green", "blue", "black"]
    
    private lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = .borderWidth1
        imageView.layer.borderColor = UIColor.black.cgColor
        return imageView
    }()
    
    private let nameTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.fontSize20)
        label.text = .userNameTitle
        label.textColor = .systemGray
        label.textAlignment = .left
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: Constants.fontSize26)
        textField.textAlignment = .left
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let carColorTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.fontSize20)
        label.text = .carColorTitle
        label.textColor = .systemGray
        label.textAlignment = .left
        return label
    }()
    
    private lazy var carColorTextField: NMTextField = {
        let text = NMTextField(frame: .zero)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: Constants.fontSize26)
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
        label.font = UIFont.systemFont(ofSize: Constants.fontSize20)
        label.text = .speedTitle
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
        label.font = UIFont.systemFont(ofSize: Constants.fontSize20)
        label.textAlignment = .center
        return label
    }()
    
    private var initialSpeed = Constants.minSpeedValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = Constants.titleSettings
        
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
            photoView.topAnchor.constraint(equalTo: view.topAnchor, constant: .constraint100),
            photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoView.widthAnchor.constraint(equalToConstant: .constraint160),
            photoView.heightAnchor.constraint(equalToConstant: .constraint160),
            
            nameTitleLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: .constraint10),
            nameTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .constraint16),
            nameTitleLabel.widthAnchor.constraint(equalToConstant: .constraint110),
            nameTitleLabel.heightAnchor.constraint(equalToConstant: .constraint35),
            
            nameTextField.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: .constraint10),
            nameTextField.leadingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor, constant: .constraint5),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.constraint16),
            nameTextField.heightAnchor.constraint(equalToConstant: .constraint35),
            
            carColorTitleLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: .constraint10),
            carColorTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .constraint16),
            carColorTitleLabel.widthAnchor.constraint(equalToConstant: .constraint95),
            carColorTitleLabel.heightAnchor.constraint(equalToConstant: .constraint35),
            
            carColorTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: .constraint10),
            carColorTextField.leadingAnchor.constraint(equalTo: carColorTitleLabel.trailingAnchor, constant: .constraint5),
            carColorTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.constraint16),
            carColorTextField.heightAnchor.constraint(equalToConstant: .constraint35),
            
            speedTitleLabel.topAnchor.constraint(equalTo: carColorTitleLabel.bottomAnchor, constant: .constraint10),
            speedTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .constraint16),
            speedTitleLabel.widthAnchor.constraint(equalToConstant: .constraint65),
            speedTitleLabel.heightAnchor.constraint(equalToConstant: .constraint35),
            
            speedSlider.topAnchor.constraint(equalTo: carColorTextField.bottomAnchor, constant: .constraint10),
            speedSlider.leadingAnchor.constraint(equalTo: speedTitleLabel.trailingAnchor, constant: .constraint5),
            speedSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.constraint16),
            speedSlider.heightAnchor.constraint(equalToConstant: .constraint35),
            
            speedValueLabel.topAnchor.constraint(equalTo: speedSlider.bottomAnchor),
            speedValueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            speedValueLabel.widthAnchor.constraint(equalToConstant: .constraint100),
            speedValueLabel.heightAnchor.constraint(equalToConstant: .constraint30)
        ])
    }
    
    func updateView(with model: SettingsModel) {
        nameTextField.text = model.userName
        carColorTextField.text = model.carColor
        
        if let selectedImage = UserImageService.shared.loadImageData(model.selectedImageName) {
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
        let actionSheet = UIAlertController(title: nil, 
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let actionCamera = UIAlertAction(title: .cameraTitle, style: .default) { _ in
            self.openCamera()
        }
        
        let actionGallery = UIAlertAction(title: .mediaLibraryTitle, style: .default) { _ in
            self.openMediaLibrary()
        }
        
        let cancelAction = UIAlertAction(title: .cancelTitle,
                                         style: .cancel,
                                         handler: nil)
        
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
        if let selectedColor = carColorTextField.text {
            settingsModel?.carColor = selectedColor
        }
        settingsModel?.userName = nameTextField.text ?? ""
        if let model = settingsModel {
            UserDefaultsService.shared.saveSettings(model)
        }
        view.endEditing(true)
    }
    
    //MARK: - Functions for speedSlider
    private func setupSpeedSlider() {
        speedSlider.addTarget(self, action: #selector(speedSliderValueChanged), for: .valueChanged)
        loadInitialSpeed()
        speedValueLabel.text = String(format: "%.1f", initialSpeed)
        speedSlider.minimumValue = Float(Constants.minSpeedValue)
        speedSlider.maximumValue = Float(Constants.maxSpeedValue)
    }
    
    @objc private func speedSliderValueChanged() {
        updateInitialSpeed()
        settingsModel?.initialSpeed = initialSpeed
        if let model = settingsModel {
            UserDefaultsService.shared.saveSettings(model)
        }
        speedValueLabel.text = String(format: "%.1f", initialSpeed)
    }
    
    private func loadInitialSpeed() {
        if let savedSpeed = settingsModel?.initialSpeed {
            initialSpeed = savedSpeed
            speedSlider.value = Float(initialSpeed)
        }
    }
    
    private func updateInitialSpeed() {
        initialSpeed = CGFloat(speedSlider.value)
    }
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
