//
//  InSeatDeliveryPreorderVC.swift
//  FanServe
//
//  Created by McCoy Mart on 22/06/22.
//

import UIKit

class InSeatDeliveryPreorderVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var backButtonView: UIView!
    
    var isfromShopTab = false
    var isFromCartPreorder = false
    var delegate : ExpressPickupPreorderVCDelegate?
    fileprivate var objPreOrder = PreorderModel()
    fileprivate let appUser = SCoreDataHelper.shared.currentUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButtonView.isHidden = !isFromCartPreorder
        
       // if isFromCartPreorder{
            objPreOrder.seatNo = appUser?.ticketDetail?.seatNumber ?? ""
            objPreOrder.zone = appUser?.ticketDetail?.stadiumZone ?? ""
            objPreOrder.tournament = appUser?.ticketDetail?.matchName ?? ""
            objPreOrder.date = appUser?.ticketDetail?.matchDate?.dateString(format: "YYYY-MM-dd") ?? ""
            objPreOrder.time = appUser?.ticketDetail?.matchDate?.dateString(format: "hh:mm a") ?? ""
       // }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func beginPreorderButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if isfromShopTab{
            if isValidateAllFields(){
                self.delegate?.onTapPreorderAction(objPreorder: objPreOrder)
                self.dismiss(animated: true)
            }
        }else{
            if isValidateAllFields(){
                let payVC = PaymentVC.controller(storyboard: .Main, identifire: "PaymentVC") as! PaymentVC
                payVC.isFromPreorder = true
                payVC.objPreOrder = objPreOrder
                self.navigationController?.pushViewController(payVC, animated: true)
            }
        }
    }
    
    fileprivate func isValidateAllFields() -> Bool{
        
        var isValid = false
        if objPreOrder.date.count == 0{
            MessageView.showMessage(message: "Please select date.", time: 2.0, verticalAlignment: .bottom)
        }else if objPreOrder.tournament.count == 0{
            MessageView.showMessage(message: "Please enter tournament.", time: 2.0, verticalAlignment: .bottom)
        }else if objPreOrder.zone.count == 0{
            MessageView.showMessage(message: "Please enter zone.", time: 2.0, verticalAlignment: .bottom)
        }else if objPreOrder.seatNo.count == 0{
            MessageView.showMessage(message: "Please enter seat number.", time: 2.0, verticalAlignment: .bottom)
        }else if objPreOrder.time.count == 0{
            MessageView.showMessage(message: "Please select time.", time: 2.0, verticalAlignment: .bottom)
        }else{
            isValid = true
        }
        return isValid
    }
}

extension InSeatDeliveryPreorderVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppTextfieldTableCell", for: indexPath) as! AppTextfieldTableCell
        cell.txtField.leftPaddingPoints(width: 10)
        cell.txtField.rightPaddingPoints(width: 0)
        cell.txtField.tag = indexPath.row + 100
        cell.imageButton.isHidden = true
        cell.txtField.keyboardType = .default
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Select Date"
            cell.txtField.placeholder = "00/00/00"
            cell.txtField.text = objPreOrder.date
            cell.txtField.rightPaddingPoints(width: 50)
            cell.imageButton.isHidden = false
            break
        case 1:
            cell.titleLabel.text = "Select Tournament"
            cell.txtField.placeholder = "Select Tournament"
            cell.txtField.text = objPreOrder.tournament
            if !objPreOrder.tournament.isEmpty {
                cell.txtField.isEnabled = false
            }
            break
        case 2:
            cell.titleLabel.text = "Enter Zone"
            cell.txtField.placeholder = "Zone"
            cell.txtField.text = objPreOrder.zone
            cell.txtField.keyboardType = .namePhonePad
            break
        case 3:
            cell.titleLabel.text = "Enter Seat No."
            cell.txtField.placeholder = "Seat No."
            cell.txtField.text = objPreOrder.seatNo
            cell.txtField.keyboardType = .namePhonePad
            break
        case 4:
            cell.titleLabel.text = "Select Time"
            cell.txtField.placeholder = "00:00"
            cell.txtField.text = objPreOrder.time
            cell.txtField.rightPaddingPoints(width: 50)
            cell.imageButton.isHidden = false
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 100
    }
    
    
}

extension InSeatDeliveryPreorderVC : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        if textField.tag == 100 {
            RPicker.selectDate(title: "Select Date", cancelText: "Cancel", doneText: "Select", datePickerMode: .date, selectDte: Date(), minDate: Date(), maxDate: nil, style: .wheel) { date in

                self.objPreOrder.date = date.dateLocalStringFromDate("YYYY-MM-dd") //"dd/MM/yy"
                self.tblView.reloadData()
            }
            return false
        }else if textField.tag == 104{
            RPicker.selectDate(title: "Select Time", cancelText: "Cancel", doneText: "Select", datePickerMode: .time, selectDte: Date(), minDate: nil, maxDate: nil, style: .wheel) { date in

                self.objPreOrder.time = date.dateLocalStringFromDate("hh:mm a")
                self.tblView.reloadData()
            }
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        switch textField.tag - 100 {
        case 1:
            objPreOrder.tournament = textField.text?.trim() ?? ""
            break
        case 2:
            objPreOrder.zone = textField.text?.trim() ?? ""
            break
        case 3:
            objPreOrder.seatNo = textField.text?.trim() ?? ""
            break
        default:
            break
        }
    }
}

