//
//  PostCommentViewController.swift
//  Bybocam
//
//  Created by eWeb on 03/01/20.
//  Copyright © 2020 eWeb. All rights reserved.
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
import IQKeyboardManager

class PostCommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    //MARK:- for message
   
     @IBOutlet weak var btmConst: NSLayoutConstraint!
    @IBOutlet weak var typeMsgTf: UITextField!
    @IBOutlet weak var typeMsgRoundView: UIView!
    
    
    var POSTID = ""
    var LIKESTATUS = ""
    
    var likeUnlikeApiRespose:AddSingleMsg?
    
    var USERID = ""
    
    //MARK:- for insta code
    var alamoManager: SessionManager?
    var MediaType = ""
    var selectedItems = [YPMediaItem]()
    let selectedImageV = UIImageView()
    let pickButton = UIButton()
    let resultsButton = UIButton()
    
    
    
    var userIDProfile = ""
    
    
    //------------------//------------------//------------------//
    
    @IBOutlet weak var messageTable: UITableView!
    @IBOutlet weak var sideRoundBtn: UIButton!
    @IBOutlet weak var nodataFoundLbl: UILabel!
    
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
    var GetPostCommentDataResponse:PostCommentModel?
 
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        messageTable.delegate = self
        messageTable.dataSource = self
        
        
        messageTable.rowHeight = 100
        messageTable.estimatedRowHeight = UITableView.automaticDimension
        
        messageTable.register(UINib(nibName: "PostCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCommentTableViewCell")
        nodataFoundLbl.isHidden = true
        typeMsgRoundView.layer.cornerRadius = 25
        typeMsgRoundView.layer.borderWidth = 1
        typeMsgRoundView.layer.borderColor = UIColor.darkGray.cgColor
     
        typeMsgTf.placeholderColor(UIColor.black)
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification,object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide),name: UIResponder.keyboardWillHideNotification,object: nil)
        
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
             getAllPostCommentApi()
        }
        
       
        
        // resultsButton.addTarget(self, action: #selector(showResults), for: .touchUpInside)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SVProgressHUD.dismiss()
        // inputToolbar.contentView.textView.contentInset = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
        //        self.getAllMassage()
        IQKeyboardManager.shared().isEnabled = false
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        IQKeyboardManager.shared().isEnabled = false
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        IQKeyboardManager.shared().isEnabled = true
    }
    @objc func keyboardWillShow(_ notification: Notification)
    {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.btmConst.constant = (keyboardHeight)
            
        }
    }
    @objc func keyboardWillHide(_ notification: Notification)
    {
        
        
        self.btmConst.constant = 10
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.GetPostCommentDataResponse?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCommentTableViewCell") as! PostCommentTableViewCell
        
        let dict = self.GetPostCommentDataResponse?.data?[indexPath.row]

    cell.messageLbl.text = dict?.postMessage
        cell.timeLbl.text = self.dateDiff(dateStr: dict?.createdAt ?? "2020-01-03 14:11:03")//self.convertDateFormater(dict?.createdAt ?? "2020-01-03 14:11:03")
        
        if dict?.userData?.count ?? 0>0
        {
            
       cell.userNameLbl.text = dict?.userData?[0].userName
            
            DispatchQueue.global(qos: .userInitiated).async
                {
                    if let newImgg = dict?.userData?[0].userImage
                    {
                        let image_value = Image_Base_URL + newImgg
                        print(image_value)
                        let profile_img = URL(string: image_value)
                        cell.profileImg.sd_setImage(with: profile_img, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                    }
            }
        }
        
       
        
        
        
        return cell
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FollowerUserViewController") as! FollowerUserViewController
//
//
//        let indexData = self.GetPostCommentDataResponse?.data?.reversed()[indexPath.row]
//
//        vc.USERID = indexData?.userId ?? "9"
//
//        self.navigationController?.pushViewController(vc, animated: true)
//
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension //110
    }
    
    
    
    func getAllPostCommentApi()
    {
        SVProgressHUD.show()
       
        
        let para = ["postId" : self.POSTID] as [String : AnyObject]
        print(para)
        
        ApiHandler.PostModelApiPostMethod(url: GET_COMMENT_POST, parameters: para, Header: [ : ]) { (respData, error) in
            
            do
            {
                let decoder = JSONDecoder()
                if respData != nil
                {
                    self.GetPostCommentDataResponse =  try decoder.decode(PostCommentModel.self, from: respData!)
                    
                    if self.GetPostCommentDataResponse?.status == "success"
                    {
                        self.nodataFoundLbl.isHidden = true
                        if self.GetPostCommentDataResponse?.data?.count == 0
                        {
                            //                            self.noDataFoundLbl.isHidden = false
                        }
                        else
                        {
                            self.messageTable.reloadData()
                            
                            //                            self.noDataFoundLbl.isHidden = true
                        }
                    }
                    else
                    {
                        self.nodataFoundLbl.isHidden = false
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
    
    
    @IBAction func goBack(_ sender: UIBarButtonItem)
    {
        DEFAULT.set("YES", forKey: "REFRESHPROFILEAPI")
        DEFAULT.synchronize()
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sendMsgAct(_ sender: UIButton)
    {
       if typeMsgTf.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Message", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else
        {
            if !NetworkEngine.networkEngineObj.isInternetAvailable()
            {
                
                NetworkEngine.showInterNetAlert(vc: self)
            }
            else
            {
                self.CommentPostApi()
                
            }
        }
        
    }
}


extension PostCommentViewController
{
    //MARK:-  comment Post  API
    
    func CommentPostApi()
    {
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        
        let para = ["userId" : USERID,
                    "postId" : self.POSTID ,
                    "postMessage" : typeMsgTf.text!]
        print(para)
        
        ApiHandler.PostModelApiPostMethod(url: COMMENT_POST, parameters: para, Header: ["":""]) { (responsedata, error) in
            
            do
            {
                let decoder = JSONDecoder()
                
                if  responsedata != nil
                    
                {
                    self.likeUnlikeApiRespose = try decoder.decode(AddSingleMsg.self, from: responsedata!)
                    
                    if self.likeUnlikeApiRespose?.status == "success"
                    {
                        self.view.makeToast(self.likeUnlikeApiRespose?.message)
                        
                        if !NetworkEngine.networkEngineObj.isInternetAvailable()
                        {
                            
                            NetworkEngine.showInterNetAlert(vc: self)
                        }
                        else
                        {
                           self.getAllPostCommentApi()
                        }
                        
                        
                        
                        self.messageTable.scrollToBottom()
                    }
                    else
                    {
                       
                    }
                    
                    self.typeMsgTf.text = ""
                  self.typeMsgTf.resignFirstResponder()
                    
                   // self.ViewProfileApi()
                }
                
            }
            catch let error
            {
                print(error)
            }
            
        }
        
    }
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "E,d MMM yyyy, h:mm a"
        return  dateFormatter.string(from: date!)
        
    }
    
    
    //===MARK:---- calculate difference
    
    func dateDiff(dateStr:String) -> String {
        let f:DateFormatter = DateFormatter()
        f.timeZone = NSTimeZone.init(abbreviation: "UTC") as! TimeZone
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = f.string(from: NSDate() as Date)
        let startDate = f.date(from: dateStr)
        let endDate = f.date(from: now)
        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        
        let calendarUnits:NSCalendar.Unit = [.weekOfMonth,.day, .hour, .minute, .second]
        let dateComponents = calendar.components(calendarUnits, from: startDate!, to: endDate!, options: [])
        let weeks = abs(Int32(dateComponents.weekOfMonth!))
        let days = abs(Int32(dateComponents.day!))
        let hours = abs(Int32(dateComponents.hour!))
        let min = abs(Int32(dateComponents.minute!))
        let sec = abs(Int32(dateComponents.second!))
        
        var timeAgo = ""

      
                        if (sec > 0)
                        {
                            if (sec > 1)
                            {
                                timeAgo = "\(sec) Seconds Ago"
                            }
                            else {
                                timeAgo = "\(sec) Second Ago"
                            }
                        }
                        else
                        {
                            timeAgo = "\(1) Second Ago"
                         }
        
                        if (min > 0){
                            if (min > 1) {
                                timeAgo = "\(min) Minutes Ago"
                            } else {
                                timeAgo = "\(min) Minute Ago"
                            }
                        }
        
            if(hours > 0){
                if (hours > 1) {
                    timeAgo = "\(hours) Hours Ago"
                } else {
                    timeAgo = "\(hours) Hour Ago"
                }
            }
            
            if (days > 0) {
                if (days > 1) {
                    timeAgo = "\(days) Days Ago"
                } else {
                    timeAgo = "\(days) Day Ago"
                }
            }
            
            if(weeks > 0){
                if (weeks > 1) {
                    timeAgo = "\(weeks) Weeks Ago"
                } else {
                    timeAgo = "\(weeks) Week Ago"
                }
            }
        

        print("timeAgo is===> \(timeAgo)")
        return timeAgo;
    }
}


extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let section = self.numberOfSections
        if section > 0 {
            let row = self.numberOfRows(inSection: section - 1)
            if row > 0 {
                self.scrollToRow(at: NSIndexPath(row: row - 1, section: section - 1) as IndexPath, at: .bottom, animated: animated)
            }
        }
    }
}
