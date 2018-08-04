//
//  Annoucements.swift
//  REDacted
//
//  Created by Greazy on 7/28/18.
//  Copyright © 2018 Red. All rights reserved.
//

import Foundation

struct GazelleAnnouncements: Codable {
    let announcements: [GazelleAnnouncement]
    
    struct GazelleAnnouncement: Codable {
        let newsId: Int
        let title: String
        let bbBody: String
        let body: String
        let newsTime: String
    }
}
