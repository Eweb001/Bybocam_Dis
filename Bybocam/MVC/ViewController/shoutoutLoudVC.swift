//
//  shoutoutLoudVC.swift
//  Bybocam
//
//  Created by Eweb on 13/07/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire
import SVProgressHUD

class shoutoutLoudVC: UIViewController {
    var pickedImageProduct = UIImage()
       var imagePicker = UIImagePickerController()
       var choosenImage:UIImage!
       
       var fromEditImage = ""
       var videoURL : URL?
    var signupData:SignUpModel?
    
    var shareVideoUrl = ""
    
     @IBOutlet weak var shareVideoBtn: UIButton!
    @IBOutlet weak var profileVideo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
self.shareVideoBtn.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func gobackAct(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareVideoAct(_ sender: Any)
    {
      
        print("share")
   
        let videoURL = URL(string:self.shareVideoUrl)
        let activityItems = [videoURL, "Check this out!" ] as [Any]
           let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

           activityController.popoverPresentationController?.sourceView = self.view
           activityController.popoverPresentationController?.sourceRect = self.view.frame

        self.present(activityController, animated: true, completion: nil)
      
    }
    
    @IBAction func chooseVideoAct(_ sender: Any)
    {
           let actionSheet = UIAlertController(title: "Add video !", message: nil, preferredStyle: UIAlertController.Style.alert)
             actionSheet.view.tintColor = UIColor.black
             
             let camera1 =  UIAlertAction(title: "Take Video", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
                 self.openCamera()
             })
             camera1.setValue(0, forKey: "titleTextAlignment")
             
             let camera2 =  UIAlertAction(title: "Choose from Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
                 self.openGallary()
             })
             camera2.setValue(0, forKey: "titleTextAlignment")
             
             let camera3 =  UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
                 
             })
             camera3.setValue(0, forKey: "titleTextAlignment")
             
             // Add the actions
             imagePicker.delegate = self
             imagePicker.isEditing = true
             imagePicker.allowsEditing = true
             
             actionSheet.addAction(camera1)
             actionSheet.addAction(camera2)
             actionSheet.addAction(camera3)
             self.present(actionSheet, animated: true, completion: {() -> Void in
                 
                 actionSheet.view.superview?.isUserInteractionEnabled = true
                 actionSheet.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose)))
             })
             
    }

    
       @objc func alertClose(gesture: UITapGestureRecognizer)
       {
           self.dismiss(animated: true, completion: nil)
       }
       //MARK:- Choose image end ---------------------------------
       
       func openCamera()
       {
           if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
           {
               imagePicker.sourceType = UIImagePickerController.SourceType.camera
              
                   imagePicker.mediaTypes=["public.movie"]
               
               
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
           
           
           let picker = UIImagePickerController()
           picker.delegate = self
           picker.sourceType = .photoLibrary
 
               picker.mediaTypes=["public.movie"]
           
          
           
           present(picker, animated: true, completion: nil)
       }
       
}
extension shoutoutLoudVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
            videoURL = info[UIImagePickerController.InfoKey.mediaURL]as? URL
            print(videoURL!)
            do {
                let asset = AVURLAsset(url: videoURL! as URL , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
            self.profileVideo.image = thumbnail
                editProfileApi()
            } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
            }
       
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func editProfileApi()
      {
          
          
          
          var useriD="1"
          if let id = DEFAULT.value(forKey: "USERID") as? String
          {
              useriD=id
          }
          

          
          Alamofire.upload(multipartFormData: { multipartFormData in
              //Parameter for Upload files
              let timestamp = NSDate().timeIntervalSince1970
              
              
              
              if self.videoURL != nil
              {
                  multipartFormData.append(self.videoURL!, withName: "RandomVideo" , fileName: "\(timestamp).mov" , mimeType: "\(timestamp)/mov")
              }
              
              let imgData = self.profileVideo.image!.jpegData(compressionQuality: 0.2)!
              
              
              multipartFormData.append(imgData, withName: "videoImage" , fileName: "\(timestamp*10).jpg" , mimeType: "\(timestamp*10)/jpg")
              
              
              print("Para in upload = \(self.videoURL)")
              print("\(self.profileVideo.image)")
              
              
          }, usingThreshold:UInt64.init(),
             to: "https://a1professionals.net/bybocam/api/addRandomVideos", //URL Here
              method: .post,//pass header dictionary here
              encodingCompletion: { (result) in
                  
                  switch result {
                  case .success(let upload, _, _):
                      print("the status code is :")
                      SVProgressHUD.dismiss()
                      
                      upload.uploadProgress(closure: { (progress) in
                          print("something")
                          if progress.isFinished
                          {
                              // self.ViewProfileAPI()
                              SVProgressHUD.dismiss()
                          }
                          else{
                              SVProgressHUD.show()
                          }
                      })
                      
                      upload.responseJSON { response in
                          debugPrint("SUCCESS RESPONSE: \(response)")
                          
                          let decoder = JSONDecoder()
                          do
                          {
                              if response.data != nil
                              {
                                  self.signupData = try decoder.decode(SignUpModel.self, from: response.data!)
                                  if self.signupData?.code == "200"
                                      
                                  {
                                      self.view.makeToast(self.signupData?.message)
                                      
                                  }
                                  else
                                  {
                                    self.shareVideoUrl = self.signupData?.message ?? "http://a1professionals.net/bybocam/assets/videos/userVideo16oqx.mp4"
                                    
                                    self.shareVideoBtn.isHidden = false
                                    
                                    let videoURL = URL(string:self.shareVideoUrl)
                                           let activityItems = [videoURL, "Check this out!" ] as [Any]
                                              let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

                                              activityController.popoverPresentationController?.sourceView = self.view
                                              activityController.popoverPresentationController?.sourceRect = self.view.frame

                                           self.present(activityController, animated: true, completion: nil)
                                  }
                                  
                              }
                              
                              
                              
                              
                          }
                          catch let error
                          {
                              self.view.makeToast(error.localizedDescription)
                          }
                      }
                      break
                  case .failure(let encodingError):
                      SVProgressHUD.dismiss()
                      print("the error is  : \(encodingError.localizedDescription)")
                      break
                  }
          })
          
          
          
          
          
          /*
           
           Alamofire.upload(multipartFormData: { MultipartFormData in
           let timestamp = NSDate().timeIntervalSince1970
           
           if self.videoURL != nil
           {
           MultipartFormData.append(self.videoURL!, withName: "profile_video" , fileName: "\(timestamp).mov" , mimeType: "\(timestamp)/mov")
           }
           
           let imgData = self.profileImg.image!.jpegData(compressionQuality: 0.2)!
           
           
           MultipartFormData.append(imgData, withName: "profile_image" , fileName: "\(timestamp*10).jpg" , mimeType: "\(timestamp*10)/jpg")
           
           
           print("Para in upload = \(uploadDict)\(self.videoURL)")
           print("\(self.profileImg.image)")
           
           for(key,value) in uploadDict
           {
           MultipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
           }
           }, to: EDITPROFILEAPI, method: .post)
           .responseJSON { (response) in
           debugPrint("SUCCESS RESPONSE: \(response)")
           
           let decoder = JSONDecoder()
           do
           {
           if response.data != nil
           {
           self.signupData = try decoder.decode(SignupModel.self, from: response.data!)
           if self.signupData?.code == "200"
           
           {
           self.view.makeToast(self.signupData?.message)
           
           }
           else
           {
           if #available(iOS 13.0, *) {
                     SCENEDEL.loadHomeView()
           }
           else
           {
           APPDEL.loadHomeView()
           }
           }
           
           }
           
           
           
           
           }
           catch let error
           {
           self.view.makeToast(error.localizedDescription)
           }
           }
           */
          
          
      }

}
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
