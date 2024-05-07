//
//  ValidationClass.swift
//  LiquorChacha
//
//  Created by Vishal Mandhyan on 22/06/21.
//

import Foundation

extension ValidateItems {
    
    var validateEmail: String {
        if (self.value.isEmpty) {
            return Validation.emptyEmail
        } else if (self.value.isValidEmail) {
            return ""
        } else {
            return Validation.validEmail
        }
    }
    
    var validateName: String {
        if (self.value.isEmpty) {
            return Validation.emptyName
        } else if (self.value.isValidName) {
            return ""
        } else {
            return Validation.validName
        }
    }
    
    var validateOTP: String {
        if (self.value.isEmpty) {
            return Validation.emptyOTP
        } else if (self.value.count < FieldLength.OTPMAXLENGTH) {
            return Validation.validOTP
        } else {
            return ""
        }
    }
    
    var validatePhone: String {
        if (self.value.isEmpty) {
            return Validation.emptyPhoneNumber
        } else if (self.value.isValidPhone) {
            return ""
        } else {
            return Validation.validPhoneNumber
        }
    }
    
    var validatePassword: String {
        if (self.value.isEmpty) {
            return Validation.emptyPassword.replacingOccurrences(of: "%S", with: self.fieldName?.lowercased() ?? "password")
        } else if (self.value.count < FieldLength.PASSWORDMINLIMIT) {
            return Validation.passworLength.replacingOccurrences(of: "%S", with: self.fieldName?.capitalized ?? "Password")
        } else {
            if (self.comparingValue == nil) {
                return ""
            } else if (self.comparingValue == self.value) {
                return ""
            } else {
                return Validation.passwordMatch
            }
        }
    }
}

extension String {
    
    var isValidZipInUS: Bool {
            let postalcodeRegex = "^[0-9]{5}(-[0-9]{4})?$"
            let pinPred = NSPredicate(format: "SELF MATCHES %@", postalcodeRegex)
            return pinPred.evaluate(with: self)
    }
    var isValidZipInIndia: Bool {
        let postalcodeRegex = "^[0-9]{6}$"
        let pinPred = NSPredicate(format: "SELF MATCHES %@", postalcodeRegex)
        return pinPred.evaluate(with: self)
    }
    
    var isValidEmail: Bool {
      //  let emailRegEx = #"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}"#
        let emailRegEx = #"^\S+@\S+\.\S+$"#
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }

    var isValidPhone: Bool {
          let PHONEREGEX = "^[0-9]{6,10}$"
          let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONEREGEX)
          let result =  phoneTest.evaluate(with: self)
          return result
    }
    
    var isValidName: Bool {
        let nameRegEx = #"^[a-zA-Z-]+ ?.* [a-zA-Z-]+$"#
        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: self)
    }
    
    var isValidOTP: Bool {
        return true
    }
    
    var isValidLength: Bool {
        let lengthPattern = #"^{8,}$"#
        let lengthPred = NSPredicate(format:"SELF MATCHES %@", lengthPattern)
        return lengthPred.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let passwordPattern = #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$"#
//            let passwordPattern =
//                // At least 8 characters
//                 #"(=.{8})"# +
//
//                // At least one capital letter
//                #"(?=.*[A-Z])"# +
//
//                // At least one lowercase letter
//                #"(?=.*[a-z])"# +
//
//                // At least one digit
//                #"(?=.*\d)"# +
//
//                // At least one special character
//                #"(?=.*[@!$%&?._-])"#
            
            let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordPattern)
            return passwordPred.evaluate(with: self)
    }
}
