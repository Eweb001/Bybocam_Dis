//
//  SingleChatMessages.swift
//  Bybocam
//
//  Created by APPLE on 18/12/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import Foundation

struct SingleChatMessages : Codable {
    
    let code : String?
    let data : [SingleChaMsgArray]?
    let status : String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data = "data"
        case status = "status"
    }
    
}
struct SingleChaMsgArray : Codable {
    
    let createdAt : String?
    let message : String?
    let messageFile : String?
    let recevierId : String?
    let senderId : String?
    let updatedAt : String?
    let userCommentsId : String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case message = "message"
        case messageFile = "messageFile"
        case recevierId = "recevierId"
        case senderId = "senderId"
        case updatedAt = "updated_at"
        case userCommentsId = "userCommentsId"
    }
    
}
