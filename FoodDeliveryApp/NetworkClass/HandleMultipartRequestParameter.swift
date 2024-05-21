//
//  HandleMultipartRequestParameter.swift
//  appName
//


import Foundation
import Alamofire

struct MultipartMimeType {
    static let imageMimeType = "image/jpg"
    static let pdfMimeType = "application/pdf"
    static let videoMimeType = "video/mp4"
}

struct MultipartDataFormate {
    static let imageFormate = ".jpg"
    static let pdfFormate = "pdf"
    static let videoFormate = "mp4"
}

extension MultipartFormData {
    
    func makeRequestForMultipart(request parameters: [String: Any] = [:]) {
        for (key, dictionaryElement) in parameters {
                self.addKeyValueInMultipartForm(key: key, value: dictionaryElement)
        }
    }

    private func addKeyValueInMultipartForm(key: String, value: Any) {
        if let valueInString = value as? String {
            self.addStringInMultipartForm(key: key, value: valueInString)
        } else if let valueInInt = value as? Int {
            let valueInInt = "\(valueInInt)"
            self.addStringInMultipartForm(key: key, value: valueInInt)
        } else if let valueInImage = value as? UIImage {
            self.addImageInMultipartForm(key: key, image: valueInImage)
        } else if let valueInArray = value as? NSArray {
            for (index, arrayElement) in valueInArray.enumerated() {
                let arrayKey = key + "[\(index)]"
                self.addKeyValueInMultipartForm(key: arrayKey, value: arrayElement)
            }
        } else if let valueInDictionary = value as? NSDictionary {
            for (dictionaryKey, dictionaryElement) in valueInDictionary {
                self.addKeyValueInMultipartForm(key: dictionaryKey as? String ?? "", value: dictionaryElement)
            }
        }
    }
    
    private func addStringInMultipartForm(key: String, value: String) {
        self.append(value.data(using: .utf8)!, withName: key)
    }
    
    private func addImageInMultipartForm(key: String, image: UIImage) {
        self.append(image.jpegData(compressionQuality: 1.0)!, withName: key, fileName: key + Date().timestamp() + ".jpg", mimeType: "image/jpg")
    }
}
