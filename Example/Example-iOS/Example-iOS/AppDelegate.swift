//
//  AppDelegate.swift
//  Example-iOS
//
//  Created by Nikita Ermolenko on 23/12/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        
        let rootViewController = UINavigationController(rootViewController: ViewController())
        window!.rootViewController = rootViewController
        
        return true
    }
}
