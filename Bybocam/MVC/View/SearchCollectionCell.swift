//
//  SearchCollectionCell.swift
//  Bybocam
//
//  Created by APPLE on 12/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit
import Photos
import Alamofire
import SDWebImage

import Foundation
import YPImagePicker
import SVProgressHUD
import AVFoundation
import AVKit


class SearchCollectionCell: UICollectionViewCell
{

    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var openImage: UIButton!
    @IBOutlet weak var playVideo: UIButton!
    @IBOutlet weak var playiconImg: UIImageView!
    
    var userVideosArray = NSMutableArray()
    var ViewPostArray = NSArray()
    var ModelApiResponse:ViewUserProfile?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
             
    }

}
