//
//  AppDelegate.swift
//  StreamlayerApp
//
//  Created by Tracker on 27.05.2020.
//  Copyright © 2020 Tracker. All rights reserved.
//

import UIKit
import StreamLayer
import StreamLayerVendor

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupSDK()
        
        return true
    }
    
    func setupSDK() {
        do {
            try StreamLayer.initSDK(with: SDKConfig.apiKey)
        } catch {
            fatalError("failed to init StreamLayer SDK: \(error)")
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

