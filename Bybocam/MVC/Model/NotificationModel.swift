//
//  NotificationModel.swift
//  Bybocam
//
//  Created by eWeb on 13/01/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import Foundation

struct NotificationModel : Codable {
    
    let code : String?
    let status : String?
    let data : [NotificationDatum]?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case status = "status"
        case data = "data"
    }
    
    
}

struct NotificationDatum : Codable {
    
    let notificationLogId : String?
    let notificationType : String?
    let senderId : String?
    let recevierId : String?
    let userId : String?
    let postId : String?
    let title : String?
    let descriptionField : String?
    let createdAt : String?
    let updatedAt : String?
    let userData : [NotificationUserDatum]?
    
    enum CodingKeys: String, CodingKey {
        case notificationLogId = "notificationLogId"
        case notificationType = "notificationType"
        case senderId = "senderId"
        case recevierId = "recevierId"
        case userId = "userId"
        case postId = "postId"
        case title = "title"
        case descriptionField = "description"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userData = "userData"
    }
    
}

struct NotificationUserDatum : Codable {
    
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
