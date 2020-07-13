//
//  PostLikedUserVC.swift
//  Bybocam
//
//  Created by eWeb on 03/07/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SVProgressHUD
import YPImagePicker
import AVFoundation
import AVKit
import Photos
import Toast_Swift
import iOSPhotoEditor
class PostLikedUserVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    //MARK:- for insta code
    var alamoManager: SessionManager?
    var MediaType = ""
    var selectedItems = [YPMediaItem]()
    let selectedImageV = UIImageView()
    let pickButton = UIButton()
    let resultsButton = UIButton()
    
    
    
    var POSTID = ""
    
    //------------------//------------------//------------------//
    
    @IBOutlet weak var messageTable: UITableView!
    @IBOutlet weak var sideRoundBtn: UIButton!
    @IBOutlet weak var nodataFoundLbl: UILabel!
    
    // Image Picker Delegate
    
    var failureApiArray = NSArray()
    var dataDict = NSDictionary()
    var imagePicker = UIImagePickerController()
    var choosenImage:UIImage!
    
    //
    
    var videoURL2:URL?
    var videoId = ""
    var fromedit = ""
    var SelectedPhoto = UIImage()
    var apiResponse:AddVideoModel?
    var GetFavUserModelData:GetFavouriteUserModel?
    var userIDProfile = ""
    var USERID = ""
    var RecomenApiResponse:ReccomendationModel?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        messageTable.delegate = self
        messageTable.dataSource = self
        messageTable.register(UINib(nibName: "FollowerTableViewCell", bundle: nil), forCellReuseIdentifier: "FollowerTableViewCell")
        nodataFoundLbl.isHidden = true
        
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            PostLikedUserApi()
        }
        
        
        // resultsButton.addTarget(self, action: #selector(showResults), for: .touchUpInside)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.GetFavUserModelData?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowerTableViewCell") as! FollowerTableViewCell
        
        let dict = GetFavUserModelData?.data?[indexPath.row]
        
        cell.userNameLbl.text = dict?.userName
        
        cell.messageLbl.text = dict?.email
        
        cell.locationLbl.text = dict?.phone
        
        DispatchQueue.global(qos: .userInitiated).async
            {
                if let newImgg = dict?.userImage
                {
                    let image_value = Image_Base_URL + newImgg
                    print(image_value)
                    let profile_img = URL(string: image_value)
                    cell.profileImg.sd_setImage(with: profile_img, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                }
        }
        
        
        
        return cell
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let Alett = UIAlertController(title: "Alert!", message: "Are you sure want to unblocked user?", preferredStyle: .alert)
        Alett.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            
        }))
        Alett.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            let dict = self.GetFavUserModelData?.data?[indexPath.row]
            
            self.USERID = dict?.userId ?? ""
            
            if !NetworkEngine.networkEngineObj.isInternetAvailable()
            {
                
                NetworkEngine.showInterNetAlert(vc: self)
            }
            else
            {
                self.PostLikedUserApi()
            }
            
        }))
        self.present(Alett, animated: true, completion:nil)
    }
    */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 110
    }
    
    
    
    func PostLikedUserApi()
    {
        SVProgressHUD.show()
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        
        let para = ["postId" : self.POSTID,
                    "userId" : USERID] as [String : String]
        print(para)
        
        ApiHandler.PostModelApiPostMethod(url: Post_LIKED_User, parameters: para, Header: [ : ]) { (respData, error) in
            
            do
            {
                let decoder = JSONDecoder()
                if respData != nil
                {
                    self.GetFavUserModelData =  try decoder.decode(GetFavouriteUserModel.self, from: respData!)
                    
                    if self.GetFavUserModelData?.status == "success"
                    {
                        self.nodataFoundLbl.isHidden = true
                        if self.GetFavUserModelData?.data?.count == 0
                        {
                            //                            self.noDataFoundLbl.isHidden = false
                        }
                        else
                        {
                            self.messageTable.reloadData()
                            
                            //                            self.noDataFoundLbl.isHidden = true
                        }
                    }
                    else
                    {
                        self.nodataFoundLbl.isHidden = false
                        self.view.makeToast("No Data Found.")
                    }
                    self.messageTable.reloadData()
                }
                else
                {
                    SVProgressHUD.dismiss()
                    print("Error")
                }
            }
            catch let error
            {
                print(error)
                
            }
        }
    }
    func PostLikedUserApi2()
    {
        
        SVProgressHUD.show()
        
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        let para = ["postId" : self.POSTID,
                    "userId" : self.USERID] as [String : String]
        print(para)
        
        ApiHandler.PostModelApiPostMethod(url: Post_LIKED_User, parameters: para, Header: [ : ]) { (respData, error) in
            
            do
            {
                let decoder = JSONDecoder()
                if respData != nil
                {
                    self.RecomenApiResponse =  try decoder.decode(ReccomendationModel.self, from: respData!)
                    
                    self.navigationController?.popViewController(animated: true)
                    if self.RecomenApiResponse?.status  == "success"
                    {
                        SVProgressHUD.dismiss()
                        
                        
                    }
                    
                    
                }
                else
                {
                    SVProgressHUD.dismiss()
                    
                    // self.view.makeToast(self.RecomenApiResponse?.message)
                    print("Error")
                }
            }
            catch let error
            {
                print(error)
                
                SVProgressHUD.dismiss()
                
            }
        }
    }
    
    
    @IBAction func goBack(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}


