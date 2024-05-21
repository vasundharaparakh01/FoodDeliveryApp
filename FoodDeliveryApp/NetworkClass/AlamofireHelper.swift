//
//  AlamofireHelper.swift
//  appName
//
//  Created by Vishal Mandhyan on 22/06/21.
//

import Alamofire
import SwiftyJSON


typealias APICompletion = (APIResponseType) -> Void
typealias ParsingCompletion<T: Decodable> = (_ modal: Any, _ pagination: PaginationModal?, _ response: APIResponseType) -> Void
class AlamofireHelper: NSObject {
    public static func apiRequest(serviceName endPoint: APIEndPoint, request parameters: [String:Any] = [:], appendStringInURL: String = "", isProgressBarRequired: Bool = true ,isMultipartRequest: Bool = false, httpMethod: HTTPMethod = .get, apiResponseHandler: @escaping APICompletion) {
                    
           if (isProgressBarRequired) {
               startActivityIndicator()
           }
           
           // Add common keys in request parameters
           // Parameters[Constants.UserDefaultsKey.userID] = loggedInUser!.userID

           let requestPath = endPoint.path + appendStringInURL

           // Print Send Request
           print("path:",requestPath,"request:",parameters,"header",endPoint.headers, httpMethod)
        
        if (isMultipartRequest) {
            
            AF.upload(multipartFormData: { multiPart in
                multiPart.makeRequestForMultipart(request: parameters)
            }, to: endPoint.path + appendStringInURL, method: httpMethod == .trace ? endPoint.httpMethod : httpMethod, headers: endPoint.headers)
                .uploadProgress(queue: .main, closure: { progress in
                    // Current upload progress of file
                   //  print("Upload Progress: \(progress.fractionCompleted)")
                })
                .responseJSON(completionHandler: { response in
                    // Do what ever you want to do with response
                    handleResponse(response, apiResponseHandler: apiResponseHandler)
                })
            
        } else {
            AF.request(requestPath, method: endPoint.httpMethod, parameters: parameters, encoding: endPoint.encoding, headers: endPoint.headers).validate().responseJSON {response in
                handleResponse(response, apiResponseHandler: apiResponseHandler)
            }
        }
    }
    
    private static func handleResponse(_ response: AFDataResponse<Any>, apiResponseHandler: @escaping APICompletion) {
        stopActivityIndicator()
        
        switch response.result {
        case .success: do {
            let responseJSON = try JSON(data: response.data!)
            
            // Print Receive Response
            print("response:",responseJSON)
            
            let responseCode = responseJSON[Constants.ServerKey.statusCode].intValue
            //            let isSuccess = responseJSON[Constants.ServerKey.isSuccess].boolValue
            
            if (responseCode >= 200 && responseCode <= 299) {
                apiResponseHandler(APIResponse(body:responseJSON, statusCode: response.response?.statusCode, errorMessage: nil))
            } else {
                let responseMessage = responseJSON[Constants.ServerKey.responseMessage].stringValue
                handleError(responseMessage, responseCode)
            }
        } catch (let parseError) {
            showErrorToast(parseError.localizedDescription)
        }
        case .failure(let resultError): do {
            handleError(resultError.errorMessage, resultError.responseCode)
        }
        }
    }
}

extension AFError {
    fileprivate var errorMessage: String {
        if let underlyingError = self.underlyingError {
            if let urlError = underlyingError as? URLError {
                switch urlError.code {
                case .notConnectedToInternet:
                    return Constants.NetworkError.NOINTERNET
                case .timedOut:
                    return Constants.NetworkError.REQUESTTIMEOUT
                default:
                    return urlError.localizedDescription
                }
            }
        }
        return Constants.NetworkError.WENTWRONG
    }
}

extension AlamofireHelper {
    private static func showErrorToast(_ errorMessage: String) {
        _ = AlertController.alertWithMessage(errorMessage)
    }
    
    private static func handleError(_ message: String, _ statusCode: Int?) {
        // If user is not authorised (session expired, blocked, account deactivate, account deleted)
        if ((statusCode != nil) && (statusCode! == 401)) {
            RedirectionHelper.redirectToLogin()
        }
        
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            _ = AlertController.alertWithMessage(message)
        }
    }
}
