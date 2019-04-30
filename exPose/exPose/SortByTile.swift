//
//  SortByTile.swift
//  exPose
//
//  Created by Andy Lochan on 3/5/19.
//  Copyright © 2019 Andy Lochan. All rights reserved.
//

import UIKit
import SQLite

class SortByTile: UIViewController {
    
    var database: Connection!; //Stored locally on the users device
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do
        {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("photoTable").appendingPathExtension("sqlite3");
            let database = try Connection(fileUrl.path)
            self.database = database;
        }
        catch {print(error);}

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ISOsort(_ sender: UIButton) {
        print("ORDER by ISO Tapped in SortVC")

    
    
    
    }
    
    
    
    
    /*@IBAction func CheckGlobalTest(_ sender: UIButton) {
        let StringTester = MyVariables.ISOTest1;
        print("CONSOLE TEST IN SORTTILES:", StringTester)
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
