//
//  ProfileViewModel.swift
//  REDacted
//
//  Created by Greazy on 7/30/18.
//  Copyright © 2018 Red. All rights reserved.
//

import Foundation
typealias SectionWithSimpleCellData = (sectionTitle: String, cells: [SimpleCellData])
typealias SimpleCellData = (title:String, detail: String)

struct ProfileViewModel {
    
    private enum StorageSize:String {
        case terabyte = "TB"
        case gigabyte = "GB"
        case megabyte = "MB"
    }
    
    var sections: [SectionWithSimpleCellData] = []
    
    init(userData: GazelleUser) {
        var sections: [SectionWithSimpleCellData] = []
        sections.append(processStats(using: userData.stats))
        sections.append(processRanks(using: userData.ranks))
        sections.append(processCommunity(using: userData.community))
        self.sections = sections
    }
    
    private func processStats(using stats:GazelleUser.GazelleStats) -> SectionWithSimpleCellData {
        var data: [SimpleCellData] = []
        data.append(SimpleCellData(title: "Uploaded:", detail:convertBytesToGigs(with: stats.uploaded)))
        data.append(SimpleCellData(title: "Downloaded:", detail: convertBytesToGigs(with: stats.downloaded)))
        data.append(SimpleCellData(title: "Ratio:", detail: stats.ratio))
        data.append(SimpleCellData(title: "Buffer:", detail: convertBytesToGigs(with: stats.buffer)))
        data.append(SimpleCellData(title: "Required Ratio:", detail: String(stats.requiredRatio)))
        return SectionWithSimpleCellData(sectionTitle: "Stats", cells:data)
    }
    
    private func processRanks(using ranks:GazelleUser.GazelleRanks) -> SectionWithSimpleCellData {
        var data: [SimpleCellData] = []
        data.append(SimpleCellData(title: "Uploaded:", detail: String(ranks.uploaded)))
        data.append(SimpleCellData(title: "Downloaded:", detail: String(ranks.downloaded)))
        data.append(SimpleCellData(title: "Uploads:", detail: String(ranks.uploads)))
        data.append(SimpleCellData(title: "Requests:", detail: String(ranks.requests)))
        data.append(SimpleCellData(title: "Bounty:", detail: String(ranks.bounty)))
        data.append(SimpleCellData(title: "Posts:", detail: String(ranks.posts)))
        data.append(SimpleCellData(title: "Artists:", detail: String(ranks.artists)))
        data.append(SimpleCellData(title: "Overall:", detail: String(ranks.overall)))
        return SectionWithSimpleCellData(sectionTitle: "Ranks", cells:data)
    }
    
    private func processCommunity(using community:GazelleUser.GazelleCommunity) -> SectionWithSimpleCellData {
        var data: [SimpleCellData] = []
        data.append(SimpleCellData(title: "Posts:", detail: String(community.posts)))
        data.append(SimpleCellData(title: "Group Votes:", detail: String(community.groupVotes)))
        data.append(SimpleCellData(title: "Torrent Comments:", detail: String(community.torrentComments)))
        data.append(SimpleCellData(title: "Artist Comments:", detail: String(community.artistComments)))
        data.append(SimpleCellData(title: "Collage Comments:", detail: String(community.collageComments)))
        data.append(SimpleCellData(title: "Request Comments:", detail: String(community.requestComments)))
        data.append(SimpleCellData(title: "Collages Started:", detail: String(community.collagesStarted)))
        data.append(SimpleCellData(title: "Collages Contributed:", detail: String(community.collagesContrib)))
        data.append(SimpleCellData(title: "Requests Filled:", detail: String(community.requestsFilled)))
        data.append(SimpleCellData(title: "Bounty Earned:", detail: convertBytesToGigs(with: community.bountyEarned)))
        data.append(SimpleCellData(title: "Requests Voted:", detail: String(community.requestsVoted)))
        data.append(SimpleCellData(title: "Bounty Spent:", detail: convertBytesToGigs(with: community.bountySpent)))
        data.append(SimpleCellData(title: "Perfect FLACs:", detail: community.perfectFlacs.toString()))
        data.append(SimpleCellData(title: "Uploaded:", detail: community.uploaded.toString()))
        data.append(SimpleCellData(title: "Groups:", detail: community.groups.toString()))
        data.append(SimpleCellData(title: "Seeding:", detail: community.seeding.toString()))
        data.append(SimpleCellData(title: "Leeching:", detail: community.leeching.toString()))
        data.append(SimpleCellData(title: "Snatched:", detail: community.snatched.toString()))
        data.append(SimpleCellData(title: "Invited:", detail: community.invited.toString()))
        data.append(SimpleCellData(title: "Artists Added:", detail: community.artistsAdded.toString()))
        return SectionWithSimpleCellData(sectionTitle: "Community", cells:data)
    }
    
    private func convertBytesToGigs(with bytes:Int) -> String {
        let bytes = NSNumber(integerLiteral: bytes)
        let storageSize: StorageSize
        storageSize = .gigabyte
        let conversion = NSNumber(integerLiteral: 1073741824)
        let formatter = NumberFormatter.init()
        formatter.allowsFloats = true
        let convertedNumber = NSNumber(value: (bytes.doubleValue/conversion.doubleValue))
        
        //TODO: Handle TB's and MB's during conversion process
        
        if convertedNumber.doubleValue > 1000 {
            formatter.maximumFractionDigits = 2
            
        } else if convertedNumber.doubleValue > 1 {
            formatter.maximumFractionDigits = 3
        } else {
            formatter.maximumFractionDigits = 4
        }
        
        let formattedNumber = formatter.string(from: convertedNumber) ?? ""

        return formattedNumber + " " + storageSize.rawValue
    }
    
    
}

extension Int {
    func toString() -> String {
        return String(self)
    }
    
    enum BinarySize: Int {
        case megabyte = 1048576
        case gigabyte = 1073741824
        case terabyte = 1099511627776
    }
    func toDecimalString() -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        let currentValue = Double(self)
        
        if (currentValue/Double(BinarySize.megabyte.rawValue) < 1024) {
            let numberString = "\(formatter.string(for: currentValue/Double(BinarySize.megabyte.rawValue)) ?? "0.00")" + " MB"
            return numberString
        }
        
        if (currentValue/Double(BinarySize.gigabyte.rawValue) < 1024) {
            let numberString = "\(formatter.string(for: currentValue/Double(BinarySize.gigabyte.rawValue)) ?? "0.00")" + " GB"
            return numberString
        }

        let numberString = "\(formatter.string(for: currentValue/Double(BinarySize.gigabyte.rawValue)) ?? "0.00")" + " TB"
        return numberString
    }
}
