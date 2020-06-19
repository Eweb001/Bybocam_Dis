//
//  HomePageModel.swift
//  Bybocam
//
//  Created by APPLE on 13/12/19.
//  Copyright © 2019 eWeb. All rights reserved.
//


import Foundation
import UIKit



struct HomePageModel : Codable {
    
    let code : String?
    let status : String?
    let data : [MessageDatum]?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case status = "status"
        case data = "data"
    }
    
}
struct MessageDatum : Codable {
    
    let userCommentsId : String?
    let senderId : String?
    let recevierId : String?
    let messageType : String?
    let message : String?
    let messageFile : String?
    let createdAt : String?
    let updatedAt : String?
    let userName : [MessageUserName]?
    
    enum CodingKeys: String, CodingKey {
        case userCommentsId = "userCommentsId"
        case senderId = "senderId"
        case recevierId = "recevierId"
        case messageType = "messageType"
        case message = "message"
        case messageFile = "messageFile"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userName = "userName"
    }

    
}


struct MessageUserName : Codable {
    
    let userName : String?
    let userId : String?
    
    enum CodingKeys: String, CodingKey {
        case userName = "userName"
        case userId = "userId"
    }

}



struct HomePageModel2 : Codable {
    
    let code : String?
    let data : [RecieverIdNameArray]?
    let status : String?
    
    enum CodingKeys: String, CodingKey
    {
        case code = "code"
        case data = "data"
        case status = "status"
    }
    
}

struct RecieverIdNameArray : Codable {
    
    let recevierId : String?
    let senderId : String?
    let userMessage : [HomeUserMessageArray]?
    let userName : [HomeUserNameArray]?
    
    enum CodingKeys: String, CodingKey
    {
        case recevierId = "recevierId"
        case senderId = "senderId"
        case userMessage = "userMessage"
        case userName = "userName"
    }
    
}

struct HomeUserNameArray : Codable {
    
    let userName : String?
    
    enum CodingKeys: String, CodingKey
    {
        case userName = "userName"
    }
    
}

struct HomeUserMessageArray : Codable {
    
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











































































/*
struct HomePageModel : Codable {
    
    let code : String?
    let data : [HomePageDataArray]?
    let status : String?
    
    enum CodingKeys: String, CodingKey
    {
        case code = "code"
        case data = "data"
        case status = "status"
    }
    
    
}

struct HomePageDataArray : Codable {
    
    let recevierId : String?
    let userMessage : [UserMessage]?
    let userName : [AnyObject]?
    
    enum CodingKeys: String, CodingKey
    {
        case recevierId = "recevierId"
        case userMessage = "userMessage"
        case userName = "userName"
    }
}

struct UserMessage : Codable {
    
    let createdAt : String?
    let message : String?
    let messageFile : String?
    let recevierId : String?
    let senderId : String?
    let updatedAt : String?
    let userCommentsId : String?
    
    enum CodingKeys: String, CodingKey
    {
        case createdAt = "created_at"
        case message = "message"
        case messageFile = "messageFile"
        case recevierId = "recevierId"
        case senderId = "senderId"
        case updatedAt = "updated_at"
        case userCommentsId = "userCommentsId"
    }
    
}

*/
