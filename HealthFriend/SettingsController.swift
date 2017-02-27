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
    
    private var terms: String = "1. Terms\n    By accessing this web site, you are agreeing to be bound by these web site Terms and Conditions of Use, all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws. If you do not agree with any of these terms, you are prohibited from using or accessing this site. The materials contained in this web site are protected by applicable copyright and trade mark law.    \n2. Use License\n    Permission is granted to temporarily download one copy of the materials (information or software) on HelpFool's web site for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:\n    modify or copy the materials; \nuse the materials for any commercial purpose, or for any public display (commercial or non-commercial); attempt to decompile or reverse engineer any software contained on HelpFool's web site; \n remove any copyright or other proprietary notations from the materials; or \n transfer the materials to another person or \"mirror\" the materials on any other server.\nThis license shall automatically terminate if you violate any of these restrictions and may be terminated by HelpFool at any time. Upon terminating your viewing of these materials or upon the termination of this license, you must destroy any downloaded materials in your possession whether in electronic or printed format.\n3. Disclaimer\n\nThe materials on HelpFool's web site are provided \"as is\". HelpFool makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties, including without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights. Further, HelpFool does not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of the materials on its Internet web site or otherwise relating to such materials or on any sites linked to this site.\n    4. Limitations\n\nIn no event shall HelpFool or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption,) arising out of the use or inability to use the materials on HelpFool's Internet site, even if HelpFool or a HelpFool authorized representative has been notified orally or in writing of the possibility of such damage. Because some jurisdictions do not allow limitations on implied warranties, or limitations of liability for consequential or incidental damages, these limitations may not apply to you.\n\n5. Revisions and Errata \n\nThe materials appearing on HelpFool's web site could include technical, typographical, or photographic errors. HelpFool does not warrant that any of the materials on its web site are accurate, complete, or current. HelpFool may make changes to the materials contained on its web site at any time without notice. HelpFool does not, however, make any commitment to update the materials.\n\n6. Links\n\nHelpFool has not reviewed all of the sites linked to its Internet web site and is not responsible for the contents of any such linked site. The inclusion of any link does not imply endorsement by HelpFool of the site. Use of any such linked web site is at the user's own risk.\n\n    7. Site Terms of Use Modifications\n\n        HelpFool may revise these terms of use for its web site at any time without notice. By using this web site you are agreeing to be bound by the then current version of these Terms and Conditions of Use.\n\n    8. Governing Law\n\n    Any claim relating to HelpFool's web site shall be governed by the laws of the State of California without regard to its conflict of law provisions.\n\n    General Terms and Conditions applicable to Use of a Web Site.\n\n    Privacy Policy\n\n        Your privacy is very important to us. Accordingly, we have developed this Policy in order for you to understand how we collect, use, communicate and disclose and make use of personal information. The following outlines our privacy policy.\n\n    Before or at the time of collecting personal information, we will identify the purposes for which information is being collected.\n\n    We will collect and use of personal information solely with the objective of fulfilling those purposes specified by us and for other compatible purposes, unless we obtain the consent of the individual concerned or as required by law.\n\n    We will only retain personal information as long as necessary for the fulfillment of those purposes.\n\n    We will collect personal information by lawful and fair means and, where appropriate, with the knowledge or consent of the individual concerned.\n\n    Personal data should be relevant to the purposes for which it is to be used, and, to the extent necessary for those purposes, should be accurate, complete, and up-to-date.\n\n    We will protect personal information by reasonable security safeguards against loss or theft, as well as unauthorized access, disclosure, copying, use or modification.\n\n    We will make readily available to customers information about our policies and practices relating to the management of personal information.\n\n    We are committed to conducting our business in accordance with these principles in order to ensure that the confidentiality of personal information is protected and maintained."
    
    //TODO: labels on buttons need to all be stored in UserDefaults.standard for them to persist

    private var suggestions: Bool = false
    
    private var termsClicked: Bool = false
    
    @IBOutlet var SelectedCats: UIButton!
    @IBOutlet var MYProximity: UIButton!
    @IBOutlet var NotificationMode: UIButton!
    @IBOutlet var AlternativeSuggestionsOption: UIButton!
    
    @IBOutlet var SaveButton: UIButton!
    
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        blacklist = UserDefaults.standard.stringArray(forKey: "blacklist")
        print(blacklist)
        if blacklist.count > 1 {
            SelectedCats.setTitle("\(blacklist[0]),...", for: .normal)
        }
        else {
            SelectedCats.setTitle(blacklist[0], for: .normal)
        }
        MYProximity.setTitle(UserDefaults.standard.string(forKey: "proximity"), for: .normal)
        NotificationMode.setTitle(UserDefaults.standard.string(forKey: "notificationsMode"), for: .normal)
        AlternativeSuggestionsOption.setTitle(UserDefaults.standard.string(forKey: "altSuggestions"), for: .normal)
        //locationManager.
    }
    

    @IBAction func SaveSettings() {
        //TODO: check if everything has been setup
        
        if (UserDefaults.standard.bool(forKey: "termsAccepted") && CLLocationManager.authorizationStatus() == .authorizedAlways){
            if UserDefaults.standard.bool(forKey: "hasSetup") {
                print("from home")
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print("from first setup")
                UserDefaults.standard.set(true, forKey: "hasSetup")
                let home = storyboard?.instantiateViewController(withIdentifier: "homeView") as! HomeViewController
                UIApplication.shared.keyWindow?.rootViewController = home
                
            }
        }
        else {
            if UserDefaults.standard.bool(forKey: "termsAccepted") {
                UserDefaults.standard.set(false, forKey: "hasSetup")
            }
        }
        
        if UserDefaults.standard.bool(forKey: "termsAccepted") && CLLocationManager.authorizationStatus() != .notDetermined {
            if CLLocationManager.authorizationStatus() != .authorizedAlways{
                requestLocation(accepted: UserDefaults.standard.bool(forKey: "termsAccepted"))
            }
            else {
                UserDefaults.standard.set(true, forKey: "hasSetup")
                UserDefaults.standard.synchronize()
            }
        }
        
        if !(UserDefaults.standard.bool(forKey: "termsAccepted")) {
            let alert = UIAlertController(title: "Accept Terms", message: "Click 'Accept' to agree to our Terms of Use", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
                let seriously = UIAlertController(title: "Seriously", message: "Accept the damn terms!", preferredStyle: UIAlertControllerStyle.alert)
                seriously.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { action in
                    let fineThen = UIAlertController(title: "Alright Then", message: "We cannot help you.", preferredStyle: UIAlertControllerStyle.alert)
                    fineThen.addAction(UIAlertAction(title: "Bye", style: UIAlertActionStyle.cancel, handler: { action in
                        self.termsClicked = true
                    }))
                    fineThen.addAction(UIAlertAction(title: "Fine, I accept them", style: UIAlertActionStyle.destructive, handler: { action in
                        self.acceptTerms()
                    }))
                    self.present(fineThen, animated: true, completion: nil)
                }))
                seriously.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.destructive, handler: { action in
                    self.acceptTerms()
                }))
                self.present(seriously, animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default, handler: { action in
                self.acceptTerms()
            }))
            
            self.present(alert, animated: true, completion: nil)
            //sleep(200)
        }
        
        
    }
    
    func acceptTerms() {
        UserDefaults.standard.set(true, forKey: "termsAccepted")
        UserDefaults.standard.synchronize()
        locationManager.requestAlwaysAuthorization()
        while (CLLocationManager.authorizationStatus() == .notDetermined) {
            //wait for request to return
        }
        self.termsClicked = true
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            requestLocation(accepted: true)
        }
        else {
            UserDefaults.standard.set(true, forKey: "hasSetup")
            UserDefaults.standard.synchronize()
        }
        if UserDefaults.standard.bool(forKey: "hasSetup") {
            let home = storyboard?.instantiateViewController(withIdentifier: "homeView") as! HomeViewController
            sleep(1)
            UIApplication.shared.keyWindow?.rootViewController = home
        }
    }
    
    func requestLocation(accepted: Bool) {
        if (accepted) {
            let alert = UIAlertController(title: "Turn on Location Services", message: "This app is useless without location services enabled.  Please go to settings and enable location services (allow in background) for this application.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No thanks", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.destructive, handler: { action in
                if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(appSettings as URL)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
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
        UserDefaults.standard.set(action.title, forKey: "notificationsMode")
        UserDefaults.standard.synchronize()

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
            UserDefaults.standard.set(textField.text, forKey: "proximity")
        }))
        self.present(alert, animated: true, completion: nil)
        UserDefaults.standard.synchronize()

    }
    
    @IBAction func altButtonPressed() {
        if AlternativeSuggestionsOption.currentTitle! == "Disabled" {
            AlternativeSuggestionsOption.setTitle("Enabled", for: .normal)
            UserDefaults.standard.set("Enabled", forKey: "altSuggestions")
            suggestions = true
        }
        else {
            AlternativeSuggestionsOption.setTitle("Disabled", for: .normal)
            UserDefaults.standard.set("Disabled", forKey: "altSuggestions")
            suggestions = false
        }
        UserDefaults.standard.synchronize()
    }
    

}
