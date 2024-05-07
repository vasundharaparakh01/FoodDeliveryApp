//
//  ApplyJobAlertVC.swift
//  GoGuards
//
//  Created by Varun Kumar Raghav on 16/02/22.
//

import UIKit

class LeaveAlertVC: BaseController {

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var okBtn: UIButton!
    @IBOutlet var detailTextView: UITextView!
    @IBOutlet var titleTextField: CustomTextField!
    
    var alertTitle = "Apply Leave"
    var okBtnTitle = "Apply Leave"
    
    var leaveTitle = ""
    var leaveDescription = ""
    
//MARK: - lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()

    }
    //MARK: - initial setup

    func initialMethod() {
        self.initializeHideKeyboard()
        
        detailTextView.delegate = self
        titleTextField.delegate = self
        
        titleLbl.text = alertTitle
        okBtn.setTitle(okBtnTitle, for: .normal)
        detailTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
//MARK: - action and selector methods
    func validateFields() -> Bool {
        if leaveTitle.isEmpty {
            self.toastErrorAtTop("Enter Leave Title")
        } else if leaveDescription.isEmpty {
            self.toastErrorAtTop("Enter Leave Description")
        } else {
            return true
        }
        return false
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okAction(_ sender: Any) {
        self.view.endEditing(true)
        if validateFields() {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
//MARK: - textfield and textview delegate methods
extension LeaveAlertVC: UITextViewDelegate {
    override func textFieldDidEndEditing(_ textField: UITextField) {
        leaveTitle = textField.text ?? ""
    }
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = self.view.viewWithTag(nextTag) as UIResponder?
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        leaveDescription = textView.text ?? ""
    }
}
