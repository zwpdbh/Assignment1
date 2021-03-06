//
//  Fraction.swift
//  prog2.1
//
//  Created by zwpdbh on 7/20/16.
//  Copyright © 2016 Otago. All rights reserved.
//

import Foundation

public final class Fraction: CustomStringConvertible, MatrixData {
    private let num: Int
    private let den: Int
    
    public init() {
        self.num = 0
        self.den = 1
    }
    
    public init(num: Int, den: Int) {
        assert(den != 0, "den can not be set to zero")
        
        var num = num
        var den = den
        
        if(den < 0) {
            num = -num
            den = -den
        }
        
        for gcd in (1...den).reverse() {
            if(num % gcd == 0 && den % gcd == 0) {
                num /= gcd
                den /= gcd
                break
            }
        }
        
        self.num = num
        self.den = den
    }
    
    public convenience init(num: Int) {
        self.init(num: num, den: 1)
    }
    
    public var decimal: Float {
        get {
            return Float(self.num) / Float(self.den)
        }
    }
    
    public var description: String {
        if self.num == 0 {
            return "0"
        }
        if self.den == 1 {
            return "\(self.num)"
        }
        return "\(self.num)/\(self.den)"
    }
    
    private func add(f: Fraction) -> Fraction {
        return Fraction(num: self.num * f.den + self.den * f.num, den: self.den * f.den)
    }
    
    private func subtract(f: Fraction) -> Fraction {
        return Fraction(num: self.num * f.den - self.den * f.num, den: self.den * f.den)
    }
    
    private func multiply(f: Fraction) -> Fraction {
        return Fraction(num: self.num * f.num, den: self.den * f.den)
    }
    
    private func divide(f: Fraction) -> Fraction {
        return Fraction(num: self.num * f.den, den: self.den * f.num)
    }
    
    private static func add(f1: Fraction, to f2: Fraction) -> Fraction {
        return Fraction(num: f1.num * f2.den + f1.den * f2.num, den: f1.den * f2.den)
    }
    
    private static func subtract(f1: Fraction, from f2: Fraction) -> Fraction {
        return Fraction(num: f1.num * f2.den - f1.den * f2.num, den: f1.den * f2.den)
    }
    
    private static func multiply(f1: Fraction, by f2: Fraction) -> Fraction {
        return Fraction(num: f1.num * f2.num, den: f1.den * f2.den)
    }
    
    private static func divide(f1: Fraction, by f2: Fraction) -> Fraction {
        return Fraction(num: f1.num * f2.den, den: f1.den * f2.num)
    }
    
    public static func readFromString(string: String) -> Fraction? {
        var num: Int = 0
        var den: Int = 1
        
        var tokens = string.componentsSeparatedByString("/")
        
        if tokens.count > 0 {
            if let n = Int(tokens[0]) {
                num = n
            } else {
                return nil
            }
        }
        
        if tokens.count > 1 {
            if let d = Int(tokens[0]) {
                den = d
            } else {
                return nil
            }
        }
        
        return Fraction(num: num, den: den)
    }
}

/**
 + operator between two Fractions
 */
public func +(f1: Fraction, f2: Fraction) -> Fraction {
    return f1.add(f2)
}

/**
 - operator between two Fractions
 */
public func -(f1: Fraction, f2: Fraction) -> Fraction {
    return f1.subtract(f2)
}

/**
 * operator between two Fractions
 */
public func *(f1: Fraction, f2: Fraction) -> Fraction {
    return f1.multiply(f2)
}

/**
 / operator between two Fractions
 */

public func /(f1: Fraction, f2: Fraction) -> Fraction {
    return f1.divide(f2)
}

public func != (lhs:Fraction, rhs:Fraction) -> Bool{
    let minus=lhs-rhs
    if(minus.num == 0) {return false }
    else {return true};
}
