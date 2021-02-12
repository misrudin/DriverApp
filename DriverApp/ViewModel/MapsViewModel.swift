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
    
    func createMarker(position: CLLocationCoordinate2D, title: String? = "")-> GMSMarker?{
        let destinationMarker = GMSMarker()
        destinationMarker.position = position
        destinationMarker.title = title
        return destinationMarker
    }
    
    func zoomTo(marker: GMSMarker)-> GMSCameraPosition{
        //        let camera = GMSCameraPosition(target: marker.position, zoom: 10)
        let camera = GMSCameraPosition(target: marker.position, zoom: 14, bearing: 0, viewingAngle: 50)
        return camera
    }
    
    
    func getDistance(origin: Origin, destination: Destination, completion: @escaping (Result<DistanceData, Error>)-> Void){
        let url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=\(origin.latitude),\(origin.longitude)&destinations=\(destination.latitude),\(destination.longitude)&key=\(Base.mapsApiKeyEta)"
        
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
                    let numberOfPlaces = 2.0
                    let multiplier = pow(10.0, numberOfPlaces)
                    let distanceRound = round(distanceValue!/1000 * multiplier) / multiplier
                    let distanceString = "(\(distanceRound) km)"
                    
                    
                    let duration = element["duration"].dictionary
                    let durationValue = duration?["value"]?.int
                    let (h, m, _) = Helpers().secondsToHoursMinutesSeconds(seconds: durationValue!)
                    var durationString = ""
                    if h != 0 {
                        durationString = "\(h) hour \(m) min"
                    }else {
                        durationString = "\(m) min"
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
    
    
    func getDotsToDrawRoute(positions : [CLLocationCoordinate2D], titles: [String], completion: @escaping(_ markers: [GMSMarker]?, _ polylines: [GMSPolyline]?) -> Void) {
        if positions.count > 1 {
            var markers = [GMSMarker]()
            var polylines = [GMSPolyline]()
            var titikA: CLLocationCoordinate2D!
            var titikB: CLLocationCoordinate2D!
            
            
            _ = positions.enumerated().map { i, position in
                markers.append(createMarker(position: position, title: titles[i])!)
                if(i < positions.count - 1) {
                    titikB = positions[i+1]
                    titikA = position
                    drawPolyline(origin: titikA, destination: titikB) { p in
                        polylines.append(p!)
                        completion(markers, polylines)
                    }
                }else {
                    titikB = positions[positions.count-1]
                    drawPolyline(origin: titikA, destination: titikB) { p in
                        polylines.append(p!)
                        completion(markers, polylines)
                    }
                }
            }
        }else{
            let origin = positions.first
            var markers = [GMSMarker]()
            markers.append(createMarker(position: origin!)!)
            completion(markers, nil)
        }
    }
    
    
    
    
    private func drawPolyline(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completion: @escaping(_ polyline: GMSPolyline?)-> Void){
        
        let request = "https://maps.googleapis.com/maps/api/directions/json"
        let parameters : [String : String] = ["origin" : "\(origin.latitude),\(origin.longitude)", "destination" : "\(destination.latitude),\(destination.longitude)", "key" : Base.mapsApiKey]
        
        AF.request(request, method: .get, parameters: parameters).responseJSON { (response) in
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
                    polyline.strokeWidth = 4
                    
                    completion(polyline)
                }
                
            }catch let error {
                completion(nil)
                print(error.localizedDescription)
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
    
    
    extension GMSMutablePath {
        func appendPath(path : GMSPath?) {
            if let path = path {
                for i in 0..<path.count() {
                    self.add(path.coordinate(at: i))
                }
            }
        }
    }


class CustomMarker: GMSMarker {

    var label: UILabel!

    init(labelText: String) {
        super.init()

        let iconView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height:     80)))
        iconView.backgroundColor = .white

        label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width:     iconView.bounds.width, height: 40)))
        label.text = labelText
        iconView.addSubview(label)

        self.iconView = iconView
    }
}
