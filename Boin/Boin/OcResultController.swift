//
//  OcResultController.swift
//  Boin
//
//  Created by apple on 24/02/2017.
//  Copyright © 2017 Jialong Li & Ziqiao Wang. All rights reserved.
//

import Foundation
import UIKit
class OcResultController: UIViewController {
    
    
    @IBOutlet weak var result: UITextView!
    var resultText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        result.text = resultText
    }
}
