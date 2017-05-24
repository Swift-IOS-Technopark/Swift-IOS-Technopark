//
//  VKHelper.swift
//  RAT
//
//  Created by Кирилл Володин on 15.05.17.
//  Copyright © 2017 RAT. All rights reserved.
//

import Foundation
import SwiftyVK

class VKHelper: VKDelegate {
    
    let appID = "6032159"
    let scope: Set<VK.Scope> = [.messages,.offline,.friends,.wall,.photos,.audio,.video,.docs,.market,.email]
    
    init() {
        VK.config.logToConsole = true
        VK.configure(withAppId: appID, delegate: self)
        print("Init did finished")
    }
    
    func vkWillAuthorize() -> Set<VK.Scope> {
        //Called when SwiftyVK need authorization permissions.
        return scope
    }
    
    func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
        print("Autorization success")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TestVkDidAuthorize"), object: nil)
    }
    
    func vkAutorizationFailedWith(error: AuthError) {
        print("Autorization failed with error: \n\(error)")
        //NotificationCenter.default.post(name: Notification.Name(rawValue: "TestVkDidNotAuthorize"), object: nil)
    }
    
    func vkDidUnauthorize() {
        
    }
    
    func vkShouldUseTokenPath() -> String? {
        return nil
    }
    
    func vkWillPresentView() -> UIViewController {
        //Only for iOS!
        //Called when need to display a view from SwiftyVK.
        return UIApplication.shared.delegate!.window!!.rootViewController!
    }
    
    func authorize() {
        VK.logOut()
        print("SwiftyVK: LogOut")
        VK.logIn()
        print("SwiftyVK: authorize")
    }
    
    func getState() {
        print(VK.state)
    }
    
    
    func logout() {
        VK.logOut()
        print("SwiftyVK: LogOut")
    }
    
}
