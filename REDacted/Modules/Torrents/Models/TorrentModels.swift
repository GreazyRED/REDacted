//
//  TorrentModels.swift
//  REDacted
//
//  Created by Greazy on 8/4/18.
//  Copyright © 2018 Red. All rights reserved.
//

import Foundation

struct GazelleBrowse: Codable {
    let currentPage: Int
    let pages: Int
    let results: [GazelleBrowseMusicGroup]
    
    struct GazelleBrowseMusicGroup: Codable {
        let groupId: Int
        let groupName: String
        let artist: String
        let cover: String
        let tags: [String]
        let bookmarked: Bool
        let vanityHouse: Bool
        let groupYear: Int
        let releaseType: String
        let groupTime: String
        let maxSize: Int
        let totalSnatched: Int
        let totalSeeders: Int
        let totalLeechers: Int
        let torrents: [GazelleBrowseMusicGroupTorrent]
        
        struct GazelleBrowseMusicGroupTorrent: Codable {
            let torrentId: Int
            let editionId: Int
            let artists: [GazelleArtist]
            let remastered: Bool
            let remasterYear: Int
            let remasterCatalogueNumber: String
            let remasterTitle: String
            let media: String
            let encoding: String
            let format: String
            let hasLog: Bool
            let logScore: Int
            let hasCue: Bool
            let scene: Bool
            let vanityHouse: Bool
            let fileCount: Int
            let time: String
            let size: Int
            let snatches: Int
            let seeders: Int
            let leechers: Int
            let isFreeleech: Bool
            let isNeutralLeech: Bool
            let isPersonalFreeleech: Bool
            let canUseToken: Bool
            let hasSnatched: Bool
            
            struct GazelleArtist: Codable {
                let id: Int
                let name: String
                let aliasid: Int
            }
            
        }
    }
}

struct TorrentTop10: Codable {
    let caption: String
    let tag: String
    let limit: Int
    let results: [TorrentTop10Torrent]
}

struct TorrentTop10Torrent: Codable {
    let torrentId: Int
    let groupId: Int
    let artist: GazelleArtist
    let groupName: String
    let groupCategory: Int
    let groupYear: Int
    let remasterTitle: String
    let format: String
    let encoding: String
    let hasLog: Bool
    let hasCue: Bool
    let media: String
    let scene: Bool
    let year: Int
    let tags: [String]
    let snatched: Int
    let seeders: Int
    let leechers: Int
    let data: Int
    let size: Int
    let wikiImage: String
    let releaseType: String
}

enum GazelleArtist: Codable {
    case bool(Bool)
    case string(String)

    init(from decoder: Decoder) throws {
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        
        if let bool = try? decoder.singleValueContainer().decode(Bool.self) {
            self = .bool(bool)
            return
        }
        
        throw GazelleError.unknownValue
    }
    
    enum GazelleError: Error {
        case unknownValue
    }
    
    func encode(to encoder: Encoder) throws {
        print("Unused")
    }
}
