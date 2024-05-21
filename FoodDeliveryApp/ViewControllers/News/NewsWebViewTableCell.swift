//
//  NewsWebViewTableCell.swift
//  appName
//
//  Created by McCoy Mart on 19/08/22.
//

import UIKit
import WebKit

class NewsWebViewTableCell: UITableViewCell {
    
    @IBOutlet weak var webView: WKWebView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
