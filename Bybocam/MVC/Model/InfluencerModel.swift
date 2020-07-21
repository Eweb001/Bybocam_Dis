//
//  InfluencerModel.swift
//  Bybocam
//
//  Created by Eweb on 18/07/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import Foundation
struct InfluencerModel : Codable {

        let code : String?
        let data : [InfluncerDatum]?
        let status : String?
let message : String?
        enum CodingKeys: String, CodingKey {
                case code = "code"
                case data = "data"
                case status = "status"
             case message = "message"
        }
    
    

}
struct InfluncerDatum : Codable {

        let address : String?
        let createdAt : String?
        let gender : String?
        let id : String?
        let industry : String?
        let infulenlatitude : String?
        let infulenlongitude : String?
        let infulenname : String?
        let picture : String?
        let price : String?
        let race : String?
        let updatedAt : String?
        let userId : String?
 let discription : String?
        enum CodingKeys: String, CodingKey {
                case address = "address"
                case createdAt = "created_at"
                case gender = "gender"
                case id = "id"
                case industry = "industry"
                case infulenlatitude = "Infulenlatitude"
                case infulenlongitude = "Infulenlongitude"
                case infulenname = "Infulenname"
                case picture = "picture"
                case price = "price"
                case race = "race"
                case updatedAt = "updated_at"
                case userId = "userId"
            case discription = "discription"
        }


}
