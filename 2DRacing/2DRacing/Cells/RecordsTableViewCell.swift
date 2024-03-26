//
//  RecordsTableViewCell.swift
//  2DRacing
//
//  Created by Damir Nuriev on 14.02.2024.
//

import UIKit

private extension CGFloat {
    static let constraint5: CGFloat = 5
    static let constraint16: CGFloat = 16
    static let constraint25: CGFloat = 25
    static let constraint50: CGFloat = 50
    static let constraint150: CGFloat = 150
}

private extension String {
    static let userText = "User:"
    static let scoreText = "Score:"
}

final class RecordsTableViewCell: UITableViewCell {
    
    static var identifier: String { "\(Self.self)" }
    
    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.fontSize20)
        label.textAlignment = .left
        return label
    }()
    
    private let recordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.fontSize16)
        label.textAlignment = .left
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.fontSize16)
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(recordLabel)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .constraint5),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .constraint16),
            iconImageView.widthAnchor.constraint(equalToConstant: .constraint50),
            iconImageView.heightAnchor.constraint(equalToConstant: .constraint50),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .constraint5),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor,constant: .constraint5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.constraint16),
            nameLabel.heightAnchor.constraint(equalToConstant: .constraint25),
            
            recordLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            recordLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .constraint5),
            recordLabel.widthAnchor.constraint(equalToConstant: .constraint150),
            recordLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.constraint5),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: recordLabel.trailingAnchor, constant: .constraint5),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.constraint16),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.constraint5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        nameLabel.text = nil
        recordLabel.text = nil
        dateLabel.text = nil
    }
    
    func configure(with model: RecordsCellModel) {
        iconImageView.image = model.iconImage
        nameLabel.text = "\(String.userText) \(model.nameLabel)"
        recordLabel.text = "\(String.scoreText) \(model.recordLabel)"
        dateLabel.text = model.dateLabel
    }
}
