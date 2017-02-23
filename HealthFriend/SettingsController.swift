//
//  SettingsController.swift
//  HealthFriend
//
//  Created by Tyson Loveless on 2/18/17.
//  Copyright © 2017 Tyson Loveless. All rights reserved.
//

import UIKit
import CoreLocation

class SettingsController : ViewController, CLLocationManagerDelegate {

    private var suggestions: Bool = false
    
    @IBOutlet var SelectedCats: UIButton!
    @IBOutlet var MYProximity: UIButton!
    @IBOutlet var NotificationMode: UIButton!
    @IBOutlet var AlternativeSuggestionsOption: UIButton!
    
    @IBOutlet var SaveButton: UIButton!
//
//    var termsAccepted = UserDefaults.standard.bool(forKey: "termsAccepted")
//    var hasSetup = UserDefaults.standard.bool(forKey: "hasSetup")
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        SelectedCats.contentHorizontalAlignment = .center
//        NotificationMode.contentHorizontalAlignment = .center
//        MYProximity.contentHorizontalAlignment = .center
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    

    @IBAction func SaveSettings() {
        //TODO: check if everything has been setup
        
        print("terms accepted: ", UserDefaults.standard.bool(forKey: "termsAccepted"))
        if !(UserDefaults.standard.bool(forKey: "termsAccepted")) {
            let alert = UIAlertController(title: "Accept Terms", message: "Click 'Accept' to agree to our Terms of Use", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
                let seriously = UIAlertController(title: "Seriously", message: "Accept the damn terms!", preferredStyle: UIAlertControllerStyle.alert)
                seriously.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { action in
                    let fineThen = UIAlertController(title: "Alright Then", message: "We cannot help you.", preferredStyle: UIAlertControllerStyle.alert)
                    fineThen.addAction(UIAlertAction(title: "Bye", style: UIAlertActionStyle.cancel, handler: nil))
                    fineThen.addAction(UIAlertAction(title: "Fine, I accept them", style: UIAlertActionStyle.destructive, handler: { action in
                        UserDefaults.standard.set(true, forKey: "termsAccepted")
                        UserDefaults.standard.synchronize()
                    }))
                    self.present(fineThen, animated: true, completion: nil)
                }))
                seriously.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.destructive, handler: { action in
                    UserDefaults.standard.set(true, forKey: "termsAccepted")
                    UserDefaults.standard.synchronize()
                }))
                self.present(seriously, animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default, handler: { action in
                UserDefaults.standard.set(true, forKey: "termsAccepted")
                UserDefaults.standard.synchronize()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            locationManager.requestAlwaysAuthorization()
        }
        
        if UserDefaults.standard.bool(forKey: "termsAccepted") && CLLocationManager.authorizationStatus() != .authorizedAlways {
            locationManager.requestAlwaysAuthorization()
            let alert = UIAlertController(title: "Turn on Location Services", message: "This app is useless without location services enabled.  Please go to settings and enable location services (allow in background) for this application.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No thanks", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.destructive, handler: { action in
                if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(appSettings as URL)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            if CLLocationManager.authorizationStatus() != .authorizedAlways {
                UserDefaults.standard.set(false, forKey: "hasSetup")
                UserDefaults.standard.synchronize()
                print(UserDefaults.standard.bool(forKey: "hasSetup"))
                print("123")
            }
            else {
                UserDefaults.standard.set(true, forKey: "hasSetup")
                print(UserDefaults.standard.bool(forKey: "hasSetup"))
                print("456")
                print(UserDefaults.standard.bool(forKey: "termsAccepted"))
            }
        }
        print("hasSetup: ", UserDefaults.standard.bool(forKey: "hasSetup"))
        print("789")
        print("termsAccepted: ", UserDefaults.standard.bool(forKey: "termsAccepted"))
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    print("access granted")
                    UserDefaults.standard.set(true, forKey: "hasSetup")
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
    
    @IBAction func notifButtonPressed() {
        let alert = UIAlertController(title: "Select Mode", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Moderate", style: UIAlertActionStyle.default, handler: updateNotificationsMode ))
        alert.addAction(UIAlertAction(title: "Extreme", style: UIAlertActionStyle.default, handler: updateNotificationsMode ))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateNotificationsMode(action: UIAlertAction) {
        NotificationMode.setTitle(action.title, for: .normal)
    }

    @IBAction func proxButtonPressed() {
        let alert = UIAlertController(title: "Proximity", message: "Enter how close to an establishment you want to be before being notified:", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.text = self.MYProximity.currentTitle
            textField.selectAll(Any?.self)
        }
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] as UITextField
            self.MYProximity.setTitle(textField.text, for: .normal)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func altButtonPressed() {
        if AlternativeSuggestionsOption.currentTitle! == "Disabled" {
            AlternativeSuggestionsOption.setTitle("Enabled", for: .normal)
            suggestions = true
        }
        else {
            AlternativeSuggestionsOption.setTitle("Disabled", for: .normal)
        }
    }
    
    
}
