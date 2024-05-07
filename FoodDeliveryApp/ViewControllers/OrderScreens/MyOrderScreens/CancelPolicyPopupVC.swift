//
//  CancelPolicyPopupVC.swift
//  FanServe
//
//  Created by McCoy Mart on 09/06/22.
//

import UIKit
import MBProgressHUD

class CancelPolicyPopupVC: UIViewController {
    
    @IBOutlet weak var policyLabel: UILabel!
    @IBOutlet weak var reasonTextfield: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var agreeButton: UIButton!
    
    var restoId = ""
    typealias CancelPolicyCompletionBlock = (Bool) -> Void
    var block : CancelPolicyCompletionBlock?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reasonTextfield.leftPaddingPoints(width: 10)
        agreeButton.setImage(UIImage(named: "checkbox")?.withTintColor(UIColor.gray), for: .normal)
        
        self.callWebApiToGetCancelPolicy()
    }
    
    func setCompletionBlock(onCompletion:@escaping CancelPolicyCompletionBlock) {
        block = onCompletion
    }
    
    fileprivate func callWebApiToGetCancelPolicy(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToGetCancelPolicy(restoId: restoId) { status, responseDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status{
                if let dataDic = responseDic?["data"] as? Dictionary<String, Any>{
                    let htmlStr = dataDic.validatedStringValue("html")
                    self.policyLabel.attributedText = self.stringFromHtml(string: htmlStr, font: UIFont(name: "Poppins-Medium", size: 14)!)
                }
            }
        }
    }
    
    private func stringFromHtml(string: String, font: UIFont?) -> NSAttributedString? {
        
        let modifiedString = "<style>body{font-family: '\(font?.fontName ?? "")'; font-size:\(font?.pointSize ?? 0)px; color: \("010101");}</style>\(string)";
        do {
            let data = modifiedString.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data {
                let str = try NSAttributedString(data: d,
                                                 options: [.documentType: NSAttributedString.DocumentType.html],
                                                 documentAttributes: nil)
                return str
            }
        } catch {
        }
        return nil
    }

    @IBAction func closeButtonAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        
        if !(agreeButton.isSelected){
            MessageView.showMessage(message: "Please select cancellation policy first.", time: 2.0)
            return
        }else if reasonTextfield.text?.trim().count == 0{
            MessageView.showMessage(message: "Please enter reason.", time: 2.0)
            return
        }
        self.dismiss(animated: true) {
            self.block!(true)
        }
    }
    
    @IBAction func agreeButtonAction(_ sender: UIButton) {
        
        if agreeButton.isSelected{
            agreeButton.isSelected = false
            agreeButton.setImage(UIImage(named: "checkbox")?.withTintColor(UIColor.gray), for: .normal)
            reasonTextfield.isHidden = true
        }else{
            agreeButton.isSelected = true
            agreeButton.setImage(UIImage(named: "checkmark"), for: .normal)
            reasonTextfield.isHidden = false
        }
    }
}
