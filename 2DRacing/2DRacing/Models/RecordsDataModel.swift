//
//  RecordsDataModel.swift
//  2DRacing
//
//  Created by Damir Nuriev on 14.02.2024.
//

import UIKit

struct RecordsDataModel: Codable {
    let iconImage: String?
    let nameLabel: String?
    let recordLabel: String?
    let dateLabel: String?
}

final class RecordsData {
    static let shared = RecordsData()
    
    var recordsDataArray: [RecordsDataModel] = []
    
    private init() {}
}
