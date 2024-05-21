//
//  ApiList.swift
//  appName
//


import Foundation

internal enum APIEndPoint {
    case login
    case socialLogin
    case changePassword
    case forgotPassword
    case notificationList // general user notifications on menu screen
    case addAlert // on job screen
    case alertListForJob
    case getURL
    case logout
    case register
    case termsAndCondition
    case addWorkLocation
    case getLocationList
    case deleteLocation
    case updateLocation
    case walletDetails
    case addAmount
    case userProfile
    case addToUserProfile
    case updateUserProfile
    case getJob
    case getJobDetail
    case cancelJob
    case updateProfile
    case getDocument
    case addDocument
    case deleteDocument
    case updateDocument
    case getSpecialities
    case getJobRoleList
    case getJobTotalPrice
    case createJob
    case getUnitList
    case deleteUnit
    case addUnit
    case createTicket
    case getTicketList
    case getTicketDetail
    case ticketResponse
    case getENotes
    case updateAccount
    case myRatingList
    case privacyData
    case termsData
    case updateAlertType
}

extension APIEndPoint {
    internal func endPoint() -> String {
    switch self {
    case .login:
        return "user/auth/login"
    case .socialLogin:
        return "user/auth/social-login"
    case .changePassword:
        return "user/change-password"
    case .forgotPassword:
        return "user/auth/forgot-password"
    case .notificationList:
        return "notification/user/list" //?jobId=&searchBy=&limit=10&page=1"
    case .addAlert:
        return "alert"
    case .alertListForJob:
        return "alert/"
    case .getURL:
        return "/api/iHim/GetUrl"
    case .logout:
        return "user/auth/logout"
    case .register:
        return "user/auth/register"
    case .termsAndCondition:
        return "user/auth/userAgreement/61d5a264900dda27cef3d2b5"
    case .addWorkLocation:
        return "work-location"
    case .getLocationList:
        return "work-location?page=1&sortBy=asc&limit=10&searchBy=&unitId="
    case .deleteLocation:
        return "work-location/"
    case .updateLocation:
        return "work-location/"
    case .walletDetails:
        return "wallet/user/"
    case .addAmount:
        return "wallet"
    case .userProfile:
        return "user/profile/"
    case .addToUserProfile:
        return "user/profile/"
    case .updateUserProfile:
        return "user/profile/"
    case .updateAlertType:
        return "user/profile/"
    case .getJob:
        return "job/"
    case .updateProfile:
        return "user/auth/updateProfile/"
    case .getDocument:
        return "customer-document"
    case .addDocument:
        return "customer-document"
    case .getSpecialities:
        return "speciality/user/list"
    case .getJobRoleList:
        return "job-role/user/list"
    case .getJobTotalPrice:
        return "job/get/price"
    case .createJob:
        return "job"
    case .getJobDetail:
        return "job/"
    case .cancelJob:
        return "job/"
    case .getUnitList:
        return "unit?page=1&sortBy=asc&limit=10&searchBy="
    case .deleteUnit:
        return "unit/"
    case .addUnit:
        return "unit"
    case .createTicket:
        return "users/ticket"
    case .getTicketList:
        return "users/ticket"
    case .getTicketDetail:
        return "users/ticket"
    case .ticketResponse:
        return "users/ticket"
    case .updateDocument:
        return "customer-document/"
    case .deleteDocument:
        return "customer-document/"
    case .getENotes:
        return "user/e-note/job/"
    case .updateAccount:
        return "user/profile/"
    case .myRatingList:
        return "users/rating/list/dropdown"
    case .privacyData:
        return "static/pages/privacy"
    case .termsData:
        return "/static/pages/terms"
    }
  }
}
