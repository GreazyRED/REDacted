//
//  LoginViewController.swift
//  REDacted
//
//  Created by Greazy on 7/18/18.
//  Copyright © 2018 Red. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import Kanna

private enum MessageType {
    case attempts
    case banned
    case invalidCredentials
}

private enum LoginState {
    case checkIfAuthenticated
    case needsAuthentication
    case needs2FA
    case isBanned
}

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var credentialsStackView: UIStackView!
    @IBOutlet weak var messagesStackView: UIStackView!
    @IBOutlet weak var statusLabel: UILabel! {
        didSet { statusLabel.textAlignment = .center }
    }
    @IBOutlet weak var attemptsLabel: UILabel! {
        didSet { attemptsLabel.textAlignment = .center }
    }
    @IBOutlet weak var warningLabel: UILabel! {
        didSet { warningLabel.textAlignment = .center }
    }
    
    @IBOutlet weak var keyboardConstraint: NSLayoutConstraint!
    var keyboardConstraintValue: CGFloat = 0.0
    
    var googleAlertController = UIAlertController()
    
    var hasStatus: Bool = false{
        didSet {
            if hasStatus == oldValue { return }
            if hasStatus {
                return statusLabel.isHidden = !hasStatus
            }
            return statusLabel.isHidden = hasStatus
        }
    }
    
    var hasAttempts: Bool = false {
        didSet {
            if hasAttempts == oldValue { return }
            if hasAttempts {
                return attemptsLabel.isHidden = !hasAttempts
            }
            return attemptsLabel.isHidden = hasAttempts
        }
    }
    
    var hasWarning: Bool = false {
        didSet {
            if hasWarning == oldValue { return }
            if hasWarning {
                warningLabel.attributedText = getWarningAttributedString()
                return warningLabel.isHidden = !hasWarning
            }
            return warningLabel.isHidden = hasWarning
        }
    }
    var webView: UIWebView!
    var beforeClick = true
    var twoFactorCode: Int = 0
    fileprivate var loginState: LoginState = .checkIfAuthenticated
    

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.showIndicator(withMessage: "Attempting to Login")
        checkLoggedInStatus()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
        let keyboard = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
        let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        print(duration)
        let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
        
        let buttonLocation = logInButton.convert(logInButton.frame.origin, to: nil)
        print(buttonLocation.y)
        print(keyboard.origin.y)
        if buttonLocation.y > keyboard.origin.y {
            keyboardConstraint.constant = keyboard.origin.y - buttonLocation.y - logInButton.frame.height
            keyboardConstraintValue = keyboardConstraint.constant
            print(keyboardConstraintValue)
            
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: animationCurve,
                           animations: { self.view.layoutSubviews() },
                           completion: nil)
        }
    }
    
    func checkLoggedInStatus() {
        webView = UIWebView(frame: .zero)
        webView.delegate = self
        webView.loadRequest(URLRequest(url: URL(string: "https://redacted.ch/ajax.php?action=index")!))
    }
    
    @IBAction func didTapLogIn(_ sender: UIButton) {
        handleKeyboard()
        triggerLogin()
    }
    @IBAction func didPressReturnOnPasswordField(_ sender: UITextField) {
        handleKeyboard()
        triggerLogin()
    }
    
    func handleKeyboard() {
        if passwordTextField.isEditing {
            passwordTextField.resignFirstResponder()
        }
        
        if usernameTextField.isEditing {
            usernameTextField.resignFirstResponder()
        }
            keyboardConstraint.constant -= keyboardConstraintValue
            
        UIView.animate(withDuration: TimeInterval(0.25), delay: 0, options: .curveEaseInOut, animations: ({
            self.view.layoutSubviews()
        }), completion: nil)
        
        keyboardConstraintValue = 0
        
    }
    
    func showTwoFactorPopUp() {
        
        googleAlertController = UIAlertController(title: "Google 2-Factor Authentication", message: "Enter your 6-digit code below", preferredStyle: .alert)
        googleAlertController.addTextField { (text) in
            text.placeholder = "Enter your 6 digit code"
            text.keyboardType = .numberPad
            text.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.webView.stringByEvaluatingJavaScript(from: "document.getElementsByName(\"qrcode_confirm\")[0].value = \(self.twoFactorCode)")
            self.webView.stringByEvaluatingJavaScript(from: "document.getElementsByName(\"logmein\")[0].click()")
        }
        okAction.isEnabled = false
        googleAlertController.addAction(cancelAction)
        googleAlertController.addAction(okAction)
        present(googleAlertController, animated: true, completion: nil)
    }
    
    func triggerLogin() {
        webView.stringByEvaluatingJavaScript(from: "\(WebViewConstants.setUserName)\"\(usernameTextField.text!)\"")
        webView.stringByEvaluatingJavaScript(from: "\(WebViewConstants.setPassword)\"\(passwordTextField.text!)\"")
        if let status = webView.stringByEvaluatingJavaScript(from: WebViewConstants.getRememberMeStatus), status == "false" {
            webView.stringByEvaluatingJavaScript(from: WebViewConstants.clickRememberMe)
        }
        webView.stringByEvaluatingJavaScript(from: WebViewConstants.clickSubmit)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let okAction = googleAlertController.actions.filter({$0.style == .default}).first,
            let authTextField = googleAlertController.textFields?.first else { return }
        
        
        guard var text = authTextField.text else { return }
        text = cleanString(withText: text)
        
        
        if text.count < 6 {
            okAction.isEnabled = false
        }
        
        if text.count == 6 {
            okAction.isEnabled = true
        }
        
        if text.count > 6 {
            okAction.isEnabled = false
            let sixDigits = text.index(text.startIndex, offsetBy: 5)
            authTextField.text = String(text[...sixDigits])
            return
        }
        
        if let number = Int(text) {
            print(number)
            twoFactorCode = number
        }
        
    }
    
    func gotoUserPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "UserView")
        present(controller, animated: true, completion: nil)
    }
    
    fileprivate func cleanString(withText text: String?) -> String {
        guard let text = text else { return "" }
        let regexPattern = "[^0-9]"
        let regex = try! NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
        return regex.stringByReplacingMatches(in: text, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, text.count), withTemplate: "")
    }
}

extension LoginViewController: UITextFieldDelegate {
}

extension LoginViewController: UIWebViewDelegate {

    func webViewDidFinishLoad(_ webView: UIWebView) {
        let url = webView.request?.url?.absoluteString ?? ""
        checkState(withUrl: url)
        print("didFinish: \(url)")
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("error: \(error)")
    }
    
    func checkState(withUrl url:String) {
        if url.isEmpty { return }
        
        switch loginState {
        case .checkIfAuthenticated:
            
            //theory that if a user is authenticated the index API will be returned back
            if url == WebViewConstants.indexData { gotoUserPage() }
            
            //if the authentication check for the user returns the login page
            //we need to prepare the screen for login
            if url == WebViewConstants.loginPage { loginState = .needsAuthentication }

            
            if let attemptsLeft = webView.stringByEvaluatingJavaScript(from: WebViewConstants.getAttemptsLeft), !attemptsLeft.isEmpty {
                print(webView.stringByEvaluatingJavaScript(from: WebViewConstants.getHTML)!)
                print(attemptsLeft)
                updateMessages(withText: attemptsLeft, withType: .attempts)
                break
            }
            
            //a check is made to see if the user is banned from loggin in and
            //the time left will be presented. The UI should be disabled since
            //there is no way to send crendentials
            checkForBans()
            
        case .needsAuthentication:
            //The user does not have 2FA enabled
            if url == WebViewConstants.indexPage { print("push to main page") }
            
            //The user attempted to authenticate
            if url == WebViewConstants.loginPage {
                //The user has 2FA enabbled
                if let twoFactor = webView.stringByEvaluatingJavaScript(from: WebViewConstants.getQRCode), !twoFactor.isEmpty {
                    loginState = .needs2FA
                    checkState(withUrl: url)
                    return
                }
                
                //Something happened while authenticating
                
                //Check for invalid credentials
                if let _ = webView.stringByEvaluatingJavaScript(from: WebViewConstants.invalidPassword),
                    let attemptsLeft = webView.stringByEvaluatingJavaScript(from: WebViewConstants.getAttemptsLeft) {
                    updateMessages(withText: attemptsLeft, withType: .invalidCredentials)
                }
                checkForBans()
                
            }
        case .needs2FA:
            if webView.request?.url?.absoluteString == "https://redacted.ch/ajax.php?action=index" {
                gotoUserPage()
            }
            if let message = webView.stringByEvaluatingJavaScript(from: WebViewConstants.invalidToken), !message.isEmpty {
                
            }
            showTwoFactorPopUp()
        default:
            break
        }
        activityIndicator.stopIndicator()
    }
    
    fileprivate func updateMessages(withText text: String, withType type: MessageType) {
        
        if let warningText = webView.stringByEvaluatingJavaScript(from: WebViewConstants.getWarning), warningText != "-1" {
            self.hasWarning = true
        } else {
            self.hasWarning = false
        }
        
        switch type {
        case .attempts:
            hasAttempts = true
            attemptsLabel.attributedText = getAttemptsAttributedString(withText: text)
        case .banned:
            hasStatus = true
            hasAttempts = false
            statusLabel.attributedText = getRedAttributedString(withText: text)
        case .invalidCredentials:
            hasStatus = true
            hasAttempts = true
            attemptsLabel.attributedText = getAttemptsAttributedString(withText: text)
            statusLabel.attributedText = getRedAttributedString(withText: "Your username or password was incorrect")
        }
    }
    
    fileprivate func hideLoginAbility() {
        credentialsStackView.isHidden = true
        logInButton.isHidden = true
    }
    
    fileprivate func checkForBans() {
        //refactor these blocks
        if let bannedTime = webView.stringByEvaluatingJavaScript(from: WebViewConstants.getBannedTime), !bannedTime.isEmpty {
            loginState = .isBanned
            updateMessages(withText: bannedTime, withType: .banned)
            hideLoginAbility()
            return
        }
        
        if let ipBan = webView.stringByEvaluatingJavaScript(from: WebViewConstants.getIPBan), !ipBan.isEmpty {
            loginState = .isBanned
            updateMessages(withText: ipBan, withType: .banned)
            hideLoginAbility()
            return
        }
    }
    
    fileprivate func getAttemptsAttributedString(withText text:String) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString()
        let normalAttribute = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15),
                               NSAttributedStringKey.foregroundColor: UIColor.init(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)]
        let attemptAttribute = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15),
                                NSAttributedStringKey.foregroundColor: UIColor.init(red: 0, green: 128/255, blue: 0, alpha: 1)]
        print("# of attempts \(text)")
        attributedText.append(NSAttributedString(string: "You have ", attributes: normalAttribute))
        attributedText.append(NSAttributedString(string: text, attributes: attemptAttribute))
        attributedText.append(NSAttributedString(string: " attempts left.", attributes: normalAttribute))
        return attributedText
    }
    
    fileprivate func getRedAttributedString(withText text:String) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString()
        let redAttribute = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15),
                            NSAttributedStringKey.foregroundColor: UIColor.init(red: 200/255, green: 0, blue: 0, alpha: 1)]
        attributedText.append(NSAttributedString(string: text, attributes: redAttribute))
        return attributedText
    }
    
    fileprivate func getWarningAttributedString() -> NSMutableAttributedString {
        let boldNormalAttribute = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14),
                                   NSAttributedStringKey.foregroundColor: UIColor.init(red: 200/255, green:0, blue: 0, alpha: 1)]
        let normalAttribute = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
                               NSAttributedStringKey.foregroundColor: UIColor.init(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)]
        let attributedText = NSMutableAttributedString()
        attributedText.append(NSAttributedString(string: "\nWARNING: ", attributes: boldNormalAttribute))
        attributedText.append(NSAttributedString(string: "You will be banned for 6 hours after your login attempts run out!", attributes: normalAttribute))
        return attributedText
    }
}
