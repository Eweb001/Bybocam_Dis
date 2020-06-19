//
//  SearchPostModel.swift
//  Bybocam
//
//  Created by eWeb on 02/12/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import Foundation

struct SearchPostModel : Codable {
    
    let code : String?
    let postData : [SearchPostData]?
    let status : String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case postData = "postData"
        case status = "status"
    }

}

struct SearchPostData : Codable {
    
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
    let postVideoThumbnailImg : String?
    let isliked : String?
    let postLikeCount : Int?
    let postCommentsCounts : Int?
    
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
        case postVideoThumbnailImg = "postVideoThumbnailImg"
        case isliked = "isliked"
        case postLikeCount = "postLikeCount"
        case postCommentsCounts = "postCommentsCounts"
    }
  
    
}
