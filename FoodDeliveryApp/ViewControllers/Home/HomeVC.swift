//
//  HomeVC.swift
//  appName
//
//  Created by Varun Kumar Raghav on 20/05/22.
//

import UIKit
import MBProgressHUD

class HomeVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var navUserNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var parallaxView: UIView!
    @IBOutlet weak var stadiumNameLabel: UILabel!
    @IBOutlet weak var cartButton: MIBadgeButton!
    @IBOutlet weak var firstTeamLogoImageView: UIImageView!
    @IBOutlet weak var secondTeamLogoImageView: UIImageView!
    @IBOutlet weak var topNavBarView: UIView!
    
    fileprivate let appUser = SCoreDataHelper.shared.currentUser()
    fileprivate var dataSourceArr = [SFNews]()
    fileprivate var selectedMatch : SFMatch?
    fileprivate var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialMethod()
        self.callWebApiToGetTicketToken()
        self.callWebApiToGetNewsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        callWebApiToGetCartCount()
        
    }
    
    //MARK: - initial methods
    
    func initialMethod() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(HomeTableCells.createCellNib(), forCellReuseIdentifier: HomeTableCells.cellIdentifier())
        
        navUserNameLabel.text = "\(appUser?.firstName ?? "")"
        profileImageView.imageLoad(urlString: "\(newsImageBaseUrl)\(appUser?.profileImage ?? "")", placeholder: UIImage(named: "userPlaceholderImage"))
        
        tableView.register(UINib(nibName: "HomeHeaderTableCell", bundle: nil), forCellReuseIdentifier: "HomeHeaderTableCell")
    }
    
    // MARK: - Actions
    
    @IBAction func cartButtonAction(_ sender: UIButton) {
        
        if !(appUser?.isCurrentlyLogin ?? false){
            let loginVC = LoginVC()
            let navBar = UINavigationController.init(rootViewController: loginVC)
            navBar.isNavigationBarHidden = true
            navBar.modalTransitionStyle = .crossDissolve
            navBar.modalPresentationStyle = .overFullScreen
            self.present(navBar, animated: true, completion: nil)
            return
        }
        let vc = MyCartVC.controller(storyboard: .Main, identifire: "MyCartVC") as! MyCartVC
        sceneDelegate?.navController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func menuBtnAction(_ sender: UIButton) {
        sceneDelegate?.FAPanelVC?.openLeft(animated: true)
    }
    
    @IBAction func upcomingMatchesBtnAction(_ sender: UIButton){
        sceneDelegate?.navController?.pushViewController(MatchScheduleVC(), animated: true)
    }
    
    @IBAction func ticketsButtonAction(_ sender: UIButton) {
        
        guard let url = URL(string: "https://ticket.tickethotline.com.my/") else { return }
        UIApplication.shared.open(url)
    }
    //MARK: - Web Service methods
    
    fileprivate func callWebApiToGetCartCount(){
        
        if !(appUser?.isCurrentlyLogin ?? false){
            return
        }
        SDataHelper.shared.callWebApiToGetCartCount { success, dataDic in
            
            if success{
                self.cartButton.badgeString = (self.appUser?.cartCount ?? 0) == 0 ? "" : "\(self.appUser?.cartCount ?? 0)"
            }
        }
    }
    
    fileprivate func callWebApiToGetTicketToken(){
        
        tableView.isHidden = true
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToGetTicketToken { success, dataDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success{
                if let token = dataDic?["token"] as? String{
                    USERDEFAULT.set(token, forKey: kAccessTicketToken)
                    USERDEFAULT.synchronize()
                }
                self.callWebApiToGetMatchList()
            }
        }
    }
    
    fileprivate func callWebApiToGetMatchList(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToGetMatchList { success, dataDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success{
                SCoreDataHelper.shared.updateMatchListData(params: dataDic!)
                if let list = self.appUser?.matchList?.array as? [SFMatch]{
                    if let obj = list.get(at: 1){
                        self.selectedMatch = obj
                    }
                }
                self.tableView.reloadData()
                self.perform(#selector(self.loadDataOnHeaderView), with: nil, afterDelay: 0.5)
            }
        }
    }
    
    @objc fileprivate func loadDataOnHeaderView(){
        
        stadiumNameLabel.text = selectedMatch?.stadiumName
        firstTeamLogoImageView.imageLoad(urlString: selectedMatch?.homeClubLogo ?? "", placeholder: UIImage(named: ""))
        secondTeamLogoImageView.imageLoad(urlString: selectedMatch?.awayClubLogo ?? "", placeholder: UIImage(named: ""))
        
        let totalSoconds = selectedMatch?.matchDate?.seconds(from: Date().localDate()) ?? 0
        print(String(describing: totalSoconds))
        timer = nil
        if totalSoconds > 0 {
            let cellHeader = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! HomeHeaderTableCell
            cellHeader.matchCountDownTitleLabel.isHidden = false
            cellHeader.daysView.isHidden = false
            cellHeader.daysTitleLabel.isHidden = false
            cellHeader.daysColonLabel.isHidden = false
            cellHeader.hourView.isHidden = false
            cellHeader.hourColonLabel.isHidden = false
            cellHeader.hrsTitleLabel.isHidden = false
            cellHeader.minsView.isHidden = false
            cellHeader.minsColonLabel.isHidden = false
            cellHeader.minsTitleLabel.isHidden = false
            cellHeader.secondView.isHidden = false
            cellHeader.secsTitleLabel.isHidden = false
            cellHeader.scoreBoardView.isHidden = true
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }else{
            let cellHeader = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! HomeHeaderTableCell
//            cellHeader.matchCountDownTitleLabel.isHidden = true
//            cellHeader.daysView.isHidden = true
//            cellHeader.daysTitleLabel.isHidden = true
//            cellHeader.daysColonLabel.isHidden = true
//            cellHeader.hourView.isHidden = true
//            cellHeader.hourColonLabel.isHidden = true
//            cellHeader.hrsTitleLabel.isHidden = true
//            cellHeader.minsView.isHidden = true
//            cellHeader.minsColonLabel.isHidden = true
//            cellHeader.minsTitleLabel.isHidden = true
//            cellHeader.secondView.isHidden = true
//            cellHeader.secsTitleLabel.isHidden = true
//            cellHeader.scoreBoardView.isHidden = false
            
            cellHeader.matchCountDownTitleLabel.isHidden = false
            cellHeader.daysView.isHidden = false
            cellHeader.daysTitleLabel.isHidden = false
            cellHeader.daysColonLabel.isHidden = false
            cellHeader.hourView.isHidden = false
            cellHeader.hourColonLabel.isHidden = false
            cellHeader.hrsTitleLabel.isHidden = false
            cellHeader.minsView.isHidden = false
            cellHeader.minsColonLabel.isHidden = false
            cellHeader.minsTitleLabel.isHidden = false
            cellHeader.secondView.isHidden = false
            cellHeader.secsTitleLabel.isHidden = false
            cellHeader.scoreBoardView.isHidden = true
        }
    }
    
    @objc func updateTimer() {
        
        let currentDate = Date().localDate()
        let matchDate = (selectedMatch?.matchDate)!
        let calendar = Calendar.current
       // let unitFlags = Set<Calendar.Component>([ .second])
        let datecomponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: matchDate)
        
        if let cellHeader = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HomeHeaderTableCell {
            cellHeader.secondLabel.text = String(format: "%02d", datecomponents.second!)
            cellHeader.minuteLabel.text = String(format: "%02d", datecomponents.minute!)
            cellHeader.hourLabel.text = String(format: "%02d", datecomponents.hour!)
            cellHeader.dayLabel.text = String(format: "%02d", datecomponents.day!)
        }
    }
    
    fileprivate func callWebApiToGetNewsList(){
        
        var param = Dictionary<String, Any>()
        param["limit"] = "10"
        param["page"] = "1"
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SDataHelper.shared.callWebApiToGetNewsList(params: param) { success, dataDic in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success{
                SCoreDataHelper.shared.updateNewsListData(params: dataDic!)
                if let list = self.appUser?.newsList?.array as? [SFNews]{
                    self.dataSourceArr = list
                }
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
    
}

//MARK: - tableview delegate and datasource methods

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderTableCell") as? HomeHeaderTableCell else { return UITableViewCell() }
            cell.matchButton.addTarget(self, action: #selector(upcomingMatchesBtnAction(_:)), for: .touchUpInside)
            cell.ticketButton.addTarget(self, action: #selector(ticketsButtonAction(_:)), for: .touchUpInside)
            cell.stadiumNameLabel.text = selectedMatch?.stadiumName
            cell.firstTeamLogoImageView.imageLoad(urlString: selectedMatch?.homeClubLogo ?? "", placeholder: UIImage(named: ""))
            cell.secondTeamLogoImageView.imageLoad(urlString: selectedMatch?.awayClubLogo ?? "", placeholder: UIImage(named: ""))
            cell.firstTeamNameLabel.text = selectedMatch?.homeClub
            cell.secondTeamNameLabel.text = selectedMatch?.awayClub
            cell.dateLabel.text = selectedMatch?.matchDate?.dateLocalStringFromDate("dd/MM/yyyy")
            
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableCells.cellIdentifier()) as? HomeTableCells else { return UITableViewCell() }
            let obj = dataSourceArr[indexPath.row - 1]
            cell.cellImg.imageLoad(urlString: "\(newsImageBaseUrl)\(obj.coverImage ?? "")", placeholder: UIImage(named: ""))
            cell.cellLbl.text = obj.title
            cell.timeLeftLbl.text = timeAgoStringFromDate(date: obj.newsDate ?? Date())
            
            cell.infoBtnTap = {
                let vc = NewsDetailsVC()
                vc.selectedNews = obj
                sceneDelegate?.navController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return indexPath.row == 0 ? 225 : UITableView.automaticDimension//600
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if indexPath.row == 0{
            return
        }
        let vc = NewsDetailsVC()
        vc.selectedNews = dataSourceArr[indexPath.row - 1]
        sceneDelegate?.navController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        if scrollView == tableView{
            if scrollView.contentOffset.y > 140{
                parallaxView.isHidden = false
            }else{
                parallaxView.isHidden = true
            }
        }
    }
}

extension HomeVC : TicketScanVCDelegateProtocol{
    
    func getTicketDetails(ticketNum: String) {
        
        if !ticketNum.isEmpty {
            let vc = ConfirmSeatNumVC()
            vc.delegate = self
            vc.seatNum = "A-26"
            vc.isEdit = false
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func closeButtonAction() {
        
    }
}

extension HomeVC : ConfirmSeatNumVCDelegate {
    
    func getSeatNumber(seatNumber: String) {
        //self.ticketNum = seatNumber
        // here we get the confirmed seat number and move to home vc
        let vc = MyCartVC.controller(storyboard: .Main, identifire: "MyCartVC") as! MyCartVC
        sceneDelegate?.navController?.pushViewController(vc, animated: true)
        
    }
}

extension HomeVC{
    
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
