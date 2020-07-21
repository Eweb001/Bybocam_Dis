//
//  AddInfluencerVC.swift
//  Bybocam
//
//  Created by Eweb on 18/07/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import IQKeyboardManager
import Alamofire
import SVProgressHUD
import CoreLocation
import DropDown


class AddInfluencerVC: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate {
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
   
            if !NetworkEngine.networkEngineObj.isInternetAvailable()
            {
                
                NetworkEngine.showInterNetAlert(vc: self)
            }
            else
            {
                ViewProfileApi()
            }
        
        
        // Do any additional setup after loading the view.
        
    }

    @IBAction func priceChange(_ sender: UISlider)
    {
        self.ammountLbl.text = "\(Int(sender.value))"
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func raceAct(_ sender: UIButton)
       {
        
        RacedropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            
            self.raceTF.text = item
            
//            DEFAULT.set(item, forKey: "year_vehicle")
//                       DEFAULT.synchronize()
//            self.selectYrBtn.setTitle(item, for: .normal)
        }
        RacedropDown.show()

        
        
       }
       
    @IBAction func genderAct(_ sender: UIButton)
          {
                GenderdropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                        print("Selected item: \(item) at index: \(index)")
                          
                          self.genderTF.text = item
                          
              //            DEFAULT.set(item, forKey: "year_vehicle")
              //                       DEFAULT.synchronize()
              //            self.selectYrBtn.setTitle(item, for: .normal)
                      }
                      GenderdropDown.show()
          }
          @IBAction func IndustryAct(_ sender: UIButton)
                {
                     IndustrydropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                                           print("Selected item: \(item) at index: \(index)")
                                             
                                             self.industryTF.text = item
                                             
                                 //            DEFAULT.set(item, forKey: "year_vehicle")
                                 //                       DEFAULT.synchronize()
                                 //            self.selectYrBtn.setTitle(item, for: .normal)
                                         }
                                         IndustrydropDown.show()
                }
                
    
    
    @IBAction func publishAct(_ sender: UIButton)
    {
        if self.userName.text == ""
               {
                   NetworkEngine.commonAlert(message: "Please Enter name.", vc: self)
               }
               else if self.addressTF.text == ""
               {
                   NetworkEngine.commonAlert(message: "Please Enter address.", vc: self)
               }
               else if self.descTxt.text == ""
               {
                   NetworkEngine.commonAlert(message: "Please Enter some discription.", vc: self)
               }
               else if self.ammountLbl.text == ""
               {
                   NetworkEngine.commonAlert(message: "Please Enter price.", vc: self)
               }
               else if self.industryTF.text == ""
               {
                   NetworkEngine.commonAlert(message: "Please Enter your Industry.", vc: self)
               }
               else
               {
                   if !NetworkEngine.networkEngineObj.isInternetAvailable()
                          {
                              
                              NetworkEngine.showInterNetAlert(vc: self)
                          }
                          else
                          {
                              uploadFluencerAPi()
                          }
               }
        
        
       
    }
    
    
    func ViewProfileApi()
    {
        
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        let para = ["userId" : USERID,
                    "loginUserId" : USERID]   as! [String : String]
        print(para)
        
        ApiHandler.PostModelApiPostMethod(url: VIEW_USER_PROFILE_URL, parameters: para, Header: ["":""]) { (responsedata, error) in
            
            do
            {
                let decoder = JSONDecoder()
                
                if  responsedata != nil
                {
                    self.ModelApiResponse = try decoder.decode(ViewUserProfile.self, from: responsedata!)
                    
                    if self.ModelApiResponse?.status == "success"
                    {
                        if self.ModelApiResponse?.data?.count ?? 0>0
                        {
                            
                            self.userName.text = self.ModelApiResponse?.data?[0].userName
                            //self.userName.text = self.ModelApiResponse?.data?[0].
                            
                            
                            
                            
                            if let newImgg = self.ModelApiResponse?.data?[0].userImage
                            {
                                let image_value = Image_Base_URL + newImgg
                                print(image_value)
                                let profile_img = URL(string: image_value)
                                self.userImg.sd_setImage(with: profile_img, completed: nil)
                                
                            }
                            
                        }
                        
                        
                    }
                    else
                    {
                        
                    }
                }
                
            }
            catch let error
            {
                print(error)
            }
            
        }
    }
    
    // uploadFluencerAPi.
    
    func uploadFluencerAPi()
    {
        
        SVProgressHUD.show()
        SVProgressHUD.setBorderColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(UIColor.black)
        
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        
        
        let para = ["userId" : USERID,
                    "name" : self.userName.text!,
                    "latitude" : self.newLat,
                    "longitude" : self.newLong,
                    "address" : self.addressTF.text!,
                    "industry" : industryTF.text!,
                    "price" : self.ammountLbl.text!,
                    "discription" : self.descTxt.text!,
                    "race" : raceTF.text!,
                    "gender" : genderTF.text!] as! [String : String]
        
        print(para)
        SVProgressHUD.show()
        SVProgressHUD.setBorderColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(UIColor.black)
        
        Alamofire.upload(multipartFormData:
            {
                (multipartFormData) in
                
                if self.userImg.image != nil
                {
                    multipartFormData.append(self.userImg.image!.jpegData(compressionQuality: 0.75)!, withName: "picture", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }
                
                for (key, value) in para
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
        }, to:ADD_INFPROFILE_User)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    
                    if progress.isFinished
                    {
                        SVProgressHUD.dismiss()
                        
                    }
                    else{
                        ApiHandler.LOADERSHOW()
                    }
                })
                upload.responseJSON
                    {
                        response in
                        print(response)
                        
                        self.navigationController?.popViewController(animated: true)
                        if response.data != nil
                        {
                            do
                            {
                                
                                
                                let decoder = JSONDecoder()
                                
                        
                            }
                            catch let error
                            {
                                print(error)
                            }
                        }
                        
                }
                break
            case .failure(let encodingError):
                SVProgressHUD.dismiss()
                print(encodingError)
                break
            }
        }
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
