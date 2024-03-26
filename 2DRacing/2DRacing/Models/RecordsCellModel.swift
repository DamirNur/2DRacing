//
//  RecordsCellModel.swift
//  2DRacing
//
//  Created by Damir Nuriev on 14.02.2024.
//

import UIKit

struct RecordsCellModel {
    let iconImage: UIImage?
    let nameLabel: String
    let recordLabel: String
    let dateLabel: String
}

struct RecordsViewModel {
    var recordsData: [RecordsDataModel] = []
}
