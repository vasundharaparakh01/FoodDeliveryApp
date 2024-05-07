//
//  Debug.swift
//  iPOS
//
//  Created by Quay Intech on 8/21/18.
//  Copyright © 2018 Quay Intech. All rights reserved.
//

import UIKit

let debug = true
public func DLog(_ message: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
    if debug {
    let className = (fileName as NSString).lastPathComponent
        print("<\(className)> \(functionName) [#\(lineNumber)]| : \(message)\n")
    }
}

let isResponseLogEnable = true
public func RLog(_ message: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
    if isResponseLogEnable {
        let className = (fileName as NSString).lastPathComponent
        print("<\(className)> \(functionName) [#\(lineNumber)]| : \(message)\n")
    }
}


