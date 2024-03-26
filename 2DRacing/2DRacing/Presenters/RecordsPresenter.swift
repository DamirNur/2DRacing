//
//  RecordsPresenter.swift
//  2DRacing
//
//  Created by Damir Nuriev on 14.02.2024.
//

import Foundation

private extension String {
    static let defaultRecord = "123"
    static let defaultDate = "00-00-0000"
}

protocol IRecordsPresenter {
    func numberOfRowsInSection(_ section: Int) -> Int
    func cellModelForRow(_ row: Int) -> RecordsCellModel
}

final class RecordsPresenter: IRecordsPresenter {
    
    weak var view: RecordsViewProtocol?
    var model: RecordsViewModel?
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        model?.recordsData.count ?? 0
    }
    
    func cellModelForRow(_ row: Int) -> RecordsCellModel {
        let record = model?.recordsData[row]
        return RecordsCellModel(
            iconImage: UserImageService.shared.userImageArray[row],
            nameLabel: record?.nameLabel ?? Constants.defaultName,
            recordLabel: record?.recordLabel ?? .defaultRecord,
            dateLabel: record?.dateLabel ?? .defaultDate
        )
    }
}
