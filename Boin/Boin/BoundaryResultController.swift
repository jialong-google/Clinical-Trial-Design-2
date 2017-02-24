//
//  BoundaryResultController.swift
//  Boin
//
//  Created by Jialong on 2/23/17.
//  Copyright © 2017 Jialong Li & Ziqiao Wang. All rights reserved.
//

import Foundation
import UIKit
class BoundaryResultController: UIViewController {

    @IBOutlet var result: UITextView!
    var resultText = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        result.text = resultText
        //showResult.text = "hello"
    }
    
}
