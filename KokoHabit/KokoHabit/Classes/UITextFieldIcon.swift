//
//  UITextFieldIcon.swift
//  This is a UITextField class with some padding for an icon image
//  KokoHabit
//
//  Created by Arthur Tran on 2019-04-04.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class UITextFieldIcon: UITextField {
    
    let padding = UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 10)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
