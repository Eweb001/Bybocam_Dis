//
//  SettingHeaderCell.swift
//  Bybocam
//
//  Created by APPLE on 12/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit

class SettingHeaderCell: UITableViewCell {

    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userContact: UILabel!
    @IBOutlet weak var userDob: UILabel!
    @IBOutlet weak var editImgBtn: UIButton!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    
}
