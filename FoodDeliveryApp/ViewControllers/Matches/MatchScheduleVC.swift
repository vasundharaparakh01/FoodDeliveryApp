//
//  MatchScheduleVC.swift
//  FanServe
//
//  Created by Varun Kumar Raghav on 25/05/22.
//

import UIKit
import MBProgressHUD

class MatchScheduleVC: UIViewController {
    
    enum PagerCategory: String {
        case schedule = "Schedule"
        case results = "Results"
        case standings = "Standings"
        
        static let allValues = [schedule,results,standings]
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var firstTeamLogoImageView: UIImageView!
    @IBOutlet weak var firstTeamLabel: UILabel!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var secondTeamLogoImageView: UIImageView!
    @IBOutlet weak var stadiumNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var matchCountDownTitleLabel: UILabel!
    @IBOutlet weak var daysColonLabel: UILabel!
    @IBOutlet weak var daysView: UIView!
    @IBOutlet weak var hourView: UIView!
    @IBOutlet weak var hourColonLabel: UILabel!
    @IBOutlet weak var minsView: UIView!
    @IBOutlet weak var minsColonLabel: UILabel!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var daysTitleLabel: UILabel!
    @IBOutlet weak var hrsTitleLabel: UILabel!
    @IBOutlet weak var minsTitleLabel: UILabel!
    @IBOutlet weak var secsTitleLabel: UILabel!
    @IBOutlet weak var scoreBoardView: UIView!
    
    fileprivate var dataSourceArr = [SFMatch]()
    fileprivate let appUser = SCoreDataHelper.shared.currentUser()
    fileprivate var selectedMatch : SFMatch?
    fileprivate var timer: Timer?
//    var selectedCategroy: PagerCategory = .schedule
//    var selectedIndex = 0
    
    //MARK: - lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        
        self.callWebApiToGetTicketToken()
    }
    
    //MARK: - intial Setup methods
    func initialSetup() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(MatchCell.createCellNib(), forCellReuseIdentifier: MatchCell.cellIdentifier())
        
        self.tableView.register(StandingsCell.createCellNib(), forCellReuseIdentifier: StandingsCell.cellIdentifier())
        
        self.tableView.register(MatchTableHeaderCell.createCellNib(), forCellReuseIdentifier: MatchTableHeaderCell.cellIdentifier())
        
        self.tableView.register(SectionCategoryCell.createCellNib(), forCellReuseIdentifier: SectionCategoryCell.cellIdentifier())
    }
    
    //MARK: - selector methods
    func setSelected(title: UILabel, line: UILabel) {
        UIView.animate(withDuration: 0.2,
                       animations: {
            line.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            title.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.2) {
                line.transform = CGAffineTransform.identity
                title.transform = CGAffineTransform.identity
            }
        })
        title.textColor = .black
        title.font = UIFont(name: "Poppins-Medium", size: 18)
        line.isHidden = false
    }
    
    //MARK: - action methods
    @IBAction func backBtnAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func headerTicketButtonAction(_ sender: UIButton) {
        
        guard let url = URL(string: "https://ticket.tickethotline.com.my/") else { return }
        UIApplication.shared.open(url)
    }
    
    //MARK: - Web Service methods
    
    fileprivate func callWebApiToGetTicketToken(){
        
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
                    self.dataSourceArr = list
                }
                if let obj = self.dataSourceArr.first{
                    self.selectedMatch = obj
                }
                self.dataSourceArr.removeFirst()
                self.loadDataOnHeaderView()
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func loadDataOnHeaderView(){
        
        stadiumNameLabel.text = selectedMatch?.stadiumName
        dateLabel.text = selectedMatch?.matchDate?.dateLocalStringFromDate("dd/MM/yyyy")
        firstTeamLogoImageView.imageLoad(urlString: selectedMatch?.homeClubLogo ?? "", placeholder: UIImage(named: "imagePlaceholder"))
        secondTeamLogoImageView.imageLoad(urlString: selectedMatch?.awayClubLogo ?? "", placeholder: UIImage(named: ""))
        firstTeamLabel.text = selectedMatch?.homeClub
        secondNameLabel.text = selectedMatch?.awayClub
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.locale = .current
        formatter.timeZone = TimeZone(identifier: "UTC")
        timeLabel.text = formatter.string(from: (selectedMatch?.matchDate)!) //selectedMatch?.matchDate?.dateCurrentZoneFromDate()
        
        let totalSoconds = selectedMatch?.matchDate?.seconds(from: Date().localDate()) ?? 0
        print(String(describing: totalSoconds))
        timer = nil
        if totalSoconds > 0{
            matchCountDownTitleLabel.isHidden = false
            daysView.isHidden = false
            daysTitleLabel.isHidden = false
            daysColonLabel.isHidden = false
            hourView.isHidden = false
            hourColonLabel.isHidden = false
            hrsTitleLabel.isHidden = false
            minsView.isHidden = false
            minsColonLabel.isHidden = false
            minsTitleLabel.isHidden = false
            secondView.isHidden = false
            secsTitleLabel.isHidden = false
            scoreBoardView.isHidden = true
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }else{
            matchCountDownTitleLabel.isHidden = true
            daysView.isHidden = true
            daysTitleLabel.isHidden = true
            daysColonLabel.isHidden = true
            hourView.isHidden = true
            hourColonLabel.isHidden = true
            hrsTitleLabel.isHidden = true
            minsView.isHidden = true
            minsColonLabel.isHidden = true
            minsTitleLabel.isHidden = true
            secondView.isHidden = true
            secsTitleLabel.isHidden = true
            scoreBoardView.isHidden = false
        }
    }
    
    @objc func updateTimer() {
        
        let currentDate = Date().localDate()
        let matchDate = (selectedMatch?.matchDate)!
        let calendar = Calendar.current
       // let unitFlags = Set<Calendar.Component>([ .second])
        let datecomponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: matchDate)
        
        secondLabel.text = String(format: "%02d", datecomponents.second!)
        minuteLabel.text = String(format: "%02d", datecomponents.minute!)
        hourLabel.text = String(format: "%02d", datecomponents.hour!)
        dayLabel.text = String(format: "%02d", datecomponents.day!)
    }
}

//MARK: - tableView delegate and datasource methods
extension MatchScheduleVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArr.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = self.tableView.dequeueReusableCell(withIdentifier: MatchTableHeaderCell.cellIdentifier()) as? MatchTableHeaderCell else { return UITableViewCell() }
        
        header.headerLbl.text = "Upcoming"
        header.lbl2.text = "Schedule"
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let matchCell = self.tableView.dequeueReusableCell(withIdentifier: MatchCell.cellIdentifier()) as? MatchCell else { return UITableViewCell() }
        let obj = dataSourceArr[indexPath.row]
        matchCell.stadiumNameLbl.text = obj.stadiumName
        matchCell.dateLbl.text = obj.matchDate?.dateLocalStringFromDate("dd/MM/yyyy")
        matchCell.firstTeamImg.imageLoad(urlString: obj.homeClubLogo ?? "", placeholder: UIImage(named: ""))
        matchCell.secondTeamImg.imageLoad(urlString: obj.awayClubLogo ?? "", placeholder: UIImage(named: ""))
        matchCell.firstTeamNameLbl.text = obj.homeClub
        matchCell.secondTeamNameLbl.text = obj.awayClub
        matchCell.ticketBtnTap = {
            guard let url = URL(string: "https://ticket.tickethotline.com.my/") else { return }
            UIApplication.shared.open(url)
        }
        return matchCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

//MARK: - collectionVeiw delegate and datasource methods

//extension MatchScheduleVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PagerCollectionCell.cellIdentifier(), for: indexPath) as!
//        PagerCollectionCell
//        let categories = MatchScheduleVC.PagerCategory.allValues.map { $0 }
//        cell.titleLbl.text = categories[indexPath.item].rawValue
//
//        cell.bottomLbl.isHidden = true
//        if indexPath.item == selectedIndex {
//            self.setSelected(title: cell.titleLbl, line: cell.bottomLbl)
//        }
//        cell.cellBtnTap = {
//            self.selectedIndex = indexPath.item
//            self.selectedCategroy = categories[indexPath.item]
//            self.tableView.reloadData()
//        }
//        return cell
//
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width/3-5, height: 40)
//    }
//}
