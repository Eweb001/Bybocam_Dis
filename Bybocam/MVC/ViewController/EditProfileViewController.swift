//
//  EditProfileViewController.swift
//  Bybocam
//
//  Created by APPLE on 23/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//


import UIKit
import Photos
import Alamofire
import SDWebImage
import AccountKit
import CoreLocation
import SVProgressHUD
import CountryList

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,AKFViewControllerDelegate
{
    var accountkit: AccountKitManager!
    var apiResponse:AddVideoModel?
    var ModelApiResponse:ViewUserProfile?
    var countryList = CountryList()
    
    @IBOutlet weak var sendBtnOutlet: UIButton!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var FirstNameTf: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var PhoneTf: UITextField!
    @IBOutlet weak var LastNameTf: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    
    var failureApiArray = NSArray()
    var dataDict = NSDictionary()
    var imagePicker = UIImagePickerController()
    var choosenImage:UIImage!
    var ViewProfileDataDict = NSDictionary()
    var datePicker = UIDatePicker()
    
    var usrName  = "yes"
    @IBOutlet weak var countryCode: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.showDatePicker()
    
        countryList.delegate = self
        userNameTF.delegate = self
        
       
       
        
        userImg.layer.borderColor = UIColor.black.cgColor
        userImg.layer.borderWidth = 1
        sendBtnOutlet.layer.shadowColor = UIColor.black.cgColor
        sendBtnOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        sendBtnOutlet.layer.masksToBounds = false
        sendBtnOutlet.layer.shadowRadius = 2.0
        sendBtnOutlet.layer.shadowOpacity = 0.5
        
        
        if accountkit == nil
        {
            self.accountkit = AccountKitManager(responseType: .accessToken)
           
            print("self.accountkit \(self.accountkit)")
        }
        
        print("access token = \(accountkit.currentAccessToken)")
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            ViewProfileApi()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        print("EditProfileViewController did ReceiveMemory Warning")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == userNameTF
        {
            print("not valid")
            
            if !NetworkEngine.networkEngineObj.isInternetAvailable()
            {
                
                NetworkEngine.showInterNetAlert(vc: self)
            }
            else
            {
                getUserNameApi()
            }
            
           
        }
    }
    
    func showDatePicker()
    {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        //  datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(EditProfileViewController.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(EditProfileViewController
            .cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        dobTF.inputAccessoryView = toolbar
        dobTF.inputView = datePicker
    }
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        dobTF.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
    }
    @IBAction func SubmitAct(_ sender: UIButton)
    {
        self.Validations()
    }
    @IBAction func ChangePhoto(_ sender: UIButton)
    {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
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
        
        userImg.layer.cornerRadius = userImg.frame.size.height/2
        
        
        if let editing = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            
            choosenImage =  editing
            userImg.image = choosenImage
            
        }
        else
        {
            choosenImage =  (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
            userImg.image = choosenImage
        }
        
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func Validations()
    {
        if userNameTF.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Name.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if FirstNameTf.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your First name.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if LastNameTf.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Second name.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if dobTF.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type Date Of Birth.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if PhoneTf.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Phone number.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if emailTF.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Email.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if emailTF.text!.isValidateEmail() == false
        {
            let alert = UIAlertController(title: "Alert", message: "Please type Valid email address.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if userImg.image == UIImage(named: "img-2")
        {
            let alert = UIAlertController(title: "Alert", message: "Please select your Profile Picture", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if self.usrName  == "no"
        {
            NetworkEngine.commonAlert(message: "Username not available", vc: self)
        }

        else
        {
            if !NetworkEngine.networkEngineObj.isInternetAvailable()
            {
                
                NetworkEngine.showInterNetAlert(vc: self)
            }
            else
            {
                self.EditProfileAPi()
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
        
        var phoneCode = (self.countryCode.titleLabel?.text ?? "")
        
        let para = ["userId" : USERID,
                    "firstName" : FirstNameTf.text!,
                    "lastName" : LastNameTf.text!,
                    "countryCode" : phoneCode,
                    "phone" : self.PhoneTf.text!,
                    "userName" : userNameTF.text!,
                    "dateOfBirth" : dobTF.text!] as! [String : String]
        
        print(para)
        SVProgressHUD.show()
        SVProgressHUD.setBorderColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(UIColor.black)
        
        Alamofire.upload(multipartFormData:
            {
                (multipartFormData) in
                
                if self.userImg.image != nil
                {
                    multipartFormData.append(self.userImg.image!.jpegData(compressionQuality: 0.75)!, withName: "userImage", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }
                
                for (key, value) in para
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
        }, to:EDIT_PROFILE_User)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    
                    if progress.isFinished
                    {
                        SVProgressHUD.dismiss()
                       
                    }
                    else{
                        ApiHandler.LOADERSHOW()
                    }
                })
                upload.responseJSON
                    {
                        response in
                        print(response)
                        
                          self.navigationController?.popViewController(animated: true)
                        if response.data != nil
                        {
                            do
                            {
                                
                                
                                let decoder = JSONDecoder()
                                
                             
                               
                                
                            //    self.apiResponse = try decoder.decode(AddVideoModel.self, from: response.data!)
                                
//                                if self.apiResponse?.code == "201"
//                                {
//
//                                    let alert = UIAlertController(title: "Notification", message: "Successfully Updated", preferredStyle: UIAlertController.Style.alert)
//
//                                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                                         self.navigationController?.popViewController(animated: true)
//                                        print("Handle Cancel Logic here")
//                                    }))
//                                   self.present(alert, animated: true, completion: nil)
//
//                                }
//                                SVProgressHUD.dismiss()
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
    
    // VIEW PROFILE API
    
 //   func ViewProfileApi()
//    {
//
//        SVProgressHUD.show()
//        SVProgressHUD.setBorderColor(UIColor.white)
//        SVProgressHUD.setForegroundColor(UIColor.white)
//        SVProgressHUD.setBackgroundColor(UIColor.black)
//
//        var USERID = "4"
//        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
//        {
//            USERID = NewUSERid
//        }
//        let para = ["userId" : USERID]   as! [String : String]
//        print(para)
//
//        ApiHandler.callApiWithParameters(url: VIEW_PROFILE_URL, withParameters: para as [String : AnyObject],success:
//            {
//                json in
//                print(json)
//
//                if   (json as NSDictionary).value(forKey: "status") as! String == "failure"
//                {
//                    SVProgressHUD.dismiss()
//                    let alert = UIAlertController(title: "Alert", message: (json as NSDictionary).value(forKey: "message") as! String, preferredStyle: .alert)
//                    let submitAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in})
//                    alert.addAction(submitAction)
//                    self.present(alert, animated: true, completion: nil)
//                }
//                else
//                {
//                    print("Success")
//                    SVProgressHUD.dismiss()
//                    print(json)
//
//                    self.ViewProfileDataDict = ((json as NSDictionary).value(forKey: "data") as! NSArray).object(at: 0) as! NSDictionary
//
//                    self.PhoneTf.text = (self.ViewProfileDataDict).value(forKey: "phone") as? String
//                    DEFAULT.set(self.PhoneTf.text!, forKey: "PHONE")
//
//
//                    self.dobTF.text = (self.ViewProfileDataDict).value(forKey: "dateOfBirth") as? String
//                    DEFAULT.set(self.dobTF.text!, forKey: "DOB")
//
//
//                    self.emailTF.text = (self.ViewProfileDataDict).value(forKey: "email") as? String
//                    DEFAULT.set(self.emailTF.text!, forKey: "Email")
//
//
//                    self.userNameTF.text = (self.ViewProfileDataDict).value(forKey: "userName") as? String
//                    DEFAULT.set(self.userNameTF.text!, forKey: "userName")
//
//                    self.FirstNameTf.text = (self.ViewProfileDataDict).value(forKey: "firstName") as? String
//                    DEFAULT.set(self.userNameTF.text!, forKey: "firstName")
//
//                    self.LastNameTf.text = (self.ViewProfileDataDict).value(forKey: "lastName") as? String
//                    DEFAULT.set(self.userNameTF.text!, forKey: "lastName")
//
//                    if let image = (self.ViewProfileDataDict).value(forKey: "userImage") as? String
//                    {
//                        if image != nil
//                        {
//                            let image_value = Image_Base_URL + image
//                            print(image_value)
//                            DEFAULT.set(image_value, forKey: "PROFILE_IMG")
//                            let profile_img = URL(string: image_value)
//                            self.userImg.sd_setImage(with: profile_img, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
//                            self.userImg.layer.cornerRadius =   self.userImg.frame.height/2
//                        }
//                        else
//                        {
//                            self.userImg.image = UIImage(named: "img-2")
//                        }
//                    }
//                }
//        },failure:
//            {
//                string in
//                SVProgressHUD.dismiss()
//
//                print(string)
//        },method: .POST, img: nil, imageParamater: "", headers: [ : ])
//
//    }
    
    
    
    
    
    
    func ViewProfileApi()
    {
        
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        let para = ["userId" : USERID,
                    "loginUserId" : USERID]   as! [String : String]
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
                        if self.ModelApiResponse?.data?.count ?? 0>0
                        {
                            self.emailTF.text = self.ModelApiResponse?.data?[0].email
                            
                            self.userNameTF.text = self.ModelApiResponse?.data?[0].userName
                            
                            self.PhoneTf.text = self.ModelApiResponse?.data?[0].phone
                            
                            self.FirstNameTf.text = self.ModelApiResponse?.data?[0].firstName
                            
                            
                            self.LastNameTf.text = self.ModelApiResponse?.data?[0].lastName
                            
                            self.dobTF.text = self.ModelApiResponse?.data?[0].dateOfBirth
                            
                           
                            if let code = self.ModelApiResponse?.data?[0].countryCode
                            {
                                
                                if code == ""
                                {
                                    self.countryCode.setTitle("🇮🇳 +91", for: .normal)
                                }
                                else
                                {
                                    
                              self.countryCode.setTitle(code, for: .normal)
                                }
                            }
                            else
                            {
                               self.countryCode.setTitle("🇮🇳 +91", for: .normal)
                            }
                            
                            
                            
                            
                            if let newImgg = self.ModelApiResponse?.data?[0].userImage
                            {
                                let image_value = Image_Base_URL + newImgg
                                print(image_value)
                                let profile_img = URL(string: image_value)
                                 self.userImg.sd_setImage(with: profile_img, completed: nil)
                              //  self.userImg.sd_setImage(with: profile_img, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
                            }
                           
                        }
                     
                        
                    }
                    else
                    {
                    
                    }
                }
                
            }
            catch let error
            {
                print(error)
            }
            
        }
    }
    
    func getUserNameApi()
    {
        
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        let para = ["userId" : USERID,
                    "userName" : self.userNameTF.text!]   as! [String : String]
        print(para)
        
        ApiHandler.PostModelApiPostMethod2(url: GET_ALL_USERNAME, parameters: para, Header: ["":""]) { (responsedata, error) in
            
            do
            {
                let decoder = JSONDecoder()
                
                if  responsedata != nil
                {
                    self.ModelApiResponse = try decoder.decode(ViewUserProfile.self, from: responsedata!)
                    
                    if self.ModelApiResponse?.status == "success"
                    {
                        self.usrName  = "yes"
                    }
                    else
                    {
                        self.usrName  = "no"
                        NetworkEngine.commonAlert(message: self.ModelApiResponse?.message ?? "", vc: self)
                    }
                }
                
            }
            catch let error
            {
                print(error)
            }
            
        }
    }
    
    
    @IBAction func GoBack(_ sender: UIBarButtonItem)
    {
        DEFAULT.set("YES", forKey: "REFRESHPROFILEAPI")
        DEFAULT.synchronize()
        self.navigationController?.popViewController(animated: true)
    }
    
    func prepareMobileNumber_VC(_ loginViewController: AKFViewController)
    {
        loginViewController.delegate = self
       // loginViewController.setAdvancedUIManager(nil)

    }
    @IBAction func poneNumberAct(_ sender: UIButton)
    {
//        let inputstate = UUID().uuidString
//        let viewController = self.accountkit.viewControllerForPhoneLogin(with: nil, state: inputstate) as AKFViewController
//        viewController.isSendToFacebookEnabled = true
//        self.prepareMobileNumber_VC(viewController)
//        self.present(viewController as! UIViewController, animated: true, completion: nil)
//
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.red
        
        let navController = UINavigationController(rootViewController: countryList)
        _ = [NSAttributedString.Key.foregroundColor:UIColor.red]
        navController.navigationController?.navigationBar.tintColor=UIColor.black
        
        
        self.present(navController, animated: true, completion: nil)
    }
    
}
extension EditProfileViewController:CountryListDelegate {
    
    func selectedCountry(country: Country) {
        print(country.name)
        print(country.flag)
        
        print(country.countryCode)
        print(country.phoneExtension)
        let name = country.countryCode ?? ""
        let flag = country.flag ?? ""
        let code =  "+" + country.phoneExtension
      //  self.phoneNumber=code
        
        var title = flag+" "+code
        self.countryCode.setTitle(title, for: .normal)
    }
}




/*
import UIKit
import Photos
import Alamofire
import SDWebImage
import SwiftyJSON
import SVProgressHUD

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var apiResponse:AddVideoModel?
    
    var ModelApiResponse:ViewUserProfile?
    
    @IBOutlet weak var sendBtnOutlet: UIButton!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var FirstNameTf: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var PhoneTf: UITextField!
    @IBOutlet weak var LastNameTf: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    
    var failureApiArray = NSArray()
    var dataDict = NSDictionary()
    var imagePicker = UIImagePickerController()
    var choosenImage:UIImage!
    var ViewProfileDataDict = NSDictionary()
    var datePicker = UIDatePicker()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.showDatePicker()
        if !NetworkEngine.networkEngineObj.isInternetAvailable()
        {
            
            NetworkEngine.showInterNetAlert(vc: self)
        }
        else
        {
            ViewProfileApi()
        }
        
        userImg.layer.borderColor = UIColor.black.cgColor
        userImg.layer.borderWidth = 1
        sendBtnOutlet.layer.shadowColor = UIColor.black.cgColor
        sendBtnOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        sendBtnOutlet.layer.masksToBounds = false
        sendBtnOutlet.layer.shadowRadius = 2.0
        sendBtnOutlet.layer.shadowOpacity = 0.5
        
    }
    func showDatePicker()
    {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        //  datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(EditProfileViewController.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(EditProfileViewController
            .cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        dobTF.inputAccessoryView = toolbar
        dobTF.inputView = datePicker
    }
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        dobTF.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
    }
    @IBAction func SubmitAct(_ sender: UIButton)
    {
        self.Validations()
    }
    @IBAction func ChangePhoto(_ sender: UIButton)
    {
        
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
        
        userImg.layer.cornerRadius = userImg.frame.size.height/2
        
        
        if let editing = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            
            choosenImage =  editing
            userImg.image = choosenImage
            
        }
        else
        {
            choosenImage =  (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
            userImg.image = choosenImage
        }
        
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func Validations()
    {
        if userNameTF.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Name.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if FirstNameTf.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your First name.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if LastNameTf.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Second name.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if dobTF.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type Date Of Birth.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if PhoneTf.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Phone number.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if emailTF.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Email.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if emailTF.text!.isValidateEmail() == false
        {
            let alert = UIAlertController(title: "Alert", message: "Please type Valid email address.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if userImg.image == UIImage(named: "img-2")
        {
            let alert = UIAlertController(title: "Alert", message: "Please select your Profile Picture", preferredStyle: UIAlertController.Style.alert)
            
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
                self.EditProfileAPi()
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
        
        let para = ["userId" : USERID,
                    "firstName" : FirstNameTf.text!,
                    "lastName" : LastNameTf.text!,
                    "phone" : PhoneTf.text!,
                    "userName" : userNameTF.text!,
                    "dateOfBirth" : dobTF.text!]
        
        print(para)
        SVProgressHUD.show()
        SVProgressHUD.setBorderColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(UIColor.black)
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        let alamoManager = Alamofire.SessionManager(configuration: configuration)
        
        
        alamoManager.upload(multipartFormData:
            {
                (multipartFormData) in
                
                if self.userImg.image != nil
                {
                    multipartFormData.append(self.userImg.image!.jpegData(compressionQuality: 0.75)!, withName: "userImage", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }
                
                for (key, value) in para
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
        }, to:"http://srv1.a1professionals.net/bybocam/api/user/editProfile")
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
                                
                                self.apiResponse = try decoder.decode(AddVideoModel.self, from: response.data!)
                                
                                if self.apiResponse?.code == "201"
                                {
                                    self.view.makeToast(self.apiResponse?.message)
                                    self.navigationController?.popViewController(animated: true)
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
    
    // VIEW PROFILE API
    
    func ViewProfileApi()
    {
        var USERID = "4"
        if let NewUSERid = DEFAULT.value(forKey: "USER_ID") as? String
        {
            USERID = NewUSERid
        }
        let para = ["userId" : USERID]   as! [String : String]
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
                        
                        if self.ModelApiResponse?.data?.count ?? 0>0
                        {
                            
                            self.PhoneTf.text = self.ModelApiResponse?.data?[0].phone
                            DEFAULT.set(self.PhoneTf.text!, forKey: "PHONE")
                            
                            
                            self.dobTF.text = self.ModelApiResponse?.data?[0].dateOfBirth
                            DEFAULT.set(self.dobTF.text!, forKey: "DOB")
                            
                            
                            self.emailTF.text = self.ModelApiResponse?.data?[0].email
                            DEFAULT.set(self.emailTF.text!, forKey: "Email")
                            
                            
                            self.userNameTF.text = self.ModelApiResponse?.data?[0].userName
                            DEFAULT.set(self.userNameTF.text!, forKey: "userName")
                            
                            self.FirstNameTf.text = self.ModelApiResponse?.data?[0].firstName
                            DEFAULT.set(self.FirstNameTf.text!, forKey: "userName")
                            self.LastNameTf.text = self.ModelApiResponse?.data?[0].lastName
                            DEFAULT.set(self.LastNameTf.text!, forKey: "userName")
                            
                            if let image = self.ModelApiResponse?.data?[0].userImage
                            {
                                if image != nil
                                {
                                    let image_value = Image_Base_URL + image
                                    print(image_value)
                                    DEFAULT.set(image_value, forKey: "PROFILE_IMG")
                                    let profile_img = URL(string: image_value)
                                    self.userImg.sd_setImage(with: profile_img, placeholderImage:nil, options: .refreshCached, context: nil)
                                    self.userImg.layer.cornerRadius =   self.userImg.frame.height/2
                                }
                                else
                                {
                                    self.userImg.image = UIImage(named: "img-2")
                                }
                            }
                        }
                    }
                    else
                    {
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
    @IBAction func GoBack(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
*/
