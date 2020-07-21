//
//  PersonalVideoVC.swift
//  Bybocam
//
//  Created by Eweb on 16/07/20.
//  Copyright © 2020 eWeb. All rights reserved.
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
import MMPlayerView


class PersonalVideoVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate
{
    
    // @IBOutlet weak var slideView: ImageSlideshow!
    
    
    @IBOutlet weak var collectView: UICollectionView!
    
    @IBOutlet weak var collectView2: UICollectionView!
    
    @IBOutlet weak var collectView3: UICollectionView!
    
    @IBOutlet weak var noData1: UILabel!
    
    var value = "0"
    var POSTID = ""
    var LIKESTATUS = ""
    
    
    
    var likeUnlikeApiRespose:AddSingleMsg?
    var USERID = ""
    // SEARCHING ARRAY
    
    var ModelApiResponse:LoudVideoModel?
    
    var ModelApiResponse2:InfluencerModel?
    
    
    var LogoutApiResponse:SignUpModel?
    var mainArray = NSMutableArray()
    var searchedArray = NSMutableArray()
    var arrayToBeSearched = NSMutableArray()
    
    
    //MARK:- for video
    
    var avPlayer = AVPlayer()
    var avPlayerLayer = AVPlayerLayer()
    
    var offsetObservation: NSKeyValueObservation?
    lazy var mmPlayerLayer: MMPlayerLayer = {
        let l = MMPlayerLayer()
        l.cacheType = .memory(count: 5)
        l.coverFitType = .fitToPlayerView
        l.videoGravity = AVLayerVideoGravity.resizeAspect
        l.replace(cover: CoverA.instantiateFromNib())
        l.repeatWhenEnd = true
        return l
    }()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        collectView.delegate = self
        collectView.dataSource = self
        
        collectView.register(UINib(nibName: "LoudCollectionCell", bundle: nil), forCellWithReuseIdentifier: "LoudCollectionCell")
        
        collectView2.register(UINib(nibName: "InfluenceProfileCell", bundle: nil), forCellWithReuseIdentifier: "InfluenceProfileCell")
        
        collectView3.register(UINib(nibName: "AddsCCell", bundle: nil), forCellWithReuseIdentifier: "AddsCCell")
        
        
        
        
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.didTap))
        // slideView.addGestureRecognizer(recognizer)
        //slideView.isHidden = true
        
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            self.SearchPostApi()
            
            self.influencerApi()
        }
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        // slideView.isHidden = true
        
        if DEFAULT.value(forKey: "REFRESHPROFILEAPI") != nil
        {
            if !NetworkEngine.networkEngineObj.isInternetAvailable()
            {
                NetworkEngine.showInterNetAlert(vc: self)
            }
            else
            {
                self.SearchPostApi()
            }
            
            DEFAULT.removeObject(forKey: "REFRESHPROFILEAPI")
            DEFAULT.synchronize()
            
        }
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        pausePlayeVideos()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        print("Search ViewController did ReceiveMemory Warning")
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
    }
    
    
    @IBAction func seeMoreAct(_ sender: UIButton)
    {
        let sign = storyboard?.instantiateViewController(withIdentifier: "AllInfluencerVC") as! AllInfluencerVC
         DEFAULT.removeObject(forKey: "price")
        DEFAULT.removeObject(forKey: "race")
               DEFAULT.removeObject(forKey: "gender")
               DEFAULT.removeObject(forKey: "industry")
               DEFAULT.removeObject(forKey: "Infulenlatitude")
                  DEFAULT.removeObject(forKey: "Infulenlongitude")
               
               DEFAULT.synchronize()
        self.navigationController?.pushViewController(sign, animated: true)
    }
    @objc func didTap()
    {
        // slideView.presentFullScreenController(from: self)
    }
    @objc func textFieldDidChange(textfield: UITextField)
    {
        
    }
    @objc func textFieldDidEndEditing(_ textField: UITextField)
    {
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            self.SearchPostApi()
        }
        
    }
    @objc func searchTyping(_ textfield:UITextField)
    {
        print("textfield typing =  \(textfield.text!)")
        
        if (textfield.text == nil)
        {
            self.searchedArray.removeAllObjects()
        }
        else
        {
            if(self.searchedArray.count>=1)
            {
                self.searchedArray.removeAllObjects()
            }
            for  i in 0..<self.mainArray.count
            {
                var dic = NSDictionary();
                dic = self.mainArray[i] as! NSDictionary
                
                let data = "\(dic.value(forKey: "postImageVideo") as! String)"
                if ((data.range(of: textfield.text!, options: .caseInsensitive, range: nil, locale: nil)) != nil)
                {
                    self.searchedArray.add(dic)
                }
            }
        }
        
        collectView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == self.collectView
        {
            return self.ModelApiResponse?.data?.count ?? 0
        }
        else if collectionView == self.collectView2
        {
         let count = self.ModelApiResponse2?.data?.count ?? 0
            
            if count > 3
            {
                 return 3
            }
            else
            {
                return count
            }
          
        }
        else
        {
            return 10
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if collectionView == self.collectView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoudCollectionCell", for: indexPath) as! LoudCollectionCell
            
            let dict = self.ModelApiResponse?.data?.reversed()[indexPath.row]
            
            cell.descpLbl.text = (dict?.discriptions ?? "")
            
            cell.userNameLbl.text = (dict?.firstName ?? "") + " " + (dict?.lastName ?? "")
            cell.playVideo.tag = indexPath.item
            cell.playVideo.isHidden = true
            if let newImgg = dict?.videoImage
            {
                if newImgg != ""
                {
                    cell.playVideo.isHidden = true
                    cell.openImage.isHidden = false
                    
                    let image_value = RANDOM_Base_URL + newImgg
                    print(image_value)
                    let profile_img = URL(string: image_value)!
                    DispatchQueue.global(qos: .userInitiated).async
                        {
                            cell.mainImg.sd_setImage(with: profile_img, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                    }
                }
            }
            cell.playVideo.isHidden = false
            cell.playVideo.tag = indexPath.row
            cell.playVideo.addTarget(self, action: #selector(CollectionPlayVideo), for: .touchUpInside)
            
            
            
            return cell
            
            
        }
        else if collectionView == self.collectView2
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfluenceProfileCell", for: indexPath) as! InfluenceProfileCell
            
            let dict = self.ModelApiResponse2?.data?.reversed()[indexPath.row]
            
            cell.namelbl.text = (dict?.infulenname ?? "")
            
            cell.priceLbl.text = "$ "+(dict?.price ?? "")
            if let newImgg = dict?.picture
            {
                if newImgg != ""
                {
                
                    
                    let image_value = INFLUENCER_IMAGE_URL + newImgg
                    print(image_value)
                    let profile_img = URL(string: image_value)!
                    DispatchQueue.global(qos: .userInitiated).async
                        {
                            cell.profileImg.sd_setImage(with: profile_img, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                    }
                }
            }
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddsCCell", for: indexPath) as! AddsCCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectView2
        {
            let sign = storyboard?.instantiateViewController(withIdentifier: "ShowInflucProfileVC") as! ShowInflucProfileVC
                  let dict = self.ModelApiResponse2?.data?.reversed()[indexPath.row]
                   
            sign.data = dict
            
            self.navigationController?.pushViewController(sign, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
    
    
    
    //  @objc func OpenImgBtn(_ sender:UIButton)
    //    {
    //        let dataDict = self.ModelApiResponse?.data?.reversed()[sender.tag]
    //
    //        let postType1 = dataDict?.postType
    //
    //        self.slideView.isHidden = false
    //
    //        if let newImgg = dataDict?.postImage
    //        {
    //            let image_value = Post_Base_URL + newImgg
    //            print(image_value)
    //
    //            slideView.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    //
    //            slideView.setImageInputs([
    //
    //            AlamofireSource(urlString: image_value, placeholder: #imageLiteral(resourceName: "loding"))!])
    //
    //            slideView.presentFullScreenController(from: self)
    //        }
    //    }
    func getThumbnailImage(forUrl url: URL) -> UIImage?
    {
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
    @objc func CollectionPlayVideo(_ sender:UIButton)
    {
        let dict = self.ModelApiResponse?.data?.reversed()[sender.tag]
        if let  imageData = dict?.videoName
        {
            
            if imageData != ""
            {
                let baseUrl = RANDOM_Base_URL + imageData
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
    
    @IBAction func goBack(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK:- like btn click
    
    
    
    // @objc func LikeBtnAction(_ sender:UIButton)
    //    {
    //        let dict =  self.ModelApiResponse?.data?.reversed()[sender.tag]
    //        print(sender.tag)
    //        self.POSTID = dict?.postId ?? "0"
    //
    //
    //        let likeStatus = dict?.isliked ?? "0"
    //
    //        if likeStatus == "0"
    //        {
    //            self.LIKESTATUS = "1"
    //        }
    //        else
    //        {
    //            self.LIKESTATUS = "0"
    //        }
    //
    //        if !NetworkEngine.networkEngineObj.isInternetAvailable()
    //        {
    //
    //            NetworkEngine.showInterNetAlert(vc: self)
    //        }
    //        else
    //        {
    //            self.LikePostApi()
    //
    //        }
    //    }
    
    
    
    
    //MARK:- Comment btn click
    
    
    
    //  @objc func CommentBtnAction(_ sender:UIButton)
    //    {
    //
    //        print(sender.tag)
    //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostCommentViewController") as! PostCommentViewController
    //        vc.userIDProfile = self.USERID
    //
    //        let dict =  self.ModelApiResponse?.data?.reversed()[sender.tag]
    //        vc.USERID = self.USERID
    //        vc.POSTID = dict?.postId ?? "0"
    //        self.navigationController?.pushViewController(vc, animated: true)
    //    }
    
    
    
    
    
    @IBAction func cancelAct(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action: UIAlertAction!) in
            if !NetworkEngine.networkEngineObj.isInternetAvailable()
            {
                
                NetworkEngine.showInterNetAlert(vc: self)
            }
            else
            {
                self.LogoutApi()
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // Logout Api here...
    
    func LogoutApi()
    {
        
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        let para = ["userId" : USERID]   as! [String : String]
        print(para)
        
        
        ApiHandler.PostModelApiPostMethod(url: LOGOUT_URL, parameters: para, Header: ["":""]) { (responsedata, error) in
            
            do
            {
                let decoder = JSONDecoder()
                
                if  responsedata != nil
                    
                {
                    self.LogoutApiResponse = try decoder.decode(SignUpModel.self, from: responsedata!)
                    
                    if self.LogoutApiResponse?.status == "success"
                    {
                        print("Success")
                        SVProgressHUD.dismiss()
                        
                        DEFAULT.removeObject(forKey: "Email")
                        DEFAULT.removeObject(forKey: "USER_ID")
                        self.view.makeToast("You have logout successfully.!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            //                            let v = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                            //                            self.navigationController?.pushViewController(v!, animated: true)
                            APPDEL.loginPage()
                        })
                        
                        
                        
                    }
                    else
                    {
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Alert", message: self.LogoutApiResponse?.message, preferredStyle: .alert)
                        let submitAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in})
                        alert.addAction(submitAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
            catch let error
            {
                print(error)
            }
            
        }
    }
    
    ///////////////////////////        SEARCH   POST API
    
    func SearchPostApi()
    {
        
        SVProgressHUD.show()
        
        var USERID = "3"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        
        let para = ["userId" : USERID]
        
        print("Home para \(para)")
        
        ApiHandler.PostModelApiPostMethod(url: LOUD_POST_URL, parameters: para, Header: [ : ]) { (responsedata, error) in
            
            do
            {
                let decoder = JSONDecoder()
                
                if  responsedata != nil
                {
                    self.ModelApiResponse = try decoder.decode(LoudVideoModel.self, from: responsedata!)
                    
                    if self.ModelApiResponse?.status == "success"
                    {
                        
                        
                        self.collectView.reloadData()
                        
                        
                    }
                    else
                    {
                        print("Error")
                        // self.view.makeToast(self.ModelApiResponse?.message)
                        
                        print(error)
                        self.collectView.reloadData()
                    }
                    let count = self.ModelApiResponse?.data?.count ?? 0
                    if count == 0
                    {
                        self.noData1.isHidden=false
                    }
                    else
                    {
                       self.noData1.isHidden=true
                    }
                }
                
            }
            catch let error
            {
                print(error)
                SVProgressHUD.dismiss()
                print(error)
            }
            
        }
    }
    
    //MARK:- influencer API
    func influencerApi()
    {
        
        SVProgressHUD.show()
        
        var USERID = "3"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        
        let para = ["id" : USERID]
        
        print("Home para \(para)")
        
        ApiHandler.PostModelApiPostMethod(url: INFLUENCER_PROFILE_User, parameters: para, Header: [ : ]) { (responsedata, error) in
            
            do
            {
                let decoder = JSONDecoder()
                
                if  responsedata != nil
                {
                    self.ModelApiResponse2 = try decoder.decode(InfluencerModel.self, from: responsedata!)
                    
                    if self.ModelApiResponse2?.status == "success"
                    {
                        
                        
                        self.collectView2.reloadData()
                        
                        
                    }
                    else
                    {
                        print("Error")
                        // self.view.makeToast(self.ModelApiResponse?.message)
                        
                        print(error)
                        self.collectView2.reloadData()
                    }
                }
                
            }
            catch let error
            {
                print(error)
                SVProgressHUD.dismiss()
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
                        self.collectView.reloadData()
                    }
                    
                    self.SearchPostApi()
                }
                
            }
            catch let error
            {
                print(error)
            }
            
        }
        
    }
    
}





extension  PersonalVideoVC :UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        //  return CGSize(width: (UIScreen.main.bounds.width/2)-18, height: (UIScreen.main.bounds.height/5)-22 )
        // return CGSize(width: (UIScreen.main.bounds.width/2)-4, height: 240 )
        
        // return CGSize(width: (UIScreen.main.bounds.width/2)-18, height: 140 )
        
        var height: CGFloat = 240
        
        //we are just measuring height so we add a padding constant to give the label some room to breathe!
        var padding: CGFloat = 8
        
        //estimate each cell's height
        //        let dict = self.ModelApiResponse?.data?.reversed()[indexPath.row]
        //
        //
        //
        //        if let text = dict?.discriptions
        //           {
        //            height = estimateFrameForText(text: text).height + 240
        //           }
        
        if collectionView == self.collectView
        {
            return CGSize(width: (UIScreen.main.bounds.width/2)-30, height: 300)
        }
        else
        {
            return CGSize(width: (UIScreen.main.bounds.width/2)-30, height: 180)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    private func estimateFrameForText(text: String) -> CGRect
    {
        //we make the height arbitrarily large so we don't undershoot height in calculation
        let height: CGFloat = 240
        
        let size = CGSize(width: (UIScreen.main.bounds.width/2)-4, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
    
}

extension PersonalVideoVC
{
    func pausePlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: collectView)
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: collectView, appEnteredFromBackground: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            pausePlayeVideos()
        }
    }
}
