//
//  ApiRequestStructure.swift
//  appName
//


import Foundation
import Alamofire

internal protocol APIRequestType {
    var path: String { get }
    var module: String { get }
    var httpMethod: Alamofire.HTTPMethod { get }
    var encoding: ParameterEncoding { get }
}

private struct APIRequest: APIRequestType {
    var path: String
    var module: String
    var httpMethod: Alamofire.HTTPMethod
    var encoding: ParameterEncoding
}
