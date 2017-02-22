//
//  getboundaryViewController.swift
//  Boin
//
//  Created by apple on 19/02/2017.
//  Copyright © 2017 Jialong Li & Ziqiao Wang. All rights reserved.
//

import UIKit

class getboundaryViewController: UIViewController {

    @IBOutlet weak var samplesizeTextFiled: UITextField!
    @IBOutlet weak var cohortsizeTextField: UITextField!
    @IBOutlet weak var targetTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func gobuttontapped(_ sender: Any) {
        let target = targetTextField;
        let ncohort = samplesizeTextFiled;
        let cohortsize = cohortsizeTextField;
        func fact(factorialNumber: Int) -> Double {
            var res = 1.0
            if(factorialNumber <= 0){
                return 1.0
            }
            for i in 1...factorialNumber
            {
                res = res * Double(i)
            }
            return res
        }
        
        func gamma(x : Int) -> Double
        {
            if(x == 0 || x == 1)
            {
                return 1.0
            }
            if(x > 1)
            {
                var res = 1
                for i in 1...(x - 1)
                {
                    res = i * res;
                }
                return Double(res)
            }
            else
            {
                var prev : Double = 1 / (Double(x) * fact(factorialNumber : x))
                if x % 2 != 0 {
                    prev = -prev
                }
                let temp = prev - Double(gamma(x : 1 - x)) / Double(x)
                return temp
            }
        }
        func B(a : Int,b : Int) -> Double
        {
            /*let temp1 = Double(gamma(x: a))
             let temp2 = Double(gamma(x: b))
             let temp3 = Double(gamma(x: a + b))
             let res = temp1 * temp2 / temp3
             return res
             */
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
        //--------------------------------------------------------
        func rbind( lists:[Int?]...) -> [[Int?]]
        {
            var res = [[Int?]]()
            for list in lists{
                res.append(list);
            }
            return res;
        }
        func getCol(lists : [[Int?]], from : Int, to : Int, step :Int = 1) -> [[Int?]]{
            var res = [[Int?]]()
            let from = from * step
            let to = to * step
            for list in lists{
                var temp = [Int?]()
                if(from > list.count){
                    continue
                }
                for i in stride(from: from - 1, to: to, by : step) {
                    if(i < list.count){
                        temp.append(list[i])
                    }
                }
                res.append(temp)
            }
            return res
        }
        
        func getBoundary(target : Double, ncohort : Int, cohortsize : Int, n_earlystop: Int = 100, p_saf : Double? = nil, p_tox : Double? = nil, cutoff_eli : Double = 0.95, extrasafe : Bool = false, offset : Double = 0.05, _print : Bool = true) -> ([[Int?]], [String], [String])?
            // the return value is unsure. some of the objects should be applied.
        {
            var psaf : Double = 0.0
            var ptox : Double = 0.0
            
            if (p_saf == nil)
            {
                psaf = 0.6 * target
            }
            else
            {
                psaf = p_saf!
            }
            if (p_tox == nil)
            {
                ptox = 1.4 * target
            }
            else
            {
                ptox = p_tox!
            }
            if (target < 0.05) {
                print("Error: the target is too low! \n")
                return nil // means exit with error.
            }
            if (target > 0.6) {
                print("Error: the target is too high! \n")
                return nil
            }
            if ((target - psaf) < (0.1 * target)) {
                print("Error: the probability deemed safe cannot be higher than or too close to the target! \n")
                return nil
            }
            if ((ptox - target) < (0.1 * target)) {
                print("Error: the probability deemed toxic cannot be lower than or too close to the target! \n")
                return nil
            }
            if (offset >= 0.5) {
                print("Error: the offset is too large! \n")
                return nil
            }
            if (n_earlystop <= 6) {
                print("Warning: the value of n.earlystop is too low to ensure good operating characteristics. Recommend n.earlystop = 9 to 18 \n")
                return nil
            }
            let npts : Int = ncohort * cohortsize
            var ntrt = [Int]()
            var b_e = [Int]()
            var b_d = [Int]()
            var elim = [Int?]()
            
            var lambda1: Double = 0.0
            var lambda2: Double = 0.0
            for n in 1...npts{
                lambda1 = log((1 - psaf)/(1 - target))/log(target * (1 - psaf)/(psaf * (1 - target)))
                lambda2 = log((1 - target)/(1 - ptox))/log(ptox * (1 - target)/(target * (1 - ptox)))
                let cutoff1 = Int(floor(lambda1 * Double(n)))
                let cutoff2 = Int(ceil(lambda2 * Double(n)))
                ntrt.append(n)
                b_e.append(cutoff1)
                b_d.append(cutoff2)
                var elimineed = true
                if (n < 3) {
                    elim.append(nil)// it was NA.
                }
                else {
                    for ntox in 1...n {
                        if (1 - pbeta(x: target, a: ntox + 1, b: n - ntox + 1) > cutoff_eli) {
                            elimineed = true
                            elim.append(ntox)
                            break
                        }
                    }
                    if (elimineed == false) {
                        elim.append(nil)
                    }
                }
            }
            for i in 0...(b_d.count - 1) {
                if ((elim[i]) != nil && (b_d[i] > elim[i]!))
                {
                    b_d[i] = elim[i]!
                }
            }
            
            let boundaries = getCol(lists: rbind(lists: ntrt, b_e, b_d, elim), from :1, to: min(npts,n_earlystop))
            let row_boundaries = ["Number of patients treated", "Escalate if # of DLT <=",
                                  "Deescalate if # of DLT >=", "Eliminate if # of DLT >="]
            let col_boundaries = [String](repeating: "", count: min(npts, n_earlystop))
            
            if (_print) {
                print("Escalate dose if the observed toxicity rate at the current dose <= \(lambda1)\n")
                print("Deescalate dose if the observed toxicity rate at the current dose >= \(lambda2)\n\n")
                print("This is equivalent to the following decision boundaries\n")
                print(getCol(lists: boundaries, from: 1, to: (min(npts, n_earlystop)/cohortsize), step: cohortsize))
                if (cohortsize > 1) {
                    print("\n")
                    print("A more completed version of the decision boundaries is given by\n")
                    
                    
                    print(boundaries)
                }
                print("\n")
                if (!extrasafe){
                    print("Default stopping rule: stop the trial if the lowest dose is eliminated.\n")
                }
            }
            if (extrasafe) {
                var stopbd = [Int?]()
                var ntrt = [Int]()
                for n in 1...npts {
                    ntrt.append(n)
                    if (n < 3) {
                        stopbd.append(nil)
                    }
                    else {
                        var stopneed = false
                        for ntox in 1...n {
                            if (1 - pbeta(x: target, a: ntox + 1, b: n - ntox + 1) > cutoff_eli - offset) {
                                stopneed = true
                                stopbd.append(ntox)
                                break
                            }
                        }
                        if (stopneed == false) {
                            stopbd.append(nil)
                        }
                    }
                }
                let stopboundary = getCol(lists: rbind(lists: ntrt, stopbd), from: 1, to: min(npts, n_earlystop))
                let row_stopboundary = ["The number of patients treated at the lowest dose  ", "Stop the trial if # of DLT >=        "]
                let col_stopboundary = [String](repeating: "", count: min(npts, n_earlystop))
                if (_print) {
                    print("\n")
                    print("In addition to the default stopping rule (i.e., stop the trial if the lowest dose is eliminated), \n")
                    print("the following more strict stopping safety rule will be used for extra safety: \n")
                    print(" stop the trial if (1) the number of patients treated at the lowest dose >= 3 AND",
                          "\n", "(2) Pr(the toxicity rate of the lowest dose >",
                          target, "| data) > \(cutoff_eli - offset),\n",
                        "which corresponds to the following stopping boundaries:\n")
                    //diff
                    print(row_stopboundary)
                    print(col_stopboundary)
                    print(stopboundary)
                    
                }
            }
            if (!_print){
                return (boundaries, row_boundaries, col_boundaries)
            }
            return nil
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
