//
//  RecomenCollectionViewCell.swift
//  Bybocam
//
//  Created by APPLE on 11/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit

class RecomenCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var noVideoFound: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var mainCardView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var firstImg: UIImageView!
    @IBOutlet weak var secondImg: UIImageView!
    @IBOutlet weak var thirdImg: UIImageView!
    @IBOutlet weak var firstPlayBtn: UIButton!
    @IBOutlet weak var secndPlayBtn: UIButton!
    @IBOutlet weak var thirdPlayBtn: UIButton!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secndView: UIView!
    @IBOutlet weak var thirdView: UIView!
    
    @IBOutlet weak var play1: UIImageView!
    @IBOutlet weak var play2: UIImageView!
    @IBOutlet weak var play3: UIImageView!
    
    
    @IBOutlet weak var mainview1: UIView!
    @IBOutlet weak var mainview2: UIView!
    @IBOutlet weak var mainview3: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
