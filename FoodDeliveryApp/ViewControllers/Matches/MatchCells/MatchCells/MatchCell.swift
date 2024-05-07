//
//  MatchCell.swift
//  FanServe
//
//  Created by Varun Kumar Raghav on 25/05/22.
//

import UIKit

class MatchCell: UITableViewCell {

    @IBOutlet weak var stadiumNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var ticketBtn: UIButton!
    @IBOutlet weak var firstTeamNameLbl: UILabel!
    @IBOutlet weak var firstTeamImg: UIImageView!

    @IBOutlet weak var secondTeamNameLbl: UILabel!
    @IBOutlet weak var secondTeamImg: UIImageView!

    var ticketBtnTap: (()->()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //MARK: - cell creation and id generation
    class func cellIdentifier() -> String {
        return String(describing: MatchCell.self)
    }
    class func createCellNib() -> UINib {
        return UINib(nibName: MatchCell.cellIdentifier(), bundle: nil)
    }
    
    @IBAction func ticketBtnAction(sender: UIButton) {
        self.ticketBtnTap()
    }
    
}
