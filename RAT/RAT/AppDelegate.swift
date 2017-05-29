//
//  AppDelegate.swift
//  RAT
//
//  Created by Kirill on 3/16/17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import VK_ios_sdk


fileprivate var SCOPE: [Any]? = nil

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let config = Realm.Configuration(

            schemaVersion: 15,
            
            migrationBlock: { migration, oldSchemaVersion in
                
                if (oldSchemaVersion < 15) {
                    
                }
        })
        Realm.Configuration.defaultConfiguration = config
        
        UIApplication.shared.statusBarStyle = .lightContent
        FIRApp.configure()
        
        print("func application")

        VKSdk.initialize(withAppId: "6050937")
        SCOPE = [VK_PER_FRIENDS, VK_PER_WALL, VK_PER_PHOTOS, VK_PER_EMAIL, VK_PER_MESSAGES, VK_PER_OFFLINE]
        VKSdk.wakeUpSession(SCOPE, complete: {(_ state: VKAuthorizationState, _ error: Error?) -> Void in
            if error != nil {
                let alertVC = UIAlertController(title: "", message: error.debugDescription, preferredStyle: UIAlertControllerStyle.alert)
                alertVC.addAction(okButton)
                self.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
            }
            else if state == VKAuthorizationState.authorized{
                print("авторизован")
                
                
            }
            else if state != VKAuthorizationState.authorized {
                print("не авторизован")
            }
        })

        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        VKSdk.processOpen(url, fromApplication: UIApplicationOpenURLOptionsKey.sourceApplication.rawValue)
        print("application URL")
        return true
    }
}

