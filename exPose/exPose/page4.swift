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
import Clarifai_Apple_SDK

class page4: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    /*func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Clarifai.sharedInstance().start(apiKey:"da75f627006347d0b9edd26fbf73babf")
        
        return true
    } */
    
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
        
       // let alert = UIAlertController(title: "Metadata", message: "F:", FStopVar, preferredStyle: .alert)
        
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
        
        var model: Model!
        var concepts: [Concept] = []
        
        model = Clarifai.sharedInstance().generalModel
        
        concepts.removeAll()
        
        let image = Image(image: self.imageView.image)
        
        let dataAsset = DataAsset.init(image: image)
        let input = Input.init(dataAsset:dataAsset)
        let inputs = [input]
        model.predict(inputs, completionHandler: {(outputs: [Output]?,error: Error?) -> Void in
            // Iterate through outputs to learn about what has been predicted
            for output in outputs! {
                // Do something with your outputs
                // In the sample code below the output concepts are being added to an array to be displayed.
                //concepts.append(contentsOf: output.dataAsset.concepts!)
                
                let concepts = output.dataAsset.concepts
                print(concepts?.count)
                for concept in concepts! {
                    print(concept.name)
                    //subjects.append(concept.name)
                }
                
                print("done")  //Done is printed
            }
            print("done2") //Done is printed
        })
        
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
                
                
               //Read into imageProperties -> {"Exif"}
                let exifDict = imageProperties2["{Exif}"] as! NSDictionary
                if let Fstop = exifDict["FNumber"] as? NSNumber {
                    //print("FStop_TEST: ", Fstop)
                    let FStopVar: Double = Double(truncating: Fstop);
                    print ("FStopVar:", FStopVar);
                }
                if let Iso = exifDict["ISOSpeedRatings"] as? NSArray {
                    //print("ISO_TEST: ", Iso)
                    let IsoVarArray: Array = Iso as! Array<Int>;
                    let IsoVarNum: Int = IsoVarArray.first!;
                    print ("ISOVar:", IsoVarNum);
                }
                if let Shutter = exifDict["ExposureTime"] as? NSNumber {
                    //print("Shutter_TEST: ", Shutter)
                    let ShutterVar: Double = Double(truncating: Shutter);
                    print ("ShutterVar:", ShutterVar);
                }
            }
            
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
