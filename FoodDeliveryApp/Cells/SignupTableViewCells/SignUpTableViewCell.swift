//
//  SignUpTableViewCell.swift
//  GoGuards
//
//  Created by Varun Kumar Raghav on 19/11/21.
//

import UIKit

class SignUpTableViewCell: UITableViewCell {
    @IBOutlet weak var cellTextField: CustomTextField!
    @IBOutlet weak var cellCheckImage: UIImageView!
    @IBOutlet weak var cellMainView: UIView!
    @IBOutlet weak var cellImageView: UIView!
    
    var textFieldFont = UIFont(name: "Poppins-Regular", size: 18)
    
    //MARK: - lifecycle methods

    override func awakeFromNib() {
        super.awakeFromNib()
        cellTextField.font = textFieldFont
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //MARK: - cell creation and identification
    class func signUpTableCellIdentifier() -> String {
        return String(describing: SignUpTableViewCell.self)
    }
    
    class func createSignUpTableViewCellNib() -> UINib {
        return UINib(nibName: SignUpTableViewCell.signUpTableCellIdentifier(), bundle: nil)
    }

}
