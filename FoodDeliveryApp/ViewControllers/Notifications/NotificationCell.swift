//
//  NotificationCell.swift
//  FanServe
//
//  Created by Varun Kumar Raghav on 26/05/22.
//

import UIKit
import Cosmos

class NotificationCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var cellImg: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingBtn: UIButton!
    
    var ratingBtnTap: (()->()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.shadow(SHADOWCOLOR)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //MARK: - cell creation and id generation
    class func cellIdentifier() -> String {
        return String(describing: NotificationCell.self)
    }
    class func createCellNib() -> UINib {
        return UINib(nibName: NotificationCell.cellIdentifier(), bundle: nil)
    }
    
    @IBAction func ratingBtnAction(sender: UIButton) {
        self.ratingBtnTap()
    }
    
}
