//
//  AppDelegate.swift
//  RocketChatAdapter
//
//  Created by Jan Bartel on 03/12/2016.
//  Copyright (c) 2016 Jan Bartel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame:UIScreen.mainScreen().bounds)
        
        self.window?.rootViewController = TestViewController(nibName:"TestViewController",bundle: nil)
        
        
        self.window?.makeKeyAndVisible()
        
        return true
    }

  


}

