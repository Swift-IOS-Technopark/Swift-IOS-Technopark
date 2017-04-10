//
//  ListOfCrashesViewController.swift
//  RAT
//
//  Created by Kirill on 3/18/17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListOfCrashesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var listOfCrashesTable: UITableView!
    var vehicle = Vehicle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listOfCrashesTable.dataSource = self
        listOfCrashesTable.delegate = self
        // listOfCrashesTable.separatorStyle = .none // delete all separators
        listOfCrashesTable.tableFooterView = UIView() // delete excess separators
        NotificationCenter.default.addObserver(self, selector: #selector(getListOfActualCrashesCallback(_:)), name: .getListOfActualCrashesCallback, object: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicle.actualCrashes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listOfCrashesTable.dequeueReusableCell(withIdentifier: "CrashCell") as! CrashCell
        let index = indexPath.row
        cell.code.text = vehicle.actualCrashes[index].code
        cell.shortDecription.text = vehicle.actualCrashes[index].shortDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "fromListOfCrashesToCrashSegue", sender: nil) // transition
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // destination
        let controller = segue.destination
        controller.title = sender as? String
    }
    */
    
    func getListOfActualCrashesCallback(_ notification: NSNotification){
        
        let data = notification.userInfo as! [String : JSON]
        let crashes = data["data"]!.arrayValue
        for crash in crashes {
            DataBaseHelper.setCrash(vehicle: vehicle, json: crash)
        }
        self.listOfCrashesTable.reloadData()
 
    }
}
