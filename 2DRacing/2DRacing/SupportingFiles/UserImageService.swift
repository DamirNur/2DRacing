//
//  UserImageService.swift
//  2DRacing
//
//  Created by Damir Nuriev on 14.02.2024.
//

import UIKit

private extension UIImage {
    static let defaultImage = UIImage(systemName: "person.fill")
}

final class UserImageService {

    static let shared = UserImageService()
    
    var documentsURL = {
        try! FileManager.default.url(for: .documentDirectory,
                                     in: .userDomainMask,
                                     appropriateFor: nil,
                                     create: false)
    }()

    var userImageArray = [UIImage?]()

    private init() { }

    func loadRecordsData() {
        let fileURL = documentsURL.appendingPathComponent(Constants.recordsJSON)

        do {
            let data = try Data(contentsOf: fileURL)
            RecordsData.shared.recordsDataArray = try JSONDecoder().decode([RecordsDataModel].self, from: data)
        } catch {
            print("Error loading recordsDataArray: \(error.localizedDescription)")
        }
    }

    func rewriteUserImageArray() {
        var array: [UIImage?] = []
        for userRecord in RecordsData.shared.recordsDataArray {
            if let iconImage = userRecord.iconImage {
                array.append(getImageFromURL(documentsURL.appendingPathComponent(iconImage)))
            } else {
                array.append(nil)
            }
        }
        UserImageService.shared.userImageArray = array
    }

    private func getImageFromURL(_ url: URL?) -> UIImage? {
        do {
            guard let url = url else { return nil }
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData)
        } catch {
            return nil
        }
    }
    
    func loadImageData(_ fileName: String) -> UIImage? {
        let documentsURL = UserImageService.shared.documentsURL
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading loadImageData: \(error.localizedDescription)")
        }
        return .defaultImage
    }
    
    func saveImageData(_ image: UIImage) {
        let documentsURL = UserImageService.shared.documentsURL
        
        let fileURL = documentsURL.appendingPathComponent(Constants.selectedImage)
        
        do {
            let data = image.jpegData(compressionQuality: 0.2)
            try data?.write(to: fileURL)
        } catch {
            print("Error saving saveImageData: \(error.localizedDescription)")
        }
    }
}
