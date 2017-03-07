//
//  getboundaryViewController.swift
//  Boin
//
//  Created by apple on 19/02/2017.
//  Copyright © 2017 Jialong Li & Ziqiao Wang. All rights reserved.
//

import UIKit

class getboundaryViewController: UIViewController {
    @IBOutlet var samplesizeTextFiled: UITextField!
    @IBOutlet var cohortsizeTextField: UITextField!
    @IBOutlet var targetTextField: UITextField!
    //@IBOutlet weak var safetySwitch: UISwitch!
    
    static var buffer_samplesize : String = ""
    static var buffer_cohortsize : String = ""
    static var buffer_target : String = ""
    var extrasafe_value : Bool = false
    var earlystop_value : Int? = nil
    var fi1_value : Double? = nil
    var fi2_value : Double? = nil
    var offset_value : Double? = nil
    var cutoff_value : Double? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        samplesizeTextFiled.text! = getboundaryViewController.buffer_samplesize
        cohortsizeTextField.text! = getboundaryViewController.buffer_cohortsize
        targetTextField.text! = getboundaryViewController.buffer_target
        // Do any additional setup after loading the view.
    }
    @IBAction func gobuttontapped(_ sender: Any) {
               

    }
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
    
    func getBoundary(target : Double, ncohort : Int, cohortsize : Int, n_earlystop: Int = 100, p_saf : Double? = nil, p_tox : Double? = nil, cutoff_eli : Double = 0.95, extrasafe : Bool = false, offset : Double = 0.05, _print : Bool = true) -> (firstHint : String?, digested: [[Int?]], complete: [[Int?]], secondHint : String?, twoLines: [[Int?]]?)?
    {
        var psaf : Double = 0.0
        var ptox : Double = 0.0
        var res1 : String = String()
        var res2 : String = String()
        var digested :[[Int?]]? = nil
        var twoLines :[[Int?]]? = nil
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
        
        if (_print) {
            res1 += String(format:"Escalate dose if the observed toxicity rate at the current dose <= %.2f\n",lambda1)
            res1 += String(format:"Deescalate dose if the observed toxicity rate at the current dose >= %.2f\n\n",lambda2)
            //res1 += "This is equivalent to the following decision boundaries\n"
            digested = getCol(lists: boundaries, from: 1, to: (min(npts, n_earlystop)/cohortsize), step: cohortsize)
            if (cohortsize > 1) {
                //res1 += "\n"
                //res1 += "A more completed version of the decision boundaries is given by\n"
                
                //res += String(describing: row_boundaries)
                //res1 += String(describing : boundaries)
            }
            if (!extrasafe){
                res1 += "Default stopping rule: stop the trial if the lowest dose is eliminated.\n"
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
            //let row_stopboundary = ["The number of patients treated at the lowest dose  ", "Stop the trial if # of DLT >=        "]
            if (_print) {
                res2 += "\n"
                res2 += "In addition to the default stopping rule (i.e., stop the trial if the lowest dose is eliminated), \n"
                res2 += "the following more strict stopping safety rule will be used for extra safety: \n"
                res2 += " stop the trial if (1) the number of patients treated at the lowest dose >= 3 AND\n(2) Pr(the toxicity rate of the lowest dose >\(target)| data) > \(cutoff_eli - offset)\n which corresponds to the following stopping boundaries:\n"
                //diff
                //res += String(describing: row_stopboundary)
                //res += String(describing: stopboundary)
                twoLines = stopboundary
            }
        }
        return (res1, digested!, boundaries, res2, twoLines) //boundaries
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let DestViewController : AdvancedViewController = segue.destination as? AdvancedViewController else{
        
            guard let  DestViewController : BoundaryResultController = segue.destination as? BoundaryResultController else
            {
                return
            }
            let samplesize = samplesizeTextFiled.text;
            let cohort = cohortsizeTextField.text;
            let target = targetTextField.text;
            func displayMyAlertMessage(userMessage:String)
            {
                let myAlert = UIAlertController(title:"Alert",message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
                let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil);
                myAlert.addAction(okAction);
                self.present(myAlert,animated:true,completion:nil);
            }
            if ((samplesize?.isEmpty)! || (cohort?.isEmpty)! || (target?.isEmpty)!)
            {
                displayMyAlertMessage(userMessage: "All fields are required");
                return;
            }
            let string = NSString(string: target!)
            if ( string.doubleValue > 0.6 )
            {
                displayMyAlertMessage(userMessage: "Error: the target is too high! ");
                return;
            }
            if ( string.doubleValue < 0.05)
            {
                displayMyAlertMessage(userMessage: "Error: the target is too low! ");
                return;
            }
        /*if(earlystop_value == nil||fi1_value == nil||fi2_value == nil||offset_value == nil||cutoff_value == nil)
        {
            let boundaryResult = getBoundary(target: Double(targetTextField.text!)!, ncohort: Int(samplesizeTextFiled.text!)!, cohortsize: Int(cohortsizeTextField.text!)!, extrasafe : extrasafe_value,_print: true)!
            DestViewController.resultText = boundaryResult.firstHint!
            DestViewController.resultText2 = boundaryResult.secondHint!
            DestViewController.firstMatrixContent = boundaryResult.digested
            DestViewController.secondMatrixContent = boundaryResult.complete
            DestViewController.thirdMatrixContent = boundaryResult.twoLines
        }
        else{*/
            let boundaryResult = getBoundary(target: Double(targetTextField.text!)!, ncohort: Int(samplesizeTextFiled.text!)!, cohortsize: Int(cohortsizeTextField.text!)!, n_earlystop : earlystop_value ?? 100, p_saf : fi1_value ?? nil, p_tox : fi2_value ?? nil, cutoff_eli : cutoff_value ?? 0.95, extrasafe : extrasafe_value, offset: offset_value ?? 0.05, _print : true)!
            DestViewController.resultText = boundaryResult.firstHint!
            DestViewController.resultText2 = boundaryResult.secondHint!
            DestViewController.firstMatrixContent = boundaryResult.digested
            DestViewController.secondMatrixContent = boundaryResult.complete
            DestViewController.thirdMatrixContent = boundaryResult.twoLines
            return
        }
        getboundaryViewController.buffer_target = targetTextField.text ?? ""
        getboundaryViewController.buffer_cohortsize = cohortsizeTextField.text ?? ""
        getboundaryViewController.buffer_samplesize = samplesizeTextFiled.text ?? ""
        
        
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
