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
    
    private var cats = ""
    private var prox = ""
    private var mode = ""
    private var suggestions: Bool = false
    
    @IBOutlet var SelectedCats: UIButton!
    @IBOutlet var MYProximity: UIButton!
    @IBOutlet var NotificationMode: UIButton!
    @IBOutlet var AlternativeSuggestionsOption: UIButton!
    
    @IBOutlet var SaveButton: UIButton!
    
    let termsAccepted = UserDefaults.standard.bool(forKey: "termsAccepted")
    let hasSetup = UserDefaults.standard.bool(forKey: "hasSetup")
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SelectedCats.contentHorizontalAlignment = .center
        SelectedCats.titleLabel?.textAlignment = .center
        NotificationMode.contentHorizontalAlignment = .center
        NotificationMode.titleLabel?.textAlignment = .center
        MYProximity.contentHorizontalAlignment = .center
        MYProximity.titleLabel?.textAlignment = .center
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        SelectedCats.titleLabel?.adjustsFontSizeToFitWidth = true
        MYProximity.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    

    @IBAction func SaveSettings() {
        //TODO: check if everything has been setup
        
        if !termsAccepted {
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
        locationManager.requestAlwaysAuthorization()
        
        if termsAccepted && CLLocationManager.authorizationStatus() != .authorizedAlways {            let alert = UIAlertController(title: "Turn on Location Services", message: "This app is useless without location services enabled.  Please go to settings and enable location services (allow in background) for this application.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No thanks", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.destructive, handler: { action in
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
                print(hasSetup)
                print("here")
            }
            else {
                print(hasSetup)
            }
        }
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
        NotificationMode.titleLabel?.text = action.title
    }

    @IBAction func proxButtonPressed() {
        let alert = UIAlertController(title: "Proximity", message: "Enter how close to an establishment you want to be before being notified:", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.text = self.MYProximity.titleLabel!.text
        }
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] as UITextField
            self.MYProximity.titleLabel?.text = textField.text!
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
