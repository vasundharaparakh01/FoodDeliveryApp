//
//  AppConstants.swift
//  LiquorChacha
//
//  Created by Vishal Mandhyan on 22/06/21.
//

import Foundation
import UIKit

// Screen Size
let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
let ScreenBound = UIScreen.main.bounds


let AppShadowColor = UIColor.init(red: 228/255, green: 235/255, blue: 240/255, alpha: 1.0)

let GrayShadowColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)


struct Constants {
    static let appName = "GoGuard_Customer"
    static let deviceType = 1 // iOS
    static let contentType = "Content-Type"
    static let deviceTypeKey = "deviceType"
    static let deviceName = "deviceName"
    static let networkIP = "ip"
    
    
    static let SOCKET_URL = ""
    static let IMAGE_URL = ""

    struct BundleKey {
        static let bundleShortVersions = "CFBundleShortVersionString"
        static let bundleVersion = "CFBundleVersion"
    }
        
    // MARK: - User Default Keys
    struct UserDefaultsKey {
        static let deviceID = "deviceId"
        static let deviceToken = "deviceToken"
        static let userID = "userId"
        static let token = "token"
        static let tokens = "tokens"
        static let authorization = "Authorization"
        static let refresh = "refresh"
    }
    
    // MARK: - KeyChain Keys
    struct KeyChainKey {
        static let deviceUDID = "keychainDeviceUDID"
    }
    
    // MARK: - Server Keys
    struct ServerKey {
        static let socialId = "socialId"
        static let socialType = "socialType"

        static let docs = "docs"
        static let user = "user"
        static let responseMessage = "message"
        static let isSuccess = "isSuccess"
        static let statusCode = "code"
        static let result = "result"
        static let data = "data"
        static let userInfo = "userInfo"
        static let id = "id"
        static let refreshToken = "refreshToken"
        static let tokens = "tokens"
        static let token = "token"
        static let accessToken = "access"
        static let locationName = "locationName"
        static let unitNumber = "unitNumber"
        static let building = "building"
        static let street = "street"
        static let city = "city"
        static let province = "province"
        static let postalCode = "postalCode"
        static let lat = "lat"
        static let long = "long"
        static let userId = "userId"
        static let unitId = "unitId"
        static let contactPerson = "contactPerson"
        static let contactNumber = "contactNumber"
        
        static let status = "status"
        static let responseError = "responseError"
        static let responseCode = "responseCode"
        static let authorization = "authorization"
        static let authKey = "authKey"
        static let userName = "userName"
        static let image = "image"
        static let deviceType = "deviceType"
        static let phoneNumber = "phone"
        static let mobileNumber = "mobileNumber"
        static let profileImage = "profileImage"
        static let otp = "otp"
        static let bankLogo = "bank_logo"
        static let rSAID = "ID"
        static let requestUserID = "id"
        static let userID = "userId"
        static let employer = "employer"
        static let gender = "gender"
        static let lastName = "lastName"
        static let middleName = "middleName"
        static let firstName = "firstName"
        static let surName = "surName"
        static let membershipNo = "membershipNo"
        static let isMember = "isMember"
        static let employeeNumber = "employeeNumber"
        static let isStatus = "isStatus"
        static let email = "email"
        static let title = "title"
        static let jobId = "jobId"
        static let sound = "sound"
        static let notification = "notification"
        static let pagination = "pagination"
        static let deleteType = "deleteType"
        static let notificationId = "notificationId"
        static let search = "search"
        static let description = "description"
        static let notificationID = "notificationID"
        static let dataId = "dataId"
        static let isCompleted = "is_completed"
        static let questionID = "questionID"
        static let answerID = "answerID"
        static let answerText = "answerText"
        static let answer = "answer"

        // User Info
        static let emailID = "email"
        static let name = "name"
        static let dob = "dob"
        static let registerAs = "registerAs"
        static let deviceToken = "deviceToken"


        // Pagination
        static let pageNumber = "pageNumber"
        static let pageSize = "pageSize"
        static let maxPages = "maxPages"
        static let totalRecords = "totalRecords"
        static let page = "page"
        static let sortBy = "sortBy"
        static let limit = "limit"
        static let searchBy = "searchBy"
        static let jobType = "jobType"
        static let isComplete = "isComplete"
        
        // Change Password
        static let newPassword = "newPassword"
        static let oldPassword = "oldPassword"
        static let password = "password"
        
        // Static Pages
        static let type = "type"
        static let url = "url"
        static let privacyAgreement = "isPrivacyAgreement"
        static let termsofUse = "isTermsOfUse"
        
    }
    struct UnitKeys {
        static let locationName = "locationName"
        static let locationType = "locationType"
        static let locationId = "locationId"
        static let regNum = "businessRegistraionNumber"
        static let HSTNo = "HSTNo"
        static let contactPerson = "contactPerson"
        static let email = "email"
        static let mobileNumber = "mobileNumber"
        static let password = "password"
        static let lat = "lat"
        static let long = "long"
        static let businessProofDocuments = "businessProofDocuments"
        static let businessDocument = "businessDocument"
        static let userId = "userId"
        static let businessRegistrationNumber = "businessRegistrationNumber"
        static let businessHSTno = "HSTNo"

    }
    
    struct JobKey {
        static let jobTitle = "jobTitle"
        static let locationID = "locationId"
        static let jobType = "jobType"
        static let description = "description"
        static let transportation = "transportation"
        static let dressCode = "dressCode"
        static let rotation = "rotation"
        static let noOfGaurd = "noOfGaurd"
        static let shifPerDay = "shifPerDay"
        static let customDates = "customDates"
        static let gaurdProfile = "gaurdProfile"
        static let jobDate = "jobDate"
        static let jobEndDate = "jobEndDate"
        static let shifts = "shifts"
        static let noOfShifts = "noOfShifts"
        static let isTravelTo = "isTravelTo"
        static let workSpecialities = "workSpecialities"
        static let transportType = "isGoWith"
        static let vestSize = "vestSize"

    }
    struct RegistrationKey {
        static let idNumber = "idNumber"
        static let idProof = "idProof"
        static let idType = "idType"
        static let fileName = "fileName"
        static let identityDocuments = "identityDocuments"
        static let profileImage = "profileImage"
        static let businessName = "businessName"
        static let businessRegisterNumber = "businessRegisterNumber"
        static let businessType = "businessType"
        static let businessHSTno = "HSTNo"
        static let businessDetails = "businessDetails"
        static let businessDocumentType = "businessDocumentType"
        
    }
    
    struct NetworkError {
        static let NOINTERNET = "The Internet connection appears to be offline."
        static let REQUESTTIMEOUT = "The request timed out."
        static let WENTWRONG = "Something went wrong. Please try again later."
    }
}
