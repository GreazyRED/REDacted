//
//  TorrentsViewController.swift
//  REDacted
//
//  Created by Greazy on 8/4/18.
//  Copyright © 2018 Red. All rights reserved.
//

import UIKit
import AlamofireImage

class TorrentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private enum TorrentSections: Int {
        case torrents = 0
        case top10 = 1
        case search = 2
    }
    
    var groups: AlbumGroupViewModel?
    var top10Groups: [Top10TorrentViewModel]?
    
    let client = RedApiClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.showIndicator(withMessage: "Loading Torrents")
        requestTorrentsForSection(section: TorrentSections.torrents.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !activityIndicator.navigationBar.isHidden {
            activityIndicator.navigationBar.isHidden = true
        }
    }
    @IBAction func didTapSegmentControl(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        requestTorrentsForSection(section: sender.selectedSegmentIndex)
        tableView.reloadData()
    }
    
    private func requestTorrentsForSection(section: Int) {
        switch section {
        case TorrentSections.torrents.rawValue:
            client.requestMusicTorrents { response in
                guard let response = response else { return }
                self.groups = AlbumGroupViewModel.init(groups: response.results)
                self.tableView.reloadData()
                self.activityIndicator.stopIndicator()
            }
        case TorrentSections.top10.rawValue:
            client.requestTop10 { response in
                guard let response = response else { return }
                self.top10Groups = response.compactMap({ Top10TorrentViewModel.init(top10Data: $0)})
                self.tableView.reloadData()
                self.activityIndicator.stopIndicator()
            }
        case TorrentSections.search.rawValue:
            print("TODO")
        default:
            print("Section not defined in TorrentSections")
        }
    }
}

extension TorrentsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentControl.selectedSegmentIndex == 1 {
            guard let groups = top10Groups else { return 0 }
            //return groups.count
            
            //TODO: uncomment real code above
            return groups.count
        }
        //add section information for search if 1 isn't valid
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControl.selectedSegmentIndex == 0 {
            guard let rows = groups?.albums else { return 0 }
            return rows.count
        }
        
        if segmentControl.selectedSegmentIndex == 1 {
            guard let count = top10Groups?[section].torrents.count else { return 0 }
            return count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentControl.selectedSegmentIndex {
        case TorrentSections.torrents.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumGroup") as! AlbumGroupTableViewCell
            guard let albums = groups?.albums else { return cell }
            let data = albums[indexPath.row]
            
            cell.artistName.text = data.artistName
            cell.albumName.text = data.albumName
            cell.releaseType.text = data.releaseType
            if data.cover.isEmpty {
                cell.albumCover.image = UIImage(imageLiteralResourceName: "ic_missing_artwork")
            } else {
                cell.albumCover.af_setImage(withURL: URL(string: data.cover)!, placeholderImage: UIImage(imageLiteralResourceName: "ic_missing_artwork"))
            }
            return cell
        case TorrentSections.top10.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumGroup") as! AlbumGroupTableViewCell
//            if !cell.uploadedByStackView.isHidden {
//                cell.uploadedByStackView.isHidden = true
//            }
            
            guard let album = top10Groups?[indexPath.section].torrents[indexPath.row] else { return cell }
            cell.artistName.text = album.artistName
            cell.albumName.text = album.albumName
            cell.releaseType.text = album.releaseType
            
            if let url = album.cover {
                cell.albumCover.af_setImage(withURL: url)
            } else {
                cell.albumCover.image = UIImage(imageLiteralResourceName: "ic_missing_artwork")
            }
            return cell
        case TorrentSections.search.rawValue:
            print("hey where da search")
            let cell = UITableViewCell()
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentControl.selectedSegmentIndex == 0 {
            guard let albums = self.groups?.albums else { return }
            if let controller = storyboard?.instantiateViewController(withIdentifier: "TorrentGroupDetail") as? TorrentGroupDetailViewController {
                self.activityIndicator.navigationBar.isHidden = false
                controller.groupId = albums[indexPath.row].id
                let backButton = UIBarButtonItem()
                backButton.title = "Torrents"
                activityIndicator.navigationBar.topItem?.backBarButtonItem = backButton
                controller.navigationController?.title = "Torrent Detail"
                self.navigationController?.pushViewController(controller, animated: true)
                
            }
        }
        
        //
        // OKAY, so maybe this object does not belong being mapped to index 1
        // Top10 torrents should be able to be downloaded directly from this screen
        // Since that is the case we will need to change the cell type to one that is able to be downloaded
        // We may have to create a unique cell. Just be aware that there should be no segue and
        // we should display all torrent meta data
        //
        
        if segmentControl.selectedSegmentIndex == 1 {
            guard let album = self.top10Groups?[indexPath.section].torrents[indexPath.row] else { return }
            if let controller = storyboard?.instantiateViewController(withIdentifier: "TorrentGroupDetail") as? TorrentGroupDetailViewController {
                self.activityIndicator.navigationBar.isHidden = false
                controller.groupId = album.id
                let backButton = UIBarButtonItem()
                backButton.title = "Torrents"
                activityIndicator.navigationBar.topItem?.backBarButtonItem = backButton
                controller.navigationController?.title = "Torrent Detail"
                self.navigationController?.pushViewController(controller, animated: true)
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: SimpleSectionHeader = SimpleSectionHeader.fromNib()
        
        if let sectionName = top10Groups?[section].sectionName {
            view.titleLabel.text = sectionName
        } else {
            view.titleLabel.text = ""
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if segmentControl.selectedSegmentIndex == 1 {
            return 44
        } else {
            return 0
        }
    }
}
