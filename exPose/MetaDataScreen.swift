//
//  MetaDataScreen.swift
//  exPose
//
//  Created by Andy Lochan on 4/24/19.
//  Copyright © 2019 Andy Lochan. All rights reserved.
//

import UIKit

class MetaDataScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let view1 = MyVariables.ImgTest1;
        ScreenView.image = view1;
        
        let str1 = String(MyVariables.FstopTest1); //Fstop
        lblFstop.text! = str1;
        
        let str2 = String(MyVariables.ISOTest1); //ISO
        lblIso.text! = str2;
        
        let str3 = String(MyVariables.ShutterTest1); //Shutter
        lblShutter.text! = str3;
        
        let mod4 = String(MyVariables.ModelTest1);
        lblCamera.text! = mod4;
        
        
    }
    
    @IBOutlet weak var ScreenView: UIImageView!
    
    
    @IBOutlet weak var lblFstop: UILabel!
    @IBOutlet weak var lblIso: UILabel!
    @IBOutlet weak var lblShutter: UILabel!
    @IBOutlet weak var lblCamera: UILabel!
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
