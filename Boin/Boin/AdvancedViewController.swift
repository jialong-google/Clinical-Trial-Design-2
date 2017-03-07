//
//  AdvancedViewController.swift
//  Boin
//
//  Created by Jialong on 3/6/17.
//  Copyright © 2017 Jialong Li & Ziqiao Wang. All rights reserved.
//

import Foundation
import UIKit

class AdvancedViewController: UIViewController{
    
    @IBOutlet weak var Extrasafe: UISwitch!
    @IBOutlet weak var EarlyStop: UITextField!
    @IBOutlet weak var fi1: UITextField!
    @IBOutlet weak var fi2: UITextField!
    @IBOutlet weak var Offset: UITextField!
    @IBOutlet weak var Cutoff: UITextField!
    
    static var extrasafe_value : Bool = false
    static var earlystop_value : Double? = nil
    static var fi1_value : Double? = nil
    static var fi2_value : Double? = nil
    static var offset_value : Double? = nil
    static var cutoff_value : Double? = nil
    //override func viewDidLoad() {
    //    super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Extrasafe.isOn = AdvancedViewController.extrasafe_value
        //EarlyStop.text = String(AdvancedViewController.earlystop_value ?? 0)
        //fi1.text = String(fi1.value ?? 0)
        //fi2.text = String(fi2.value ?? 0)
        //Offset.text = String(AdvancedViewController.offset_value ?? 0)
        //Cutoff.text = String(AdvancedViewController.cutoff_value ?? 0)
        
    //}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let  DestViewController : getboundaryViewController = segue.destination as? getboundaryViewController else
        {
            return
        }
        let extrasafe_value = Extrasafe.isOn
        let earlystop_value = Int(EarlyStop.text!)
        let fi1_value = Double(fi1.text!)
        let fi2_value = Double(fi2.text!)
        let offset_value = Double(Offset.text!)
        let cutoff_value = Double(Cutoff.text!)
        
       /* DestViewController.resultText = boundaryResult.firstHint!
        DestViewController.resultText2 = boundaryResult.secondHint!
        DestViewController.firstMatrixContent = boundaryResult.digested
        DestViewController.secondMatrixContent = boundaryResult.complete
        DestViewController.thirdMatrixContent = boundaryResult.twoLines
         */
        DestViewController.extrasafe_value = extrasafe_value
        DestViewController.earlystop_value = earlystop_value
        DestViewController.fi1_value = fi1_value
        DestViewController.fi2_value = fi2_value
        DestViewController.offset_value = offset_value
        DestViewController.cutoff_value = cutoff_value
    }

}
