//
//  SideMenuCell.swift
//  appName
//
//  Created by Varun Kumar Raghav on 20/05/22.
//

import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var cellLbl: UILabel!
    @IBOutlet weak var cellBtn: UIButton!
    @IBOutlet weak var cellImg: UIImageView!
    var cellBtnTap: (()->()) = {}
    let lblFont = UIFont(name: "Poppins-Regular", size: 18)


    override func awakeFromNib() {
        super.awakeFromNib()
        cellLbl.font = lblFont
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class func cellIdentifier() -> String {
        return String(describing: SideMenuCell.self)
    }
    
    class func createCellNib() -> UINib {
        return UINib(nibName: SideMenuCell.cellIdentifier(), bundle: nil)
    }
    
    //MARK: - action Methods
    @IBAction func cellBtnAction(sender: UIButton) {
        cellBtnTap()
    }
    
}
