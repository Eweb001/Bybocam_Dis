//
//  GradientColor.swift
//  Bybocam
//
//  Created by eWeb on 04/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import Foundation
import UIKit

let BtnTopClr = UIColor(red: 0/255.0, green: 230/255.0, blue: 235/255.0, alpha: 1.0)
let BtnMiddleClr = UIColor(red: 0/255.0, green: 147/255.0, blue: 184/255.0, alpha: 1.0)
let BtnBottomClr = UIColor(red: 0/255.0, green: 83/255.0, blue: 139/255.0, alpha: 1.0)

extension UIView
{
   
    func ViewShadeEffect(colorOne: UIColor, colorTwo: UIColor, colorThree: UIColor)
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor, colorThree.cgColor]
       //gradientLayer.locations = [0.45, 0.55]
        layer.insertSublayer(gradientLayer, at: 0)
    
    }
}
