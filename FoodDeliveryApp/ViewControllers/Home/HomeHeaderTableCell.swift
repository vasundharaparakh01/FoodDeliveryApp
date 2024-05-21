//
//  HomeHeaderTableCell.swift
//  appName
//
//  Created by McCoy Mart on 08/06/22.
//

import UIKit

class HomeHeaderTableCell: UITableViewCell {
    
    @IBOutlet weak var ticketButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var matchButton: UIButton!
    @IBOutlet weak var stadiumNameLabel: UILabel!
    @IBOutlet weak var firstTeamLogoImageView: UIImageView!
    @IBOutlet weak var firstTeamNameLabel: UILabel!
    @IBOutlet weak var secondTeamLogoImageView: UIImageView!
    @IBOutlet weak var secondTeamNameLabel: UILabel!
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
