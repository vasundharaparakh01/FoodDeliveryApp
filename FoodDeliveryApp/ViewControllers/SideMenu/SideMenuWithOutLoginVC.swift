//
//  SideMenuWithOutLoginVC.swift
//  appName
//
//  Created by Varun Kumar Raghav on 20/05/22.
//

import UIKit

class SideMenuWithOutLoginVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var sideMenuHeaderView: UIView!
    
    var isGuest = false
    let imagesArray = ["myorder","customerservice","privacypolicy","termscondition","refund","info","contactus"]
    let titleArray = ["My Order","Customer Service","Privacy Policy","Terms & Conditions", "Refund And Shipping Policy", "About Us", "Contact Us"]
    
    fileprivate let appUser = SCoreDataHelper.shared.currentUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    // MARK: - initial Methods
    func initialSetup(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(SideMenuCell.createCellNib(), forCellReuseIdentifier: SideMenuCell.cellIdentifier())
    }
    
    //MARK: - selector and action methods
    @IBAction func logoutButtonAction(_ sender: UIButton) {
        
        if sender.currentTitle?.contains("Sign") ?? false{
            let loginVC = LoginVC()
            let navBar = UINavigationController.init(rootViewController: loginVC)
            navBar.isNavigationBarHidden = true
            navBar.modalTransitionStyle = .crossDissolve
            navBar.modalPresentationStyle = .overFullScreen
            self.present(navBar, animated: true, completion: nil)
        }else{
            RedirectionHelper.redirectToLogin()
        }
    }
    
    func setCenterPanel(viewController: UIViewController) {
        let navVC = UINavigationController(rootViewController: viewController)
        navVC.isNavigationBarHidden = true
        sceneDelegate?.FAPanelVC?.center(navVC)
    }
    
}
//MARK: - tableView delegate and datasource
extension SideMenuWithOutLoginVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isGuest ? 2 : titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.cellIdentifier()) as? SideMenuCell else { return UITableViewCell() }
        cell.cellImg.image = UIImage(named: imagesArray[indexPath.row])
        cell.cellLbl.text = titleArray[indexPath.row]
        switch indexPath.row {
        case 0:
            cell.cellBtnTap = {
                let vc = AddOrderPopupVC()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                vc.setCompletionBlock { success,orderNumber  in
                    if success{
                        let vc = MyOrderDetailVC.controller(storyboard: .Main, identifire: "MyOrderDetailVC") as! MyOrderDetailVC
                        vc.isFromSideMenu = true
                        let order = SFOrder.newObject(entityName: "SFOrder") as! SFOrder
                        order.customId = orderNumber
                        self.appUser?.dummyOrder = order
                        SCoreDataHelper.shared.saveContext()
                        vc.selectedOrder = order
                        self.setCenterPanel(viewController: vc)
                    }
                }
                self.present(vc, animated: true, completion: nil)
            }
            break
        case 1:
            cell.cellBtnTap = {
                let vc = CustomerServiceVC()
                self.setCenterPanel(viewController: vc)            }
//        case 2:
//            cell.cellBtnTap = {
//                let popvc = EditDeliveryTypeVC.controller(storyboard: .Main, identifire: "EditDeliveryTypeVC") as! EditDeliveryTypeVC
//                self.setCenterPanel(viewController: popvc)
//            }
        case 2:
            cell.cellBtnTap = {
                let vc = StaticPagesVC()
                vc.staticType = .privacy
                self.setCenterPanel(viewController: vc)
            }
        case 3:
            cell.cellBtnTap = {
                let vc = StaticPagesVC()
                vc.staticType = .terms
                self.setCenterPanel(viewController: vc)
            }
        case 4:
            cell.cellBtnTap = {
                let vc = StaticPagesVC()
                vc.staticType = .refundPolicy
                self.setCenterPanel(viewController: vc)
            }
        case 5:
            cell.cellBtnTap = {
                let vc = StaticPagesVC()
                vc.staticType = .aboutus
                self.setCenterPanel(viewController: vc)
            }
        case 6:
            cell.cellBtnTap = {
                let vc = StaticPagesVC()
                vc.staticType = .contactus
                self.setCenterPanel(viewController: vc)
            }
        default:
            cell.cellBtnTap = {
            
            }
            break
        }
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    
}
