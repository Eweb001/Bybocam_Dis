//
//  Constant.swift
//  Bybocam
//
//  Created by APPLE on 18/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import Foundation


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
