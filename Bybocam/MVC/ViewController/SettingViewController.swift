//
//  LoginViewController.swift
//  Bybocam
//
//  Created by eWeb on 04/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

//
//
//Class SettingViewController:UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
//{
//
//    @IBOutlet weak var settingTable: UITableView!
//
//    var nameListArray = ["Notification","Privacy","Help","Report a Problem","Delete Account","Clear Search History","Clear Conversation","Clear Data","Term & Use","Share the App","Log Out"]
//    var ImageListArray = ["notification","privacy","help-icon","Report a problem","delete-user","delete_forever","delete_forever","Clear_data","term-& use","Share-the-app","log-out"]
//
//    // Image Picker Delegate
//
//    var failureApiArray = NSArray()
//    var dataDict = NSDictionary()
//    var imagePicker = UIImagePickerController()
//    var choosenImage:UIImage!
//    var PickedImage = "no"
//    var newImage:UIImage!
//
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//        settingTable.register(UINib(nibName: "SettingHeaderCell", bundle: nil), forCellReuseIdentifier: "SettingHeaderCell")
//        settingTable.register(UINib(nibName: "SettingRowTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingRowTableViewCell")
//    }
//    @IBAction func GoBack(_ sender: UIBarButtonItem)
//    {
//        self.navigationController?.popViewController(animated: true)
//    }
//    func numberOfSections(in tableView: UITableView) -> Int
//    {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingHeaderCell") as! SettingHeaderCell
//
////        if PickedImage == "yes"
////        {
////          cell.userImg.clipsToBounds = true
////          cell.userImg.image = choosenImage
////        }
////        else
////        {
////            cell.userImg.image = UIImage(named: "img-2")
////        }
//        cell.editImgBtn.tag = 0
//        cell.editImgBtn.addTarget(self, action: #selector(listBtnAction), for: .touchUpInside)
//
//       return cell
//
//    }
//    @objc func listBtnAction(_ sender:UIButton)
//    {
//                let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
//                let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
//                {
//                    UIAlertAction in
//                    self.openCamera()
//                }
//                let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertAction.Style.default)
//                {
//                    UIAlertAction in
//                    self.openGallary()
//                }
//                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
//                {
//                    UIAlertAction in
//                }
//                // Add the actions
//                imagePicker.delegate = self
//                alert.addAction(cameraAction)
//                alert.addAction(gallaryAction)
//                alert.addAction(cancelAction)
//                self.present(alert, animated: true, completion: nil)
//
//    }
//    func openCamera()
//    {
//        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
//        {
//            imagePicker.sourceType = UIImagePickerController.SourceType.camera
//            imagePicker.delegate = self
//            imagePicker.isEditing = true
//            imagePicker.allowsEditing = true
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//        else
//        {
//            let alertWarning = UIAlertView(title:"Alert!", message: "You don't have camera", delegate:nil, cancelButtonTitle:"Ok")
//            alertWarning.show()
//        }
//    }
//    func openGallary()
//    {
//        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
//        imagePicker.delegate = self
//        imagePicker.isEditing = true
//        imagePicker.allowsEditing = true
//        self.present(imagePicker, animated: true, completion: nil)
//    }
//    //PickerView Delegate Methods
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
//    {
//        choosenImage =  (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
////        PickedImage = "yes"
////        newImage = choosenImage
////         uiimage.layer.cornerRadius = uiimage.frame.size.height/2
//         picker.dismiss(animated: true, completion: nil)
//
//    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
//    {
//        picker.dismiss(animated: true, completion: nil)
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
//    {
//        return 165
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 60
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return nameListArray.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingRowTableViewCell") as! SettingRowTableViewCell
////        cell.imgIcon.image = UIImage(named: ImageListArray[indexPath.row])
//        cell.nameLbl.text = nameListArray[indexPath.row]
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("You tapped cell number \(indexPath.section).")
//        print("Cell cliked value is \(indexPath.row)")
//
//        if(indexPath.row == 0)
//        {
//           var new = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
//            self.navigationController?.pushViewController(new, animated: true)
//        }
//        else if (indexPath.row == 1)
//        {
//            var privacy = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyViewController") as! PrivacyViewController
//            self.navigationController?.pushViewController(privacy, animated: true)
//        }
//        else if (indexPath.row == 2)
//        {
//            let alert = UIAlertController(title: "Alert", message: "No data avialable", preferredStyle: UIAlertController.Style.alert)
////            alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action: UIAlertAction!) in
////
////
////            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//                print("Handle Cancel Logic here")
//            }))
//            present(alert, animated: true, completion: nil)
//        }
//        else if (indexPath.row == 3)
//        {
//            var new = self.storyboard?.instantiateViewController(withIdentifier: "ReoprtProblemViewController") as! ReoprtProblemViewController
//            self.navigationController?.pushViewController(new, animated: true)
//        }
//        else if (indexPath.row == 4)
//        {
//            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Delete your account?", preferredStyle: UIAlertController.Style.alert)
//
//            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
//
//
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//                print("Handle Cancel Logic here")
//            }))
//            present(alert, animated: true, completion: nil)
//        }
//        else if (indexPath.row == 5)
//        {
//            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Clear your search history?", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { (action: UIAlertAction!) in
//
//
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//                print("Handle Cancel Logic here")
//            }))
//            present(alert, animated: true, completion: nil)
//        }
//        else if (indexPath.row == 6)
//        {
//            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Clear your Conversation?", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { (action: UIAlertAction!) in
//
//
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//                print("Handle Cancel Logic here")
//            }))
//            present(alert, animated: true, completion: nil)
//        }
//        else if (indexPath.row == 7)
//        {
//            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Clear your data?", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { (action: UIAlertAction!) in
//
//
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//                print("Handle Cancel Logic here")
//            }))
//            present(alert, animated: true, completion: nil)
//        }
//        else if (indexPath.row == 8)
//        {
//            var term = self.storyboard?.instantiateViewController(withIdentifier: "TermAndUseView") as! TermAndUseView
//            self.navigationController?.pushViewController(term, animated: true)
//        }
//        else if (indexPath.row == 9)
//        {
//            /*
//            let firstActivityItem = "Text you want"
//            let secondActivityItem : NSURL = NSURL(string: "http//:urlyouwant")!
//            // If you want to put an image
//            let image : UIImage = UIImage(named: "MENN")!
//
//            let activityViewController : UIActivityViewController = UIActivityViewController(
//                activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
//
//            // This lines is for the popover you need to show in iPad
//            activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
//
//            // This line remove the arrow of the popover to show in iPad
//            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.allZeros
//            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
//
//            // Anything you want to exclude
//            activityViewController.excludedActivityTypes = [
//                UIActivity.ActivityType.postToWeibo,
//                UIActivity.ActivityType.print,
//                UIActivity.ActivityType.assignToContact,
//                UIActivity.ActivityType.saveToCameraRoll,
//                UIActivity.ActivityType.addToReadingList,
//                UIActivity.ActivityType.postToFlickr,
//                UIActivity.ActivityType.postToVimeo,
//                UIActivity.ActivityType.postToTencentWeibo]
//
//            self.present(activityViewController, animated: true, completion: nil)
//            */
//            let ActivityController = UIActivityViewController(activityItems: ["www.google.com"], applicationActivities: nil)
//            ActivityController.popoverPresentationController?.sourceView = self.view
//            self.present(ActivityController, animated: true, completion: nil)
//
//        }
//        else if (indexPath.row == 10)
//        {
//            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action: UIAlertAction!) in
//
//
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//                print("Handle Cancel Logic here")
//            }))
//            present(alert, animated: true, completion: nil)
//        }
//
//    }
//
//}
//*/
