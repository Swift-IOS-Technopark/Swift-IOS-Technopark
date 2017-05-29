//
//  ServiceViewController.swift
//  RAT
//
//  Created by Kirill on 4/13/17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class ServiceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var serviceDescription: UITextView!
    @IBOutlet weak var listOfReviewsTable: UITableView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceEmail: UILabel!
    @IBOutlet weak var servicePhone: UILabel!
    @IBOutlet weak var serviceAdress: UILabel!
    var naviString,longitudeString,latitudeString: String?
    var longitude = 0.0, latitude = 0.0

    let locationManager = CLLocationManager()
    
    @IBAction func navigatorButton(_ sender: Any) {
        
        locationManager.delegate = self as! CLLocationManagerDelegate
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
        longitudeString = String(longitude)
        latitudeString = String(latitude)
        // делаем ссылку для Яндекс.Навигатора
        naviString = "yandexnavi://build_route_on_map?lat_from=" + String(Double((locationManager.location?.coordinate.latitude)!)) + "&lon_from=" + String(Double((locationManager.location?.coordinate.longitude)!)) + "&lat_to=" + latitudeString! + "&lon_to=" + longitudeString!
        
        var naviURL = URL(string: naviString!)!
        
        if (UIApplication.shared.canOpenURL(naviURL)) {
            print("can open URL")
            UIApplication.shared.open(naviURL, options: [:], completionHandler: nil)
            
        }
        else {
            print("can not open URL")
            // если приложение не установлено, открываем на него ссылку в AppleStore
            UIApplication.shared.open(URL(string: "https://itunes.apple.com/ru/app/yandex.navigator/id474500851")!, options: [:], completionHandler: nil)
        }
        
        
    }
    
    
    var service = Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listOfReviewsTable.reloadData()
        serviceDescription.text = service.serviceDescription
        serviceName.text=service.name
        serviceEmail.text = service.email
        servicePhone.text = service.phone
        serviceAdress.text = service.address
        
        print("found reviews \(service.reviews.count)")
        listOfReviewsTable.dataSource = self
        listOfReviewsTable.delegate = self
        
        print(serviceAdress)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("found reviews \(service.reviews.count)")
        return service.reviews.count
        //return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = listOfReviewsTable.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
        let index = indexPath.row
        print("rew")
        print(index)
        print(service.reviews[index].text)
        print(service.reviews[index].date)
        cell.reviewText.text = service.reviews[index].text
        cell.reviewDate.text = service.reviews[index].date
        return cell
    }
    
    
    func getServiceCallback(_ notification: NSNotification){
        let data = notification.userInfo as! [String : JSON]
        let service = data["data"]!
        _ = DataBaseHelper.setService(json: service)
    }
    
    func getListOfReviewsCallback(_ notification: NSNotification){
        let data = notification.userInfo as! [String : JSON]
        let reviews = data["data"]!.arrayValue
        for review in reviews {
            _ = DataBaseHelper.setReview(service: service, json: review)
        }
        self.listOfReviewsTable.reloadData()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //
    }
    func  locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //
    }
}
