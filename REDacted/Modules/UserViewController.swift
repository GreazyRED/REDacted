//
//  UserViewController.swift
//  REDacted
//
//  Created by Greazy on 7/19/18.
//  Copyright © 2018 Red. All rights reserved.
//

import UIKit
import Alamofire

struct RedactedIndex: Codable {
    let status: String
    let response: IndexData
    
    struct IndexData: Codable {
        let authkey: String
        let id: Int
        let notifications: NotificationItems
        let passkey: String
        let userName: String
        let userstats: UserStatList
        
        enum CodingKeys: String, CodingKey {
            case authkey
            case id
            case notifications
            case passkey
            case userName = "username"
            case userstats
        }
    }

    
    struct NotificationItems: Codable {
        let messages: Int
        let newAnnouncement: Bool
        let newBlog: Bool
        let newSubscriptions: Bool
        let notifications: Int
    }
    
    struct UserStatList: Codable {
        let userClass: String
        let downloaded: Int64
        let ratio: Double
        let requiredRatio: Double
        let uploaded: Int64
        
        enum CodingKeys: String, CodingKey {
            case userClass = "class"
            case downloaded
            case ratio
            case requiredRatio = "requiredratio"
            case uploaded
        }
    }
}


class UserViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var lastAccess: UILabel!
    @IBOutlet weak var uploadedLabel: UILabel!
    @IBOutlet weak var downloadedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //userNameLabel.text = "Test"
        callUserInfo()
    }
    
    func callUserInfo() {
        Alamofire.request("https://redacted.ch/ajax.php?action=index", method: .get, parameters: nil, headers: nil).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Dis Da Data: \(response.result.value)")
                do {
                    let decoder = JSONDecoder()
                    let index = try decoder.decode(RedactedIndex.self, from: response.data!)
                    print(index.response.userName)
                    self.assignLabels(using: index)
                } catch {
                    print("i got caught")
                }
                
            case .failure:
                print("boo")
            }
        }
    }
    
    func assignLabels(using data: RedactedIndex) {
        userNameLabel.text = data.response.userName
        classLabel.text = data.response.userstats.userClass
        joinDateLabel.text = "\(data.response.userstats.ratio)"
        lastAccess.text = "\(data.response.userstats.requiredRatio)"
        uploadedLabel.text = "\(data.response.userstats.uploaded)"
        downloadedLabel.text = "\(data.response.userstats.downloaded)"
    }
}
