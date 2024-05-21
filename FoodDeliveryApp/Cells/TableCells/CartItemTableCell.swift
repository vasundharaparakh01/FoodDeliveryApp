//
//  CartItemTableCell.swift
//  appName
//
//  Created by McCoy Mart on 15/06/22.
//

import UIKit

class CartItemTableCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var addOnsButton: UIButton!
    @IBOutlet weak var addOnsLineLabel: UILabel!
    @IBOutlet weak var sepratorLabel: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    fileprivate var dataArr = [SFSubItem]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        tblView.register(UINib(nibName: "AddOnsTableCell", bundle: nil), forCellReuseIdentifier: "AddOnsTableCell")
        tblView.dataSource = self
        tblView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadTableData(list : [SFSubItem]){
        
        dataArr = list
        self.tblView.reloadData()
    }

}

extension CartItemTableCell : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "AddOnsTableCell", for: indexPath) as! AddOnsTableCell
        let obj = dataArr[indexPath.row]
        
        cell.nameLabel.text = obj.name
        cell.priceLabel.text = "MYR\((obj.price/100).toValueFormat())"
        cell.deleteButton.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 30
    }
    
}
