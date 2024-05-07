//
//  CancelJobAlertVC.swift
//  GoGuards
//
//  Created by Varun Kumar Raghav on 16/02/22.
//

import UIKit
import DropDown

protocol AlertDelegateProtocol {
    func alertResponse(message: String)
}

class CancelJobAlertVC: BaseController {
    
    @IBOutlet var okBtn: UIButton!
    @IBOutlet var detailTextView: UITextView!
    @IBOutlet var selectJobBtn: UIButton!
    var reasonDropDown: DropDown?
    var delegate: AlertDelegateProtocol? = nil

    var okBtnTitle = "Cancel Job"
    
    var cancelReason = ""
    
    //MARK: - lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
        
    }
    //MARK: - initial setup
    
    func setupDropDown(_ dropDown: DropDown, _ dataSource: [String], _ label: UILabel?, _ button: UIButton?) {
        label?.text = dataSource[0]
        dropDown.anchorView = button
        dropDown.dataSource = dataSource
        dropDown.selectionAction = { [unowned self] (index, item) in
                cancelReason = item
                button?.setTitle(item, for: .normal)
        }
    }
    @IBAction func dropDownBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
            reasonDropDown = DropDown()
            setupDropDown(reasonDropDown!, ["Change My Mind","Too Costly"], nil, selectJobBtn)
        reasonDropDown!.show()
        
    }
    func initialMethod() {
        self.initializeHideKeyboard()
        
        detailTextView.delegate = self
        okBtn.setTitle(okBtnTitle, for: .normal)
        detailTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    //MARK: - action and selector methods
    func validateFields() -> Bool {
        if cancelReason.isEmpty {
            self.toastErrorAtTop("Please Provide The Reason")
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
            self.delegate?.alertResponse(message: cancelReason)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
//MARK: - textfield and textview delegate methods
extension CancelJobAlertVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        cancelReason = textView.text ?? ""
    }
}
