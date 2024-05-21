//
//  CancelOrderVC.swift
//  appName
//
//  Created by McCoy Mart on 09/06/22.
//

import UIKit
import MBProgressHUD

class CancelOrderVC: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var popUpButton: UIButton!
    
    typealias CancelOrderCompletionBlock = (Bool, String) -> Void
    var block : CancelOrderCompletionBlock?
    var screenType = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if screenType == "cancelOrder"{
            imgView.image = UIImage(named: "orderCancelIcon")
            titleLabel.text = "Order cancelled"
            detailLabel.isHidden = false
            popUpButton.isHidden = true
        }else if screenType == "successOrder"{
            imgView.image = UIImage(named: "successOrderIcon")
            titleLabel.text = "Your order has been placed successfully"
            detailLabel.isHidden = true
            popUpButton.isHidden = false
        }else if screenType == "wallet"{
            imgView.image = UIImage(named: "amountAddIcon")
            titleLabel.text = "Amount has been in your wallet"
            detailLabel.isHidden = true
            popUpButton.isHidden = true
        }
    }
    
    func setCompletionBlock(onCompletion:@escaping CancelOrderCompletionBlock) {
        block = onCompletion
    }
    
    @IBAction func popButtonAction(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            self.block!(true, "ViewOrder")
        }
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            if self.screenType == "successOrder"{
                sceneDelegate?.setSideMenu()
            }
        }
    }
}
