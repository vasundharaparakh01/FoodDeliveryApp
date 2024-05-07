//
//  MyCartVC.swift
//  FanServe
//
//  Created by McCoy Mart on 15/06/22.
//

import UIKit
import MBProgressHUD

class MyCartVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var placeorderButton: UIButton!
    
    var itemArr = [SFMenuItem]()
    var priceArr = [("Total Amount",""),("Item Total","0"),("Taxes or Charges","0"),("Grand Total","0")]
    var selectedAddOnsItem = -1
    var objPreOrder : PreorderModel?  //object for "Are You at Stadium = No" case.
    fileprivate let appUser = SCoreDataHelper.shared.currentUser()
    fileprivate var grandTotalAmount : Double = 0
    fileprivate var deliveryCharge : Double = 0
    fileprivate var taxArr = Array<Dictionary<String, Any>>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var frame = CGRect.zero
//        frame.size.height = .leastNormalMagnitude
//        tblView.tableHeaderView = UIView(frame: frame)
        
        //tblView.keyboardDismissMode = .onDrag
        
        let cart = SFCart.newObject(entityName: "SFCart") as! SFCart
        appUser?.userCart = cart
        if objPreOrder != nil && objPreOrder?.deliveryType.count ?? 0 > 0{
            appUser?.userCart?.deliveryMode = objPreOrder?.deliveryType
        }else{
            appUser?.userCart?.deliveryMode = "In seat Delivery"
        }
        SCoreDataHelper.shared.saveContext()
        
        self.callWebApiToGetcartDetail()
    }
    
    @IBAction func placeOrderButtonAction(_ sender: UIButton) {
        
        appUser?.userCart?.totalAmount = grandTotalAmount
        appUser?.userCart?.deliveryCharge = deliveryCharge
        SCoreDataHelper.shared.saveContext()
        
        if objPreOrder == nil{
            let popvc = PlaceOrderPopupVC.controller(storyboard: .Main, identifire: "PlaceOrderPopupVC") as! PlaceOrderPopupVC
            popvc.modalTransitionStyle = .crossDissolve
            popvc.modalPresentationStyle = .overFullScreen
            popvc.setCompletionBlock { success, type in
                if success{
                    if type == "order"{
                        let payVC = PaymentVC.controller(storyboard: .Main, identifire: "PaymentVC") as! PaymentVC
                        self.navigationController?.pushViewController(payVC, animated: true)
                    }else{
                        self.appUser?.userCart?.deliveryMode = type
                        SCoreDataHelper.shared.saveContext()
                        self.reloadTableData(taxArr: self.taxArr)
                        self.perform(#selector(self.navigateToPreOrderPopup), with: nil, afterDelay: 0.2)
//                        let popvc = EditDeliveryTypeVC.controller(storyboard: .Main, identifire: "EditDeliveryTypeVC") as! EditDeliveryTypeVC
//                        popvc.isFromCartScreen = true
//                        popvc.modalTransitionStyle = .crossDissolve
//                        popvc.modalPresentationStyle = .overFullScreen
//                        popvc.setCompletionBlock { success, type in
//                            if success{
//                                self.appUser?.userCart?.deliveryMode = type
//                                SCoreDataHelper.shared.saveContext()
//                                self.reloadTableData(taxArr: self.taxArr)
//                                self.perform(#selector(self.navigateToPreOrderPopup), with: nil, afterDelay: 0.2)
//                            }
//                        }
//                        self.present(popvc, animated: true, completion: nil)
                    }
                }
            }
            self.present(popvc, animated: true, completion: nil)
        }else{
            let payVC = PaymentVC.controller(storyboard: .Main, identifire: "PaymentVC") as! PaymentVC
            payVC.objPreOrder = objPreOrder
            payVC.isFromPreorder = true
            self.navigationController?.pushViewController(payVC, animated: true)
        }
    }
    
    @objc fileprivate func navigateToPreOrderPopup(){
        
        let vc = InSeatDeliveryPreorderVC.controller(storyboard: .Main, identifire: "InSeatDeliveryPreorderVC") as! InSeatDeliveryPreorderVC
        vc.isFromCartPreorder = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cellMinusButtonAction(_ sender: UIButton) {
        
        let obj = itemArr[sender.tag - 300]
        if obj.quantity < 2{
            self.callWebApiToDeleteItemIncart(obj: obj)
        }else{
            obj.quantity = obj.quantity - 1
            SCoreDataHelper.shared.saveContext()
            self.callWebApiToUpdatecart(obj: obj)
        }
    }
    
    @IBAction func cellPlusButtonAction(_ sender: UIButton) {
        
        let obj = itemArr[sender.tag - 200]
        obj.quantity = obj.quantity + 1
        SCoreDataHelper.shared.saveContext()
        self.callWebApiToUpdatecart(obj: obj)
    }
    
    @IBAction func editDeliveryButtonAction(_ sender: UIButton) {
        
        let popvc = EditDeliveryTypeVC.controller(storyboard: .Main, identifire: "EditDeliveryTypeVC") as! EditDeliveryTypeVC
        popvc.isFromCartScreen = true
        popvc.modalTransitionStyle = .crossDissolve
        popvc.modalPresentationStyle = .overFullScreen
        popvc.currentSelectedDeliveryType = self.appUser?.userCart?.deliveryMode ?? ""
        popvc.setCompletionBlock { success, type in
            if success{
                self.appUser?.userCart?.deliveryMode = type
                SCoreDataHelper.shared.saveContext()
                self.reloadTableData(taxArr: self.taxArr)
            }
        }
        self.present(popvc, animated: true, completion: nil)
    }
    
    @IBAction func cellAddOnsButtonAction(_ sender: UIButton) {
        
        if selectedAddOnsItem == sender.tag - 100{
            selectedAddOnsItem = -1
        }else{
            selectedAddOnsItem = sender.tag - 100
        }
        self.tblView.reloadData()
    }
    
    //MARK: - Web Service Methods
    
    fileprivate func callWebApiToGetcartDetail(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToGatCartDetail() { success, responseDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success{
                SCoreDataHelper.shared.updateUserCartData(params: responseDic!)
                self.tblView.isHidden = false
                self.placeorderButton.isHidden = false
                self.callWebApiToGetTaxList()
            }else{
                self.tblView.isHidden = true
                self.placeorderButton.isHidden = true
            }
        }
    }
    
    fileprivate func callWebApiToGetTaxList(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToGatTaxList() { success, responseDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success{
                if let dataArr = responseDic?["data"] as? Array<Dictionary<String, Any>>{
                    self.taxArr = dataArr
                }
                self.reloadTableData(taxArr: self.taxArr)
            }
        }
    }
    
    
    fileprivate func callWebApiToUpdatecart(obj : SFMenuItem){
        
        var cartDic = Dictionary<String, Any>()
        if obj.isSauvenior{
            cartDic["souvenierId"] = obj.menuId
        }else{
            cartDic["menuId"] = obj.menuId
        }
        cartDic["quantity"] = obj.quantity
        cartDic["additionalItems"] = [String]()
        cartDic["variant"] = obj.varientId
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToUpdateCart(menuId : obj.productId ?? "", params: cartDic) { success, responseDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success{
//                if let message = responseDic?["message"] as? String{
//                    MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
//                }
                self.callWebApiToGetcartDetail()
            }
        }
    }
    
    fileprivate func callWebApiToDeleteItemIncart(obj : SFMenuItem){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToDeleteItemInCart(menuId: obj.productId ?? "") { success, responseDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success{
//                if let message = responseDic?["message"] as? String{
//                    MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
//                }
                self.callWebApiToGetcartDetail()
            }
        }
    }
    
    fileprivate func reloadTableData(taxArr : Array<Dictionary<String, Any>>){
        
        if let items = self.appUser?.userCart?.cartItems?.array as? [SFMenuItem]{
            self.itemArr = items
        }
        
        var total : Double = 0
        var totalAddOn : Double = 0
        for item in itemArr {
            let amountTotal = ((item.totalPrice)/100.0) * Double(item.quantity)
            total = total + amountTotal
            
//            var varientAmount : Double = 0
//            if let list = item.varients?.array as? [SFSubItem], list.count > 0{
//                let obj = list.first
//                varientAmount = ((obj?.price ?? 0)/100.0) * Double(item.quantity)
//            }
//            total = total + varientAmount
            
            var addOnAmount : Double = 0
            if let list = item.additionalItems?.array as? [SFSubItem], list.count > 0{
                for obj in list{
                    addOnAmount = addOnAmount + ((obj.price)/100.0) * Double(item.quantity)
                }
            }
            totalAddOn += addOnAmount
            total = total + addOnAmount
        }
        
        if totalAddOn == 0 {
            priceArr = [("Total Amount",""),("Item Total","\(total.toValueFormat())")]
        } else {
            let totalAm = (total - totalAddOn).toValueFormat()
            let totalAd = (totalAddOn).toValueFormat()
            priceArr = [("Total Amount",""),("Item Total","\(totalAm)"),("Add ons","\(totalAd)")]
        }
        
        var totalTax : Double = 0
//        for taxDic in taxArr{
//            let name = taxDic.validatedStringValue("name")
//            let val = taxdic.validatedDoubleValue("totalPrice")
//            let tax = (total * val)/100
//            totalTax = totalTax + tax
//            priceArr.append(("\(name)","\(tax.toValueFormat())"))
//        }
//        grandTotalAmount = total + totalTax
        if appUser?.userCart?.deliveryMode == "Express Lane Delivery"{
            let filteredArr = taxArr.filter { dic in
                return dic.validatedStringValue("slug") == "express_delivery"
            }
            if let dic = filteredArr.first{
                let name = dic.validatedStringValue("description")
                let val = dic.validatedDoubleValue("value")
                totalTax = val/100
                priceArr.append(("\(name)","\((val/100).toValueFormat())"))
            }
            appUser?.userCart?.deliveryModeSlug = "EXPRESS_DELIVERY"
        }else if appUser?.userCart?.deliveryMode == "Pickup"{
            let filteredArr = taxArr.filter { dic in
                return dic.validatedStringValue("slug") == "pickup"
            }
            if let dic = filteredArr.first{
                let name = dic.validatedStringValue("description")
                let val = dic.validatedDoubleValue("value")
                totalTax = val/100
                priceArr.append(("\(name)","\((val/100).toValueFormat())"))
            }
            appUser?.userCart?.deliveryModeSlug = "PICKUP"
        }else if appUser?.userCart?.deliveryMode == "In seat Delivery"{
            let filteredArr = taxArr.filter { dic in
                return dic.validatedStringValue("slug") == "seat_delivery"
            }
            if let dic = filteredArr.first{
                let name = dic.validatedStringValue("description")
                let val = dic.validatedDoubleValue("value")
                totalTax = val/100
                priceArr.append(("\(name)","\((val/100).toValueFormat())"))
            }
            appUser?.userCart?.deliveryModeSlug = "SEAT_DELIVERY"
        }
        SCoreDataHelper.shared.saveContext()
        deliveryCharge = totalTax
        grandTotalAmount = total
        var tip : Double = 0
        if appUser?.userCart?.tipAmount ?? 0 > 0{
            tip = appUser?.userCart?.tipAmount ?? 0
            priceArr.append(("Tip","\(tip.toValueFormat())"))
        }
        priceArr.append(("Grand Total","\((total + totalTax + tip).toValueFormat())"))
        
        self.tblView.reloadData()
    }
}

extension MyCartVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return itemArr.count
        case 2:
            return 2
        case 3:
            return priceArr.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell", for: indexPath) as! OrderDetailCell
            cell.bgView.aroundShadow()
            cell.nameLabel.text = appUser?.userCart?.restaurant?.name
            cell.imgView.imageLoad(urlString: "\(newsImageBaseUrl)\(appUser?.userCart?.restaurant?.profileImage ?? "")", placeholder: UIImage(named: "imagePlaceholder"))
            cell.ratingLabel.text = appUser?.userCart?.restaurant?.rating
            cell.addressLabel.text = appUser?.userCart?.restaurant?.cusine
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemTableCell", for: indexPath) as! CartItemTableCell
            cell.bgView.aroundShadow()
            cell.sepratorLabel.isHidden = true
            cell.addOnsButton.tag = indexPath.row + 100
            cell.plusButton.tag = indexPath.row + 200
            cell.minusButton.tag = indexPath.row + 300
            let obj = itemArr[indexPath.row]
            if obj.isSauvenior{
                cell.addOnsButton.isHidden = true
                cell.addOnsLineLabel.isHidden = true
                cell.nameLabel.text = obj.name
                if (obj.varients?.array.count ?? 0) >= 1 {
                    if let varient = (obj.varients?.array as? [SFSubItem] ?? []).filter { item in
                        return (item.itemId ?? UUID().uuidString) == obj.varientId
                    }.first {
                        if let vName = varient.name {
                            cell.nameLabel.text = "\(obj.name ?? "") - \(vName)"
                        } else {
                            cell.nameLabel.text = "\(obj.name ?? "")"
                        }
                    }
                }
            }else{
                cell.addOnsButton.isHidden = obj.additionalItems?.count ?? 0 == 0
                cell.addOnsLineLabel.isHidden = obj.additionalItems?.count ?? 0 == 0
                if let list = obj.additionalItems?.array as? [SFSubItem]{
                    cell.reloadTableData(list: list)
                }
                cell.nameLabel.text = obj.name
            }
            cell.imgView.imageLoad(urlString: "\(newsImageBaseUrl)\(obj.productImage ?? "")", placeholder: UIImage(named: "imagePlaceholder"))
            cell.priceLabel.text = "MYR\(((obj.totalPrice/100) * Double(obj.quantity)).toValueFormat())"
            cell.qtyLabel.text = "\(obj.quantity)"
            return cell
        }else if indexPath.section == 2{
            
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AppTextviewTableCell", for: indexPath) as! AppTextviewTableCell
                cell.txtView.text = appUser?.userCart?.additionalInfo
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CartDetailTableCell", for: indexPath) as! CartDetailTableCell
                cell.txtField.text = appUser?.userCart?.tipAmount.toValueFormat()
                cell.seatNoLabel.text = appUser?.ticketDetail?.seatNumber
                cell.addressLabel.text = appUser?.ticketDetail?.stadiumName
                cell.deliveryLabel.text = appUser?.userCart?.deliveryMode
                return cell
            }
        }else if indexPath.section == 3{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPaymentTableCell", for: indexPath) as! OrderItemTableCell
            cell.bgViewTopConstraint.constant = -2
            cell.bgViewBottomConstraint.constant = -2
            cell.imgView.isHidden = true
            cell.sepratorLabel.isHidden = true
            cell.priceLabel.isHidden = false
            cell.titleLabel.font = UIFont(name: "Poppins-Regular", size: 16)
            cell.titleLabel.textColor = UIColor(hex: "666666")
            cell.priceLabel.textColor = UIColor(hex: "666666")
            let obj = priceArr[indexPath.row]
            cell.titleLabel.text = obj.0
            cell.priceLabel.text = obj.1
            if indexPath.row == 0{
                cell.imgView.isHidden = true
                cell.sepratorLabel.isHidden = false
                cell.sepratorLabel.backgroundColor = UIColor(hex: "214BB1")
                cell.priceLabel.isHidden = true
                cell.bgViewTopConstraint.constant = 15
                cell.bgView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 8)
                cell.titleLabel.font = UIFont(name: "Poppins-Medium", size: 16)
                cell.titleLabel.textColor = UIColor(hex: "214BB1")
            }else if indexPath.row == priceArr.count - 1{
                cell.bgViewBottomConstraint.constant = 5
                cell.bgView.roundCorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 8)
                cell.titleLabel.font = UIFont(name: "Poppins-Medium", size: 16)
                cell.titleLabel.textColor = UIColor(hex: "000000")
                cell.priceLabel.textColor = UIColor(hex: "214BB1")
            }else if indexPath.row == priceArr.count - 2{
                cell.bgView.roundCorners(radius: 0)
                cell.sepratorLabel.isHidden = false
                cell.sepratorLabel.backgroundColor = UIColor(hex: "666666")
            }else{
                cell.bgView.roundCorners(radius: 0)
            }
            cell.bgView.aroundShadow()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        switch indexPath.section {
        case 0:
            return 120
        case 1:
            let obj = itemArr[indexPath.row]
            return CGFloat(selectedAddOnsItem == indexPath.row ? (90 + ((obj.additionalItems?.count ?? 0) * 40)) : 90)
        case 2:
            return indexPath.row == 0 ? 130 : 255
        case 3:
            if indexPath.row == 0 || indexPath.row == priceArr.count - 1{
                return 50
            }
            return 30
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        if section == 1 || section == 2{
            return 35
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        if section == 1 || section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppHeaderTableCell") as! AppHeaderTableCell
            if section == 1{
                cell.qtyLabel.isHidden = false
                cell.priceLabel.isHidden = false
                cell.itemLabel.text = "Items"
            }else{
                cell.qtyLabel.isHidden = true
                cell.priceLabel.isHidden = true
                cell.itemLabel.text = "Additional instruction (If any)"
            }
            return cell
        }
        return nil
    }
    
}

extension MyCartVC : UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        appUser?.userCart?.tipAmount = textField.text?.trim().doubleValue ?? 0
        self.reloadTableData(taxArr: taxArr)
    }
}

extension MyCartVC : UITextViewDelegate{
    
    func textViewDidEndEditing(_ textView: UITextView){
        
        appUser?.userCart?.additionalInfo = textView.text.trim()
    }
}
