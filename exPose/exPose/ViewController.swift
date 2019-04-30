//
//  ViewController.swift
//  exPose
//
//  Created by Andy Lochan on 2/21/19.
//  Copyright © 2019 Andy Lochan. All rights reserved.
//


import UIKit


struct myImportScrVars{
    static var flag = 0;
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func importBtnIncFlag(_ sender: UIButton) {
        myImportScrVars.flag = myImportScrVars.flag + 1;
    }
    

}

