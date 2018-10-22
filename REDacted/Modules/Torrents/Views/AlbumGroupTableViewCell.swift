//
//  AlbumGroupTableViewCell.swift
//  REDacted
//
//  Created by Greazy on 8/6/18.
//  Copyright © 2018 Red. All rights reserved.
//

import UIKit

class AlbumGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var releaseType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
