//
//  ViewPassbookVC.swift
//  appName
//
//  Created by McCoy Mart on 19/06/22.
//

import UIKit
import MBProgressHUD

class ViewPassbookVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    fileprivate let appUser = SCoreDataHelper.shared.currentUser()
    fileprivate var passbookArr = [SFNotification]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.aroundShadow()
        self.callWebApiToGetPassbookDetail()
    }
    
    @IBAction func sortButtonAction(_ sender: UIButton) {
        
        let vc = ProductSortVC.controller(storyboard: .Main, identifire: "ProductSortVC") as! ProductSortVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.setCompletionBlock { success, type in
            
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func callWebApiToGetPassbookDetail(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToGetPassbookList { success, responseDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success{
                SCoreDataHelper.shared.updatePassbookListData(params: responseDic!)
                if let list = self.appUser?.userPassbookEntries?.array as? [SFNotification]{
                    self.passbookArr = list
                }
                self.tblView.reloadData()
            }
        }
    }
}

extension ViewPassbookVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        passbookArr.count == 0 ? self.tblView.setEmptyMessage(message: "No transaction here") : self.tblView.setEmptyMessage(message: "")
        return passbookArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryTypeTableCell", for: indexPath) as! DeliveryTypeTableCell
        cell.baseView.aroundShadow()
        cell.imageBgView.aroundShadow()
        
        let obj = passbookArr[indexPath.row]
        cell.titleLabel.text = obj.title
        cell.dataLabel?.text = obj.message
        cell.amountLabel?.text = "MYR \((obj.amount/100).toValueFormat())"
        cell.dateLabel?.text = "\(obj.notificationDate?.dateString(format: "MMM dd, yyyy") ?? "") at \(obj.notificationDate?.dateString(format: "h:mm a") ?? "")"
        if obj.type == "debit"{
            cell.amountLabel?.textColor = UIColor.red
            cell.imgView.image = UIImage(named: "orderPassbookIcon")
        }else{
            cell.amountLabel?.textColor = UIColor(hex: "00CE15")
            cell.imgView.image = UIImage(named: "orderCancelIcon")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return UITableView.automaticDimension
    }
    
    
}

extension ViewPassbookVC : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let updatedText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if var listArr = self.appUser?.userPassbookEntries?.array as? [SFNotification]{
            if updatedText.count > 0{
                listArr = listArr.filter { (obj) -> Bool in
                    return ((obj.amount/100).toValueFormat().contains(updatedText.lowercased())) || (obj.title?.lowercased().contains(updatedText.lowercased()))!
                }
            }
            passbookArr = listArr
        }
        self.tblView.reloadData()
        return true
    }
}
