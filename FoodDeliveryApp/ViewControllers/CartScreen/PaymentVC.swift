//
//  PaymentVC.swift
//  appName
//
//  Created by McCoy Mart on 18/06/22.
//

import UIKit
import MBProgressHUD
import Stripe

class PaymentVC: UIViewController {
    
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var loyaltyView: UIView!
    @IBOutlet weak var loyaltyViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var loyaltySepratorView: UILabel!
    @IBOutlet weak var loyaltyPointLabel: UILabel!
    @IBOutlet weak var walletBalanceLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var addAmountView: UIView!
    @IBOutlet weak var amountTextfield: UITextField!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var bottomTitleLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var imageButtonWidthConstraint: NSLayoutConstraint!
    
    var isFromSideMenu = false
    var isFromMyWallet = false
    var isFromPreorder = false
    var objPreOrder : PreorderModel?
    fileprivate var totalAmount : Double = 0
    fileprivate var walletAmount : Double = 0
    fileprivate var textfieldAmount : Int64?
    fileprivate var isLoyaltyCheck = true
    fileprivate let appUser = SCoreDataHelper.shared.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// SandBox Key
//        StripeAPI.defaultPublishableKey = "pk_test_51LKGMvIrVR2wyzzEVDWQ9ZJDKz9pXj5eZLeIHB9J18uxle86uoic0EnYqi2jdXseDWzIG7kcIFFDzHvDUKWnwPZ400qIAGNONE"
        /// Production Key
        StripeAPI.defaultPublishableKey = "pk_live_51LKGMvIrVR2wyzzE9aWC6EHSLD7xqkCN5DjkNbAgfpTzTjKB6j4GIjfmVvnEW1ZWcdRQc76Lj8mlHOZmDspE15sw00ByUdBMCe"
        navTitleLabel.text = isFromMyWallet ? "Wallet" : "Payment"
        errorView.aroundShadow()
        addAmountView.aroundShadow()
        
        if isFromMyWallet{
            //            loyaltyViewHeightConstraint.constant = 65
            //            checkButton.isHidden = true
            //            loyaltySepratorView.isHidden = true
            imageButton.isHidden = false
            imageButtonWidthConstraint.constant = 60
            bottomTitleLabel.text = "View Passbook"
            arrowImageView.isHidden = true
            amountLabel.isHidden = true
        }else{
            imageButton.isHidden = true
            imageButtonWidthConstraint.constant = 20
            bottomTitleLabel.text = "Make Payment"
            arrowImageView.isHidden = false
            amountLabel.isHidden = false
            
            totalAmount = (appUser?.userCart?.totalAmount ?? 0) + (appUser?.userCart?.tipAmount ?? 0) + (appUser?.userCart?.deliveryCharge ?? 0)
            amountLabel.text = "MYR \(totalAmount.toValueFormat())"
        }
        loyaltyPointLabel.text = "$\(appUser?.loyaltyPoints ?? "")"
        self.callWebApiToGetWalletDetails()
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if isFromSideMenu{
            sceneDelegate?.setSideMenu()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addWalletButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        addAmountView.isHidden = false
    }
    
    @IBAction func hideWalletViewButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        self.addAmountView.isHidden = true
    }
    
    @IBAction func addAmountButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if textfieldAmount ?? 0 <= 0{
            self.toastErrorAtTop("Please enter valid amount!")
            return
        }
        self.callWebApiToGetStripePaymentIntent()
                
        //        let paymentVC = PaymentMethodsBaseVC.controller(storyboard: .Main, identifire: "PaymentMethodsBaseVC") as! PaymentMethodsBaseVC
        //        self.navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    @IBAction func amountCommonButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        switch sender.tag {
        case 100:
            textfieldAmount = 100
            amountTextfield.text = "100"
            break
        case 200:
            textfieldAmount = 200
            amountTextfield.text = "200"
            break
        case 500:
            textfieldAmount = 500
            amountTextfield.text = "500"
            break
        default:
            break
        }
    }
    
    @IBAction func bottomButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if isFromSideMenu{
            //View Passbook
            let vc = ViewPassbookVC.controller(storyboard: .Main, identifire: "ViewPassbookVC") as! ViewPassbookVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            //Make Payment
            if walletAmount < totalAmount{
                MessageView.showMessage(message: "Your wallet have not enough amount to make the order, Please add amount in your wallet first.", time: 3.0)
                return
            }
            self.callWebApiToPostPlaceHolder()
        }
    }
    
    @IBAction func loyaltyCheckButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        isLoyaltyCheck = !isLoyaltyCheck
        checkButton.setImage(UIImage(named: isLoyaltyCheck ? "loyaltyCheckIcon" : "loyaltyUncheck"), for: .normal)
    }
    
    //MARK: - Web Service Methods
    
    fileprivate func callWebApiToPostPlaceHolder(){
        
        var params = Dictionary<String, Any>()
        params["additionalNotes"] = appUser?.userCart?.additionalInfo
        params["paymentMode"] = "WALLET"
        params["deliveryMode"] = appUser?.userCart?.deliveryModeSlug
        params["seatNumber"] = isFromPreorder ? objPreOrder?.seatNo : appUser?.ticketDetail?.seatNumber
        params["seatDetails"] = appUser?.ticketDetail?.stadiumName
        params["orderDate"] = isFromPreorder ? objPreOrder?.date :  Date().dateString(format:"YYYY-MM-dd")
        params["orderTime"] = isFromPreorder ? objPreOrder?.time :  Date().dateString(format:"hh:mm a")
        params["email"] = appUser?.email
        params["mobile"] = appUser?.mobile
        params["countryCode"] = appUser?.countryCode?.replacingOccurrences(of: "+", with: "")
        params["tipAmount"] = (appUser?.userCart?.tipAmount ?? 0) * 100
        params["price"] = (appUser?.userCart?.totalAmount ?? 0) * 100
        params["deliveryCharge"] = (appUser?.userCart?.deliveryCharge ?? 0) * 100
        params["restaurantId"] = appUser?.userCart?.restaurant?.restaurantId
        params["zone"] = appUser?.ticketDetail?.stadiumZone
        var cartArr = Array<Dictionary<String, Any>>()
        if let items = self.appUser?.userCart?.cartItems?.array as? [SFMenuItem]{
            for obj in items{
                var dic = Dictionary<String, Any>()
                if obj.isSauvenior{
                    dic["quantity"] = obj.quantity
                    dic["souvenierId"] = obj.menuId
                    dic["unitPrice"] = obj.price
                    if obj.varientId?.count ?? 0 > 0{
                        dic["variant"] = obj.varientId
                            let varients = obj.varients?.array as? [SFSubItem] ?? []
                            if let selectedVarient = varients.filter { ($0.itemId ?? UUID().uuidString) == obj.varientId }.first {
                                dic["variantName"] = selectedVarient.name ?? ""
                            }
                    }
                }else{
                    dic["menuId"] = obj.menuId
                    dic["quantity"] = obj.quantity
                    dic["image"] = obj.productImage
                    dic["restaurantId"] = obj.restaurantId
                    dic["name"] = obj.name
                    var varientPrice : Double = 0
                    if obj.varientId?.count ?? 0 > 0{
                        dic["variant"] = obj.varientId
                        if let varients = obj.varients?.array as? [SFSubItem], varients.count > 0{
                            let objVar = varients.first
                            dic["variantPrice"] = objVar?.price
                            varientPrice = objVar?.price ?? 0
                        }
                    }
                    var additionalItemPrice : Double = 0
                    if let addtionalItems = obj.additionalItems?.array as? [SFSubItem]{
                        var itemArr = Array<Dictionary<String, Any>>()
                        for objAdd in addtionalItems{
                            var itemDic = Dictionary<String, Any>()
                            itemDic["id"] = objAdd.itemId
                            itemDic["name"] = objAdd.name
                            itemDic["price"] = objAdd.price
                            additionalItemPrice = additionalItemPrice + objAdd.price
                            itemArr.append(itemDic)
                        }
                        dic["additionalItems"] = itemArr
                    }
                    dic["unitPrice"] = obj.price + varientPrice + additionalItemPrice
                }
                cartArr.append(dic)
            }
        }
        params["cart"] = cartArr
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToPlaceOrder(params: params) { success, responseDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success{
                //self.appUser?.ticketDetail = nil
                SCoreDataHelper.shared.saveContext()
                let vc1 = CancelOrderVC()
                vc1.modalTransitionStyle = .crossDissolve
                vc1.modalPresentationStyle = .overFullScreen
                vc1.screenType = "successOrder"
                vc1.setCompletionBlock { success, type in
                    if success{
                        let vc = MyOrderListVC()
                        vc.isFromSuccessOrder = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                self.present(vc1, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func callWebApiToGetWalletDetails(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToGetWalletDetails() { success, responseDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success{
                if let dataDic = responseDic?["data"] as? Dictionary<String, Any>{
                    let balance = dataDic.validatedDoubleValue("balance")
                    self.walletAmount = balance/100
                    self.walletBalanceLabel.text = "MYR \((balance/100).toValueFormat())"
                }
                self.callWebApiToGetLoyalityDetails()
            }
        }
    }
    
    fileprivate func callWebApiToGetLoyalityDetails(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToGetLoyaltyDetails() { success, responseDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success{
                if let dataDic = responseDic?["data"] as? Dictionary<String, Any>{
                    self.appUser?.loyaltyPoints = dataDic.validatedStringValue("loyalityPoints")
                    SCoreDataHelper.shared.saveContext()
                    self.loyaltyPointLabel.text = "$\(self.appUser?.loyaltyPoints ?? "")"
                }
            }
        }
    }
    
    fileprivate func callWebApiToGetStripePaymentIntent(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToGetStripeIntent(amount: textfieldAmount ?? 0) { success, responseDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success{
                if let dataDic = responseDic?["data"] as? Dictionary<String, Any>{
                    let secretKey = dataDic.validatedStringValue("clientSecret")
                    self.pay(secretkey: secretKey)
                }
            }
        }
    }
    
    fileprivate func pay(secretkey : String) {
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "JDTappName"
        
        let paymentSheet = PaymentSheet(
            paymentIntentClientSecret: secretkey,
            configuration: configuration)
        
        paymentSheet.present(from: self) { [weak self] (paymentResult) in
            switch paymentResult {
            case .completed:
                MessageView.showMessage(message: "Payment complete!", time: 2.0)
                self?.textfieldAmount = 0
                self?.amountTextfield.text = ""
                self?.addAmountView.isHidden = true
                self?.callWebApiToGetWalletDetails()
            case .canceled:
                MessageView.showMessage(message: "Payment canceled!", time: 2.0)
            case .failed(let error):
                _ =  AlertController.alert("Payment failed", message: error.localizedDescription, acceptMessage: "Ok") {
                    
                    }
            }
        }
    }
}

extension PaymentVC : UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        textfieldAmount = Int64(textField.text?.trimWhiteSpace() ?? "0")
    }
}
