//
//  SplashViewController.swift
//  Bybocam
//
//  Created by APPLE on 11/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController
{

    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        loginBtn.layer.cornerRadius = 6
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        signupBtn.layer.cornerRadius = 6
        signupBtn.layer.borderWidth = 1
        signupBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
    }
    @IBAction func signupAct(_ sender: UIButton)
    {
        let signupScreen = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.navigationController?.pushViewController(signupScreen, animated: true)
        
    }
    @IBAction func logInAct(_ sender: UIButton)
    {
        let loginScreen = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        self.navigationController?.pushViewController(loginScreen, animated: true)
        
    }
    
    
}


