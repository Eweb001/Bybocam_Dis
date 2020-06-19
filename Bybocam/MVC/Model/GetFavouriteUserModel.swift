//
//  GetFavouriteUserModel.swift
//  Bybocam
//
//  Created by eWeb on 07/12/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import Foundation
import UIKit

struct GetFavouriteUserModel : Codable {
    
    let code : String?
    let data : [GetFavUserArray]?
    let status : String?
    
    enum CodingKeys: String, CodingKey
    {
        case code = "code"
        case data = "data"
        case status = "status"
    }
    
}

struct GetFavUserArray : Codable {
    
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
    
    enum CodingKeys: String, CodingKey
    {
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
    
 
    
}
