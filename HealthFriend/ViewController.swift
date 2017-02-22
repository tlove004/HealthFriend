//
//  ViewController.swift
//  HealthFriend
//
//  Created by Tyson Loveless on 2/18/17.
//  Copyright © 2017 Tyson Loveless. All rights reserved.
//

import UIKit
import Foundation
import YelpAPI

let myID = "KQOW6wvZOhPFO-uu2d4-QQ"
let mySecret = "M9KAYPJipfuGjMKRV3yb4nyciPrmNDavFBRYRsCXSDxDpYzK86hVDShEK1ozIELi"

let coords = YLPCoordinate(latitude: 123, longitude: 123)

class ViewController: UIViewController {

    @IBOutlet var getStartedBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStartedBtn?.contentEdgeInsets = UIEdgeInsetsMake(20, 45, 30, 45)
        YLPClient.authorize(withAppId: myID, secret: mySecret, completionHandler: { (client, error) -> Void in
            //print(client!)
            
            client!.search(with: coords, completionHandler: { (ylpSearch, error) in
                //let ip = IndexPath()
                //self.CategoriesTable.allowsMultipleSelection = true
                //for b in (ylpSearch?.businesses)! {
                    //
                //}
            })
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGradientLayer()
        getStartedBtn?.isHidden = false
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
    
    var bottom: UIColor = UIColor.init(red: 36/255.0, green: 149/255.0, blue: 242/255.0, alpha: 1.0)
    var top: UIColor = UIColor.init(red: 135/255.0, green: 198/255.0, blue: 249/255.0, alpha: 1.0)
    var gradientLayer: CAGradientLayer = CAGradientLayer()
    
    func createGradientLayer() {
        
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = [top.cgColor, bottom.cgColor]
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

