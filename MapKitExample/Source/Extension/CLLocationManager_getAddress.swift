//
//  MapKit_getAddress.swift
//  IOS2-MapKit
//
//  Created by Daniel Carvalho on 2022-02-13.
//

import Foundation
import MapKit



extension CLLocationManager {
    
    
    func getAddress(from coordinate: CLLocationCoordinate2D,
                    successHandler: @escaping (_ address : String, _ city : String) -> Void,
                    failHandler: @escaping () -> Void) {
        
       
            let geoCoder = CLGeocoder()
            let location = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
     
        
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                // check for errors
                guard let placeMarkArr = placemarks else {
                    failHandler()
                    return
                }
                // check placemark data existence
                
                guard let placemark = placeMarkArr.first, !placeMarkArr.isEmpty else {
                    failHandler()
                    return
                }
                // create address string
                
                let address = "\(placemark.subThoroughfare ?? "") \(placemark.thoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.country ?? "") - \(placemark.postalCode ?? "")"
                
                let city = placemark.locality ?? ""
                
                successHandler(address, city)
                
            })
        }

    
}
	
