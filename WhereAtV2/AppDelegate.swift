//
//  AppDelegate.swift
//  WhereAtV2
//
//  Created by Katia Hajjar on 3/31/17.
//  Copyright © 2017 Katia Hajjar. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?

    var locationManager : CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    var placemark: CLPlacemark!
    var locationArray: NSArray!
    var locationObj: CLLocation!
//    var tabBarController = UITabBarController()
    var tabBarController: UITabBarController?
    var username : String!
    var password : String!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initLocationManager();
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarTest") as! UITabBarController
    
        if (username == nil || password == nil) {
            //user not logged in
            let loginViewController = ViewController()
            self.window?.rootViewController?.present(loginViewController, animated: false, completion: nil)
        }
 
        

        return true
    }

    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
                        //locationManager.startUpdatingHeading()
        }
        
//        locationManager.requestAlwaysAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
            if (seenError == false) {
                seenError = true
                print(error)
            }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            
            
            
            
            CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
                
                if (error != nil) {
                    print("Reverse geocoder failed with error")
                    return
                }
                
                if (placemarks?.count)! > 0 {
                    let pm = placemarks?[0]
                    self.placemark = pm
                } else {
                    print("Problem with the data received from geocoder")
                }
            })

            locationArray = locations as NSArray
            locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            
            print(coord.latitude)
            print(coord.longitude)
        }
    }
    
    
   
    
//    
//    private func locationManager(manager: CLLocationManager!,
//                         didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        var shouldIAllow = false
//        
//        switch status {
//        case CLAuthorizationStatus.restricted:
//            locationStatus = "Restricted Access to location"
//        case CLAuthorizationStatus.denied:
//            locationStatus = "User denied access to location"
//        case CLAuthorizationStatus.notDetermined:
//            locationStatus = "Status not determined"
//        default:
//            
//            locationStatus = "Allowed to location Access"
//            shouldIAllow = true
//        }
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LabelHasbeenUpdated"), object: nil)
//        if (shouldIAllow == true) {
//            NSLog("Location to Allowed")
//            // Start location services
//            locationManager.startUpdatingLocation()
//        } else {
//            NSLog("Denied access: \(locationStatus)")
//        }
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
//        if let tbc : UITabBarController = self.window!.rootViewController as? UITabBarController{
//            let myVc = tbc.viewControllers![1]
//        }

        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
 
    


}

