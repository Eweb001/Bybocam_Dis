//
//  GroupChatMsgModel.swift
//  Bybocam
//
//  Created by eWeb on 10/12/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import Foundation
import UIKit

struct GroupChatMsgModel : Codable {
    
    let code : String?
    let data : [GroupChatDataArray]?
    let status : String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data = "data"
        case status = "status"
    }
   
}

struct GroupChatDataArray : Codable {
    
    let recevierId : String?
    let userMessage : [UserMessageArray]?
    let userName : [UserNameArray]?
    
    enum CodingKeys: String, CodingKey
    {
        case recevierId = "recevierId"
        case userMessage = "userMessage"
        case userName = "userName"
    }
    
}

struct UserMessageArray : Codable {
    
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


struct UserNameArray : Codable {
    
    let userName : String?
    
    enum CodingKeys: String, CodingKey
    {
        case userName = "userName"
    }
    
}



