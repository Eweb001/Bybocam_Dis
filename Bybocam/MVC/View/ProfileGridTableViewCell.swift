//
//  ProfileGridTableViewCell.swift
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


class ProfileGridTableViewCell: UITableViewCell
{
     var likeUnlikeApiRespose:AddSingleMsg?
    var POSTID = ""
    var LIKESTATUS = ""
    
    @IBOutlet weak var gridCollection: UICollectionView!
    
    var userVideosArray = NSMutableArray()
    var ViewPostArray = NSArray()
    var ModelApiResponse:ViewUserProfile?
  
    var currentVC:UIViewController?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        gridCollection.register(UINib(nibName: "ProfileGridCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileGridCollectionViewCell")
        gridCollection.delegate = self
        gridCollection.dataSource = self
        
    }
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    func reloadCollection(postArray:ViewUserProfile,vc:UIViewController)
    {
        self.currentVC = vc
        
        self.ModelApiResponse = postArray
        self.gridCollection.reloadData()
        
    }

}
extension  ProfileGridTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
         return self.ModelApiResponse?.postData?.count ?? 0 //self.ViewPostArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileGridCollectionViewCell", for: indexPath) as! ProfileGridCollectionViewCell
        
        let dict = self.ModelApiResponse?.postData?.reversed()[indexPath.row]//self.ViewPostArray.object(at: indexPath.item) as! NSDictionary
        
        if let vcName = self.currentVC?.restorationIdentifier
        {
           
             if vcName == "ViewUserProfileVC"
            {
                cell.deleteBtn.isHidden=true
             cell.buutomView.isHidden = true
                cell.buttomConst.constant = 0
            }
             else if vcName == "NewProfileViewController"
             {
                cell.deleteBtn.isHidden=false
                cell.buutomView.isHidden = false
                cell.buttomConst.constant = 50
            }
             else
             {
                cell.deleteBtn.isHidden=true
                cell.buutomView.isHidden = false
                 cell.buttomConst.constant = 50
            }
        }
        else{
            cell.deleteBtn.isHidden=true
            cell.buutomView.isHidden = false
             cell.buttomConst.constant = 50
        }
        cell.likBtn.tag = indexPath.row
        cell.likBtn.addTarget(self, action: #selector(LikeBtnAction), for: .touchUpInside)
        
        
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
        
        
          let postType = dict?.postType //dict.value(forKey: "postType") as! String
            if postType == "0"
            {
                cell.plyBtn.isHidden = true
                cell.OpenImgBtn.tag = indexPath.row
                cell.OpenImgBtn.addTarget(self, action: #selector(OpenImgBtn), for: .touchUpInside)
               if let newImgg = dict?.postImage
                {
                    let image_value = Post_Base_URL + newImgg
                    print(image_value)
                    let profile_img = URL(string: image_value)
                    cell.gridCollectImgg.sd_setImage(with: profile_img, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                }
                else
               {
                cell.gridCollectImgg.image = #imageLiteral(resourceName: "banner_Image")
                }
            }
            else
            {
                cell.plyBtn.isHidden = false
                cell.gridCollectImgg.image = #imageLiteral(resourceName: "loding")
              
                
                DispatchQueue.global(qos: .userInitiated).async
                    {
                        if let newImgg = dict?.postVideoThumbnailImg//dict.value(forKey: "postImageVideo") as? String
                        {
                            if newImgg != ""
                            {
                                let image_value = Post_Base_URL + newImgg
                                print(image_value)
                                let profile_img = URL(string: image_value)!
                              
                                        
                                        cell.gridCollectImgg.sd_setImage(with: profile_img, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                                
                                
                                
                                cell.videoPlayerItem = AVPlayerItem.init(url: profile_img)
                            cell.startPlayback()
//                                let player = AVPlayer(url: profile_img)
//
//                                let playerLayer = AVPlayerLayer(player: player)
//                                playerLayer.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
//
//                                cell.layer.addSublayer(playerLayer)
//                                player.play()
                                
                                DispatchQueue.global(qos: .userInitiated).async
                                    {

                                        if let thumbnailImage = self.getThumbnailImage(forUrl: profile_img)
                                        {
                                            cell.gridCollectImgg.image = thumbnailImage
                                        }
                                }
                            }
                            else
                            {
                                cell.gridCollectImgg.image = #imageLiteral(resourceName: "banner_Image")
                            }
                            
                    }
                        else
                        {
                            cell.gridCollectImgg.image = #imageLiteral(resourceName: "banner_Image")
                        }
                }
            }
        
        cell.plyBtn.tag = indexPath.row
        cell.plyBtn.addTarget(self, action: #selector(CollectionPlayVideo), for: .touchUpInside)
       
        return cell
    }
    @objc func OpenImgBtn(_ sender:UIButton)
    {
        
        let dict = self.ModelApiResponse?.postData?.reversed()[sender.tag] //self.ViewPostArray.object(at: sender.tag) as! NSDictionary
        
        let postType = dict?.postType //dict.value(forKey: "postType") as! String
        
        if postType == "0"
        {
            if let newImgg = dict?.postImage//dict.value(forKey: "postImage") as? String
            {
                let image_value = Post_Base_URL + newImgg
                print(image_value)
                
                NotificationCenter.default.post(name: Notification.Name("PlayVideoNotificationIdentifier"), object: nil, userInfo: ["url":image_value,"Type":"i"])
            }
        }
    }
    
    //MARK:- Comment btn click
    
    
    
    @objc func CommentBtnAction(_ sender:UIButton)
    {
        
        print("current vc \(self.currentVC)")
        print(sender.tag)
        let dict = self.ModelApiResponse?.postData?.reversed()[sender.tag]
        let postId = dict?.postId
      
        
        if let vcName = self.currentVC?.restorationIdentifier
        {
            if vcName == "FolloweViewController"
            {
               NotificationCenter.default.post(name: Notification.Name("FromFolloweViewController"), object: nil, userInfo: ["POSTID":postId])
            }
            else if vcName == "ViewUserProfileVC"
            {
                NotificationCenter.default.post(name: Notification.Name("ViewUserProfileVCCommentUserProfile"), object: nil, userInfo: ["POSTID":postId])
            }
            else
            {
                NotificationCenter.default.post(name: Notification.Name("FromUsergProfileCommentUserProfile"), object: nil, userInfo: ["POSTID":postId])
            }
        }
        
        
            
        
        
    }
    
    
    @objc func DeleteBtnAction(_ sender:UIButton)
    {
        let dict =  self.ModelApiResponse?.postData?.reversed()[sender.tag]
        print(sender.tag)
        self.POSTID = dict?.postId ?? "0"
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Delete this post?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
            
            if !NetworkEngine.networkEngineObj.isInternetAvailable()
            {
                
                //NetworkEngine.showInterNetAlert(vc: self)
            }
            else
            {
                self.deletePostApi()
            }
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
      //  present(alert, animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)

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
        
       
        
        self.LikePostApi()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
          return CGSize(width: (UIScreen.main.bounds.width/2)-5, height: 240 )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 1
    }
    @objc func CollectionPlayVideo(_ sender:UIButton)
    {
        let dict = self.ModelApiResponse?.postData?.reversed()[sender.tag] //self.ViewPostArray.object(at: sender.tag) as! NSDictionary
        
        let postType = dict?.postType//dict.value(forKey: "postType") as! String
        
        if postType == "0"
        {
            if let newImgg = dict?.postImage//dict.value(forKey: "postImage") as? String
            {
                let image_value = Post_Base_URL + newImgg
                print(image_value)
                
                NotificationCenter.default.post(name: Notification.Name("PlayVideoNotificationIdentifier"), object: nil, userInfo: ["url":image_value,"Type":"i"])
                
            }
        }
        else
        {
            if let  imageData = dict?.postImageVideo//dict.value(forKey: "postImageVideo") as? String
            {
                if imageData != ""
                {
                    let baseUrl = Post_Base_URL + imageData
                    let url = URL(string: baseUrl)!
                    
                    
                    NotificationCenter.default.post(name: Notification.Name("PlayVideoNotificationIdentifier"), object: nil, userInfo: ["url":url,"Type":"v"])
                }
                
            }
        }
        
       
        
    }
    
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
                      //  self.view.makeToast(self.likeUnlikeApiRespose?.message)
                      //
                        
                        
                    }
                    else
                    {
                       // self.profileTable.reloadData()
                    }
                    
                    if let vcName = self.currentVC?.restorationIdentifier
                    {
                        if vcName == "FolloweViewController"
                        {
                            NotificationCenter.default.post(name: Notification.Name("FolloweViewControllerReloadForUpdate"), object: nil, userInfo: nil)
                        }
                        else if vcName == "ViewUserProfileVC"
                        {
                            NotificationCenter.default.post(name: Notification.Name("ViewUserProfileVCReloadForUpdate"), object: nil, userInfo: nil)
                        }
                        else
                        {
                            NotificationCenter.default.post(name: Notification.Name("NewUserVCReloadForUpdate"), object: nil, userInfo: nil)
                        }
                    }
                    
                    
                  self.gridCollection.reloadData()
                }
                
            }
            catch let error
            {
                print(error)
            }
            
        }
        
    }
    
    
    //MARK:- Delete post Api here...
    
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
                        
                        NetworkEngine.networkEngineObj.showAlert(messageToShow: self.likeUnlikeApiRespose?.message ?? "", title: "Alert!")
                        
                        
                    }
                }
                
            }
            catch let error
            {
                print(error)
            }
            
        }
        
    }
}
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as? UIViewController
            }
        }
        return nil
    }
}
