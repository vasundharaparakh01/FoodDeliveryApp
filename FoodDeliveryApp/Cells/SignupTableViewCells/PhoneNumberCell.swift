//
//  PhoneNumberCell.swift
//  appName
//
//  Created by Varun Kumar Raghav on 19/05/22.
//

import UIKit

class PhoneNumberCell: UITableViewCell {
    @IBOutlet weak var cellTextField: CustomTextField!
    @IBOutlet weak var cellMainView: UIView!
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var countryCodeLbl: UILabel!
    
    var countryCodeBtnTap: (()->()) = {}
    
    //MARK: - lifecycle methods

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - cell creation and identification
    class func cellIdentifier() -> String {
        return String(describing: PhoneNumberCell.self)
    }
    
    class func createCellNib() -> UINib {
        return UINib(nibName: PhoneNumberCell.cellIdentifier(), bundle: nil)
    }
    
    //MARK: - action Methods
    @IBAction func countryCodeBtnAction(sender: UIButton) {
        countryCodeBtnTap()
    }
}
