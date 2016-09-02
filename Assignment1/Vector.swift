//
//  Vector.swift
//  MatrixAndVector
//
//  Created by zwpdbh on 8/11/16.
//  Copyright © 2016 Otago. All rights reserved.
//

import Foundation


public class Vector<T: MatrixData>: BasicVector, VectorArithmetic, VectorToMatrix {
    
    internal var _data : Array<UnsafeMutablePointer<T>>
    private var _size: Int
    
    public init(size: Int) {
        assert(size > 0, "initial size of vector must be bigger than zero")
        self._size = size
        self._data = Array<UnsafeMutablePointer<T>>()
        
        for _ in 0..<size {
            let pt = UnsafeMutablePointer<T>.alloc(sizeof(T.self))
            pt.initialize(T())
            self._data.append(pt)
        }
    }
    
    deinit {
        for i in 0..<self._size {
            if self._data[i] != nil {
                self._data[i].destroy()
                self._data[i].dealloc(sizeof(T.self))
                self._data[i] = nil
            }
        }
    }
    
    public var size: Int {
        return self._size
    }
    
    // Computes the dot product of the vector with another vector
    public func dot(v: Vector<T>) -> T {
        assert(self.size == v.size, "Vector dot failure The size of both vector does not match:\n one is \(self.size), another is \(v.size)")
        var total = T()
        for i in 0..<self.size {
            total = total + self[i] * v[i]
        }
        return total
        
    }
    
    public var description: String {
        var str: String = ""
        for i in 0..<self.size {
            str += " \(self._data[i].memory)"
        }
        return str
    }
    
    // Returns/sets the element value at the given index
    public subscript(index: Int) -> T {
        get {
            assert(index >= 0 && index < self._size, "Vector element get failure The index of vector should be 0~\(self._size - 1)")
            return self._data[index].memory
        }
        
        set {
            assert(index >= 0 && index < self._size, "Vector element set failure :The index of vector should be 0~\(self._size - 1)")
            self._data[index].memory = newValue
        }
    }
    
    
    // Returns a new object instance that is a copy of the current vector
    public func copy() -> Vector<T> {
        let newVector = Vector(size: self.size)
        for i in 0..<self.size {
            newVector[i] = self._data[i].memory
        }
        return newVector
    }
    
    // Convert Vector to Matrix
    public var matrixview: Matrix<T> {
        var tmp = self
        return Matrix(v: &tmp)
    }
    
}




// Vector and Vector operators
/**
 dot product return nil, fix it
 */
public func *<T: MatrixData>(lhs: Vector<T>, rhs: Vector<T>) -> T {
    assert(lhs.size == rhs.size, "Vector Multiply failure The size of both vector does not match:\n one is \(lhs.size), another is \(rhs.size)")
    return lhs.dot(rhs)
}

/**
 return a new vector which is the sum of v1 + v2
 */
public func +<T: MatrixData>(lhs: Vector<T>, rhs: Vector<T>) -> Vector<T> {
    assert(lhs.size == rhs.size, "Vector puls Vector failure The size of both vector does not match:\n one is \(lhs.size), another is \(rhs.size)")
    
    let newVector = Vector<T>(size: lhs.size)
    for i in 0..<lhs.size {
        newVector[i] = lhs[i] + rhs[i]
    }
    return newVector
}


/**
 return a new vector which is the difference of v1 - v2
 */
public func -<T: MatrixData>(lhs: Vector<T>, rhs: Vector<T>) -> Vector<T> {
    assert(lhs.size == rhs.size, "Vector minus failure The size of both vector does not match:\n one is \(lhs.size), another is \(rhs.size)")
    let newVector = Vector<T>(size: lhs.size)
    for i in 0..<lhs.size {
        newVector[i] = lhs[i] - rhs[i]
    }
    return newVector
}

// Vector and scalar operators
public func +<T: MatrixData>(lhs: Vector<T>, rhs:T) -> Vector<T> {
    let newVector = Vector<T>(size: lhs.size)
    for i in 0..<lhs.size {
        newVector[i] = lhs[i] + rhs
    }
    return newVector
}

public func -<T: MatrixData>(lhs: Vector<T>, rhs: T) -> Vector<T> {
    let newVector = Vector<T>(size: lhs.size)
    for i in 0..<lhs.size {
        newVector[i] = lhs[i] - rhs
    }
    return newVector
}

public func *<T: MatrixData>(lhs: Vector<T>, rhs: T) -> Vector<T> {
    let newVector = Vector<T>(size: lhs.size)
    for i in 0..<lhs.size {
        newVector[i] = lhs[i] * rhs
    }
    return newVector
}

public func /<T: MatrixData>(lhs: Vector<T>, rhs: T) -> Vector<T> {
    let str = rhs.description
    assert((str != "0.0" && str != "0"), "Vector Devision scaler failure, Can not be devided by zero")
    
    let newVector = Vector<T>(size: lhs.size)
    for i in 0..<lhs.size {
        newVector[i] = lhs[i] / rhs
    }
    return newVector
}