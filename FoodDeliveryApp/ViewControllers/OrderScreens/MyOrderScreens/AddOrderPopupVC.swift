//
//  AddOrderPopupVC.swift
//  FanServe
//
//  Created by McCoy Mart on 06/06/22.
//

import UIKit

class AddOrderPopupVC: UIViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var orderIdTextfield: CustomTextField!
    
    typealias AddOrderCompletionBlock = (Bool,String) -> Void
    var block : AddOrderCompletionBlock?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnView)))
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnView)))
    }
    
    @objc func tapOnView(){
        
        self.view.endEditing(true)
    }
    
    func setCompletionBlock(onCompletion:@escaping AddOrderCompletionBlock) {
        block = onCompletion
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
    
    @IBAction func sendBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if !(orderIdTextfield.text?.isEmpty ?? false) {
            self.dismiss(animated: false) {
                self.block!(true, self.orderIdTextfield.text?.trim() ?? "")
            }
        } else {
            self.toastErrorAtTop("Please Enter Order ID!")
        }
    }

}

extension AddOrderPopupVC : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        self.view.endEditing(true)
        return true
    }
}
