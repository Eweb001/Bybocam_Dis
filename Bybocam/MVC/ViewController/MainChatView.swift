//
//  MainChatView.swift
//  Bybocam
//
//  Created by APPLE on 16/12/19.
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
import IQKeyboardManager
import JSQMessagesViewController
import ImageSlideshow

class MainChatView:JSQMessagesViewController, UIPopoverControllerDelegate{

    
    var timer = Timer()
   
    
    @IBOutlet weak var sliderView: ImageSlideshow!
    
    var imagePicker = UIImagePickerController()
    var allData:MessageDatum?
    var allMsgData:MessageDatum?//[MessageDatum]?
    var messages = [JSQMessage]()
    var SendMsgToGroup:AddCommentModel?
    var customView = UIView()
    var lineView = UIView()
    var StatusView = UIView()
    var sendThisMsg = ""
    var USERID = "4"
    var SingleChatMsgModelData:SingleChatMessages?
    var recieverIdd = "0"
    var userName = "DummyUser"
    var recieverNaim = "DummyUser"
    var AddSingleMsgData:AddSingleMsg?
    var msgDate = NSDate()

    
   
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
  //  var imagePicker = UIImagePickerController()
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
    
    
    var fromLoad = "no"
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // RECIEVER DATA
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(delayedAction), userInfo: nil, repeats: true)
  
        if let recieverid = allData?.recevierId
        {
            recieverIdd = recieverid
        }
        else
        {
            recieverIdd = allData?.senderId ?? "1"
        }
        
        
       
        
     
        // SENDER DATA
        if let userName1 = DEFAULT.value(forKey: "userName") as? String
        {
            userName = userName1
        }
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        // SENDER DATA
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.didTap))
        sliderView.addGestureRecognizer(recognizer)
        sliderView.isHidden = true
        
        inputToolbar.barStyle = .default
        print(allMsgData)
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            self.GetAllMsgApi()
        }
        
        
        
        if let recieverid = allData?.recevierId
        {
            self.senderId = recieverid
        }
        else
        {
           self.senderId = self.allData?.senderId
        }
        
        
        var senderDisplayName = self.allData?.userName
        
        
        // Status view
        StatusView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height)
        StatusView.backgroundColor = UIColor.white
        
        // Custom View
        customView.frame = CGRect.init(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 50)
        
        // Line View
        lineView.frame = CGRect.init(x: 0, y: 55, width: UIScreen.main.bounds.width, height: 1)
        lineView.backgroundColor = UIColor.black
        customView.addSubview(lineView)
        
        self.view.addSubview(StatusView)
        let backBtn = UIButton()
        backBtn.frame = CGRect.init(x: 8, y: 15, width: 25, height: 25)
        backBtn.setImage(UIImage(named: "back_icon"), for: .normal)
        backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        customView.addSubview(backBtn)
        
        let label = UILabel(frame: CGRect(x: self.customView.center.x-20, y: self.customView.center.y-35, width: 250, height: 35))
        if allData?.userName?.count ?? 0>0
        {
            if let recieverNaim1 = allData?.userName?[0].userName
            {
                recieverNaim = recieverNaim1
                print(recieverNaim)
                self.senderDisplayName = recieverNaim1
                label.text = recieverNaim1
                // label.text = recieverNaim1
                
                self.recieverIdd = allData?.userName?[0].userId ?? "0"
            }
        }
        
        
        label.textAlignment = .left
       
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        customView.addSubview(label)
 
        view.addSubview(customView)
        inputToolbar.contentView.textView.delegate = self
        
        inputToolbar.contentView.textView.backgroundColor = UIColor.white
        inputToolbar.contentView.textView.layer.cornerRadius = inputToolbar.contentView.textView.frame.height/2
        inputToolbar.contentView.rightBarButtonItem.setTitle("", for: .normal)
        inputToolbar.contentView.textView.isUserInteractionEnabled = true
        inputToolbar.contentView.textView.placeHolder = "  Message"
        inputToolbar.contentView.rightBarButtonItem.isEnabled = true
        inputToolbar.contentView.rightBarButtonItem.isHidden = false
        inputToolbar.contentView.rightBarButtonItem.isUserInteractionEnabled = true
        inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: "Send-icon"), for: .normal)

        
       
    }
    @objc func didTap()
    {
        sliderView.presentFullScreenController(from: self)
    }
    // function to be called after the delay
    
   @objc func delayedAction()
   {
    print(Date())
    fromLoad = "yes"
        print("action has started")
    if !NetworkEngine.networkEngineObj.isInternetAvailable()
    {
        
        NetworkEngine.showInterNetAlert(vc: self)
    }
    else
    {
        self.GetAllMsgApi()
    }
    
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        SVProgressHUD.dismiss()
        IQKeyboardManager.shared().isEnabled = false
        self.tabBarController?.tabBar.isHidden = true
        
        
        //////////////////////////////////////////////////////////   ©️🅰️🈷️🅰️🈁🅰️  🇨🇦🇨🇦🇨🇦🇨🇦🇨🇦🇨🇦🇨🇦
        
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(true)
        timer.invalidate()
        
        IQKeyboardManager.shared().isEnabled = false
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(true)
        IQKeyboardManager.shared().isEnabled = true
    }
    
    
    
    @objc func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func GoToHomee(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.SingleChatMsgModelData?.data?.count ?? 0
    }
     override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
       
        let detailes = self.SingleChatMsgModelData?.data?[indexPath.item]
        print(detailes)
        
        
       
       
        if let allMSG = self.SingleChatMsgModelData?.data?[indexPath.item].message
        {
            let message1 = JSQMessage(senderId: detailes?.senderId, displayName: recieverNaim, text: allMSG)
            
            return message1
        }
       else
        
        {
            let message1 = JSQMessage(senderId: detailes?.senderId, displayName: recieverNaim, text: "...")
            
            return message1
        }
        
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        cell.textView!.textColor = UIColor.black
       
        let detailes = self.SingleChatMsgModelData?.data?[indexPath.item]
        print(detailes)
        
        cell.cellTopLabel.isHidden = false
        cell.cellTopLabel.textColor = UIColor.black
        
        if ((detailes?.messageFile) != nil)
        {
            let full = Message_Image_Base_URL + (detailes?.messageFile ?? "")
            let  url = URL(string: full)!
            cell.textView.isUserInteractionEnabled = false
            cell.textView.text = "dqwh ejrjerijeg jij egig hih ghiohg hg hioh ioh fghiohi dfghiodfg hih dfghidfghidfgh gfh gh h fghifgh h df hhghgfh fgh h fgh gh fgh g"
            cell.textView.textColor = UIColor.clear
            
            cell.messageBubbleImageView.sd_setImage(with: url, completed: nil)
        }
        else
        {
             cell.textView.isUserInteractionEnabled = true
            if detailes?.recevierId == USERID
            {
                cell.textView!.textColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
            }
            else
            {
                cell.textView!.textColor = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
            }
        }
        
        
        
        
    //sd_setImage(with: URL(string: "YOUR_URL"))
        //cell.avatarImageView.sd_setShowActivityIndicatorView(true)
        
        return cell
        
    }
    // var images = [UIImage]() // puts images of messages here
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!)
    {
      
        
        print("didTapMessageBubbleAt ")
        
         let detailes = self.SingleChatMsgModelData?.data?[indexPath.item]
        if ((detailes?.messageFile) != nil)
        {
            let full = Message_Image_Base_URL + (detailes?.messageFile ?? "")
            let  url = URL(string: full)!
            
           // slideView.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
            
//            sliderView.setImageInputs([
//
//                AlamofireSource(urlString: full, placeholder: #imageLiteral(resourceName: "loding"))!])
//
//            sliderView.presentFullScreenController(from: self)
//
            let newImageView = UIImageView()
            newImageView.sd_setImage(with: url, completed: nil)
            
            newImageView.frame = UIScreen.main.bounds
            newImageView.backgroundColor = .black
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
            self.tabBarController?.tabBar.isHidden = true
        }
    
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        
        print("cell at \(indexPath.item)")
        
        var detailes = self.SingleChatMsgModelData?.data?[indexPath.item]
        print(detailes)
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()

        
        
        if detailes?.recevierId == USERID
        {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor(red: 240/255.0, green: 246/255.0, blue: 3/255.0, alpha: 1))
        }
        else
        { 
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor(red: 23/255.0, green: 116/255.0, blue: 122/255.0, alpha: 1))
        }
        
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return 20
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        
        let j = indexPath.item
        /*
        var time1  = ""
        var time2  = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        if j == 0
        {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        else
        {
            
            if let snap1 = self.SingleChatMsgModelData?.data?[j]
            {
                print("snap= \(snap1)")
                
                if let date = self.SingleChatMsgModelData?.data?[indexPath.item].createdAt
                {
                    time1 = date
                }
            }
            
            if (j-1)>0
            {
                if let snap2 = self.SingleChatMsgModelData?.data?[indexPath.item-1]
                {
                    print("snap= \(snap2)")
                    if let date = snap2.createdAt
                    {
                        time2 = date
                    }
                }
            }
            else
            {
                if let snap1 = self.SingleChatMsgModelData?.data?[j]
                {
                    print("snap= \(snap1)")
                    if let date =  snap1.createdAt
                    {
                        time2 = date
                    }
                }
            }
            
            var newDate1 = time1.replacingOccurrences(of: " +0000", with: "")
            var newDate2 = time2.replacingOccurrences(of: " +0000", with: "")
            
            
             let day = Calendar.current.component(.day, from: dateFormatter.date(from: newDate1)!)
             let previouseDay = Calendar.current.component(.day, from: dateFormatter.date(from: newDate2)!)
            print("Date diffrent xxxx")
            print(day)
            print(previouseDay)
            
            if day == previouseDay
            {
                print("equal")
                return 0.0
            }
            else
            {
                print("Not equal")
                
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
            
        }
        */
         return 0
    }
    
    
    
    // FOR SHOWING TIME OF THE MESSAGE

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        
        var detailes = self.SingleChatMsgModelData?.data?[indexPath.item]
        print(detailes)
        var allMSG = self.SingleChatMsgModelData?.data?[indexPath.item].message
        print(allMSG)
        var a1 = self.SingleChatMsgModelData?.data?[indexPath.item].createdAt
        print(a1)
        
        let isoDate = a1
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: (isoDate)!)
        let dateFormatter2 = DateFormatter()
        var DateDataBase = "10:11 AM"
        dateFormatter2.dateFormat = "hh:mm" // superset of OP's format
        if date != nil
        {
            DateDataBase = dateFormatter2.string(from: date!)
        }
        
        
        return NSAttributedString(string: self.UTCToLocal(date: DateDataBase))
//        return NSAttributedString(string: "\(DateDataBase)")
        
    }
    
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        
        let j = indexPath.item
        
        var time1  = ""
        var time2  = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
       /*
        if j == 0
        {
            if let snap1 = self.SingleChatMsgModelData?.data?[j]
            {
                print("snap= \(snap1)")
                if let date = snap1.createdAt
                {
                    time1 = date
                }
            }
            var newDate1 = time1.replacingOccurrences(of: " +0000", with: "")
            print("differ \(self.dateDiff(dateStr: newDate1))")
            var time = (self.dateDiff(dateStr: newDate1))
            if time.contains("Hours Ago") || time.contains("Hour Ago")
            {
            return NSMutableAttributedString(string: "Today", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
             //   return NSMutableAttributedString(string: "Today")
            }
            else
            {
                return NSMutableAttributedString(string: "\(self.dateDiff(dateStr: newDate1))", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
                
                
              //  return NSMutableAttributedString(string: "\(self.dateDiff(dateStr: newDate1))")
            }
        }
        else
        {
            if let snap1 = self.SingleChatMsgModelData?.data?[j]
            {
                print("snap= \(snap1)")
                if let date = snap1.createdAt
                {
                    time1 = date
                }
            }
            
            if (j-1)>0
            {
                if let snap2 = self.SingleChatMsgModelData?.data?[j-1]
                {
                    print("snap= \(snap2)")
                    if let date = snap2.createdAt
                    {
                        time2 = date
                    }
                }
            }
            else
            {
                if let snap1 = self.SingleChatMsgModelData?.data?[j]
                {
                    print("snap= \(snap1)")
                    if let date = snap1.createdAt
                    {
                        time2 = date
                    }
                }
            }
            
            var newDate1 = time1.replacingOccurrences(of: " +0000", with: "")
            var newDate2 = time2.replacingOccurrences(of: " +0000", with: "")
            
            
            let day = Calendar.current.component(.day, from: dateFormatter.date(from: newDate1)!)
            var previouseDay = Calendar.current.component(.day, from: dateFormatter.date(from: newDate2)!)
            if day == previouseDay
            {
                print("equal")
                
                print("differ \(self.dateDiff(dateStr: newDate1))")
                return NSMutableAttributedString(string: "\(self.dateDiff(dateStr: newDate1))", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black]) //NSMutableAttributedString(string: "\(self.dateDiff(dateStr: newDate1))")
            }
            else
            {
                print("Not equal")
                
                print("differ \(self.dateDiff(dateStr: newDate1))")
                var time = (self.dateDiff(dateStr: newDate1))
                if time.contains("Hours Ago") || time.contains("Hour Ago")
                {
                    return  NSMutableAttributedString(string: "Today", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
                    //NSMutableAttributedString(string: "Today")
                }
                else
                {
                    //return NSMutableAttributedString(string: "\(self.dateDiff(dateStr: newDate1))")
                    return NSMutableAttributedString(string: "\(self.dateDiff(dateStr: newDate1))", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
                }
                
            }
        }
 */
 return NSMutableAttributedString(string: "")
    }
    
    //===MARK:---- calculate difference
    
    func dateDiff(dateStr:String) -> String
    {
        let f:DateFormatter = DateFormatter()
        f.timeZone = NSTimeZone.local
        //        f.dateFormat = "yyyy-M-dd'T'HH:mm:ss.SSSZZZ"
        
        f.dateFormat = "yyyy-MM-dd hh:mm:ss"
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = dateFormatter.date(from: dateStr)
        dateFormatter.dateFormat = "dd/MM/yy"
        let str =  dateFormatter.string(from: date!)
        
        
        let ln = Locale.preferredLanguages[0]
        if (ln == "el")
        {
            if (sec > 0)
            {
                if (sec > 1)
                {
                    timeAgo = "Μόλις τωρα"
                } else {
                    timeAgo = "Μόλις τωρα"
                }
            }
            
            if (min > 0){
                if (min > 1) {
                    timeAgo = "Πρίν " + "\(min)" + " λεπτό"
                } else {
                    timeAgo = "Πρίν " + "\(min)" + " λεπτό"
                }
            }
            
            if(hours > 0){
                if (hours > 1) {
                    timeAgo = "Πρίν "  + "\(hours) "+" ώρες"
                } else {
                    timeAgo = "Πρίν " + "\(hours) "+" ώρες"
                }
            }
            
            if (days > 0) {
                if (days > 1) {
                    timeAgo = "Πρίν " + "\(days)" + " μέρες"
                } else {
                    timeAgo = "Πρίν " + "\(days)" + " μέρες"
                }
                
            }
            
            if(weeks > 0){
                if (weeks > 1) {
                    timeAgo = "Πρίν " + "\(weeks)" + " εβδομάδα"
                } else {
                    // timeAgo = "Πρίν" + "\(weeks)" + " εβδομάδα"
                    
                    
                    
                    timeAgo = str
                }
            }
        }
        else
        {
//                        if (sec > 0)
//                        {
//                            if (sec > 1)
//                            {
//                                timeAgo = "\(sec) Seconds Ago"
//                            } else {
//                                timeAgo = "\(sec) Second Ago"
//                            }
//                        }
//            
//                        if (min > 0){
//                            if (min > 1) {
//                                timeAgo = "\(min) Minutes Ago"
//                            } else {
//                                timeAgo = "\(min) Minute Ago"
//                            }
//                        }
            
            if(hours > 0){
                if (hours > 1) {
                    timeAgo = "\(hours) Hours Ago"
                } else {
                    timeAgo = "\(hours) Hour Ago"
                }
            }
            
            if (days > 0) {
                if (days > 1)
                {
                    
                  // timeAgo = "\(days) Days Ago"
                  
                    var time1  = dateStr
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    var newDate1 = time1.replacingOccurrences(of: " +0000", with: "")
                    print(newDate1)
                    
                  //  let datee = dateFormatter.date(from: (newDate1))
                    let dates = dateFormatter.date(from: (newDate1))
                    
                    let dateFormatter3 = DateFormatter()
                    dateFormatter3.dateFormat = "dd MMM yyyy" // superset of OP's format
                    var newdate = ""
                    if dates != nil
                    {
                        newdate = dateFormatter3.string(from: dates!)
                    }
                    
                    
                    let finalDate = newdate
                    
                    timeAgo = finalDate
                    
                }
                if days == 1
                {
                    timeAgo = "Yesterday"
                }
                else
                {
                    // timeAgo = "\(days) Day Ago"
                }
            }
            
            if(weeks > 0){
                if (weeks > 1) {
                    timeAgo = "\(weeks) Weeks Ago"
                }
                else
                {
                    timeAgo = str
                }
            }
        }
        
        print("massage date = \(str)")
        
        print("timeAgo is===> \(timeAgo)")
        return timeAgo;
    }

    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        var userName = "DummyUser"
        if let userName1 = DEFAULT.value(forKey: "userName") as? String
        {
            userName = userName1
        }
        
       var message1 = JSQMessage(senderId: USERID, displayName: userName, text: text)

        
        if message1?.text.count == 0
        {
            self.view.makeToast("Please type your message")
        }
        else
        {
            var new1 = (message1 as? JSQMessage)?.value(forKey: "text")
            self.sendThisMsg = new1 as? String ?? "0"
            if !NetworkEngine.networkEngineObj.isInternetAvailable()
            {
                
                NetworkEngine.showInterNetAlert(vc: self)
            }
            else
            {
                self.SendMsgApi()
                self.GetAllMsgApi()
            }
           
            finishSendingMessage()
            
        }
        
       
    }
 
    override func didPressAccessoryButton(_ sender: UIButton!)
    {
        self.view.endEditing(true)
    

        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.camera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.photoLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    func photoLibrary()
    {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
        
    }
    //  Send Message Api
    
    func SendMsgApi()
    {
        SVProgressHUD.show()
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        
//        var recieverId1 = "1"
//
//        if let recieverid = allData?.recevierId
//        {
//            recieverId1 = recieverid
//        }
//        else
//        {
//            recieverId1 = allData?.senderId ?? "1"
//        }
        
        
        var userName = "DummyUser"
        if let userName1 = DEFAULT.value(forKey: "userName") as? String
        {
            userName = userName1
        }
        
        let para = ["senderId" : USERID as AnyObject,
                    "recevierId" : self.recieverIdd as AnyObject,
                    "message" : self.sendThisMsg] as [String : AnyObject]
        print(para)
        
        ApiHandler.PostModelApiPostMethod(url: ADD_SINGLE_CHATMSG_URL, parameters: para, Header: [ : ]) { (respData, error) in
            do
            {
                let decoder = JSONDecoder()
                if respData != nil
                {
                    self.AddSingleMsgData =  try decoder.decode(AddSingleMsg.self, from: respData!)
                    
                    if self.AddSingleMsgData?.status == "success"
                    {
                        SVProgressHUD.dismiss()
                        
                        var message1 = JSQMessage(senderId: USERID, displayName: userName, text: self.sendThisMsg)
                        self.messages.append(message1!)
                        
                        self.finishSendingMessage()
                        self.GetAllMsgApi()
                        
                    }
                    else
                    {
                        SVProgressHUD.dismiss()
                        self.view.makeToast("No Data Found.")
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
                SVProgressHUD.dismiss()
                print(error)
            }
        }
    }
    
    
  
    //// MARK :-- API METHOD
    
    
    override func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func GetAllMsgApi()
    {
        if fromLoad != "yes"
        {
               SVProgressHUD.show()
        }
        else
        {
            SVProgressHUD.dismiss()
        }
        
     
        
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        
        let para = ["senderId" : USERID,
                    "recevierId" : recieverIdd] as [String : AnyObject]
        print(para)
        
        ApiHandler.PostModelApiPostMethod2(url: GET_SINGLE_CHATMSG_URL, parameters: para, Header: [ : ]) { (respData, error) in
         
            do
            {
                let decoder = JSONDecoder()
                if respData != nil
                {
                    self.SingleChatMsgModelData =  try decoder.decode(SingleChatMessages.self, from: respData!)
                    SVProgressHUD.dismiss()
                    if ((self.SingleChatMsgModelData?.data?.count) != nil)
                    {
                        self.finishReceivingMessage()
                        
                    }
                    else
                    {
                        //  self.view.makeToast("No Data Found.")
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
            }
        }
    }
    
    
    // MARK: -  camera action
    func camera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.delegate = self
            imagePicker.isEditing = true
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alertWarning = UIAlertView(title:"Alert!", message: "You don't have camera", delegate:nil, cancelButtonTitle:"Ok")
            alertWarning.show()
        }
        
    }

    
    func UTCToLocal(date:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"
        
        if dt != nil
        {
          return dateFormatter.string(from: dt!)
        }
        else
        {
            return "10:11 AM"
        }
        
    }
    
}
//MARK: - extension PhotoEditorDelegate  to edit photo

extension MainChatView: PhotoEditorDelegate
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
            self.SendImageMsgApi()
        }
        
        print(self.selectedImageV.image)
    }
    
    func canceledEditing()
    {
        print("Canceled editing")
    }
}

//MARK: - extension UIImagePickerControllerDelegate  delegate

extension MainChatView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
//
        picker.dismiss(animated: true, completion: nil)
        
        
        let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
        photoEditor.photoEditorDelegate = self
        photoEditor.image = image
        //Colors for drawing and Text, If not set default values will be used
        //photoEditor.colors = [.red, .blue, .green]
        
        //Stickers that the user will choose from to add on the image
        for i in 0...10
        {
            photoEditor.stickers.append(UIImage(named: i.description )!)
        }
        
        //To hide controls - array of enum control
        //photoEditor.hiddenControls = [.crop, .draw, .share]
        
        present(photoEditor, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - // Helper function inserted by Swift 4.2 migrator.
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
    
    //MARK:- Send image message
    
    
    func SendImageMsgApi()
    {
        
        ApiHandler.LOADERSHOW()
        
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        
//        var recieverId1 = "1"
//
//        if let recieverid = allData?.recevierId
//        {
//            recieverId1 = recieverid
//        }
//        else
//        {
//            recieverId1 = allData?.senderId ?? "1"
//        }
        
        
        var userName = "DummyUser"
        if let userName1 = DEFAULT.value(forKey: "userName") as? String
        {
            userName = userName1
        }
        
        let params = ["senderId" : USERID,
                      "recevierId" : self.recieverIdd,
                      "messageType" : "i"] as [String : String]
        print(params)
        
        print("All para = ")
        print(params)
        
        print(self.selectedImageV.image)
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        alamoManager = Alamofire.SessionManager(configuration: configuration)
        
        
        self.alamoManager?.upload(multipartFormData: { (multipartFormData) in
            
            
            if self.selectedImageV.image != nil
            {
                multipartFormData.append(self.selectedImageV.image!.jpegData(compressionQuality: 0.75)!, withName: "messageFile", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
            
            
            
            
            
            for (key, value) in params
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
                                  to:ADD_Image_Message_URL)
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
                        self.GetAllMsgApi()
                        if response.data != nil
                        {
                          //  do
                           // {
//                                ApiHandler.LOADERSHOW()
//
//                                let decoder = JSONDecoder()
//
//                                self.apiResponse = try decoder.decode(AddVideoModel.self, from: response.data!)
//
//                                if self.apiResponse?.code == "201"
//                                {
//                                  //  self.view.makeToast(self.apiResponse?.message)
//                                }
//                                SVProgressHUD.dismiss()
//                            }
//                            catch let error
//                            {
//                                print(error)
//                                SVProgressHUD.dismiss()
//                            }
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
}
