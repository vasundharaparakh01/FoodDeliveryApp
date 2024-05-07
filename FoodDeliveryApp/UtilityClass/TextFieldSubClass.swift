//
//  TextFieldSubClass.swift
//  LiquorChacha
//
//  Created by Vishal Mandhyan on 29/06/21.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
  
   internal var fieldType: FieldType?
   internal var isFieldManatory: Bool = true

   internal var indexPath = IndexPath()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

@IBDesignable
class TextField: UITextField {
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0

    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }

    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
}
