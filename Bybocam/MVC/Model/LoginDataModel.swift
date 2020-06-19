//
//  LoginDataModel.swift
//  Bybocam
//
//  Created by eWeb on 03/12/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import Foundation

struct LoginDataModel : Codable {
    
    let code : String?
    let data : [LoginUserData]?
    let status : String?
    let message:String?
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data = "data"
        case status = "status"
        case message = "message"
    }
    
  
}

struct LoginUserData : Codable {
    
    let createdAt : String?
    let dateOfBirth : String?
    let deviceId : String?
    let deviceType : String?
    let email : String?
    let firstName : String?
    let lastName : String?
    let latitude : String?
    let loginStatus : String?
    let longitude : String?
    let otp : String?
    let password : String?
    let phone : String?
    let updatedAt : String?
    let userId : String?
    let userImage : String?
    let userName : String?
    let userRole : String?
    let varifiedStatus : String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case dateOfBirth = "dateOfBirth"
        case deviceId = "deviceId"
        case deviceType = "deviceType"
        case email = "email"
        case firstName = "firstName"
        case lastName = "lastName"
        case latitude = "latitude"
        case loginStatus = "loginStatus"
        case longitude = "longitude"
        case otp = "otp"
        case password = "password"
        case phone = "phone"
        case updatedAt = "updated_at"
        case userId = "userId"
        case userImage = "userImage"
        case userName = "userName"
        case userRole = "userRole"
        case varifiedStatus = "varifiedStatus"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        dateOfBirth = try values.decodeIfPresent(String.self, forKey: .dateOfBirth)
        deviceId = try values.decodeIfPresent(String.self, forKey: .deviceId)
        deviceType = try values.decodeIfPresent(String.self, forKey: .deviceType)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        loginStatus = try values.decodeIfPresent(String.self, forKey: .loginStatus)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        otp = try values.decodeIfPresent(String.self, forKey: .otp)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        userImage = try values.decodeIfPresent(String.self, forKey: .userImage)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        userRole = try values.decodeIfPresent(String.self, forKey: .userRole)
        varifiedStatus = try values.decodeIfPresent(String.self, forKey: .varifiedStatus)
    }
    
}
