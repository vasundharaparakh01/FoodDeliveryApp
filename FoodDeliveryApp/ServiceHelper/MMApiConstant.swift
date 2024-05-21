//
//  MMApiConstant.swift
//  McCoy_Mart
//
//  Created by Lalit Kumar Gupta on 06/04/20.
//  Copyright © 2020 Lalit Kumar Gupta. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleSignIn

let Device_Name         = "ios"
let Device_Type         = "3"
let kAccessTicketToken  = "AccessTicketToken"
let kAccessToken        = "AccessToken"
let USERDEFAULT = UserDefaults.standard
let kSplashShown        = "SplashShown"

//let newsImageBaseUrl = "http://"
let newsImageBaseUrl = "https://"

let APPDELEGATE =  UIApplication.shared.delegate as! AppDelegate

var currentLocation = CLLocation()

//let GREEN_GOLOR =  RGBA(r: 48, g: 108, b: 28, a: 1)
//let RED_GOLOR =  RGBA(r: 238, g: 91, b: 76, a: 1)
//let YELLOW_GOLOR =  RGBA(r: 249, g: 204, b: 70, a: 1)

public func RGBA(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)-> UIColor{
    return UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: a)
}


@available(iOS 13.0, *)
let KEY_WINDOW = UIApplication.shared.connectedScenes
    .filter({$0.activationState == .foregroundActive})
    .map({$0 as? UIWindowScene})
    .compactMap({$0})
    .first?.windows
    .filter({$0.isKeyWindow}).first

class MMApiConstant: NSObject {

}
