//
//  BankDetailVC.swift
//  FanServe
//
//  Created by McCoy Mart on 19/06/22.
//

import UIKit

class BankDetailVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    fileprivate var bankObj = BankDetailModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.dataSource = self
        tblView.delegate = self
        
        self.tblView.register(SignUpTableViewCell.createSignUpTableViewCellNib(), forCellReuseIdentifier: SignUpTableViewCell.signUpTableCellIdentifier())

    }
    
    @IBAction func continueButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if validateField(){
            let vc1 = CancelOrderVC()
            vc1.modalTransitionStyle = .crossDissolve
            vc1.modalPresentationStyle = .overFullScreen
            vc1.screenType = "wallet"
            self.present(vc1, animated: true, completion: nil)
        }
    }
    
    fileprivate func validateField() -> Bool {
        
        var isValid = false
        if bankObj.name.count == 0{
            self.toastErrorAtTop("Please enter recipient name!")
        }else if bankObj.accountNumber.count == 0{
            self.toastErrorAtTop("Please enter account number!")
        }else if bankObj.confirmAccountNumber.count == 0{
            self.toastErrorAtTop("Please re-enter account number!")
        }else if bankObj.accountNumber != bankObj.confirmAccountNumber{
            self.toastErrorAtTop("Account number and re-enter account number should be same!")
        }else if bankObj.ifsc.count == 0{
            self.toastErrorAtTop("Please enter ifsc code!")
        }else{
            isValid = true
        }
        return isValid
    }
}

extension BankDetailVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SignUpTableViewCell.signUpTableCellIdentifier()) as? SignUpTableViewCell else {
            return UITableViewCell()
        }
                
        cell.cellTextField.delegate = self
        cell.cellTextField.tag = indexPath.row + 100
        cell.cellTextField.returnKeyType = .next
        cell.cellTextField.keyboardType = .namePhonePad
        cell.cellImageView.isHidden = true
        
        switch indexPath.row {
        case 0:
            cell.cellTextField.placeholder = "Recipient Name"
            cell.cellTextField.text = bankObj.name
        case 1:
            cell.cellTextField.placeholder = "Account number"
            cell.cellTextField.text = bankObj.accountNumber
        case 2:
            cell.cellTextField.placeholder = "Re-enter account number"
            cell.cellTextField.text = bankObj.confirmAccountNumber
        case 3:
            cell.cellTextField.placeholder = "IFSC"
            cell.cellTextField.text = bankObj.ifsc
            cell.cellTextField.returnKeyType = .done
        default:
            break
        }
        return cell
    }
    
}

extension BankDetailVC : UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        switch textField.tag {
        case 100:
            bankObj.name = textField.text?.trimWhiteSpace() ?? ""
            break
        case 101:
            bankObj.accountNumber = textField.text?.trimWhiteSpace() ?? ""
            break
        case 102:
            bankObj.confirmAccountNumber = textField.text?.trimWhiteSpace() ?? ""
            break
        case 103:
            bankObj.ifsc = textField.text?.trimWhiteSpace() ?? ""
            break
        default:
            break
        }
    }
}
