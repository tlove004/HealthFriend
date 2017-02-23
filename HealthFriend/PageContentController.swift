//
//  PageContentController.swift
//  HealthFriend
//
//  Created by Tyson Loveless on 2/22/17.
//  Copyright © 2017 Tyson Loveless. All rights reserved.
//

import Foundation
import UIKit

class PageContentController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var pageIndex: Int?
    var titleText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.titleText
        self.titleLabel.alpha = 0.1
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.titleLabel.alpha = 1.0
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
