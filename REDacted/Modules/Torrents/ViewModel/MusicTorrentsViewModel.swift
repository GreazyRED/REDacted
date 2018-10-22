//
//  MusicTorrentsViewModel.swift
//  REDacted
//
//  Created by Greazy on 8/4/18.
//  Copyright © 2018 Red. All rights reserved.
//

import Foundation
import UIKit

struct MusicTorrentsViewModel {

    
    var groups: [MusicGroupWithTorrents] = []
    
    init(groups: [GazelleBrowse.GazelleBrowseMusicGroup]) {
        self.groups = getGroups(with: groups)
    }
    
    func getGroups(with groups: [GazelleBrowse.GazelleBrowseMusicGroup]) -> [MusicGroupWithTorrents] {
        var viewModelGroups: [MusicGroupWithTorrents] = []
        
        for group in groups {
            viewModelGroups.append(MusicGroupWithTorrents.init(group: group))
        }
        
        return viewModelGroups
    }
}

struct MusicGroupWithTorrents {
    enum MusicGroupWithTorrentType {
        case editionHeader
        case editionMeta
    }
    typealias ArtistWithId = (id: Int, name: String)
    typealias AlbumWithId = (id: Int, name: String)
    typealias TorrentWithType = (type: MusicGroupWithTorrentType, data: Any)
    //TODO: Add default album cover
    //Does not contain record label data
    let cover: String
    var artists: [ArtistWithId] = []
    let album: AlbumWithId
    let yearAndReleaseType: String
    var tags: String = ""
    var torrents: [TorrentWithType] = []
    
    init(group: GazelleBrowse.GazelleBrowseMusicGroup) {
        self.cover = group.cover
        if let artists = group.torrents.first?.artists, artists.count > 1 {
            
            var arrayOfArtists: [ArtistWithId] = []
            
            for artist in artists {
                arrayOfArtists.append(ArtistWithId(id: artist.id, name: artist.name))
            }
            self.artists = arrayOfArtists
        } else {
            self.artists = [ArtistWithId(id: 0, name:group.artist)]
        }
        self.album = AlbumWithId(id: group.groupId, name: String(htmlEncodedString: group.groupName)!)
        self.yearAndReleaseType = "[\(group.groupYear)] [\(group.releaseType)]"
        
        for (index,tag) in group.tags.enumerated() {
            if index == 0 {
                self.tags = tag
            }
            
            self.tags = self.tags + ", " + tag
        }
        
        self.torrents = processTorrents(with: group.torrents)
    }
    
    private func processTorrents(with torrents: [GazelleBrowse.GazelleBrowseMusicGroup.GazelleBrowseMusicGroupTorrent]) -> [TorrentWithType]{
        let sortedTorrents = torrents.sorted(by: ({$0.remasterYear < $1.remasterYear}))
        var torrentsWithTypeArray: [TorrentWithType] = []
        
        var currentEdition = 0
        
        for torrent in sortedTorrents {
            if torrent.editionId != currentEdition {
                currentEdition = torrent.editionId
                torrentsWithTypeArray.append(makeTorrentWithType(usingType: .editionHeader, andTorrent: torrent))
            }
            torrentsWithTypeArray.append(makeTorrentWithType(usingType: .editionMeta, andTorrent: torrent))
        }
        return torrentsWithTypeArray
    }
    
    private func makeTorrentWithType(usingType type: MusicGroupWithTorrentType, andTorrent torrent: GazelleBrowse.GazelleBrowseMusicGroup.GazelleBrowseMusicGroupTorrent) -> MusicGroupWithTorrents.TorrentWithType {
        switch type {
        case .editionHeader:
            var headerText: String = ""
            if torrent.remastered {
                headerText = (torrent.remasterYear == 0 ? "Unknown Release(s)" : "\(torrent.remasterYear)") + (torrent.remasterCatalogueNumber.isEmpty ? "" : " / \(torrent.remasterCatalogueNumber)") + (torrent.remasterTitle.isEmpty ? "" : " / \(torrent.remasterTitle)") + " / " + torrent.media
            } else {
                headerText = "Original Release / " + torrent.media
            }
            return TorrentWithType(type: .editionHeader, data: headerText)
        case .editionMeta:
            let metaText = torrent.format + " / \(torrent.encoding)" + (torrent.hasLog ? " / Log(\(torrent.logScore)%)" : "") +
                (torrent.hasCue ? " / Cue": "") + (torrent.scene ? " / Scene": "")
            return TorrentWithType(type: .editionMeta, data: metaText)
        }
    }
}

extension String {
    
    init?(htmlEncodedString: String) {
        
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.documentType.rawValue): NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentReadingOptionKey.characterEncoding.rawValue): String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString.string)
    }
    
}

