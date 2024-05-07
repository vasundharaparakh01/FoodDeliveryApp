//
//  SimpleCommentAlertVC.swift
//  GoGuards
//
//  Created by Varun Kumar Raghav on 18/02/22.
//

import UIKit

class SimpleCommentAlertVC: UIViewController {

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var detailLbl: UILabel!
    var titleText = ""
    var detailText = ""
    
    //MARK: - lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
        
    }
    //MARK: - initial setup
    func initialMethod() {
        self.titleLbl.text = titleText
        self.detailLbl.text = detailText
    }
    //MARK: - action and selector methods
   
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
   
