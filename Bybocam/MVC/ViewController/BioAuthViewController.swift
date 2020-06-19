//
//  BioAuthViewController.swift
//  Bybocam
//
//  Created by eWeb on 30/01/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

import BiometricAuthentication

class BioAuthViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AuthCheck()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationController?.isToolbarHidden = true
        AuthCheck()
    }
    override func viewWillDisappear(_ animated: Bool) {
        // self.navigationController?.navigationController?.isToolbarHidden = false
    }

    func AuthCheck()  {
        
        // start authentication
        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "App Authenticatication!", success: {
            APPDEL.HomePage()
            print("Sucess")
        })
        { (error) in
            print("Error \(error.message())")
            print(error.localizedDescription)
            print(error)
            self.showPasscodeAuthentication(message: error.message())
            
            switch error {
                
            // device does not support biometric (face id or touch id) authentication
            case .biometryNotAvailable:
                NetworkEngine.commonAlert(message: error.message(), vc: self)
                
            // No biometry enrolled in this device, ask user to register fingerprint or face
            case .biometryNotEnrolled:
                print("biometry Not Enrolled")
               // self.showGotoSettingsAlert(message: error.message())
                
            // show alternatives on fallback button clicked
            case .fallback:
              //  self.txtUsername.becomeFirstResponder() // enter username password manually
                
                print("fallback")
                // Biometry is locked out now, because there were too many failed attempts.
            // Need to enter device passcode to unlock.
            case .biometryLockedout:
               NetworkEngine.commonAlert(message: error.message(), vc: self)
                
            // do nothing on canceled by system or user
            case .canceledBySystem:
                 print("canceledBySystem")
                
            case .canceledByUser:
             //   exit(0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        exit(0)
                    }
                }
                print("canceledByUser authenticateWithBioMetrics")
            // show error for any other reason
            default:
               NetworkEngine.commonAlert(message: error.message(), vc: self)
            }
            
        }
    }
    func showGotoSettingsAlert(message: String)
    {
        let alertController = UIAlertController(title: "Biometry Not Enrolled!", message: "Go to settings.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
//            UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            
            // open settings
            let url = URL(string: UIApplication.openSettingsURLString)
            if UIApplication.shared.canOpenURL(url!)
            {
                UIApplication.shared.open(url!, options: [:])
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    // show passcode authentication
    func showPasscodeAuthentication(message: String)
    {
        
        BioMetricAuthenticator.authenticateWithPasscode(reason: message, success: {
            //NetworkEngine.commonAlert(message: "Login success!", vc: self)
            APPDEL.HomePage()
        }) { (error) in
            
        print(error.localizedDescription)
            print(error)
            switch  error
            {
                
            case .failed:
                NetworkEngine.commonAlert(message: error.message(), vc: self)
            case .canceledByUser:
                print("canceledByUser showPasscodeAuthentication")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        exit(0)
                    }
                }
              
            //    print("canceledByUser")
               //  NetworkEngine.commonAlert(message: error.message(), vc: self)
            case .fallback:
                NetworkEngine.commonAlert(message: error.message(), vc: self)
            case .canceledBySystem:
              print("canceledBySystem")
               //  NetworkEngine.commonAlert(message: error.message(), vc: self)
            case .passcodeNotSet:
                 NetworkEngine.commonAlert(message: error.message(), vc: self)
            case .biometryNotAvailable:
                 NetworkEngine.commonAlert(message: error.message(), vc: self)
            case .biometryNotEnrolled:
                 NetworkEngine.commonAlert(message: error.message(), vc: self)
            case .biometryLockedout:
                 NetworkEngine.commonAlert(message: error.message(), vc: self)
            case .other:
                 NetworkEngine.commonAlert(message: error.message(), vc: self)
            }
        }
    }
}

