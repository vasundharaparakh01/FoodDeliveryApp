//
//  StandingsCell.swift
//  FanServe
//
//  Created by Varun Kumar Raghav on 25/05/22.
//

import UIKit

class StandingsCell: UITableViewCell {
    @IBOutlet weak var positionLbl: UILabel!
    @IBOutlet weak var teamNameLbl: UILabel!
    @IBOutlet weak var teamImg: UIImageView!

    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var playedLbl: UILabel!
    @IBOutlet weak var drawLbl: UILabel!
    @IBOutlet weak var winsLbl: UILabel!
    @IBOutlet weak var lostLbl: UILabel!
    
    @IBOutlet weak var topContstraint: NSLayoutConstraint!
    @IBOutlet weak var topHeader: UIView!


    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //MARK: - cell creation and id generation
    class func cellIdentifier() -> String {
        return String(describing: StandingsCell.self)
    }
    class func createCellNib() -> UINib {
        return UINib(nibName: StandingsCell.cellIdentifier(), bundle: nil)
    }
    
}
