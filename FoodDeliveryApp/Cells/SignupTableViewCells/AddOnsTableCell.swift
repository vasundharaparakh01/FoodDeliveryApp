//
//  AddOnsTableCell.swift
//  appName
//
//  Created by McCoy Mart on 15/06/22.
//

import UIKit

class AddOnsTableCell: UITableViewCell {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        deleteButton.aroundShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
