//
//  NotificationViewController.swift
//  Bybocam
//
//  Created by eWeb on 08/01/20.
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
class NotificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    //MARK:- for insta code
    var alamoManager: SessionManager?
    var MediaType = ""
    var selectedItems = [YPMediaItem]()
    let selectedImageV = UIImageView()
    let pickButton = UIButton()
    let resultsButton = UIButton()
    
    
    
    
    
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
    var apiNotificationModel:NotificationModel?
    var userIDProfile = ""
    
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
            followerUserApi()
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.FromFolloweViewController(notification:)), name: Notification.Name("FromFolloweViewController"), object: nil)
        // resultsButton.addTarget(self, action: #selector(showResults), for: .touchUpInside)
        
    }
    //MARK:- goCommentUserProfile using notification
    
    @objc func FromFolloweViewController(notification: Notification)
    {
        print("notification data = \(notification)")
        
        
        if let dict = (notification.userInfo as? NSDictionary)
        {
            if let POSTID = dict.value(forKey: "POSTID") as? String
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostCommentViewController") as! PostCommentViewController
                
                vc.userIDProfile = DEFAULT.value(forKey: "USER_ID") as! String
                
                vc.POSTID = POSTID
                vc.USERID = DEFAULT.value(forKey: "USER_ID") as! String
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.apiNotificationModel?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowerTableViewCell") as! FollowerTableViewCell
        
        let dict = self.apiNotificationModel?.data?[indexPath.row]
        
         let userDataCount = dict?.userData?.count
        
        if userDataCount ?? 0 > 0
            {
                cell.userNameLbl.text = dict?.userData?[0].userName
                DispatchQueue.global(qos: .userInitiated).async
                    {
                        if let newImgg = dict?.userData?[0].userImage
                        {
                            let image_value = Image_Base_URL + newImgg
                            print(image_value)
                            let profile_img = URL(string: image_value)
                            cell.profileImg.sd_setImage(with: profile_img, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                        }
                }
            }
        
        
        
        
        cell.messageLbl.text = dict?.title
        
        cell.locationLbl.text = dict?.descriptionField
        
        
       
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FollowerUserViewController") as! FollowerUserViewController
        
        
        let indexData = self.apiNotificationModel?.data?[indexPath.row]
        
        vc.USERID = indexData?.senderId ?? "9"
         
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 110
    }
    
    
    
    func followerUserApi()
    {
        SVProgressHUD.show()
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        
        let para = ["userId" : USERID] as [String : AnyObject]
        print(para)
        
        ApiHandler.PostModelApiPostMethod(url: GET_ALL_NOTIFICATION, parameters: para, Header: [ : ]) { (respData, error) in
            
            do
            {
                let decoder = JSONDecoder()
                if respData != nil
                {
                    self.apiNotificationModel =  try decoder.decode(NotificationModel.self, from: respData!)
                    
                    if self.apiNotificationModel?.status == "success"
                    {
                        self.nodataFoundLbl.isHidden = true
                        if self.apiNotificationModel?.data?.count == 0
                        {
                         
                        }
                        else
                        {
                            self.messageTable.reloadData()
                        
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
    
    
    @IBAction func goBack(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}


