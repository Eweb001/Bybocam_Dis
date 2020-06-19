//
//  ReccomendationModel.swift
//  Bybocam
//
//  Created by APPLE on 25/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import Foundation
import UIKit

struct ReccomendationModel : Codable
{
    
    let code : String?
    let data : [RecomenData]?
    let status : String?
    let message : String?
    enum CodingKeys: String, CodingKey
    {
        case code = "code"
        case data = "data"
        case status = "status"
        case message = "message"
    }
}


struct RecomenData : Codable
{
    
    let createdAt : String?
    let dateOfBirth : String?
    let deviceId : String?
    let deviceType : String?
    let distance : String?
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
    let userVideos : [RecomendationUserVideo]?
    let varifiedStatus : String?
    let likeStatus : String?
    
    enum CodingKeys: String, CodingKey
    {
        case createdAt = "created_at"
        case dateOfBirth = "dateOfBirth"
        case deviceId = "deviceId"
        case deviceType = "deviceType"
        case distance = "distance"
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
        case userVideos = "userVideos"
        case varifiedStatus = "varifiedStatus"
        case likeStatus = "likeStatus"
    }
}

struct RecomendationUserVideo : Codable
{
    
    let createdAt : String?
    let id : String?
    let updatedAt : String?
    let userId : String?
    let videoName : String?
    let videoThumbnailimg : String?
    
    enum CodingKeys: String, CodingKey
    {
        case createdAt = "created_at"
        case id = "id"
        case updatedAt = "updated_at"
        case userId = "userId"
        case videoName = "videoName"
        case videoThumbnailimg = "videoThumbnailimg"
        
    }
}
