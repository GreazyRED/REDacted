//
//  UIViewExtensions.swift
//  REDacted
//
//  Created by Greazy on 7/20/18.
//  Copyright © 2018 Red. All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
