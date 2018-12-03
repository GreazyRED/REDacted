//
//  TorrentGroupDetailModel.swift
//  REDacted
//
//  Created by Greazy on 8/11/18.
//  Copyright © 2018 Red. All rights reserved.
//

import Foundation

struct TorrentGroupDetail: Codable {
    let group: TorrentGroup
    let torrents: [Torrent]
}

struct TorrentGroup: Codable {
    let wikiBody: String
    let wikiImage: String
    let id: Int
    let name: String
    let year: Int
    let recordLabel: String
    let catalogueNumber: String
    let releaseType: Int
    let categoryId: Int
    let categoryName: String
    let time: String
    let vanityHouse: Bool
    let isBookmarked: Bool
    let musicInfo: TorrentGroupMusicInfo
    let tags: [String]
}

struct TorrentGroupMusicInfo: Codable {
    let composers: [TorrentArtist]
    let dj: [TorrentArtist]
    let artists: [TorrentArtist]
    let with: [TorrentArtist]
    let conductor: [TorrentArtist]
    let remixedBy: [TorrentArtist]
    let producer: [TorrentArtist]
}

struct TorrentArtist: Codable {
    let id: Int
    let name: String
}

struct Torrent: Codable {
    let id: Int
    let media:String
    let format: String
    let encoding: String
    let remastered: Bool
    let remasterYear: Int
    let remasterTitle: String
    let remasterRecordLabel: String
    let remasterCatalogueNumber: String
    let scene: Bool
    let hasLog: Bool
    let hasCue: Bool
    let logScore: Int
    let fileCount: Int
    let size: Int
    let seeders: Int
    let leechers: Int
    let snatched: Int
    let freeTorrent: Bool
    let reported: Bool
    let time: String
    let description: String
    let fileList: String
    let filePath: String
    let userId: Int
    let username: String
}

struct AutoComplete: Codable {
    let query: String
    let suggestions: [AutoCompleteSuggestion]
}

struct AutoCompleteSuggestion: Codable {
    let value: String
    let data: String
}
