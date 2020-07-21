//
//  AppDelegate.swift
//  Bybocam
//
//  Created by eWeb on 04/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import BiometricAuthentication
import DropDown
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate
{
// FBFE03  app color
    var window: UIWindow?
    
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Calibri-Bold", size: 17)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        Autologin()
        DropDown.startListeningToKeyboard()

        UIApplication.shared.windows.forEach { window in
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = .light
            } else {
                // Fallback on earlier versions
            }
        }
        // set this before calling authenticateWithBioMetrics method (optional)
        BioMetricAuthenticator.shared.allowableReuseDuration = 60
         registerForRemoteNotification()
        
        
        
        return true
    }
    func Autologin()
    {
       
        if (DEFAULT.value(forKey: "USER_ID") as? String) != nil
        {
            if (DEFAULT.value(forKey: "TOUCHID") as? String) != nil
            {
            
            
                self.AuthPage()
            }
            else
            {
               self.HomePage()
            }
            
            
            
        }
        else
        {
            loginPage()
        }
        
    }
    func loginPage()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        window = UIWindow.init(frame: UIScreen.main.bounds)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let vc = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let nav = UINavigationController(rootViewController: vc)
        delegate?.window?.rootViewController = nav
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    func AuthPage()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        window = UIWindow.init(frame: UIScreen.main.bounds)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let vc = storyBoard.instantiateViewController(withIdentifier: "BioAuthViewController") as! BioAuthViewController
        let nav = UINavigationController(rootViewController: vc)
        delegate?.window?.rootViewController = nav
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    func HomePage()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        window = UIWindow.init(frame: UIScreen.main.bounds)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeTabViewController") as! HomeTabViewController
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        delegate?.window?.rootViewController = nav
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    //MARK:-- remote notifications methods---
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *)
        {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil
                {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            // For iOS 10 data message (sent via FCM
            //            Messaging.messaging().delegate = self
            
        }
        else
        {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
    }
    
    func notificationBlock()
    {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    //MARK:- Notification Methods------
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification.request.content.userInfo)
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        
        
        
        
        
        completionHandler([.alert, .badge, .sound])
    }
    //Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
        {
            
            
            
        }
        
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    //--MARK:--Get Token-----
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count
        {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("device token =  \(token)")
        
        UserDefaults.standard.setValue(token, forKey: "DEVICETOKEN")
        UserDefaults.standard.synchronize()
        
    }
    
    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        Autologin()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        print("Memory Warning Error Occur")
        
        
    }


}

