//
//  PlaceOrderPopupVC.swift
//  FanServe
//
//  Created by McCoy Mart on 15/06/22.
//

import UIKit

class PlaceOrderPopupVC: UIViewController {
    
    typealias PlaceOrderCompletionBlock = (Bool, String) -> Void
    var block : PlaceOrderCompletionBlock?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setCompletionBlock(onCompletion:@escaping PlaceOrderCompletionBlock) {
        block = onCompletion
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func orderNowButtonAction(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            self.block!(true, "order")
        }
    }
    
    @IBAction func preOrderButtonAction(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            self.block!(true, "preorder")
        }
    }
}
