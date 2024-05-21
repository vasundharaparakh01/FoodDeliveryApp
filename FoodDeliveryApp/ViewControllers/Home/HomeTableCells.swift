//
//  HomeTableCells.swift
//  appName
//
//  Created by Varun Kumar Raghav on 24/05/22.
//

import UIKit

class HomeTableCells: UITableViewCell {

    @IBOutlet weak var cellLbl: UILabel!
    @IBOutlet weak var timeLeftLbl: UILabel!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var cellImg: UIImageView!
    
    var infoBtnTap: (()->()) = {}
    //let lblFont = UIFont(name: "Poppins-SemiBold", size: 24)

    override func awakeFromNib() {
        super.awakeFromNib()
        //cellLbl.font = lblFont
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class func cellIdentifier() -> String {
        return String(describing: HomeTableCells.self)
    }
    
    class func createCellNib() -> UINib {
        return UINib(nibName: HomeTableCells.cellIdentifier(), bundle: nil)
    }
    
    //MARK: - action Methods
    @IBAction func infoBtnAction(sender: UIButton) {
        infoBtnTap()
    }
    
}
