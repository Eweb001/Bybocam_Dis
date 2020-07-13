//
//  ReccomendationView.swift
//  Bybocam
//
//  Created by APPLE on 11/11/19.
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
import CoreLocation

class ReccomendationView: UIViewController, CLLocationManagerDelegate
{
    
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var noDataFoundLbl: UILabel!
    var likeValue = "0"
    var RecomenApiResponse:ReccomendationModel?
    var newValue = "00"
    
    // Location Manager
    
    var locationManager:CLLocationManager!
    var newLat = ""
    var newLong = ""
    var CurrentMainLocatin = ""
    var recevierId = ""
    var userLikeStatus = ""
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        
        return refreshControl
    }()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation :CLLocation = locations[0] as CLLocation
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(userLocation)
        {
            (placemarks, error) in
            if (error != nil)
            {
                print("error in reverseGeocode")
            }
            let placemark = placemarks as? [CLPlacemark]
            if placemark?.count ?? 0>0
            {
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                
                print("user latitude = \(userLocation.coordinate.latitude)")
                print("user longitude = \(userLocation.coordinate.longitude)")
                
                self.newLat = "\(userLocation.coordinate.latitude)"
                self.newLong = "\(userLocation.coordinate.longitude)"
                
                DEFAULT.set(self.newLat, forKey: "LATITUDE")
                DEFAULT.set(self.newLong, forKey: "LONGITUDE")
                self.CurrentMainLocatin = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
                DEFAULT.set(self.CurrentMainLocatin, forKey: "CurrentMainLocatin")
                
           //     self.getAlluser()
                
                //   self.locationTxt.text = "\(placemark.locality!), \(placemark.administrativeArea!),(placemark.country!)"
                
            }
            
            
        }
 
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        noDataFoundLbl.isHidden = true
        self.collectionView.addSubview(refreshControl)
        self.collectionView.register(UINib(nibName: "RecomenCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecomenCollectionViewCell")
        
        // Location Manager
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            getAlluser()
        }
        
         
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        print("ReccomendationView did ReceiveMemory Warning")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        // Location Manager
        
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
        
        if DEFAULT.value(forKey: "REFRESHRECOMENDAPI") != nil
        {
            if !NetworkEngine.networkEngineObj.isInternetAvailable()
            {
               NetworkEngine.showInterNetAlert(vc: self)
            }
            else
            {
                getAlluser()
              //  LikeuserApi()
            }
            
            print("will apper call")
            DEFAULT.removeObject(forKey: "REFRESHRECOMENDAPI")
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
        getAlluser()
    }
    
    self.refreshControl.endRefreshing()
    }
    
    func getAlluser()
    {
        
        var USERID = "4"
        var LATITUDE = "30.704649"
        var LONGITUDE = "76.717873"
        
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        if let LATITUDE1 = DEFAULT.value(forKey: "LATITUDE") as? String
        {
            LATITUDE = LATITUDE1
        }
        if let LONGITUDE1 = DEFAULT.value(forKey: "LONGITUDE") as? String
        {
            LONGITUDE = LONGITUDE1
        }
        
        let para = ["userId" : USERID,
                    "lat" : LATITUDE,
                    "lng" : LONGITUDE] as [String : AnyObject]
        print(para)
        
        ApiHandler.PostModelApiPostMethod(url: RECOMENDATION_URL, parameters: para, Header: [ : ]) { (respData, error) in
            
            do
            {
                let decoder = JSONDecoder()
                if respData != nil
                {
                    self.RecomenApiResponse =  try decoder.decode(ReccomendationModel.self, from: respData!)
                    
                    if self.RecomenApiResponse?.status == "success"
                    {
                        if self.RecomenApiResponse?.data?.count == 0
                        {
                             self.noDataFoundLbl.isHidden = false
                        }
                        else
                        {
                            self.collectionView.reloadData()
                            self.noDataFoundLbl.isHidden = true
                        }
                    }
                    else
                    {
                        self.view.makeToast(self.RecomenApiResponse?.message)
                    }
                    
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
                
                let alert = UIAlertController(title: "Alert", message: error as! String, preferredStyle: .alert)
                let submitAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in})
                alert.addAction(submitAction)
                self.present(alert, animated: true, completion: nil)
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
                    "recevierId" : self.recevierId,
                    "userLikeStatus" : newValue] as [String : AnyObject]
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
                       
                       self.view.makeToast(self.RecomenApiResponse?.message)
                    }
                     self.getAlluser()
                    
                }
                else
                {
                    SVProgressHUD.dismiss()
                    self.getAlluser()
                    self.view.makeToast(self.RecomenApiResponse?.message)
                    print("Error")
                }
            }
            catch let error
            {
                print(error)
                self.getAlluser()
                SVProgressHUD.dismiss()
               
            }
        }
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
}
extension  ReccomendationView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        
        return  self.RecomenApiResponse?.data?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecomenCollectionViewCell", for: indexPath) as! RecomenCollectionViewCell
        
        // STATIC DATA
       
        cell.stackView.isHidden = false
        cell.likeBtn.tag = indexPath.item
        cell.likeBtn.addTarget(self, action: #selector(UserLikeAct), for: .touchUpInside)
        
        // USE NAME AND PROFILE
        
        let indexData = self.RecomenApiResponse?.data?.reversed()[indexPath.item]
        
        if indexData?.userVideos?.count ?? 0>0
        {
            cell.noVideoFound.isHidden=true
        }
        else
        {
            cell.noVideoFound.isHidden=true
        }
        
        cell.userName.text = indexData?.userName
        
        let img = indexData?.userImage
        if img != nil
        {
            let image_value = Image_Base_URL + img!
            print(image_value)
            let profile_img = URL(string: image_value)
            cell.userImg.sd_setImage(with: profile_img, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
            cell.userImg.layer.cornerRadius = cell.userImg.frame.height/2
            cell.userImg.layer.borderWidth = 1
            cell.userImg.layer.borderColor = UIColor.black.cgColor
        }
        else
        {
            cell.userImg.image = UIImage(named: "defaultImage")
        }
        
        if let videoArray = indexData?.userVideos
        {
            print(videoArray)
            
            if videoArray.count != 0
            {
                cell.noVideoFound.isHidden = true
                cell.stackView.isHidden = false
                if videoArray.count == 1
                {
                
                    // 1st Btn
                    cell.firstImg.isHidden = false
                    cell.mainview1.isHidden = false
                    cell.firstImg.isHidden = false
                    cell.play1.isHidden = false
                    cell.firstPlayBtn.isHidden = false
                    
                    // 2nd Btn

                    cell.secondImg.isHidden = true
                    cell.mainview2.backgroundColor = UIColor.white
                    cell.secondImg.isHidden = true
                    cell.play2.isHidden = true
                    cell.secndPlayBtn.isHidden = true
                    
                    
                    // 3rd Btn

                    cell.thirdImg.isHidden = true
                    cell.mainview3.backgroundColor = UIColor.white
                    cell.thirdImg.isHidden = true
                    cell.play3.isHidden = true
                    cell.thirdPlayBtn.isHidden = true
                    
                    
                    cell.firstPlayBtn.tag = indexPath.item
                    cell.play1.isHidden = false
                    cell.mainview1.isHidden = false
                    cell.firstPlayBtn.addTarget(self, action: #selector(firstPlayAct), for: .touchUpInside)
                    
                
                    if let  imageData = indexData?.userVideos?[0].videoThumbnailimg
                    {
                        if imageData != ""
                        {
                            let baseUrl =  Video_Base_URL + imageData
                            let url = URL(string: baseUrl)!
                            
                            DispatchQueue.global(qos: .userInitiated).async
                                {
                                    
                       
                        cell.firstImg.sd_setImage(with: url, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                                    
                            }
    
//                            let player = AVPlayer(url: url)
//
//                            let playerLayer = AVPlayerLayer(player: player)
//                            playerLayer.frame = CGRect(x: 0, y: 0, width: cell.firstView.frame.width, height: cell.firstView.frame.height)
//
//                            cell.firstView.layer.addSublayer(playerLayer)
//                            player.isMuted=true
//                            player.play()
                            
                            cell.firstPlayBtn.isHidden = false
                            
                            cell.secndView.isHidden = true
                            cell.thirdView.isHidden = true
                            cell.secndPlayBtn.isHidden = false
                            cell.thirdPlayBtn.isHidden = false
                            
                            }
                   
                    }
                    
                    
                }
                else if videoArray.count == 2
                {
                    cell.firstPlayBtn.tag = indexPath.item
                    cell.firstPlayBtn.addTarget(self, action: #selector(firstPlayAct), for: .touchUpInside)
                    
                    cell.secndPlayBtn.tag = indexPath.item
                    cell.secndPlayBtn.addTarget(self, action: #selector(secondPlayAct), for: .touchUpInside)
                    
                   
                    if let  imageData = indexData?.userVideos?[0].videoThumbnailimg
                    {
                        if imageData != ""
                        {
                            
                            // 1st Btn
                            // 1st Btn
                            cell.firstImg.isHidden = false
                            cell.mainview1.isHidden = false
                            cell.firstImg.isHidden = false
                            cell.play1.isHidden = false
                            cell.firstPlayBtn.isHidden = false
                            
                            // 2nd Btn
                            
                            cell.secondImg.isHidden = true
                            cell.mainview2.backgroundColor = UIColor.white
                            cell.secondImg.isHidden = true
                            cell.play2.isHidden = true
                            cell.secndPlayBtn.isHidden = true
                            
                            
                            // 3rd Btn
                            
                            cell.thirdImg.isHidden = true
                            cell.mainview3.backgroundColor = UIColor.white
                            cell.thirdImg.isHidden = true
                            cell.play3.isHidden = true
                            cell.thirdPlayBtn.isHidden = true
                            
                            let baseUrl =  Video_Base_URL + imageData
                            
                            let url = URL(string: baseUrl)!
                            DispatchQueue.global(qos: .userInitiated).async
                                {
                                    
                                    
                                    cell.firstImg.sd_setImage(with: url, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                                    
                            }
                            
                          //  let player = AVPlayer(url: url)
                            
//                            let playerLayer = AVPlayerLayer(player: player)
//                            playerLayer.frame = CGRect(x: 0, y: 0, width: cell.firstView.frame.width, height: cell.firstView.frame.height)
//
//                            cell.firstView.layer.addSublayer(playerLayer)
//                                player.isMuted=true
//                            player.play()
                        
                            cell.firstPlayBtn.isHidden = false
                            
                            cell.secndView.isHidden = true
                            cell.thirdView.isHidden = true
                            cell.secndPlayBtn.isHidden = true
                            cell.thirdPlayBtn.isHidden = true
                            
                         }
                        
                    }
                    
                    if let  imageData = indexData?.userVideos?[1].videoThumbnailimg
                    {
                        if imageData != ""
                        {
                             
                            // 1st Btn
                            cell.firstImg.isHidden = false
                            cell.mainview1.isHidden = false
                            cell.firstImg.isHidden = false
                            cell.play1.isHidden = false
                            cell.firstPlayBtn.isHidden = false
                            
                            // 2nd Btn
                            
                            cell.secondImg.isHidden = true
                            cell.mainview2.backgroundColor = UIColor.white
                            cell.secondImg.isHidden = true
                            cell.play2.isHidden = true
                            cell.secndPlayBtn.isHidden = true
                            
                            
                            // 3rd Btn
                            
                            cell.thirdImg.isHidden = true
                            cell.mainview3.backgroundColor = UIColor.white
                            cell.thirdImg.isHidden = true
                            cell.play3.isHidden = true
                            cell.thirdPlayBtn.isHidden = true
                            
                            
                            
//                            // 2nd Btn
//                            cell.secondImg.isHidden = false
//                            cell.play2.isHidden = false
//                            cell.mainview2.backgroundColor = UIColor.black
//                            cell.mainview2.isHidden = false
                            
                            
                            
//                            // 3rd Btn
//                            cell.thirdImg.isHidden = true
//                            cell.thirdPlayBtn.isHidden = true
//                            cell.play3.isHidden = true
//                            cell.mainview3.backgroundColor = UIColor.white
////                            cell.mainview3.isHidden = true
//                            cell.thirdView.backgroundColor = UIColor.white
////                            cell.thirdView.isHidden = true
                            
                            
                            
                            let baseUrl =  Video_Base_URL + imageData
                            
                            let url = URL(string: baseUrl)!
                            
                            DispatchQueue.global(qos: .userInitiated).async
                                {
                                    
                                    
                                    cell.secondImg.sd_setImage(with: url, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                                    
                            }
                            
//                            let player = AVPlayer(url: url)
//
//                            let playerLayer = AVPlayerLayer(player: player)
//                            playerLayer.frame = CGRect(x: 0, y: 0, width: cell.secndView.frame.width, height: cell.secndView.frame.height)
//                            cell.secndView.layer.addSublayer(playerLayer)
//                             player.isMuted=true
//                            player.play()
                          
                             cell.secndPlayBtn.isHidden = false
                        }
                        
                    }
                    
                }
                else if videoArray.count == 3
                {
                   
                    
                    cell.firstPlayBtn.tag = indexPath.item
                    cell.firstPlayBtn.addTarget(self, action: #selector(firstPlayAct), for: .touchUpInside)
                    
                    cell.secndPlayBtn.tag = indexPath.item
                    cell.secndPlayBtn.addTarget(self, action: #selector(secondPlayAct), for: .touchUpInside)
                    
                    cell.thirdPlayBtn.tag = indexPath.item
                    cell.thirdPlayBtn.addTarget(self, action: #selector(thirdPlayAct), for: .touchUpInside)
                    
                    
                    
                    if let  imageData = indexData?.userVideos?[0].videoThumbnailimg
                    {
                        if imageData != ""
                        {
                            
                            
                            // 1st Btn
                            cell.firstImg.isHidden = false
                            cell.play1.isHidden = false
                            cell.mainview1.isHidden = false
                            
                            
                            
                            let baseUrl =  Video_Base_URL + imageData
                            
                            let url = URL(string: baseUrl)!
                            
                            DispatchQueue.global(qos: .userInitiated).async
                                {
                                    
                                    
                                    cell.firstImg.sd_setImage(with: url, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                                    
                            }
                            
//                            let player = AVPlayer(url: url)
//
//                            let playerLayer = AVPlayerLayer(player: player)
//                            playerLayer.frame = CGRect(x: 0, y: 0, width: cell.firstView.frame.width, height: cell.firstView.frame.height)
//
//                            cell.firstView.layer.addSublayer(playerLayer)
//                            player.isMuted=true
//                            player.play()
                           
                             cell.firstPlayBtn.isHidden = false

                            
                        }
                        
                        
                        
                    }
                    
                    
                    if let  imageData = indexData?.userVideos?[1].videoThumbnailimg
                    {
                        if imageData != ""
                        {
                            // 2nd Btn
                            cell.secondImg.isHidden = false
                            cell.play2.isHidden = false
                            cell.mainview2.isHidden = false
                            cell.mainview2.backgroundColor = UIColor.black
                            
                            // 3rd Btn
                            cell.thirdImg.isHidden = false
                            cell.play3.isHidden = false
                            cell.mainview3.isHidden = false
                            cell.mainview3.backgroundColor = UIColor.black
                            
                            
                            
                            let baseUrl =  Video_Base_URL + imageData
                            
                            
                            
                            
                           let url = URL(string: baseUrl)!
                            DispatchQueue.global(qos: .userInitiated).async
                                {
                                    
                                    
                                    cell.secondImg.sd_setImage(with: url, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                                    
                            }
//
//                            let player = AVPlayer(url: url)
//
//                            let playerLayer = AVPlayerLayer(player: player)
//                           playerLayer.frame = CGRect(x: 0, y: 0, width: cell.secndView.frame.width, height: cell.secndView.frame.height)
//
//
//                            cell.secndView.layer.addSublayer(playerLayer)
//                           player.isMuted=true
//                            player.play()
                            
                            cell.secndPlayBtn.isHidden = false
                            
                        }
                        
                        
                        
                    }
                    
                    
                    if let  imageData = indexData?.userVideos?[2].videoThumbnailimg
                    {
                        if imageData != ""
                        {
                            
                            // 3rd Btn
                            cell.thirdImg.isHidden = false
                            cell.play3.isHidden = false
                            cell.mainview3.isHidden = false
                            cell.mainview3.backgroundColor = UIColor.black
                            
                            
                            let baseUrl =  Video_Base_URL + imageData
                            
                            let url = URL(string: baseUrl)!
                            
                            DispatchQueue.global(qos: .userInitiated).async
                                {
                                    
                                    
                                    cell.thirdImg.sd_setImage(with: url, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                                    
                            }
                            
                            
//                            let player = AVPlayer(url: url)
//
//                            let playerLayer = AVPlayerLayer(player: player)
//                            playerLayer.frame = CGRect(x: 0, y: 0, width: cell.thirdView.frame.width, height: cell.thirdView.frame.height)
//
//                            cell.thirdView.layer.addSublayer(playerLayer)
//                              player.isMuted=true
//                            player.play()
                            cell.thirdPlayBtn.isHidden = false
                        }
                     }
                }
                else
                {
                    cell.noVideoFound.isHidden = false
                    cell.stackView.isHidden = true
                }
            }
            else
            {
                cell.noVideoFound.isHidden = true
                cell.stackView.isHidden = true
            }
        }
        if indexData?.likeStatus == "1"
        {
            cell.likeBtn.setImage(#imageLiteral(resourceName: "YelloHeart"), for: .normal)
        }
        else
        {
           cell.likeBtn.setImage(#imageLiteral(resourceName: "blackHeart"), for: .normal)
        }
        
        
        cell.mainCardView.layer.borderColor = UIColor.darkGray.cgColor
        cell.mainCardView.layer.borderWidth = 1
        cell.mainCardView.layer.cornerRadius = 6
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewUserProfileVC") as! ViewUserProfileVC
        
        let indexData = self.RecomenApiResponse?.data?.reversed()[indexPath.item]
        
        vc.USERID = indexData?.userId ?? "9"
        if indexData?.likeStatus == "1"
        {
            vc.isFollowing=true
        }
        else
        {
            vc.isFollowing=false
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func firstPlayAct(_ sender:UIButton)
    {
        print("First Button is tapped.")
        
        
            let dict = self.RecomenApiResponse?.data?.reversed()[sender.tag]
            
            if let  imageData = dict?.userVideos?[0].videoName
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
 
    @objc func UserLikeAct(_ sender:UIButton)
    {
        print("First Button is tapped.")
        
        let indexData1 = self.RecomenApiResponse?.data?.reversed()[sender.tag]
        self.recevierId = indexData1?.userId ?? "1"
        self.userLikeStatus = indexData1?.likeStatus ?? "1"
        var data = indexData1?.likeStatus
        print(data)
        
        if data == "0"
        {
            newValue = "1"
        }
        else if data == "1"
        {
            newValue = "0"
        }
        else
        {
            newValue = "3"
        }
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
           self.LikeuserApi()
        }
        
        
        
        
    }
    @objc func secondPlayAct(_ sender:UIButton)
    {
        print("Second Button is tapped.")
        
        let indexData1 = self.RecomenApiResponse?.data?.reversed()[sender.tag]
        let firstVideo1 = indexData1?.userVideos?[1].videoName
        
        if let sec = indexData1?.userVideos?[1].videoName
        {
            if sec != ""
            {
                let baseUrl = Video_Base_URL + sec
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
    @objc func thirdPlayAct(_ sender:UIButton)
    {
        print("Third Button is tapped.")
        
        let indexData1 = self.RecomenApiResponse?.data?.reversed()[sender.tag]
        let firstVideo1 = indexData1?.userVideos?[2].videoName
        
        if let third = indexData1?.userVideos?[2].videoName
        {
            if third != ""
            {
                let baseUrl = Video_Base_URL + third
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (UIScreen.main.bounds.width/2)-12, height: 170)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0000000.1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0000000.1
    }
}
