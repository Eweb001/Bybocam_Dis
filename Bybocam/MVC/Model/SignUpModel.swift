//
//  SignUpModel.swift
//  Bybocam
//
//  Created by eWeb on 03/12/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import Foundation


struct SignUpModel : Codable
{
    
    let code : String?
    let message : String?
    let status : String?
    
    enum CodingKeys: String, CodingKey
    {
        case code = "code"
        case message = "message"
        case status = "status"
    }
    

}
