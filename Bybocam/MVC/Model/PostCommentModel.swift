//
//  PostCommentModel.swift
//  Bybocam
//
//  Created by eWeb on 03/01/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import Foundation

struct PostCommentModel : Codable {
    
    let code : String?
    let status : String?
    let data : [PostCommentDatum]?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case status = "status"
        case data = "data"
    }

}
struct PostCommentDatum : Codable {
    
    let postMessageId : String?
    let userId : String?
    let postId : String?
    let postMessage : String?
    let postMessageStatus : String?
    let createdAt : String?
    let updatedAt : String?
    let userData : [PostUserDatum]?
    
    enum CodingKeys: String, CodingKey {
        case postMessageId = "postMessageId"
        case userId = "userId"
        case postId = "postId"
        case postMessage = "postMessage"
        case postMessageStatus = "postMessageStatus"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userData = "userData"
    }
    
 
}
struct PostUserDatum : Codable {
    
    let userId : String?
    let firstName : String?
    let lastName : String?
    let userName : String?
    let email : String?
    let phone : String?
    let dateOfBirth : String?
    let userImage : String?
    let password : String?
    let latitude : String?
    let longitude : String?
    let otp : String?
    let varifiedStatus : String?
    let loginStatus : String?
    let userRole : String?
    let deviceType : String?
    let deviceId : String?
    let createdAt : String?
    let updatedAt : String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case firstName = "firstName"
        case lastName = "lastName"
        case userName = "userName"
        case email = "email"
        case phone = "phone"
        case dateOfBirth = "dateOfBirth"
        case userImage = "userImage"
        case password = "password"
        case latitude = "latitude"
        case longitude = "longitude"
        case otp = "otp"
        case varifiedStatus = "varifiedStatus"
        case loginStatus = "loginStatus"
        case userRole = "userRole"
        case deviceType = "deviceType"
        case deviceId = "deviceId"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
   
}
