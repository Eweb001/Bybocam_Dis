//
//  DemoChatView.swift
//  Bybocam
//
//  Created by APPLE on 16/12/19.
//  Copyright © 2019 eWeb. All rights reserved.
//
/*
import UIKit

class DemoChatView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

}


//
//  NewChatViewController.swift
//  LaptureApp
//
//  Created by administrator on 24/05/19.
//  Copyright © 2019 A1 professionals. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import FirebaseAuth
import FirebaseCore
import CoreData
import FirebaseStorage
import FileProvider
import FirebaseDatabase
import FirebaseMessaging
class DemoChatView:JSQMessagesViewController,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate{
    
    var messages = [JSQMessage]()
    var recieverId = ""
    var recieverName = ""
    
    var fromCamera = ""
    
    var firstMsgDate = "yes"
    var arrayDate = [String]()
    
    var choosenImage:UIImage! = nil
    var isImageChoosen = false
    var picker:UIImagePickerController?=UIImagePickerController()
    
    var allChatData = NSMutableArray()
    
    var userId = (DEFAULT.value(forKey: "userData") as! NSDictionary).value(forKey: "id") as! String
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        
        
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.init(red: 76/255.0, green: 106/255.0, blue: 219/255.0, alpha: 1))
        
        //   return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage =
        {
            //            return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
            
            return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.init(red: 240/255.0, green: 242/255.0, blue: 244/255.0, alpha: 1))
    }()
    var customView = UIView()
    var StatusView = UIView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        senderId = userId
        senderDisplayName = "dave"
        
        customView.frame = CGRect.init(x: 0, y: UIApplication.shared.statusBarFrame.height, width: UIScreen.main.bounds.width, height: 60)
        
        customView.backgroundColor = UIColor.red
        
        
        customView.backgroundColor = CHATBACKCOLOR
        
        picker?.delegate=self
        
        StatusView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height)
        StatusView.backgroundColor = APPSTATUSCOLOR
        self.view.addSubview(StatusView)
        
        
        let backBtn = UIButton()
        backBtn.frame = CGRect.init(x: 8, y: 15, width: 25, height: 25)
        backBtn.setImage(UIImage(named: "newLeft1"), for: .normal)
        backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        customView.addSubview(backBtn)
 
        
        let imageName = "imagesw"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 45, y: 15, width: 30, height: 30)
        customView.addSubview(imageView)
 
 
        //
        //        backBtn.setImage(UIImage(named: "newLeft1"), for: .normal)
        //        backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x: 95, y: 15, width: 200, height: 20))
        
        label.textAlignment = .left
        
        label.text = recieverName
        
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        customView.addSubview(label)
        
        
        
        let online = UILabel(frame: CGRect(x: 95, y: 35, width: 200, height: 18))
        
        online.textAlignment = .left
        online.font = UIFont.systemFont(ofSize: 14.0)
        online.text = "Online"
        online.textColor = CHATONLINECOLOR
        
        customView.addSubview(online)
        
        
        customView.addSubview(backBtn)
        
        
        
        self.view.addSubview(customView)
        
        
        self.tabBarController?.tabBar.isHidden  = true
        
        inputToolbar.barStyle = .black
        
        print("inputToolbar.contentView.leftBarButtonItem.currentImage \(inputToolbar.contentView.leftBarButtonItem.currentImage)")
        inputToolbar.contentView.leftBarButtonItem.imageView?.image = nil
        
        inputToolbar.contentView.leftBarButtonItem.setImage(UIImage(named: "plus-20"), for: .normal)
        inputToolbar.contentView.leftBarButtonItem.setImage(UIImage(named: "plus-20"), for: .focused)
        inputToolbar.contentView.leftBarButtonItem.setImage(UIImage(named: "plus-20"), for: .selected)
        
        inputToolbar.contentView.backgroundColor = UIColor.white
        //         inputToolbar.contentView.layer.borderWidth = 1
        inputToolbar.contentView.textView.layer.backgroundColor = UIColor.clear.cgColor
        //        inputToolbar.contentView.layer.borderColor = UIColor.clear.cgColor
        
        inputToolbar.contentView.textView.backgroundColor = CHATBACKCOLOR
        inputToolbar.contentView.textView.layer.cornerRadius = inputToolbar.contentView.textView.frame.height/2
        inputToolbar.contentView.rightBarButtonItem.setTitle("", for: .normal)
        inputToolbar.contentView.textView.isUserInteractionEnabled = true
        inputToolbar.contentView.textView.placeHolder = "  Message"
        
        inputToolbar.contentView.rightBarButtonItem.isEnabled = true
        inputToolbar.contentView.rightBarButtonItem.isHidden = false
        
        inputToolbar.contentView.rightBarButtonItem.isUserInteractionEnabled = true
        
        
        inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: "newMsg-20"), for: .normal)
        
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        inputToolbar.contentView.textView.delegate = self
        
        inputToolbar.contentView.textView.addDoneOnKeyboardWithTarget(self, action: #selector(firstResponderAction), shouldShowPlaceholder: true)
        
        
        
        getAllMassage()
        
        
    }
    
    func saveImageDocumentDirectory() {
        
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("newMsg-20")
        let image = UIImage(named: "newMsg-20")
        print(paths)
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    @objc func firstResponderAction()
        
    {
        inputToolbar.contentView.textView.resignFirstResponder()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        cell.textView!.textColor = UIColor.black
        cell.avatarImageView.sd_setImage(with: URL(string: "https://www.google.com/search?q=%22https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Flapture-web.appspot.com%2Fo%2Fmessage_images%252F5EC23218-BB18-4FAC-997E-993A377513F3%3Falt%3Dmedia%26token%3D0a604167-f3b0-4a85-bf23-22fdfbb91df5&oq=%22https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Flapture-web.appspot.com%2Fo%2Fmessage_images%252F5EC23218-BB18-4FAC-997E-993A377513F3%3Falt%3Dmedia%26token%3D0a604167-f3b0-4a85-bf23-22fdfbb91df5&aqs=chrome..69i57j69i59.1832j0j9&sourceid=chrome&ie=UTF-8"))
        
        let message = messages[indexPath.item]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // superset of OP's format
        
        let DateDataBase = dateFormatter.string(from: message.date)
        //        let date = dateFormatter.dateFromString(DateDataBase)
        
        print("\(DateDataBase)")
        
        cell.cellTopLabel.isHidden = false
        // cell.cellTopLabel.text = "\(DateDataBase)"
        cell.cellTopLabel.textColor = UIColor.black
        if messages[indexPath.item].senderId == senderId
        {
            cell.textView!.textColor = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
            
        }
        else
        {
            cell.textView!.textColor = UIColor.init(red: 84/255.0, green: 84/255.0, blue: 87/255.0, alpha: 1)
        }
        return cell
        
    }
    
    @objc func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        
        let message = messages[indexPath.item]
        
        if let snap = allChatData.object(at: indexPath.item) as? DataSnapshot
        {
            print("snap= \(snap)")
            if let date = (snap.value as! NSDictionary).value(forKey: "message_time") as? String
            {
                var newDate = date.replacingOccurrences(of: " +0000", with: "")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // superset of OP's format
                
                // let DateDataBase = dateFormatter.string(from: date)
                let date = dateFormatter.date(from: newDate)
                if let date1 = date
                {
                    let DateDataBase = dateFormatter.string(from: date!)
                    
                    print("\(date)")
                    return NSAttributedString(string: UTCToLocal(date: DateDataBase))
                }
                    
                else
                {
                    return NSAttributedString(string: "")
                }
            }
            else
                
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss" // superset of OP's format
                
                let DateDataBase = dateFormatter.string(from: message.date)
                return NSAttributedString(string: "\(DateDataBase)")
            }
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss" // superset of OP's format
            
            let DateDataBase = dateFormatter.string(from: message.date)
            return NSAttributedString(string: "\(DateDataBase)")
        }
        
        
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        
        let j = indexPath.item
        
        var time1  = ""
        var time2  = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // dateFormatter.calendar = NSCalendar.current
        // dateFormatter.timeZone = TimeZone.current
        
        //   let dt = dateFormatter.date(from: date)
        
        if j == 0
        {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        else
        {
            
            if let snap1 = allChatData.object(at: j) as? DataSnapshot
            {
                print("snap= \(snap1)")
                if let date = (snap1.value as! NSDictionary).value(forKey: "message_time") as? String
                {
                    time1 = date
                }
            }
            
            if (j-1)>0
            {
                if let snap2 = allChatData.object(at: j-1) as? DataSnapshot
                {
                    print("snap= \(snap2)")
                    if let date = (snap2.value as! NSDictionary).value(forKey: "message_time") as? String
                    {
                        time2 = date
                    }
                }
            }
            else
            {
                if let snap1 = allChatData.object(at: j) as? DataSnapshot
                {
                    print("snap= \(snap1)")
                    if let date = (snap1.value as! NSDictionary).value(forKey: "message_time") as? String
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
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        
        let j = indexPath.item
        
        
        var time1  = ""
        var time2  = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // dateFormatter.calendar = NSCalendar.current
        // dateFormatter.timeZone = TimeZone.current
        
        //   let dt = dateFormatter.date(from: date)
        
        if j == 0
        {
            if let snap1 = allChatData.object(at: j) as? DataSnapshot
            {
                print("snap= \(snap1)")
                if let date = (snap1.value as! NSDictionary).value(forKey: "message_time") as? String
                {
                    time1 = date
                }
            }
            var newDate1 = time1.replacingOccurrences(of: " +0000", with: "")
            print("differ \(self.dateDiff(dateStr: newDate1))")
            var time = (self.dateDiff(dateStr: newDate1))
            if time.contains("Hours Ago") || time.contains("Hour Ago")
            {
                return NSMutableAttributedString(string: "Today")
            }
            else
            {
                return NSMutableAttributedString(string: "\(self.dateDiff(dateStr: newDate1))")
            }
            
            
        }
        else
        {
            
            if let snap1 = allChatData.object(at: j) as? DataSnapshot
            {
                print("snap= \(snap1)")
                if let date = (snap1.value as! NSDictionary).value(forKey: "message_time") as? String
                {
                    time1 = date
                }
            }
            
            if (j-1)>0
            {
                if let snap2 = allChatData.object(at: j-1) as? DataSnapshot
                {
                    print("snap= \(snap2)")
                    if let date = (snap2.value as! NSDictionary).value(forKey: "message_time") as? String
                    {
                        time2 = date
                    }
                }
            }
            else
            {
                if let snap1 = allChatData.object(at: j) as? DataSnapshot
                {
                    print("snap= \(snap1)")
                    if let date = (snap1.value as! NSDictionary).value(forKey: "message_time") as? String
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
                return NSMutableAttributedString(string: "\(self.dateDiff(dateStr: newDate1))")
            }
            else
            {
                print("Not equal")
                
                print("differ \(self.dateDiff(dateStr: newDate1))")
                var time = (self.dateDiff(dateStr: newDate1))
                if time.contains("Hours Ago") || time.contains("Hour Ago")
                {
                    return NSMutableAttributedString(string: "Today")
                }
                else
                {
                    return NSMutableAttributedString(string: "\(self.dateDiff(dateStr: newDate1))")
                }
                
            }
        }
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return 20
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        
        
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date)
    {
        let ref = Constants.refs.databaseChats.child(self.recieverId + "_" + self.userId).childByAutoId()
        var device_token = "fbe36f51edbb131c98b70d52b4c58fc82549106ec4e2d2dec03a08a82b326b94"
        if let token = DEFAULT.value(forKey: "DEVICETOKEN") as? String
        {
            device_token = token
        }
        
        let message = ["from_user_id": senderId, "from_user_name": senderDisplayName, "message": text,"to_user_id": recieverId, "to_user_name": recieverName, "to_deviceid": device_token,"message_time":"\(date)"]
        
        ref.setValue(message)
        
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!)
    {
        self.view.endEditing(true)
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.openCamera()
            
            
            
        })
        let saveAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.openGallary()
            
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
        
        
        
        
        
    }
    
    
    // MARK:--- Open galary Method---
    func openGallary()
    {
        
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            self .present(picker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            
            let mediaItem = JSQPhotoMediaItem(image: nil)
            mediaItem?.appliesMediaViewMaskAsOutgoing = true
            mediaItem?.image = UIImage(data: UIImageJPEGRepresentation(selectedImage, 0.5)!)
            let sendMessage = JSQMessage(senderId: senderId, displayName: self.senderId, media: mediaItem)
            // self.messages.append(sendMessage!)
            // inputToolbar.contentView.textView.text = "\(selectedImageFromPicker)"
            //  self.finishSendingMessage()
            uploadToFirebaseStorageUsingImage(image: selectedImage)
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    
    private func uploadToFirebaseStorageUsingImage(image: UIImage)
    {
        let imageName = NSUUID().uuidString
        
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        if let uploadData = UIImageJPEGRepresentation(image, 0.3)
        {
            
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    
                    print("failed to load:", error)
                    return
                }
                
                if let  imageUrl = metadata?.name{
                    
                    
                }
                
                ref.downloadURL(completion: { (url, error) in
                    if let urlText = url?.absoluteString {
                        
                        
                        print("///////////tttttttt//////// \(urlText)   ///////)
                        // self.sendMessageWithImageUrl(imageUrl: urlText)
                        
                    }
                })
            }
            )
            
        }
        
    }
    
    
    private func sendMessageWithImageUrl(imageUrl: String){
        
        let ref = Constants.refs.databaseChats.child(self.recieverId + "_" + self.userId).childByAutoId()
        var device_token = "fbe36f51edbb131c98b70d52b4c58fc82549106ec4e2d2dec03a08a82b326b94"
        if let token = DEFAULT.value(forKey: "DEVICETOKEN") as? String
        {
            device_token = token
        }
        
        let message = ["from_user_id": self.userId, "from_user_name": senderDisplayName, "message": imageUrl,"to_user_id": recieverId, "to_user_name": recieverName, "to_deviceid": device_token,"message_time":"2019-05-29 13:54:22 +0000"] as [String : Any]
        
        ref.setValue(message)
        
        return self.finishSendingMessage(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func getAllMassage()
    {
        
        if allChatData.count>0
        {
            self.allChatData.removeAllObjects()
        }
        
        let dbRef = Constants.refs.databaseChats.queryLimited(toLast: 100)
        let nextRef = Constants.refs.databaseChats.child(self.recieverId + "_" + self.userId)
        let query = nextRef.queryLimited(toLast: 10)
        
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            
            
            print("data snap = \(snapshot.value as? [String: String])")
            
            if  let data        = snapshot.value as? [String: String],
                let id          = data["to_user_id"],
                let name        = data["to_user_name"],
                let text        = data["message"],
                !text.isEmpty
            {
                
                if let message = JSQMessage(senderId: id, senderDisplayName: name, date: Date(), text: text)
                {
                    self?.messages.append(message)
                    
                    self?.allChatData.add(snapshot)
                    
                    self?.finishReceivingMessage()
                }
            }
        })
        
        
        
    }
    func localToUTC(date:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: dt!)
    }
    
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: dt!)
    }
    
    func dateDiff2(dateStr:String) -> Int32
    {
        let f:DateFormatter = DateFormatter()
        f.timeZone = NSTimeZone.local
        
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //   f.dateFormat = "MMM d"
        let now = f.string(from: NSDate() as Date)
        let startDate = f.date(from: dateStr)
        let endDate = f.date(from: now)
        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        
        let calendarUnits:NSCalendar.Unit = [.weekOfMonth,.day,.year]
        let dateComponents = calendar.components(calendarUnits, from: startDate!, to: endDate!, options: [])
        let weeks = abs(Int32(dateComponents.weekOfMonth!))
        let days = abs(Int32(dateComponents.day!))
        //        let hours = abs(Int32(dateComponents.hour!))
        //        let min = abs(Int32(dateComponents.minute!))
        //        let sec = abs(Int32(dateComponents.second!))
        
        
        var timeAgo = Int32()
        
        
        
        
        if (days > 0) {
            if (days > 1) {
                timeAgo = days /\(days) Day Ago"
            } else {
                timeAgo = days /\(days) Days Ago"
            }
        }
        
        if(weeks > 0){
            if (weeks > 1) {
                timeAgo = weeks /\(weeks) Week Ago"
            } else {
                timeAgo =  weeks/\(weeks) Weeks Ago"
            }
        }
        
        print("timeAgo is===> \(timeAgo)")
        return timeAgo;
    }
    
    //===MARK:---- calculate difference
    
    func dateDiff(dateStr:String) -> String {
        let f:DateFormatter = DateFormatter()
        f.timeZone = NSTimeZone.local
        //        f.dateFormat = "yyyy-M-dd'T'HH:mm:ss.SSSZZZ"
        
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
            //            if (sec > 0)
            //            {
            //                if (sec > 1)
            //                {
            //                    timeAgo = "\(sec) Seconds Ago"
            //                } else {
            //                    timeAgo = "\(sec) Second Ago"
            //                }
            //            }
            //
            //            if (min > 0){
            //                if (min > 1) {
            //                    timeAgo = "\(min) Minutes Ago"
            //                } else {
            //                    timeAgo = "\(min) Minute Ago"
            //                }
            //            }
            
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
                    timeAgo = str
                }
            }
        }
        
        print("massage date = \(str)")
        
        print("timeAgo is===> \(timeAgo)")
        return timeAgo;
    } {Lapture}
    
    func firstMessageOfTheDay(indexOfMessage: IndexPath) -> Bool
    {
        let messageDate = messages[indexOfMessage.item].date
        guard let previouseMessageDate = messages[indexOfMessage.item - 1].date else
        {
            return true // because there is no previous message so we need to show the date
        }
        let day = Calendar.current.component(.day, from: messageDate!)
        let previouseDay = Calendar.current.component(.day, from: previouseMessageDate)
        if day == previouseDay
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    
}
extension Date {
    
    func currentTimeZoneDate() -> String
    {
        let dtf = DateFormatter()
        dtf.timeZone = TimeZone.current
        dtf.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dtf.string(from: self)
    }
}



///
*/
