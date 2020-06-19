//
//  Profile1StTableViewCell.swift
//  Bybocam
//
//  Created by eWeb on 05/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit

class Profile1StTableViewCell: UITableViewCell {

    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        noDataLbl.isHidden = true
        
        collectionView.register(UINib(nibName: "ProfileTopCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileTopCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
noDataLbl.isHidden = true
        // Configure the view for the selected state
    }
    
}
