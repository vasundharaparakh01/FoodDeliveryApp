//
//  OnBoardingVC.swift
//  FanServe
//
//  Created by Varun Kumar Raghav on 18/05/22.
//

import UIKit

class OnBoardingVC: UIViewController {
    
    @IBOutlet var viewPageController: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var skipBtn: UIButton!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var getStartBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var titleArr = ["Fan enjoy their order","Fan places the order","Concession prepares the order","Same-day order ahead","Runner delivers the order"]
    fileprivate var imageArr = ["onboard1","onboard2","onboard3","onboard4","onboard5"]
    fileprivate var timer : Timer?
    fileprivate var index = 0
    
    let vwCurrentPage = UIView()
    let vw1 = UIView()
    let vw2 = UIView()
    let vw3 = UIView()
    let vw4 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getStartBtn.isHidden  = true
        
        collectionView.register(UINib(nibName: "OnBoardCollectionCell", bundle: nil), forCellWithReuseIdentifier: "OnBoardCollectionCell")
        
        vwCurrentPage.frame = CGRect(x: 0, y: 0, width: 38, height: 16)
        vw1.frame = CGRect(x: 48, y: 0, width: 16, height: 16)
        vw2.frame = CGRect(x: 74, y: 0, width: 16, height: 16)
        vw3.frame = CGRect(x: 100, y: 0, width: 16, height: 16)
        vw4.frame = CGRect(x: 126, y: 0, width: 16, height: 16)
        self.initialMethod()
    }
    
    func initialMethod () {
        vwCurrentPage.frame = CGRect(x: 0, y: 0, width: 38, height: 16)
        vwCurrentPage.layer.cornerRadius = vwCurrentPage.bounds.height/2
        vwCurrentPage.backgroundColor = RED
        
        vw1.frame = CGRect(x: 48, y: 0, width: 16, height: 16)
        vw1.layer.cornerRadius = vw1.bounds.height/2
        vw1.backgroundColor = .gray
        
        vw2.frame = CGRect(x: 74, y: 0, width: 16, height: 16)
        vw2.layer.cornerRadius = vw2.bounds.height/2
        vw2.backgroundColor = .gray
        
        vw3.frame = CGRect(x: 100, y: 0, width: 16, height: 16)
        vw3.layer.cornerRadius = vw3.bounds.height/2
        vw3.backgroundColor = .gray
        
        vw4.frame = CGRect(x: 126, y: 0, width: 16, height: 16)
        vw4.layer.cornerRadius = vw4.bounds.height/2
        vw4.backgroundColor = .gray
        
        viewPageController.addSubview(vwCurrentPage)
        viewPageController.addSubview(vw1)
        viewPageController.addSubview(vw2)
        viewPageController.addSubview(vw3)
        viewPageController.addSubview(vw4)
        
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(autoScrollTimer), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func autoScrollTimer(){
        
        index = index + 1
        switch index {
        case 0:
            break
        case 1:
            vw1.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
            vwCurrentPage.frame = CGRect(x: 26, y: 0, width: 38, height: 16)
            break
        case 2:
            vw2.frame = CGRect(x: 26, y: 0, width: 16, height: 16)
            vwCurrentPage.frame = CGRect(x: 52, y: 0, width: 38, height: 16)
            break
        case 3:
            vw3.frame = CGRect(x: 52, y: 0, width: 16, height: 16)
            vwCurrentPage.frame = CGRect(x: 78, y: 0, width: 38, height: 16)
            break
        case 4:
            timer?.invalidate()
            vw4.frame = CGRect(x: 78, y: 0, width: 16, height: 16)
            vwCurrentPage.frame = CGRect(x: 104, y: 0, width: 38, height: 16)
            self.getStartBtn.isHidden = false
            self.skipBtn.isHidden = true
            break
        default:
            break
        }
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
    }
    
    @IBAction func skipBtnAct(_ sender: Any) {
        self.getStartBtn.isHidden = false
        self.skipBtn.isHidden = true
    }
    
    @IBAction func btnGetStartedAct(_ sender: Any) {
        
        if SCoreDataHelper.shared.currentUser() == nil{
            SCoreDataHelper.shared.createAppUser(params: nil)
        }
        UserDefaults.standard.setValue(true, forKey: kSplashShown)
        sceneDelegate?.setSideMenu()
    }
    
}

extension OnBoardingVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnBoardCollectionCell", for: indexPath) as! OnBoardCollectionCell
        cell.titleLabel.text = titleArr[indexPath.item]
        cell.imgView.image = UIImage(named: imageArr[indexPath.item])
        cell.detailLabel.text = ""//"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus blandit pharetra sollicitudin."
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: self.collectionView.frame.size.width, height: self.collectionView.frame.size.height)
    }
}

extension OnBoardingVC : UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == collectionView{
            var visibleRect = CGRect()
            visibleRect.origin = collectionView.contentOffset
            visibleRect.size = collectionView.bounds.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            
            vwCurrentPage.frame = CGRect(x: 0, y: 0, width: 38, height: 16)
            vw1.frame = CGRect(x: 48, y: 0, width: 16, height: 16)
            vw2.frame = CGRect(x: 74, y: 0, width: 16, height: 16)
            vw3.frame = CGRect(x: 100, y: 0, width: 16, height: 16)
            vw4.frame = CGRect(x: 126, y: 0, width: 16, height: 16)
            
            guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
            index = indexPath.item
            switch indexPath.item {
            case 0:
                vwCurrentPage.frame = CGRect(x: 0, y: 0, width: 38, height: 16)
                vw1.frame = CGRect(x: 48, y: 0, width: 16, height: 16)
                vw2.frame = CGRect(x: 74, y: 0, width: 16, height: 16)
                vw3.frame = CGRect(x: 100, y: 0, width: 16, height: 16)
                vw4.frame = CGRect(x: 126, y: 0, width: 16, height: 16)
                break
            case 1:
                vw1.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
                vwCurrentPage.frame = CGRect(x: 26, y: 0, width: 38, height: 16)
                vw2.frame = CGRect(x: 74, y: 0, width: 16, height: 16)
                vw3.frame = CGRect(x: 100, y: 0, width: 16, height: 16)
                vw4.frame = CGRect(x: 126, y: 0, width: 16, height: 16)
                break
            case 2:
                vw1.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
                vw2.frame = CGRect(x: 26, y: 0, width: 16, height: 16)
                vwCurrentPage.frame = CGRect(x: 52, y: 0, width: 38, height: 16)
                vw3.frame = CGRect(x: 100, y: 0, width: 16, height: 16)
                vw4.frame = CGRect(x: 126, y: 0, width: 16, height: 16)
                break
            case 3:
                vw1.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
                vw2.frame = CGRect(x: 26, y: 0, width: 16, height: 16)
                vw3.frame = CGRect(x: 52, y: 0, width: 16, height: 16)
                vwCurrentPage.frame = CGRect(x: 78, y: 0, width: 38, height: 16)
                vw4.frame = CGRect(x: 126, y: 0, width: 16, height: 16)
                break
            case 4:
                vw1.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
                vw2.frame = CGRect(x: 26, y: 0, width: 16, height: 16)
                vw3.frame = CGRect(x: 52, y: 0, width: 16, height: 16)
                vw4.frame = CGRect(x: 78, y: 0, width: 16, height: 16)
                timer?.invalidate()
                vwCurrentPage.frame = CGRect(x: 104, y: 0, width: 38, height: 16)
                self.getStartBtn.isHidden = false
                self.skipBtn.isHidden = true
                break
            default:
                break
            }
        }
    }
}

