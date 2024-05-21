//
//  SectionCategoryCell.swift
//  appName
//
//  Created by Varun Kumar Raghav on 25/05/22.
//

import UIKit

class SectionCategoryCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(PagerCollectionCell.createCellNib(), forCellWithReuseIdentifier: PagerCollectionCell.cellIdentifier())
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //MARK: - cell creation and id generation
    class func cellIdentifier() -> String {
        return String(describing: SectionCategoryCell.self)
    }
    class func createCellNib() -> UINib {
        return UINib(nibName: SectionCategoryCell.cellIdentifier(), bundle: nil)
    }
    //MARK: - setup CollectionView datasource and delegate
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forSection section: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = section
        collectionView.reloadData()
    }
    
}
