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

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var ScreenView: UIImageView!
    
    @IBOutlet weak var sampleText: UILabel!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
