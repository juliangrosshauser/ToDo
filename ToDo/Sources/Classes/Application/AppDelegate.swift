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
        let listController = ListController()
        let todoController = TodoController()
        listController.delegate = todoController
        
        let masterViewController = UINavigationController(rootViewController: listController)
        let detailViewController = UINavigationController(rootViewController: todoController)
        
        let splitViewController = UISplitViewController()
        splitViewController.viewControllers = [masterViewController, detailViewController]

        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

