//
//  SignupHeaderCell.swift
//  FanServe
//
//  Created by Varun Kumar Raghav on 19/05/22.
//

import UIKit

class SignupHeaderCell: UITableViewCell {
    @IBOutlet weak var cellLbl: UILabel!
    @IBOutlet weak var infoBtn: UIButton!
    var infoBtnTap: (()->()) = {}
    let lblFont = UIFont(name: "Poppins-SemiBold", size: 18)


    override func awakeFromNib() {
        super.awakeFromNib()
        cellLbl.font = lblFont
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class func cellIdentifier() -> String {
        return String(describing: SignupHeaderCell.self)
    }
    
    class func createCellNib() -> UINib {
        return UINib(nibName: SignupHeaderCell.cellIdentifier(), bundle: nil)
    }
    
    //MARK: - action Methods
    @IBAction func infoBtnAction(sender: UIButton) {
        infoBtnTap()
    }
    
}
