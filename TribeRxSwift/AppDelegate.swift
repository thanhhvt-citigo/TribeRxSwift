//
//  AppDelegate.swift
//  TribeRxSwift
//
//  Created by thanh on 27/04/2022.
//

import UIKit
import SVProgressHUD
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SVProgressHUD.setDefaultMaskType(.black)
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let demoListVC = DemoListVC(vm: .init())
        let navigationController = UINavigationController(rootViewController: demoListVC)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

