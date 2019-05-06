//
//  CritiqueController.swift
//  exPose
//
//  Created by Andy Lochan on 4/28/19.
//  Copyright © 2019 Andy Lochan. All rights reserved.
//

import UIKit

class CritiqueController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view1 = MyVariables.ImgTest1;
        ScreenView.image = view1;

        let sample = "Sample suggestion"
        critique.text! = sample
        
        if (MyVariables.landscapeHighQuality >= 0.7 ) { //image quality
            let str1 = "This is a high quality photo!";
            critique.text! = str1;
        }
        else {
            let str1 = "This is a low quality photo. It might not make a good print or internet content for your website or social media.";
            critique.text! = str1;
        }
        
        if (MyVariables.focusValue < 0.7) {
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var ScreenView: UIImageView!
    
    @IBOutlet weak var critique: UILabel!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
