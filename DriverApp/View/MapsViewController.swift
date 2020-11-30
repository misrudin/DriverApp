//
//  MapsViewController.swift
//  DriverApp
//
//  Created by Indo Office4 on 30/11/20.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapsViewController: UIViewController  {

    var mapView: GMSMapView! //Google Map View
        var userMarker: GMSMarker! //Our Car marker
        private let locationManager = CLLocationManager()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupMap()
            createMarker()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }

        func setupMap() {
            let map = GMSMapView(frame: view.bounds)
            map.animate(toViewingAngle: 40)
            map.animate(toZoom: 20)
            self.view.addSubview(map)
            mapView = map
        }
        
    func createMarker() {
         let marker = GMSMarker()
        let car = UIImage(named: "car")
        let carIcon = car?.resizeImage(CGSize(width: 25, height: 25))
        let icon: UIImageView = {
            let i = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
            i.image = carIcon
            return i
        }()
        marker.groundAnchor = CGPoint(x: 0.25, y: 0.5)
        marker.isFlat = true
        marker.iconView = icon
         marker.map = mapView
         userMarker = marker
     }
        
        func updateMarkerWith(position: CLLocationCoordinate2D, angle: Double) {
            if userMarker != nil {
                CATransaction.begin()
                CATransaction.setAnimationDuration(2.0)
                userMarker.position = position
                
                guard angle >= 0 && angle < 360 else {
                    return
                }
                let angleInRadians: CGFloat = CGFloat(angle) * .pi / CGFloat(180)
                userMarker.iconView?.transform = CGAffineTransform.identity.rotated(by: angleInRadians)
                CATransaction.commit()
            }
            
        }
    

}

extension MapsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        let point = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                           longitude: location.coordinate.longitude)
        updateMarkerWith(position: point, angle: location.course)
        CATransaction.begin()
        CATransaction.setAnimationDuration(5.0)
        mapView.animate(toLocation: point)
        mapView.animate(toBearing: location.course)
        CATransaction.commit()
    }
    
}
