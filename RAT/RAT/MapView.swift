//
//  mapView.swift
//  RAT
//
//  Created by Анастасия Шахлан on 28.04.17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit
import MapKit

class mapView: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // 55.763724, 37.592568
        // 55.760325, 37.597975
        
        let sourceLocation = CLLocationCoordinate2D(latitude: 55.763724, longitude: 37.592568)
        let destinationLocation = CLLocationCoordinate2D(latitude: 55.760325, longitude: 37.597975)
        
        // объекты-метки
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // используются для маршрутизации, этот класс инкапсулирует информацию о конкретной точке на карте
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // аннотации для названий меток
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Патриаршие пруды"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Синагога"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // отображение аннотаций на карте
        //        self.mapView.showAnnotations([sourceAnnotation], animated: true)
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        // MKDirectionsRequest - класс для вычисления маршрута
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
      //  directionRequest.transportType = .automobile
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        
        
        // маршрут будет нарисован с использованием полилинии по наложенному на карту верхнему слою. Область установлена, поэтому будут видны обе локации
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }


}
