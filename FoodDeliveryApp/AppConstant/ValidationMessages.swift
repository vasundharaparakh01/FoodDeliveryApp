//
//  ValidationMessages.swift
//  LiquorChacha
//
//  Created by Vishal Mandhyan on 22/06/21.
//

import Foundation

struct Validation {
// Email
    static let emptyEmail = "Please enter email."
    static let validEmail = "Please enter valid email."
// Password
    static let emptyPassword = "Please enter password."
    static let correctPassword = "Please enter correct password"
    static let passworLength = "Password must be atleast of 8 characters."
    static let oldPassworLength = "Old Password must be atleast of 8 characters."
    static let passwordMatch = "New Password and Confirm Password must be same."
    static let emptyOldPassword = "Please enter old password."
    static let emptyNewPassword = "Please enter new password."
    static let newPasswordLength = "New Password must be atleast of 8 characters."
    static let emptyConfirmPassword = "Please enter confirm password."
    static let confirmPasswordLength = "Confirm Password must be atleast of 8 characters."
// Phone Number
    static let emptyPhoneNumber = "Please enter phone."
    static let validPhoneNumber = "Please enter a valid phone."
    static let PhoneNumberLength = ""
// Name
    static let emptyName = "Please enter name."
    static let validName = "Please enter a valid name."
// OTP
    static let emptyOTP = "Please enter OTP."
    static let validOTP = "Please enter valid OTP."
// Pincode
    static let emptyPincode = ""
    static let pincodeLength = ""
}

struct FieldLength {
    static let PASSWORDMINLIMIT = 8
    static let OTPMAXLENGTH = 6
    static let NAMEMAXLENGTH = 100
    static let PHONEMAXLENGTH = 10
    static let PASSWORDMAXLENGTH = 16
    static let EMAILMAXLENGTH = 64
    static let SEARCHMAXLENGTH = 100
    static let DESCRIPTIONMAXLENGTH = 240
}
