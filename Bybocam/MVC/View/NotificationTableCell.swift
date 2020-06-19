//
//  NotificationTableCell.swift
//  Bybocam
//
//  Created by APPLE on 15/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit

class NotificationTableCell: UITableViewCell
{

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var mainTextView: UITextView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
}
