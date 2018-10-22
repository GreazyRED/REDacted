//
//  TorrentDetailViewModel.swift
//  REDacted
//
//  Created by Greazy on 8/11/18.
//  Copyright © 2018 Red. All rights reserved.
//

import Foundation

struct TorrentDetailViewModel {
    let albumDetail: TorrentDetailAlbumViewModel
    var torrents: [TorrentViewModel] = []
    
    init(torrentDetail: TorrentGroupDetail) {
        self.albumDetail = TorrentDetailAlbumViewModel.init(cover: torrentDetail.group.wikiImage, albumName: torrentDetail.group.name, artistName: torrentDetail.group.musicInfo.artists[0].name, releaseType: "Album")
        self.torrents = processTorrents(with: torrentDetail)
        
    }
    
    func processTorrents(with detail: TorrentGroupDetail) -> [TorrentViewModel]{
        var torrents: [TorrentViewModel] = []
        var keyArray: [String] = []
        var torrentDictionary: [String: [Torrent]] = [:]
//        for torrent in detail.torrents.sorted(by: {$0.remasterYear < $1.remasterYear}) {
        for torrent in detail.torrents {
            let key = "\(torrent.remasterYear)" + torrent.remasterRecordLabel + torrent.remasterCatalogueNumber + torrent.remasterTitle + torrent.media
            if !keyArray.contains(key) {
                keyArray.append(key)
                var newArray: [Torrent] = []
                newArray.append(torrent)
                torrentDictionary[key] = newArray
                continue
            }
            guard var currentArray = torrentDictionary[key] else { continue }
            currentArray.append(torrent)
            torrentDictionary.updateValue(currentArray, forKey: key)
        }
        
        for key in keyArray {
            guard let torrentArray = torrentDictionary[key] else { continue }
            torrents.append(TorrentViewModel(torrents: torrentArray))
        }
        return torrents
    }
}

struct TorrentDetailAlbumViewModel {
    var id: Int?
    let cover: URL?
    let albumName: String
    let artistName: String
    let releaseType: String
    
    init(cover: String, albumName: String, artistName: String, releaseType: String, torrentId: Int = -1) {
        if let url = URL(string: cover) {
            self.cover = url
        } else {
            self.cover = nil
        }
        self.albumName = String(htmlEncodedString: albumName) ?? ""
        self.artistName = String(htmlEncodedString: artistName) ?? ""
        self.releaseType = releaseType
        
        if torrentId != -1 {
            self.id = torrentId
        }
    }
}

struct TorrentViewModel {
    var releaseName: String = ""
    var releaseFormats: [ReleaseFormat] = []
    
    init(torrents: [Torrent]) {
        self.releaseName = getReleaseName(torrent: torrents.first!)
        self.releaseFormats = getReleaseFormats(torrents: torrents)
    }
    
    private func getReleaseName(torrent: Torrent) -> String {
        if torrent.remastered {
            return (torrent.remasterYear == 0 ? "Unknown Release(s)" : "\(torrent.remasterYear)" ) + (torrent.remasterRecordLabel.isEmpty ? "" : " / \(torrent.remasterRecordLabel)") + (torrent.remasterCatalogueNumber.isEmpty ? "" : " / \(torrent.remasterCatalogueNumber)") + (torrent.remasterTitle.isEmpty ? "" : " / " + String(htmlEncodedString: torrent.remasterTitle)!) + " / \(torrent.media)"
        }
        return (torrent.remasterYear == 0 ? "Original Release" : "\(torrent.remasterYear)" ) + (torrent.remasterRecordLabel.isEmpty ? "" : " / \(torrent.remasterRecordLabel)") + (torrent.remasterCatalogueNumber.isEmpty ? "" : " / \(torrent.remasterCatalogueNumber)") + (torrent.remasterTitle.isEmpty ? "" : " / " + String(htmlEncodedString: torrent.remasterTitle)!) + " / \(torrent.media)"
    }
    
    private func getReleaseFormats(torrents: [Torrent]) -> [ReleaseFormat] {
        var releaseArray: [ReleaseFormat] = []
        for torrent in torrents {
            let description = torrent.format + " / " + torrent.encoding + (torrent.hasLog ? " / Log (\(torrent.logScore)%)" : "") + (torrent.hasCue ? " / Cue" : "") + (torrent.scene ? " / Scene" : "")
            releaseArray.append(ReleaseFormat(torrentId: torrent.id, releaseDescription: description, userId: torrent.userId, username: torrent.username, fileSize: torrent.size.toDecimalString()))
        }
        return releaseArray
    }
}

struct ReleaseFormat {
    let torrentId: Int
    let releaseDescription: String
    let userId: Int
    let username: String
    let fileSize: String
}
