//
//  sendMessgaeViewController.swift
//  Bybocam
//
//  Created by APPLE on 12/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit
import SVProgressHUD
import IQKeyboardManager

class sendMessgaeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    
    @IBOutlet weak var nodataFound: UILabel!
    @IBOutlet weak var btmConst: NSLayoutConstraint!
    
    var myTempArray1 = NSMutableArray()
    var userIdArray = NSMutableArray()
    var userNameArray = NSMutableArray()
    var myTempArray = NSMutableArray()
    var favArray = NSMutableArray()
    var SendMsgToGroup:AddCommentModel?
    var fromMsgPage = ""
    var checkArray = NSMutableArray()
    var arrayFruits = [String]()
    var GetFavUserModelData:GetFavouriteUserModel?
    var selectedgroupArray = NSMutableArray()
    var selectedgroupCatArray = NSMutableArray()
    var imagePicker = UIImagePickerController()
    var choosenImage:UIImage!
    
    
    @IBOutlet weak var mainPopUpView: UIView!
    @IBOutlet weak var RecieverNameTf: UITextField!
    @IBOutlet weak var typeMsgTf: UITextField!
    @IBOutlet weak var typeMsgRoundView: UIView!
    
    // POP UP TABLE
    
    @IBOutlet weak var myPopUpTable: UITableView!
    @IBOutlet weak var popUp: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mainPopUpView.isHidden = true
        self.nodataFound.isHidden = true
        
        // 000000
        popUp.layer.cornerRadius = 18
        
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
             FevouriteUserApi()
        }
        
        
       
        arrayFruits = ["Apple","Banana","Orange","Grapes","Watermelon"]

        myPopUpTable.register(UINib(nibName: "ChatListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListTableViewCell")
        
        typeMsgRoundView.layer.cornerRadius = 25
        typeMsgRoundView.layer.borderWidth = 1
        typeMsgRoundView.layer.borderColor = UIColor.darkGray.cgColor
        RecieverNameTf.placeholderColor(UIColor.black)
        typeMsgTf.placeholderColor(UIColor.black)
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification,object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide),name: UIResponder.keyboardWillHideNotification,object: nil)
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
            self.btmConst.constant = -keyboardHeight
            
        }
    }
    @objc func keyboardWillHide(_ notification: Notification)
    {
       
        
            self.btmConst.constant = -10
            
        
    }

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
    func openCamera()
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
    
    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        
       // userImg.layer.cornerRadius = userImg.frame.size.height/2
        
        
        if let editing = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            
            choosenImage =  editing
           // userImg.image = choosenImage
            
        }
        else
        {
            choosenImage =  (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
           // userImg.image = choosenImage
        }
        
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
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
    @IBAction func goBack(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sendMsgAct(_ sender: UIButton)
    {
        if RecieverNameTf.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please add users to send message.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if typeMsgTf.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your comment", preferredStyle: UIAlertController.Style.alert)
            
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
                self.SendMsgApi()
            }
           
        }
        
    }
   
    @IBAction func cancelAct(_ sender: UIBarButtonItem)
    {
        let home1 = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabViewController") as! HomeTabViewController
        self.navigationController?.pushViewController(home1, animated: true)
    }
    @IBAction func AddBtn(_ sender: UIButton)
    {
        
     self.mainPopUpView.isHidden = false
     
    }
    @IBAction func popUpSubmit(_ sender: Any)
    {
        print(self.userIdArray)
        print(self.userNameArray)
        
        let id = self.userIdArray.componentsJoined(by: ",")
        print(id)
        
        let name = self.userNameArray.componentsJoined(by: ",")
        print(name)
        
        self.RecieverNameTf.text = self.userNameArray.componentsJoined(by: ", ")
        self.mainPopUpView.isHidden = true
        
     }
    @IBAction func popupCancel(_ sender: Any)
    {
        self.mainPopUpView.isHidden = true
    }
    @IBAction func Opencam(_ sender: UIButton)
    {
        self.openCamera()
        
    }
    @IBAction func AddEmoji(_ sender: UIButton)
    {
        
    }
    func FevouriteUserApi()
    {
        SVProgressHUD.show()
        if  self.favArray.count>0
        {
            self.favArray.removeAllObjects()
        }
        
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
                        for dict in self.GetFavUserModelData?.data ?? []
                        {
                            self.nodataFound.isHidden = true
                            self.favArray.add(dict.userName as! String)
//                           self.myTempArray1.add(dict.userId as? String)
                        }
//                        self.myTempArray = self.favArray
//                        var a = self.myTempArray1.componentsJoined(by: ",")
//                        print(a)
                    }
                     else
                    {
                        self.nodataFound.isHidden = false
                      //  self.view.makeToast("No Data Found.")
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
    
    
    
    // MARK:-- SendMsgApi
    
    func SendMsgApi()
    {
        
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        
        let para = ["senderId" : USERID,
                    "recevierId" : self.userIdArray.componentsJoined(by: ","),
                    "message" : typeMsgTf.text!] as [String : AnyObject]
        print(para)
        
        ApiHandler.PostModelApiPostMethod(url: ADD_SINGLE_AND_GROUP_MSG_URL, parameters: para, Header: [ : ]) { (respData, error) in
            
            do
            {
                let decoder = JSONDecoder()
                if respData != nil
                {
                    self.SendMsgToGroup =  try decoder.decode(AddCommentModel.self, from: respData!)
                    
                    if self.SendMsgToGroup?.status == "success"
                    {
                        self.view.makeToast(self.SendMsgToGroup?.message)
                        self.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
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
                print(error)
            }
        }
    }
 
    @IBAction func openPopUp(_ sender: UIButton)
    {
        self.mainPopUpView.isHidden = false
        
    }
    @IBAction func PopupHideBtn(_ sender: UIButton)
    {
    self.mainPopUpView.isHidden = true
        
    }
}
