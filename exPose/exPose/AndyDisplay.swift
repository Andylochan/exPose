//
//  AndyDisplay.swift
//  exPose
//
//  Created by Andy Lochan on 5/4/19.
//  Copyright © 2019 Andy Lochan. All rights reserved.
//

import UIKit

class AndyDisplay: UIViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!

    var imageArray = MyVariables.logoImages;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for i in 0..<imageArray.count{
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            imageView.contentMode = .scaleAspectFit
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.mainScrollView.frame.width, height: self.mainScrollView.frame.height)
            
            mainScrollView.contentSize.width = mainScrollView.frame.width * CGFloat(i + 1)
            mainScrollView.addSubview(imageView)
        }
        
        let view70 = MyVariables.AndyImg;
        TestView.image = view70;
    }
    
    @IBOutlet weak var TestView: UIImageView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
