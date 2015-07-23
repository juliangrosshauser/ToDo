//
//  AppDelegate.swift
//  ToDo
//
//  Created by Julian Grosshauser on 16/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.backgroundColor = .whiteColor()
        return window
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let splitViewController = UISplitViewController()
        let masterViewController = UINavigationController(rootViewController: ListController())
        let detailViewController = UINavigationController(rootViewController: TodoController())
        splitViewController.viewControllers = [masterViewController, detailViewController]

        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

