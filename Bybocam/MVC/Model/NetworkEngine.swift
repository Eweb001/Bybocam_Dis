//
//  NetworkEngine.swift
//  Bybocam
//
//  Created by eWeb on 22/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import Alamofire
import SVProgressHUD
class NetworkEngine:UIViewController{
    
    static let networkEngineObj = NetworkEngine()
    var activityView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let appDel_ref = UIApplication.shared.delegate as! AppDelegate   // app delegate Refrence
    
    
    var shoudLoadAssetsData = false
    
    
    //--MARK:--- calculate diffent devices---
    func diffDevices()-> Float
    {
        
        if UIScreen.main.nativeBounds.height == 960
        {
            return  250.0 // 4
        }
            
        else if UIScreen.main.nativeBounds.height == 1136
        {
            return 280.0 // 5
        }
            
            
        else if UIScreen.main.nativeBounds.height == 1334
        {
            return 310.0 // 6
        }
            
        else     {
            
            return 325.0 //
            
        }
        
        
    }
    
    
    func LOADERSHOW()
    {
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(UIColor.white)
        //Ring Color
        
        SVProgressHUD.setBackgroundColor(UIColor.black)        //HUD Color
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)    //Background Color
        SVProgressHUD.show()
    }
    
    
    // MARK :INTERNET AVAILABLITY Method
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    //    MARK:Alert Method
    func showAlert(messageToShow:String,title:String)
    {
        let alert = UIAlertController(title: title, message: messageToShow, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .cancel)
        {
            UIAlertAction in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okBtn)
        appDel_ref.window?.rootViewController!.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Email validation Method
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func validatePhoneNumber(value: String) -> Bool {
        
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    //MARK:        local  to Gmt ----
    func convertLocal_Gmt()-> String
    {
        let date = NSDate()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormat.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone!
        let dateString = dateFormat.string(from: date as Date)
        print(dateString)
        return dateString
    }
    //===MARK:---- Gmt--> local
    func convertGmt_LocalTime(dateValue:String)->String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        let date = dateFormatter.date(from: dateValue)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date!)
        print(timeStamp)
        return timeStamp
    }
    
    //MARK: get date value in required format
    func setDateData( serverDate:String) -> String
    {
        
        var lblText = ""
        var convertedMintvalue = ""
        var amPmValue = ""
        
        let serverYear = serverDate.substring(to: serverDate.index(serverDate.endIndex, offsetBy: -15))
        //-- get month----
        let startIndexMonth = serverDate.index(serverDate.startIndex, offsetBy: 5)
        let endIndexMonth = serverDate.index(serverDate.endIndex, offsetBy: -12)
        let range = startIndexMonth..<endIndexMonth
        let serverMonth =  serverDate.substring(with: range)
        
        //--- get day----
        let startIndexday = serverDate.index(serverDate.startIndex, offsetBy: 8)
        let endIndexDay = serverDate.index(serverDate.endIndex, offsetBy: -9)
        let rangeDay = startIndexday..<endIndexDay
        let serverDay =  serverDate.substring(with: rangeDay)
        
        //-- get hour-------
        
        let startIndexHour = serverDate.index(serverDate.startIndex, offsetBy: 11)
        let endIndexHour = serverDate.index(serverDate.endIndex, offsetBy: -6)
        let rangeHour = startIndexHour..<endIndexHour
        let serverHour =  serverDate.substring(with: rangeHour)
        
        //-- get Mint -------
        
        let startIndexMint = serverDate.index(serverDate.startIndex, offsetBy: 14)
        let endIndexMint = serverDate.index(serverDate.endIndex, offsetBy: -3)
        let rangeMint = startIndexMint..<endIndexMint
        let serverMint =  serverDate.substring(with: rangeMint)
        
        
        //--- get current date Time
        
        let date = NSDate()
        let calendarVal = NSCalendar.current
        let components = calendarVal.dateComponents([.month, .year, .second,.day], from: date as Date)
        let currentYear = components.year
        let currentMonth = components.month
        let currentDay = components.day
        
        let yesterday =  calendarVal.date(byAdding: .day, value: -1, to: date as Date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let yesterDayString = dateFormatter.string(from: yesterday!)
        let modifiedServerDate = serverDate.substring(to: serverDate.index(serverDate.endIndex, offsetBy: -9))
        
        
        
        
        //-- checks----
        if Int(serverHour)! > 12
        {
            convertedMintvalue = String(Int(serverHour)! - 12)
            amPmValue = " pm"
        }
        
        if Int(serverHour)! < 12{
            convertedMintvalue = String(Int(serverHour)!)
            amPmValue = " am"
        }
        
        
        if Int(serverHour) == 12
        {
            convertedMintvalue = String(Int(serverHour)! - 12)
            amPmValue = " pm"
        }
        if Int(serverHour) == 24
        {
            convertedMintvalue = String(Int(serverHour)! - 12)
            amPmValue = " am"
        }
        
        
        if currentYear == Int(serverYear) && currentMonth == Int(serverMonth) && currentDay == Int(serverDay)
        {
            
            //--- today date
            lblText = "Today at" + " " + convertedMintvalue + ":" + String(serverMint) + amPmValue
        }
            
            
        else if yesterDayString == modifiedServerDate
        {
            //-- yesterdat date
            lblText = "Yesterday at" + " " + convertedMintvalue + ":" + String(serverMint) + amPmValue
            
        }
            
            
            
        else{
            lblText = serverYear + "- " + serverMonth + " -" + serverDay + " at" + " " + convertedMintvalue + ":" + serverMint + " " + amPmValue
        }
        return lblText
        
    }
    
    static func showInterNetAlert(vc: UIViewController?) ->Void
    {
        
        let alert = UIAlertController(title: "No Connection", message: "Please check Your internet connectivity.", preferredStyle: .alert)
        let Settings = UIAlertAction(title: "Settings", style: .default, handler: { (UIAlertAction) in
            let url = URL(string: "App-Prefs:root=WIFI") //for WIFI setting app
            let app = UIApplication.shared
            app.openURL(url!)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in
        })
        alert.addAction(cancel)
        alert.addAction(Settings)
        
        if (vc == nil)
        {
            if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
                window.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            vc?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    static func commonAlert(message:String,vc: UIViewController?) ->Void
    {
        
        let alert = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
        let Ok = UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            
        })
        
        alert.addAction(Ok)
        
        if (vc == nil)
        {
            if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
                window.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            vc?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
}
