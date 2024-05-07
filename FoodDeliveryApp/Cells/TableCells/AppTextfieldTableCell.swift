//
//  AppTextfieldTableCell.swift
//  FanServe
//
//  Created by McCoy Mart on 22/06/22.
//

import UIKit

class AppTextfieldTableCell: UITableViewCell {
    
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
