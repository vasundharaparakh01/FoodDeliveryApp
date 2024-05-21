//
//  EndPoints.swift
//  appName
//


import Foundation
import Alamofire

private enum Environment: String {
    case production
    case testing
    case development
}
private let env : Environment = .development

private protocol BaseURL {
    static var baseURL: String { get }
}

private struct APIBuilder {
    static let ApiScheme = "https"
    static var ApiHost: String {
        if env == .development {
            return "go"
        } else if env == .testing {
            return "go"
        } else {
            return "go"
        }
    }
}

extension APIBuilder: BaseURL {
    static var baseURL: String {
        return "\(APIBuilder.ApiScheme)://\(APIBuilder.ApiHost)"
    }
}

extension APIEndPoint: APIRequestType {
    
    var module: String {
        return ""
    }
    
    var userId: String{
        switch self {
        case .walletDetails, .userProfile, .updateUserProfile, .updateAlertType:
            return NSUSERDEFAULTMANAGER.userID
        default:
            return ""
        }
    }
    
    var path: String {
        let endPath = endPoint()
        return APIBuilder.baseURL + module + endPath + userId
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        switch self {
        case .getLocationList, .walletDetails, .getJob, .userProfile, .getDocument, .getSpecialities, .getJobRoleList, .getUnitList, .getTicketList, .getTicketDetail, .getENotes, .notificationList, .alertListForJob, .getJobDetail, .myRatingList, .privacyData, .termsData:
            return .get
        case .deleteLocation, .deleteDocument:
            return .delete
        case .updateUserProfile, .updateDocument, .updateLocation, .cancelJob:
            return .patch
        default:
            return .post
        }
    }
    
    var encoding: ParameterEncoding {
        switch self.httpMethod {
        case .post, .patch:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    var headers: HTTPHeaders {
        
        var auth = HTTPHeader(name: Constants.UserDefaultsKey.authorization, value: "Basic token")
        let contentType = HTTPHeader(name: Constants.contentType, value: "application/json")
        
        switch self {
        case .login, .socialLogin, .register, .forgotPassword, .privacyData, .termsData:
            auth = HTTPHeader(name: Constants.UserDefaultsKey.authorization, value: "Basic token")
        default:
            let authDict = NSUSERDEFAULTMANAGER.userData[Constants.UserDefaultsKey.tokens] as! [String: Any]
            let accessToken = authDict[Constants.ServerKey.accessToken] as! [String: Any]
            let token = accessToken[Constants.ServerKey.token] as! String
            let accessTokenValue = "Bearer "+"\(token)"
            auth = HTTPHeader(name: Constants.UserDefaultsKey.authorization, value: accessTokenValue)
        }
        return [auth, contentType]
    }
}

//        let endPath = endPoint()
//        if endPath == "/v1/user/change-password" {
//            auth = HTTPHeader(name: Constants.UserDefaultsKey.authorization, value: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MWQ1ODUyZjZlZjVlMzE2MzNkNDM4MzciLCJpYXQiOjE2NDEzODg3OTEsImV4cCI6MTY0MTM5MDU5MSwidHlwZSI6ImFjY2VzcyJ9.wZYvwHzSVEDsK6d6gm1TzREUrViPRR1F88yVZuyifwM")
//        }
