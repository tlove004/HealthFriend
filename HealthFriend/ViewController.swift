//
//  ViewController.swift
//  HealthFriend
//
//  Created by Tyson Loveless on 2/18/17.
//  Copyright © 2017 Tyson Loveless. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

   // @IBOutlet var getStartedBtn: UIButton!
   // @IBOutlet weak var welcomeLabel: UILabel!
    
   
    
   // var pageIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   getStartedBtn?.contentEdgeInsets = UIEdgeInsetsMake(20, 45, 30, 45)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBOutlet weak var myproximity: UITextField!
    
    @IBAction func SaveProximityTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        let prev = presentingViewController as! SettingsController
        if myproximity.text != "" {
            prev.MYProximity.titleLabel?.text = myproximity.text! + " Feet"
        }
    }

    @IBOutlet weak var notifications: UISegmentedControl!
    
    @IBAction func SaveNotificationsTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        let prev = presentingViewController as! SettingsController
        prev.NotificationMode.titleLabel?.text = notifications.titleForSegment(at: notifications.selectedSegmentIndex)
    }
    
}

