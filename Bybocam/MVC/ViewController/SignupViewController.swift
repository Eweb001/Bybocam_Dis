//
//  SignupViewController.swift
//  Bybocam
//
//  Created by eWeb on 04/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

import SVProgressHUD

class SignupViewController: UIViewController, CLLocationManagerDelegate {
   
    @IBOutlet weak var mainNameLbl: UILabel!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var locationTxt: UITextField!
    @IBOutlet weak var signupBtn: UIButton!

     var ModelApiResponse:SignUpModel?
    
    // Location Manager
    
    var locationManager:CLLocationManager!
    var newLat = "30.998"
    var newLong = "769089"
    var CurrentMainLocatin = ""
    
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
                    
                    self.locationTxt.text = ("\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)") + "\(" (Optional)")"
                    
                }
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
        setUI()
        
        self.signupBtn.applyGradient(colours: [COLOR1, COLOR2, COLOR3], locations: [0.0, 0.5, 1.0])

        self.mainNameLbl.UILableTextShadow(color: UIColor.black )
        
        self.navigationController?.isNavigationBarHidden = true
        userNameTxt.placeholderColor(UIColor.black)
        emailTxt.placeholderColor(UIColor.black)
        passwordTxt.placeholderColor(UIColor.black)
        locationTxt.placeholderColor(UIColor.black)
        signupBtn.layer.shadowColor = UIColor.black.cgColor
        signupBtn.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        signupBtn.layer.masksToBounds = false
        signupBtn.layer.shadowRadius = 2.0
        signupBtn.layer.shadowOpacity = 0.5
        
        // Location Manager
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.startUpdatingLocation()
        }
    }
    @IBAction func goToLogin(_ sender: UIButton)
    {
        let sign = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(sign, animated: true)
    }
    @IBAction func SignUpAct(_ sender: UIButton)
    {
         Validations()
    }
    func Validations()
    {
        if userNameTxt.text == "" && emailTxt.text == "" && passwordTxt.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Details.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if userNameTxt.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Name.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if emailTxt.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Email.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if emailTxt.text!.isValidateEmail() == false
        {
            let alert = UIAlertController(title: "Alert", message: "Please type Valid email address.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if passwordTxt.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Password.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else
        {
            if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            self.signup_APi()
        }
            
        }
    }
    
    // SIGNUP Api here..........
    
    func signup_APi()
    {
        var newLat2 = "30.704649"
        var newLong2 = "76.717873"
        
        if newLat != ""
        {
            newLat2=newLat
        }
        if newLong != ""
        {
            newLong2=newLong
        }

        let para = ["UserName" : userNameTxt.text!,
                    "email" : emailTxt.text!,
                    "password" : passwordTxt.text!,
                    "latitude" : newLat2,
                    "longitude" : newLong2]  as! [String : String]
        print(para)
        
        ApiHandler.PostModelApiPostMethod(url: SIGNUP_URL, parameters: para, Header: ["":""]) { (responsedata, error) in
            
            do
            {
                let decoder = JSONDecoder()
                
                if  responsedata != nil
                    
                {
                    self.ModelApiResponse = try decoder.decode(SignUpModel.self, from: responsedata!)
                    
                    if self.ModelApiResponse?.status == "success"
                    {
                        let alert = UIAlertController(title: "Alert", message: self.ModelApiResponse?.message, preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                        
                            
                            let v = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                            self.navigationController?.pushViewController(v!, animated: true)
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
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
    func setUI()
    {
        userNameTxt?.placeholderColor(UIColor.darkGray)
        emailTxt?.placeholderColor(UIColor.darkGray)
        passwordTxt?.placeholderColor(UIColor.darkGray)
        locationTxt?.placeholderColor(UIColor.darkGray)
    }
}
