//
//  ApiResponseStructure.swift
//  appName
//
//  Created by Vishal Mandhyan on 27/06/21.
//

import Foundation
import SwiftyJSON

internal protocol APIResponseType {
    var body: JSON { get }
    var header: [String: Any]? { get }
    var statusCode: Int? { get }
    var errorMessage: String? { get }
}

internal struct APIResponse: APIResponseType {
    var body: JSON
    var header: [String: Any]?
    var statusCode: Int?
    var errorMessage: String?
}
