//
//  AppTextviewTableCell.swift
//  FanServe
//
//  Created by McCoy Mart on 15/06/22.
//

import UIKit

class AppTextviewTableCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var txtView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
