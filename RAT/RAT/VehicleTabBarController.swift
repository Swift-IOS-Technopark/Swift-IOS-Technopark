//
//  VehicleTabBarController.swift
//  RAT
//
//  Created by Кирилл Володин on 18.05.17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit

class VehicleTabBarController: UITabBarController {

    var vehicle: Vehicle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.index(of: item){
            print(index)
        switch index {
        case 0:
            let nav = self.viewControllers![0] as! UINavigationController
            let destinationViewController = nav.viewControllers[0] as! ListOfCrashesViewController
            destinationViewController.vehicle = vehicle!
            destinationViewController.nowTypeCrash = .actual
            APIHelper.getListOfActualCrashesRequest(vehicle: vehicle!)
        /*case 1:
            let nav = self.viewControllers![1] as! UINavigationController
            let destinationViewController = nav.viewControllers[0] as! ListOfCrashesViewController
            destinationViewController.vehicle = vehicle!
            destinationViewController.nowTypeCrash = .history
            APIHelper.getListOfHistoryCrashesRequest(vehicle: vehicle!)*/
        case 1:
            let nav = self.viewControllers![1] as! UINavigationController
            let destinationViewController = nav.viewControllers[0] as! ListOfOffersViewController
            destinationViewController.vehicle = vehicle!
            APIHelper.getListsOfOffersAndServicesRequest(vehicle:vehicle!)
        case 2:
            let nav = self.viewControllers![2] as! UINavigationController
            let destinationViewController = nav.viewControllers[0] as! AddRedactViewController
            destinationViewController.vehicle = vehicle!
        default: break
        }
        }
    }

}
