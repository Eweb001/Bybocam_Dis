//
//  ReportProblemViewController.swift
//  Bybocam
//
//  Created by APPLE on 29/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit

class ReportProblemViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var subjectTF: UITextField!
    @IBOutlet weak var detailTf: UITextView!
    
    @IBOutlet weak var sendBtn: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    @IBAction func goBackAct(_ sender: UIBarButtonItem)
    {
    self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sendBtnTf(_ sender: Any)
    {
        
    }
    
}
