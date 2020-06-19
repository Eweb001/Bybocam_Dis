//
//  ViewUserProfileVC.swift
//  Bybocam
//
//  Created by eWeb on 02/12/19.
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
import ImageSlideshow
import AlamofireImage

class ViewUserProfileVC: UIViewController
{
    @IBOutlet weak var popupView: UIView!
     var newValue = "0"
    @IBOutlet weak var SlideView: ImageSlideshow!
    
    @IBOutlet weak var followBtn: UIBarButtonItem!
    var apiResponse:AddVideoModel?
    
    @IBOutlet weak var noDataLbl: UILabel!
    var RecomenApiResponse:ReccomendationModel?
    
    //MARK:- for show profile
    
    var ModelApiResponse:ViewUserProfile?
    
    var likeUnlikeApiRespose:AddSingleMsg?
    
    
    var POSTID = ""
    var LIKESTATUS = ""
    
    
    
    var USERID = ""
    
    var callAPI = "yes"
    var userVideosArray = NSMutableArray()
    var ViewPostArray = NSArray()
    
    // View Profile Array
    
    var ViewProfileDataDict = NSDictionary()
    var New_Name = ""
    var New_Email = ""
    var New_IMG = ""
    
    // Image Picker
    
    var videoURL : NSURL?
    var imageArray = NSMutableArray()
    var imageArray2 = NSMutableArray()
    var imagePicker = UIImagePickerController()
    var pickedImageProduct = UIImage()
    let myPickerview = UIPickerView()
    
    //
    
    var videoURL2 = ""
    var videoId = ""
    var fromedit = ""
    
    
    @IBOutlet weak var FollowersLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var PhoneLbl: UILabel!
    
    @IBOutlet weak var mainUserImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var NmbrOfPostLbl: UILabel!
    
    @IBOutlet weak var profileTable: UITableView!
    
    var listSelected = "yes"
    
    //MARK:- for video
    
    var aboutToBecomeInvisibleCell = -1
    var avPlayerLayer: AVPlayerLayer!
    var videoURLs = Array<URL>()
    var firstLoad = true
    
    
    var isFollowing = false
    
     @IBOutlet weak var noOFFlowwerLbl: UILabel!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        
        return refreshControl
    }()
    override func viewDidLoad()
    {
        super.viewDidLoad()
          self.profileTable.addSubview(refreshControl)
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            ViewProfileApi()
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(NewProfileViewController.didTap))
        SlideView.addGestureRecognizer(recognizer)
        
        popupView.isHidden = true
        SlideView.isHidden = true
        
        noDataLbl.isHidden = true
        profileTable.delegate = self
        profileTable.dataSource = self
        //  profileTable.prefetchDataSource = self
        
        profileTable.estimatedRowHeight = 100
        profileTable.rowHeight = UITableView.automaticDimension
        profileTable.register(UINib(nibName: "ProfileGridTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileGridTableViewCell")
        profileTable.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        profileTable.register(UINib(nibName: "Profile2ndTableViewCell", bundle: nil), forCellReuseIdentifier: "Profile2ndTableViewCell")
        profileTable.register(UINib(nibName: "Profile1StTableViewCell", bundle: nil), forCellReuseIdentifier: "Profile1StTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.PlayVideomethodOfReceivedNotification(notification:)), name: Notification.Name("PlayVideoNotificationIdentifier"), object: nil)
        
          NotificationCenter.default.addObserver(self, selector: #selector(self.ViewUserProfileVCCommentUserProfile(notification:)), name: Notification.Name("ViewUserProfileVCCommentUserProfile"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.ViewUserProfileVCReloadForUpdate(notification:)), name: Notification.Name("ViewUserProfileVCReloadForUpdate"), object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        SlideView.isHidden = true
        popupView.isHidden = true
        
        if isFollowing == true
        {
            self.followBtn.title = "Unfollow"
        }
        else
            
        {
           self.followBtn.title = "Follow"
        }
        if DEFAULT.value(forKey: "REFRESHPROFILEAPI") != nil
        {
            
            if !NetworkEngine.networkEngineObj.isInternetAvailable()
            {
                
                NetworkEngine.showInterNetAlert(vc: self)
            }
            else
            {
                ViewProfileApi()
            }
            
            print("will apper call")
            
            DEFAULT.removeObject(forKey: "REFRESHPROFILEAPI")
            DEFAULT.synchronize()
            
        }
        
    }
    @objc  func handleRefresh(_ refreshControl: UIRefreshControl)
    {
        
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            ViewProfileApi()
        }
        self.refreshControl.endRefreshing()
    }
    //MARK:- ViewUserProfileVCReloadForUpdate using notification
    
    @objc func ViewUserProfileVCReloadForUpdate(notification: Notification)
    {
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            self.listSelected = "no"
            ViewProfileApi()
        }
    }
    
    //MARK:- goCommentUserProfile using notification
    
    @objc func ViewUserProfileVCCommentUserProfile(notification: Notification)
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
    @IBAction func goToFollower(_ sender: UIButton)
    {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FolloweViewController") as! FolloweViewController
        vc.userIDProfile = self.USERID
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToFollowing(_ sender: UIButton)
    {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FollowingViewController") as! FollowingViewController
        vc.userIDProfile = self.USERID
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func didTap()
    {
        SlideView.presentFullScreenController(from: self)
        
    }
    
    @objc func PlayVideomethodOfReceivedNotification(notification: Notification)
    {
        print("notification data = \(notification)")
        
        
        if let dict = (notification.userInfo as? NSDictionary)
        {
            if let Type = dict.value(forKey: "Type") as? String
            {
                if Type == "i"
                {
                    if let url = dict.value(forKey: "url") as? String
                    {
                        self.SlideView.isHidden = false
                        self.popupView.isHidden = false
                        SlideView.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
                        
                        SlideView.setImageInputs([
                            
                            AlamofireSource(urlString: url, placeholder: #imageLiteral(resourceName: "loding"))!
                            ])
                        
                        
                        SlideView.presentFullScreenController(from: self)
                    }
                }
                else
                {
                    if let url = dict.value(forKey: "url") as? URL
                    {
                        let player = AVPlayer(url: url)
                        
                        let vc = AVPlayerViewController()
                        vc.player = player
                        
                        self.present(vc, animated: true)
                        {
                            vc.player?.play()
                            
                        }
                    }
                }
                
            }
        }
    }
    
    @IBAction func SettingBtnAct(_ sender: UIBarButtonItem)
    {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    @IBAction func cancelImgAct(_ sender: UIButton)
    {
        SlideView.delegate = nil
        SlideView.isHidden = true
        popupView.isHidden = true
    }
    
    //MARK:- follow action
    
    @IBAction func Video(_ sender: UIBarButtonItem)
    {

        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        var title = ""
        if self.isFollowing == true
        {
            
            title = "Unfollow"
        }
        else
        {
           title = "Follow"
        }
        let saveAction = UIAlertAction(title: title, style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Follow")
            
                    if !NetworkEngine.networkEngineObj.isInternetAvailable()
                    {
            
                        NetworkEngine.showInterNetAlert(vc: self)
                    }
                    else
                    {
                        if self.isFollowing == true
                        {
                            
                            
                            
                            
                            self.newValue = "0"
                            
                            self.isFollowing = false
                        }
                        else
            
                        {
                            self.newValue = "1"
                            
                            self.isFollowing = true
                        }
            
            
                        self.LikeuserApi()
                    }
            
            
        })
        
        let deleteAction = UIAlertAction(title: "Block User", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Block User")
            
            if !NetworkEngine.networkEngineObj.isInternetAvailable()
            {
                
                NetworkEngine.showInterNetAlert(vc: self)
            }
            else
            {

                
                self.BlockuserApi()
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
         optionMenu.addAction(saveAction)
        optionMenu.addAction(deleteAction)
       
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
        
    }
    
    @IBAction func goEditProfile(_ sender: UIButton)
    {
        
        let editing = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        self.navigationController?.pushViewController(editing, animated: true)
        
    }
   
    @objc func OpenImgBtn(_ sender:UIButton)
    {
        let dataDict = self.ModelApiResponse?.postData?.reversed()[sender.tag]
        

        
        self.SlideView.isHidden = false
        self.popupView.isHidden = false
        
        if let newImgg = dataDict?.postImage //dataDict.value(forKey: "postImage") as? String
        {
            let image_value = Post_Base_URL + newImgg
            print(image_value)
            // let profile_img = URL(string: image_value)
            
            SlideView.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
            
        
            SlideView.setImageInputs([
                
                AlamofireSource(urlString: image_value, placeholder: #imageLiteral(resourceName: "loding"))!
                ])
            
            SlideView.presentFullScreenController(from: self)
        }
    }

  

    //MARK:- like btn click
    
    
    
    @objc func LikeBtnAction(_ sender:UIButton)
    {
           let dict =  self.ModelApiResponse?.postData?.reversed()[sender.tag]
        print(sender.tag)
        self.POSTID = dict?.postId ?? "0"
        
        
        let likeStatus = dict?.isliked ?? "0"
        
        if likeStatus == "0"
        {
            self.LIKESTATUS = "1"
        }
        else
        {
            self.LIKESTATUS = "0"
        }
        
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            self.LikePostApi()
            
        }
    }
    
    
    
    
    //MARK:- Comment btn click
    
    
    
    @objc func CommentBtnAction(_ sender:UIButton)
    {
        
        print(sender.tag)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostCommentViewController") as! PostCommentViewController
       vc.userIDProfile = self.USERID
        
        let dict =  self.ModelApiResponse?.postData?.reversed()[sender.tag]
        vc.USERID = self.USERID
        vc.POSTID = dict?.postId ?? "0"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func listBtnAction(_ sender:UIButton)
    {
        
        print(sender.tag)
        
        if sender.tag == 0
        {
            self.listSelected = "yes"
        }
        else
        {
            self.listSelected = "no"
        }
        
        // DispatchQueue.main.async {
        self.profileTable.reloadData()
        //  }
        
    }
    
   
 
}

//MARK:-  API method

extension ViewUserProfileVC
{
    //MARK:-  VIEW PROFILE API
    
    func ViewProfileApi()
    {
        
//        let para = ["userId" : self.USERID]   as! [String : String]
//        print(para)
        
        var USERID2 = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID2 = NewUSERid
        }
        let para = ["userId" : self.USERID,
                    "loginUserId" : USERID2]   as! [String : String]
        
        ApiHandler.PostModelApiPostMethod(url: VIEW_USER_PROFILE_URL, parameters: para, Header: ["":""]) { (responsedata, error) in
            
            do
            {
                let decoder = JSONDecoder()
                
                if  responsedata != nil
                    
                {
                    self.ModelApiResponse = try decoder.decode(ViewUserProfile.self, from: responsedata!)
                    
                    if self.ModelApiResponse?.status == "success"
                    {
                        
                        if self.ModelApiResponse?.data?.count ?? 0>0
                        {
                            self.emailLbl.text = self.ModelApiResponse?.data?[0].email
                            
                            self.nameLbl.text = self.ModelApiResponse?.data?[0].userName
                            
                            let phoen = (self.ModelApiResponse?.data?[0].countryCode ?? "") + " " + (self.ModelApiResponse?.data?[0].phone ?? "")
                            self.PhoneLbl.text = phoen

                            
                            if let newImgg = self.ModelApiResponse?.data?[0].userImage
                                
                            {
                                let image_value = Image_Base_URL + newImgg
                                print(image_value)
                                let profile_img = URL(string: image_value)
                                self.mainUserImg.sd_setImage(with: profile_img, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                                
                            }
                        }
                        
                        let userLike = (self.ModelApiResponse?.totalfavouriteusers)!
                        let followers = (self.ModelApiResponse?.followers)!
                        self.noOFFlowwerLbl.text = "Followers: " + "\(followers)"
                        
                        self.NmbrOfPostLbl.text =  "\(userLike)"
                        
                        if self.ModelApiResponse?.postData?.count == 0
                        {
                            self.noDataLbl.isHidden = false
                            
                        }
                        else
                        {
                            self.noDataLbl.isHidden = true
                            
                        }
                        // DispatchQueue.main.async {
                        self.profileTable.reloadData()
                        //  }
                    }
                    else
                    {
                        self.profileTable.reloadData()
                    }
                }
                
            }
            catch let error
            {
                print(error)
            }
            
        }
        
    }
    
    //MARK:-  Like Post  API
    
    func LikePostApi()
    {
        var USERID2 = ""
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID2 = NewUSERid
        }
        
        let para = ["userId" : USERID2,
                    "postId" : self.POSTID ,
                    "likeStatus" : self.LIKESTATUS]
        print(para)
        
        ApiHandler.PostModelApiPostMethod(url: LIKE_POST, parameters: para, Header: ["":""]) { (responsedata, error) in
            
            do
            {
                let decoder = JSONDecoder()
                
                if  responsedata != nil
                    
                {
                    self.likeUnlikeApiRespose = try decoder.decode(AddSingleMsg.self, from: responsedata!)
                    
                    if self.likeUnlikeApiRespose?.status == "success"
                    {
                        self.view.makeToast(self.likeUnlikeApiRespose?.message)
                   
                       

                    }
                    else
                    {
                        self.profileTable.reloadData()
                    }
                    
                    self.ViewProfileApi()
                }
                
            }
            catch let error
            {
                print(error)
            }
            
        }
        
    }

    
    func LikeuserApi()
    {
        
        SVProgressHUD.show()
        
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        let para = ["senderId" : USERID,
                    "recevierId" : self.USERID,
                    "userLikeStatus" : self.newValue] as [String : String]
        print(para)
        
        ApiHandler.PostModelApiPostMethod(url: User_Like_URL, parameters: para, Header: [ : ]) { (respData, error) in
            
            do
            {
                let decoder = JSONDecoder()
                if respData != nil
                {
                    self.RecomenApiResponse =  try decoder.decode(ReccomendationModel.self, from: respData!)
                    
                    if self.RecomenApiResponse?.status  == "success"
                    {
                        SVProgressHUD.dismiss()
                        
                        //self.view.makeToast(self.RecomenApiResponse?.message)
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
    func BlockuserApi()
    {
        
        SVProgressHUD.show()
        
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        let para = ["loginId" : USERID,
                    "userId" : self.USERID] as [String : String]
        print(para)
        
        ApiHandler.PostModelApiPostMethod(url: BLOCK_USER_API, parameters: para, Header: [ : ]) { (respData, error) in
            
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
    
    
    
    
    
    
}


//MARK:- UICollection all method

extension  ViewUserProfileVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return  self.ModelApiResponse?.userVideos?.count ?? 0 //self.userVideosArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileTopCollectionViewCell", for: indexPath) as! ProfileTopCollectionViewCell
        
        let dict = self.ModelApiResponse?.userVideos?[indexPath.row]
      //  cell.img.image = nil
//        if let  imageData = dict?.videoThumbnailimg
//        {
//            if imageData != ""
//            {
//                cell.plyBtn.isHidden = false
//                let baseUrl =  Video_Base_URL + imageData
//                let url = URL(string: baseUrl)!
//                let player = AVPlayer(url: url)
//
//                let playerLayer = AVPlayerLayer(player: player)
//                playerLayer.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
//                player.isMuted=true
//                cell.videoPlayerSuperView.layer.addSublayer(playerLayer)
//                player.isMuted=true
//                player.playImmediately(atRate: 1.0)
//
//
//                     cell.img.sd_setImage(with: url, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
//
//                }
//
//
//            }
//
        cell.img.image = nil
        
        if let  imageData = dict?.videoName
        {
            if imageData != ""
            {
                cell.plyBtn.isHidden = false
                let baseUrl =  Video_Base_URL + imageData
                let url = URL(string: baseUrl)!
                let player = AVPlayer(url: url)
                
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
                player.isMuted=true
                cell.videoPlayerSuperView.layer.addSublayer(playerLayer)
                player.isMuted=true
                player.play()
            }
            
        }
        
        
        
        cell.plyBtn.tag = indexPath.row
        cell.plyBtn.addTarget(self, action: #selector(PlayVideo), for: .touchUpInside)
        
        cell.editBtn.isHidden = true
     
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: 120, height: 80)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 2
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage?
    {
        print("Thumbnail url = \(url)")
        
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    
    @objc func PlayVideo(_ sender:UIButton)
    {
        let dict = self.ModelApiResponse?.userVideos?[sender.tag]
        
        if let  imageData = dict?.videoName
        {
            if imageData != ""
            {
                let baseUrl = Video_Base_URL + imageData
                let url = URL(string: baseUrl)!
                
                
                // let url = URL(string: data)!
                
                let player = AVPlayer(url: url)
                
                let vc = AVPlayerViewController()
                vc.player = player
                
                self.present(vc, animated: true)
                {
                    vc.player?.play()
                    
                }
                
            }
            
        }
        
    }
    
    @objc func TablePlayVideo(_ sender:UIButton)
    {
        
        
        let dict =  self.ModelApiResponse?.postData?.reversed()[sender.tag]
      
        
        let postType = dict?.postType
        
        if postType == "0"
        {
            
            self.SlideView.isHidden = false
            self.popupView.isHidden = false
            
            if let newImgg = dict?.postImage
            {
                let image_value = Post_Base_URL + newImgg
                print(image_value)
                // let profile_img = URL(string: image_value)
                
            SlideView.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
                
                SlideView.setImageInputs([
                    
                    AlamofireSource(urlString: image_value, placeholder: #imageLiteral(resourceName: "loding"))!
                    ])
                
                
                SlideView.presentFullScreenController(from: self)
            }
            
        }
        else
        {
            self.SlideView.isHidden = true
            popupView.isHidden = true
            if let  imageData = dict?.postImageVideo
            {
                if imageData != ""
                {
                    let baseUrl = Post_Base_URL + imageData
                    let url = URL(string: baseUrl)!
                    
                    
                    // let url = URL(string: data)!
                    
                    let player = AVPlayer(url: url)
                    
                    let vc = AVPlayerViewController()
                    vc.player = player
                    
                    
                    
                    self.present(vc, animated: true)
                    {
                        vc.player?.play()
                        
                    }
                    print("to play url \(url)")
                    
                    
                    
                }
                
            }
        }
        
    }
    
    
   
    
    
    
}

//MARK:- UITableView all method




extension  ViewUserProfileVC : UITableViewDataSource,UITableViewDelegate

{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 0
        }
        else
        {
            if self.listSelected == "yes"
            {
                
                return self.ModelApiResponse?.postData?.count ?? 0
                
            }
            else
            {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Profile1StTableViewCell") as! Profile1StTableViewCell
            
            if self.ModelApiResponse?.userVideos?.count ?? 0>0
            {
                cell.noDataLbl.isHidden = true
            }
            else
            {
                cell.noDataLbl.isHidden = false
            }
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            return  cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Profile2ndTableViewCell") as! Profile2ndTableViewCell
            
            cell.listBtn.tag = 0
            cell.listBtn.addTarget(self, action: #selector(listBtnAction), for: .touchUpInside)
            cell.gridBtn.tag = 1
            cell.gridBtn.addTarget(self, action: #selector(listBtnAction), for: .touchUpInside)
            
            
            
            if self.listSelected == "yes"
            {
                cell.listBtn.setImage(#imageLiteral(resourceName: "List-with-yellow"), for: .normal)
                cell.gridBtn.setImage(#imageLiteral(resourceName: "Gray-with-Grid"), for: .normal)
            }
            else
            {
                cell.listBtn.setImage(#imageLiteral(resourceName: "list-with-Gray"), for: .normal)
                cell.gridBtn.setImage(#imageLiteral(resourceName: "LIST"), for: .normal)
            }
            
            return  cell
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if self.listSelected == "yes"
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
            
            cell.buttomView.isHidden = true
            cell.buttomConst.constant = 0
            
            let dict =  self.ModelApiResponse?.postData?.reversed()[indexPath.row]
            
            cell.likBtn.tag = indexPath.row
            cell.likBtn.addTarget(self, action: #selector(LikeBtnAction), for: .touchUpInside)
            
            cell.commentBtn.tag = indexPath.row
            cell.commentBtn.addTarget(self, action: #selector(CommentBtnAction), for: .touchUpInside)
            
            cell.plyBtn.tag = indexPath.row
            cell.plyBtn.addTarget(self, action: #selector(TablePlayVideo), for: .touchUpInside)
            // cell.plyBtn.isHidden = true
            
            let postType = dict?.postType
            
            let likeStatus = dict?.isliked
            
             let count = dict?.postLikeCount
            
            if count != nil
            {
                  cell.likeCout.text = "\(count!)"
            }
            let countCommt = dict?.postCommentsCounts
            
            if countCommt != nil
            {
                cell.commentCountLbl.text = "\(countCommt!)"
            }
            
            
            if likeStatus == "0"
            {
               cell.likeImg.image = #imageLiteral(resourceName: "blackHeart")
            }
            else
            {
                 cell.likeImg.image = #imageLiteral(resourceName: "like")
            }
            
            if postType == "0"
            {
                cell.backgroundColor=UIColor.white
                // Image Zooming
                cell.plyBtn.isHidden = true
                cell.openImgAct.tag = indexPath.row
                cell.openImgAct.addTarget(self, action: #selector(OpenImgBtn), for: .touchUpInside)
                DispatchQueue.global(qos: .userInitiated).async
                    {
                        if let newImgg = dict?.postImage
                            //dict.value(forKey: "postImage") as? String
                        {
                            let image_value = Post_Base_URL + newImgg
                            print(image_value)
                            let profile_img = URL(string: image_value)
                            cell.mainProfileImg.sd_setImage(with: profile_img, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                            // cell.mainProfileImg.kf.indicatorType = .activity
                            
                            // cell.mainProfileImg.kf.setImage(with: profile_img, placeholder: UIImage(named: "loding"), options: nil, progressBlock: nil, completionHandler: nil)
                        }
                }
                
            }
            else
            {
                cell.plyBtn.isHidden = false
             
                cell.mainProfileImg.image = nil
                // cell.mainProfileImg.isHidden = true
                
                //                DispatchQueue.global(qos: .background).async
                //                    {
                if let newImgg = dict?.postImageVideo //dict.value(forKey: "postImageVideo") as? String
                {
                    if newImgg != ""
                    {
                        let image_value = Post_Base_URL + newImgg
                        print(image_value)
                        let profile_img = URL(string: image_value)!
                        
                        cell.videoPlayerItem = AVPlayerItem.init(url: profile_img)
                        cell.startPlayback()
                        
                        //                                let player = AVPlayer(url: profile_img)
                        //
                        //                                let playerLayer = AVPlayerLayer(player: player)
                        //                                playerLayer.frame = cell.bounds
                        //
                        //                                cell.layer.addSublayer(playerLayer)
                        //                                player.play()
                        //
                        
                        
                        //  DispatchQueue.global(qos: .background).async
                        //                                {
                        //                                if let thumbnailImage = self.getThumbnailImage(forUrl: profile_img)
                        //                                {
                        //                                    cell.mainProfileImg.image = thumbnailImage
                        //                                }
                        //                                else
                        //                                {
                        //                                 cell.mainProfileImg.image = UIImage(named: "loding")
                        //                                }
                        //                            }
                    }
                }
                //}
            }
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileGridTableViewCell") as! ProfileGridTableViewCell
            
            // DispatchQueue.main.async
            if self.ModelApiResponse != nil
            {
                cell.reloadCollection(postArray: self.ModelApiResponse!, vc: self)
            }
            
            cell.gridCollection.reloadData()
            //}
            
            print("Grid Table View")
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        if self.listSelected == "yes"
        {
            return 350
        }
        else
        {
            if ((self.ModelApiResponse?.postData?.count == 0) || (self.ModelApiResponse?.postData?.count == 1))
            {
                return 220
            }
            else
            {
                let height = (Double(self.ModelApiResponse?.postData?.count ?? 0)/2.0).rounded(.up)
                
                print("height rounded = \(height)")
                return (CGFloat(220*height))
            }
            
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 80
        }
        else
        {
            return 48
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 1
    }
}



