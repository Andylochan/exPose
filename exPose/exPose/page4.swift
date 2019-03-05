//
//  page4.swift
//  exPose
//
//  Created by Andy Lochan on 2/22/19.
//  Copyright © 2019 Andy Lochan. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class page4: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func loadImageButtonTapped(_ sender: AnyObject) {
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .photoLibrary
//
//        present(imagePicker, animated: true, completion: nil)
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true)
        {
            //After it is complete
        }
    }
    
    
    @IBAction func viewMetadata(_ sender: UIButton) {
        let alert = UIAlertController(title: "Metadata", message: "ISO: 400; Aperture: f2.0; Shutter Speed: 1/80; ColorModel = RGB; DPIHeight = 72; DPIWidth = 72; Depth = 8; Orientation = 6; PixelHeight = 1936; PixelWidth = 2592", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker.delegate = self
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imageView.image = image
        }
        else
        {
            //Error message
        }
        
        self.dismiss(animated: true, completion: nil)
        
        //Extract Metdadata/EXIF files
        let assetURL = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
        let asset = PHAsset.fetchAssets(withALAssetURLs: [assetURL as URL], options: nil)
        guard let result = asset.firstObject else {
            return
        }
        
        let imageManager = PHImageManager.default()
        imageManager.requestImageData(for: result , options: nil, resultHandler:{
            (data, responseString, imageOriet, info) -> Void in
            let imageData: NSData = data! as NSData
            if let imageSource = CGImageSourceCreateWithData(imageData, nil) {
                let imageProperties2 = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)! as NSDictionary
                print("imageProperties2: ", imageProperties2)
                print("DICT TEST1: ", imageProperties2.object(forKey: "ColorModel"))
                //, NSLog ( [imageProperties2.value(forKeyPath: "{Exif}.ApertureValue")])
                //imageProperties2 is a dictionary of dictionaries
                //try data[keyPath:"Exif.ApertureValue"]
                //, imageProperties2.value(forKey: "TIFF.DateTime"), imageProperties2.object(forKey: "Exif.ApertureValue")
            }
            
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
