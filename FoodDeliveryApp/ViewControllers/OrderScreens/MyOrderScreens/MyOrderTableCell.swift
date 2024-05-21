//
//  MyOrderTableCell.swift
//  appName
//
//  Created by McCoy Mart on 09/06/22.
//

import UIKit
import FloatRatingView

class MyOrderTableCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var orderImageView: UIImageView!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cancelUnderlineLabel: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var trackCollectionView: UICollectionView!
    @IBOutlet weak var addRattingLabel: UILabel!
    
    fileprivate var itemArr = [SFMenuItem]()
    fileprivate var trackList = [SFSection]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        productTableView.register(UINib(nibName: "ProductTableCell", bundle: nil), forCellReuseIdentifier: "ProductTableCell")
        trackCollectionView.register(UINib(nibName: "TrackCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TrackCollectionCell")
        productTableView.dataSource = self
        productTableView.delegate = self
        trackCollectionView.dataSource = self
        trackCollectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadTableData(list : [SFMenuItem]){
        
        itemArr = list
        self.productTableView.reloadData()
    }
    
    func reloadCollectionData(list : [SFSection]){
        
        trackList = list
        self.trackCollectionView.reloadData()
    }
    
}

extension MyOrderTableCell : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableCell", for: indexPath) as! ProductTableCell
        let obj = itemArr[indexPath.item]
        cell.nameLabel.text = "\(obj.quantity) * \(obj.name ?? "")"
//        if (obj.varients?.array.count ?? 0) >= 1 {
//            if let varient = (obj.varients?.array as? [SFSubItem] ?? []).filter({ item in
//                return (item.itemId ?? UUID().uuidString) == obj.varientId
//            }).first {
//                cell.nameLabel.text = "\(obj.quantity) * \(obj.name ?? "") \(varient.name ?? "")"
//            }
//        }
        cell.imgView.imageLoad(urlString: "\(newsImageBaseUrl)\(obj.productImage ?? "")", placeholder: UIImage(named: "imagePlaceholder"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60
    }
}

extension MyOrderTableCell : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackCollectionCell", for: indexPath) as! TrackCollectionCell
        
        cell.leftLineLabel.isHidden = false
        cell.rightLineLabel.isHidden = false
        let obj = trackList[indexPath.item]
        cell.titleLabel.text = obj.categoryName
        cell.dotLabel.backgroundColor = obj.status ? UIColor.init(hex: "01AA12") : UIColor.systemGray3
        cell.leftLineLabel.backgroundColor = obj.status ? UIColor.init(hex: "01AA12") : UIColor.systemGray3
        cell.rightLineLabel.backgroundColor = obj.status ? UIColor.init(hex: "01AA12") : UIColor.systemGray3
        if indexPath.row == 0{
            cell.leftLineLabel.isHidden = true
        }else if indexPath.row == (trackList.count - 1){
            cell.rightLineLabel.isHidden = true
        }
        return cell
    }
    
    
    
}
