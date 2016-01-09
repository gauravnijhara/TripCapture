//
//  CameraViewController.swift
//  Tripcapture
//
//  Created by Gaurav Nijhara on 12/26/15.
//  Copyright © 2015 Gaurav Nijhara. All rights reserved.
//

import UIKit
import Photos

class CameraViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var picker:UIImagePickerController = UIImagePickerController();
    var clickingPic:Bool = true;
    var capturedDict:[String : AnyObject]?;
    
    @IBOutlet weak var topBarTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var locationLabel: NSLayoutConstraint!
    
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var topbarView: UIView!
    
    override func viewDidLoad() {
        
        self.tripNameLabel.text = DataManager.sharedInstance.currentTrip!.tripName;
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action:"handleTap:");
        self.view.addGestureRecognizer(tapGesture);
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        if self.clickingPic == true
        {
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceType.Camera;
            self.presentViewController(picker, animated: false, completion: nil);
        }
    }

    
    func  imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image:UIImage? = (info[UIImagePickerControllerOriginalImage] as! UIImage);
        self.capturedDict = info;
        self.capturedImage.image = image;
        self.clickingPic = false;
        
//        let library = ALAssetsLibrary()
//        let url: NSURL = info[UIImagePickerControllerReferenceURL] as! NSURL
//        library.assetForURL(url, resultBlock: {
//            (asset: ALAsset!) in
//            
//            if asset.valueForProperty(ALAssetPropertyLocation) != nil {
//                let longitude = (asset.valueForProperty(ALAssetPropertyLocation) as! CLLocation!).coordinate.longitude
//                let latitude = (asset.valueForProperty(ALAssetPropertyLocation) as! CLLocation!).coordinate.latitude
//            }
//            }, failureBlock: {
//                (error: NSError!) in
//        })
        
        picker.dismissViewControllerAnimated(true , completion: nil);

        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        picker.dismissViewControllerAnimated(true , completion: nil);
        
    }
    
    @IBAction func acceptPressed(sender: AnyObject) {
        
        // Save image
        UIImageWriteToSavedPhotosAlbum(self.capturedImage.image!, self, nil, nil);
        
        let size = CGSizeApplyAffineTransform(self.capturedImage.image!.size, CGAffineTransformMakeScale(0.1, 0.1))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        self.capturedImage.image!.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        if let location = LocationManager.sharedInstance.location
        {
            DataManager.sharedInstance.addImage(scaledImage, forLocation:location.description , withCoordinates: location.coordinate);
            self.reLaunchCamera();
        }
        else
        {
            //launch location enter page6
        }
    }
    
    @IBAction func declinePressed(sender: AnyObject) {
        
        
//        if !(PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Authorized)
//        {
//           PHPhotoLibrary.requestAuthorization({ (status) -> Void in
//            
//            switch (status) {
//            case PHAuthorizationStatus.Authorized:
//                break;
//            case PHAuthorizationStatus.Restricted:
//                break;
//            case PHAuthorizationStatus.Denied:
//                break;
//            default:
//                break;
//            }
//            
//           })
//            
//        }else {
//        }
        
        self.reLaunchCamera();
        
    }
    
    func deletePic() -> Void
    {
//        let imageUrl = self.capturedDict![UIImagePickerControllerReferenceURL] as! NSURL
//        let imageUrls = [imageUrl]
//        //Delete asset
//
//        PHPhotoLibrary.sharedPhotoLibrary().performChanges( {
//            
//            let imageAssetToDelete = PHAsset.fetchAssetsWithALAssetURLs(imageUrls, options: nil)
//            PHAssetChangeRequest.deleteAssets(imageAssetToDelete)
//            },
//            completionHandler: { success, error in
//                
//                self.performSelector(Selector("reLaunchCamera"), withObject: nil, afterDelay: 1);
//                
//               // self.reLaunchCamera();
//        })
        
// 
        self.reLaunchCamera();
    }
    
    func reLaunchCamera() -> Void
    {
        self.clickingPic = true;
        
        picker = UIImagePickerController();
        picker.delegate = self;
        picker.modalPresentationStyle = UIModalPresentationStyle.CurrentContext;
        picker.sourceType = UIImagePickerControllerSourceType.Camera;
        self.presentViewController(picker, animated: false, completion: nil);
    }
    
    
    func handleTap(gesture:UITapGestureRecognizer) -> Void
    {
        if self.topBarTopLayoutConstraint.constant == 0
        {
            self.topBarTopLayoutConstraint.constant -= 50;
        }
        else
        {
            self.topBarTopLayoutConstraint.constant += 50;
        }
        
        UIView .animateWithDuration(0.5 , animations: { () -> Void in
            
            self.topbarView.layoutIfNeeded();
            
            }) { (completed) -> Void in
                
        }
    }
    
//    - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    
//    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    self.imageView.image = chosenImage;
//    
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//    
//    }
    
}
