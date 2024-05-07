//
//  ServiceHelper.swift
//  LBMA Gold
//
//  Created by Lalit Kumar Gupta on 24/03/20.
//  Copyright © 2020 Lalit Kumar Gupta. All rights reserved.
//

import UIKit
import MobileCoreServices
import Swime
import CommonCrypto

let NO_INTERNET_CONNECTION = "The Internet connection appears to be offline, please check your Internet connection."
let NO_DATA_FOUND_MESSAGE  = "We didn't find anything to show here."

let timeoutInterval:Double = 200

let ticketDetailApiBaseUrl = "http://103.197.59.202:5011/api/"
//let API_BASE_URL = "http://54.201.160.69:9125/api/v1/"  //UAT URL
let API_BASE_URL = "https://servingfan.com:9125/api/v1/"  //Production URL


struct PAGE {
    var startIndex: Int = 1
    var pageSize: Int = 10
    var totalPage: Int = 1
    
    //    mutating func updatePage(params: Dictionary<String, AnyObject>) {
    //
    //        self.startIndex =  Int((params.validatedValue("page_no" , expected: "1" as AnyObject) as? String)!)!
    //        self.totalPage =   Int((params.validatedValue("max_page_size" , expected: "1" as AnyObject) as? String)!)!
    //    }
}

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}

enum MethodType: CGFloat {
    case get     = 0
    case post    = 1
    case put     = 2
    case delete  = 3
    case patch   = 4
}

class ServiceHelper: NSObject {
    
    //MARK:- Public Functions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    class func request(params: [String: Any],
                       method: MethodType,
                       apiName: String, timeoutInterval: Double = timeoutInterval,
                       completionBlock: ((AnyObject?, Error?, Int)->())?) {
        
        if !(Connectivity.isConnectedToInternet) {
            
            let err  =  NSError.init(domain: "com.ipos", code: 100, userInfo: [NSLocalizedDescriptionKey:NO_INTERNET_CONNECTION]) as Error
            completionBlock!(nil, err, 100)
            return
        }
        
        let requestDict = params
        
        //>>>>>>>>>>> create request
        let url = requestURL(method, apiName: apiName, parameterDict: requestDict)
        
        var request = URLRequest(url: url)
        request.httpMethod = methodName(method)
        request.timeoutInterval = timeoutInterval
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if apiName == "getTicketDetail" || apiName == "getMatch"{
            if let token = USERDEFAULT.value(forKey: kAccessTicketToken){
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }else{
            if let token = USERDEFAULT.value(forKey: kAccessToken){
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }
        
        let jsonData = body(method, parameterDict: requestDict)
        request.httpBody = jsonData
        
        DLog("\n\n Request URL  >>>>>>\(url)")
        DLog("\n\n Request Header >>>>>> \n\(String(describing: request.allHTTPHeaderFields.debugDescription))")
        DLog("\n\n Request Parameters >>>>>>\n\(requestDict.toJsonString())")
        
        // print(" START TIME ===== \(apiName) -- \(Date())")
        request.perform() { (responseObject: AnyObject?, error: Error?, httpResponse: HTTPURLResponse?) in
            
            //        RLog("RESPONSE:  \(String(describing: responseObject))")
            
            //   print(" END TIME ===== \(apiName) -- \(Date())")
            
            guard let block = completionBlock else {
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                guard let httpResponse = httpResponse else {
                    
                    block(responseObject, error, 9999)
                    return
                }
                
                if responseObject != nil {
                    
                    if httpResponse.statusCode == 200 {
                        block(responseObject, error, httpResponse.statusCode)
                        
                    }
//                    else if httpResponse.statusCode == 400 || httpResponse.statusCode == 500 || httpResponse.statusCode == 404 {
//                        let errorResponse = responseObject as! Dictionary<String, Any>
//                        if apiName == "ValidateVPA"{
//                            let err  =  NSError.init(domain: "com.ipos", code: 100, userInfo: [NSLocalizedDescriptionKey:"\(errorResponse["errorDescription"] ?? "Please enter valid UPI ID.")"]) as Error
//                            completionBlock!(nil, err, 100)
//                        }else{
//                            let err  =  NSError.init(domain: "com.ipos", code: 100, userInfo: [NSLocalizedDescriptionKey:"\(errorResponse["errorDescription"] ?? "Something went wrong, please try again.")"]) as Error
//                            completionBlock!(nil, err, 100)
//                        }
//                    }
                    else{
                        if httpResponse.statusCode == 401 {
                            let message = (responseObject as? [String: Any])?["message"] as? String
                            sessionExpired(message: message)
                            return
                        }
                        block(responseObject, error, httpResponse.statusCode)
                    }
                } else {
                    if httpResponse.statusCode == 401 {
                       // let err  =  NSError.init(domain: "com.ipos", code: 100, userInfo: [NSLocalizedDescriptionKey:"You have been logged out because your session has expired, please login again to continue."]) as Error
                       // sessionExpired()
                        let err  =  NSError.init(domain: "com.ipos", code: 100, userInfo: [NSLocalizedDescriptionKey:"Something went wrong."]) as Error
                        block(responseObject, err, httpResponse.statusCode)
                    }else {
                        block(responseObject, error, httpResponse.statusCode)
                    }
                }
            })
        }
    }
    
    
    @objc class func sessionExpired(message: String?){
        let viewController = UIApplication.topViewController()
        let alert = UIAlertController(title: message ?? "Your Session Has Expired!!", message: nil, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default,handler: { _ in
            RedirectionHelper.redirectToLogin()
        }))
        viewController?.present(alert, animated: true)
//        USERDEFAULT.removeObject(forKey: kAccessTokenPrincipal)
//        USERDEFAULT.removeObject(forKey: kEmpCode)
//
//        APPDELEGATE.loginController()
    }
    
    class func multipartApiCall(params: [String: Any],
                                method: MethodType,
                                apiName: String,
                                completionBlock: ((AnyObject?, Error?, Int)->())?) {
        
        if !(Connectivity.isConnectedToInternet) {
            
            let err  =  NSError.init(domain: "com.ipos", code: 100, userInfo: [NSLocalizedDescriptionKey:NO_INTERNET_CONNECTION]) as Error
            completionBlock!(nil, err, 100)
            return
        }
        
        let  requestDict = params
        
        //>>>>>>>>>>> create request
        let url = requestURL(method, apiName: apiName, parameterDict: requestDict)
        
        var request = URLRequest(url: url)
        request.httpMethod = methodName(method)
        //  request.timeoutInterval = timeoutInterval
        
        if let token = USERDEFAULT.value(forKey: kAccessToken){
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        //  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = ServiceHelper.createMultipleBodyWithArray(dictValue: params, boundary: boundary)
        DLog("\n\n Request URL  >>>>>>\(url)")
        
        request.perform() { (responseObject: AnyObject?, error: Error?, httpResponse: HTTPURLResponse?) in
            
            DLog("RESPONSE:  \(String(describing: responseObject))")
            
            guard let block = completionBlock else {
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                guard let httpResponse = httpResponse else {
                    block(responseObject, error, 9999)
                    return
                }
                
                
                if responseObject != nil {
                    //                    if let responseCode =  responseObject![kResponseCode]{
                    //
                    //                        guard responseCode != nil else {
                    //                            let err  =  NSError.init(domain: "com.ipos", code: 100, userInfo: nil) as Error
                    //                            block(responseObject, err, 100)
                    //                            return
                    //                        }
                    //
                    //                        if responseCode as! Int == 501 {
                    //                            if let data = responseObject![kResponseMsg]  {
                    //                                MessageView.showMessage(message: data as! String, time: 4.0, verticalAlignment: .bottom)
                    //                            }
                    //                        }else if responseCode as! Int == 404 {
                    //                            if let data = responseObject![kResponseMsg]  {
                    //                                MessageView.showMessage(message: data as! String, time: 4.0, verticalAlignment: .bottom)
                    //                            }
                    //                            block(responseObject, error, responseCode as! Int)
                    //                            ServiceHelper.perform(#selector(sessionExpired), with: nil, afterDelay: 4.0)
                    //
                    //                        } else if responseCode as! Int == 405 {
                    //
                    //                            if let data = responseObject![kResponseMsg]  {
                    //                                MessageView.showMessage(message: data as! String, time: 4.0, verticalAlignment: .bottom)
                    //                            }
                    //                            block(responseObject, error, responseCode as! Int)
                    //                            ServiceHelper.perform(#selector(sessionExpired), with: nil, afterDelay: 4.0)
                    //
                    //                        } else {
                    //                            block(responseObject, error, responseCode as! Int)
                    //                        }
                    //
                    //                    }else {
                    block(responseObject, error, httpResponse.statusCode)
                    
                } else {
                    block(responseObject, error, httpResponse.statusCode)
                }
            })
        }
        
    }
    
    
    class private func createMultipleBodyWithArray(dictValue : Dictionary<String,Any>,boundary : String) -> Data{
        
        let body = NSMutableData()
        for (key, value) in dictValue {
            if (value is String || value is NSString){
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            } else if (value is Int || value is NSInteger){
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            } else if (value is UIImage) {
                body.appendString("--\(boundary)\r\n")
                let mimetype = "image/png"
                let data = (value as! UIImage).jpegData(compressionQuality: 0.1)
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\("picture\(String(describing: Date().toMillis())).png")\"\r\n")
                body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                body.append(data!)
                body.appendString("\r\n")
            } else if (value is Data) {
                if value as? Data != nil {
                    body.appendString("--\(boundary)\r\n")
                    let swime = Swime.mimeType(data: value as! Data)
                    print("====== \(swime?.mime ?? "") --- \(swime?.ext ?? "")")
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(String(describing: Date().toMillis())).\(swime?.ext ?? "")\"\r\n")
                    body.appendString("Content-Type: \(swime?.mime ?? "")\r\n\r\n")
                    body.append(value as! Data)
                    body.appendString("\r\n")
                }
            }else if(value is URL){
                
                let url = value as! URL
                body.appendString("--\(boundary)\r\n")
                let mimetype = url.mimeTypeForPath()
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(String(describing: Date().toMillis())).\(url.pathExtension)\"\r\n")
                body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                do {
                    let data = try Data.init(contentsOf: url)
                    body.append(data)
                } catch {
                    
                }
                body.appendString("\r\n")
            } else if (value is Bool){
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            } else if (value is Array<String>){
                let arr = value as? Array<String>
                var indexNumber = 0
                for index in arr! {
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(key)[\(indexNumber)]\"\r\n\r\n")
                    //body.appendString("\(index)\r\n")
                    body.appendString(index)
                    body.appendString("\r\n")
                    indexNumber += 1
                }
            }
            else if (value is Array<Data>){
                let arr = value as? Array<Data>
                var indexNumber = 0
                for index in arr! {
                    body.appendString("--\(boundary)\r\n")
                    let swime = Swime.mimeType(data: index)
                    body.appendString("Content-Disposition: form-data; name=\"\(key)[\(indexNumber)]\"; filename=\"\("\(String(describing: Date().toMillis)).\(swime?.ext ?? "")")\"\r\n")
                    body.appendString("Content-Type: \(swime?.mime ?? "")\r\n\r\n")
                    body.append(index)
                    body.appendString("\r\n")
                    indexNumber += 1
                }
            }else if (value is Array<UIImage>){
                let arr = value as? Array<UIImage>
                var indexNumber = 0
                for image in arr! {
                    body.appendString("--\(boundary)\r\n")
                    let mimetype = "image/png"
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\("picture_\(String(describing: Date().toMillis())).png")\"\r\n")
                    body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                    let data = image.jpegData(compressionQuality: 0.1)
                    body.append(data ?? Data())
                    body.appendString("\r\n")
                    indexNumber += 1
                }
            }else if (value is Array<Dictionary<String, Any>>){
                let arr = value as? Array<Dictionary<String, Any>>
                var indexNumber = 0
                for index in arr! {
                    for (newKey, newValue) in index {
                        if (newValue is String || newValue is NSString){
                            body.appendString("--\(boundary)\r\n")
                            body.appendString("Content-Disposition: form-data; name=\"\(key)[\(indexNumber)]\(newKey)\"\r\n\r\n")
                            body.appendString("\(newValue)\r\n")
                        }else if (newValue is Bool){
                            body.appendString("--\(boundary)\r\n")
                            body.appendString("Content-Disposition: form-data; name=\"\(key)[\(indexNumber)]\(newKey)\"\r\n\r\n")
                            body.appendString("\(newValue)\r\n")
                        }else if (newValue is UIImage) {
                            body.appendString("--\(boundary)\r\n")
                            let mimetype = "image/jpg"
                            // let data = UIImageJPEGRepresentation(newValue as! UIImage,0.1)
                            let data  = (newValue as! UIImage).jpegData(compressionQuality: 0.1)
                            body.appendString("Content-Disposition: form-data; name=\"\(key)[\(indexNumber)]\(newKey)\"; filename=\"\("\(String(describing: Date().toMillis)).jpg")\"\r\n")
                            body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                            body.append(data!)
                            body.appendString("\r\n")
                        }else if (newValue is Data){
                            
                            if newValue as? Data != nil {
                                body.appendString("--\(boundary)\r\n")
                                let swime = Swime.mimeType(data: newValue as! Data)
                                
                                body.appendString("Content-Disposition: form-data; name=\"\(key)[\(indexNumber)]\(newKey)\"; filename=\"\("\(String(describing: Date().toMillis)).\(swime?.ext ?? "")")\"\r\n")
                                body.appendString("Content-Type: \(swime?.mime ?? "")\r\n\r\n")
                                body.append(newValue as! Data)
                                body.appendString("\r\n")
                            }
                            
                        }else if(value is URL){
                            
                            let url = value as! URL
                            body.appendString("--\(boundary)\r\n")
                            let mimetype = url.mimeTypeForPath()
                            body.appendString("Content-Disposition: form-data; name=\"\(key)[\(indexNumber)]\(newKey)\"; filename=\"\(String(describing: Date().toMillis)).\(url.pathExtension)\"\r\n")
                            body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                            do {
                                let data = try Data.init(contentsOf: url)
                                body.append(data)
                            } catch {
                                
                            }
                            body.appendString("\r\n")
                    }
                            
                        else if (newValue is Dictionary<String, Any>){
                            let dict = newValue as! Dictionary<String, Any>
                            for (newkey1, newValue1) in dict {
                                if (newValue1 is String || newValue1 is NSString){
                                    body.appendString("--\(boundary)\r\n")
                                    body.appendString("Content-Disposition: form-data; name=\"\(key)[\(indexNumber)][\(newKey)]\(newkey1)\"\r\n\r\n")
                                    body.appendString("\(newValue1)\r\n")
                                }else if (newValue1 is Bool){
                                    body.appendString("--\(boundary)\r\n")
                                    body.appendString("Content-Disposition: form-data; name=\"\(key)[\(indexNumber)][\(newKey)]\(newkey1)\"\r\n\r\n")
                                    body.appendString("\(newValue1)\r\n")
                                }else if (newValue1 is UIImage) {
                                    body.appendString("--\(boundary)\r\n")
                                    let mimetype = "image/jpg"
                                    // let data = UIImageJPEGRepresentation(newValue1 as! UIImage,0.1)
                                    let data = (newValue as! UIImage).jpegData(compressionQuality: 0.1)
                                    body.appendString("Content-Disposition: form-data; name=\"\(key)[\(indexNumber)][\(newKey)]\(newkey1)\"; filename=\"\("\(String(describing: Date().toMillis)).jpg")\"\r\n")
                                    body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                                    body.append(data!)
                                    body.appendString("\r\n")
                                }
                            }
                        }
                    }
                    indexNumber += 1
                }
            }else if (value is Dictionary<String, Any>){
                
                let dataDict = value as! Dictionary<String, Any>
                for (newKey, newValue) in dataDict {
                    if (newValue is String || newValue is NSString){
                        body.appendString("--\(boundary)\r\n")
                        body.appendString("Content-Disposition: form-data; name=\"[\(key)][\(newKey)]\"\r\n\r\n")
                        body.appendString("\(newValue)\r\n")
                    }else if (newValue is Bool){
                        body.appendString("--\(boundary)\r\n")
                        body.appendString("Content-Disposition: form-data; name=\"[\(key)][\(newKey)]\"\r\n\r\n")
                        body.appendString("\(newValue)\r\n")
                    }else if (newValue is UIImage) {
                        body.appendString("--\(boundary)\r\n")
                        let mimetype = "image/jpg"
                        let data = (newValue as! UIImage).jpegData(compressionQuality: 0.1)
                        body.appendString("Content-Disposition: form-data; name=\"[\(key)][\(newKey)]\"; filename=\"\("\(String(describing: Date().toMillis)).jpg")\"\r\n")
                        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                        body.append(data!)
                        body.appendString("\r\n")
                    }
                }
            }
        }
        body.appendString("--\(boundary)--\r\n")
        return body as Data
    }
    
    /// Determine mime type on the basis of extension of a file.
    ///
    /// This requires MobileCoreServices framework.
    ///
    /// - parameter path:         The path of the file for which we are going to determine the mime type.
    ///
    /// - returns:                Returns the mime type if successful. Returns application/octet-stream if unable to determine mime type.
    
    class private func mimeTypeForPath(for path: String) -> String {
        
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream";
    }
    
    //MARK:- Private Functions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    class fileprivate func methodName(_ method: MethodType)-> String {
        
        switch method {
        case .get: return "GET"
        case .post: return "POST"
        case .delete: return "DELETE"
        case .put: return "PUT"
        case .patch: return "PATCH"
            
        }
    }
    
    class fileprivate func body(_ method: MethodType, parameterDict: [String: Any]) -> Data {
        
        // Create json with your parameters
        switch method {
        case .post: fallthrough
        case .patch: fallthrough
        case .delete: fallthrough
        case .put:
            if let data = parameterDict["array"] {
                let array = data as!  Array<Dictionary<String, Any>>
                return   array.toData()
            }else {
                return parameterDict.toData()
            }
        case .get: fallthrough
            
        default: return Data()
        }
    }
    
    class fileprivate func requestURL(_ method: MethodType, apiName: String, parameterDict: [String: Any]) -> URL {
        
        if apiName == "getTicketDetail" || apiName == "getToken" || apiName == "getMatch"{
            let urlString = ticketDetailApiBaseUrl + apiName
            return URL(string: urlString)!
        }
        let urlString = API_BASE_URL + apiName
                
//        if apiName.contains("smsgatewayhub"){
//            let urlString = apiName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//            DLog("URL: \(urlString ?? "")")
//            return URL(string: urlString ?? "")!
//        }else if apiName == "global/mm-lead"{
//            let urlString = "https://apiuat.mccoymart.com/" + apiName
//            return URL(string: urlString)!
//        }else if apiName.contains("seller/web_track_order") {
//            return URL(string: apiName)!
//        }
        
        switch method {
        case .get:
            return getURL(apiName, parameterDict: parameterDict)
            
        case .post: fallthrough
        case .put: fallthrough
        case .patch: fallthrough
        case .delete: fallthrough
        default: return URL(string: urlString)!
        }
    }
    
    class fileprivate func getURL(_ apiName: String, parameterDict: [String: Any]) -> URL {
        
        var urlString = API_BASE_URL + apiName
        
        var isFirst = true
        
        for key in parameterDict.keys {
            
            let object = parameterDict[key]
            
            if object is NSArray {
                
                let array = object as! NSArray
                for eachObject in array {
                    var appendedStr = "&"
                    if (isFirst == true) {
                        appendedStr = "?"
                    }
                    urlString += appendedStr + (key) + "=" + (eachObject as! String)
                    isFirst = false
                }
                
            } else {
                var appendedStr = "&"
                if (isFirst == true) {
                    appendedStr = "?"
                }
                let parameterStr = parameterDict[key] as! String
                urlString += appendedStr + (key) + "=" + parameterStr
            }
            
            isFirst = false
        }
        
        let strUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        DLog("URL: \(urlString)")
        
        return URL(string:strUrl!)!
    }
    
}

extension URLRequest  {
    
    //    mutating func addBasicAuth() {
    //        let authStr = basicAuthUserName + ":" + basicAuthPassword
    //        let authData = authStr.data(using: .ascii)
    //        let authValue = "Basic " + (authData?.base64EncodedString(options: .lineLength64Characters))!
    //        self.setValue(authValue, forHTTPHeaderField: "Authorization")
    //    }
    
    mutating func addAccessParameters(_ apiName: String) {
        
        //self.setValue("TOKEN_VALUE", forHTTPHeaderField: "keyName")
    }
    
    func perform(completionBlock: @escaping (AnyObject?, Error?, HTTPURLResponse?) -> Void) -> Void {
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        //var session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        
        let task = session.dataTask(with: self, completionHandler: {
            (data, response, error) in
            
            
            if let error = error {
                DLog("\n\n error  >>>>>>\n\(error)")
                completionBlock(nil, error, nil)
            } else {
                
                let httpResponse = response as! HTTPURLResponse
                let responseCode = httpResponse.statusCode
                
                DLog("All headers   \(httpResponse.allHeaderFields)")
                //let responseHeaderDict = httpResponse.allHeaderFields
                //Debug.log("\n\n Response Header >>>>>> \n\(responseHeaderDict.debugDescription)")
                DLog("Response Code : \(responseCode))  data count:  \(data?.count ?? 0)")
                
                if let responseString = NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue) {
                    RLog("Response String : \n \(responseString)")
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    //  DLog("\n\n result  >>>>>>\n\(result)")
                    completionBlock(result as AnyObject?, nil, httpResponse)
                } catch {
                    
                    DLog("\n\n error in JSONSerialization")
                    DLog("\n\n error  >>>>>>\n\(error)")
                    
                    if responseCode == 200 {
                        let result = ["Code":"200"]
                        completionBlock(result as AnyObject?, nil, httpResponse)
                    } else {
                        
                        let responseString = NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue)
                        
                        var  message = responseString?.replacingOccurrences(of: "\"", with: "")
                        
                        if message?.isEmpty ?? true {
                            message = "Something went wrong. Please try after some time."
                        }
                        
                        let err  =  NSError.init(domain: "com.ipos", code: 100, userInfo: [NSLocalizedDescriptionKey:message!]) as Error
                        completionBlock(nil, err, httpResponse)
                    }
                }
            }
        })
        task.resume()
    }
}

extension Array {
    
    func toData() -> Data {
        return try! JSONSerialization.data(withJSONObject: self, options: [])
    }
    
    func toJsonString() -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        return jsonString
    }
    
    func get(at index: Index) -> Element? {
        if self.indices.contains(index) {
            return self[index]
        } else {
            return nil
        }
    }
}
extension Dictionary {
    
    func toData() -> Data {
        return try! JSONSerialization.data(withJSONObject: self, options: [])
    }
    
    func toJsonString() -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        return jsonString
    }
    
    func formData() -> Data{
        var isFirst = true
        var urlString = ""
        for key in self.keys {
            let object = self[key]
            
            var appendedStr = "&"
            if (isFirst == true) {
                appendedStr = ""
            }
            let parameterStr = object as! String
            urlString += appendedStr + "\(key)" + "=" + parameterStr
            isFirst = false
        }
        
        print(urlString)
        let data =  urlString.data(using: .utf8)
        return data!
    }
}

extension Data {
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
    
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff",
        0x25 : "application/pdf",
        0xD0 : "application/vnd",
        0x46 : "text/plain",
    ]
    
    var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        
        print("wwwwwww   \(c)")
        
        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
    }
    
    public func sha256() -> String{
        return hexStringFromData(input: digest(input: self as NSData))
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}

extension URL {
    
    func mimeTypeForPath() -> String {
        let pathExtension = self.pathExtension
        
        print(" path extention  :\(pathExtension)")
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
}

func resolutionScale() -> CGFloat {
    return UIScreen.main.scale
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
