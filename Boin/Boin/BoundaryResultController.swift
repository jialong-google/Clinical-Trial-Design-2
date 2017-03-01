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
        var columns1 = [130]//麻烦子乔帮忙调下这里的参数。。这个是第一列的宽度
        let len1 = firstMatrixContent[0].count
        for _ in 1...len1
        {
            columns1.append((310 - columns1[0])/len1)//算其余列的宽度，这个地方的310可以换成改变后的宽度
        }
        columns1[columns1.count - 1] += 310 - sum(array: columns1)
        
        self.firstMatrixView = NALLabelsMatrixView(frame: CGRect.init(x: 5, y: 140, width: 310, height: 50), columns: columns1)//麻烦子乔帮忙调下这里的参数。。
        //width是横向宽度。(目前感觉310有点不太够)
        //hight是一行有多高。
        //一开始的CGRect.init是用函数画一个长方形，x和y是左上角那个点。
        
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
        //同理。。第二个matrix和第三个matrix也拜托你调啦。。。
        //另外你可以在storyboard里面移动文字框的位置用来配合。。
        var columns2 = [130]
        let len2 = secondMatrixContent[0].count
        for _ in 1...len2
        {
            columns2.append((310 - 130)/len2)
        }
        columns2[columns2.count - 1] += 310 - sum(array: columns2)
        self.secondMatrixView = NALLabelsMatrixView(frame: CGRect.init(x: 5, y: 175, width: 350, height: 50), columns: columns2)//
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
            var columns3 = [125]
            
            for _ in 1...thirdMatrixContent![0].count
            {
                columns3.append((310 - 125)/thirdMatrixContent![0].count)
            }
            columns3[columns3.count - 1] += 310 - sum(array: columns3)
            self.thirdMatrixView = NALLabelsMatrixView(frame: CGRect.init(x: 5, y: 400, width: 310, height: 50), columns: columns3)
            self.view.addSubview(self.thirdMatrixView)
            thirdMatrixView.addRecord(record: ["The number of patients treated at the lowest dose"] + thirdMatrixContent![0].map{
                if(($0) != nil){return String($0!)} else {return "NA"}
                })
            thirdMatrixView.addRecord(record: ["Stop the trial if # of DLT >="] + thirdMatrixContent![1].map{
                if(($0) != nil){return String($0!)} else {return "NA"}
                })
        }
        //感谢子乔~~！！
    }
    
}
