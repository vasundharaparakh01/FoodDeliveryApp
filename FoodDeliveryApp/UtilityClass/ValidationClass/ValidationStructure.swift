//
//  ValidationStructure.swift
//  LiquorChacha
//
//  Created by Vishal Mandhyan on 06/07/21.
//

import Foundation

internal enum FieldType: String {
    case email
    case password
    case confirmPassword
    case newPassword
    case otp
    case phoneNumber
    case name
    case address
    case search
    case button
}

// internal enum StringOrInt {
//    case string(String)
//    case int(Int)
// }

enum ValidationError: Error {
    case message(String)
}

internal protocol ValidationItemProtocol {
    var type: FieldType { get set }
    var fieldName: String? { get set }
    var isMandatory: Bool { get set }
    var value: String { get set }
    var comparingValue: String? { get set }
}

struct ValidateItems: ValidationItemProtocol {
    var type: FieldType
    var fieldName: String?
    var isMandatory: Bool = true
    var value: String = ""
    var comparingValue: String?
}

extension String: Error {}
