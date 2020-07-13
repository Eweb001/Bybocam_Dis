//
//  LoginViewController.swift
//  Bybocam
//
//  Created by eWeb on 04/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//


import UIKit
import CoreLocation
import Alamofire

import SVProgressHUD
import Toast_Swift

class LoginViewController: UIViewController, CLLocationManagerDelegate
{
    
    @IBOutlet weak var mainNameLbl: UILabel!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    
    var dataDict = NSDictionary()
    
    var ModelApiResponse:LoginDataModel?
    
    // Location Manager
    
    var locationManager:CLLocationManager!
    var newLat = ""
    var newLong = ""
    var CurrentMainLocatin = ""
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation :CLLocation = locations[0] as CLLocation
        let geocoder = CLGeocoder()
        
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
                
                // self.locationTxt.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
                
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        self.mainNameLbl.UILableTextShadow(color: UIColor.black )
        userNameTxt.placeholderColor(UIColor.black)
        passwordTxt.placeholderColor(UIColor.black)
        
        self.navigationController?.isNavigationBarHidden = true
        
        loginBtn.layer.shadowColor = UIColor.black.cgColor
        loginBtn.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        loginBtn.layer.masksToBounds = false
        loginBtn.layer.shadowRadius = 2.0
        loginBtn.layer.shadowOpacity = 0.5
        
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()
            {
            case .notDetermined, .restricted, .denied:
                print("No access")
                
                let alertController = UIAlertController(title: "Enable GPS", message: "GPS is not enable.Do you want to go setting menu.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
                let settingsAction = UIAlertAction(title: "SETTING", style: .default) { (UIAlertAction) in
                    UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.present(alertController, animated: true, completion: nil)
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        }
        else {
            print("Location services are not enabled")
            let alertController = UIAlertController(title: "Enable GPS", message: "GPS is not enable.Do you want to go setting menu.", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
            let settingsAction = UIAlertAction(title: "SETTING", style: .default) { (UIAlertAction) in
                UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
    @IBAction func goSignup(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func loginAction(_ sender: UIButton)
    {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeTabViewController") as! HomeTabViewController
//        self.navigationController?.pushViewController(vc, animated: true)
         self.Validations()
        
    }
    @IBAction func ForgotPass(_ sender: UIButton)
    {
        let forget = storyboard?.instantiateViewController(withIdentifier: "ForgetViewOne") as! ForgetViewOne
        self.navigationController?.pushViewController(forget, animated: true)
    }
    func Validations()
    {
        if userNameTxt.text == "" && passwordTxt.text == ""
        {
           
            
            NetworkEngine.commonAlert(message: "Please type your Email and Password.", vc: self)
        }
       
        else if userNameTxt.text == ""
        {

            NetworkEngine.commonAlert(message: "Please type your email.", vc: self)
        }
        else if passwordTxt.text == ""
        {
           
            
            NetworkEngine.commonAlert(message: "Please type your Password.", vc: self)
        }
        else
        {
            if !NetworkEngine.networkEngineObj.isInternetAvailable()
            {
                
                NetworkEngine.showInterNetAlert(vc: self)
            }
            else
            {
                self.login_APi()
            }
           
        }
    }
    // LOGIN Api here..........
    
    func login_APi()
        
    {
        
        var token = "9fc82b667d910eb2f54af7b3c607f2f330963dfff787e935dd45582f2145837a"
        
        if let DEVICETOKEN = DEFAULT.value(forKey: "DEVICETOKEN") as? String
        {
            token = DEVICETOKEN
        }

        let para = ["email" : userNameTxt.text!,
                    "password" : passwordTxt.text!,
                    "deviceType" : "2",
                    "deviceId" : token]   as! [String : String]
        print(para)
        
        ApiHandler.PostModelApiPostMethod(url: LOGIN_URL, parameters: para, Header: ["":""]) { (responsedata, error) in
            
            do
            {
                let decoder = JSONDecoder()
                
                if  responsedata != nil
                    
                {
                    self.ModelApiResponse = try decoder.decode(LoginDataModel.self, from: responsedata!)
                    
                    if self.ModelApiResponse?.status == "success"
                    {
                        
                        self.view.makeToast("Login successfully!")
                        
                        if self.ModelApiResponse?.data?.count ?? 0>0
                        {
                          
                            DEFAULT.set(self.ModelApiResponse?.data?[0].email, forKey: "Email")
                        
                            DEFAULT.set(self.ModelApiResponse?.data?[0].userId, forKey: "USER_ID")
                        
                            DEFAULT.set(self.ModelApiResponse?.data?[0].userName, forKey: "userName")
                            
                          
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabViewController") as! HomeTabViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                        })
                        
                    }
                    else
                    {
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Alert", message: self.ModelApiResponse?.message, preferredStyle: .alert)
                        let submitAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in})
                        alert.addAction(submitAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
            catch let error
            {
                print(error)
            }
            
        }
    
        
    }
}
extension UITextField
{
    func placeholderColor(_ color: UIColor)
    {
        var placeholderText = ""
        if self.placeholder != nil{
            placeholderText = self.placeholder!
        }
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
}

extension UILabel
{
    public var substituteFontName : String
    {
        get
        {
            return self.font.fontName;
        }
        set
        {
            let fontNameToTest = self.font?.fontName.lowercased() ?? ""
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            else if fontNameToTest.range(of: "regular") != nil {
                fontName += "-Regular";
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}

extension UITextView
{
    public var substituteFontName : String
    {
        get
        {
            return self.font?.fontName ?? "";
        }
        set
        {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            else if fontNameToTest.range(of: "regular") != nil {
                fontName += "-Regular";
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}

extension UITextField
{
    public var substituteFontName : String
    {
        get
        {
            return self.font?.fontName ?? "";
        }
        set
        {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            else if fontNameToTest.range(of: "regular") != nil {
                fontName += "-Regular";
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}
extension UILabel
{
    func UILableTextShadow(color: UIColor)
    {
        self.textColor = color
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
    }
}
