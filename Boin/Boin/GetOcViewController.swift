//
//  GetOcViewController.swift
//  Boin
//
//  Created by apple on 24/02/2017.
//  Copyright © 2017 Jialong Li & Ziqiao Wang. All rights reserved.
//

import UIKit

class GetOcViewController: UIViewController {

    @IBOutlet weak var pvalue: UITextField!
    @IBOutlet weak var ncohort: UITextField!
    @IBOutlet weak var cohortsize: UITextField!
    @IBOutlet weak var target: UITextField!
    
    var pvalueString: String = String()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                if ((1 - pbeta(x: target, a: y[i] + 1, b: n[i] - y[i] + 1)) > cutoff_eli) {
                    for j in (i + 1)...ndose {
                        elimi[j - 1] = 1
                    }
                    break
                }
            }
        }
        if(extrasafe){
            if (n[0] >= 3) {
                if ((1 - pbeta(x: target, a: y[0] + 1, b: n[0] - y[0] + 1)) > (cutoff_eli - offset)) {
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
            var adm_index = [Int]()
            var y_adm = [Int]()
            var n_adm = [Int]()
            var phat = [Double?]()
            var phat_var = [Double]()
            for i in 0..<ndose
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
                    phat[i]! += (Double)(i+1)*(1e-10)
                    
                }
                else
                {
                    phat[i] = (Double)(i+1)*(1e-10)
                    
                }
                let temp = abs(phat[i]! - target)
                if(temp < abs(phat[min_index]! - target))
                {
                    min_index = i
                }
            }
            selectdose = adm_index[min_index]
        }
        
        if (_print) {
                 }
        
        return selectdose
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
    
    
    func getBoundary(target : Double, ncohort : Int, cohortsize : Int, n_earlystop: Int = 100, p_saf : Double? = nil, p_tox : Double? = nil, cutoff_eli : Double = 0.95, extrasafe : Bool = false, offset : Double = 0.05, _print : Bool = true) -> [[Int?]]?
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
        return boundaries
    }
    
    
    func sumRunifLess(number : Int, standard: Double) -> Int
    {
        var res: Int = 0
        for _ in 1...number{
            if(drand48() < standard){
                res += 1
            }
        }
        return res
    }
    func applyColMean(Matrix: [[Int]]) -> [Double]
    {
        let row = Matrix.count
        let col = Matrix[0].count
        var res :[Double] = [Double]()
        for i in 0 ..< col{
            var temp = 0.0
            for j in 0..<row{
                temp += (Double)(Matrix[j][i])
            }
            res.append(temp/((Double)(row)))
        }
        return res
    }
    
    func getOc(target: Double, p_true: [Double], ncohort: Int, cohortsize: Int, n_earlystop: Int = 100, startdose: Int = 1, p_saf : Double? = nil, p_tox : Double? = nil, cutoff_eli : Double = 0.95, extrasafe : Bool = false, offset : Double = 0.05, ntrial: Int=1000) -> (res1: String, res2: String?, res3: String?, selpercent: [Double]?, nptsdose: [Double]?)
    {
        var res : String = String()
        var psaf : Double = 0.0
        var ptox : Double = 0.0
        var res1 : String = String()
        var res2 : String = String()
        var res3 : String = String()
        
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
            res += "Error: the target is too low! \n"
            return (res, nil, nil, nil, nil)
        }
        if (target > 0.6) {
            res += "Error: the target is too high! \n"
            return (res, nil, nil, nil, nil)
        }
        if ((target - psaf) < (0.1 * target)) {
            res += "Error: the probability deemed safe cannot be higher than or too close to the target! \n"
            return (res, nil, nil, nil, nil)
        }
        if ((ptox - target) < (0.1 * target)) {
            res += "Error: the probability deemed toxic cannot be lower than or too close to the target! \n"
            return (res, nil, nil, nil, nil)
        }
        if (offset >= 0.5) {
            res += "Error: the offset is too large! \n"
            return (res, nil, nil, nil, nil)
        }
        if (n_earlystop <= 6) {
            res += "Warning: the value of n.earlystop is too low to ensure good operating characteristics. Recommend n.earlystop = 9 to 18 \n"
            return (res, nil, nil, nil, nil)
        }
        srand48(6)
        let ndose = p_true.count
        var npts = ncohort * cohortsize
        
        var Y : [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: ndose), count: ntrial)
        var N : [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: ndose), count: ntrial)
        var dselect :[Int] = [Int](repeating: 0, count: ntrial)
        var temp = getBoundary(target: target, ncohort: ncohort, cohortsize: cohortsize, n_earlystop: n_earlystop, p_saf: psaf, p_tox: ptox, cutoff_eli: cutoff_eli, extrasafe: extrasafe, _print:false)
        //print(temp)
        var b_e = temp![1]
        var b_d = temp![2]
        var b_elim = temp![3]
        
        for trial in 0..<ntrial{
            var y:[Int] = [Int](repeating: 0, count: ndose)
            var n:[Int] = [Int](repeating: 0, count: ndose)
            var earlystop = false
            var d = startdose - 1
            var elimi :[Int] = [Int](repeating: 0, count: ndose)
            for i in 0..<ncohort{
                y[d] += sumRunifLess(number: cohortsize, standard: p_true[d])
                n[d] += cohortsize
                if(n[d] >= n_earlystop){
                    break
                }
                if(b_elim[n[d] - 1] != nil)
                {
                    if(y[d] >= b_elim[n[d] - 1]!) {
                        for j in d..<ndose{
                            elimi[j] = 1
                        }
                        if(d == 0){
                            earlystop = true
                            break
                        }
                    }
                    if(extrasafe) {
                        if (d == 0 && n[0] >= 3) {
                            if (1 - pbeta(x: target, a: y[0] + 1, b: n[0] - y[0] + 1) > cutoff_eli - offset) {
                                earlystop = true
                                break
                            }
                        }
                        
                    }
                    
                }
                if(y[d] <= b_e[n[d] - 1]! && d != ndose - 1) {
                    if (elimi[d + 1] == 0){
                        d = d + 1
                    }
                }
                else if (y[d] >= b_d[n[d] - 1]! && d != 0) {
                    d = d - 1
                }
            }
            Y[trial] = y
            N[trial] = n
            if (earlystop) {
                dselect[trial] = 99
            }
            else {
                dselect[trial] = selectMtd(target: target, npts: n, ntox: y, cutoff_eli: cutoff_eli, extrasafe: extrasafe, offset: offset, _print :false)!
            }
        }
        var selpercent:[Double] = [Double](repeating: 0.0, count: ndose)
        let nptsdose : [Double] = applyColMean(Matrix: N)
        //var ntoxdose : [Double] = applyColMean(Matrix: Y)
        for i in 0..<ndose {
            var temp = 0
            for j in dselect {
                if(j - 1 == i)
                {
                    temp += 1
                }
            }
            selpercent[i] = Double(temp*100) / Double(ntrial)
        }
        var temp2 = 0
        for j in dselect {
            if(j == 99)
            {
                temp2 += 1
            }
        }
        res1 += "selection percentage at each dose level (%):\n"
        //res += String(describing: selpercent)
        res2 += "\nnumber of patients treated at each dose level:\n"
        //res += String(describing: nptsdose)
        res3 += "\npercentage of early stopping due to toxicity (%):"
        res3 += String(Double(temp2 * 100)/Double(ntrial))
        return (res1, res2, res3, selpercent, nptsdose)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let  DestViewController : OcResultController = segue.destination as? OcResultController else
        {
            return
        }
        let pv = pvalue.text;
        let cohort = cohortsize.text;
        let nc = ncohort.text;
        let tt = target.text;
        func displayMyAlertMessage(userMessage:String)
        {
            let myAlert = UIAlertController(title:"Alert",message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
            let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil);
            myAlert.addAction(okAction);
            self.present(myAlert,animated:true,completion:nil);
        }
        if ((pv?.isEmpty)! || (cohort?.isEmpty)! || (nc?.isEmpty)! || (tt?.isEmpty)!)
        {
            displayMyAlertMessage(userMessage: "All fields are required");
            return;
        }
        let string = NSString(string: tt!)
        if ( string.doubleValue > 0.6 )
        {
            displayMyAlertMessage(userMessage: "Error: the target is too high! ");
            return;
        }
        if (  string.doubleValue < 0.05)
        {
            displayMyAlertMessage(userMessage: "Error: the target is too low! ");
            return;
        }



        let pvalueArray = pvalue.text!.components(separatedBy: " ").map{Double($0)}.filter{$0 != nil}
        let targetValue = Double(target.text!)
        let ncohortValue = Int(ncohort.text!)
        let cohortsizeValue = Int(cohortsize.text!)
        let ocResult = getOc(target: targetValue!, p_true: pvalueArray as! [Double], ncohort: ncohortValue!, cohortsize: cohortsizeValue!)
     //   for i in 0..<pvalueArray.count
       // {
          
         //   if ( pvalueArrayKey > 1.0 ||  pvalueArrayKey < 0.0)
           // {
             //   displayMyAlertMessage(userMessage: "Please enter valid number");
               // return;
            //}
        
       //}
        DestViewController.result1Text = ocResult.res1
        DestViewController.result2Text = ocResult.res2!
        DestViewController.result3Text = ocResult.res3!
        DestViewController.selpercent = ocResult.selpercent
        DestViewController.nptsdose = ocResult.nptsdose
        //DestViewController.resultText = "\(getOc(target: targetValue!, p_true: pvalueArray as! [Double], ncohort: ncohortValue!, cohortsize: cohortsizeValue!))"
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


