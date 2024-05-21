//
//  PagerCollectionCell.swift
//  appName
//
//  Created by Varun Kumar Raghav on 25/05/22.
//

import UIKit

class PagerCollectionCell: UICollectionViewCell {

    @IBOutlet weak var cellBtn: UIButton!
    @IBOutlet weak var bottomLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    var cellBtnTap: (()->()) = {}
    let font = UIFont(name: "Poppins-Medium", size: 18)

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLbl.font = font
    }
    //MARK: - cell creation and id generation
    class func cellIdentifier() -> String {
        return String(describing: PagerCollectionCell.self)
    }
    class func createCellNib() -> UINib {
        return UINib(nibName: PagerCollectionCell.cellIdentifier(), bundle: nil)
    }
    //MARK: - action methods
    @IBAction func btnAction(_ sender: UIButton) {
        self.cellBtnTap()
    }
}
