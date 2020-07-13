//
//  NewProfileViewController.swift
//  Bybocam
//
//  Created by eWeb on 05/11/19.
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

class NewProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var SlideView: ImageSlideshow!
    @IBOutlet weak var addvideoBtnOutlet: UIBarButtonItem!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var noOFFlowwerLbl: UILabel!
    
    
    var likeUnlikeApiRespose:AddSingleMsg?
    var POSTID = ""
    var LIKESTATUS = ""
    var apiResponse:AddVideoModel?
    var ModelApiResponse:ViewUserProfile?
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
    @IBOutlet weak var phoneLbl: UILabel!
    
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
        
        profileTable.estimatedRowHeight = 100
        profileTable.rowHeight = UITableView.automaticDimension
        profileTable.register(UINib(nibName: "ProfileGridTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileGridTableViewCell")
        profileTable.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        profileTable.register(UINib(nibName: "Profile2ndTableViewCell", bundle: nil), forCellReuseIdentifier: "Profile2ndTableViewCell")
        profileTable.register(UINib(nibName: "Profile1StTableViewCell", bundle: nil), forCellReuseIdentifier: "Profile1StTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.PlayVideomethodOfReceivedNotification(notification:)), name: Notification.Name("PlayVideoNotificationIdentifier"), object: nil)

        
         NotificationCenter.default.addObserver(self, selector: #selector(self.refreshProfileApi(notification:)), name: Notification.Name("refreshProfileApiProfilePage"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goCommentUserProfileView(notification:)), name: Notification.Name("FromUsergProfileCommentUserProfile"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.LikeUserListgoCommentUserProfileView(notification:)), name: Notification.Name("LikeUserListFromUsergProfileCommentUserProfile"), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.UserProfileReloadForUpdate(notification:)), name: Notification.Name("NewUserVCReloadForUpdate"), object: nil)
        
        
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
    //MARK:- go To Follower action
    
    @IBAction func goToFollower(_ sender: UIButton)
    {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FolloweViewController") as! FolloweViewController
        
        vc.userIDProfile = DEFAULT.value(forKey: "USER_ID") as! String
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- go To Following action
    
    
    @IBAction func goToFollowing(_ sender: UIButton)
    {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FollowingViewController") as! FollowingViewController
        
        vc.userIDProfile = DEFAULT.value(forKey: "USER_ID") as! String
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        print("did ReceiveMemory Warning")
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        SlideView.isHidden = true
        popupView.isHidden = true
        
        print("viewWillAppear in own profile")
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
    
    @objc func didTap()
    {
        SlideView.presentFullScreenController(from: self)
        
    }
    
    //MARK:- refresh Profile Api using notification
    
    @objc func refreshProfileApi(notification: Notification)
    {
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            ViewProfileApi()
        }
    }
    //MARK:- goCommentUserProfile using notification
    
    @objc func UserProfileReloadForUpdate(notification: Notification)
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
    
    @objc func goCommentUserProfileView(notification: Notification)
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
    //MARK:- goCommentUserProfile using notification
    
    @objc func LikeUserListgoCommentUserProfileView(notification: Notification)
    {
        print("notification data = \(notification)")
        
        
        if let dict = (notification.userInfo as? NSDictionary)
        {
            if let POSTID = dict.value(forKey: "POSTID") as? String
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostLikedUserVC") as! PostLikedUserVC
                
               // vc.userIDProfile = DEFAULT.value(forKey: "USER_ID") as! String
                
                vc.POSTID = POSTID
               // vc.USERID = DEFAULT.value(forKey: "USER_ID") as! String
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
     //MARK:- Play VideomethodO fReceivedNotification using notification
        
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
                         SlideView.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
                        
                        self.SlideView.isHidden = false
                         self.popupView.isHidden = false
                        
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
        
        let new = self.storyboard?.instantiateViewController(withIdentifier: "NewSettingViewController") as! NewSettingViewController
        self.navigationController?.pushViewController(new, animated: true)

    }
    
    @IBAction func cancelImgAct(_ sender: UIButton)
    {
        SlideView.delegate = nil
        SlideView.isHidden = true
        popupView.isHidden = true
    }
    @IBAction func Video(_ sender: UIBarButtonItem)
    {
        self.fromedit = "no"
        
        let alert = UIAlertController(title: nil, message: "Choose media", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))

            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallary()
            }))
        
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
  
            switch UIDevice.current.userInterfaceIdiom
            {
            case .pad:

            alert.popoverPresentationController?.permittedArrowDirections = .up
            default:
                break
            }
            self.present(alert, animated: true, completion: nil)
      
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.mediaTypes = ["public.movie"]
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.movie"]
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    func videoLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = ["public.movie"]
            self.present(imagePicker, animated: true, completion: nil)
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
    
    
    @objc func DeleteBtnAction(_ sender:UIButton)
    {
        let dict =  self.ModelApiResponse?.postData?.reversed()[sender.tag]
        print(sender.tag)
        
        self.POSTID = dict?.postId ?? "0"
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Delete this post?", preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
            
            if !NetworkEngine.networkEngineObj.isInternetAvailable()
            {
                
                NetworkEngine.showInterNetAlert(vc: self)
            }
            else
            {
                self.deletePostApi()
            }
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func goEditProfile(_ sender: UIButton)
    {
       
        var editing = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        self.navigationController?.pushViewController(editing, animated: true)
        
    }
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
                
                return self.ModelApiResponse?.postData?.count ?? 0//self.ViewPostArray.count
                
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
            
          let dict = self.ModelApiResponse?.postData?.reversed()[indexPath.row]
           
            cell.likBtn.tag = indexPath.row
            cell.likBtn.addTarget(self, action: #selector(LikeBtnAction), for: .touchUpInside)
            cell.likeListBtn.tag = indexPath.row
            cell.likeListBtn.addTarget(self, action: #selector(LikeBtnListAction), for: .touchUpInside)
            
            cell.deleteBtn.isHidden=false
            
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(DeleteBtnAction), for: .touchUpInside)
            
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
            
            cell.commentBtn.tag = indexPath.row
            cell.commentBtn.addTarget(self, action: #selector(CommentBtnAction), for: .touchUpInside)
            
            
            
            cell.plyBtn.tag = indexPath.row
            cell.plyBtn.addTarget(self, action: #selector(TablePlayVideo), for: .touchUpInside)
           
            
            let postType = dict?.postType
            if postType == "0"
            {
                cell.backgroundColor=UIColor.white
               // Image Zooming
                cell.plyBtn.isHidden = true
                cell.openImgAct.isHidden = false
                
                cell.openImgAct.tag = indexPath.row
                cell.openImgAct.addTarget(self, action: #selector(OpenImgBtn), for: .touchUpInside)
                DispatchQueue.global(qos: .userInitiated).async
                    {
                    if let newImgg = dict?.postImage
                    {
                        let image_value = Post_Base_URL + newImgg
                        print(image_value)
                        let profile_img = URL(string: image_value)
                        cell.mainProfileImg.sd_setImage(with: profile_img, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                     }
                }
            
            }
            else
            {
                cell.plyBtn.isHidden = false
                cell.openImgAct.isHidden = true
                cell.mainProfileImg.image = nil
           
               
               
                
                if let newImgg = dict?.postImageVideo
                {
                            if newImgg != ""
                            {
                                let image_value = Post_Base_URL + newImgg
                                print(image_value)
                                let profile_img = URL(string: image_value)!
                                
                                cell.videoPlayerItem = AVPlayerItem.init(url: profile_img)
                                cell.startPlayback()
                                
                        }
                    }
//                DispatchQueue.global(qos: .userInitiated).async
//                    {
//                        if let newImgg = dict?.postVideoThumbnailImg
//                        {
//                            let image_value = Post_Base_URL + newImgg
//                            print(image_value)
//                            let profile_img = URL(string: image_value)
//                            cell.mainProfileImg.sd_setImage(with: profile_img, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
//                        }
//                }
                
            }
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileGridTableViewCell") as! ProfileGridTableViewCell
            
            if self.ModelApiResponse != nil
            {
                cell.reloadCollection(postArray: self.ModelApiResponse!, vc: self)
            }
            
               cell.gridCollection.reloadData()
            
            
            
                print("Grid Table View")
            
            return cell
        }
    }
    @objc func OpenImgBtn(_ sender:UIButton)
    {
        var dataDict = self.ModelApiResponse?.postData?.reversed()[sender.tag]
        
        let postType1 = dataDict?.postType
        
            self.SlideView.isHidden = false
            self.popupView.isHidden = false
        
           
        var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.center = SlideView.center
        actInd.hidesWhenStopped = true
        actInd.style =
            UIActivityIndicatorViewStyle.whiteLarge
        SlideView.addSubview(actInd)
        actInd.startAnimating()
        
        
            if let newImgg = dataDict?.postImage
            {
                let image_value = Post_Base_URL + newImgg
                print(image_value)
                
              
                
                
                SlideView.activityIndicator = DefaultActivityIndicator(style: .gray, color: UIColor.red)
                SlideView.setImageInputs([AlamofireSource(urlString: image_value, placeholder: nil)!])
              //  SlideView.add
             
                SlideView.presentFullScreenController(from: self)
                 actInd.stopAnimating()
            }
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict = self.ModelApiResponse?.postData?[indexPath.row]
        
        
        let postType = dict?.postType
        
        if postType != "0"
        {
            if let  imageData = dict?.postImageVideo
            {
                if imageData != ""
                {
                    let baseUrl = Video_Base_URL + imageData
                    let url = URL(string: baseUrl)!
                    
                    
               
                    
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
    */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        if self.listSelected == "yes"
        {
            return 410
        }
        else
        {
            if ((self.ModelApiResponse?.postData?.count == 0) || (self.ModelApiResponse?.postData?.count == 1))
            {
                return 300
            }
            else
            {
                let height = (Double(self.ModelApiResponse?.postData?.count ?? 0)/2.0).rounded(.up)
                
                print("height rounded = \(height)")
                return (CGFloat(300*height))
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
        return 000000.1
    }
    //MARK:- Comment btn click
    
    
    
    @objc func CommentBtnAction(_ sender:UIButton)
    {
        
        print(sender.tag)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostCommentViewController") as! PostCommentViewController
       
        vc.userIDProfile = DEFAULT.value(forKey: "USER_ID") as! String
        let dict =  self.ModelApiResponse?.postData?.reversed()[sender.tag]
          vc.POSTID = dict?.postId ?? "0"
         vc.USERID = DEFAULT.value(forKey: "USER_ID") as! String
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:-Like list
    
    @objc func LikeBtnListAction(_ sender:UIButton)
    {
        
        print(sender.tag)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostLikedUserVC") as! PostLikedUserVC
        
        vc.userIDProfile = DEFAULT.value(forKey: "USER_ID") as! String
        let dict =  self.ModelApiResponse?.postData?.reversed()[sender.tag]
        vc.POSTID = dict?.postId ?? "0"
        vc.USERID = DEFAULT.value(forKey: "USER_ID") as! String
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    //MARK:- list Btn Action btn click
    
    
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
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            self.ViewProfileApi()
        }
        
        //self.profileTable.reloadData()
    }
    
    // VIEW PROFILE API
    
    func ViewProfileApi()
    {
        
//        var USERID = "4"
//        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
//        {
//            USERID = NewUSERid
//        }
//        let para = ["userId" : USERID]   as! [String : String]
//        print(para)
        
        
        //DEFAULT.set(forKey: "USER_ID")
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        let para = ["userId" : USERID,
                    "loginUserId" : USERID]   as! [String : String]
        print(para)
        
        
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
                            
                            let phoen = (self.ModelApiResponse?.data?[0].countryCode ?? "") + " " + (self.ModelApiResponse?.data?[0].phone ?? "")
                            self.phoneLbl.text = phoen
                            
                            
                            self.nameLbl.text = self.ModelApiResponse?.data?[0].userName
                            
                            if let newImgg = self.ModelApiResponse?.data?[0].userImage
                            {
                                let image_value = Image_Base_URL + newImgg
                                print(image_value)
                                let profile_img = URL(string: image_value)
                                self.mainUserImg.sd_setImage(with: profile_img, completed: nil)
                              //  self.mainUserImg.sd_setImage(with: profile_img, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                            }
                            if self.ModelApiResponse?.userVideos?.count  == 3
                            {
                              self.addvideoBtnOutlet.isEnabled = false
                              self.addvideoBtnOutlet.tintColor = UIColor.clear
                              self.addvideoBtnOutlet.title  = ""
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
                      
                        self.profileTable.reloadData()
                       
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
        var USERID = ""
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        
        let para = ["userId" : USERID,
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
                    if !NetworkEngine.networkEngineObj.isInternetAvailable()
                    {
                        
                        NetworkEngine.showInterNetAlert(vc: self)
                    }
                    else
                    {
                         self.ViewProfileApi()
                    }
                    
                   
                }
                
            }
            catch let error
            {
                print(error)
            }
            
        }
        
    }


    
    // Add 3 Videos Api
    
    func AddMediaAPI()
    {
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        
        var videoId2 = ""
        
        if fromedit == "yes"
        {
            videoId2 = self.videoId
        }
        else
        {
            videoId2 = "0"
        }
        let params:[String:String] = ["userId": USERID,
                                      "videoId":videoId2]
        
        print(params)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if self.videoURL2 != ""
            {
                var url = URL(string: self.videoURL2)!
                
                multipartFormData.append(url, withName: "addVideo", fileName: "\(Date().timeIntervalSince1970*10).mov", mimeType: "video/mov")
                
            }
            if self.pickedImageProduct != nil
            {
                multipartFormData.append(self.pickedImageProduct.jpegData(compressionQuality: 0.75)!, withName: "videoThumbnailimg", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
            
            for (key, value) in params
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:ADD_VIDEO_URL)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    self.callAPI = "yes"
                    
                    print(progress)
                    if progress.isFinished
                    {
                        SVProgressHUD.dismiss()
                    }
                    else
                    {
                        SVProgressHUD.show()
                    }
                })
                upload.responseJSON
                    { response in
                        print(response)
                        
                        if response.data != nil
                        {
                            do
                            {
                                ApiHandler.LOADERSHOW()
                                
                                let decoder = JSONDecoder()
                                
                                self.apiResponse = try decoder.decode(AddVideoModel.self, from: response.data!)
                                
                                if self.apiResponse?.code == "201"
                                {
                                    self.view.makeToast(self.apiResponse?.message)
                                    
                                    self.ViewProfileApi()
                                }
                                SVProgressHUD.dismiss()
                            }
                            catch let error
                            {
                                print(error)
                            }
                        }
                }
                break
                case .failure(let encodingError):
                SVProgressHUD.dismiss()
                print(encodingError)
                
            }
        }
    }
    // Delete Account Api here...
    
    func  deletePostApi()
    {
        SVProgressHUD.show()
        
        SVProgressHUD.setBorderColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(UIColor.black)
        
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        let para = ["userId" : USERID,
                    "postId" : self.POSTID ]   as! [String : String]
        print(para)
        
        
        ApiHandler.PostModelApiPostMethod(url: DELETE_VIDEO, parameters: para, Header: ["":""]) { (responsedata, error) in
            
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
                }
                
            }
            catch let error
            {
                print(error)
            }
            
        }
        
    }
    
    
    
    /*
    // Add 3 Videos Api

    func AddMediaAPI()
    {
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        
        var videoId2 = ""
        
        if fromedit == "yes"
        {
            videoId2 = self.videoId
        }
        else
        {
            videoId2 = "0"
        }
        let params:[String:String] = ["userId": USERID,
                                      "videoId":videoId2]
        
        print(params)
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        var alamoManager = Alamofire.SessionManager(configuration: configuration)
        alamoManager.upload(multipartFormData: { (multipartFormData) in
            
          if self.videoURL2 != ""
            {
                var url = URL(string: self.videoURL2)!
                
                multipartFormData.append(url, withName: "addVideo", fileName: "\(Date().timeIntervalSince1970*10).mov", mimeType: "video/mov")
                
            }
            for (key, value) in params
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:ADD_VIDEO_URL)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    self.callAPI = "yes"
                    
                    print(progress)
                    if progress.isFinished
                    {
                        SVProgressHUD.dismiss()
                    }
                    else
                    {
                        SVProgressHUD.show()
                    }
                })
                upload.responseJSON
                { response in
                    print(response)
                    
                    if response.data != nil
                    {
                        do
                        {
                            ApiHandler.LOADERSHOW()
                            
                            let decoder = JSONDecoder()
                            
                            self.apiResponse = try decoder.decode(AddVideoModel.self, from: response.data!)
                            
                            if self.apiResponse?.code == "201"
                            {
                                self.view.makeToast(self.apiResponse?.message)
                                
                                self.ViewProfileApi()
                            }
                            SVProgressHUD.dismiss()
                        }
                        catch let error
                        {
                            print(error)
                        }
                    }
                }
                break
                case .failure(let encodingError):
                SVProgressHUD.dismiss()
                print(encodingError)
                
            }
        }
    }
    
    */
    
    
}

//MARK: - UIImagePickerControllerDelegate

extension NewProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
     
        if let editing = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
//            let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            let imageUniqueName : Int64 = Int64(NSDate().timeIntervalSince1970 * 1000);
//            let filePath = docDir.appendingPathComponent("\(imageUniqueName).png");
//
//            do
//            {
//                if let pngImageData = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!.pngData()
//                {
//                    try pngImageData.write(to : filePath , options : .atomic)
//                    print(filePath)
//
//                }
//            }
//            catch
//            {
//                print("couldn't write image")
//            }
            self.pickedImageProduct=editing
        }
        else
        {
            if let selectedImage = info[.originalImage] as? UIImage
            {
                self.pickedImageProduct=selectedImage
            }
            else
            {
               videoURL = info[UIImagePickerController.InfoKey.mediaURL]as? NSURL
               
                self.videoURL2 = "\(info[UIImagePickerController.InfoKey.mediaURL]!)"
                
                do {
                    let asset = AVURLAsset(url: videoURL as! URL , options: nil)
                    let imgGenerator = AVAssetImageGenerator(asset: asset)
                    imgGenerator.appliesPreferredTrackTransform = true
                    let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                    let thumbnail = UIImage(cgImage: cgImage)
                    
                    self.pickedImageProduct=thumbnail
                    
                    

                }
                catch let error
                {
                    print("*** Error generating thumbnail: \(error.localizedDescription)")
                }
              
                if !NetworkEngine.networkEngineObj.isInternetAvailable()
                {
                    
                    NetworkEngine.showInterNetAlert(vc: self)
                }
                else
                {
                     self.AddMediaAPI()
                }
            }
         }
        
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}

extension  NewProfileViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return self.ModelApiResponse?.userVideos?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileTopCollectionViewCell", for: indexPath) as! ProfileTopCollectionViewCell
        
        let dict = self.ModelApiResponse?.userVideos?[indexPath.row]
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
        
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(EditVideo), for: .touchUpInside)
        
        return cell
  
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {

            return CGSize(width: 120, height: 80)
   
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSetionAt section: Int) -> CGFloat
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
        
        
        let dict = self.ModelApiResponse?.postData?.reversed()[sender.tag]
        
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
    
    
    @objc func EditVideo(_ sender:UIButton)
    {
        
        
                let alert:UIAlertController=UIAlertController(title: "Alert!", message: "Are you sure want to edit video?", preferredStyle: UIAlertController.Style.alert)
                let cameraAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default)
                {
                    UIAlertAction in
                   
                }
                let gallaryAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default)
                {
                    UIAlertAction in
                  
                  let dict = self.ModelApiResponse?.userVideos?[sender.tag]
                    
                    if let  id = dict?.id//value(forKey: "id") as? String
                    {
                      self.videoId = id
                    }
                    self.fromedit = "yes"
                    
                    self.chooseVideo()
                }
        
        
                alert.addAction(cameraAction)
                alert.addAction(gallaryAction)
        
                self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func chooseVideo()
    {
        let alert = UIAlertController(title: nil, message: "Choose media", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
     
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }


}

