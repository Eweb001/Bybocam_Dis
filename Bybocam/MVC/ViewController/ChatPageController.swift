//
//  ChatPageController.swift
//  Bybocam
//
//  Created by eWeb on 07/12/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit

import SVProgressHUD
import Alamofire
import SVProgressHUD
import Toast_Swift

class ChatPageController: UIViewController {

    
    var GetFavUserModelData:GetFavouriteUserModel?
    
    @IBOutlet weak var typeMsgRoundView: UIView!
    @IBOutlet weak var typeMsgTf: UITextField!
    
    @IBOutlet weak var Btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btn10: UIButton!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: UIView!
    @IBOutlet weak var view8: UIView!
    @IBOutlet weak var view9: UIView!
    @IBOutlet weak var view10: UIView!
    
    @IBOutlet weak var name1: UITextField!
    @IBOutlet weak var name2: UITextField!
    @IBOutlet weak var name3: UITextField!
    @IBOutlet weak var name4: UITextField!
    @IBOutlet weak var name5: UITextField!
    @IBOutlet weak var name6: UITextField!
    @IBOutlet weak var name7: UITextField!
    @IBOutlet weak var name8: UITextField!
    @IBOutlet weak var name9: UITextField!
    @IBOutlet weak var name10: UITextField!
    
    
    
   

    var userNameArray = NSMutableArray()
    var userNameArray2 = NSMutableArray()
    
    var userIdArray1 = NSMutableArray()
    var userIdArray2 = NSMutableArray()
    
    var favArray = NSMutableArray()
    var SendMsgToGroup:AddCommentModel?
    var fromMsgPage = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        typeMsgRoundView.layer.cornerRadius = 15
        typeMsgRoundView.layer.borderWidth = 1
        typeMsgRoundView.layer.borderColor = UIColor.darkGray.cgColor
        typeMsgTf.placeholderColor(UIColor.black)
        
        hideView()
      
        self.FevouriteUserApi()
    }
    
    func hideView()
    {
        view2.isHidden = true
        view3.isHidden = true
        view4.isHidden = true
        view5.isHidden = true
        view6.isHidden = true
        view7.isHidden = true
        view8.isHidden = true
        view9.isHidden = true
        view10.isHidden = true
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func PlusAction(_ sender: UIButton)
    {

        if sender.tag == 1
        {
            
            if sender.image(for: .normal) == UIImage(named: "CanclImg")
            {
                self.userNameArray.add(self.name1.text!)
               
                var userId =
                
                self.view1.isHidden = true
            }
            else
            {
               // self.setupDropDown(toShowText: name1)
            }
            
        }
        else  if sender.tag == 2
        {
            
            if sender.image(for: .normal) == UIImage(named: "CanclImg")
            {
              self.userNameArray.add(self.name2.text!)
                self.view2.isHidden = true
            }
            else
            {
             //  self.setupDropDown(toShowText: name2)
            }
            
        }
        else  if sender.tag == 3
        {
            
            if sender.image(for: .normal) == UIImage(named: "CanclImg")
            {
                self.userNameArray.add(self.name3.text!)
                self.view3.isHidden = true
            }
            else
            {
               // self.setupDropDown(toShowText: name3)
            }
            
        }
        else  if sender.tag == 4
        {
            if sender.image(for: .normal) == UIImage(named: "CanclImg")
            {
                self.userNameArray.add(self.name4.text!)
                self.view4.isHidden = true
            }
            else
            {
                //self.setupDropDown(toShowText: name4)
            }
           
        }
        else  if sender.tag == 5
        {
            if sender.image(for: .normal) == UIImage(named: "CanclImg")
            {
                self.userNameArray.add(self.name5.text!)
                self.view5.isHidden = true
            }
            else
            {
               // self.setupDropDown(toShowText: name5)
            }
           
        }
        else  if sender.tag == 6
        {
            if sender.image(for: .normal) == UIImage(named: "CanclImg")
            {
                self.userNameArray.add(self.name6.text!)
                self.view6.isHidden = true
            }
            else
            {
               /// self.setupDropDown(toShowText: name6)
            }
        
        }
        else  if sender.tag == 7
        {
            if sender.image(for: .normal) == UIImage(named: "CanclImg")
            {
                self.userNameArray.add(self.name7.text!)
                self.view7.isHidden = true
            }
            else
            {
               // self.setupDropDown(toShowText: name7)
            }
            
        }
        else  if sender.tag == 8
        {
            if sender.image(for: .normal) == UIImage(named: "CanclImg")
            {
                self.userNameArray.add(self.name8.text!)
                self.view8.isHidden = true
            }
            else
            {
                //self.setupDropDown(toShowText: name8)
            }
            
        }
        else  if sender.tag == 9
        {
            if sender.image(for: .normal) == UIImage(named: "CanclImg")
            {
                self.userNameArray.add(self.name9.text!)
                self.view9.isHidden = true
            }
            else
            {
              //  self.setupDropDown(toShowText: name9)
            }
            
        }
        else  if sender.tag == 10
        {
            if sender.image(for: .normal) == UIImage(named: "CanclImg")
            {
                self.userNameArray.add(self.name10.text!)
                self.view10.isHidden = true
            }
            else
            {
               // self.setupDropDown(toShowText: name10)
            }
            
        }
     
        
    }
 

    
    
    
    @IBAction func sendMsgAct(_ sender: UIButton)
    {
        
        if typeMsgTf.text == ""
        {
            self.view.makeToast("Please type your message.")
        }
        else if name1.text == ""
        {
            self.view.makeToast("Please add sender name.")
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
        
        print(favArray)
        print(userNameArray)
        print(userIdArray1)
    }
    
    
    func SendMsgApi()
    {
        
        
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        
        if name1.text != ""
        {
            print(name1)
        }
        else if name2.text != ""
        {
            print(name2)
        }
        else if name3.text != ""
        {
            print(name3)
        }
        else if name4.text != ""
        {
            print(name4)
        }
        else if name5.text != ""
        {
            print(name5)
        }
        
        let para = ["senderId" : USERID,
                    "recevierId" : name1.text!,
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
                            self.favArray.add(dict.userName as! String)
                            self.userNameArray.add(dict.userId as! String)
                        }
                        self.userNameArray = self.favArray

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

    @IBAction func OpenDemoPage(_ sender: UIBarButtonItem)
    {
        
        
    
        
    }
}
