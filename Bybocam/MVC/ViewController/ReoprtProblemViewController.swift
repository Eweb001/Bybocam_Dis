//
//  ReoprtProblemViewController.swift
//  Bybocam
//
//  Created by APPLE on 15/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit

class ReoprtProblemViewController: UIViewController
{

    @IBOutlet weak var enterSubTF: UITextField!
    @IBOutlet weak var enterSubView: UIView!
    @IBOutlet weak var detailTxtView: UITextView!
    @IBOutlet weak var sendBtnOutlet: UIButton!
    @IBOutlet weak var detailtextui: UIView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        enterSubTF.placeholderColor(UIColor.black)
        enterSubView.layer.cornerRadius = 8
        enterSubView.layer.borderWidth = 1
        enterSubView.layer.borderColor = UIColor.darkGray.cgColor
        
        sendBtnOutlet.layer.shadowColor = UIColor.black.cgColor
        sendBtnOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        sendBtnOutlet.layer.masksToBounds = false
        sendBtnOutlet.layer.shadowRadius = 2.0
        sendBtnOutlet.layer.shadowOpacity = 0.5
        
       
        detailtextui.layer.cornerRadius = 8
        detailtextui.layer.borderWidth = 1
        detailtextui.layer.borderColor = UIColor.darkGray.cgColor
    }
    @IBAction func sendBtnAct(_ sender: UIButton)
    {
        
    }
    @IBAction func GoBtnAct(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
