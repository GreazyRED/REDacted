//
//  ProfileViewController.swift
//  REDacted
//
//  Created by Greazy on 7/30/18.
//  Copyright © 2018 Red. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let apiClient = RedApiClient()
    var userData: ProfileViewModel?
    private let profileCell = "profileCell"
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userclass: UILabel!
    @IBOutlet weak var joinDate: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Implement segment control to add a Settings area
        
        guard let userId = UserDefaults.standard.string(forKey: "userId") else { return }
        activityIndicator.showIndicator(withMessage: "Loading Profile Data")
        apiClient.postUser(userId: userId) { result in
            guard let result = result else { return }
            //TODO: add a generic avatar when empty
            self.avatar.af_setImage(withURL: URL(string:result.avatar)!)
            self.avatar.layer.cornerRadius = self.avatar.frame.height / 2
            self.avatar.clipsToBounds = true
            self.username.text = result.userName.trimmingCharacters(in: .whitespaces)
            self.userclass.text = result.personal.userClass.trimmingCharacters(in: .whitespaces)
            self.joinDate.text = self.returnDateSince(result.stats.joinedDate)
            self.userData = ProfileViewModel.init(userData: result)
            self.tableView.reloadData()
            self.activityIndicator.stopIndicator()
        }
    }
    
    private func returnDateSince(_ dateString:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale.current
        guard let date = dateFormatter.date(from: dateString) else { return ""}
        let timeSinceJoin = Calendar.current.dateComponents([.year, .month, .day], from: date, to: Date())
        
        guard let years = timeSinceJoin.year, let months = timeSinceJoin.month, let days = timeSinceJoin.day else { return "" }
        
        if years == 0 && months == 0 && days == 0 {
            return "Joined today!"
        } else if years == 0 && months == 0 && days == 1 {
            return "Joined yesterday"
        }
        
        var yearString = ""
        var monthString = ""
        var dayString = ""
        let comma = ", "
        var finalString = ""
        if years == 0 { yearString = ""} else { yearString = "\(years)y"}
        
        if months != 0 || days != 0 { finalString = yearString + comma } else { finalString = yearString }
        
        if months == 0 { monthString = "" } else {monthString = "\(months)m"}
        
        if days != 0 { finalString = finalString + monthString + comma} else { finalString = finalString + monthString }
        
        if days == 0 { dayString = "" } else { dayString = "\(days)d"}
        
        finalString = finalString + dayString
        
        return "Joined \(finalString) ago"
        
    }
    
    private func convertBytesToGigs(with bytes:Int) -> String {
        return "\(bytes/1073741824)"
    }

}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let data = self.userData else { return 0 }
        return data.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = self.userData else { return 0 }
        return data.sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        guard let cellData = self.userData else { return cell }
        cell.textLabel?.text = cellData.sections[indexPath.section].cells[indexPath.row].title
        cell.detailTextLabel?.text = cellData.sections[indexPath.section].cells[indexPath.row].detail
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let data = self.userData else { return "" }
        return data.sections[section].sectionTitle
    }
    
    
}
