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
import SQLite

struct MyVariables {                    //Global Variables
    static var FstopTest1 = 0.0;
    static var ISOTest1 = 0;
    static var ShutterTest1 = 0.0;
    static var ModelTest1 = "";
    
    static var ImgTest1 = UIImage(); //Selected Image
    //Insert into SQL DB one by one
    
    //Add Clarifai variables for comparison
    

}

class page4: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var database: Connection!; //Stored locally on the users device
  
    let photoDisk = Table("photoDisk");
    let id = Expression<Int>("id");
    let photoDir = Expression<String?>("photoDir"); //Photo Directory
    let fstop = Expression<Double?>("fstop");
    let iso = Expression<Int?>("iso");
    let shutter = Expression<Double?>("shutter");
    //Clarity,Blur,Color value --> Etc --> other fields that should be saved into the table
 
    override func viewDidLoad() {
        super.viewDidLoad();
        do
        {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("photoDisk").appendingPathExtension("sqlite3");
            let database = try Connection(fileUrl.path)
            self.database = database;
        }
        catch {print(error);}
        imagePicker.delegate = self;
    }
    
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    @IBAction func loadImageButtonTapped(_ sender: AnyObject) {
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .photoLibrary
//
//        present(imagePicker, animated: true, completion: nil)
        let image = UIImagePickerController();
        image.delegate = self
        
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true)
        {
            //After it is complete
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imageView.image = image;
            MyVariables.ImgTest1 = image;
        }
        else
        {
            print("Error in func imagePickerController()"); //Error message
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
                
                
               //Read into imageProperties -> {"Exif"}
                let exifDict = imageProperties2["{Exif}"] as! NSDictionary;
                let tiffDict = imageProperties2["{TIFF}"] as! NSDictionary;
                
                if let Fstop = exifDict["FNumber"] as? NSNumber {
                    //print("FStop_TEST: ", Fstop)
                    let FStopVar: Double = Double(truncating: Fstop);
                    MyVariables.FstopTest1 = FStopVar;
                    print ("FStopVar:", FStopVar);
                }
                if let Iso = exifDict["ISOSpeedRatings"] as? NSArray {
                    //print("ISO_TEST: ", Iso)
                    let IsoVarArray: Array = Iso as! Array<Int>;
                    let IsoVarNum: Int = IsoVarArray.first!;
                    MyVariables.ISOTest1 = IsoVarNum;
                    print ("ISOVar:", IsoVarNum);
                }
                if let Shutter = exifDict["ExposureTime"] as? NSNumber {
                    //print("Shutter_TEST: ", Shutter)
                    let ShutterVar: Double = Double(truncating: Shutter);
                    MyVariables.ShutterTest1 = ShutterVar;
                    print ("ShutterVar:", ShutterVar);
                }
                
                if let Model = tiffDict["Model"] as? NSString {
                    //print("Model_TEST: ", Model)
                    let Model: String = String(Model);
                    //let ModelVarArray: Array = Model as! Array<String>;
                    //let ModelVarString: String = ModelVarArray.first!;
                    MyVariables.ModelTest1 = Model;
                    print ("ModelVar:", Model);
                    
                }
            }
            
        })
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    @IBAction func viewMetadata(_ sender: UIButton) {
        print ("ViewMetaData Clicked from page 4");
    }/*
        let alert = UIAlertController(title: "Metadata", message: "ISO: 400; Aperture: f2.0; Shutter Speed: 1/80; ColorModel = RGB;", preferredStyle: .alert)
        //let alert = UIAlertController(title: "Metadata", message: IsoVar as String, preferredStyle: .alert)
        
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
        
       // let StringTester = MyVariables.ISOTest1;                      //DEBUGGING CODE
       // print("CONSOLE TEST IN VIEWMETADATA:", StringTester)
 
    }*/
    
}

/*
 var FStopVar: Double;
 var IsoVarNum: Int;
 var ShutterVar: Double;
 
 init(FStopVar: Double, IsoVarNum: Int, ShutterVar: Double )
 {
 self.FStopVar = FStopVar;
 self.IsoVarNum = IsoVarNum;
 self.ShutterVar = ShutterVar;
 };
 
 init()
 {
 self.FStopVar = 0.0;
 self.IsoVarNum = 0;
 self.ShutterVar = 0.0;
 };
 
 
 required init?(coder aDecoder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }
 */
