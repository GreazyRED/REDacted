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
    var torrents: [Top10TorrentDetailViewModel] = []
    
    init(top10Data: TorrentTop10) {
        self.sectionName = top10Data.caption
        self.torrents = top10Data.results.compactMap({ Top10TorrentDetailViewModel.init(torrent: $0)})
    }
}

struct Top10TorrentDetailViewModel {
    var id: Int = 0
    var releaseFormat: NSAttributedString = NSAttributedString(string: "")
    var size: String = ""
    
    init(torrent: TorrentTop10Torrent) {
        self.id = torrent.torrentId
        self.releaseFormat = getTop10ReleaseFormat(torrent: torrent)
        self.size = torrent.size.toDecimalString()
    }
    
    private func getTop10ReleaseFormat(torrent: TorrentTop10Torrent) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString.init(string: "")
        let helper = Helpers()
        
        switch torrent.artist {
        case .string(let value):
            let artist = helper.makeAttributedString(using: String(htmlEncodedString: value) ?? "", bold: true, size: 14)
            mutableAttributedString.append(artist)
            mutableAttributedString.append(helper.makeAttributedString(using: " - ", size: 14))
        default:
            print("Non-music torrent")
        }
        
        let groupName = helper.makeAttributedString(using: String(htmlEncodedString: torrent.groupName) ?? "", bold: true, size: 14)
        mutableAttributedString.append(groupName)
        
        var year = ""
        var releaseType = ""
        
        if torrent.year == 0 {
            if torrent.groupYear == 0 {
                year = ""
            } else {
                year = " [\(torrent.groupYear)]"
            }
        } else {
            year = " [\(torrent.year)]"
        }
        
        if torrent.releaseType != "0" {
            releaseType = " [\(torrent.releaseType)]"
        }
        
        let yearAndType = helper.makeAttributedString(using: year + releaseType, bold: true, size: 14)
        mutableAttributedString.append(yearAndType)
        
        let description = (torrent.format.isEmpty ? "" : " - [" + torrent.format + " / " + torrent.encoding + (torrent.hasLog ? " / Log (??%)" : "") + (torrent.hasCue ? " / Cue" : "") + (torrent.scene ? " / Scene" : "") + (torrent.remasterTitle.isEmpty ? "]" : " / " + torrent.remasterTitle + "]"))
        mutableAttributedString.append(helper.makeAttributedString(using: description, size: 14))
        return mutableAttributedString
    }
}
