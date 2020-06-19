//
//  ExtraViewController.swift
//  Bybocam
//
//  Created by APPLE on 11/12/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SVProgressHUD
import Toast_Swift

class ExtraViewController: UIViewController
{
    
    
    var UserIdArray = NSMutableArray()
    var UserIdDict = NSMutableDictionary()
    var myTempArray = NSMutableArray()

    var favArray = NSMutableArray()
    var SendMsgToGroup:AddCommentModel?
    var fromMsgPage = ""
    var GetFavUserModelData:GetFavouriteUserModel?
    var newResultArray = NSMutableArray()
  
    
    @IBOutlet weak var addNameBtn: UIBarButtonItem!
 
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
           FevouriteUserApi()
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
        
        ApiHandler.PostModelApiPostMethod(url: FEVOURITE_USER_URL, parameters: para, Header: [ : ])
        { (respData, error) in
            
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
                            self.UserIdArray.add(dict.userId) as? String
                        }
                        self.myTempArray = self.favArray
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
    
    
   
    
}
