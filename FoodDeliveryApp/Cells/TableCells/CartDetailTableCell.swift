//
//  CartDetailTableCell.swift
//  FanServe
//
//  Created by McCoy Mart on 15/06/22.
//

import UIKit

class CartDetailTableCell: UITableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var seatNoLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var txtField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
