//
//  MtdResultController.swift
//  Boin
//
//  Created by Jialong on 2/24/17.
//  Copyright © 2017 Jialong Li & Ziqiao Wang. All rights reserved.
//

import Foundation
import UIKit
class MtdResultController: UIViewController {

    @IBOutlet var result: UILabel!
    var resultText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        result.text = resultText
    }
    
}
