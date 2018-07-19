//
//  LoginConstants.swift
//  REDacted
//
//  Created by Greazy on 7/20/18.
//  Copyright © 2018 Red. All rights reserved.
//

import Foundation

struct WebViewConstants {
    static let getHTML = "document.getElementsByTagName(\"html\")[0].innerHTML;"
    static let setUserName = "document.getElementById(\"username\").value = "
    static let setPassword = "document.getElementById(\"password\").value = "
    static let getQRCode = "document.getElementsByName(\"qrcode_confirm\")[0].name"
    static let loginPage = "https://redacted.ch/login.php"
    static let indexData = "https://redacted.ch/ajax.php?action=index"
    static let indexPage = "https://redacted.ch/index.php"
    static let getAttemptsLeft = "document.getElementsByClassName(\"info\")[0].innerHTML"
    static let getBannedTime = "document.getElementsByClassName(\"time tooltip\")[0].innerHTML"
    static let getWarning = "document.documentElement.innerText.indexOf(\"You will be banned for 6 hours after your login attempts run out!\")"
    static let getIPBan = "document.getElementsByTagName(\"p\")[0].innerHTML"
    static let invalidToken = "document.getElementsByClassName(\"warning\")[0].innerHTML"
    static let invalidPassword = "document.getElementsByClassName(\"warning\")[1].innerHTML"
    static let clickSubmit = "document.getElementsByClassName(\"submit\")[0].click()"
    static let getRememberMeStatus = "document.getElementById(\"keeplogged\").checked"
    static let clickRememberMe = "document.getElementById(\"keeplogged\").click()"
}
