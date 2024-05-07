//
//  AppUtility.swift
//  GoGuards
//
//  Created by Abhishek Agarwal on 23/08/21.
//  Copyright © 2021 Deepak. All rights reserved.
//

import Foundation
import UIKit

// Screen Size
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let screenBound = UIScreen.main.bounds

let authDict = (NSUSERDEFAULTMANAGER.userData["user"] as? [String: Any]) ?? [String: Any]()

let WINDOWSCENE = UIApplication.shared.connectedScenes.first as? UIWindowScene
let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

let appDelegate = UIApplication.shared.delegate as? AppDelegate
let NSUSERDEFAULTMANAGER = UserDefaultManager.sharedInstance
let NSUSERDEFAULT = UserDefaults.standard
let APPLICATIONWINDOW = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
let appBlueColor = UIColor.init(red: 5/255, green: 54/255, blue: 128/255, alpha: 1.0)

let appGreenColor = UIColor(red: 113/255, green: 213/255, blue: 197/255, alpha: 1.0)

var applicationWindow: UIWindow? {
    if #available(iOS 13, *) {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    } else {
        return UIApplication.shared.keyWindow
    }
}

let deviceUDID = UIDevice.current.identifierForVendor?.uuidString ?? "dslkitriuwerskdfskjd33fdsfs453345fsjfgsdfdsfk"
let deviceName = UIDevice.current.name
let systemVersion = UIDevice.current.systemVersion
let deviceModelName = UIDevice.current.model

func RGBA(_ red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat) -> UIColor {
    return UIColor(red: (red/255.0), green: (green/255.0), blue: (blue/255.0), alpha: alpha)
}

func getIPAddress() -> String {
            var address : String?
            
            // Get list of all interfaces on the local machine:
            var ifaddr : UnsafeMutablePointer<ifaddrs>?
            guard getifaddrs(&ifaddr) == 0 else { return "" }
            guard let firstAddr = ifaddr else { return "" }
            
            // For each interface ...
            for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
                let interface = ifptr.pointee
                
                // Check for IPv4 or IPv6 interface:
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    // Check interface name:
                    let name = String(cString: interface.ifa_name)
                    if  name == "en0" {
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                    &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    } else if (name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3") {
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                    &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(1), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
            
             return address == nil ? "" : address!
        }
