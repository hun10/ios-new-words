//
//  AppDelegate.swift
//  New Words
//
//  Created by Dmitri Urbanowicz on 25/01/2017.
//  Copyright © 2017 Dmitri Urbanowicz. All rights reserved.
//

/*
 The application is intended to simplify iOS built-in dictionary usage.
 It shows a list of words. Words can be added and deleted.
 When user taps on the word, its definition is shown.
 Also it is shown right after a new word has been entered.
 The list shows most recent words at the top.
 Additionally it groups words by date and show day time for each word.
 Most recent days are denoted as Today and Yesterday.
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    // This should update group headers as they may change
    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "updateView"),
            object: nil
        )
    }
}
