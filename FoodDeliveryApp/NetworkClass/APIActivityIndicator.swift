//
//  APIActivityIndicator.swift
//  appName
//


import UIKit
import NVActivityIndicatorView

extension AlamofireHelper {
     static func startActivityIndicator() {
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: screenWidth/2 - 30, y: screenHeight/2 - 30, width: 60, height: 60), type: .ballClipRotatePulse, color: .gray, padding: 0)
        APPLICATIONWINDOW?.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
     static func stopActivityIndicator() {
        for view in APPLICATIONWINDOW!.subviews where view is NVActivityIndicatorView {
                let activityIndicatorView = view as? NVActivityIndicatorView
                activityIndicatorView?.stopAnimating()
        }
    }
}
