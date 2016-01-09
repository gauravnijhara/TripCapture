//
//  AppDelegate.swift
//  Tripcapture
//
//  Created by Gaurav Nijhara on 12/26/15.
//  Copyright © 2015 Gaurav Nijhara. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.setApplicationId("XKceBMFjYIQM0yPrePJI2s1GAwBEyl8TgCx7X2ru",
            clientKey: "N988y8vk5L8YJ8vUfdgZ4DEm1x1ikRDWBPnfyCBM")

        //fetch init location or permissions if not allowed
        LocationManager.sharedInstance.getCurrentLocation();
        
//        self.window = [[UIWindow alloc]
//            initWithFrame:[[UIScreen mainScreen] bounds]];
//        // Override point for customization after application launch.
//        self.window.backgroundColor = [UIColor whiteColor];
//        [self.window makeKeyAndVisible];
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds);
        self.window?.backgroundColor = UIColor.whiteColor();
        
        if NSUserDefaults.standardUserDefaults().integerForKey("loginFirstTime") == 0
        {
            // do onboarding
            self.window?.rootViewController = UIStoryboard(name:"Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("onboardingNavVC");
        }
        else
        {
            // launch app with logged in user
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("rootTabBarVC");

        }
        
        self.window?.makeKeyAndVisible();
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions);
        
        return true;
        
        
    }

    func application(application: UIApplication,openURL url: NSURL,sourceApplication: String?,annotation: AnyObject?) -> Bool {
            
        return FBSDKApplicationDelegate.sharedInstance().application(application,openURL: url,sourceApplication: sourceApplication,annotation: annotation);
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

