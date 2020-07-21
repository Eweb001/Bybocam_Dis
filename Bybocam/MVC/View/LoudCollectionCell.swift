//
//  LoudCollectionCell.swift
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


class LoudCollectionCell: UICollectionViewCell,ASAutoPlayVideoLayerContainer
{

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var openImage: UIButton!
    @IBOutlet weak var playVideo: UIButton!
    @IBOutlet weak var playiconImg: UIImageView!
    @IBOutlet weak var videoPlayerSuperView: UIView!
    var userVideosArray = NSMutableArray()
    var ViewPostArray = NSArray()
    var ModelApiResponse:ViewUserProfile?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
       
    @IBOutlet weak var descpLbl: UILabel!
    @IBOutlet weak var buutomView: UIView!
       
       var videoURL: String? {
           didSet {
               if let videoURL = videoURL {
                   ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
               }
               videoLayer.isHidden = videoURL == nil
           }
       }
       var avPlayer: AVPlayer?
          var avPlayerLayer: AVPlayerLayer?
          var paused: Bool = false
    
    var videoPlayerItem: AVPlayerItem? = nil {
           didSet {
               /*
                If needed, configure player item here before associating it with a player.
                (example: adding outputs, setting text style rules, selecting media options)
                */
               avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
           }
       }
       
    override func awakeFromNib()
    {
        super.awakeFromNib()
             mainImg.layer.cornerRadius = 5
                   mainImg.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
                   mainImg.clipsToBounds = true
                   mainImg.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
                   mainImg.layer.borderWidth = 0.5
                   videoLayer.backgroundColor = UIColor.clear.cgColor
                   videoLayer.videoGravity = AVLayerVideoGravity.resize
                   mainImg.layer.addSublayer(videoLayer)
    }
     func setupMoviePlayer()
        {
            self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
            avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            avPlayer?.volume = 3
            avPlayer?.actionAtItemEnd = .none
            
            //        You need to have different variations
            //        according to the device so as the avplayer fits well
            //        if UIScreen.main.bounds.width == 375 {
            //            let widthRequired = self.frame.size.width - 20
            //            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: widthRequired, height: widthRequired/1.78)
            //        }else if UIScreen.main.bounds.width == 320 {
            //            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: (self.frame.size.height - 120) * 1.78, height: self.frame.size.height - 120)
            //        }else{
            //            let widthRequired = self.frame.size.width
            //            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: widthRequired, height: widthRequired/1.78)
            //        }
            
            avPlayerLayer?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            
          //  self.backgroundColor = .black
            self.videoPlayerSuperView.backgroundColor = UIColor.black
            
            self.videoPlayerSuperView.layer.insertSublayer(avPlayerLayer!, at: 0)
            
            // This notification is fired when the video ends, you can handle it in the method.
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.playerItemDidReachEnd(notification:)),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object: avPlayer?.currentItem)
        }
        
        func stopPlayback(){
            self.avPlayer?.pause()
        }
        
        func startPlayback(){
            self.avPlayer?.isMuted=true
            self.avPlayer?.play()
        }
        
        // A notification is fired and seeker is sent to the beginning to loop the video again
        @objc func playerItemDidReachEnd(notification: Notification) {
            let p: AVPlayerItem = notification.object as! AVPlayerItem
            p.seek(to: CMTime.zero)
        }
        
        
        
        func configureCell(imageUrl: String?,
                           description: String,
                           videoUrl: String?) {
           // self.descriptionLabel.text = description
            self.mainImg.imageURL = imageUrl
            self.videoURL = videoUrl
        }
        
        override func prepareForReuse() {
            mainImg.imageURL = nil
            super.prepareForReuse()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let horizontalMargin: CGFloat = 20
            let width: CGFloat = bounds.size.width - horizontalMargin * 2
            let height: CGFloat = (width * 0.9).rounded(.up)
            videoLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height) //CGRect(x: 0, y: 0, width: width, height: height)
        }
        
        func visibleVideoHeight() -> CGFloat {
    //        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(gridCollectImgg.frame, from: gridCollectImgg)
    //        guard let videoFrame = videoFrameInParentSuperView,
    //            let superViewFrame = superview?.frame else {
    //                return 0
    //        }
    //        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
    //        return visibleVideoFrame.size.height
            return 140
        }

}
