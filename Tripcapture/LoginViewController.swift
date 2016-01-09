//
//  LoginViewController.swift
//  Tripcapture
//
//  Created by Gaurav Nijhara on 1/1/16.
//  Copyright © 2016 Gaurav Nijhara. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import ParseFacebookUtilsV4

class LoginViewController: UIViewController {

    @IBOutlet weak var fbLoginButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // hack - change it
            self.performSegueWithIdentifier("onboarding_Trips" , sender: self);

        }
    }
    
    @IBAction func fbLoginButtonPressed(sender: AnyObject) {
        
        
        if (FBSDKAccessToken.currentAccessToken() == nil)
        {
            let loginManager:FBSDKLoginManager =  FBSDKLoginManager();
            
            loginManager.logInWithReadPermissions(["public_profile","email","user_friends"], fromViewController:self , handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
                
                if error != nil {
                    
                    loginManager.logOut()
                    
                } else if result.isCancelled {
                    // Handle cancellations
                    loginManager.logOut()
                    
                } else {
                    
                    
                    PFAnonymousUtils.logInWithBlock {
                        (user: PFUser?, error: NSError?) -> Void in
                        if error != nil || user == nil {
                            print("Anonymous login failed.")
                        } else {
                            print("Anonymous user logged in.")
                            
                            if !PFFacebookUtils.isLinkedWithUser(user!) {
                                PFFacebookUtils.linkUserInBackground(user!, withReadPermissions:["public_profile","email","user_friends"], block: {
                                    (succeeded: Bool?, error: NSError?) -> Void in
                                    if (succeeded != nil) {
                                        print("Woohoo, the user is linked with Facebook!")
                                        
                                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                            self.performSegueWithIdentifier("onboarding_Trips" , sender: self);
                                        };
                                    }
                                })
                            }
                        }
                    }

                }
            })
        }

    }
}
