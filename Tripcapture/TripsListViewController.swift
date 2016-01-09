//
//  TripsListViewController.swift
//  Tripcapture
//
//  Created by Gaurav Nijhara on 1/1/16.
//  Copyright © 2016 Gaurav Nijhara. All rights reserved.
//

import UIKit

class TripsListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var trips:[TripData]?
    
    @IBOutlet weak var tripsList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // data manager to load and display trips
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        DataManager.sharedInstance.fetchTrips { (trips:[TripData]?) -> Void in
            
            self.trips = trips
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tripsList.reloadData();
            })
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView();
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let trips = self.trips
        {
            return (trips.count);
        }
        else
        {
            return 0;
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("basicCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = trips![indexPath.row].tripName;
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        DataManager.sharedInstance.currentTrip = self.trips![indexPath.row];
        
        let rootTabBar:UIViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("rootTabBarVC")
        self.presentViewController(rootTabBar, animated:true, completion: nil);
        
    }
    
    @IBAction func addNewTripPressed(sender: AnyObject) {
        
        self.performSegueWithIdentifier("onboarding_createnewTrip", sender: self);
        
    }

}
