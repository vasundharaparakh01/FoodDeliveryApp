//
//  ValidationHandler.swift
//  LiquorChacha
//
//  Created by Vishal Mandhyan on 06/07/21.
//

import Foundation

internal func validator(_ itemArray: ValidateItems...) -> (String, FieldType?) {
    
    for item in itemArray {
        do {
           try item.addValidation()
        } catch {
            let message = error as? String ?? ""
            if !message.isEmpty {
                return (message,item.type)
            }
        }
    }
    return ("", nil)
}

extension ValidateItems {
    internal func addValidation () throws {
        
        if (self.isMandatory) {
            if (self.type == .button) {
                
            } else {
                if (self.type == .email) {
                    throw self.validateEmail
                } else if (self.type == .password) {
                    throw self.validatePassword
                } else if (self.type == .otp) {
                    throw self.validateOTP
                } else if (self.type == .name) {
                    throw self.validateName
                } else if (self.type == .phoneNumber) {
                    throw self.validatePhone
                }
            }
        }
    }
}
