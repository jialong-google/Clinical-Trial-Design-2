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

    @IBOutlet var result2: UITextView!
    @IBOutlet var result: UITextView!
    var resultText = String()
    var resultText2 = String()
    var firstMatrixView   : NALLabelsMatrixView!;
    var secondMatrixView  : NALLabelsMatrixView!;
    var thirdMatrixView   : NALLabelsMatrixView!;
    var firstMatrixContent : [[Int?]] = []
    var secondMatrixContent : [[Int?]] = []
    var thirdMatrixContent : [[ Int?]]? = nil
    func sum(array : [Int]) -> Int
    {
        var res = 0
        for i in array
        {
            res += i
        }
        return res
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        result.text = resultText
        result2.text = resultText2
        var columns1 = [150]
        let len1 = firstMatrixContent[0].count
        for _ in 1...len1
        {
            columns1.append((380 - columns1[0])/len1)
        }
        columns1[columns1.count - 1] += 380 - sum(array: columns1)
        
        self.firstMatrixView = NALLabelsMatrixView(frame: CGRect.init(x: 18, y: 145, width: 380, height: 50), columns: columns1)
        
        self.view.addSubview(self.firstMatrixView)
        
        firstMatrixView.addRecord(record: ["Number of patients treated"] + firstMatrixContent[0].map{
            if(($0) != nil){return String($0!)} else {return "NA"}
            })
        firstMatrixView.addRecord(record: ["Escalate if # of DLT <="] + firstMatrixContent[1].map{
            if(($0) != nil){return String($0!)} else {return "NA"}
            })
        firstMatrixView.addRecord(record: ["Deescalate if # of DLT >="] + firstMatrixContent[2].map{
            if(($0) != nil){return String($0!)} else {return "NA"}
            })
        firstMatrixView.addRecord(record: ["Eliminate if # of DLT >="] + firstMatrixContent[3].map{
            if(($0) != nil){return String($0!)} else {return "NA"}
            })

        var columns2 = [150]
        let len2 = secondMatrixContent[0].count
        for _ in 1...len2
        {
            columns2.append((400 - 150)/len2)
        }
        columns2[columns2.count - 1] += 400 - sum(array: columns2)
        self.secondMatrixView = NALLabelsMatrixView(frame: CGRect.init(x: 18, y: 300, width: 400, height: 50), columns: columns2)//
        self.view.addSubview(self.secondMatrixView)
        secondMatrixView.addRecord(record: ["Number of patients treated"] + secondMatrixContent[0].map{
            if(($0) != nil){return String($0!)} else {return "NA"}
            })
        secondMatrixView.addRecord(record: ["Escalate if # of DLT <="] + secondMatrixContent[1].map{
            if(($0) != nil){return String($0!)} else {return "NA"}
            })
        secondMatrixView.addRecord(record: ["Deescalate if # of DLT >="] + secondMatrixContent[2].map{
            if(($0) != nil){return String($0!)} else {return "NA"}
            })
        secondMatrixView.addRecord(record: ["Eliminate if # of DLT >="] + secondMatrixContent[3].map{
            if(($0) != nil){return String($0!)} else {return "NA"}
            })
        if(thirdMatrixContent != nil)
        {
            var columns3 = [150]
            
            for _ in 1...thirdMatrixContent![0].count
            {
                columns3.append((500 - 150)/thirdMatrixContent![0].count)
            }
            columns3[columns3.count - 1] += 500 - sum(array: columns3)
            self.thirdMatrixView = NALLabelsMatrixView(frame: CGRect.init(x: 18, y: 580, width: 500, height: 60), columns: columns3)
            self.view.addSubview(self.thirdMatrixView)
            thirdMatrixView.addRecord(record: ["# patients treated at the lowest dose"] + thirdMatrixContent![0].map{
                if(($0) != nil){return String($0!)} else {return "NA"}
                })
            thirdMatrixView.addRecord(record: ["Stop the trial if # of DLT >="] + thirdMatrixContent![1].map{
                if(($0) != nil){return String($0!)} else {return "NA"}
                })
        }
        
    }
    
}
