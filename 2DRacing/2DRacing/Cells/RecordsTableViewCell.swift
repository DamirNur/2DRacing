//
//  RecordsTableViewCell.swift
//  2DRacing
//
//  Created by Damir Nuriev on 16.12.2023.
//

import UIKit

class RecordsTableViewCell: UITableViewCell {
    
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
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    private let recordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
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
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor,constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 25),
            
            recordLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            recordLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
            recordLabel.widthAnchor.constraint(equalToConstant: 150),
            recordLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: recordLabel.trailingAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
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
        nameLabel.text = "User: \(model.nameLabel)"
        recordLabel.text = "Score: \(model.recordLabel)"
        dateLabel.text = model.dateLabel
    }
}
