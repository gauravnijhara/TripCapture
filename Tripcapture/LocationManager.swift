//
//  LocationManager.swift
//  Tripcapture
//
//  Created by Gaurav Nijhara on 12/26/15.
//  Copyright © 2015 Gaurav Nijhara. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject,CLLocationManagerDelegate  {
    
    static let sharedInstance = LocationManager()
    private let manager = CLLocationManager()
    var location:CLLocation? = nil;
    
    private override init() {
    
        super.init();
        
        manager.delegate = self;
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestWhenInUseAuthorization()
        } 
    } 

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status:CLAuthorizationStatus)
    {
        if status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }

    func isAuthorized() -> Bool
    {
        return CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse;
    }
    
    func getCurrentLocation()
    {
        manager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let myLocation:CLLocation = locations[0]
        {
            self.location = myLocation;
            
        }
        manager.stopUpdatingLocation();
    }
    
}
