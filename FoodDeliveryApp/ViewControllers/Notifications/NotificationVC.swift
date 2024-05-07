//
//  NotificationVC.swift
//  FanServe
//
//  Created by Varun Kumar Raghav on 26/05/22.
//

import UIKit
import MBProgressHUD

class NotificationVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let appUser = SCoreDataHelper.shared.currentUser()
    fileprivate var dataArr = [SFNotification]()
    
    //MARK: - lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
        self.callWebApiToGetNotificationList()
    }
    
    //MARK: - initial setup methods
    func initialMethod() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(NotificationCell.createCellNib(), forCellReuseIdentifier: NotificationCell.cellIdentifier())
    }
    
    //MARK: - action and selector methods
    @IBAction func backBtnAction(_ sender: UIButton) {
        sceneDelegate?.setSideMenu()
    }
    
    func showRatingAlert() {
        let vc = RatingAlertVC()
        vc.delgate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    fileprivate func callWebApiToGetNotificationList(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToGetAllNotifications { success, dataDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success{
                SCoreDataHelper.shared.updateNotificationListData(params: dataDic!)
                if let list = self.appUser?.notificationList?.array as? [SFNotification]{
                    self.dataArr = list
                }
                self.tableView.reloadData()
            }
        }
    }
    
}
//MARK: - tableView delegate and datasource methods

extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        dataArr.count == 0 ? self.tableView.setEmptyMessage(message: "No notifications here") : self.tableView.setEmptyMessage(message: "")
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: NotificationCell.cellIdentifier()) as? NotificationCell else {
            return UITableViewCell()
        }
        cell.ratingBtn.isHidden = true
        cell.ratingView.isHidden = true
        let obj = dataArr[indexPath.row]
        cell.titleLbl.text = obj.message
        cell.subtitleLbl.text = "Order Id : \(obj.orderNumber ?? "")"
        cell.dateLbl.text = timeAgoStringFromDate(date: obj.notificationDate ?? Date())
        //"\(obj.notificationDate?.dateString(format: "MMM dd, yyyy") ?? "") at \(obj.notificationDate?.dateString(format: "h:mm a") ?? "")"
//        if indexPath.row == 3 {
//            cell.ratingBtn.isHidden = false
//            cell.ratingView.isHidden = false
//            cell.ratingView.rating = 3
//        }
//        cell.ratingBtnTap = {
//            self.showRatingAlert()
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
//        let obj = dataArr[indexPath.row]
//        if obj.orderId?.count ?? 0 > 0{
//            let vc = MyOrderDetailVC.controller(storyboard: .Main, identifire: "MyOrderDetailVC") as! MyOrderDetailVC
//            let objOrder = SFOrder.newObject(entityName: "SFOrder") as! SFOrder
//            objOrder.orderId = obj.orderId
//            appUser?.dummyOrder = objOrder
//            vc.selectedOrder = objOrder
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
}
//MARK: - Rating alertProtocol delegate methods
extension NotificationVC: RatingAlertProtocolDelegate {
    func getRating(rating: Int) {
        //get rating here...
    }
}

extension NotificationVC{
    
    func timeAgoStringFromDate(date: Date) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full

        let now = Date()

        let calendar = NSCalendar.current
        let components1: Set<Calendar.Component> = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
        let components = calendar.dateComponents(components1, from: date, to: now)

        if components.year ?? 0 > 0 {
            formatter.allowedUnits = .year
        } else if components.month ?? 0 > 0 {
            formatter.allowedUnits = .month
        } else if components.weekOfMonth ?? 0 > 0 {
            formatter.allowedUnits = .weekOfMonth
        } else if components.day ?? 0 > 0 {
            formatter.allowedUnits = .day
        } else if components.hour ?? 0 > 0 {
            formatter.allowedUnits = [.hour]
        } else if components.minute ?? 0 > 0 {
            formatter.allowedUnits = .minute
        } else {
            formatter.allowedUnits = .second
        }

        let formatString = NSLocalizedString("%@ ago", comment: "Used to say how much time has passed. e.g. '2 hours ago'")

        guard let timeString = formatter.string(for: components) else {
            return nil
        }
        return String(format: formatString, timeString)
    }
}
