//
//  ExpressPickupPreorderVC.swift
//  appName
//
//  Created by McCoy Mart on 21/06/22.
//

import UIKit

protocol ExpressPickupPreorderVCDelegate {
    
    func onTapPreorderAction(objPreorder : PreorderModel?)
}

class ExpressPickupPreorderVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextfield: UITextField!
    
    var isExpressDelivery = false
    var isfromShopTab = false
    var delegate : ExpressPickupPreorderVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isExpressDelivery{
            titleLabel.text = "Now get your finger licking food delivered in 30 mins."
            detailLabel.text = "Please keep your order id or QR code handly to have a hassle-free delivery."
        }else{
            titleLabel.text = "Please keep your order id or QR code handly to have a hassle-free delivery."
            detailLabel.text = "Select your date & time."
        }
        dateTextField.leftPaddingPoints(width: 10)
        timeTextfield.leftPaddingPoints(width: 10)
        dateTextField.rightPaddingPoints(width: 50)
        timeTextfield.rightPaddingPoints(width: 50)

    }
    
    @IBAction func preorderButtonAction(_ sender: UIButton) {
        
        if isfromShopTab{
            self.delegate?.onTapPreorderAction(objPreorder: nil)
            self.dismiss(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension ExpressPickupPreorderVC : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        if textField == dateTextField{
            RPicker.selectDate(title: "Select Date", cancelText: "Cancel", doneText: "Select", datePickerMode: .date, selectDte: Date(), minDate: Date(), maxDate: nil, style: .wheel) { date in
                
                self.dateTextField.text = date.dateLocalStringFromDate("dd/MM/yy")
            }
        }else{
            RPicker.selectDate(title: "Select Time", cancelText: "Cancel", doneText: "Select", datePickerMode: .time, selectDte: Date(), minDate: nil, maxDate: nil, style: .wheel) { date in
                
                self.timeTextfield.text = date.dateLocalStringFromDate("HH:mm")
            }
        }
        return false
    }
}
