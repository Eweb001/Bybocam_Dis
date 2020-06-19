//
//  TermAndUseView.swift
//  Bybocam
//
//  Created by APPLE on 15/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit

class TermAndUseView: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    @IBAction func GoBack(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
