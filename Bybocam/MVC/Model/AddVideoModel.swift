//
//  AddVideoModel.swift
//  Bybocam
//
//  Created by eWeb on 22/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import Foundation


struct AddVideoModel : Codable {
    
    let code : String?
    let status : String?
    let message : String?
    
    enum CodingKeys: String, CodingKey
    {
        case code = "code"
        case status = "status"
        case message = "message"
    }

    
}
