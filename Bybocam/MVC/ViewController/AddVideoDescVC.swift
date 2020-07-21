//
//  AddVideoDescVC.swift
//  Bybocam
//
//  Created by Eweb on 16/07/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class AddVideoDescVC: UIViewController,UITextViewDelegate
    
{
    @IBOutlet weak var myPopUpTable: UITableView!
    var GetFavUserModelData:GetFavouriteUserModel?
    var myTempArray = NSMutableArray()
    var favArray = NSMutableArray()
    var userIdArray = NSMutableArray()
    var userNameArray = NSMutableArray()
    var SendMsgToGroup:AddCommentModel?
    var fromMsgPage = ""
    var checkArray = NSMutableArray()
    var arrayFruits = [String]()
    
    var signupData:SignUpModel?
    @IBOutlet weak var thumbImg: UIImageView!
      @IBOutlet weak var descTxt: UITextView!
    
    var fromEditImage = ""
    var videoURL : URL?
    
    var image : UIImage?
    
    var shareVideoUrl = ""
    
    
    var revicersIds = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPopUpTable.register(UINib(nibName: "ChatListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListTableViewCell")
        // Do any additional setup after loading the view.
        
        self.thumbImg.image = image
        descTxt.delegate=self
        
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            self.FevouriteUserApi()
        }
        
        self.myPopUpTable.isHidden=true
    }
    @IBAction func gobackAct(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

   func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
   {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
    
    if numberOfChars < 50
    {
        return true
    }
    else
    {
           NetworkEngine.commonAlert(message: "Discription will maximum 50 characters.", vc: self)
         return false
    }
  
    }
}
extension AddVideoDescVC:UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.GetFavUserModelData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell") as! ChatListTableViewCell
        
        var dict = self.GetFavUserModelData?.data?[indexPath.row]
        
        cell.labl.text = dict?.firstName ?? ""
        
        cell.btn.tag = indexPath.row
        cell.btn.addTarget(self, action: #selector(TablePlayVideo), for: .touchUpInside)
        
        cell.btn2.tag = indexPath.row
        cell.btn2.addTarget(self, action: #selector(TablePlayVideo), for: .touchUpInside)
        
        
        cell.labl.text = dict?.userName
        
        
        if self.checkArray.contains(indexPath.row)
        {
            cell.btn.setImage(#imageLiteral(resourceName: "CheckBox.png"), for: .normal)
            if !self.userIdArray.contains(dict?.userId)
            {
                self.userIdArray.add(dict?.userId)
                self.userNameArray.add(dict?.userName)
            }
            
        }
        else
        {
            cell.btn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        }
        
        
        
        return cell
    }
    @IBAction func tagFriendVideo(_ sender:UIButton)
    {
       
               
        if sender.isSelected
        {
            sender.isSelected = false
            self.myPopUpTable.isHidden=true
        }
        else
        {
            sender.isSelected = true
            self.myPopUpTable.isHidden=false
        }
        
    }
    
    @IBAction func shareVideo(_ sender:UIButton)
    {
      
        self.myPopUpTable.isHidden=true
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else if self.userIdArray.count == 0
            {

                NetworkEngine.commonAlert(message: "Please select user to share.", vc: self)
            }
        else
        {
            self.EditProfileAPi()
        }
    }
    
    
    @objc func TablePlayVideo(_ sender:UIButton)
    {
        print("Button is tapped")
        
        
        if self.userIdArray.count>0
        {
            self.userIdArray.removeAllObjects()
            self.userNameArray.removeAllObjects()
        }
        
        if self.checkArray.contains(sender.tag)
        {
            self.checkArray.remove(sender.tag)
        }
        else
        {
            self.checkArray.add(sender.tag)
        }
        print("check array = \(self.checkArray)")
        self.myPopUpTable.reloadData()
        
    }
    func FevouriteUserApi()
    {
        SVProgressHUD.show()
        
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        
        let para = ["userId" : USERID] as [String : AnyObject]
        print(para)
        
        ApiHandler.PostModelApiPostMethod(url: FEVOURITE_USER_URL, parameters: para, Header: [ : ]) { (respData, error) in
            
            do
            {
                let decoder = JSONDecoder()
                if respData != nil
                {
                    self.GetFavUserModelData =  try decoder.decode(GetFavouriteUserModel.self, from: respData!)
                    
                    if ((self.GetFavUserModelData?.data?.count) != nil)
                    {
                        self.myPopUpTable.reloadData()
                    }
                    else
                    {
                        
                    }
                    self.myPopUpTable.reloadData()
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
    
    // Edit Profile Api here...
    
    func EditProfileAPi()
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
        
        
        let para = ["senderId" : USERID,
                    "revicersIds" : self.userIdArray.componentsJoined(by: ","),
                    "discriptions" : self.descTxt.text!] as! [String : String]
        
        print(para)
        SVProgressHUD.show()
        SVProgressHUD.setBorderColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(UIColor.black)
        
        Alamofire.upload(multipartFormData:
            {
                (multipartFormData) in
                let timestamp = NSDate().timeIntervalSince1970
                if self.thumbImg.image != nil
                {
                    
                    let imgData = self.thumbImg.image!.jpegData(compressionQuality: 0.2)!
                    
                    
                    multipartFormData.append(imgData, withName: "videoImage" , fileName: "\(timestamp*10).jpg" , mimeType: "\(timestamp*10)/jpg")
                }
                
                if self.videoURL != nil
                {
                    multipartFormData.append(self.videoURL!, withName: "RandomVideo" , fileName: "\(timestamp).mov" , mimeType: "\(timestamp)/mov")
                }
                
                
                
                
                print("Para in upload = \(self.videoURL)")
                print("\(self.thumbImg.image)")
                
                
                
                
                for (key, value) in para
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
        }, to:"https://a1professionals.net/bybocam/api/addRandomVideos")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON
                    {
                        response in
                        print(response)
                        
                        
                        if response.data != nil
                        {
                            do
                            {
                                ApiHandler.LOADERSHOW()
                                
                                let decoder = JSONDecoder()
                                
                                self.signupData = try decoder.decode(SignUpModel.self, from: response.data!)
                                
                                if self.signupData?.code == "201"
                                {
                                    
                                    
                                      APPDEL.Autologin()
                                }
                                SVProgressHUD.dismiss()
                            }
                            catch let error
                            {
                                print(error)
                            }
                        }
                        
                }
                break
            case .failure(let encodingError):
                SVProgressHUD.dismiss()
                print(encodingError)
                break
            }
        }
    }
    
}
