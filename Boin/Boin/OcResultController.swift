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
    
    
    @IBOutlet weak var result3: UITextView!
    @IBOutlet weak var result2: UITextView!
    @IBOutlet weak var result: UITextView!
    var result1Text = String()
    var result2Text = String()
    var result3Text = String()
    var selpercent: [Double]? = nil
    var nptsdose: [Double]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        result.text = result1Text + String(describing: selpercent!)
        result2.text = result2Text + String(describing: nptsdose!)
        result3.text = result3Text
        //frame里面是这个外框的大小，这个需要子乔来调节~~
        let barChart = PNBarChart(frame: CGRect(x: 0.0, y: 135.0, width: 320.0, height: 200.0))
        barChart.backgroundColor = UIColor.clear
        barChart.animationType = .Waterfall
        barChart.labelMarginTop = 5.0
        //barChart.xLabels = ["Sep 1", "Sep 2", "Sep 3", "Sep 4", "Sep 5", "Sep 6", "Sep 7"]
        var sel :[CGFloat] = [CGFloat]()
        for i in selpercent!
        {
            sel.append(CGFloat(i))
        }
        barChart.yValues = sel
        //[1.1, 23.3, 12.5, 18.9, 30.1, 12.9, 21.9]
        barChart.strokeChart()
        barChart.center = CGPoint(x:235, y:160)//表格的中心~麻烦子乔调啦
        
        let barChart2 = PNBarChart(frame: CGRect(x: 0.0, y: 135.0, width: 320.0, height: 200.0))
        barChart2.backgroundColor = UIColor.clear
        barChart2.animationType = .Waterfall
        barChart2.labelMarginTop = 5.0
        var npts :[CGFloat] = [CGFloat]()
        for i in nptsdose!
        {
            npts.append(CGFloat(i))
        }
        barChart2.yValues = npts
        //[1.1, 23.3, 12.5, 18.9, 30.1, 12.9, 21.9]
        barChart2.strokeChart()
        barChart2.center = CGPoint(x:235, y:560)//表格的中心，麻烦子乔啦
        
        self.view.addSubview(barChart)
        self.view.addSubview(barChart2)
    }
}
