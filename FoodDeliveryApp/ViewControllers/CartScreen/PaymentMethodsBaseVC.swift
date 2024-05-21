//
//  PaymentMethodsBaseVC.swift
//  appName
//
//  Created by McCoy Mart on 19/06/22.
//

import UIKit
import CarbonKit

class PaymentMethodsBaseVC: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    var walletVC : EwalletsListVC?
    var bankVC : BankDetailVC?
    var carbonTabSwipeNavigation : CarbonTabSwipeNavigation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.perform(#selector(initialiseCorbonKit), with: nil, afterDelay: 0.2)
    }
    
    @objc fileprivate func initialiseCorbonKit(){
        
        walletVC  = EwalletsListVC.controller(storyboard: .Main, identifire: "EwalletsListVC") as? EwalletsListVC
        bankVC  = BankDetailVC.controller(storyboard: .Main, identifire: "BankDetailVC") as? BankDetailVC
        
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items:["ewallets","Bank Transfer"], delegate: self)
        carbonTabSwipeNavigation?.toolbarHeight.constant = 50
        carbonTabSwipeNavigation?.insert(intoRootViewController: self, andTargetView: containerView)
        carbonTabSwipeNavigation?.carbonSegmentedControl?.setWidth(self.containerView.frame.width/2, forSegmentAt: 0)
        carbonTabSwipeNavigation?.carbonSegmentedControl?.setWidth(self.containerView.frame.width/2, forSegmentAt: 1)
        
        carbonTabSwipeNavigation?.toolbar.barTintColor = .white
        carbonTabSwipeNavigation?.toolbar.isTranslucent = true
        carbonTabSwipeNavigation?.setIndicatorColor(UIColor.black)
        carbonTabSwipeNavigation?.setNormalColor(UIColor.black, font: UIFont.init(name: "Poppins-Medium", size: 18)!)
        carbonTabSwipeNavigation?.setSelectedColor(UIColor.black, font: UIFont.init(name: "Poppins-Medium", size: 18)!)
        carbonTabSwipeNavigation?.setCurrentTabIndex(0, withAnimation: true)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension PaymentMethodsBaseVC: CarbonTabSwipeNavigationDelegate {
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        switch index {
        case 0:
            return walletVC!
        case 1:
            return bankVC!
        default:
            return walletVC!
        }
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        
    }
}
