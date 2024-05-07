//
//  ButtonSubClass.swift
//  LiquorChacha
//
//  Created by Vishal Mandhyan on 29/06/21.
//

import Foundation
import UIKit

final class CustomShadowButton: UIButton {

    private var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 5).cgPath
            shadowLayer.fillColor = self.backgroundColor?.cgColor

            shadowLayer.shadowColor = UIColor.gray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 3.0, height: 4.0)
            shadowLayer.shadowOpacity = 3.0
            shadowLayer.shadowRadius = 5

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }

}

class SFButton: UIButton {

   var indexPath:IndexPath?
   
   override func awakeFromNib() {
       super.awakeFromNib()
       
   }
}
