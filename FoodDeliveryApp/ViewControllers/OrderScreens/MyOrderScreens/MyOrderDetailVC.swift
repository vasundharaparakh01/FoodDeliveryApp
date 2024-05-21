//
//  MyOrderDetailVC.swift
//  appName
//
//  Created by McCoy Mart on 13/06/22.
//

import UIKit
import MBProgressHUD
import FloatRatingView

class MyOrderDetailVC: UIViewController {
    
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var seatDeatilLabel: UILabel!
    
    var selectedOrder : SFOrder?
    var isFromSideMenu = false
    var itemArr = [SFMenuItem]()
    var priceArr = [("Total Amount","")]
    typealias UpdateOrderListCompletionBlock = (Bool) -> Void
    var block : UpdateOrderListCompletionBlock?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.isHidden = true
        if isFromSideMenu{
            self.callWebApiToGetOrderDetailByCustomId()
        }else{
            self.callWebApiToGetOrderDetail()
        }
        
    }
    
    func setCompletionBlock(onCompletion:@escaping UpdateOrderListCompletionBlock) {
        block = onCompletion
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let QRFilter = CIFilter(name: "CIQRCodeGenerator") {
            QRFilter.setValue(data, forKey: "inputMessage")
            guard let QRImage = QRFilter.outputImage else {return nil}
            
            let transformScale = CGAffineTransform(scaleX: 5.0, y: 5.0)
            let scaledQRImage = QRImage.transformed(by: transformScale)
            
            return UIImage(ciImage: scaledQRImage)
        }
        return nil
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        if isFromSideMenu{
            sceneDelegate?.setSideMenu()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    fileprivate func callWebApiToGetOrderDetail(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToGetOrderDetail(orderId: selectedOrder?.orderId ?? "") { status, responseDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status{
                SCoreDataHelper.shared.updateOrderDetailData(order: self.selectedOrder!, params: responseDic!)
                self.reloadTableData()
            }
        }
    }
    
    fileprivate func callWebApiToGetOrderDetailByCustomId(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToGetOrderDetailByCustomId(orderId: selectedOrder?.customId ?? "") { status, responseDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status{
                SCoreDataHelper.shared.updateOrderDetailData(isFromCustomIdOrder:true, order: self.selectedOrder!, params: responseDic!)
                self.reloadTableData()
            }
        }
    }
    
    fileprivate func callWebApiToUpdateOrderRating(rating : Double){
        
        var params = Dictionary<String, Any>()
        params["orderId"] = selectedOrder?.orderId
        params["message"] = "dasdasdasd"
        params["rating"] = rating
        params["restaurantId"] = selectedOrder?.restaurent?.restaurantId
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToUpdateRestaurantReview(params: params) { status, responseDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status{
                MessageView.showMessage(message: "Rating added successfully.", time: 2.0)
                self.selectedOrder?.rating = rating
                SCoreDataHelper.shared.saveContext()
                self.tblView.reloadData()
                self.block!(true)
            }
        }
    }
    
    fileprivate func reloadTableData(){
        
        navTitleLabel.text = "Order-\(selectedOrder?.customId ?? "")"
        orderNumberLabel.text = selectedOrder?.customId
        qrCodeImageView.image = generateQRCode(from: selectedOrder?.orderId ?? "")
        dateLabel.text = selectedOrder?.orderDate?.dateString(format: "EEEE dd, yyyy")
        
        seatDeatilLabel.text = "\(selectedOrder?.seatDetails ?? "") \(selectedOrder?.seatNumber ?? "")"
        
        if let list = selectedOrder?.items?.array as? [SFMenuItem]{
            self.itemArr = list
        }
        //[("Total Amount",""),("Item Total","10"),("Taxes or Charges","1"),("Grand Total","11")]
        priceArr.append(("Item Total","\(((selectedOrder?.orderPrice ?? 0)/100).toValueFormat())"))
        priceArr.append(("\(selectedOrder?.deliveryMode ?? "")","\(((selectedOrder?.deliveryCharge ?? 0)/100).toValueFormat())"))
        if selectedOrder?.tipAmount ?? 0 > 0{
            priceArr.append(("Tip Amount","\(((selectedOrder?.tipAmount ?? 0)/100).toValueFormat())"))
        }
        let totalAmount = (selectedOrder?.orderPrice ?? 0) + (selectedOrder?.deliveryCharge ?? 0) + (selectedOrder?.tipAmount ?? 0)
        priceArr.append(("Grand Total","\(((totalAmount)/100).toValueFormat())"))
        
        tblView.isHidden = false
        tblView.reloadData()
    }
}

extension MyOrderDetailVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1{
            return itemArr.count
        }else if section == 2{
            return priceArr.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell", for: indexPath) as! OrderDetailCell
            cell.bgView.aroundShadow()
            cell.imgView.imageLoad(urlString: "\(newsImageBaseUrl)\(selectedOrder?.restaurent?.profileImage ?? "")", placeholder: UIImage(named: "imagePlaceholder"))
            cell.ratingView.rating = selectedOrder?.rating ?? 0
            cell.ratingView.isUserInteractionEnabled = selectedOrder?.rating == 0
            cell.ratingView.delegate = self
            cell.nameLabel.text = selectedOrder?.restaurent?.name
            cell.addressLabel.text = selectedOrder?.restaurent?.address
            return cell
        }else if indexPath.section == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemTableCell", for: indexPath) as! OrderItemTableCell
            cell.bgViewTopConstraint.constant = -2
            cell.bgViewBottomConstraint.constant = -2
            let obj = itemArr[indexPath.row]
            cell.imgView.imageLoad(urlString: "\(newsImageBaseUrl)\(obj.productImage ?? "")", placeholder: UIImage(named: "imagePlaceholder"))
            cell.titleLabel.text = obj.name
            cell.qtyLabel.text = "Qty : \(obj.quantity)"
            cell.priceLabel.text = "MYR \((obj.price/100).toValueFormat())"
            if indexPath.row == 0{
                if itemArr.count == 1{
                    cell.bgViewTopConstraint.constant = 2
                    cell.bgViewBottomConstraint.constant = 2
                    cell.bgView.roundCorners()
                }else{
                    cell.bgViewTopConstraint.constant = 5
                    cell.bgView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 8)
                }
                
            }else if indexPath.row == itemArr.count - 1{
                cell.bgViewBottomConstraint.constant = 5
                cell.bgView.roundCorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 8)
            }else{
                cell.bgView.roundCorners(radius: 0)
            }
            cell.bgView.aroundShadow()
            return cell
        }else if indexPath.section == 2{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPaymentTableCell", for: indexPath) as! OrderItemTableCell
            cell.bgViewTopConstraint.constant = -2
            cell.bgViewBottomConstraint.constant = -2
            cell.imgView.isHidden = true
            cell.sepratorLabel.isHidden = true
            cell.priceLabel.isHidden = false
            cell.titleLabel.font = UIFont(name: "Poppins-Regular", size: 16)
            cell.titleLabel.textColor = UIColor(hex: "666666")
            let obj = priceArr[indexPath.row]
            cell.titleLabel.text = obj.0
            cell.priceLabel.text = obj.1
            if indexPath.row == 0{
                cell.imgView.isHidden = false
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
            }else if indexPath.row == priceArr.count - 2{
                cell.bgView.roundCorners(radius: 0)
                cell.sepratorLabel.isHidden = false
                cell.sepratorLabel.backgroundColor = UIColor(hex: "666666")
            }else{
                cell.bgView.roundCorners(radius: 0)
            }
            cell.bgView.aroundShadow()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPaymentByTableCell", for: indexPath) as! OrderItemTableCell
            cell.titleLabel.text = selectedOrder?.paymentMode
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if indexPath.section == 0{
            return 230
        }else if indexPath.section == 1{
            return 90
        }else if indexPath.section == 2{
            if indexPath.row == 0 || indexPath.row == priceArr.count - 1{
                return 50
            }
            return 30
        }else{
            return 56
        }
    }
    
    
}

extension MyOrderDetailVC : FloatRatingViewDelegate{
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double){
        
        self.callWebApiToUpdateOrderRating(rating: rating)
    }
}
