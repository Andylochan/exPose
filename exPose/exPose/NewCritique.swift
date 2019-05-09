//
//  NewCritique.swift
//  exPose
//
//  Created by Alice Gamarnik on 5/8/19.
//  Copyright © 2019 Andy Lochan. All rights reserved.
//

import UIKit

class NewCritique: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view1 = MyVariables.ImgTest1;
        ScreenView.image = view1;
        
        let sample = "This is a high quality photo! It has an overall focus value of 0.949. It would make a good print or content for social media."
        
        critique.text!  = sample;

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
