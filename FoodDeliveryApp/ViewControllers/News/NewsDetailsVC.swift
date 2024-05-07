//
//  NewsDetailsVC.swift
//  FanServe
//
//  Created by Varun Kumar Raghav on 26/05/22.
//

import UIKit
import WebKit

class NewsDetailsVC: UIViewController {
    
    @IBOutlet var newsTitleLbl: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var webView: WKWebView!
    @IBOutlet weak var tblView: UITableView!
    
    var selectedNews : SFNews?
    
    // MARK: - lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.register(UINib(nibName: "NewsDetailTableCell", bundle: nil), forCellReuseIdentifier: "NewsDetailTableCell")
        tblView.register(UINib(nibName: "NewsWebViewTableCell", bundle: nil), forCellReuseIdentifier: "NewsWebViewTableCell")
        //self.initialMethod()
    }
    
    // MARK: - initial methods
    func initialMethod() {
        
        newsTitleLbl.text = selectedNews?.title
        imgView.imageLoad(urlString: "\(newsImageBaseUrl)\(selectedNews?.coverImage ?? "")", placeholder: UIImage(named: "imagePlaceholder"))
        
        
    }
    
    // MARK: - action methods
    @IBAction func backBtnAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension NewsDetailsVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsDetailTableCell", for: indexPath) as! NewsDetailTableCell
            cell.imgView.imageLoad(urlString: "\(newsImageBaseUrl)\(selectedNews?.coverImage ?? "")", placeholder: UIImage(named: "imagePlaceholder"))
            cell.titleLabel.text = selectedNews?.title
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsWebViewTableCell", for: indexPath) as! NewsWebViewTableCell
            let header = """
                    <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no" />
                        <style>
                            body {
                                font-family: "Poppins-Regular";
                                font-size: 18px;
                            }
                        </style>
                    </head>
                    <body>
                    """
            cell.webView.loadHTMLString(header + (selectedNews?.newsBody ?? "") + "</body>", baseURL: nil)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 600
    }
}

// MARK: - webView delegate methods
extension NewsDetailsVC: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
     //   AlamofireHelper.stopActivityIndicator()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
      //  AlamofireHelper.stopActivityIndicator()
    }
}
