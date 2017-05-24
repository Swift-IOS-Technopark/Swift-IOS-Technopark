//
//  CrashViewController.swift
//  RAT
//
//  Created by Kirill on 4/12/17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit
import SwiftyJSON

class CrashViewController: UIViewController {

    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var fullDescription: UITextView!
//    @IBOutlet weak var listOfOffersTable: UITableView!
    
    var crash = Crash()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        listOfOffersTable.dataSource = self
//        listOfOffersTable.delegate = self
//        listOfOffersTable.tableFooterView = UIView() // delete excess separators
        code.text = crash.code
        date.text = crash.date
        fullDescription.text = crash.fullDescription
//        NotificationCenter.default.addObserver(self, selector: #selector(getListOfOffersCallback(_:)), name: .getListOfOffersCallback, object: nil)
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return crash.offers.count
//        
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = listOfOffersTable.dequeueReusableCell(withIdentifier: "OfferCell") as! OfferCell
//        let index = indexPath.row
//        
//        cell.service.text = crash.offers[index].service!.name
//        cell.message.text = crash.offers[index].message
//        cell.price.text = String(crash.offers[index].price)
//        
//        return cell
//    }
    
    
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationController = segue.destination as! CrashViewController
        destinationController.crash = sender as! Crash
    }
    */
    
//    func getListOfOffersCallback(_ notification: NSNotification){
//        print("in")
//        let data = notification.userInfo as! [String : JSON]
//        let offers = data["data"]!.arrayValue
//        print("offer: \(offers)")
//        for offer in offers {
//            
//            DataBaseHelper.setOffer(crash: crash, json: offer)
//        }
//        self.listOfOffersTable.reloadData()
//        
//    }
}
