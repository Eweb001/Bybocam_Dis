//
//  InfluenceProfileCell.swift
//  Bybocam
//
//  Created by Eweb on 18/07/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class InfluenceProfileCell: UICollectionViewCell {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var backView: CardView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImg.layer.cornerRadius = self.profileImg.frame.height/2
        self.profileImg.clipsToBounds=true
        self.profileImg.contentMode = .scaleAspectFill
        // Initialization code
    }

}
