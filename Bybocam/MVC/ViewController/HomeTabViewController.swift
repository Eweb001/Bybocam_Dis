//
//  HomeTabViewController.swift
//  Bybocam
//
//  Created by eWeb on 04/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit

class HomeTabViewController: UITabBarController,UITabBarControllerDelegate {

     let button = UIButton.init(type: .custom)
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.isTranslucent = false
       self.delegate = self
        // self.tabBar.barTintColor = UIColor(red: 253/255.0, green: 250/255.0, blue: 45/255.0, alpha: 1.0)
        // button.setTitle("Logo", for: .normal)
        // button.setTitleColor(.black, for: .normal)
       //  button.setTitleColor(.yellow, for: .highlighted)
        
        /*
        button.setImage(#imageLiteral(resourceName: "email24"), for: .normal)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 32
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        self.view.insertSubview(button, aboveSubview: self.tabBar)
        */
        
        
        
        let appearance = UITabBarItem.appearance(whenContainedInInstancesOf: [HomeTabViewController.self])
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
    }
    

    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    // UITabBarDelegate
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        print("Selected item \(item)")
        
        
    }
    
    
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        print("Selected view controller \(viewController)")
        
        print("Selected view controller \(tabBarController.selectedIndex)")
        
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 2
        {
        
            NotificationCenter.default.post(name: Notification.Name("refreshProfileApiProfilePage"), object: nil, userInfo: nil)
    
        }
        else if tabBarIndex == 1
        {
            DEFAULT.set("YES", forKey: "REFRESHRECOMENDAPI")
            
            
            DEFAULT.synchronize()
            
            
        }
        
    }


}
