//
//  SideMenuVC.swift
//  FanServe
//
//  Created by Varun Kumar Raghav on 20/05/22.
//

import UIKit

class SideMenuVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var sideMenuHeaderView: UIView!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var profileTitleBGView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var isGuest = false
    let imagesArray = ["editprofile","myorder","mywallet","customerservice","changepassword","faceid","privacypolicy","termscondition","refund","info","contactus"]
    let titleArray = ["Edit Profile","My Order","My Wallet","Customer Service","Change Password","Passcode & Face ID","Privacy Policy","Terms & Conditions", "Refund And Shipping Policy", "About Us", "Contact Us"]
    fileprivate let appUser = SCoreDataHelper.shared.currentUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    // MARK: - initial Methods
    func initialSetup(){
        profileTitleBGView.layer.cornerRadius = 25
        profileTitleBGView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        nameLabel.text = "\(appUser?.firstName ?? "") \(appUser?.lastName ?? "")"
        profileImg.imageLoad(urlString: "\(newsImageBaseUrl)\(appUser?.profileImage ?? "")", placeholder: UIImage(named: "userPlaceholderImage"))
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(SideMenuCell.createCellNib(), forCellReuseIdentifier: SideMenuCell.cellIdentifier())
    }
    
    //MARK: - selector and action methods
    @IBAction func logoutBtnAction(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: kFaceIDUnlock)
        RedirectionHelper.redirectToLogin()
    }
    
    @IBAction func profileBtnAction(_ sender: Any) {
    }
    
    func setCenterPanel(viewController: UIViewController) {
        let navVC = UINavigationController(rootViewController: viewController)
        navVC.isNavigationBarHidden = true
        sceneDelegate?.FAPanelVC?.center(navVC)
    }
    
    
}
//MARK: - tableView delegate and datasource
extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
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
                let vc = EditProfileVC()
                self.setCenterPanel(viewController: vc)            }
        case 1:
            cell.cellBtnTap = {
                let vc = MyOrderListVC()
                self.setCenterPanel(viewController: vc)
            }
            break
//        case 2:
//            cell.cellBtnTap = {
//                let payVC = PaymentVC.controller(storyboard: .Main, identifire: "PaymentVC") as! PaymentVC
//                payVC.isFromSideMenu = true
//                self.setCenterPanel(viewController: payVC)
//            }
//            break
//        case 2:
//            cell.cellBtnTap = {
////                let popvc = EditDeliveryTypeVC.controller(storyboard: .Main, identifire: "EditDeliveryTypeVC") as! EditDeliveryTypeVC
////                self.setCenterPanel(viewController: popvc)
//            }
//            break
        case 2:
            cell.cellBtnTap = {
                let payVC = PaymentVC.controller(storyboard: .Main, identifire: "PaymentVC") as! PaymentVC
                payVC.isFromSideMenu = true
                payVC.isFromMyWallet = true
                self.setCenterPanel(viewController: payVC)
            }
            break
        case 3:
            cell.cellBtnTap = {
                let vc = CustomerServiceVC()
                self.setCenterPanel(viewController: vc)
            }
            break
        case 4:
            cell.cellBtnTap = {
                let vc = ChangePassWordVC()
                self.setCenterPanel(viewController: vc)
            }
        case 5:
            cell.cellBtnTap = {
                print("faceiddd")
                let vc = FaceIdPasscodeViewController()
                self.setCenterPanel(viewController: vc)
            }
        case 6:
            cell.cellBtnTap = {
                let vc = StaticPagesVC()
                vc.staticType = .privacy
                self.setCenterPanel(viewController: vc)
            }
        case 7:
            cell.cellBtnTap = {
                let vc = StaticPagesVC()
                vc.staticType = .terms
                self.setCenterPanel(viewController: vc)
                
            }
        case 8:
            cell.cellBtnTap = {
                let vc = StaticPagesVC()
                vc.staticType = .refundPolicy
                self.setCenterPanel(viewController: vc)
            }
        case 9:
            cell.cellBtnTap = {
                let vc = StaticPagesVC()
                vc.staticType = .aboutus
                self.setCenterPanel(viewController: vc)
            }
        case 10:
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
