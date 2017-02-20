import UIKit

//func B(a : Int,b : Int) -> Double
//{
//    return Btop(x:1, a: a, b:b)
//}
//
//func Btop(x : Double, a: Int, b: Int) -> Double
//{
//    if b == 1
//    {
//        return pow(x, Double(a)) / Double(a)
//    }
//    else{
//        let temp = pow(x, Double(a)) * pow(1 - x, Double(b - 1)) / Double(a)
//        return temp + Double(b - 1) / Double(a) * Btop(x: x, a: a + 1, b: b - 1)
//    }
//}
//func pbeta(x: Double,a: Int, b: Int) -> Double
//{
//    var res = Double()
//    let integral = Btop(x:x, a:a, b:b)
//    res = integral / B(a: a,b: b)
//    return res
//}
//
//func rbind( lists:[Int?]...) -> [[Int?]]
//{
//    var res = [[Int?]]()
//    for list in lists{
//        res.append(list);
//    }
//    return res;
//}
func getOc(target: Double, p_true: [String], ncohort: Int, cohortsize: Int, n_earlystop: Int = 100, startdose: Int = 1, p_saf : Double? = nil, p_tox : Double? = nil, cutoff_eli : Double = 0.95, extrasafe : Bool = false, offset : Double = 0.05, ntrial: Int=1000) -> ()
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
/*set.seed(6)???*/
    



}
