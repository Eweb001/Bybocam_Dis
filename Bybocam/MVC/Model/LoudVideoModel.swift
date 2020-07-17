//
//  LoudVideoModel.swift
//  Bybocam
//
//  Created by Eweb on 16/07/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import Foundation
struct LoudVideoModel : Codable {

        let code : String?
        let data : [LoudDatum]?
        let status : String?

        enum CodingKeys: String, CodingKey {
                case code = "code"
                case data = "data"
                case status = "status"
        }
    
}
struct LoudDatum : Codable {

        let countryCode : String?
        let createdAt : String?
        let dateOfBirth : String?
        let deviceId : String?
        let deviceType : String?
        let discriptions : String?
        let email : String?
        let firstName : String?
        let id : String?
        let lastName : String?
        let latitude : String?
        let loginStatus : String?
        let longitude : String?
        let otp : String?
        let password : String?
        let phone : String?
        let recevierId : String?
        let senderId : String?
        let status : String?
        let updatedAt : String?
        let userId : String?
        let userImage : String?
        let userName : String?
        let userRole : String?
        let varifiedStatus : String?
        let videoImage : String?
        let videoName : String?

        enum CodingKeys: String, CodingKey {
                case countryCode = "countryCode"
                case createdAt = "created_at"
                case dateOfBirth = "dateOfBirth"
                case deviceId = "deviceId"
                case deviceType = "deviceType"
                case discriptions = "discriptions"
                case email = "email"
                case firstName = "firstName"
                case id = "id"
                case lastName = "lastName"
                case latitude = "latitude"
                case loginStatus = "loginStatus"
                case longitude = "longitude"
                case otp = "otp"
                case password = "password"
                case phone = "phone"
                case recevierId = "recevierId"
                case senderId = "senderId"
                case status = "status"
                case updatedAt = "updated_at"
                case userId = "userId"
                case userImage = "userImage"
                case userName = "userName"
                case userRole = "userRole"
                case varifiedStatus = "varifiedStatus"
                case videoImage = "videoImage"
                case videoName = "videoName"
        }
    
      

}
