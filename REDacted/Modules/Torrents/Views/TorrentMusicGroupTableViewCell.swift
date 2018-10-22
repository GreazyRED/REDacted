//
//  TorrentMusicGroupTableViewCell.swift
//  REDacted
//
//  Created by Greazy on 8/4/18.
//  Copyright © 2018 Red. All rights reserved.
//

import UIKit

class TorrentMusicGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var artist: UIButton!
    @IBOutlet weak var album: UIButton!
    @IBOutlet weak var yearAndReleaseLabel: UILabel!
    @IBOutlet weak var tags: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
