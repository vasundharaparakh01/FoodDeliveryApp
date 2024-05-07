//
//  RatingAlertVC.swift
//  FanServe
//
//  Created by Varun Kumar Raghav on 26/05/22.
//

import UIKit
import Cosmos

protocol RatingAlertProtocolDelegate {
    func getRating(rating: Int)
}

class RatingAlertVC: UIViewController {
    @IBOutlet var ratingView: CosmosView!
    
    var rating = 0
    var delgate: RatingAlertProtocolDelegate? = nil
    
//MARK: - lifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//MARK: - selector method
    
    func getRating() {
        self.rating = Int(ratingView.rating)
    }
    
    //MARK: - action method
    @IBAction func dismissBtnAction(sender: UIButton) {
        self.getRating()
        self.dismiss(animated: true){
            self.delgate?.getRating(rating: self.rating)
        }
    }
    
}
