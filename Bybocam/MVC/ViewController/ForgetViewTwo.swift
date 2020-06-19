//
//  ForgetViewTwo.swift
//  Bybocam
//
//  Created by APPLE on 15/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgetViewTwo: UIViewController
{

    @IBOutlet weak var submitBtnOutlet: UIButton!
    @IBOutlet weak var enterOTPtf: UITextField!
    @IBOutlet weak var createNewpassTF: UITextField!
    @IBOutlet weak var confirmNewPassTF: UITextField!
    
    var ModelApiResponse:SignUpModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        enterOTPtf.placeholderColor(UIColor.black)
        createNewpassTF.placeholderColor(UIColor.black)
        confirmNewPassTF.placeholderColor(UIColor.black)
        submitBtnOutlet.layer.shadowColor = UIColor.black.cgColor
        submitBtnOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        submitBtnOutlet.layer.masksToBounds = false
        submitBtnOutlet.layer.shadowRadius = 2.0
        submitBtnOutlet.layer.shadowOpacity = 0.5
        
    }
    func Validations()
    {
        if enterOTPtf.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your OTP.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if createNewpassTF.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your New password.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if confirmNewPassTF.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please confirm your password.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if enterOTPtf.text == "" && createNewpassTF.text == "" && confirmNewPassTF.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please fill all details.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else
        {
             self.ForgetApi1()
        }
    }
    @IBAction func goBak(_ sender: UIBarButtonItem)
    {
       self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitAct(_ sender: UIButton)
    {
        self.Validations()
    }
    
    // Forget Api here...
    
    func ForgetApi1()
    {

        
        let para = ["otp" : enterOTPtf.text!,
                    "password" : createNewpassTF.text! ,
                    "confirmPassword" : confirmNewPassTF.text!]   as! [String : String]
        print(para)
        
        ApiHandler.PostModelApiPostMethod(url: FORGET_TWO_URL, parameters: para, Header: ["":""]) { (responsedata, error) in
            
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
                            
                            
                            let ForgetViewTwo = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            
                            self.navigationController?.pushViewController(ForgetViewTwo, animated: true)
                            
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

}
