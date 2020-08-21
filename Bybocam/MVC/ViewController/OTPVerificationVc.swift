//
//  OTPVerificationVc.swift
//  Bybocam
//
//  Created by Eweb on 03/08/20.
//  Copyright © 2020 eWeb. All rights reserved.
//


import UIKit
import Photos
import Alamofire
import SDWebImage
import CoreLocation
import SVProgressHUD
import CountryList
import FirebaseAuth
import Firebase
class OTPVerificationVc: UIViewController
{
    var countryList = CountryList()
    @IBOutlet weak var countryCode: UIButton!
    @IBOutlet weak var sendBtnOutlet: UIButton!
    @IBOutlet weak var PhoneTf: UITextField!
    
    @IBOutlet weak var OTPView: UIView!
    @IBOutlet weak var OTPTf: UITextField!
    @IBOutlet weak var cancelBtnOutlet: UIButton!
    @IBOutlet weak var submitBtnOutlet: UIButton!
    var verificationId = ""
    var phoneNumber = ""
    var code = "+91"
    override func viewDidLoad() {
        super.viewDidLoad()
        countryList.delegate = self
        // Do any additional setup after loading the view.
        sendBtnOutlet.layer.shadowColor = UIColor.black.cgColor
        sendBtnOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        sendBtnOutlet.layer.masksToBounds = false
        sendBtnOutlet.layer.shadowRadius = 2.0
        sendBtnOutlet.layer.shadowOpacity = 0.5
    self.OTPView.isHidden=true
    }
    @IBAction func poneNumberAct(_ sender: UIButton)
    {
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.red
        
        let navController = UINavigationController(rootViewController: countryList)
        _ = [NSAttributedString.Key.foregroundColor:UIColor.red]
        navController.navigationController?.navigationBar.tintColor=UIColor.black
        
        
        self.present(navController, animated: true, completion: nil)
    }
    @IBAction func GoBack(_ sender: UIBarButtonItem)
    {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OTpSubmitAct(_ sender: UIButton)
       {
        
        
         if OTPTf.text == ""
                     {
                         
                         NetworkEngine.commonAlert(message: "Please enter OTP.", vc: self)
                         
                     }
                     else
                     {
                      
                      let credential = PhoneAuthProvider.provider().credential(
                          withVerificationID: self.verificationId,
                      verificationCode: self.OTPTf.text!)
                      
                      Auth.auth().signIn(with: credential) { (authResult, error) in
                        if  error != nil
                           {
                              NetworkEngine.showToast(controller: self, message : error?.localizedDescription, seconds: 2.0)

                           }
                          else
                          {
                             print(authResult)
                            DEFAULT.set((self.countryCode.titleLabel?.text!), forKey: "PHONECODE")
                            DEFAULT.set((self.PhoneTf.text!), forKey: "PHONENUMBER")
                            DEFAULT.synchronize()
                            self.OTPView.isHidden=true
                            
                            self.navigationController?.popViewController(animated: true)
                           }
                    
                        }
                        
                      
                     }
    }
    @IBAction func cancelAct(_ sender: UIButton)
       {
        self.OTPView.isHidden=true
    }
    
    @IBAction func SubmitAct(_ sender: UIButton)
    {
        if PhoneTf.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Phone number.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else
        {
            let number = self.code+self.PhoneTf.text!
            
            print("Phone Number = \(number)")
            
            PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verificationID, error) in
                if let error = error
                {
                    print(error.localizedDescription)
                    self.view.makeToast(error.localizedDescription)
                    return
                }
                else
                {
                    print("verificationID=\(verificationID)")
                    
                    self.verificationId=verificationID ?? ""
                    self.phoneNumber = number
                    
                    self.OTPView.isHidden=false
                    let vcode = verificationID ?? ""
                    
                    DEFAULT.set(vcode, forKey: "verificationID")
                    DEFAULT.set(number, forKey: "Number")
                    DEFAULT.synchronize()
            
                    
                }
                
                
            }
        }
        
    }
}
extension OTPVerificationVc:CountryListDelegate {
    
    func selectedCountry(country: Country) {
        print(country.name)
        print(country.flag)
        
        print(country.countryCode)
        print(country.phoneExtension)
        let name = country.countryCode ?? ""
        let flag = country.flag ?? ""
        let code =  "+" + country.phoneExtension
        //  self.phoneNumber=code
        self.code = code
        
        var title = flag+" "+code
        self.countryCode.setTitle(title, for: .normal)
    }
}
