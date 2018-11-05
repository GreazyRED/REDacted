//
//  GazelleIndex.swift
//  REDacted
//
//  Created by Greazy on 7/30/18.
//  Copyright © 2018 Red. All rights reserved.
//

import Foundation

struct GazelleIndex: Codable {
    let userName: String
    let userId: Int
    let authKey: String
    let passKey: String
    let notifications: GazelleNotifications
    let userStats: GazelleUserStats
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case userId = "id"
        case authKey = "authkey"
        case passKey = "passkey"
        case notifications
        case userStats = "userstats"
    }
    
    struct GazelleNotifications: Codable {
        let messages: Int
        let notifications: Int
        let newAnnouncement: Bool
        let newBlog: Bool
        let newSubscriptions: Bool
    }
    
    struct GazelleUserStats: Codable {
        let uploaded: Int
        let downloaded: Int
        let ratio: Double
        let requiredRatio: Double
        let userClass: String
        
        enum CodingKeys: String, CodingKey {
            case uploaded
            case downloaded
            case ratio
            case requiredRatio = "requiredratio"
            case userClass = "class"
        }
    }
}
