//
//  RedactedNavigationActivityView.swift
//  REDacted
//
//  Created by Greazy on 7/20/18.
//  Copyright © 2018 Red. All rights reserved.
//

import UIKit

class RedactedNavigationActivityView: UIView {
    @IBOutlet weak var backgroundView: UIView! {
        didSet {
            backgroundView.layer.cornerRadius = 5.0
        }
    }
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityStatusLabel: UILabel!
    
    override func awakeFromNib() {
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.addSubview(blurEffectView)
//        self.sendSubviewToBack(blurEffectView)
    }
}
