//
//  EwalletsListVC.swift
//  appName
//
//  Created by McCoy Mart on 19/06/22.
//

import UIKit

class EwalletsListVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    fileprivate var walletArr = ["Apple pay","Google pay"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension EwalletsListVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppHeaderTableCell", for: indexPath) as! AppHeaderTableCell
        cell.bgView.aroundShadow()
        cell.itemLabel.text = walletArr[indexPath.row]
        cell.imgView.image = UIImage(named: indexPath.row == 0 ? "applePayIcon" : "gPayIcon")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc1 = CancelOrderVC()
        vc1.modalTransitionStyle = .crossDissolve
        vc1.modalPresentationStyle = .overFullScreen
        vc1.screenType = "wallet"
        self.present(vc1, animated: true, completion: nil)
    }
}
