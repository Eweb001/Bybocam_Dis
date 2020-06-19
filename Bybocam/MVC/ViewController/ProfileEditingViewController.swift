//
//  ProfileEditingViewController.swift
//  Bybocam
//
//  Created by APPLE on 19/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit
import Photos
import Alamofire
import SDWebImage

import SVProgressHUD

class ProfileEditingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    var apiResponse:AddVideoModel?
    
    @IBOutlet weak var sendBtnOutlet: UIButton!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var dobTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    
    var ModelApiResponse:ViewUserProfile?
    
    // Image Picker Delegate
    
    var failureApiArray = NSArray()
    var dataDict = NSDictionary()
    var imagePicker = UIImagePickerController()
    var choosenImage:UIImage!
    
    // View Profile Array
    var ViewProfileDataDict = NSDictionary()
    //   Date of birth view
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
    override func viewWillAppear(_ animated: Bool)
    {
        /*
        // ViewProfileApi()
        if let img = DEFAULT.value(forKey: "PROFILE_IMG") as? String
        {
            let profile_img = URL(string: img)
            self.userImg.sd_setImage(with: profile_img, placeholderImage: UIImage(named: "loding"), options: .refreshCached, context: nil)
            self.userImg.layer.cornerRadius =   self.userImg.frame.height/2
        }
        if let name = DEFAULT.value(forKey: "Name") as? String
        {
            self.usernameTF.text = name
        }
        if let email = DEFAULT.value(forKey: "Email") as? String
        {
            self.emailTf.text = email
        }
        if let phone = DEFAULT.value(forKey: "PHONE") as? String
        {
            self.phoneTF.text = phone
        }
        if let dob = DEFAULT.value(forKey: "DOB") as? String
        {
            self.dobTf.text = dob
        }
        */
    }
    func showDatePicker()
    {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        //  datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(ProfileEditingViewController.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(ProfileEditingViewController
            .cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        dobTf.inputAccessoryView = toolbar
        dobTf.inputView = datePicker
    }
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        dobTf.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
    }
    @IBAction func GoBackAct(_ sender: UIBarButtonItem)
    {
      self.navigationController?.popViewController(animated: true)
    }
    @IBAction func changeImageAct(_ sender: UIButton)
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
    @IBAction func SubmitAct(_ sender: UIButton)
    {
       self.Validations()
    }
    func Validations()
    {
        if usernameTF.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Name.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if dobTf.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type Date Of Birth.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if phoneTF.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Phone number.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if emailTf.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please type your Email.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else if emailTf.text!.isValidateEmail() == false
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
                 "firstName" : usernameTF.text!,
                 "lastName" : usernameTF.text!,
                 "phone" : phoneTF.text!,
                 "userName" : usernameTF.text!,
                 "dateOfBirth" : dobTf.text!] as! [String : String]
     
     print(para)
     SVProgressHUD.show()
     SVProgressHUD.setBorderColor(UIColor.white)
     SVProgressHUD.setForegroundColor(UIColor.white)
     SVProgressHUD.setBackgroundColor(UIColor.black)
     
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        var alamoManager = Alamofire.SessionManager(configuration: configuration)
        
        
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
                         
                        
                            
                            self.phoneTF.text = self.ModelApiResponse?.data?[0].phone
                            DEFAULT.set(self.phoneTF.text!, forKey: "PHONE")
                            
                            
                            self.dobTf.text = self.ModelApiResponse?.data?[0].dateOfBirth
                            DEFAULT.set(self.dobTf.text!, forKey: "DOB")
                            
                            
                            self.emailTf.text = self.ModelApiResponse?.data?[0].email
                            DEFAULT.set(self.emailTf.text!, forKey: "Email")
                            
                            
                            self.usernameTF.text = self.ModelApiResponse?.data?[0].userName
                            DEFAULT.set(self.usernameTF.text!, forKey: "userName")
                            
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
    
    
}
