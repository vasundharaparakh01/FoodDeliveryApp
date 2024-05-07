//
//  PhotosPickerClass.swift
//  LiquorChacha
//
//  Created by Vishal Mandhyan on 22/06/21.
//

import Foundation
import UIKit
import Photos

class FMImageView: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageViewClouser: (UIImage?, String?)->Void = {_,_  in }
    var picker : UIImagePickerController?=UIImagePickerController()
    var viewController = UIViewController()
    
    
    class var sharedImageHelper: FMImageView {
        struct Static {
            static let imageInstance: FMImageView = FMImageView()
        }
        return Static.imageInstance
    }
    
    
    func getImageFromPicker(sourceViewController: UIViewController, completionBlock: @escaping (UIImage?, String?) -> Void ) -> Void {
        viewController = sourceViewController
        openActionSheet()
        imageViewClouser = completionBlock
    }
    
    
    func openActionSheet() {
        picker?.delegate = self
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: viewController.view.center.x, y: viewController.view.center.y, width: 0, height: 0)
            popoverController.sourceView = viewController.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            picker?.sourceType = UIImagePickerController.SourceType.camera
            picker?.allowsEditing = true
            viewController.present(picker!, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func openGallary()
    {
        picker?.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker?.allowsEditing = true
        viewController.present(picker!, animated: true, completion: nil)
    }
    
    //MARK: UIImage Picker Method
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var filename = ""
        if let imageUrl = info[.imageURL] as? URL {
            filename = imageUrl.lastPathComponent
                }
//        let filename = photo?.value(forKey: "filename") as! String
//        if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
//            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
//            let asset = result.firstObject
//            imageName = asset?.value(forKey: "filename") as! String
            //print(asset?.value(forKey: "filename")!)
            
//        }
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageViewClouser(image, filename)
        }
        viewController.dismiss(animated: true, completion: nil)
    }
}
