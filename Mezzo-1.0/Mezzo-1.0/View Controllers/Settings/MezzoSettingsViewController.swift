//
//  MezzoSettingsViewController.swift
//  Mezzo-1.0
//
//  Created by Heejung Chung on 7/30/15.
//  Copyright (c) 2015 MezzoAwesomeness. All rights reserved.
//

import UIKit

class MezzoSettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToSettings(segue: UIStoryboardSegue) {
        if let id = segue.identifier {
            switch id {
            default:
                return
            }
        }
    }
    
    @IBAction func unwindFromMyInfo(sender: UIStoryboardSegue) {
        switch sender.identifier! {
        case "Save my info":
            println("saving my info")
        default:
            break
        }
    }
    

}
