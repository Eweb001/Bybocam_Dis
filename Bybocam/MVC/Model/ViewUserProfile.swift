//
//  ViewUserProfile.swift
//  Bybocam
//
//  Created by eWeb on 02/12/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import Foundation


struct ViewUserProfile : Codable {
    
    let code : String?
    let data : [ViewUserData]?
    let postData : [ViewUserPostData]?
    let status : String?
     let message : String?
    let totalfavouriteusers : Int?
    let followers : Int?
    let userVideos : [ViewUserVideo]?
    
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data = "data"
        case postData = "postData"
        case status = "status"
        case userVideos = "userVideos"
         case message = "message"
        case followers = "followers"
        case totalfavouriteusers = "totalfavouriteusers"
    }
    
    
}


struct ViewUserVideo : Codable {
    
    let createdAt : String?
    let id : String?
    let updatedAt : String?
    let userId : String?
    let videoName : String?
    let videoThumbnailimg : String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id = "id"
        case updatedAt = "updated_at"
        case userId = "userId"
        case videoName = "videoName"
        case videoThumbnailimg = "videoThumbnailimg"
        
    }
    
}


struct ViewUserPostData : Codable {
    
    let createdAt : String?
    let postDescription : String?
    let postId : String?
    let postImage : String?
    let postImageVideo : String?
    let postName : String?
    let postStatus : String?
    let postType : String?
    let postVideo : String?
    let updatedAt : String?
    let userId : String?
    let isliked : String?
    let postLikeCount : Int?
    let postCommentsCounts : Int?
    let postVideoThumbnailImg : String?
    
    
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case postDescription = "postDescription"
        case postId = "postId"
        case postImage = "postImage"
        case postImageVideo = "postImageVideo"
        case postName = "postName"
        case postStatus = "postStatus"
        case postType = "postType"
        case postVideo = "postVideo"
        case updatedAt = "updated_at"
        case userId = "userId"
        case isliked = "isliked"
        case postLikeCount = "postLikeCount"
        case postCommentsCounts = "postCommentsCounts"
        case postVideoThumbnailImg = "postVideoThumbnailImg"
        
        
    }

    
}


struct ViewUserData : Codable {
    
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
    let countryCode : String?
    let updatedAt : String?
    let userId : String?
    let userImage : String?
    let userName : String?
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
        case varifiedStatus = "varifiedStatus"
        case countryCode = "countryCode"
        
    }
    

}
