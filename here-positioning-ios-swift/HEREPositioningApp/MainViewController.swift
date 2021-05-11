/*
 * Copyright (c) 2011-2020 HERE Europe B.V.
 * All rights reserved.
 */

import UIKit
import NMAKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: NMAMapView!
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var nameTextFiled: UITextField!

    var locationManager: CLLocationManager!

    class Defaults {
        static let latitude = 61.494713
        static let longitude = 23.775360
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change data source to HERE position data source
        NMAPositioningManager.sharedInstance().dataSource = NMAHEREPositionSource()
        NMAPositioningManager.sharedInstance().dataSource?.setBackgroundUpdatesEnabled?(true)
        
        
        // Set initial position
        let geoCoodCenter = NMAGeoCoordinates(latitude: Defaults.latitude,
                                              longitude: Defaults.longitude)
        mapView.set(geoCenter: geoCoodCenter, animation: .none)
        mapView.copyrightLogoPosition = .center
        
        // Set zoom level
        mapView.zoomLevel = NMAMapViewMaximumZoomLevel - 1
        
        // Subscribe to position updates
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MainViewController.didUpdatePosition),
                                               name: NSNotification.Name.NMAPositioningManagerDidUpdatePosition,
                                               object: NMAPositioningManager.sharedInstance())
        
        // Set position indicator visible. Also starts position updates.
        mapView.positionIndicator.isVisible = true
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.sendLocationToServer(latitude: center.latitude, longitude: center.longitude)

        
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//        self.map.setRegion(region, animated: true)
    }


    @objc func didUpdatePosition() {
        guard let position = NMAPositioningManager.sharedInstance().currentPosition,
              let coordinates = position.coordinates else {
            return
        }

//        self.sendLocationToServer(latitude: coordinates.latitude, longitude: coordinates.longitude)
        // Update label text based on received position.
        var text = " Type: \(position.source == NMAGeoPositionSource.indoor ? "Indoor" : position.source == NMAGeoPositionSource.systemLocation ? "System" : "Unknown")\n"
                   + "Coordinate: \(coordinates.latitude), \(coordinates.longitude)\n"
                   + "Altitude: \(coordinates.latitude)\n"

        if let buildingName = position.buildingName, let buildingId = position.buildingId {
            text += "Building: \(buildingName) \(buildingId)\n"
        }

        if let floorId = position.floorId {
            text += "Floor: \(floorId)"
        }

        label.text = text

        // Update position indicator position.
        mapView.set(geoCenter: coordinates, animation: .linear)
    }
    
    func sendLocationToServer(latitude: Double, longitude: Double) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        let session = URLSession(configuration: configuration)
        
        let url = URL(string: "https://staging-api.pickups.mobi/location/or1.0/v1/location/post")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")


		let parameters = ["name" : nameTextFiled.text ?? "-",
                          "latitude" : latitude,
                          "longitude" : longitude,
                          "os" : "iOS - \(UIDevice.current.systemVersion)",
                          "device" : UIDevice.current.name] as [String : Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Oops!! there is server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("response is not json")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("The Response is : ",json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
        })
        
        task.resume()
    }
    
}
