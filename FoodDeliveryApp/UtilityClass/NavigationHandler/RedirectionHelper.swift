//
//  RedirectionHelper.swift
//  Swift_MVVM_Boilerplate
//
//  Created by Ravi on 09/01/20.
//  Copyright © 2020 Systango. All rights reserved.
//

import UIKit

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

struct RedirectionHelper {
    
    static func redirectToLogin() {
        DispatchQueue.main.async {
            NSUSERDEFAULTMANAGER.clearCache()
            SCoreDataHelper.shared.clearAllDBData()
            if SCoreDataHelper.shared.currentUser() == nil{
                SCoreDataHelper.shared.createAppUser(params: nil)
            }
            sceneDelegate?.setSideMenu()
//            let loginVC = LoginVC()
//            sceneDelegate?.setUpRootController(controller: loginVC)
        }
    }

    static func redirectToHome() {
//        let homeVC = HomeTabViewController()
//        sceneDelegate?.setUpRootController(controller: homeVC)
    }
}
