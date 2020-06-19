//
//  ForgetViewOne.swift
//  Bybocam
//
//  Created by APPLE on 15/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgetViewOne: UIViewController
{

    
    @IBOutlet weak var userEmailTF: UITextField!
    @IBOutlet weak var submitBtnOutlet: UIButton!
    
    var ModelApiResponse:SignUpModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        userEmailTF.placeholderColor(UIColor.black)
        submitBtnOutlet.layer.shadowColor = UIColor.black.cgColor
        submitBtnOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        submitBtnOutlet.layer.masksToBounds = false
        submitBtnOutlet.layer.shadowRadius = 2.0
        submitBtnOutlet.layer.shadowOpacity = 0.5
        
    }
    @IBAction func GoBack(_ sender: UIBarButtonItem)
    {
      self.navigationController?.popViewController(animated: true)
    }
    @IBAction func SubmitAct(_ sender: UIButton)
    {
        Validations()
        
    }
    func Validations()
    {
        if userEmailTF.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Email.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if userEmailTF.text!.isValidateEmail() == false
        {
            let alert = UIAlertController(title: "Alert", message: "Please type Valid email address.", preferredStyle: UIAlertController.Style.alert)
            
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
                self.ForgetApi()
            }
            
            
    
        }
    }
    @IBAction func GoTo(_ sender: UIButton)
    {
        let sign = storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.navigationController?.pushViewController(sign, animated: true)
    }
    // Forget Api here...
    
    func ForgetApi()
    {
       
        let para = ["email" : userEmailTF.text!]   as! [String : String]
        print(para)
        
        
        ApiHandler.PostModelApiPostMethod(url: FORGET_ONE_URL, parameters: para, Header: ["":""]) { (responsedata, error) in
            
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
                            
                            
                            let ForgetViewTwo = self.storyboard?.instantiateViewController(withIdentifier: "ForgetViewTwo") as! ForgetViewTwo
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
