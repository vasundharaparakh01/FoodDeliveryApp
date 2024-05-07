//
//  CustomImagePreview.swift
//  LBMA Gold
//
//  Created by Lalit Kumar Gupta on 24/03/20.
//  Copyright © 2020 Lalit Kumar Gupta. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class CustomImagePreview: NSObject {
    
    //  static let shared = POSImagePreview()
    
    class func displayImageWithUrl(url:String,controller:UIViewController) {
        
        SKPhotoBrowserOptions.displayAction         = false
        SKPhotoBrowserOptions.enableSingleTapDismiss = true
        let photo = SKPhoto.photoWithImageURL(url)
        let browser =  SKPhotoBrowser.init(photos: [photo])
        browser.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        controller.present(browser, animated: false) {
        }
    }
    
    class func displayImageWithUrls(urls:[String],controller:UIViewController, currentPageIndex: Int = 0) {
        
        if urls.count > 0 {
            
            SKPhotoBrowserOptions.displayAction         = false
            SKPhotoBrowserOptions.enableSingleTapDismiss = true
            var photos = [SKPhoto]()
            for url in urls {
                let photo = SKPhoto.photoWithImageURL(url)
                photos.append(photo)
            }
            let browser =  SKPhotoBrowser.init(photos: photos)
            browser.currentPageIndex = currentPageIndex
            controller.present(browser, animated: false) {
            }
        }else{
            MessageView.showMessage(message: "Urls not supported", time: 4.0, verticalAlignment: .bottom)
        }
    }
    
    class func displayImageWithImage(image:UIImage, controller:UIViewController) {
        
        SKPhotoBrowserOptions.displayAction         = false
        SKPhotoBrowserOptions.enableSingleTapDismiss = true
        let photo = SKPhoto.photoWithImage(image)
        let browser =  SKPhotoBrowser.init(photos: [photo])
        
        controller.present(browser, animated: false) {
        }
    }
}
