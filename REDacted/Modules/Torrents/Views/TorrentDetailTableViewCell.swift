//
//  TorrentDetailTableViewCell.swift
//  REDacted
//
//  Created by Greazy on 8/11/18.
//  Copyright © 2018 Red. All rights reserved.
//

import UIKit

class TorrentDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var useTokenButton: UIButton!
    @IBOutlet weak var torrentDetailLabel: UILabel!
    @IBOutlet weak var uploaderButton: UIButton!
    @IBOutlet weak var torrentDetailDateLabel: UILabel!
    @IBOutlet weak var uploadedByStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
