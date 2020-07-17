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
    
    @IBOutlet weak var slideView: ImageSlideshow!

  
    @IBOutlet weak var collectView: UICollectionView!
    var value = "0"
    var POSTID = ""
    var LIKESTATUS = ""
    
  
    
    var likeUnlikeApiRespose:AddSingleMsg?
    var USERID = ""
    // SEARCHING ARRAY
    
    var ModelApiResponse:LoudVideoModel?
    
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
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.didTap))
        slideView.addGestureRecognizer(recognizer)
        slideView.isHidden = true
        
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
           NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            self.SearchPostApi()
        }
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        slideView.isHidden = true
        
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
  
    
    @objc func didTap()
    {
        slideView.presentFullScreenController(from: self)
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
        return self.ModelApiResponse?.data?.count ?? 0//searchedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoudCollectionCell", for: indexPath) as! LoudCollectionCell
        
        let dict = self.ModelApiResponse?.data?.reversed()[indexPath.row]
        
        
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

//                                    let player = AVPlayer(url: profile_img)
//                                    let playerLayer = AVPlayerLayer(player: player)
//                                    playerLayer.frame = CGRect(x: 0, y: 0, width: cell.videoPlayerSuperView.frame.width, height: cell.videoPlayerSuperView.frame.height)
//
//                                    cell.videoPlayerSuperView.layer.addSublayer(playerLayer)
//        //                            cell.layer.addSublayer(playerLayer)
//                                    player.isMuted=true
//                                    player.play()

                                }



                            }
                    cell.playVideo.isHidden = false
                    cell.playVideo.tag = indexPath.row
                    cell.playVideo.addTarget(self, action: #selector(CollectionPlayVideo), for: .touchUpInside)
        
        /*
        cell.plyBtn.tag = indexPath.item
        cell.plyBtn.isHidden = true
        
        cell.likBtn.tag = indexPath.row
        cell.likBtn.addTarget(self, action: #selector(LikeBtnAction), for: .touchUpInside)
        
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




        
        
        let postType = dict?.postType
        if postType == "0"
        {
            
           cell.gridCollectImgg.image = #imageLiteral(resourceName: "loding")
    
            if let newImgg = dict?.postImage
            {
                cell.plyBtn.isHidden = true
                
                cell.OpenImgBtn.isHidden = false
                
                //cell.videoPlayerSuperView.backgroundColor = UIColor.white
                
                let image_value = Post_Base_URL + newImgg
                print(image_value)
//                DispatchQueue.global(qos: .userInitiated).async
//                                   {
//                cell.configureCell(imageUrl: image_value, description: "Image", videoUrl: nil)
//                }
                let profile_img = URL(string: image_value)
                DispatchQueue.global(qos: .userInitiated).async
                    {
                        cell.gridCollectImgg.sd_setImage(with: profile_img, placeholderImage: #imageLiteral(resourceName: "loding"), options: .refreshCached, context: nil)
                }
                cell.OpenImgBtn.tag = indexPath.row
                cell.OpenImgBtn.addTarget(self, action: #selector(OpenImgBtn), for: .touchUpInside)
                
            }
 
        }
        else
        {
            
            cell.plyBtn.isHidden = false
            cell.OpenImgBtn.isHidden = true
            cell.gridCollectImgg.image = nil
            
//            if let newImgg = dict?.postImageVideo
//            {
//                if newImgg != ""
//                {
//                    let image_value = Post_Base_URL + newImgg
//                    print(image_value)
//           // let profile_img = URL(string: image_value)!
//                    cell.configureCell(imageUrl: image_value, description: "Video", videoUrl: image_value)
//                }
//            }
//
            
        
            
         //   if let newImgg = dict?.postImageVideo
//                        {
//                            if newImgg != ""
//                            {
//                                let image_value = Post_Base_URL + newImgg
//                                print(image_value)
//                                if let newImgg2 = dict?.postVideoThumbnailImg
//                                                    {
//                                        if newImgg2 != ""
//                    {
//
//                        let image_value2 = Post_Base_URL + newImgg2
//                        cell.configureCell(imageUrl: image_value2, description: "Video", videoUrl: image_value)
//                            }
//                                }
//                                else
//                                {
//                                   cell.configureCell(imageUrl: image_value, description: "Video", videoUrl: image_value)
//                                }
//
//
//
//
//
////                                mmPlayerLayer.thumbImageView.image = cell.gridCollectImgg.image
////                                // set video where to play
////                                let profile_img = URL(string: image_value)!
////                                mmPlayerLayer.playView = cell.gridCollectImgg
////                                mmPlayerLayer.set(url: profile_img)
////                                self.mmPlayerLayer.resume()
//
//
//                               // let profile_img = URL(string: image_value)!
////                                let item = AVPlayerItem(url: URL(string: image_value)!)
////
////                                self.avPlayer = AVPlayer(playerItem: item)
////                                self.avPlayer.actionAtItemEnd = .none
////
////                                self.avPlayerLayer = AVPlayerLayer(player: self.avPlayer)
////                                self.avPlayerLayer.videoGravity = .resizeAspectFill
////                                self.avPlayerLayer.frame = CGRect(x: 0, y: 0, width: cell.videoPlayerSuperView.frame.size.width, height: cell.videoPlayerSuperView.frame.size.height / 2)
////
////                                cell.videoPlayerSuperView.layer.addSublayer(self.avPlayerLayer)
////
////                                self.avPlayer.play()
//                            }
//            }
           
 
            
            
            
            
            //if let newImgg = dict?.postImageVideo
//            {
//                if newImgg != ""
//                {
//                    let image_value = Post_Base_URL + newImgg
//                    print(image_value)
//                    let profile_img = URL(string: image_value)!
//
//                    DispatchQueue.main.async {
//                        cell.videoPlayerItem = AVPlayerItem.init(url: profile_img)
//                        cell.startPlayback()
//
//                    }
//
//
//                }
//            }
            
                    if let newImgg = dict?.postVideoThumbnailImg
                    {
                        if newImgg != ""
                        {
                            cell.plyBtn.isHidden = false
                            cell.OpenImgBtn.isHidden = true

                          //  cell.gridCollectImgg.isHidden = true
                            let image_value = Post_Base_URL + newImgg
                            print(image_value)
                            let profile_img = URL(string: image_value)!
                            DispatchQueue.global(qos: .userInitiated).async
                                {
                                    cell.gridCollectImgg.sd_setImage(with: profile_img, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                            }

                            let player = AVPlayer(url: profile_img)
                            let playerLayer = AVPlayerLayer(player: player)
                            playerLayer.frame = CGRect(x: 0, y: 0, width: cell.videoPlayerSuperView.frame.width, height: cell.videoPlayerSuperView.frame.height)

                            cell.videoPlayerSuperView.layer.addSublayer(playerLayer)
//                            cell.layer.addSublayer(playerLayer)
                            player.isMuted=true
                            player.play()

                        }



                    }
            cell.plyBtn.isHidden = false
            cell.plyBtn.tag = indexPath.row
            cell.plyBtn.addTarget(self, action: #selector(CollectionPlayVideo), for: .touchUpInside)
 
        }
        */
       
        return cell
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




//extension SearchViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//       // let m = min((UIScreen.main.bounds.size.width/2)-18, UIScreen.main.bounds.size.height)
//
//       return CGSize(width: (UIScreen.main.bounds.width/2)-24, height: (UIScreen.main.bounds.height/5)-22 )
//        //return CGSize(width: m/2, height: m*0.75)
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        DispatchQueue.main.async { [unowned self] in
//            if self.presentedViewController != nil || self.mmPlayerLayer.isShrink == true {
//                self.collectView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
//                self.updateDetail(at: indexPath)
//            } else {
//                self.presentDetail(at: indexPath)
//            }
//        }
//    }
//
//    fileprivate func updateByContentOffset() {
//        if mmPlayerLayer.isShrink {
//            return
//        }
//
//        if let path = findCurrentPath(),
//            self.presentedViewController == nil {
//            self.updateCell(at: path)
//            //Demo SubTitle
//            if path.row == 0, self.mmPlayerLayer.subtitleSetting.subtitleType == nil {
//                let subtitleStr = Bundle.main.path(forResource: "srtDemo", ofType: "srt")!
//                if let str = try? String.init(contentsOfFile: subtitleStr) {
//                    self.mmPlayerLayer.subtitleSetting.subtitleType = .srt(info: str)
//                    self.mmPlayerLayer.subtitleSetting.defaultTextColor = .red
//                    self.mmPlayerLayer.subtitleSetting.defaultFont = UIFont.boldSystemFont(ofSize: 20)
//                }
//            }
//        }
//    }
//
//    fileprivate func updateDetail(at indexPath: IndexPath) {
////        let value = DemoSource.shared.demoData[indexPath.row]
////        if let detail = self.presentedViewController as? DetailViewController {
////            detail.data = value
////        }
////
////        self.mmPlayerLayer.thumbImageView.image = value.image
////        self.mmPlayerLayer.set(url: DemoSource.shared.demoData[indexPath.row].play_Url)
//        self.mmPlayerLayer.resume()
//
//    }
//
//    fileprivate func presentDetail(at indexPath: IndexPath) {
//        self.updateCell(at: indexPath)
//        mmPlayerLayer.resume()
////
////        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
////            vc.data = DemoSource.shared.demoData[indexPath.row]
////            self.present(vc, animated: true, completion: nil)
////            //            self.navigationController?.pushViewController(vc, animated: true)
////        }
//    }
//
//    fileprivate func updateCell(at indexPath: IndexPath)
//    {
//        if let cell = collectView.cellForItem(at: indexPath) as? ProfileGridCollectionViewCell
//        {
//            let dict = self.ModelApiResponse?.postData?.reversed()[indexPath.row]
//            let postType = dict?.postType
//
//            if postType == "1"
//            {
//                if let newImgg = dict?.postImageVideo
//                {
//                    if newImgg != ""
//                    {
//                        let image_value = Post_Base_URL + newImgg
//                        print(image_value)
//
//                        let playURL = URL(string: image_value)!
//
//                        mmPlayerLayer.thumbImageView.image = cell.gridCollectImgg.image
//                        // set video where to play
//                        mmPlayerLayer.playView = cell.gridCollectImgg
//                        mmPlayerLayer.set(url: playURL)
//                    }
//                }
//
//            }
//
//            // this thumb use when transition start and your video dosent start
//
//        }
//    }
//
//    @objc fileprivate func startLoading() {
//        self.updateByContentOffset()
//        if self.presentedViewController != nil {
//            return
//        }
//        // start loading video
//        mmPlayerLayer.resume()
//    }
//
//    private func findCurrentPath() -> IndexPath? {
//        let p = CGPoint(x: collectView.frame.width/2, y: collectView.contentOffset.y + collectView.frame.width/2)
//        return collectView.indexPathForItem(at: p)
//    }
//
//    private func findCurrentCell(path: IndexPath) -> UICollectionViewCell {
//        return collectView.cellForItem(at: path)!
//    }
//}

extension  PersonalVideoVC :UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {

      //  return CGSize(width: (UIScreen.main.bounds.width/2)-18, height: (UIScreen.main.bounds.height/5)-22 )
        return CGSize(width: (UIScreen.main.bounds.width/2)-4, height: 240 )
        
       // return CGSize(width: (UIScreen.main.bounds.width/2)-18, height: 140 )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {

        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 1
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
