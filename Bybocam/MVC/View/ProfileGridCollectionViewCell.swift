//
//  ProfileGridCollectionViewCell.swift
//  Bybocam
//
//  Created by eWeb on 05/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileGridCollectionViewCell: UICollectionViewCell,ASAutoPlayVideoLayerContainer
{
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var plyBtn: UIButton!
    
    @IBOutlet weak var OpenImgBtn: UIButton!
    
    @IBOutlet weak var gridCollectImgg: UIImageView!
    
    @IBOutlet weak var videoPlayerSuperView: UIView!
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var paused: Bool = false
    
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var likBtn: UIButton!
    
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var commentImg: UIImageView!
    @IBOutlet weak var likeCout: UILabel!
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    
    @IBOutlet weak var buutomView: UIView!
    
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    
    
    
    @IBOutlet weak var buttomConst: NSLayoutConstraint!
    //This will be called everytime a new value is set on the videoplayer item
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
        // Initialization code
        
        
        gridCollectImgg.layer.cornerRadius = 5
        gridCollectImgg.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        gridCollectImgg.clipsToBounds = true
        gridCollectImgg.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        gridCollectImgg.layer.borderWidth = 0.5
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resize
        gridCollectImgg.layer.addSublayer(videoLayer)
        //selectionStyle = .none
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
        self.gridCollectImgg.imageURL = imageUrl
        self.videoURL = videoUrl
    }
    
    override func prepareForReuse() {
        gridCollectImgg.imageURL = nil
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
