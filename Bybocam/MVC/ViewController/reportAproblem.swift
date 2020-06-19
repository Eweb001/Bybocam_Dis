//
//  reportAproblem.swift
//  Bybocam
//
//  Created by APPLE on 29/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit
import SVProgressHUD

class reportAproblem: UIViewController, UITextViewDelegate, UITextFieldDelegate
{

    @IBOutlet weak var headreView: UIView!
    @IBOutlet weak var sendBtnOutlet: UIButton!
    @IBOutlet weak var headreTf: UITextField!
    @IBOutlet weak var deatilTxt: UITextView!
    
    
    var ModelApiResponse:SignUpModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        headreTf.delegate = self
        deatilTxt.delegate = self
        deatilTxt.returnKeyType = .done
        
        headreTf.placeholderColor(UIColor.black)
        deatilTxt.text = "Type your message..."
        deatilTxt.textColor = UIColor.black
        
        headreView.layer.cornerRadius = 8
        headreView.layer.borderWidth = 1
        headreView.layer.borderColor = UIColor.darkGray.cgColor
        
        deatilTxt.layer.cornerRadius = 5
        deatilTxt.layer.borderWidth = 1
        deatilTxt.layer.borderColor = UIColor.darkGray.cgColor
      
        sendBtnOutlet.layer.shadowColor = UIColor.black.cgColor
        sendBtnOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        sendBtnOutlet.layer.masksToBounds = false
        sendBtnOutlet.layer.shadowRadius = 2.0
        sendBtnOutlet.layer.shadowOpacity = 0.5
        
    }
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.text == "Type your message..."
        {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if text == "\n"
        {
            textView.resignFirstResponder()
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView.text == ""
        {
            textView.text = "Type your message..."
            textView.textColor = UIColor.black
        }
    }
    
    // Send Report API........

    func sendReprtApi()
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
                    "reportTitle" : headreTf.text!,
                    "reportMessage" : deatilTxt.text!]   as! [String : String]
        print(para)
        
        
        
        ApiHandler.PostModelApiPostMethod(url: REPORT_PROBLEM_URL, parameters: para, Header: ["":""]) { (responsedata, error) in
            
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
                            self.navigationController?.popViewController(animated: true)
                            
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
    @IBAction func gobackAct(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sendAct(_ sender: UIButton)
    {
        if headreTf.text == ""
        {
          let alert = UIAlertController(title: "Alert", message: "Please type Title of report.", preferredStyle: .alert)
          let submitAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in})
          alert.addAction(submitAction)
          self.present(alert, animated: true, completion: nil)
        }
        else if deatilTxt.text == "Type your message..."
        {
           let alert = UIAlertController(title: "Alert", message: "Please type your message.", preferredStyle: .alert)
           let submitAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in})
           alert.addAction(submitAction)
           self.present(alert, animated: true, completion: nil)
        }
        else
        {
            if !NetworkEngine.networkEngineObj.isInternetAvailable()
            {
                
                NetworkEngine.showInterNetAlert(vc: self)
            }
            else
            {
                  self.sendReprtApi()
            }
            
          
        }
    }
}

