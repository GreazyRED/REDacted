//
//  Top10TorrentTableViewCell.swift
//  REDacted
//
//  Created by Greazy on 10/26/18.
//  Copyright © 2018 Red. All rights reserved.
//

import UIKit

class Top10TorrentTableViewCell: UITableViewCell {
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var releaseFormat: UILabel!
    @IBOutlet weak var torrentSize: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
