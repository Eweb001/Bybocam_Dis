//
//  ShowInflucProfileVC.swift
//  Bybocam
//
//  Created by Eweb on 18/07/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import IQKeyboardManager
import Alamofire
import SVProgressHUD
import CoreLocation
class ShowInflucProfileVC: UIViewController,CLLocationManagerDelegate {
    var ModelApiResponse:ViewUserProfile?
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var raceTF: UITextField!
    @IBOutlet weak var industryTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var descTxt: IQTextView!
    @IBOutlet weak var userName: UILabel!
    
    // Location Manager
       
       var locationManager:CLLocationManager!
       var newLat = "30.898"
       var newLong = "76.8778"
       var CurrentMainLocatin = ""
    
    var data:InfluncerDatum?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.userName.text = data?.infulenname
        self.addressTF.text = data?.address
        self.genderTF.text = data?.gender
        self.descTxt.text = data?.discription
        
        self.priceTF.text = data?.price
               self.industryTF.text = data?.industry
               self.raceTF.text = data?.race
        
        if let newImgg = data?.picture
                                   {
                                       let image_value = INFLUENCER_IMAGE_URL + newImgg
                                       print(image_value)
                                       let profile_img = URL(string: image_value)
                                       self.userImg.sd_setImage(with: profile_img, completed: nil)
                                       
                                   }

    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
        
    

    
}
