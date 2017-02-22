//
//  TableViewController.swift
//  HealthFriend
//
//  Created by Tyson Loveless on 2/18/17.
//  Copyright © 2017 Tyson Loveless. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    @IBOutlet var categories: UITableView!
    var selectedCats = ""
    var numSelected = 0
    var selected = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for cat in categories.visibleCells {
            if cat.isSelected {
                cat.setSelected(false, animated: false)
            }
        }
        self.parent?.title = "Categories"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    

    @IBAction func SaveButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        numSelected = 0
        selectedCats = ""
        if (categories.indexPathsForSelectedRows == nil) {
            return
        }
        for _ in categories.indexPathsForSelectedRows! {
            numSelected += 1
        }
        for cat in categories.visibleCells {
            //print(numSelected)
            if cat.isSelected {
                if  numSelected == 1 {
                    //print(cat.textLabel!.text)
                    selectedCats.append((cat.textLabel?.text)!)
                    break
                }
                else if numSelected > 1 {
                    selectedCats.append((cat.textLabel?.text)! + ",...")
                    break
                }
            }
        }
        print(numSelected)
        let prev = presentingViewController as! SettingsController
        prev.SelectedCats.titleLabel?.text = selectedCats
        
    }

}

