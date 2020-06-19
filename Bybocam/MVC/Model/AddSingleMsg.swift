//
//  AddSingleMsg.swift
//  Bybocam
//
//  Created by APPLE on 18/12/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import Foundation


struct AddSingleMsg : Codable {
    
    let code : String?
    let message : String?
    let status : String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case status = "status"
    }
    
}
