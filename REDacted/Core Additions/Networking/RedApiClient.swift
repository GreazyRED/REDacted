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
    
    
    private func getFullURL(_ string: String) -> String {
        return "\(baseURL)\(string)"
    }
    
    private func wrappedNetworkResponseResult<T>(result: NetworkManager.Result<BaseAPIResponse<T>>, completionHandler: @escaping(T?) -> ()) {
        switch result {
        case .success(let data):
            self.unwrapAndCallCompletionHandler(wrappedResponse: data, completionHandler: completionHandler)
        case .failure:
            print("Wrapped Error")
        }
    }
    
    private func unwrapAndCallCompletionHandler<T>(wrappedResponse: BaseAPIResponse<T>, completionHandler: @escaping (T?) -> ()) {
        completionHandler(wrappedResponse.response)
    }
}
