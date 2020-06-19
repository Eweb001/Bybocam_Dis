//
//  SettingRowTableViewCell.swift
//  Bybocam
//
//  Created by APPLE on 12/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit

class SettingRowTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var ClickBtn: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
}
