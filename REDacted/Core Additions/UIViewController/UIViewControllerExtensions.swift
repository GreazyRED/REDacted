//
//  UIViewControllerExtensions.swift
//  REDacted
//
//  Created by Greazy on 7/21/18.
//  Copyright © 2018 Red. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    var activityIndicator: RedactedNavigationController {
        get {
            return self.navigationController as! RedactedNavigationController
        }
    }
}
