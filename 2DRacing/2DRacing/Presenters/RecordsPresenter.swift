//
//  RecordsPresenter.swift
//  2DRacing
//
//  Created by Damir Nuriev on 16.12.2023.
//

import UIKit

protocol IRecordsPresenter {
    func numberOfRowsInSection(_ section: Int) -> Int
    func cellModelForRow(_ row: Int) -> RecordsCellModel
}

class RecordsPresenter: IRecordsPresenter {
    
    weak var view: RecordsViewProtocol?
    
    init(view: RecordsViewProtocol) {
        self.view = view
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return recordsDataArray.count
    }
    
    func cellModelForRow(_ row: Int) -> RecordsCellModel {
        let record = recordsDataArray[row]
        return RecordsCellModel(
            iconImage: UserImageService.shared.userImageArray[row],
            nameLabel: record.nameLabel ?? "User",
            recordLabel: record.recordLabel ?? "123",
            dateLabel: record.dateLabel ?? "00-00-0000"
        )
    }
}
