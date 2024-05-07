//
//  ViewController.swift
//  LiquorChacha
//
//  Created by Vishal Mandhyan on 22/06/21.
//

import UIKit

class BaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension BaseController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let customTextField = textField as? CustomTextField

        if (customTextField?.fieldType == .email) {
            customTextField?.keyboardType = .emailAddress
        } else if (customTextField?.fieldType == .name) {
            customTextField?.keyboardType = .namePhonePad
        } else if (customTextField?.fieldType == .password) {
            customTextField?.keyboardType = .default
            customTextField?.isSecureTextEntry = true
        } else if (customTextField?.fieldType == .phoneNumber) {
            customTextField?.keyboardType = .phonePad
        } else if (customTextField?.fieldType == .otp) {
            customTextField?.keyboardType = .phonePad
        } else if (customTextField?.fieldType == .search) {
            customTextField?.keyboardType = .default
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let customTextField = textField as? CustomTextField
                
        if ((customTextField?.isFirstResponder) != nil) {
            if customTextField?.textInputMode?.primaryLanguage == nil || customTextField?.textInputMode?.primaryLanguage == "emoji" {
                return false
            }
        }
        
        let fieldText = customTextField?.text ?? ""
        
        guard let stringRange = Range(range, in: fieldText) else { return false }
        let updatedText = fieldText.replacingCharacters(in: stringRange, with: string)

        if (customTextField?.fieldType == .email && updatedText.count > FieldLength.EMAILMAXLENGTH) {
            return false
        } else if (customTextField?.fieldType == .name && updatedText.count > FieldLength.NAMEMAXLENGTH) {
            return false
        } else if (customTextField?.fieldType == .password && updatedText.count > FieldLength.PASSWORDMAXLENGTH) {
            return false
        } else if (customTextField?.fieldType == .phoneNumber && updatedText.count > FieldLength.PHONEMAXLENGTH) {
            return false
        } else if (customTextField?.fieldType == .otp && updatedText.count > FieldLength.OTPMAXLENGTH) {
            return false
        } else if (customTextField?.fieldType == .search && updatedText.count > FieldLength.SEARCHMAXLENGTH) {
            return false
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        // Try to find next responder
        let nextResponder = self.view.viewWithTag(nextTag) as UIResponder?

        if nextResponder != nil {
            // Found next responder, so set it
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }

        return false
    }
}
//MARK: - dissmissing Keyboard on tapping the view
extension BaseController {
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
}
