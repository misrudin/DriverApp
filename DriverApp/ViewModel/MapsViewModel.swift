//
//  MapsViewModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 18/10/20.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON

protocol MapsViewModelDelegate {
    func didDrawDirection(_ viewModel: MapsViewModel,
                          direction: GMSPolyline,
                          markerOrigin: GMSMarker,
                          markerDestination: GMSMarker,
                          camera: GMSCameraPosition)
    func didFailedDrawDirection(_ error: Error)
}

struct MapsViewModel {
    
    var delegate: MapsViewModelDelegate?
    
    func drawDirection(direction: DirectionData){
        
        let origin = "\(direction.origin.latitude),\(direction.origin.longitude)"
        let destination = "\(direction.destination.latitude),\(direction.destination.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=\(Base.mapsApiKey)"
        
        AF.request(url).responseJSON { (response) in
            guard let data = response.data else {return}
            
            do {
                let jsonData = try JSON(data: data)
                let routes = jsonData["routes"].arrayValue
                
                for route in routes {
                    let overview_polyline = route["overview_polyline"].dictionary
                    let points = overview_polyline?["points"]?.string
                    let path = GMSPath.init(fromEncodedPath: points ?? "")
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeColor = .systemRed
                    polyline.strokeWidth = 5
                    
                    
                    guard let markerOrigin: GMSMarker = createMarkerOrigin(origin: direction.origin),
                          let markerDestination: GMSMarker = createMarkerDestination(destination: direction.destination) else {
                        return
                    }
                    
                    let camera: GMSCameraPosition = zoomTo(marker: markerOrigin)
                    
                    delegate?.didDrawDirection(self,
                                               direction: polyline,
                                               markerOrigin: markerOrigin,
                                               markerDestination: markerDestination, camera: camera)}
                
            }catch let error {
                delegate?.didFailedDrawDirection(error)
                print(error.localizedDescription)
            }
        }
    }
    
    
    func createMarkerOrigin(origin: Origin)-> GMSMarker?{
        let originMarker = GMSMarker()
        originMarker.position = CLLocationCoordinate2D(latitude: origin.latitude, longitude: origin.longitude)
        originMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        let car = UIImage(named: "car")
        let carIcon = car?.resizeImage(CGSize(width: 25, height: 25))
        originMarker.icon = carIcon
        originMarker.isFlat = true
        return originMarker
    }
    
    func createMarkerDestination(destination: Destination)-> GMSMarker?{
        let destinationMarker = GMSMarker()
        destinationMarker.position = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
        return destinationMarker
    }
    
    func zoomTo(marker: GMSMarker)-> GMSCameraPosition{
//        let camera = GMSCameraPosition(target: marker.position, zoom: 10)
        let camera = GMSCameraPosition(target: marker.position, zoom: 14, bearing: 0, viewingAngle: 50)
        return camera
    }
    
    
    func getDistance(origin: Origin, destination: Destination, completion: @escaping (Result<DistanceData, Error>)-> Void){
        let url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=\(origin.latitude),\(origin.longitude)&destinations=\(destination.latitude),\(destination.longitude)&key=\(Base.mapsApiKey)"
        
        AF.request(url).responseJSON { (response) in
            guard let data = response.data else {return}
            
            do {
                let jsonData = try JSON(data: data)
                let rows = jsonData["rows"].arrayValue
                let element = rows[0]["elements"].arrayValue[0]
                print(element["status"])
                
                if element["status"] == "OK" {
                    let distance = element["distance"].dictionary
                    let distanceValue = distance?["value"]?.double
                    let distanceString = "\(Double(distanceValue!/1000)) KM"
                    
                    
                    let duration = element["duration"].dictionary
                    let durationValue = duration?["value"]?.int
                    let (h, m, _) = Helpers().secondsToHoursMinutesSeconds(seconds: durationValue!)
                    var durationString = ""
                    if h != 0 {
                        durationString = "\(h) Hour \(m) Minutes"
                    }else {
                        durationString = "\(m) Minutes"
                    }
                    
                    let data = DistanceData(time: durationString, distance: distanceString)
                    completion(.success(data))
                }else {
                    let status = element["status"].string
                    completion(.failure(MapsError.noResult(status ?? "Result not found!")))
                }
            
            }catch let error {
                completion(.failure(error))
            }
        }
    }
    
    
}



enum MapsError: Error{
    case failedToFetch(_ message: String)
    case failedToParseJson
    case noResult(_ message: String)
}

extension MapsError: LocalizedError {
    var errorDescription: String? {
        switch self {
        
        case .failedToFetch(let message):
            return NSLocalizedString(
                message,
                comment: ""
            )
        case .failedToParseJson:
            return NSLocalizedString(
                "Failed to parse data".localiz(),
                comment: ""
            )
        case .noResult(let message):
            return NSLocalizedString(
                message,
                comment: ""
            )
        }
    }
}
