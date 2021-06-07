//
//  AppDelegate.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 13/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow()
        let rootViewController = MainViewController()
        let rootViewModel = MainViewModel()
        rootViewController.bind(rootViewModel)

        window?.makeKeyAndVisible()
        window?.rootViewController = rootViewController
        return true
    }
}
