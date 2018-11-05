//
//  GazelleUser.swift
//  REDacted
//
//  Created by Greazy on 7/30/18.
//  Copyright © 2018 Red. All rights reserved.
//

import Foundation
import Alamofire

struct GazelleUser: Codable {
    let userName: String
    let avatar: String
    let isFriend: Bool
    let profileText: String
    let stats: GazelleStats
    let ranks: GazelleRanks
    let personal: GazellePersonal
    let community: GazelleCommunity
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case avatar
        case isFriend
        case profileText
        case stats
        case ranks
        case personal
        case community
    }
    
    struct GazelleStats: Codable {
        let joinedDate: String
        let lastAccess: String
        let uploaded: Int
        let downloaded: Int
        let ratio: String
        let buffer: Int
        let requiredRatio: Double
    }
    
    struct GazelleRanks: Codable {
        let uploaded: Int
        let downloaded: Int
        let uploads: Int
        let requests: Int
        let bounty: Int
        let posts: Int
        let artists: Int
        let overall: Int
    }
    
    struct GazellePersonal: Codable {
        let userClass: String
        let paranoia: Int
        let paranoiaText: String
        let donor: Bool
        let warned: Bool
        let enabled: Bool
        let passKey: String
        
        enum CodingKeys: String, CodingKey {
            case userClass = "class"
            case paranoia
            case paranoiaText
            case donor
            case warned
            case enabled
            case passKey = "passkey"
        }
    }
    
    struct GazelleCommunity: Codable {
        let posts: Int
        let groupVotes: Int
        let torrentComments: Int
        let artistComments: Int
        let collageComments: Int
        let requestComments: Int
        let collagesStarted: Int
        let collagesContrib: Int
        let requestsFilled: Int
        let bountyEarned: Int
        let requestsVoted: Int
        let bountySpent: Int
        let perfectFlacs: Int
        let uploaded: Int
        let groups: Int
        let seeding: Int
        let leeching: Int
        let snatched: Int
        let invited: Int
        let artistsAdded: Int
    }
}
