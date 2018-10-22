//
//  HomeViewController.swift
//  REDacted
//
//  Created by Greazy on 7/25/18.
//  Copyright © 2018 Red. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let apiClient = RedApiClient()
    var annoucements: GazelleAnnouncements?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.showIndicator(withMessage: "Loading Announcements")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 250
        loadAnnouncements()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadAnnouncements() {
        apiClient.requestAnnoucements { (result) in
            self.activityIndicator.stopIndicator()
            guard let annoucements = result else { return }
            self.annoucements = annoucements
            self.tableView.reloadData()
        }
        
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.annoucements?.announcements.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Announcement") as! AnnouncementTableViewCell
        guard let announcements = self.annoucements else { return cell }
        let annoucement = announcements.announcements[indexPath.row]
        cell.announceLabel.text = stripBBCode(from: annoucement.bbBody)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func stripBBCode(from string: String) -> String {
        let regPattern = "\\[(quote|\\/quote|b|\\/b|i|\\/i|align[a-z=]+|size[a-z=0-9]+|url[a-z=0-9:/.?&#]+|\\/url|size|\\/size|color[a-z=]+|\\*|hide|\\/hide|hide[=a-zA-Z\\s]+|img|\\/img|important|\\/important|\\/align|\\/color|pre|\\/pre)\\]"
        let regex = try! NSRegularExpression(pattern: regPattern, options: .caseInsensitive)
        return regex.stringByReplacingMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string.count), withTemplate: "")
    }
}
