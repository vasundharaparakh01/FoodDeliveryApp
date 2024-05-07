//
//  CustomAlertViewController.swift
//  GoGuards
//
//  Created by mac on 28/01/22.
//

import UIKit

class CustomAlertViewController: UIViewController {
    @IBOutlet var alertMsgLbl: UILabel!
    @IBOutlet var okBtn: UIButton!
    
    var alertMsg = ""
    var okBtnTitle = ""
    
//MARK: - lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        alertMsgLbl.text = alertMsg
        okBtn.setTitle(okBtnTitle, for: .normal)
    }
//MARK: - action and selector methods
    
    @IBAction func okAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
