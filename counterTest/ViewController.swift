//
//  ViewController.swift
//  counterTest
//
//  Created by 🐨 on 30/03/2021.
//  Copyright © 2021 rHockWorks. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    
    @IBOutlet weak var countingUILabel: CountingUILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        countingUILabel.count(fromValue: 0, to: 9999, withDuration: 5, andAnimationType: .easeOut, andCountingType: .integer)
        
        //SPRITE KIT LABEL NODE WITH CLASS
    }

}

