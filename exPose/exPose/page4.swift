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

//Global Variables
struct MyVariables {
    static var String64 = "";
    static var FstopTest1 = 0.0;
    static var ISOTest1 = 0;
    static var ShutterTest1 = 0.0;
    static var ModelTest1 = "";
    static var ImgTest1 = UIImage(); //Selected Image
    //static var photoTableGlobal = Table("");
    //Insert into SQL DB one by one
    
    //Add Clarifai variables for comparison
}

class page4: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var database: Connection!; //Stored locally on the users device
    let photoTable = Table("photoTable");
    let id = Expression<Int>("id");
    let photoSTORED = Expression<String?>("photoSTORED");  //Encoded Image Stored as 64bit String
    let fstop = Expression<Double>("fstop");
    let iso = Expression<Int>("iso");
    let shutter = Expression<Double>("shutter");
    let model = Expression<String>("model");
    
    //Clarifai Values: Clarity,Blur,Color value --> Etc --> other fields that should be saved into the table
    //let clarity = Expression<Double>("clarity");
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        do
        {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("photoTable").appendingPathExtension("sqlite3");
            let database = try Connection(fileUrl.path)
            self.database = database;
        }
        catch {print(error);}
        imagePicker.delegate = self;
        
        //Intial Table Deletion upon app start
        if myImportScrVars.flag == 1 {
            //Delete previous tables in document directory from previous instances
            print("Attempting Intial Delete");
            do {
                try self.database.run(photoTable.drop(ifExists: true))
                print("Deleted Previous Table")
            } catch {
                print(error)
            }
        }
        myImportScrVars.flag = myImportScrVars.flag + 1; //Increment to 2, no loop
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    @IBAction func resetDB(_ sender: UIButton) {
        //Delete previous tables in document directory from previous instances
        print("Attempting Delete");
        do {
            try self.database.run(photoTable.drop(ifExists: true))
            print("Deleted Previous Table")
        } catch {
            print(error)
        }
    }
    
    @IBAction func listDB(_ sender: UIButton) {
        print("LIST DB TAPPED")
        
        do {
            let photos = try self.database.prepare(self.photoTable)
            for photo in photos {
                print("id: \(photo[self.id]), fstop: \(photo[self.fstop]), iso: \(photo[self.iso]) , shutter: \(photo[self.shutter]) , model: \(photo[self.model])")
                // photoSTORED: \(String(describing: photo[self.photoSTORED])), //before fstop ^^^ Causes program to hang up due to long string
            }
        } catch {
            print(error)
        }
    }
    
    //SORTING CALLS from SortByTile
    @IBAction func listISO(_ sender: UIButton) {
        print("ORDER by ISO Tapped on SortVC")
        do {
            let photos = try self.database.prepare(self.photoTable.order(self.iso)) //ORDER BY ISO
            for photo in photos {
                print("id: \(photo[self.id]), fstop: \(photo[self.fstop]), iso: \(photo[self.iso]) , shutter: \(photo[self.shutter]) , model: \(photo[self.model])")
            } } catch { print(error) }
    }
    @IBAction func listAperture(_ sender: UIButton) {
        print("ORDER by Aperture Tapped on SortVC")
        do {
            let photos = try self.database.prepare(self.photoTable.order(self.fstop)) //ORDER BY Fstop
            for photo in photos {
                print("id: \(photo[self.id]), fstop: \(photo[self.fstop]), iso: \(photo[self.iso]) , shutter: \(photo[self.shutter]) , model: \(photo[self.model])")
            } } catch { print(error) }
    }
    @IBAction func listShutter(_ sender: UIButton) {
        print("ORDER by Shutter Tapped on SortVC")
        do {
            let photos = try self.database.prepare(self.photoTable.order(self.shutter)) //ORDER BY Shutter
            for photo in photos {
                print("id: \(photo[self.id]), fstop: \(photo[self.fstop]), iso: \(photo[self.iso]) , shutter: \(photo[self.shutter]) , model: \(photo[self.model])")
            } } catch { print(error) }
    }
    
 
    
    @IBAction func loadImageButtonTapped(_ sender: AnyObject) {
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .photoLibrary
//        present(imagePicker, animated: true, completion: nil)

        //Create a table in the database
        let createTable = self.photoTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.photoSTORED)
            table.column(self.fstop)
            table.column(self.iso)
            table.column(self.shutter)
            table.column(self.model)
        }
        do {
            try self.database.run(createTable)
            print("Created Table")
        } catch {
            print("DNCT") //DO NOT CREATE TABLE = already exists
            //print(error) //Swift Error Code
        }
        
        //Image Picking Code
        let image = UIImagePickerController();
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
        {//After it is complete
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imageView.image = image;
            MyVariables.ImgTest1 = image;
            //MyVariables.photoTableGlobal = photoTable; //Make photoTable usable by SortByTile //CAUSES THE PROGRAM TO SLOW DOWN
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
                //print("imageProperties2: ", imageProperties2) //DEBUGGING CODE
                
                
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
                    MyVariables.ModelTest1 = Model;
                    print ("ModelVar:", Model);
                    
                }
                
                //Encode image and insert into table after values are loaded into MyVariables struct
                print("INSERT PHOTO after LoadImageButtonTapped");
                let imageData:NSData = MyVariables.ImgTest1.pngData()! as NSData
                MyVariables.String64 = imageData.base64EncodedString(options: .lineLength64Characters) //ENCODE THE UIPHOTO to store into DATABASE
               //let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters) //ENCODE THE UIPHOTO to store into DATABASE
                
                /* IMAGE DECODING CODE< Using the global String64 value, perhaps call this as a function elsewhere.
                let dataDecoded:NSData = NSData(base64Encoded: strBase64, options: NSData.Base64DecodingOptions(rawValue: 0))!
                let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
                */
                
                //INSERT DATA into the SQL Photo Table
                let loadImageButtonTapped = self.photoTable.insert(self.photoSTORED <- MyVariables.String64, self.fstop <- MyVariables.FstopTest1, self.iso <- MyVariables.ISOTest1, self.shutter <- MyVariables.ShutterTest1, self.model <- MyVariables.ModelTest1);
                do {
                    try self.database.run(loadImageButtonTapped)
                    print("INSERTED PHOTO INTO TABLE")
                } catch {
                    print(error);
                }}})
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewMetadata(_ sender: UIButton) {
        print ("ViewMetaData Clicked from page 4");
    }
    
} //END











/*
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
