//
//  MessageViewController.swift
//  Bybocam
//
//  Created by eWeb on 04/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
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


class MessageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate
{
    let mySpecialNotificationKey = "com.andrewcbancroft.specialNotificationKeyABC"
    //MARK:- for insta code
    var alamoManager: SessionManager?
    var MediaType = ""
    var selectedItems = [YPMediaItem]()
    let selectedImageV = UIImageView()
    let pickButton = UIButton()
    let resultsButton = UIButton()
    
    //------------------
    
    @IBOutlet weak var messageTable: UITableView!
    @IBOutlet weak var sideRoundBtn: UIButton!
    @IBOutlet weak var noDataFound: UILabel!
    
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
    
    // Data for Api
    
    var HomePageModelData:HomePageModel?
    var AllDataArray = NSMutableArray()
    var userMessageArray = NSMutableArray()
    
    
    
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
        
           self.messageTable.addSubview(refreshControl)
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            self.UsersListApi()
        }
        
        noDataFound.isHidden = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        sideRoundBtn.layer.shadowColor = UIColor.black.cgColor
        sideRoundBtn.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        sideRoundBtn.layer.masksToBounds = false
        sideRoundBtn.layer.shadowRadius = 2.0
        sideRoundBtn.layer.shadowOpacity = 0.5
        messageTable.delegate = self
        messageTable.dataSource = self
        messageTable.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        
        //MARK:- for insta
        
        self.view.backgroundColor = .white
        
        selectedImageV.contentMode = .scaleAspectFit
        selectedImageV.frame = CGRect(x: 0,
                                      y: 0,
                                      width: UIScreen.main.bounds.width,
                                      height: UIScreen.main.bounds.height * 0.45)

        pickButton.setTitle("Pick", for: .normal)
        pickButton.setTitleColor(.black, for: .normal)
        pickButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        pickButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)

        pickButton.center = view.center
        
        resultsButton.setTitle("Show selected", for: .normal)
        resultsButton.setTitleColor(.black, for: .normal)
        resultsButton.frame = CGRect(x: 0,y: UIScreen.main.bounds.height - 100,width: UIScreen.main.bounds.width,height: 100)

    }
    override func viewWillAppear(_ animated: Bool)
    {
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            self.UsersListApi()
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
            self.UsersListApi()
        }
        self.refreshControl.endRefreshing()
    }
    @IBAction func searchAct(_ sender: UIBarButtonItem)
    {
       let search = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
       self.navigationController?.pushViewController(search, animated: true)
    }
    @IBAction func cameraAct(_ sender: UIBarButtonItem)
    {
        var config = YPImagePickerConfiguration()
        
        config.library.mediaType = .photoAndVideo
        
        config.shouldSaveNewPicturesToAlbum = false
        
        config.video.compression = AVAssetExportPresetMediumQuality
        
        config.startOnScreen = .photo
        
        config.screens = [.library, .photo, .video]
        
        config.video.libraryTimeLimit = 500.0
        
       // config.showsCrop = .rectangle(ratio: (16/9))
       
        config.wordings.libraryTitle = "Gallery"
        
        config.hidesStatusBar = false
        
        config.hidesBottomBar = false
        
        config.library.maxNumberOfItems = 1
        
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled
            {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            _ = items.map { print("🧀 \($0)") }
            
            self.selectedItems = items
            if let firstItem = items.first
            {
                switch firstItem
                {
                case .photo(let photo):
                    
                    self.selectedImageV.image = photo.image
                    
                    self.MediaType = "image"
                    
                    let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
                    
                    photoEditor.photoEditorDelegate = self
                    photoEditor.image = photo.image
 
                    for i in 0...10
                    {
                        photoEditor.stickers.append(UIImage(named: i.description )!)
                    }
                    
                    picker.dismiss(animated: true, completion:
                    {
                    self.present(photoEditor, animated: true, completion: nil)
                    })
                    case .video(let video):
                    
                    self.selectedImageV.image = video.thumbnail
                    let assetURL = video.url
                    self.videoURL2 = assetURL
                    
                    self.MediaType = "video"
                    
                    if !NetworkEngine.networkEngineObj.isInternetAvailable()
                    {
                        
                        NetworkEngine.showInterNetAlert(vc: self)
                    }
                    else
                    {
                        self.AddImgPostAPI()
                    }

                    picker.dismiss(animated: false, completion:
                    { [weak self] in
                      // self?.present(playerVC, animated: true, completion: nil)
                       print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
                    })
                }
            }
            
        }
        
        self.present(picker, animated: false, completion: nil)
    }
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        choosenImage =  (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func PlusBtnAct(_ sender: UIButton)
    {
        let sendMessgaeViewController = self.storyboard?.instantiateViewController(withIdentifier: "sendMessgaeViewController") as! sendMessgaeViewController
        
        self.navigationController?.pushViewController(sendMessgaeViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.HomePageModelData?.data?.count ?? 0
        //return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell
       
        if let userName = self.HomePageModelData?.data?[indexPath.row].userName
        {
            if userName.count>0
            {
                cell.userNameLbl.text = userName[0].userName
            }
           
        }
        if let userMessage = self.HomePageModelData?.data?[indexPath.row].message
        {
             cell.messageLbl.text = userMessage
            
//            if userMessage.count>1
//            {
//                cell.messageLbl.text = userMessage[0].message
//            }
//            else if userMessage.count>0
//            {
//                cell.messageLbl.text = userMessage[0].message
//            }
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let new = self.storyboard?.instantiateViewController(withIdentifier: "MainChatView") as! MainChatView
        
       new.allMsgData = self.HomePageModelData?.data?[indexPath.row]
        new.allData = self.HomePageModelData?.data?[indexPath.row]
       self.navigationController?.pushViewController(new, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 110
    }
    
//     MARK:- for insta method
    
//    @objc
//    func showResults()
    func showResults()
    {
        if selectedItems.count > 0
        {
            let gallery = YPSelectionsGalleryVC(items: selectedItems)
            { g, _ in
                g.dismiss(animated: true, completion: nil)
            }
           
            let navC = UINavigationController(rootViewController: gallery)
            self.present(navC, animated: false, completion: nil)

        }
        else {
            print("No items selected yet.")
        }
    }
    
    @objc func showPicker()
    {
        
        var config = YPImagePickerConfiguration()
        
        config.library.mediaType = .photoAndVideo
        
       config.shouldSaveNewPicturesToAlbum = false
        
       config.video.compression = AVAssetExportPresetMediumQuality
        
       config.startOnScreen = .library
        
        config.screens = [.library, .photo, .video]
      
        config.video.libraryTimeLimit = 500.0
        
        
      //  config.showsCrop = .rectangle(ratio: (16/9))
        
        config.wordings.libraryTitle = "Gallery"
        
         config.hidesStatusBar = false
        
        config.hidesBottomBar = false
        
        config.library.maxNumberOfItems = 1
       
        let picker = YPImagePicker(configuration: config)
        
       picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled
            {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }
        
            _ = items.map { print("🧀 \($0)") }
            
            self.selectedItems = items
            if let firstItem = items.first
            {
                switch firstItem
                {
                case .photo(let photo):
                    
                    self.selectedImageV.image = photo.image
                    
                    picker.dismiss(animated: false, completion: nil)
                   
                case .video(let video):
                    
                    self.selectedImageV.image = video.thumbnail
                    let assetURL = video.url
                    let playerVC = AVPlayerViewController()
                    let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
                    playerVC.player = player
                    
                    picker.dismiss(animated: true, completion: { [weak self] in
                    
                        self?.present(playerVC, animated: true, completion: nil)
                        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
                    
                })
            }
        }
    }
       
    self.present(picker, animated: false, completion: nil)
    }
    
    //  ADD IMAGE POST API
    
    func AddImgPostAPI()
    {
        
        ApiHandler.LOADERSHOW()
        
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        // POST TYPE [0 for Image and 1 for video]
        var postType2 = "0"
        
        if self.MediaType == "video"
        {
           postType2 = "1"
        }
        else
        {
             postType2 = "0"
        }
        
        
        let params:[String:String] = ["userId": USERID,
                                      "postType": postType2]
        
        print("All para = ")
        print(params)
        print(self.videoURL2)
        print(self.selectedImageV.image)
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        alamoManager = Alamofire.SessionManager(configuration: configuration)
        
        
        self.alamoManager?.upload(multipartFormData: { (multipartFormData) in
            
             if self.MediaType == "video"
             {
                if self.videoURL2 != nil
                {
                
//                    var url = URL(string: self.videoURL2)!
                    
                    multipartFormData.append(self.videoURL2!, withName: "postVideoImg", fileName: "\(Date().timeIntervalSince1970*10).mov", mimeType: "video/mov")
                }
                if self.selectedImageV.image != nil
                {
                    multipartFormData.append(self.selectedImageV.image!.jpegData(compressionQuality: 0.75)!, withName: "postVideoThumbnailImg", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }
                
            }
            else
             {
                if self.selectedImageV.image != nil
                {
                    multipartFormData.append(self.selectedImageV.image!.jpegData(compressionQuality: 0.75)!, withName: "postVideoImg", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }
               }
            
            
           
            
            
            for (key, value) in params
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            },
            to:ADD_NEW_POST_URL)
            { (result) in
            switch result
            {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print(progress)
                    
                    
                    
                    if progress.isFinished
                    {
                        SVProgressHUD.dismiss()
                     }
                    else
                    {
                        ApiHandler.LOADERSHOW()
                        
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
                            }
                            SVProgressHUD.dismiss()
                        }
                        catch let error
                        {
                           print(error)
                            SVProgressHUD.dismiss()
                        }
                    }
                    
                }
                break
                
                case .failure(let encodingError):
                SVProgressHUD.dismiss()
                
                print("error")
                print(encodingError.localizedDescription)
                print(encodingError)
                
            }
        }
    }
    
    
    //// MARK :-- API METHOD
    
    
    func UsersListApi()
    {
        
        SVProgressHUD.show()
       
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        
        let para = ["userId" : USERID] as [String : AnyObject]
        print(para)
        
        ApiHandler.PostModelApiPostMethod(url: GET_ALL_CHAT_MSG_URL, parameters: para, Header: [ : ]) { (respData, error) in
            
            do
            {
                let decoder = JSONDecoder()
                if respData != nil
                {
                    self.HomePageModelData =  try decoder.decode(HomePageModel.self, from: respData!)
                    
                    if ((self.HomePageModelData?.data?.count) != nil)
                    {
                        
                    
                       self.noDataFound.isHidden = true
                        
                        /*
                        for dict in self.HomePageModelData?.data ?? []
                        {
                            self.UsernameArray.add(dict.userName as? String)
                            //                           self.myTempArray1.add(dict.userId as? String)
                        }
                        //                        self.myTempArray = self.favArray
                        //                        var a = self.myTempArray1.componentsJoined(by: ",")
                        //                        print(a)
                         */
                    }
                    else
                    {
                        self.noDataFound.isHidden = false
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

// Support methods
extension MessageViewController
{
    /* Gives a resolution for the video by URL */
    func resolutionForLocalVideo(url: URL) -> CGSize?
    {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
}
//MARK: - extension PhotoEditorDelegate  to edit photo

extension MessageViewController: PhotoEditorDelegate
{
    
    func doneEditing(image: UIImage)
    {
       print("Done editing")
         self.selectedImageV.image = image
    if !NetworkEngine.networkEngineObj.isInternetAvailable()
    {
        
        NetworkEngine.showInterNetAlert(vc: self)
   }
    else
      {
                               self.AddImgPostAPI()
      }
        
    }
    
    func canceledEditing()
    {
        print("Canceled editing")
    }
}
