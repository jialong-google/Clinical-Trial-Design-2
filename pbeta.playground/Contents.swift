//: Playground - noun: a place where people can play

import UIKit

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
    if x == 0 || x == 1
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
    /*
    let temp1 = Double(gamma(x: a))
    let temp2 = Double(gamma(x: b))
    let temp3 = Double(gamma(x: a + b))
    let res = (temp1 / temp3) * temp2
    */
    
    /*if(a <= 1)
    {
        return 1.0
    }
    var res: Double = 1.0 / Double(a + b - 1)
    for i in 1...(a - 1)
    {
        res = res * (Double(i)/Double(b - 1 + i))
    }
    return res*/
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
    //print("integral:\(integral)")
    //print(B(a: a,b: b))
    res = integral / B(a: a,b: b)
    //print(res)
    return res
}

for i in 1...100
{
    print(pbeta(x: 0.5, a: i, b: 3))
    print(i)
}
/*
print(pbeta(x: 0.3, a: 4, b: 10))
print(pbeta(x: 0.3, a: 10, b: 10))
print(pbeta(x: 0.4, a: 1, b: 3))
print(pbeta(x: 0.3, a: 10, b: 10))
print(pbeta(x: 1, a: 1, b: 1))
*/

