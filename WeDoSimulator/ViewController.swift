//
//  ViewController.swift
//  WeDoSimulator
//
//  Created by Shinichiro Oba on 2017/07/27.
//  Copyright © 2017 bricklife.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let simulator = WeDoSimulator()
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPushed(_ sender: Any) {
        if button.isSelected {
            simulator.stopAdvertising()
            button.isSelected = false
        } else {
            simulator.startAdvertising()
            button.isSelected = true
        }
    }
}

