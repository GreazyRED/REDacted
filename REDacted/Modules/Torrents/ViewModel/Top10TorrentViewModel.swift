//
//  Top10TorrentViewModel.swift
//  REDacted
//
//  Created by Greazy on 10/17/18.
//  Copyright © 2018 Red. All rights reserved.
//

import Foundation

struct Top10TorrentViewModel {
    let sectionName: String
    var torrents: [TorrentDetailAlbumViewModel] = []
    
    init(top10Data: TorrentTop10) {
        self.sectionName = top10Data.caption
        self.torrents = top10Data.results.compactMap({
            var artistName: String
            switch $0.artist {
            case .bool:
                artistName = ""
            case .string(let name):
                artistName = name
            }
            return TorrentDetailAlbumViewModel.init(cover: $0.wikiImage, albumName: $0.groupName, artistName: artistName, releaseType: $0.releaseType, torrentId: $0.torrentId)})

    }
}
