//
//  AlertClass.swift
//  LiquorChacha
//
//  Created by Vishal Mandhyan on 22/06/21.
//

import Foundation
import UIKit
import Loaf

extension UIViewController {
    internal func toastErrorAtTop(_ message: String) {
          Loaf(message, state: .error ,location: .top, presentingDirection: .vertical, sender: self).show(.short)
      }
    internal func toastSuccessAtTop(_ message: String) {
          Loaf(message, state: .success ,location: .top, presentingDirection: .vertical, sender: self).show(.short)
      }
}

open class AlertController {
    
    // MARK: - Singleton
    class var instance : AlertController {
        struct Static {
            static let singletonInstance : AlertController = AlertController()
        }
        return Static.singletonInstance
    }
    
    // MARK: - Functions to get the top controller
    fileprivate func topMostController() -> UIViewController? {
        
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let presented = presentedVC?.presentedViewController {
            presentedVC = presented
        }
        
        if presentedVC == nil {
            // print("AlertController Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
        }
        return presentedVC
    }
}

extension AlertController {
    open class func toastWithTitle(_ title: String, controller: UIViewController) {
//        let test =  SwiftToast(
//                            text: title,
//                            textAlignment: .left,
//                            image: UIImage(named: "alert"),
//                            backgroundColor: UIColor.init(red: 33/255, green: 138/255, blue: 176/255, alpha: 1.0),
//                            textColor: .white,
//                            font: .boldSystemFont(ofSize: 15.0),
//                            duration: 2.0,
//                            minimumHeight: CGFloat(60.0),
//                            statusBarStyle: .lightContent,
//                            aboveStatusBar: true,
//                            target: nil,
//                            style: .navigationBar)
//        controller.present(test, animated: true)
    }
    
    // MARK: - Class Functions
    open class func alertWithTitle(_ title: String) -> UIAlertController {
        return alert(title, message: "")
    }
    
    // MARK: - Class Functions
    open class func alertWithMessage(_ message: String) -> UIAlertController {
        return alert("", message: message)
    }
    
    open class func alert(_ title: String, message: String) -> UIAlertController {
        return alert(title, message: message, acceptMessage: "OK") { () -> Void in
            // Do nothing
        }
    }
    
    open class func alert(_ title: String, message: String, acceptMessage: String, acceptBlock: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let acceptButton = UIAlertAction(title: acceptMessage, style: .default, handler: { (_ : UIAlertAction) in
            acceptBlock()
        })
        alert.addAction(acceptButton)
        
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    open class func alert(_ title: String, message: String,controller : AnyObject, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
        controller.present(alert, animated: true, completion: nil)
        return alert
    }
}

private extension UIAlertController {
    
    convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) {
        
        self.init(title: title, message: message, preferredStyle:preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            let action = UIAlertAction(title: buttonTitle, preferredStyle: .default, buttonIndex: buttonIndex, tapBlock: tapBlock)
            buttonIndex += 1
            self.addAction(action)
        }
    }
}

extension AlertController {
    open class func actionSheet(_ title: String, message: String, sourceView: UIView, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        for action in actions {
            alert.addAction(action)
        }
        
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    open class func actionSheet(_ title: String, message: String, sourceView: UIView, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet, buttons: buttons, tapBlock: tapBlock)
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
}

private extension UIAlertAction {
    convenience init(title: String?, preferredStyle: UIAlertAction.Style, buttonIndex:Int, tapBlock:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title, style: preferredStyle) { (action:UIAlertAction) in
            if let block = tapBlock {
                block(action,buttonIndex)
            }
        }
    }
}
