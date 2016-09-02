//
//  Complex.swift
//  prog3.3
//
//  Created by zwpdbh on 7/27/16.
//  Copyright © 2016 Otago. All rights reserved.
//

import Foundation

final class Complex: CustomStringConvertible, MatrixData {
    var real: Float
    var imag: Float
    
    // computed property
    var magnitude: Float {
        return real*real + imag*imag
    }
    
    var description: String {
        if self.imag < 0 {
            return "\(self.real)\(self.imag)i"
        } else if self.imag == 0 {
            return "\(self.real)"
        } else if self.real == 0 {
            return "\(self.imag)i"
        } else {
            return "\(self.real)+\(self.imag)i"
        }
        
    }
    
    // Designated initialiser
    init(real: Float, imag: Float) {
        self.real = real
        self.imag = imag
    }
    
    convenience init() {
        self.init(real: 0, imag: 0)
    }
    
    func copy() -> Complex {
        return Complex(real: self.real, imag: self.imag)
    }
    
    static func add(c1: Complex, to c2: Complex) -> Complex {
        return Complex(real: c1.real + c2.real, imag: c1.imag + c2.imag)
    }
    
    static func subtract(c1: Complex, from c2: Complex) -> Complex {
        return Complex(real: c1.real - c2.real, imag: c1.imag - c2.imag)
    }
    
    static func multiply(c1: Complex, by c2: Complex) -> Complex {
        return Complex(real: c1.real * c2.real - c1.imag * c2.imag, imag: c1.real * c2.imag + c1.imag * c2.real)
    }
    
    static func divide(c1: Complex, by c2: Complex) -> Complex {
        return Complex(real: (c1.real * c2.real + c1.imag * c2.imag) / c2.magnitude, imag: (c1.imag * c2.real - c1.real * c2.imag) / c2.magnitude)
    }
    
    static func readFromString(string: String) -> Complex? {
        var tokens = string.componentsSeparatedByString("i")
        
        if tokens.count > 0 {
            // The token is the number without the i, so can convert it
            // to a float value
            let numToken = tokens[0]
            let numFromStr : Float? = (numToken as NSString).floatValue;
            
            // If the conversion of the number to float worked...
            if let num = numFromStr {
                // Check if the token is the same as argument string...
                if numToken == string {
                    // If yes, then it means there was no i in the string...
                    return Complex(real: num, imag: 0.0)
                } else {
                    // If the passed in string had "i" at the end, the
                    // separate by string would have removed the i, so the
                    // token is not the same as the argument string.
                    // The number then is imaginary
                    return Complex(real: 0.0, imag: num);
                }
            }
        }
        return nil
    }
}


func +(c1: Complex, c2: Complex) -> Complex {
    return Complex.add(c1, to: c2)
}

func -(c1: Complex, c2: Complex) -> Complex {
    return Complex.subtract(c1, from: c2)
}

func *(c1: Complex, c2: Complex) -> Complex {
    return Complex.multiply(c1, by: c2)
}

func /(c1: Complex, c2: Complex) -> Complex {
    return Complex.divide(c1, by: c2)
}

func +(c: Complex, x: Float) -> Complex {
    return Complex.add(c, to: Complex(real: x, imag: 0))
}

func -(c: Complex, x: Float) -> Complex {
    return Complex.subtract(c, from: Complex(real: x, imag: 0))
}

func *(c: Complex, x: Float) -> Complex {
    return Complex.multiply(c, by: Complex(real: x, imag: 0))
}

func /(c: Complex, x: Float) -> Complex {
    return Complex.divide(c, by: Complex(real: x, imag: 0))
}



func != (lhs:Complex, rhs:Complex) -> Bool{
    
    if(lhs.real==rhs.real && lhs.imag == rhs.imag){
        return false}
    else {return true }
}

