//
//  InfluenceFilterVc.swift
//  Bybocam
//
//  Created by Eweb on 21/07/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import IQKeyboardManager
import Alamofire
import SVProgressHUD
import CoreLocation
import DropDown


class InfluenceFilterVc: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate {
    var ModelApiResponse:ViewUserProfile?
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var raceTF: UITextField!
    @IBOutlet weak var industryTF: UITextField!
   
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var descTxt: IQTextView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var price: UISlider!
    
    @IBOutlet weak var ammountLbl: UILabel!
    
    
    
    
    
      @IBOutlet weak var raceBtn: UIButton!
     @IBOutlet weak var genderBtn: UIButton!
     @IBOutlet weak var IndustryBtn: UIButton!
    
    // Location Manager
       
       var locationManager:CLLocationManager!
       var newLat = "30.898"
       var newLong = "76.8778"
       var CurrentMainLocatin = ""
    
    let RacedropDown = DropDown()
 let GenderdropDown = DropDown()
     let IndustrydropDown = DropDown()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RacedropDown.anchorView = self.raceBtn
        RacedropDown.dataSource = ["Black/African American", "Asian", "white","American Indian/Alaska Native","Hispanic/Latino","Native Hawaiian or Other Pacific Islander"]
        
        GenderdropDown.anchorView = self.genderBtn
             GenderdropDown.dataSource = ["Male", "Female", "Neutral or Prefer not to say"]
             
             IndustrydropDown.anchorView = self.genderBtn
                         IndustrydropDown.dataSource = ["Advertising", "Creative industry", "Entertainment industry","Fashion","Media","Retail","Technology Industry","Education","Finance","Music industry","Service Industry"]
                         

               locationManager = CLLocationManager()
               locationManager.delegate = self
               locationManager.desiredAccuracy = kCLLocationAccuracyBest
               locationManager.requestAlwaysAuthorization()
               
               if CLLocationManager.locationServicesEnabled()
               {
                   locationManager.startUpdatingLocation()
        }
   
          
        
    }

    @IBAction func priceChange(_ sender: UISlider)
    {
        self.ammountLbl.text = "\(Int(sender.value))"
        
        DEFAULT.set(self.ammountLbl.text!, forKey: "price")
            DEFAULT.synchronize()
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem)
    {
         DEFAULT.removeObject(forKey: "price")
        DEFAULT.removeObject(forKey: "race")
        DEFAULT.removeObject(forKey: "gender")
        DEFAULT.removeObject(forKey: "industry")
        DEFAULT.removeObject(forKey: "Infulenlatitude")
           DEFAULT.removeObject(forKey: "Infulenlongitude")
        
        DEFAULT.synchronize()
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func raceAct(_ sender: UIButton)
       {
        
        RacedropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            
            self.raceTF.text = item
            
         DEFAULT.set(item, forKey: "race")
                 DEFAULT.synchronize()

        }
        RacedropDown.show()

        
        
       }
       
    @IBAction func genderAct(_ sender: UIButton)
          {
                GenderdropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                        print("Selected item: \(item) at index: \(index)")
                          
                          self.genderTF.text = item
                          
                        DEFAULT.set(item, forKey: "gender")
                                 DEFAULT.synchronize()
           
                      }
                      GenderdropDown.show()
          }
          @IBAction func IndustryAct(_ sender: UIButton)
                {
                     IndustrydropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                                           print("Selected item: \(item) at index: \(index)")
                                             
                                             self.industryTF.text = item
                                             
                                           DEFAULT.set(item, forKey: "industry")
                                                    DEFAULT.synchronize()
                                
                                         }
                                         IndustrydropDown.show()
                }
                
    
    
    @IBAction func publishAct(_ sender: UIButton)
    {
       
        self.navigationController?.popViewController(animated: true)
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
       {
           let userLocation :CLLocation = locations[0] as CLLocation
           let geocoder = CLGeocoder()
           
           if !NetworkEngine.networkEngineObj.isInternetAvailable()
           {
               NetworkEngine.showInterNetAlert(vc: self)
           }
           else
           {
               geocoder.reverseGeocodeLocation(userLocation)
               {
                   (placemarks, error) in
                   if (error != nil)
                   {
                       print("error in reverseGeocode")
                   }
                   let placemark = placemarks! as [CLPlacemark]
                   if placemark.count>0
                   {
                       let placemark = placemarks![0]
                       print(placemark.locality!)
                       print(placemark.administrativeArea!)
                       print(placemark.country!)
                       
                       print("user latitude = \(userLocation.coordinate.latitude)")
                       print("user longitude = \(userLocation.coordinate.longitude)")
                       
                       self.newLat = "\(userLocation.coordinate.latitude)"
                       self.newLong = "\(userLocation.coordinate.longitude)"
                       
                       DEFAULT.set(self.newLat, forKey: "LATITUDE")
                       DEFAULT.set(self.newLong, forKey: "LONGITUDE")
                    
                    DEFAULT.set(self.newLat, forKey: "Infulenlatitude")
                    DEFAULT.set(self.newLong, forKey: "Infulenlongitude")
                    
                    
                       self.CurrentMainLocatin = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
                       DEFAULT.set(self.CurrentMainLocatin, forKey: "CurrentMainLocatin")
                       
                       self.addressTF.text = ("\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)")
                       
                   }
               }

           }
           
           
       }
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
       {
           print("Error \(error)")
       }
    
}
