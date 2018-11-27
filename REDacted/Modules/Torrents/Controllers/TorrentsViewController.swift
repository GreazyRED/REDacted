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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var stackView: UIStackView!
    
    //var searchController = UISearchController(searchResultsController: nil)
    private enum TorrentSections: Int {
        case torrents = 0
        case top10 = 1
        case search = 2
    }
    
    var groups: AlbumGroupViewModel?
    var top10Groups: [Top10TorrentViewModel]?
    var searchGroups: AlbumGroupViewModel?
    
    let client = RedApiClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
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
        hideSearchBar()
        switch section {
        case TorrentSections.torrents.rawValue:
            client.requestMusicTorrents { response in
                guard let response = response else {
                    self.activityIndicator.stopIndicator()
                    return }
                self.groups = AlbumGroupViewModel.init(groups: response.results)
                self.tableView.reloadData()
                self.activityIndicator.stopIndicator()
            }
        case TorrentSections.top10.rawValue:
            client.requestTop10 { response in
                guard let response = response else {
                    self.activityIndicator.stopIndicator()
                    return }
                self.top10Groups = response.compactMap({ Top10TorrentViewModel.init(top10Data: $0)})
                self.tableView.reloadData()
                self.activityIndicator.stopIndicator()
            }
        case TorrentSections.search.rawValue:
            hideSearchBar(false)
        default:
            print("Section not defined in TorrentSections")
        }
    }
    
    private func hideSearchBar(_ shouldHide:Bool = true) {
        if !searchBar.isHidden && shouldHide {
            searchBar.isHidden.toggle()
            shouldAnimate()
        }
        
        if searchBar.isHidden && !shouldHide {
            searchBar.isHidden.toggle()
            shouldAnimate()
        }
    }
    
    private func shouldAnimate() {
        self.view.endEditing(false)
        
        //initial animation is slightly bugged
        //remove unwanted animations (cursor animates into place)
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func searchForTorrents(withTerm text: String) {
        searchBar.endEditing(false)
        self.activityIndicator.showIndicator()
        client.search(withTerm: text) { response in
            guard let response = response else {
                self.activityIndicator.stopIndicator()
                return }
            self.searchGroups = AlbumGroupViewModel.init(groups: response.results)
            self.tableView.reloadData()
            self.activityIndicator.stopIndicator()
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
        
        if segmentControl.selectedSegmentIndex == 2 {
            guard let rows = searchGroups?.albums else { return 0 }
            return rows.count
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "Top10Torrent") as! Top10TorrentTableViewCell
            
            guard let album = top10Groups?[indexPath.section].torrents[indexPath.row] else { return cell }
            
            cell.albumName.attributedText = album.releaseFormat
            cell.torrentSize.text = album.size
            return cell
        case TorrentSections.search.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumGroup") as! AlbumGroupTableViewCell
            guard let albums = searchGroups?.albums else { return cell }
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
        
        if segmentControl.selectedSegmentIndex == 2 {
            guard let albums = self.searchGroups?.albums else { return }
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

extension TorrentsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            print("Search term: \(searchText)")
            searchForTorrents(withTerm: searchText)
        }
    }
}
