//
//  CustomButton.swift
//  GoChat
//
//  Created by Muhammad Iqbal on 19/03/2018.
//  Copyright © 2018 Muhammad Iqbal. All rights reserved.
//

import UIKit
@IBDesignable
class CustomButton: UIButton {

  
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("MyTitle", for: .normal)
        setTitleColor(UIColor.blue, for: .normal)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
}
