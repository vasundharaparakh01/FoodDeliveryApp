//
//  DeliveryTypeTableCell.swift
//  appName
//
//  Created by McCoy Mart on 15/06/22.
//

import UIKit

class DeliveryTypeTableCell: UITableViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var imageBgView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var amountLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var dataLabel: UILabel?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
