//
//  Matrix.swift
//  MatrixAndVector
//
//  Created by zwpdbh on 8/14/16.
//  Copyright © 2016 Otago. All rights reserved.
//

import Foundation

public class Matrix<T: MatrixData>: BasicMatrix, MatrixArithmetic, MatrixToVector {
    private var _rows: Int
    private var _columns: Int
    private var _isTransposed: Bool {
        didSet {
            let tmp = self._columns
            self._columns = self._rows
            self._rows = tmp
        }
    }
    
    private var _dataRow = Array<UnsafeMutablePointer<Vector<T>>>()
    private var _dataColumn = Array<UnsafeMutablePointer<Vector<T>>>()
    
    private var dataRow: Array<UnsafeMutablePointer<Vector<T>>> {
        get {
            if !self._isTransposed {
                return self._dataRow
            } else {
                return self._dataColumn
            }
        }
    }
    
    private var dataColumn: Array<UnsafeMutablePointer<Vector<T>>> {
        get {
            if !self._isTransposed {
                return self._dataColumn
            } else {
                return self._dataRow
            }
        }
    }
    
    public init(rows: Int, columns: Int) {
        assert(rows > 0, "Matrix rows must be bigger than zero")
        assert(columns > 0, "Matrix columns must be bigger than zero")
        self._rows = rows
        self._columns = columns
        self._isTransposed = false
        
        for _ in 0..<rows {
            let rpt = UnsafeMutablePointer<Vector<T>>.alloc(sizeof(Vector<T>.self))
            rpt.initialize(Vector<T>(size: columns))
            self._dataRow.append(rpt)
        }
        
        for i in 0..<columns {
            let cpt = UnsafeMutablePointer<Vector<T>>.alloc(sizeof(Vector<T>.self))
            cpt.initialize(Vector<T>(size: rows))
            self._dataColumn.append(cpt)
            for j in 0..<rows {
                (self._dataColumn[i].memory)._data[j].destroy()
                (self._dataColumn[i].memory)._data[j].dealloc(sizeof(T.self))
                (self._dataColumn[i].memory)._data[j] = (self._dataRow[j].memory)._data[i]
            }
        }
        
    }
    
    internal init(inout v: Vector<T>) {
        self._rows = 1
        self._columns = v.size
        self._isTransposed = false
        
        for _ in 0..<self._rows {
            let rpt = UnsafeMutablePointer<Vector<T>>.alloc(sizeof(Vector<T>.self))
            rpt.initialize(v)
            self._dataRow.append(rpt)
        }
        
        for i in 0..<columns {
            let cpt = UnsafeMutablePointer<Vector<T>>.alloc(sizeof(Vector<T>.self))
            cpt.initialize(Vector<T>(size: rows))
            self._dataColumn.append(cpt)
            for j in 0..<rows {
                (self._dataColumn[i].memory)._data[j].destroy()
                (self._dataColumn[i].memory)._data[j].dealloc(sizeof(T.self))
                (self._dataColumn[i].memory)._data[j] = (self._dataRow[j].memory)._data[i]
            }
        }
        
    }

    
    deinit {
        var row = self._rows
        var col = self._columns
        if self._isTransposed {
            row = self._columns
            col = self._rows
        }
        
        for i in 0..<col {
            for j in 0..<row {
                (self._dataColumn[i].memory)._data[j] = nil
            }
        }
        
        for i in 0..<row {
            self._dataRow[i].destroy()
            self._dataRow[i].dealloc(sizeof(Vector<T>.self))
            self._dataRow[i] = nil
        }
        
        for i in 0..<col {
            self._dataColumn[i].destroy()
            self._dataColumn[i].dealloc(sizeof(Vector<T>.self))
        }
    }
    
    
    // Returns the number of rows in the matrix
    public var rows: Int {
        get {
            return self._rows
        }
    }
    
    // Returns the number of columns in the matrix
    public var columns: Int {
        get {
            return self._columns
        }
    }
    
    // Returns/sets the element value at the given row and column index
    public subscript(row: Int, column: Int) -> T {
        get {
            assert(row >= 0 && row < self._rows, "Matrix row Index should be 0~\(self._rows - 1) when get element from matrix")
            assert(column >= 0 && column < self._columns, "column Index should be 0~\(self._columns - 1)")
            return self.dataRow[row].memory[column]
        }
        set {
            assert(row >= 0 && row < self._rows, "row Index should be 0~\(self._rows - 1)")
            assert(column >= 0 && column < self._columns, "column Index should be 0~\(self._columns - 1) when set matrix element")
            return self.dataRow[row].memory[column] = newValue
        }
    }
    
    // Returns a matrix that is a transpose of the current matrix
    public var transpose: Matrix<T> {
        get {
            self._isTransposed = !self._isTransposed
            return self
        }
    }
    
    // Select row vector from matrix
    public func row(index: Int) -> Vector<T> {
        assert(index >= 0 && index < self._rows, "get column vector failure column Index should be 0~\(self._rows - 1)")
        return self.dataRow[index].memory
    }
    
    
    // Select column vector from matrix
    public func column(index: Int) -> Vector<T> {
        assert(index >= 0 && index < self._columns, "get column vector failure column Index should be 0~\(self._columns - 1)")
        return self.dataColumn[index].memory
    }
    
    
    // Returns a new object that is a copy of the current matrix
    public func copy() -> Matrix<T> {
        let newMatrix = Matrix(rows: self._rows, columns: self._columns)
        for i in 0..<self.rows {
            for j in 0..<self.columns {
                newMatrix[i,j] = self[i,j]
            }
        }
        return newMatrix
    }
    
    public var description: String {
        var str = ""
        for i in 0..<self.rows {
            str += (self.dataRow[i].memory).description
            if i != self.rows - 1 {
                str += "\n"
            }
        }
        return str
    }
    
    // Convert Matrix to Vector
    public var vectorview: Vector<T> {
        assert(self.rows == 1 || self.columns == 1, "only single row or column matrix can be converted into vector ")
        if self.rows == 1 && self.columns != 1 {
            return self.row(0)
        } else {
            return self.column(0)
        }
    }
    
    
}


// Matrix and Matrix operators
public func *<T:MatrixData>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
    assert(lhs.rows == rhs.columns && lhs.columns == rhs.rows, "two matrix size not allow *")
    let newMatrix = Matrix<T>(rows: lhs.rows, columns: rhs.columns)
    for i in 0..<lhs.rows {
        for j in 0..<rhs.columns {
            newMatrix[i, j] = lhs.row(i).dot(rhs.column(j))
        }
    }
    return newMatrix
}

public func +<T:MatrixData>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
    assert(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "two matrix size must match in plus")
    let newMatrix = Matrix<T>(rows: lhs.rows, columns: lhs.columns)
    for i in 0..<lhs.rows {
        for j in 0..<lhs.columns {
            newMatrix[i,j] = lhs[i,j] + rhs[i,j]
        }
    }
    return newMatrix
}

public func -<T:MatrixData>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
    assert(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "two matrix size must match in minus")
    let newMatrix = Matrix<T>(rows: lhs.rows, columns: lhs.columns)
    for i in 0..<lhs.rows {
        for j in 0..<lhs.columns {
            newMatrix[i,j] = lhs[i,j] - rhs[i,j]
        }
    }
    return newMatrix
}

// Matrix and scalar operators
public func +<T:MatrixData>(lhs: Matrix<T>, rhs:T) -> Matrix<T> {
    let newMatrix = Matrix<T>(rows: lhs.rows, columns: lhs.columns)
    for i in 0..<lhs.rows {
        for j in 0..<lhs.columns {
            newMatrix[i, j] = lhs[i, j] + rhs
        }
    }
    return newMatrix
}
public func -<T:MatrixData>(lhs: Matrix<T>, rhs: T) -> Matrix<T> {
    let newMatrix = Matrix<T>(rows: lhs.rows, columns: lhs.columns)
    for i in 0..<lhs.rows {
        for j in 0..<lhs.columns {
            newMatrix[i, j] = lhs[i, j] - rhs
        }
    }
    return newMatrix
}
public func *<T:MatrixData>(lhs: Matrix<T>, rhs: T) -> Matrix<T> {
    let newMatrix = Matrix<T>(rows: lhs.rows, columns: lhs.columns)
    for i in 0..<lhs.rows {
        for j in 0..<lhs.columns {
            newMatrix[i, j] = lhs[i, j] * rhs
        }
    }
    return newMatrix
    
}
public func /<T:MatrixData>(lhs: Matrix<T>, rhs: T) -> Matrix<T> {
    let str = rhs.description
    assert((str != "0.0" && str != "0"), "Matrix Devision scaler failure, Can not be devided by zero")
    
    let newMatrix = Matrix<T>(rows: lhs.rows, columns: lhs.columns)
    for i in 0..<lhs.rows {
        for j in 0..<lhs.columns {
            newMatrix[i, j] = lhs[i, j] / rhs
        }
    }
    return newMatrix
}