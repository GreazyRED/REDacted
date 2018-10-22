//
//  AlbumGroupViewModel.swift
//  REDacted
//
//  Created by Greazy on 8/6/18.
//  Copyright © 2018 Red. All rights reserved.
//

import Foundation

struct AlbumGroupViewModel {
    var albums: [AlbumGroup] = []
    
    init(groups: [GazelleBrowse.GazelleBrowseMusicGroup]) {
        let processedAlbums = processAlbums(with: groups)
        self.albums = processedAlbums
    }
    
    private func processAlbums(with groups: [GazelleBrowse.GazelleBrowseMusicGroup]) -> [AlbumGroup]{
        var albums: [AlbumGroup] = []
        for group in groups {
            albums.append(AlbumGroup(id: group.groupId, cover: group.cover, albumName: String(htmlEncodedString: group.groupName) ?? "", artistName: String(htmlEncodedString: group.artist) ?? "", releaseType: group.releaseType))
        }
        return albums
        
    }
    
    struct AlbumGroup {
        let id: Int
        let cover: String
        let albumName: String
        let artistName: String
        let releaseType: String
    }
}
