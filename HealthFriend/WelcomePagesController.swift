//
//  WelcomePagesController.swift
//  HealthFriend
//
//  Created by Tyson Loveless on 2/21/17.
//  Copyright © 2017 Tyson Loveless. All rights reserved.
//

import UIKit
import Foundation

class WelcomePagesController : UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    var pageViewController:UIPageViewController!
    var pageLabels: Array<String>!
    var count: Int!
    var viewControllers: Array<PageContentController>!
    var startingViewController: PageContentController!
    
    @IBOutlet weak var getStartedBtn: UIButton!
    @IBOutlet weak var HealthFriendTitle: UIImageView!
    
    @IBOutlet weak var TitleVertConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create page view controller
        
        if !(UserDefaults.standard.bool(forKey: "hasSetup")) {
            //we could use text like this
            self.pageLabels = ["Page1", "Page2", "Page3"]
            
            //or add an image view and have series of images
            //self.imageLabels = ["img1.png", "img2.png", "img3.png"]
            
            
            self.count = pageLabels.count //imageLabels.count
            self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
            self.pageViewController.dataSource = self
            self.startingViewController = self.viewControllerAtIndex(index: 0) as! PageContentController
            self.viewControllers = [startingViewController]
            self.pageViewController.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
            
            self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-170)
            self.addChildViewController(pageViewController)
            self.view.addSubview(pageViewController.view)
            self.pageViewController.didMove(toParentViewController: self)
        }
        else {
            getStartedBtn.isHidden = true
            TitleVertConstraint.constant = (self.view.frame.height / 2.0) - (HealthFriendTitle.frame.height)
            print("time to move to normal screen")
        }
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGradientLayer()

    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let identifier = viewControllers?.first?.restorationIdentifier {
            if let index = pageLabels.index(of: identifier) {
            //if let index = imageLabels.index(of:identifier) {
                return index
            }
        }
        return 0
    }
    
    
    //helper method to get the index of current page
    func viewControllerAtIndex(index: Int)-> UIViewController? {
        
        if((count == 0) || (index >= count))
        {
            print("something wrong")
            return nil
        }
        
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentController") as! PageContentController

        pageContentViewController.titleText = self.pageLabels[index] //self.imageLabels[index]
        pageContentViewController.pageIndex = index
        
        return pageContentViewController
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! PageContentController).pageIndex!
        if (index == 0)
        {
            index = count-1
        }
        else {
            index -= 1
        }
        return viewControllerAtIndex(index: index)
        

        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?  {
        var index = (viewController as! PageContentController).pageIndex!

        index += 1
        if(index == count)
        {
            index = 0
        }
        return viewControllerAtIndex(index: index)

        
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
