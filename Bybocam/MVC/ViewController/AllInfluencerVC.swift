//
//  AllInfluencerVC.swift
//  Bybocam
//
//  Created by Eweb on 21/07/20.
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


class AllInfluencerVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate
{
    
    // @IBOutlet weak var slideView: ImageSlideshow!
    
    
    @IBOutlet weak var collectView: UICollectionView!
 
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
     
        collectView.register(UINib(nibName: "InfluenceProfileCell", bundle: nil), forCellWithReuseIdentifier: "InfluenceProfileCell")
        
      
        
        
        
        
     
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            
            self.influencerApi()
        }
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
       
            if !NetworkEngine.networkEngineObj.isInternetAvailable()
            {
                NetworkEngine.showInterNetAlert(vc: self)
            }
            else
            {
                self.influencerApi()
            }
            
         
    }
    @IBAction func filterAct(_ sender: UIBarButtonItem)
    {
        let sign = storyboard?.instantiateViewController(withIdentifier: "InfluenceFilterVc") as! InfluenceFilterVc
               
        self.navigationController?.pushViewController(sign, animated: true)
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
  
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
            return self.ModelApiResponse2?.data?.count ?? 0
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectView
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
               // self.LogoutApi()
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        present(alert, animated: true, completion: nil)
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
        
        let para = ["id" : USERID,
                    "Infulenlatitude" : DEFAULT.value(forKey: "Infulenlatitude") as? String ?? "",
                     "Infulenlongitude" : DEFAULT.value(forKey: "Infulenlongitude") as? String ?? "",
                     "price" : DEFAULT.value(forKey: "price") as? String ?? "",
                     "industry" : DEFAULT.value(forKey: "industry") as? String ?? "",
                     "race" : DEFAULT.value(forKey: "race") as? String ?? "",
                     "gender" : DEFAULT.value(forKey: "gender") as? String ?? ""
                     
                     
        ]
        
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
                        
                        
                        self.collectView.reloadData()
                        
                        
                    }
                    else
                    {
                        print("Error")
                        self.view.makeToast(self.ModelApiResponse2?.message)
                        
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
    
}





extension  AllInfluencerVC :UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
    
    return CGSize(width: (UIScreen.main.bounds.width/2)-30, height: 180)
  
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

extension AllInfluencerVC
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
