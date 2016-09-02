//
//  Interface.swift
//  MatrixAndVector
//
//  Created by zwpdbh on 8/11/16.
//  Copyright © 2016 Otago. All rights reserved.
//

import Foundation

// Constraints for matrix data generic type
public protocol MatrixData: CustomStringConvertible {
    // Must have a default initialiser
    init()
    // Must provide basic arithmetic operators
    // with itself
    func *(_: Self, _:Self) -> Self
    func /(_: Self, _:Self) -> Self
    func +(_: Self, _:Self) -> Self
    func -(_: Self, _:Self) -> Self
}

// Int, Float and Double alread conform to MatrixData -
// extend them to inform compiler about this.
extension Int: MatrixData { }
extension Float: MatrixData { }
extension Double: MatrixData { }

public protocol BasicMatrix: CustomStringConvertible {
    // Generic data type
    associatedtype T: MatrixData
    // Returns the number of rows in the matrix
    var rows: Int { get }
    // Returns the number of columns in the matrix
    var columns: Int { get }
    // Returns a matrix that is a transpose of the current matrix
    var transpose: Matrix<T> { get }
    // Returns/sets the element value at the given row and column index
    subscript(row: Int, column: Int) -> T { get set }
    // Returns a new object that is a copy of the current matrix
    func copy() -> Matrix<T>
}

public protocol BasicVector: CustomStringConvertible {
    // Generic data type
    associatedtype T: MatrixData
    // Returns the size of the vector
    var size: Int { get }
    // Computes the dot product of the vector with another vector
    func dot(v: Vector<T>) -> T
    // Returns/sets the element value at the given index
    subscript(index: Int) -> T { get set }
    // Returns a new object instance that is a copy of the current vector
    func copy() -> Vector<T>
}

public protocol MatrixArithmetic: BasicMatrix {
    // Generic data type
    associatedtype T: MatrixData
    // Matrix and Matrix operators
    func *(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T>
    func +(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T>
    func -(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T>
    // Matrix and scalar operators
    func +(lhs: Matrix<T>, rhs:T) -> Matrix<T>
    func -(lhs: Matrix<T>, rhs: T) -> Matrix<T>
    func *(lhs: Matrix<T>, rhs: T) -> Matrix<T>
    func /(lhs: Matrix<T>, rhs: T) -> Matrix<T>
}

public protocol VectorArithmetic: BasicVector {
    // Generic data type
    associatedtype T: MatrixData
    // Vector and Vector operators
    func *(lhs: Vector<T>, rhs: Vector<T>) -> T
    func +(lhs: Vector<T>, rhs: Vector<T>) -> Vector<T>
    func -(lhs: Vector<T>, rhs: Vector<T>) -> Vector<T>
    // Vector and scalar operators
    func +(lhs: Vector<T>, rhs:T) -> Vector<T>
    func -(lhs: Vector<T>, rhs: T) -> Vector<T>
    func *(lhs: Vector<T>, rhs: T) -> Vector<T>
    func /(lhs: Vector<T>, rhs: T) -> Vector<T>
}

public protocol MatrixToVector: MatrixArithmetic {
    // Generic data type
    associatedtype T: MatrixData
    // Convert Matrix to Vector
    var vectorview: Vector<T> { get }
    // Select row vector from matrix
    func row(index: Int) -> Vector<T>
    // Select column vector from matrix
    func column(index: Int) -> Vector<T>
}

public protocol VectorToMatrix: VectorArithmetic {
    // Generic data type
    associatedtype T: MatrixData
    // Convert Vector to Matrix
    var matrixview: Matrix<T> { get }
}