//
//  MatchTableHeaderCell.swift
//  FanServe
//
//  Created by Varun Kumar Raghav on 25/05/22.
//

import UIKit

class MatchTableHeaderCell: UITableViewCell {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var lbl2: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //MARK: - cell creation and id generation
    class func cellIdentifier() -> String {
        return String(describing: MatchTableHeaderCell.self)
    }
    class func createCellNib() -> UINib {
        return UINib(nibName: MatchTableHeaderCell.cellIdentifier(), bundle: nil)
    }
    
}
