//
//  MyOrderListVC.swift
//  appName
//
//  Created by McCoy Mart on 09/06/22.
//

import UIKit
import MBProgressHUD
import FloatRatingView

class MyOrderListVC: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    fileprivate let appUser = SCoreDataHelper.shared.currentUser()
    fileprivate var dataSourceArr = [SFOrder]()
    var isFromSuccessOrder = false
    fileprivate var pageCount = 1
    fileprivate var isLoadingList = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.aroundShadow()
        tblView.register(UINib(nibName: "MyOrderTableCell", bundle: nil), forCellReuseIdentifier: "MyOrderTableCell")
        
        self.callWebApiToGetMyOrders()
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        sceneDelegate?.setSideMenu()
    }
    
    @IBAction func cancelOrderButtonAction(_ sender: UIButton) {
        
        let obj = self.dataSourceArr[sender.tag - 100]
        let vc = CancelPolicyPopupVC()
        vc.restoId = obj.restaurent?.restaurantId ?? ""
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.setCompletionBlock { success in
            if success{
                self.callWebApiToCancelMyOrders(orderId: obj.orderId ?? "")
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    fileprivate func callWebApiToGetMyOrders(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToGetMyOrders(page: pageCount) { status, responseDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status{
                if let dataDic = responseDic?["data"] as? Dictionary<String, Any>{
                    let totalCount : Int = dataDic["totalPages"] as? Int ?? 1
                    if self.pageCount == totalCount{
                        self.isLoadingList = true
                    }else{
                        self.isLoadingList = false
                    }
                }
                SCoreDataHelper.shared.updateOrderListData(isPagination: self.pageCount > 1, params: responseDic!)
                if let list = self.appUser?.myOrders?.array as? [SFOrder]{
                    self.dataSourceArr = list
                }
                self.tblView.reloadData()
            }
        }
    }
    
    fileprivate func callWebApiToCancelMyOrders(orderId : String){
        
        var params = Dictionary<String, Any>()
        params["orderId"] = orderId
        params["reason"] = "dasdasdasd"
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToCancelMyOrders(params: params) { status, responseDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status{
                let vc1 = CancelOrderVC()
                vc1.modalTransitionStyle = .crossDissolve
                vc1.modalPresentationStyle = .overFullScreen
                vc1.screenType = "cancelOrder"
                self.present(vc1, animated: true, completion: nil)
                self.callWebApiToGetMyOrders()
            }
        }
    }
    
    fileprivate func callWebApiToUpdateOrderRating(obj : SFOrder, rating : Double){
        
        var params = Dictionary<String, Any>()
        params["orderId"] = obj.orderId
        params["message"] = "dasdasdasd"
        params["rating"] = rating
        params["restaurantId"] = obj.restaurent?.restaurantId
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToUpdateRestaurantReview(params: params) { status, responseDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status{
                MessageView.showMessage(message: "Rating added successfully.", time: 2.0)
                obj.rating = rating
                SCoreDataHelper.shared.saveContext()
            }
        }
    }
    
    
}

extension MyOrderListVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tblView.setEmptyMessage(message: dataSourceArr.count == 0 ? "No orders here." : "")
        return dataSourceArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderTableCell", for: indexPath) as! MyOrderTableCell
        cell.bgView.aroundShadow()
        cell.ratingView.delegate = self
        cell.cancelButton.tag = indexPath.row + 100
        cell.ratingView.tag = indexPath.row + 1000
        cell.cancelButton.addTarget(self, action: #selector(cancelOrderButtonAction(_:)), for: .touchUpInside)
        let obj = dataSourceArr[indexPath.row]
        cell.qrCodeImageView.image = generateQRCode(from: obj.orderId ?? "")
        cell.amountLabel.text = "MYR \((obj.orderPrice/100).toValueFormat())"
        cell.dateLabel.text = "\(obj.orderDate?.dateString(format: "dd MMM yyyy") ?? "") at \(obj.orderTime ?? "")"
        cell.orderImageView.imageLoad(urlString: "\(newsImageBaseUrl)\(obj.restaurent?.profileImage ?? "")", placeholder: UIImage(named: "imagePlaceholder"))
        cell.orderIdLabel.text = obj.customId
        cell.titleLabel.text = obj.restaurent?.name
        
        cell.ratingView.rating = obj.rating
        cell.ratingView.isUserInteractionEnabled = obj.rating == 0
        
        
        let isFreshOrder = ((obj.trackList?.array as? [SFSection])?.get(at: 1))?.status ?? false
        cell.cancelButton.isHidden = isFreshOrder
        cell.cancelUnderlineLabel.isHidden = isFreshOrder
        
        let isDelivered = ((obj.trackList?.array as? [SFSection])?.get(at: 5))?.status ?? false
        cell.ratingView.isHidden = !isDelivered
        cell.addRattingLabel.isHidden = !isDelivered
        
//        cell.cancelLabel.isHidden = !isFreshOrder
        
//        cell.cancelButton.isHidden = obj.status == "CANCELLED"
//        cell.cancelUnderlineLabel.isHidden = obj.status == "CANCELLED"
        cell.cancelLabel.isHidden = !(obj.status == "CANCELLED")
        
        if let list = obj.items?.array as? [SFMenuItem]{
            cell.reloadTableData(list: list)
        }
        if let list = obj.trackList?.array as? [SFSection]{
            cell.reloadCollectionData(list: list)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let obj = dataSourceArr[indexPath.row]
        let isDelivered = ((obj.trackList?.array as? [SFSection])?.get(at: 5))?.status ?? false
        if isDelivered {
            return 315 + (60 * CGFloat(obj.items?.count ?? 0))
        } else {
            return 315 + (60 * CGFloat(obj.items?.count ?? 0)) - 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let vc = MyOrderDetailVC.controller(storyboard: .Main, identifire: "MyOrderDetailVC") as! MyOrderDetailVC
        vc.selectedOrder = dataSourceArr[indexPath.row]
        vc.setCompletionBlock { success in
            if success{
                self.tblView.reloadData()
            }
        }
//        self.navigationController?.pushViewController(vc, animated: true)
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
}

extension MyOrderListVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let updatedText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if var listArr = self.appUser?.myOrders?.array as? [SFOrder]{
            if updatedText.count > 0{
                listArr = listArr.filter { (obj) -> Bool in
                    return (obj.restaurent?.name?.lowercased().contains(updatedText.lowercased()))! || (obj.customId?.lowercased().contains(updatedText.lowercased()))!
                }
            }
            dataSourceArr = listArr
        }
        self.tblView.reloadData()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        self.view.endEditing(true)
        return true
    }
}

extension MyOrderListVC : FloatRatingViewDelegate{
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double){
        
        let obj = dataSourceArr[ratingView.tag - 1000]
        self.callWebApiToUpdateOrderRating(obj: obj, rating: rating)
    }
}

extension MyOrderListVC : UIScrollViewDelegate{
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            self.loadMoreData()
        }
    }
    
    func loadMoreData(){
        
        if !isLoadingList{
            isLoadingList = true
            pageCount = pageCount + 1
            self.callWebApiToGetMyOrders()
        }
    }
}
