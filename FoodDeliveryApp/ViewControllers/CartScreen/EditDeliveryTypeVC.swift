//
//  EditDeliveryTypeVC.swift
//  FanServe
//
//  Created by McCoy Mart on 15/06/22.
//

import UIKit

class EditDeliveryTypeVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    
    var titleArr = ["Express Lane Delivery","Pickup","In seat Delivery"]
    var imgArr = ["expressIcon","pickupIcon","deliveryIcon"]
    
    var isFromShopTab = false
    var isFromCartScreen = false
    typealias EditDeliveryCompletionBlock = (Bool, String) -> Void
    var block : EditDeliveryCompletionBlock?
    var currentSelectedDeliveryType: String = ""
    fileprivate var selectedTypeIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromCartScreen {
            if let index = titleArr.firstIndex(of: currentSelectedDeliveryType) {
                selectedTypeIndex = index
            } else {
                selectedTypeIndex = 2
            }
        }
        
        if isFromShopTab{
            closeButton.isHidden = false
        }else{
            closeButton.isHidden = true
        }
    }
    
    func setCompletionBlock(onCompletion:@escaping EditDeliveryCompletionBlock) {
        block = onCompletion
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        
        sceneDelegate?.setSideMenu()
    }
    
    @IBAction func okButtonAction(_ sender: UIButton) {
        
        if isFromShopTab || isFromCartScreen{
            self.dismiss(animated: true) {
                self.block!(true, self.titleArr[self.selectedTypeIndex])
            }
        }else{
            let type = titleArr[selectedTypeIndex]
            if type == "Express Lane Delivery" || type == "Pickup"{
                let vc = ExpressPickupPreorderVC.controller(storyboard: .Main, identifire: "ExpressPickupPreorderVC") as! ExpressPickupPreorderVC
                vc.isExpressDelivery = type == "Express Lane Delivery"
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = InSeatDeliveryPreorderVC.controller(storyboard: .Main, identifire: "InSeatDeliveryPreorderVC") as! InSeatDeliveryPreorderVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension EditDeliveryTypeVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryTypeTableCell", for: indexPath) as! DeliveryTypeTableCell
        cell.titleLabel.text = titleArr[indexPath.row]
        if selectedTypeIndex == indexPath.row{
            cell.checkButton.isHidden = false
            cell.imgView.image = UIImage(named: imgArr[indexPath.row])?.withTintColor(UIColor.white)
            cell.imageBgView.backgroundColor = UIColor(hex: "CC0D00")
            cell.baseView.backgroundColor = UIColor(hex: "F8281A")
            cell.baseView.layer.borderColor = UIColor(hex: "F8281A").cgColor
            cell.titleLabel.textColor = UIColor.white
        }else{
            cell.checkButton.isHidden = true
            cell.imgView.image = UIImage(named: imgArr[indexPath.row])?.withTintColor(UIColor(hex: "747474"))
            cell.imageBgView.backgroundColor = UIColor(hex: "D8D8D8")
            cell.baseView.backgroundColor = UIColor.white
            cell.baseView.layer.borderColor = UIColor(hex: "D8D8D8").cgColor
            cell.titleLabel.textColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        selectedTypeIndex = indexPath.row
        self.tblView.reloadData()
    }
}
