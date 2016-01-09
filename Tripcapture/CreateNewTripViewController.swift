//
//  CreateNewTripViewController.swift
//  Tripcapture
//
//  Created by Gaurav Nijhara on 1/1/16.
//  Copyright © 2016 Gaurav Nijhara. All rights reserved.
//

import UIKit

class CreateNewTripViewController: UIViewController , UITextFieldDelegate{

    
    @IBOutlet weak var tripName: UITextField!
    
    @IBAction func createTripPressed(sender: AnyObject) {
        
        //data manager please create a trip
        DataManager.sharedInstance.createNewTrip(tripName.text!) { (success:Bool, error:NSError?) -> Void in
            
            if success == true
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.navigationController?.popViewControllerAnimated(true);
                })
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder();
        
        return true;
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.tripName.resignFirstResponder();
    }
}
