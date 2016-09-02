import Foundation


var test0 = TestMatricVector<Int>()

var test1 = TestMatricVector<Double>()
var test2 = TestMatricVector<Float>()
var test3 = TestMatricVector<Complex>()
var test4 = TestMatricVector<Fraction>()

var test5 = TestMatricVector<Int>(row:10,col:10,seed:100)
var test6 = TestMatricVector<Double>(row:10,col:10,seed:100)
var test7 = TestMatricVector<Float>(row:10,col:10,seed:100)
var test8 = TestMatricVector<Complex>(row:10,col:10,seed:100)
var test9 = TestMatricVector<Fraction>(row:10,col:10,seed:100)


/**
 Public interface(test manually):
 1. testmemoryleakage:
 This is an internal function, it is a while loop that never stop. 
 Call the methods in main and open the activity monitor. If the memory used by matrixvector process never rockets up, it means there is no memory leakage.
 
 2. checkborder_MRH(flag:Int):
 Check the border of matrix and vector. It contains one flag.
 Flag:1, test negative number of row and column when it visits matrix element
 Flag:2, test positive number, which is larger than the maximum row and column number of matrix, when it visits matrix element
 Flag:3, test positive number, which is larger than the maximum size of vector, when it visit matrix element
 Flag:4, test negative number when it visits vector element.

 test9.testmemoryleak()
 test9.checkborder_MRH(<#T##flag: Int##Int#>)
 */