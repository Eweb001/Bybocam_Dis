//
//  NewSettingViewController.swift
//  Bybocam
//
//  Created by APPLE on 18/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage

class NewSettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    @IBOutlet weak var settingTable: UITableView!
    
    var ModelApiResponse:ViewUserProfile?
    
    var LogoutApiResponse:SignUpModel?
    
    var nameListArray = ["Notification","Privacy","Help","Report a Problem","Delete Account","Clear Search History","Clear Conversation","Clear Data","Term & Use","Share the App","Notification Setting","Liked Post","Blocked User","Log Out"]
    
    var ImageListArray = ["notification","privacy","help-icon","Report a problem","delete-user","delete_forever","delete_forever","Clear_data","term-& use","Share-the-app","notification","My-favourites","User_Name","log-out"]
    
    
    // View Profile Array
    
    var ViewProfileDataDict = NSDictionary()
    
    // Image Picker Delegate
    
    var failureApiArray = NSArray()
    var dataDict = NSDictionary()
    var imagePicker = UIImagePickerController()
    var choosenImage:UIImage!
    var PickedImage = "no"
    var newImage:UIImage!
    
    var videourl = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
       print(self.flag(from: "????????"))
        
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
             self.ViewProfileApi()
        }
        
        
         settingTable.register(UINib(nibName: "NotificationsettingCell", bundle: nil), forCellReuseIdentifier: "NotificationsettingCell")
        
        settingTable.register(UINib(nibName: "SettingHeaderCell", bundle: nil), forCellReuseIdentifier: "SettingHeaderCell")
        settingTable.register(UINib(nibName: "SettingRowTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingRowTableViewCell")
    }
    @IBAction func GoBack(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingHeaderCell") as! SettingHeaderCell
        
//        var mail = ""
//        if let email = DEFAULT.value(forKey: "") as? String
//        {
//           mail = email
//        }
        
        cell.userEmail.text = self.ModelApiResponse?.data?[0].email
        cell.userName.text = self.ModelApiResponse?.data?[0].userName
        cell.userDob.text = self.ModelApiResponse?.data?[0].dateOfBirth
        
        let phoen = (self.ModelApiResponse?.data?[0].countryCode ?? "") + " "  + (self.ModelApiResponse?.data?[0].phone ?? "")
        cell.userContact.text = phoen
        
        if let  img = self.ModelApiResponse?.data?[0].userImage
        {
            if img != nil
            {
            var image_value = Image_Base_URL + img
            print(image_value)
            DEFAULT.set(image_value, forKey: "PROFILE_IMG")
            let profile_img = URL(string: image_value)
            cell.userImg.sd_setImage(with: profile_img, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
            cell.userImg.layer.cornerRadius =   cell.userImg.frame.height/2
            }
            else
            {
            cell.userImg.image = UIImage(named: "defaultImage")
            }
        }
//                if PickedImage == "yes"
//                {
//                  cell.userImg.clipsToBounds = true
//                  cell.userImg.image = choosenImage
//                }
//                else
//                {
//                    cell.userImg.image = UIImage(named: "img-2")
//                }
        
        cell.editImgBtn.tag = 0
        cell.editImgBtn.addTarget(self, action: #selector(listBtnAction), for: .touchUpInside)
        
        return cell
        
    }
    @objc func listBtnAction(_ sender:UIButton)
    {
        
        let edit = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        self.navigationController?.pushViewController(edit, animated: true)
        
        /*
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallary()
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
        */
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
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.delegate = self
        imagePicker.isEditing = true
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        choosenImage =  (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
                PickedImage = "yes"
                newImage = choosenImage
               //  uiimage.layer.cornerRadius = uiimage.frame.size.height/2
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 165
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return nameListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.row == 10
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsettingCell") as! NotificationsettingCell
           // cell.imgIcon.image = UIImage(named: ImageListArray[indexPath.row])
            cell.nameLbl.text = nameListArray[indexPath.row]
            return cell
        }
        else
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingRowTableViewCell") as! SettingRowTableViewCell
            cell.imgIcon.image = UIImage(named: ImageListArray[indexPath.row])
            cell.nameLbl.text = nameListArray[indexPath.row]
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("You tapped cell number \(indexPath.section).")
        print("Cell cliked value is \(indexPath.row)")
        
        if(indexPath.row == 0)
        {
            let new = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
            self.navigationController?.pushViewController(new, animated: true)
        }
        else if (indexPath.row == 1)
        {
            let privacy = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyViewController") as! PrivacyViewController
            self.navigationController?.pushViewController(privacy, animated: true)
        }
        else if (indexPath.row == 2)
        {
            let alert = UIAlertController(title: "Alert", message: "No data avialable", preferredStyle: UIAlertController.Style.alert)
            //            alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action: UIAlertAction!) in
            //
            //
            //            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            present(alert, animated: true, completion: nil)
        }
        else if (indexPath.row == 3)
        {
            let new = self.storyboard?.instantiateViewController(withIdentifier: "reportAproblem") as! reportAproblem
            self.navigationController?.pushViewController(new, animated: true)
        }
        else if (indexPath.row == 4)
        {
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Delete your account?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
                
                if !NetworkEngine.networkEngineObj.isInternetAvailable()
                {
                    
                    NetworkEngine.showInterNetAlert(vc: self)
                }
                else
                {
                     self.deleteAccountApi()
                }
               
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            present(alert, animated: true, completion: nil)
        }
        else if (indexPath.row == 5)
        {
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Clear your search history?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { (action: UIAlertAction!) in
                
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            present(alert, animated: true, completion: nil)
        }
        else if (indexPath.row == 6)
        {
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Clear your Conversation?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { (action: UIAlertAction!) in
                
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            present(alert, animated: true, completion: nil)
        }
        else if (indexPath.row == 7)
        {
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Clear your data?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { (action: UIAlertAction!) in
                
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            present(alert, animated: true, completion: nil)
        }
        else if (indexPath.row == 8)
        {
            let term = self.storyboard?.instantiateViewController(withIdentifier: "TermAndUseView") as! TermAndUseView
            self.navigationController?.pushViewController(term, animated: true)
        }
        else if (indexPath.row == 9)
        {
            let ActivityController = UIActivityViewController(activityItems: ["www.google.com"], applicationActivities: nil)
            ActivityController.popoverPresentationController?.sourceView = self.view
            self.present(ActivityController, animated: true, completion: nil)
            
        }
        else if (indexPath.row == 11)
        {
            let term = self.storyboard?.instantiateViewController(withIdentifier: "ViewLikeVideoVC") as! ViewLikeVideoVC
            self.navigationController?.pushViewController(term, animated: true)
            
        }
        else if (indexPath.row == 12)
        {
            let term = self.storyboard?.instantiateViewController(withIdentifier: "BlokedViewController") as! BlokedViewController
            self.navigationController?.pushViewController(term, animated: true)
            
        }
        else if (indexPath.row == 13)
        {
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action: UIAlertAction!) in
                if !NetworkEngine.networkEngineObj.isInternetAvailable()
                {
                    
                    NetworkEngine.showInterNetAlert(vc: self)
                }
                else
                {
                   self.LogoutApi()
                }
               
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            present(alert, animated: true, completion: nil)
        }
        
    }
    // Logout Api here...
    
    func LogoutApi()
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
            let para = ["userId" : USERID]   as! [String : String]
            print(para)
        
        
        ApiHandler.PostModelApiPostMethod(url: LOGOUT_URL, parameters: para, Header: ["":""]) { (responsedata, error) in
            
            do
            {
                let decoder = JSONDecoder()
                
                if  responsedata != nil
                    
                {
                    self.LogoutApiResponse = try decoder.decode(SignUpModel.self, from: responsedata!)
                    
                    if self.LogoutApiResponse?.status == "success"
                    {
                        print("Success")
                        SVProgressHUD.dismiss()
                        
                        DEFAULT.removeObject(forKey: "Email")
                        DEFAULT.removeObject(forKey: "USER_ID")
                        
                        self.view.makeToast("You have logout successfully.!")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//                            let v = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
//                            self.navigationController?.pushViewController(v!, animated: true)
                            APPDEL.loginPage()
                        })
                        
                     
                        
                    }
                    else
                    {
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Alert", message: self.LogoutApiResponse?.message, preferredStyle: .alert)
                        let submitAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in})
                        alert.addAction(submitAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
            catch let error
            {
                print(error)
            }
            
        }

    }
    // Delete Account Api here...
    
    func  deleteAccountApi()
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
        let para = ["userId" : USERID]   as! [String : String]
        print(para)
        
        
        ApiHandler.PostModelApiPostMethod(url: DELETE_ACCOUNT_URL, parameters: para, Header: ["":""]) { (responsedata, error) in
            
            do
            {
                let decoder = JSONDecoder()
                
                if  responsedata != nil
                    
                {
                    self.LogoutApiResponse = try decoder.decode(SignUpModel.self, from: responsedata!)
                    
                    if self.LogoutApiResponse?.status == "success"
                    {
                        print("Success")
                        SVProgressHUD.dismiss()
                        
                        DEFAULT.removeObject(forKey: "Email")
                        DEFAULT.removeObject(forKey: "USER_ID")
                        
                        self.view.makeToast("Your account is deleted")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            let v = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                            self.navigationController?.pushViewController(v!, animated: true)
                        })
                        
                    }
                    else
                    {
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Alert", message: self.LogoutApiResponse?.message, preferredStyle: .alert)
                        let submitAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in})
                        alert.addAction(submitAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
            catch let error
            {
                print(error)
            }
            
        }
        
    }
    
    // VIEW PROFILE API
    
    func ViewProfileApi()
    {
        
        SVProgressHUD.show()
        SVProgressHUD.setBorderColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(UIColor.black)
        
//        var USERID = "4"
//        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
//        {
//            USERID = NewUSERid
//        }
//        let para = ["userId" : USERID]   as! [String : String]
//        print(para)
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        let para = ["userId" : USERID,
                    "loginUserId" : USERID]   as! [String : String]
        print(para)
        
        print(para)
        
        ApiHandler.PostModelApiPostMethod(url: VIEW_USER_PROFILE_URL, parameters: para, Header: ["":""]) { (responsedata, error) in
            
            do
            {
                let decoder = JSONDecoder()
                
                if  responsedata != nil
                    
                {
                    self.ModelApiResponse = try decoder.decode(ViewUserProfile.self, from: responsedata!)
                    
                    if self.ModelApiResponse?.status == "success"
                    {
                    
                        self.settingTable.reloadData()
                       
                    }
                    else
                    {
                         self.settingTable.reloadData()
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Alert", message: self.ModelApiResponse?.message, preferredStyle: .alert)
                        let submitAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in})
                        alert.addAction(submitAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
            catch let error
            {
                print(error)
            }
            
        }
    
        
    }
    func flag(from country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
}
    

