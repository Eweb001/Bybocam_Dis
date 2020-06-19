//
//  PerticularUserChat.swift
//  Bybocam
//
//  Created by APPLE on 13/12/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit

class PerticularUserChat: UIViewController {

    @IBOutlet weak var typeMsgTf: UITextField!
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var userNameView: UIView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        userNameView.layer.cornerRadius = 15
        userNameView.layer.borderWidth = 1
        userNameView.layer.borderColor = UIColor.darkGray.cgColor
        usernameTf.placeholderColor(UIColor.black)
        typeMsgTf.placeholderColor(UIColor.black)
        
       // usernameTf.text = userName
    }
    @IBAction func goBack(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sendMsgAct(_ sender: UIButton)
    {
        if usernameTf.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please select users to send message.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if typeMsgTf.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Message", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else
        {
            // self.SendMsgApi()
        }
    }
    
}
