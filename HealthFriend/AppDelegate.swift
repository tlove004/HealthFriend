//
//  AppDelegate.swift
//  HealthFriend
//
//  Created by Tyson Loveless on 2/18/17.
//  Copyright © 2017 Tyson Loveless. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import YelpAPI

let myID = "KQOW6wvZOhPFO-uu2d4-QQ"
let mySecret = "M9KAYPJipfuGjMKRV3yb4nyciPrmNDavFBRYRsCXSDxDpYzK86hVDShEK1ozIELi"

//let coords = YLPCoordinate(latitude: 33.6908934, longitude: -117.34151800000001)
var blacklist: [String]!// = ["hotdogs"] //hotdogs == yelp's "fast food" category

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    lazy var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.pausesLocationUpdatesAutomatically = false
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = true
        manager.requestAlwaysAuthorization()
        manager.distanceFilter = 10
        return manager
    }()
    
    
    var query: YLPQuery!
    
    var coords: YLPCoordinate!
    
    //var lastNotificationDate = NSDate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            self.locationManager.startUpdatingLocation()
            print("OK")
        }
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Do something interesting.
        
        print("location updated")
        
        blacklist = UserDefaults.standard.array(forKey: "blacklist") as! [String]!
        
        self.coords = YLPCoordinate(latitude: (locations.last?.coordinate.latitude)!, longitude: (locations.last?.coordinate.longitude)!)
        
        YLPClient.authorize(withAppId: myID, secret: mySecret, completionHandler: { (client, error) -> Void in
            //print(client!)
            
            self.query = YLPQuery.init(coordinate: self.coords)
            
//            var cat = YLPCategory.name
            var filter: [String] = []
//            self.query.term = "Fast\\ Food"
            for i in blacklist {
                switch i {
                case "Fast Food":
                    filter.append("hotdogs")
                    break
                case "Ice Cream":
                    filter.append("icecream")
                    break
                case "Liquor Store":
                    filter.append("beer_and_wine")
                default:
                    //filter.append(i)
                    print("cannot add \(i)")
                }
            }
            
            self.query.categoryFilter = filter
            self.query.radiusFilter = 30.0 //proximity
            self.query.limit = 5 //num of results to return
            self.query.offset = 0 //offset - no idea what this does
            self.query.sort = .distance
            
            client?.search(with: self.query, completionHandler: { (ylpSearch, searchError) in
                let num = ylpSearch?.businesses.count
                var cat: String!
                let notif = UNMutableNotificationContent()
                
                
                if num != 0 && num != nil {
                    for i in 0...num!-1 {
                        print(ylpSearch!.businesses[i].name)
                        if (ylpSearch!.businesses[i].categories.count > 0) {
                            for j in 0...ylpSearch!.businesses[i].categories.count-1 {
                                cat = ylpSearch!.businesses[i].categories[j].alias
                                //print("name:", ylpSearch!.businesses[i].categories[j].alias)
                                if filter.contains(cat) {
                                    notif.title = "Hey - you're in \(ylpSearch!.businesses[i].name)!"
                                    notif.body = "Didn't you say you wanted to avoid \(ylpSearch!.businesses[i].categories[j].name)?"
                                    
                                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                    
                                    let id = "UYLocalNotification"
                                    let request = UNNotificationRequest(identifier: id, content: notif, trigger: trigger)
                                    UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                                        if error != nil {
                                            print(error.debugDescription)
                                        }
                                    })
                                    print("notify: you are in", cat)
                                }
                            }
                        }
                    }
                }
                let err = searchError?.localizedDescription
                if err != nil {
                    print(err ?? "unknown")
                }
            })
        })
        
    }
    
    func handle(withNotification notification: Notification) {
        print("Received: ", notification.name.rawValue)
    }
    
    func handleNotification(notification: Notification) -> Void {
        print("handling")
        guard let userInfo = notification.userInfo,
            let message = userInfo["category"] as? String else {
                print("NO userInfo found in notification")
                return
        }
        //NotificationCenter.default.post
        let alert = UIAlertController(title: "Notification!", message: "\(message) received", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//self.present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UserDefaults.standard.synchronize()
        
        locationManager.startUpdatingLocation()
        
        
      //  self.coords = YLPCoordinate(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        
        //updateCoordinates()
        //search Yelp using coordinates 
        //if yelp result has categories in blacklist within 10 yard radius
            // then check if inside blacklisted category
            // if in blacklisted category
                //then notify user
            // else return
        //
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UserDefaults.standard.synchronize()
        locationManager.stopUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }


}

