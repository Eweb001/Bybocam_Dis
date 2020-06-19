//
//  AddCommentModel.swift
//  Bybocam
//
//  Created by eWeb on 10/12/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import Foundation
import UIKit

struct AddCommentModel : Codable {
    
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
