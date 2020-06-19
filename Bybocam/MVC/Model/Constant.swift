//
//  Constant.swift
//  Bybocam
//
//  Created by eWeb on 04/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import Foundation
import UIKit

let APPBUTTONCOLOR = UIColor.init(red: 0/255, green: 197/255, blue: 217/255, alpha: 1)
let APPBACKGROUNDCOLOR = UIColor.init(red: 19/255, green: 205/255, blue: 190/255, alpha: 1)
let APPDEL = UIApplication.shared.delegate as! AppDelegate

var DEFAULT = UserDefaults.standard

extension String
{
    func isValidateEmail() -> Bool
    {
        var emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        var emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
}
