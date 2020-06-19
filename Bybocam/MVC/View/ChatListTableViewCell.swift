//
//  ChatListTableViewCell.swift
//  Bybocam
//
//  Created by APPLE on 12/12/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var labl: UILabel!
    
    @IBOutlet weak var btn2: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
