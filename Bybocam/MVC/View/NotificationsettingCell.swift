//
//  NotificationsettingCell.swift
//  Bybocam
//
//  Created by eWeb on 18/06/20.
//  Copyright © 2020 eWeb. All rights reserved.
//
import UIKit

class NotificationsettingCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var ClickBtn: UIButton!
    @IBOutlet weak var switchBtn: UISwitch!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
}
