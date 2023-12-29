//
//  RecordsDataModel.swift
//  2DRacing
//
//  Created by Damir Nuriev on 23.12.2023.
//

import UIKit

struct RecordsDataModel: Codable {
    let iconImage: String?
    let nameLabel: String?
    let recordLabel: String?
    let dateLabel: String?
}

var recordsDataArray: [RecordsDataModel] = []
