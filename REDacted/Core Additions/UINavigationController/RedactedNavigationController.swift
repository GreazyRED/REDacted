//
//  RedactedNavigationController.swift
//  REDacted
//
//  Created by Greazy on 7/20/18.
//  Copyright © 2018 Red. All rights reserved.
//

import UIKit

class RedactedNavigationController: UINavigationController {
    
    lazy var activityIndicatorView: RedactedNavigationActivityView = UIView.fromNib()
    
    let apiClient = RedApiClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isHidden = true
        
        apiClient.requestindex { result in
            guard let result = result else { return }
            
            UserDefaults.standard.set(result.userId, forKey: "userId")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func showIndicator(withMessage string:String = "") {
        print(self.view.subviews.count)
        if activityIndicatorView.activityIndicator.isAnimating {
            UIView.animate(withDuration: 0.3) {
                if string.isEmpty { return }
                self.activityIndicatorView.activityStatusLabel.text = string
                self.activityIndicatorView.activityStatusLabel.isHidden = false
                
            }
            return
        }
        
        activityIndicatorView.activityIndicator.startAnimating()
        activityIndicatorView.activityStatusLabel.text = string
        view.addSubview(activityIndicatorView)
    }
    
    public func stopIndicator() {
        activityIndicatorView.activityIndicator.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
