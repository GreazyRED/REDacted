//
//  TorrentGroupDetailViewController.swift
//  REDacted
//
//  Created by Greazy on 8/10/18.
//  Copyright © 2018 Red. All rights reserved.
//

import UIKit

class TorrentGroupDetailViewController: UIViewController {
    
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumTypeLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    let client = RedApiClient()
    var torrentDetail: TorrentDetailViewModel?
    
    var groupId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.showIndicator(withMessage: "Loading Album")
        guard let groupId = groupId else { return }
        client.requestTorrentGroupDetail(withGroupId: groupId) { response in
            guard let response = response else { return }
            let detail = TorrentDetailViewModel.init(torrentDetail: response)
            self.torrentDetail = detail
            if let url = detail.albumDetail.cover {
                self.cover.af_setImage(withURL: url)
            }
            self.albumNameLabel.text = detail.albumDetail.albumName
            self.artistNameLabel.text = detail.albumDetail.artistName
            self.albumTypeLabel.text = detail.albumDetail.releaseType
            self.tableView.reloadData()
            self.activityIndicator.stopIndicator()
        }
    
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.activityIndicator.navigationBar.isHidden {
            //self.activityIndicator.navigationBar.isHidden = false
        }
    }
}

extension TorrentGroupDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = torrentDetail?.torrents[section].releaseFormats else { return 0 }
        return rows.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = torrentDetail?.torrents else { return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TorrentDetail") as! TorrentDetailTableViewCell
        guard let torrentData = torrentDetail else { return cell }
        print("Section: \(indexPath.section)\n Row: \(indexPath.row)\n NumberOfFormats: \(torrentData.torrents[indexPath.section].releaseFormats.count)")
        let data = torrentData.torrents[indexPath.section].releaseFormats[indexPath.row]
        cell.torrentDetailLabel.text = data.releaseDescription
        cell.uploaderButton.setTitle(data.username, for: .normal)
        cell.torrentDetailDateLabel.text = data.fileSize
        return cell
    }
    
    
}

extension TorrentGroupDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = torrentDetail?.torrents[section] else { return UIView() }
        let view: SimpleSectionHeader = SimpleSectionHeader.fromNib()
        view.titleLabel.text = section.releaseName
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}
