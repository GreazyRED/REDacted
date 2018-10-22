//
//  RedApiClient.swift
//  REDacted
//
//  Created by Greazy on 7/28/18.
//  Copyright © 2018 Red. All rights reserved.
//

import Foundation

class RedApiClient {
    private let baseURL = "https://redacted.ch/"
    private let announcements = "ajax.php?action=announcements"
    private let index = "ajax.php?action=index"
    private let user = "ajax.php?action=user"
    private let browseTorrents = "ajax.php?action=browse&filter_cat[1]=1"
    private let torrentGroupDetail = "ajax.php?action=torrentgroup&id="
    private let top10 = "ajax.php?action=top10"
    
    func requestAnnoucements(_ completionHandler: @escaping (GazelleAnnouncements?) -> ()) {
        NetworkManager.get(getFullURL(announcements), headers: nil) { (result:
            NetworkManager.Result<BaseAPIResponse<GazelleAnnouncements>>) in
            self.wrappedNetworkResponseResult(result: result, completionHandler: completionHandler)
        }
    }
    
    func requestindex(_ completionHandler: @escaping (GazelleIndex?) -> ()) {
        NetworkManager.get(getFullURL(index), headers: nil) { (result:
            NetworkManager.Result<BaseAPIResponse<GazelleIndex>>) in
            self.wrappedNetworkResponseResult(result: result, completionHandler: completionHandler)
        }
    }
    
    func postUser(userId:String, completionHandler: @escaping (GazelleUser?) -> ()) {
        NetworkManager.post(getFullURL(user)+"&id=\(userId)", parameters: nil, headers: nil) { (result: NetworkManager.Result<BaseAPIResponse<GazelleUser>>) in
            self.wrappedNetworkResponseResult(result: result, completionHandler: completionHandler)
        }
    }
    
    func requestMusicTorrents(_ completionHandler: @escaping (GazelleBrowse?) -> ()) {
        NetworkManager.get(getFullURL(browseTorrents), headers: nil) { (result:
            NetworkManager.Result<BaseAPIResponse<GazelleBrowse>>) in
            self.wrappedNetworkResponseResult(result: result, completionHandler: completionHandler)
        }
    }
    
    func requestTorrentGroupDetail(withGroupId groupId: Int, completionHandler: @escaping (TorrentGroupDetail?) ->()) {
        NetworkManager.get(getFullURL(torrentGroupDetail+"\(groupId)"), headers: nil) { (result: NetworkManager.Result<BaseAPIResponse<TorrentGroupDetail>>) in
            self.wrappedNetworkResponseResult(result: result, completionHandler: completionHandler)
        }
    }
    
    func requestTop10(_ completionHandler: @escaping ([TorrentTop10]?) -> ()) {
        NetworkManager.get(getFullURL(top10), headers: nil) { (result: NetworkManager.Result<BaseAPIResponse<[TorrentTop10]>>) in
            self.wrappedNetworkResponseResult(result: result, completionHandler: completionHandler)
        }
    }
    
    
    private func getFullURL(_ string: String) -> String {
        return "\(baseURL)\(string)"
    }
    
    private func wrappedNetworkResponseResult<T>(result: NetworkManager.Result<BaseAPIResponse<T>>, completionHandler: @escaping(T?) -> ()) {
        switch result {
        case .success(let data):
            self.unwrapAndCallCompletionHandler(wrappedResponse: data, completionHandler: completionHandler)
        case .failure:
            print("error")
        }
    }
    
//    private func wrappedNetworkResponseResult<[T>(result: NetworkManager.Result<BaseAPIResponse<[T]>>, completionHandler: @escaping([T]?) -> ()) {
//        switch result {
//        case .success(let data):
//            self.unwrapAndCallCompletionHandler(wrappedResponse: data, completionHandler: completionHandler)
//        case .failure:
//            print("error")
//        }
//    }
    
    private func unwrapAndCallCompletionHandler<T>(wrappedResponse: BaseAPIResponse<T>, completionHandler: @escaping (T?) -> ()) {
        completionHandler(wrappedResponse.response)
    }
}
