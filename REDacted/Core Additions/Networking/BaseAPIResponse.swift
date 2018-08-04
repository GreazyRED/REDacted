//
//  BaseAPIResponse.swift
//  REDacted
//
//  Created by Greazy on 7/28/18.
//  Copyright © 2018 Red. All rights reserved.
//

import Foundation

struct BaseAPIResponse<T: Codable>: Codable {
    let status: APIStatus
    let response: T?
}

enum APIStatus: String, Codable {
    case success = "success"
    case failure = "failure"
}
