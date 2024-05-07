//
//  ViewControllerExtension.swift
//  Go_Guard_Customer
//
//  Created by Varun Kumar Raghav on 05/05/22.
//

import Foundation
import UIKit

extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    enum STORYBOARD: String {
        case Main                   = "Main"
    }
    
    class func controller(storyboard:STORYBOARD, identifire:String) -> UIViewController {
        let storyboard = UIStoryboard.init(name: storyboard.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifire)
    }
}

extension UITextField {
    
    // Use to set the left padding space in px
    func leftPaddingPoints(width:CGFloat){
        self.leftView = nil
        DispatchQueue.main.async {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.size.height))
            paddingView.backgroundColor = .clear
            self.leftView = paddingView
            self.leftViewMode = .always
        }
    }
    
    func leftPaddingWithImage(width:CGFloat, image:UIImage){
        
        self.leftView = nil
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.size.height))
        paddingView.backgroundColor = .clear
        let btn =   UIButton.init(type: .custom)
        btn.frame = CGRect(x: 5, y: 0, width: width - 10, height: self.frame.size.height)
        btn.backgroundColor = .clear
        btn.setImage(image, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        btn.isUserInteractionEnabled = false
        paddingView.addSubview(btn)
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    // use to set right padding space in px
    func rightPaddingPoints(width:CGFloat) {
        
        self.rightView = nil
        DispatchQueue.main.async {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.size.height))
            paddingView.backgroundColor = .clear
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
    
    func rightPaddingWithImage(width:CGFloat, image:UIImage){
        
        self.rightView = nil
        let btn =   UIButton.init(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        btn.backgroundColor = .clear
        btn.setImage(image, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        btn.isUserInteractionEnabled = false
        self.rightView = btn
        self.rightViewMode = .always
    }
    
    func hideKeyboard(){
        self.inputView = UIView()
        self.inputAccessoryView = nil
    }
    
    func addDoneButtonToolBar() -> UIToolbar! {
        
        if self.keyboardType == .decimalPad || self.keyboardType == .phonePad || self.keyboardType == .numberPad  || self.keyboardType == .numbersAndPunctuation{
        let toolBar = UIToolbar()
        toolBar.frame = CGRect.init(x: 0, y: 0, width: 300, height: 40)
        
        let doneBtn =  UIBarButtonItem.init(title: (self.returnKeyType == .next) ? "Next" : "Done", style: .plain, target: self, action: #selector(dissmissKeyboard))
        let space = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.tintColor = .darkGray
        toolBar.items = [space, doneBtn]
        return toolBar
        }else {
            return nil
        }
    }
    
    func nextFieldBecomeFirstResponder(){
        if self.returnKeyType == .next {
            if let nextField = self.superview?.viewWithTag(self.tag + 1) as? UITextField {
                nextField.becomeFirstResponder()
            } else {
                self.resignFirstResponder()
            }
        }else {
            self.resignFirstResponder()
        }
    }
    
    @objc fileprivate func dissmissKeyboard(){
        self.nextFieldBecomeFirstResponder()
   // UIApplication.shared.keyWindow?.endEditing(true)
    }
    
}

// MARK: - UIApplication extension
extension UIApplication {
    
    internal class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(top)
            } else if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        
        return base
    }
}
