//
//  Helpers.swift
//  REDacted
//
//  Created by Greazy on 10/26/18.
//  Copyright © 2018 Red. All rights reserved.
//

import Foundation
import UIKit

class Helpers {
    
    func makeAttributedString(using string:String, bold: Bool = false, size: CGFloat?, color: UIColor = .black, url: String = "") -> NSAttributedString {
        var attributes: [NSAttributedString.Key : Any] = [:]
        
        if bold {
            if let size = size {
                attributes[.font] = UIFont.boldSystemFont(ofSize: size)
            } else {
                attributes[.font] = UIFont.boldSystemFont(ofSize: 17.0)
            }
        } else {
            if let size = size {
                attributes[.font] = UIFont.systemFont(ofSize: size)
            } else {
                attributes[.font] = UIFont.systemFont(ofSize: 17.0)
            }
        }
        
        if !url.isEmpty {
            attributes[.link] = URL(string: url)
        }
        
        attributes[.foregroundColor] = color
        
        let attributedString =  NSAttributedString(string: string, attributes: attributes)
        return attributedString
    }
}
