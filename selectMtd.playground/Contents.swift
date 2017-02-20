//: Playground - noun: a place where people can play

import UIKit
//func fact(factorialNumber: Int) -> Double {
//    var res = 1.0
//    if(factorialNumber <= 0){
//        return 1.0
//    }
//    for i in 1...factorialNumber
//    {
//        res = res * Double(i)
//    }
//    return res
//}
//
//func gamma(x : Int) -> Double
//{
//    if x == 0 || x == 1
//    {
//        return 1.0
//    }
//    if(x > 1)
//    {
//        var res = 1
//        for i in 1...(x - 1)
//        {
//            res = i * res;
//        }
//        return Double(res)
//    }
//    else
//    {
//        var prev : Double = 1 / (Double(x) * fact(factorialNumber : x))
//        if x % 2 != 0 {
//            prev = -prev
//        }
//        let temp = prev - Double(gamma(x : 1 - x)) / Double(x)
//        return temp
//    }
//}
func B(a : Int,b : Int) -> Double
{
    return Btop(x:1, a: a, b:b)
}

func Btop(x : Double, a: Int, b: Int) -> Double
{
    if b == 1
    {
        return pow(x, Double(a)) / Double(a)
    }
    else{
        let temp = pow(x, Double(a)) * pow(1 - x, Double(b - 1)) / Double(a)
        return temp + Double(b - 1) / Double(a) * Btop(x: x, a: a + 1, b: b - 1)
    }
}
func pbeta(x: Double,a: Int, b: Int) -> Double
{
    var res = Double()
    let integral = Btop(x:x, a:a, b:b)
    res = integral / B(a: a,b: b)
    return res
}


func diff(x: [Double]) -> [Double]
{
    var res = [Double](repeating : 0.0, count: x.count - 1)
    for i in 0...res.count - 1
    {
        res[i] = x[i + 1] - x[i]
    }
    return res
}
func selectMtd (target : Double, npts : [Int] , ntox : [Int], cutoff_eli : Double = 0.95, extrasafe: Bool = false, offset : Double = 0.05, _print : Bool = true) -> Int?
{
    func pava( x:inout [Double?], wt:[Double?]? = nil) -> [Double?]{
        let n: Int = x.count
        var weight: [Double?]? = nil
        if(wt == nil){
            weight = [Double](repeating: 1.0, count: n)
        }
        else{
            weight = wt
        }
        if(n <= 1) {
            return x
        }
        var missing : Bool = false
        for i in x {
            if(i == nil)
            {
                missing = true
            }
        }
        for i in weight! {
            if(i == nil)
            {
                missing = true
            }
        }
        if (missing  || weight == nil) {
            print("Missing values in 'x' or 'wt' not allowed")
        }
        var lvlsets :[Int] = [Int](1...n)
        while(true) {
            var viol :[Bool] = diff(x: x as! [Double]).map {$0 < 0}
            var flag : Bool = false
            for i in viol{
                if(i)
                {
                    flag = true
                }
            }
            if(flag == false)
            {
                break
            }
            
            var i : Int = -1
            for j in 1...(n-1){
                if(viol[j - 1] == true)
                {
                    i = j - 1
                    break;
                }
            }
            let lvl1 = lvlsets[i]
            let lvl2 = lvlsets[i + 1]
            var ilvl :[Bool] = [Bool]()
            for j in lvlsets{
                if(j == lvl1 || j == lvl2)
                {
                    ilvl.append(true)
                }
                else{
                    ilvl.append(false)
                }
            }
            var temp1 : Double = 0.0
            var temp2 : Double = 0.0
            for j in 0 ..< ilvl.count{
                if(ilvl[j] == true)
                {
                    lvlsets[j] = lvl1
                    temp1 += x[j]! * weight![j]!
                    temp2 += weight![j]!
                }
            }
            let temp: Double = temp1/temp2
            for j in 0 ..< ilvl.count {
                if(ilvl[j] == true) {
                    x[j] = temp
                }
            }
            
        }
        return x
    }
    var y : [Int] = ntox
    var n : [Int] = npts
    let ndose : Int = n.count
    var elimi = [Int](repeating:0, count: ndose)
    for i in 0..<ndose {
        if (n[i] >= 3) {
            if (1 - pbeta(x: target, a: y[i] + 1, b: n[i] - y[i] + 1) > cutoff_eli) {
                for j in i...ndose {
                    elimi[j - 1] = 1
                }
                break
            }
        }
    }
    if(extrasafe){
        if (n[0] >= 3) {
            if (1 - pbeta(x: target, a: y[0] + 1, b: n[0] - y[0] + 1) > cutoff_eli - offset) {
                for j in 1...ndose {
                    elimi[j - 1] = 1
                }
            }
        }
    }
    var selectdose : Int? = nil
    var sumup : Int = 0
    for i in 0..<elimi.count {
        if(elimi[i] == 0)
        {
            sumup += n[i]
        }
    }
    if (elimi[0] == 1 || sumup == 0) {
        selectdose = 99
    }
    else {
        //var adm_set : [Bool] = (n != 0) & (elimi == 0)
        //var adm_index = which(adm_set == T)
        //var y_adm = y[adm_set]
        //var n_adm = n[adm_set]
        //var phat : [Double] = (y_adm + 0.05)/(n_adm + 0.1)
        //var phat_var = (y_adm + 0.05) * (n_adm - y_adm + 0.05)/((n_adm + 0.1)* (n_adm + 0.1) * (n_adm + 1.1)) // 1/
        var adm_index = [Int]()
        var y_adm = [Int]()
        var n_adm = [Int]()
        var phat = [Double?]()
        var phat_var = [Double]()
        for i in 0..<min(n.count, elimi.count)
        {
            if(n[i] != 0 && elimi[i] == 0) {
                adm_index.append(i + 1)//!!!!!!
                y_adm.append(y[i])
                n_adm.append(n[i])
                phat.append((Double(y[i]) + 0.05 )/(Double(n[i])+0.1))
                phat_var.append(((Double(n[i]) + 0.1)*(Double(n[i]) + 0.1)*(Double(n[i])+1.1))/((Double(y[i]) + 0.05)*(Double(n[i]) - Double(y[i])+0.05)))
            }
            
        }
        phat = pava(x: &phat, wt: phat_var)
        var min_index = 0
        for i in 0..<phat.count{
            if((phat[i]) != nil)
            {
                phat[i]! += 1e-10
                phat[i]! = abs(phat[i]! - target)
                if(phat[i]!  < phat[min_index]!)
                {
                    min_index = i
                }
            }
        }
        phat.sort{$0! < $1!}
        selectdose = adm_index[min_index]
    }
    
    if (_print) {
//        if (selectdose == 99) {
//            print("All tested doses are overly toxic. No MTD is selected! \n")
//        }
//        else {
//            print("The MTD is dose level \(selectdose) \n\n")
//        }
//        var trtd : [Bool] = [Bool]()
//        for p in n{
//            if(p == 0)
//            {
//                trtd.append(false);
//            }
//            else
//            {
//                trtd.append(true);
//            }
//        }
//        let phat_all : [Int?] = pava(x: (y[trtd] + 0.05)/(n[trtd] + 0.1), wt: 1/((y[trtd] + 0.05) * (n[trtd] - y[trtd] + 0.05)/((n[trtd] + 0.1)^2 * (n[trtd] + 0.1 + 1))))
//        print("Dose    Posterior DLT             95%                  \n")
//        print("Level     Estimate         Credible Interval   Pr(toxicity> \(target)|data)\n")
//        for i in 1...ndose {
//            if (n[i] > 0) {
//                print(" \(i)        \(phat_all[i])")
//            }
//            else {
//                print(" \(i)          ----")
//            }
//        }
//        print("NOTE: no estimate is provided for the doses at which no patient was treated.")
    }
    
    return selectdose
}



selectMtd(target: 0.3, npts: [3,3,15,9,0], ntox: [0,0,4,4,0])
selectMtd(target: 0.3, npts: [0], ntox: [0])
