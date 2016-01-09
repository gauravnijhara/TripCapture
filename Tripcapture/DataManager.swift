//
//  DataManager.swift
//  Tripcapture
//
//  Created by Gaurav Nijhara on 12/29/15.
//  Copyright © 2015 Gaurav Nijhara. All rights reserved.
//

import UIKit
import CoreLocation
import Parse

public func roundoff(num:Double) -> Double
{
    return floor(num * Double(1000)) / Double(1000);
}

class DataManager: NSObject {

    static let sharedInstance = DataManager()
    var trips:[TripData]?
    var currentTrip:TripData?
    
    
    var location:CLLocation? = nil;
    
    private override init() {
        
        super.init();
        
        
    }

    func addImage(image:UIImage , forLocation location:String , withCoordinates coordinates:CLLocationCoordinate2D) -> Void
    {
       
        var existingLocation:PFGeoPoint?;
        
        if self.currentTrip!.locations != nil
        {
            for object in self.currentTrip!.locations! where object is PFGeoPoint
            {
                if roundoff(object.latitude) == roundoff(coordinates.latitude) && roundoff(object.longitude) == roundoff(coordinates.longitude)
                {
                    existingLocation = object as? PFGeoPoint;
                }
            }
        }
        
        if let foundLocation = existingLocation
        {
            // loc accuracy 50 meters
            let locationQuery:PFQuery = PFQuery(className: "Location");
            locationQuery.whereKey("coordinate", nearGeoPoint: PFGeoPoint(latitude: foundLocation.latitude, longitude: foundLocation.longitude), withinKilometers: 0.02);
            locationQuery.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                
                let location:PFObject = objects![0];
                let filename:String =   "\(NSDate.timeIntervalSinceReferenceDate())" + ".png";
                
                let imageData:NSData = UIImagePNGRepresentation(image)!;
                let imageFile:PFFile = PFFile(name: filename, data: imageData)!;
                imageFile.saveInBackgroundWithBlock({ (success, error) -> Void in
                    
                    var captures = (location.objectForKey("captures") as! [AnyObject])
                    captures.append(imageFile);
                    
                    location.setObject(captures, forKey: "captures");
                    location.saveInBackgroundWithBlock({ (success, error) -> Void in
                        
                    })
                    
                    }, progressBlock: { (progress:Int32) -> Void in
                        
                        // do something kewl here
                        
                })
                
            })
            
        }else {
            
            let newLocation = PFObject(className:"Location")
            newLocation["createdBy"] = self.currentTrip?.parseObject;
            
            let filename:String =   "\(NSDate.timeIntervalSinceReferenceDate())" + ".png";
            let imageData:NSData = UIImagePNGRepresentation(image)!;
            let imageFile:PFFile = PFFile(name: filename, data: imageData)!;
            imageFile.saveInBackgroundWithBlock({ (success, error) -> Void in
                
                var captures:[AnyObject]? = (newLocation.objectForKey("captures") as? [AnyObject])
                
                if captures == nil
                {
                    captures = [AnyObject]();
                }
                
                captures!.append(imageFile);
                
                newLocation.setObject(captures!, forKey: "captures");
                newLocation.setObject(PFGeoPoint(latitude: coordinates.latitude, longitude: coordinates.longitude), forKey: "coordinate");
                newLocation.saveInBackgroundWithBlock({ (success, error) -> Void in
                    
                    var locations:[AnyObject]? = self.currentTrip?.parseObject?.objectForKey("locations") as? [AnyObject]
                    
                    if locations == nil
                    {
                        locations = [AnyObject]();
                    }
                    
                    locations!.append(PFGeoPoint(latitude: coordinates.latitude, longitude: coordinates.longitude));
                    self.currentTrip?.parseObject?.setObject(locations!, forKey: "locations");
                    self.currentTrip?.parseObject?.saveInBackgroundWithBlock({ (success, error) -> Void in
                         // success here
                    })
                })
                }, progressBlock: { (progress:Int32) -> Void in
                    
                    // do something kewl here
                    
            })


        }
        
    }
    
    
    func createNewTrip(name:String, completionBlock: (Bool, NSError?) -> Void) -> Void
    {
        let newTrip = PFObject(className:"Trip")
        newTrip["name"] = name
        newTrip["createdBy"] = PFUser.currentUser()

        newTrip.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            
            completionBlock(success,error);
            
        }
    }
    
    func fetchTrips(completion: ([TripData]?) -> Void) -> Void
    {
        let tripsQuery = PFQuery(className:"Trip")
        if let user = PFUser.currentUser() {
            tripsQuery.whereKey("createdBy", equalTo: user)
            tripsQuery.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                
                if objects == nil
                {
                    completion(nil);
                }
                else
                {
                    var trips:[TripData] = [];
                    for item in objects!
                    {
                        let trip:TripData = TripData();
                        trip.tripName = item.objectForKey("name") as? String;
                        trip.locations = item.objectForKey("locations") as? NSArray
                        trip.parseObject = item;
                        trips.append(trip);
                    }
                    
                    completion(trips)
                    
                    self.trips = trips
                    
                }
            })
        }
    }
    
}
