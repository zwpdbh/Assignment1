//
//  
//  MatrixAndVector
//
//  Created by Jialin Yang on 8/24/16.
//  Copyright © 2016 Otago. All rights reserved.
//

import Foundation



protocol MatrixDataTest:MatrixData{
    func cast(obj:Int,obj1:Int)->Self;
    func !=(_:Self, _:Self)->Bool
}

extension Int: MatrixDataTest { func cast(obj:Int,obj1:Int) ->Int{return Int(obj)} }
extension Double: MatrixDataTest { func cast(obj:Int,obj1:Int)->Double {return Double(obj) } }
extension Float: MatrixDataTest { func cast(obj:Int,obj1:Int)->Float {return Float(obj)} }
extension Fraction: MatrixDataTest { func cast(obj:Int,obj1:Int)->Fraction {return Fraction(num:obj,den:obj1) } }
extension Complex: MatrixDataTest { func cast(obj:Int,obj1:Int)->Complex {
    
    return Complex(real:Float(obj),imag:Float(obj1))} }





class TestMatricVector<T:MatrixDataTest> {
    
    private var data1 = [T]()
    private var data2 = [T]()
    private var data3 = [T]()
    private var data4 = [T]()
    private var row : Int
    private var col : Int
    private var seed :Int
    
    
    private var err_cnt_MXrowSG : Int
    private var err_cnt_MXcolSG : Int
    private var err_cnt_VsizeSG : Int
    
    private var err_cnt_MXUnitSG: Int
    private var err_cnt_VUnitSG : Int
    private var err_cnt_Vdot    : Int
    private var err_cnt_VFMROW  : Int
    private var err_cnt_VFMCOL  : Int
    private var err_cnt_Mtrans  : Int
    
    private var err_cnt_MCP     : Int
    private var err_cnt_VCP     : Int
    
    private var err_cnt_Mplus   : Int
    private var err_cnt_Mminu   : Int
    private var err_cnt_Mmulti  : Int
    private var err_cnt_Msplu   : Int
    private var err_cnt_Msmul   : Int
    private var err_cnt_Msdiv   : Int
    private var err_cnt_Msmin   : Int
    private var err_cnt_Vplus   : Int
    private var err_cnt_Vminu   : Int
    private var err_cnt_Vmulti  : Int
    private var err_cnt_Vsplu   : Int
    private var err_cnt_Vsmul   : Int
    private var err_cnt_Vsdiv   : Int
    private var err_cnt_Vsmin   : Int
    private let MAX_NUM  = 5
    
    
    init(row:Int,col:Int,seed:Int){
        err_cnt_MXrowSG  = 0
        err_cnt_MXcolSG  = 0
        err_cnt_VsizeSG  = 0
        err_cnt_MXUnitSG = 0
        err_cnt_VUnitSG  = 0
        err_cnt_Vdot     = 0
        err_cnt_VFMROW   = 0
        err_cnt_VFMCOL   = 0
        err_cnt_Mtrans   = 0
        
        err_cnt_MCP      = 0
        err_cnt_VCP      = 0
        
        
        err_cnt_Mplus   = 0
        err_cnt_Mminu   = 0
        err_cnt_Mmulti  = 0
        err_cnt_Msplu   = 0
        err_cnt_Msmul   = 0
        err_cnt_Msdiv   = 0
        err_cnt_Msmin   = 0
        err_cnt_Vplus   = 0
        err_cnt_Vminu   = 0
        err_cnt_Vmulti  = 0
        err_cnt_Vsplu   = 0
        err_cnt_Vsmul   = 0
        err_cnt_Vsdiv   = 0
        err_cnt_Vsmin   = 0
        
        
        self.row=row
        self.col=col
        self.seed=seed;
        
        for i in 0...self.row-1 {
            for j in 0...self.col-1{
                let k1=Int(arc4random_uniform(UInt32(seed)))+1
                let k2=Int(arc4random_uniform(UInt32(seed)))+1
                if( T.self != Complex.self ){
                    self.data1.append(T().cast(self.col*i+j+k1,obj1:k2))
                    self.data2.append(T().cast(self.row*self.col-self.col*i-j-k1,obj1:k2))
                    self.data3.append(T().cast(self.row*self.col,obj1:k2))
                    self.data4.append(T())
                }
                else {
                    self.data1.append(T().cast(self.col*i+j+k1,obj1:self.col*i+j+k2))
                    self.data2.append(T().cast(self.row*self.col-self.col*i-j-k1,obj1:self.row*self.col-self.col*i-j-k2))
                    self.data3.append(T().cast(self.row*self.col,obj1:self.row*self.col))
                    self.data4.append(T())
                }
                
                
                
            }
        }
        
        for _ in 0..<MAX_NUM{
            createthendestroy();
            simplemathMatrix()
            simplemathVector()
            testcopy()
            testdot()
            testtranspose()
            testMVconversion()
            testVfromM()
            integrated_test()
        }
        
        gen_report()
        
    }
    
    
    convenience init(){
        let seed = Int(arc4random_uniform(5))+1
        let row = Int(arc4random_uniform(5))+1
        let col = Int(arc4random_uniform(5))+1
        
        self.init(row:row,col:col,seed:seed)
        
    }
    
    
    deinit{}
    
    
    
    
    /*check the possible memory leakage
     allocate 1000 matrix and vector of different data type, check the memory usage
     */
    private func createthendestroy(){
        
        let m=Matrix<T>(rows:self.row,columns:self.col)
        let v=Vector<T>(size:self.row*self.col)
        
        if(m.rows != self.row){
            err_cnt_MXrowSG += 1
            print("failure to set or get matrix\(T.self)  row\n")}
        if(m.columns != self.col){
            err_cnt_MXcolSG += 1
            print("failure to set or get matrix\(T.self)  col\n") }
        if(v.size != self.row*self.col) {
            err_cnt_VsizeSG += 1
            print("failure to set or get Vector\(T.self)  size\n") }
        
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                m[i,j]=self.data1[i*self.col+j]
                v[i*self.col+j]=self.data1[i*self.col+j]
            }
        }
        
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                if( m[i,j] != self.data1[i*self.col+j]){
                    err_cnt_MXUnitSG += 1
                    print("failure to set or get element from matrix \(T.self)\n")
                }
                if( v[i*self.col+j] != self.data1[i*self.col+j]){
                    err_cnt_VUnitSG += 1
                    print("failure to set or get element from vector \(T.self)\n")
                    
                }
            }
        }
        
        
    }
    
    /*test vector dot*/
    private func testdot(){
        let m1=Vector<T>(size:self.row*self.col);
        let m2=Vector<T>(size:self.col*self.row);
        
        for i in 0...self.row*self.col-1{
            m1[i] = self.data2[i]
            m2[i] = T()
        }
        let m3 = m1.dot(m2)
        if(m3 != T() ){
            err_cnt_Vdot += 1
            print("fail in Vector \(T.self) dot operation\n")
        }
        
        
    }
    
    
    /*test matrix transpose*/
    private func testtranspose(){
        var eflag :Int = 0
        
        let m1=Matrix<T>(rows: self.row,columns: self.col);
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                m1[i,j] = self.data1[i*self.col+j]
            }
        }
        let m3=m1.copy()
        
        let m2 = m1.transpose
        
        if( m2 !== m1) { print(" fail to refer to the original Matrix\(T.self) in transpose test\n")}
        
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                if( m2[j,i] != m3[i,j] ){ eflag = 1  }
            }
        }
        
        
        if(eflag == 1 ){
            err_cnt_Mtrans += 1
            print(" fail to transpose\n")
        }
    }
    
    
    private func testVfromM(){
        
        var eflag1 : Int = 0
        var eflag2 : Int = 0
        
        let m1 = Matrix<T>(rows: self.row,columns: self.col)
        
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                m1[i,j] = self.data1[i*self.col+j]
            }
        }
        
        
        let Rindex = Int(arc4random_uniform(UInt32(self.row-1)))
        let Cindex = Int(arc4random_uniform(UInt32(self.col-1)))
        let v1 :Vector<T> = m1.row(Rindex)
        let v2 :Vector<T> = m1.column(Cindex)
        
        for i in 0...self.col-1{
            if ( v1[i] != m1[Rindex,i] ) {
                eflag1 = 1
                
            }
        }
        for i in 0...self.row-1{
            if ( v2[i] != m1[i, Cindex] ) {
                eflag2 = 1
                
            }
            
        }
        if(eflag1 == 1){
            err_cnt_VFMROW += 1
            print("error in  select row from matrix")
            
        }
        if(eflag2 == 1){
            err_cnt_VFMCOL += 1
            print("error in  select column from matrix")
        }
        
        
    }
    /*   */
    private func testMVconversion(){
        var m1 : Matrix<T>
        var m2 : Matrix<T>
        let v1 = Vector<T>(size:self.row)
        
        m1 = Matrix<T>(rows: self.row,columns: 1)
        m2 = Matrix<T>(rows: 1,columns: self.col)
        for i in 0...self.row-1{
            m1[i,0] = self.data1[i*self.col]
        }
        for i in 0...self.col-1{
            m2[0,i] = self.data1[i]
        }
        
        
        
        let mv1 : Vector<T> = m1.vectorview
        let mv2 : Vector<T> = m2.vectorview
        
        
        if ( mv1.size != m1.rows ) {
            for i in 0...self.row-1{
                if(mv1[i] != m1[i,0]){
                    print("error in data copy when convert from m\(T.self) to v\(T.self)")
                }
            }
            
            print("error in convert from single column matrix\(T.self) to vector\(T.self)")
            
        }
        if ( mv2.size != m2.columns  ) {
            
            for i in 0...self.col-1{
                if(mv2[i] != m2[0,i]){
                    print("error in data copy when convert from m\(T.self) to v\(T.self)")
                }
            }
            
            print("error in convert from single row matrix\(T.self) to vector\(T.self)")
        }
        
        let vm1: Matrix<T>  = v1.matrixview
        for i in 0...v1.size-1{
            if(vm1[0,i] != v1[i]){
                print("error in convert from vector\(T.self) to matrix\(T.self)")
            }
            
        }
        
        
    }
    
    private func testMVconversionFailure1(){
        let m1 = Matrix<T>(rows: self.row,columns: self.col)
        var _ : Vector<T> = m1.vectorview
        
    }
    
    
    /* Check copy function in the matrix&vector
     
     */
    private func testcopy(){
        
        var eflag1 : Int = 0
        var eflag2 : Int = 0
        
        let m1=Matrix<T>(rows: self.row,columns: self.col);
        let v1=Vector<T>(size:self.row*self.col);
        
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                m1[i,j]=self.data1[i*self.col+j]
                v1[i*self.col+j]=self.data1[i*self.col+j]
            }
        }
        
        let m2=m1
        let m3=m1.copy()
        let v2=v1
        let v3=v1.copy()
        if(m2 !== m1){ print("fail to refer to Matrix\(T.self)\n")}
        if(v2 !== v1){ print("fail to refer to Vector\(T.self)\n")}
        if(m3 === m1){ print("fail to copy Matrix\(T.self) this is a reference\n")}
        if(v3 === v1){ print("fail to copy Vector\(T.self) this is a reference\n")}
        
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                
                var tmp : T
                tmp = v1[i*self.col+j]
                if(v3[i*self.col+j] != tmp){
                    eflag1 = 1
                    print("fail to copy Vector\(T.self) element:\(i*self.col+j)\n")}
                tmp = m1[i,j]
                if(m3[i,j] != tmp ){
                    eflag2 = 1
                    print("fail to copy Matrix\(T.self) element: M[ \(i) , \(j) ]\n")
                }
            }
        }
        
        if( eflag1 == 1){
            err_cnt_VCP += 1
        }
        
        if( eflag2 == 2){
            err_cnt_MCP += 1
        }
        
        
    }
    
    
    
    /* check the border of matrix and vector
     in case that anyone could gain illegal access to undefined data in matrix and vector(try..catch..)
     flag =1 check matrix negative row and col
     flag =2 check matrix positive row and col, exceed positive border
     flag =3 check vector positive row and col m exceed positive border
     flag =4 check vector negative row and col
     caution:program will crash when error occur
     */
    internal func checkborder_MRH(flag:Int){
        
        /*matrix border test*/
        var row_t:Int = -1-Int(arc4random_uniform(100))
        var col_t:Int = -1-Int(arc4random_uniform(100))
        
        let m1=Matrix<T>(rows: self.row,columns: self.col);
        if(flag==1){
            print("test illegal access to matrix element row:\(row_t) column:\(col_t)\n")
            m1[row_t,col_t]=T();
        }
        
        row_t = Int(arc4random_uniform(10))+row
        col_t = Int(arc4random_uniform(10))+col
        if(flag==2){
            print("test illegal access to matrix row:\(row_t) column:\(col_t)\n")
            m1[row_t,col_t]=T();
        }
        /*Vector border test*/
        let v1=Vector<T>(size: row);
        if(flag==3){
            print("test illegal access to vector index:\(row_t)\n")
            v1[row_t]=T();
        }
        
        row_t = -1-Int(arc4random_uniform(10))
        if(flag==4){
            print("test illegal access to vector index:\(row_t)\n")
            v1[row_t]=T();
        }
    }
    /*
     test set and get function in vector and matrix
     
     
     */
    
    
    
    /*
     check basic operation of vector and matrix +,-,*,dot,
     Check both input are the same type or different types
     */
    
    private func simplemathMatrix(){
        
        var mflag1 : Int = 0
        var mflag2 : Int = 0
        var mflag3 : Int = 0
        var mflag4 : Int = 0
        var mflag5 : Int = 0
        var mflag6 : Int = 0
        var mflag7 : Int = 0
        
        
        let m1=Matrix<T>(rows: self.row,columns: self.col);
        let m2=Matrix<T>(rows: self.row,columns: self.col);
        let m3=Matrix<T>(rows: self.col,columns: self.row);
        
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                //var k=T()+T(arc4random_uniform(100));
                m1[i,j] = self.data1[i*self.col+j]
                m2[i,j] = self.data2[i*self.col+j]
                m3[j,i] = T()
            }
        }
        //test plus
        let m4=m1+m2
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                if (m4[i,j] != self.data3[i*self.col+j]   ){
                    mflag1 = 1
                    
                }
                
                
                
            }
        }
        if(mflag1 == 1){
            err_cnt_Mplus += 1
            print("error in simple Matrix\(T.self)  add matrix operation\n");
            
        }
        
        
        //test minus
        let m5=m4-m2
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                
                if ( m5[i,j] != m1[i,j] ) {
                    mflag2 = 1
                }
            }
        }
        
        if (mflag2 == 1) {
            err_cnt_Mminu += 1
            print("error in simple Matrix\(T.self)  minus Matrix operation")
        }
        
        //test multiply
        let m6=m1*m3
        for i in 0...self.row-1{
            for j in 0...self.row-1{
                
                if( m6[i,j] != T() ) {
                    mflag3 = 1
                }
            }
        }
        if( mflag3 == 1){
            err_cnt_Mmulti += 1
            print("error in simple  Matrix\(T.self) multiply Matrix operation")
            
        }
        
        //test scale
        let seed1 = Int(arc4random_uniform(UInt32(seed)))+Int(1)
        let seed2 = Int(arc4random_uniform(UInt32(seed)))+Int(1)
        let scale=T().cast(seed1, obj1: seed2)
        //scale plus
        let m9=m1+scale
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                
                if( m9[i,j] != (m1[i,j]+scale) ) {
                    mflag4 = 1
                }
            }
        }
        
        if( mflag4 == 1){
            err_cnt_Msplu += 1
            print("error in simple  Matrix\(T.self) plus scaler\n")
        }
        
        //scale minus
        let m10=m1-scale
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                if( m10[i,j] != (m1[i,j]-scale) ) {
                    mflag5 = 1
                }
            }
        }
        if(mflag5 == 1){
            err_cnt_Msmin += 1
            print("error in simple  Matrix\(T.self) minus scaler\n")
        }
        //scale multiply
        let m7=m1*scale
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                
                if( m7[i,j] != (m1[i,j]*scale) ) {
                    mflag6 = 1
                }
            }
        }
        
        if(mflag6 == 1){
            err_cnt_Msmul += 1
            print("error in simple  Matrix\(T.self) multiply scaler\n")
            
        }
        //scale devide
        let m8=m1/scale
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                
                if( m8[i,j] != (m1[i,j]/scale) ) {
                    mflag7 = 1
                    
                }
            }
        }
        
        if( mflag7 == 1){
            err_cnt_Msdiv += 1
            print("error in simple  Matrix\(T.self) devide scaler\n")
        }
        
    }
    
    
    
    
    private func simplemathVector(){
        
        var vflag1 : Int = 0
        var vflag2 : Int = 0
        //  var vflag3 : Int = 0
        var vflag4 : Int = 0
        var vflag5 : Int = 0
        var vflag6 : Int = 0
        var vflag7 : Int = 0
        
        
        let m1=Vector<T>(size:self.row*self.col);
        let m2=Vector<T>(size:self.row*self.col);
        let m3=Vector<T>(size:self.col*self.row);
        
        for i in 0...self.row*self.col-1{
            m1[i] = self.data1[i]
            m2[i] = self.data2[i]
            m3[i] = T()
        }
        //test plus
        let m4=m1+m2
        for i in 0...self.row*self.col-1{
            
            if (m4[i] != self.data3[i]   ){
                vflag1 = 1
                
            }
        }
        if( vflag1 == 1){
            err_cnt_Vplus += 1
            print("error in simple Vector\(T.self)  add vector operation\n")
        }
        
        //test minus
        let m5=m4-m2
        for i in 0...self.row*self.col-1{
            
            if ( m5[i] != m1[i] ) {
                vflag2 = 1
            }
        }
        
        if( vflag2 == 1){
            err_cnt_Vminu += 1
            print("error in simple Vector\(T.self)  minus vector operation\n")
        }
        
        
        //test multiply
        let m6=m1*m3
        if( m6 != T() ) {
            err_cnt_Vmulti += 1
            print("error in simple  Vector\(T.self) multiply vector operation")
        }
        
        
        
        //test scale
        let seed1 = Int(arc4random_uniform(UInt32(seed)))+Int(1)
        let seed2 = Int(arc4random_uniform(UInt32(seed)))+Int(1)
        let scale=T().cast(seed1, obj1: seed2)
        //scale plus
        let m9=m1+scale
        for i in 0...self.row*self.col-1{
            if( m9[i] != (m1[i]+scale) ) {
                vflag4 = 1
            }
        }
        
        if( vflag4 == 1){
            err_cnt_Vsplu += 1
            print("error in simple Vector\(T.self)  plus scaler\n")
        }
        
        
        //scale minus
        let m10=m1-scale
        for i in 0...self.row*self.col-1{
            if( m10[i] != (m1[i]-scale) ) {
                vflag5 = 1
                
            }
        }
        
        if( vflag5 == 1){
            err_cnt_Vsmin += 1
            print("error in simple  Vector\(T.self) minus scaler")
        }
        
        
        //scale multiply
        let m7=m1*scale
        for i in 0...self.row*self.col-1{
            if( m7[i] != (m1[i]*scale) ) {
                vflag6 = 1
                
            }
        }
        
        
        if( vflag6 == 1){
            err_cnt_Vsmul += 1
            print("error in simple  Vector\(T.self) multiply scaler")
        }
        
        
        //scale devide
        let m8=m1/scale
        for i in 0...self.col*self.row-1{
            if( m8[i] != (m1[i]/scale) ) {
                vflag7 = 1
            }
        }
        
        if( vflag7 == 1){
            err_cnt_Vminu += 1
            print("error in simple  Vector\(T.self) devide scaler")
        }
        
    }
    
    
    
    internal func testmemoryleak(){
        
        
        while (true){
            createthendestroy()
        }
        
    }
    
    private func integrated_test(){
        var eflag1 : Int = 0
        /*        var eflag2 : Int = 0
         var eflag3 : Int = 0
         var eflag4 : Int = 0
         var eflag5 : Int = 0
         */
        
        var m1 = Matrix<T>(rows: self.row,columns: self.col);
        let m2 = Matrix<T>(rows: self.row,columns: self.col);
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                m1[i,j] = self.data1[i*self.col+j]
                m2[i,j] = self.data2[i*self.col+j]
            }
        }
        
        let s1 = T().cast(1,obj1:1)
        
        m1 = m1 + s1
        m1.transpose
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                if( m1[j,i] != self.data1[i*self.col+j]+s1){ eflag1 = 1  }
            }
        }
        
        m1 = m1 - s1
        m1.transpose
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                if( m1[i,j] != self.data1[i*self.col+j]){ eflag1 = 1  }
            }
        }
        
        m1.transpose
        m1 = m1 * s1
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                if( m1[j,i] != self.data1[i*self.col+j]*s1){ eflag1 = 1  }
            }
        }
        
        m1 = m1 / s1
        m1.transpose
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                if( m1[i,j] != self.data1[i*self.col+j]){ eflag1 = 1  }
            }
        }
        
        if(eflag1 == 1 ){
            err_cnt_Mtrans += 1
            print(" fail to transpose with scaler operation\n")
        }
        
        
        m1.transpose
        let m3 = m1.copy()
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                if m3[j,i] != m1[j,i]{
                    print("error in copy transposed matrix")
                }
            }
        }
        
        
        m1 = m1 + (m2.transpose)
        m1.transpose
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                if m1[i,j] != self.data3[i*self.col+j] {
                    print("error in plus operation on transposed matrix")
                }
            }
        }
        
        m2.transpose
        m1 = (m1 - m2).transpose
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                if m1[j,i] != self.data1[i*self.col+j] {
                    print("error in minus operation on transposed matrix")
                }
            }
        }
        
        let v1 = m1.row(0)
        m1.transpose
        let v2 = m1.column(0)
        
        for i in 0...self.row-1{
            if v1[i] != m1[i,0] || v1[i] != v2[i] {print("error in get row vector of a transposed matrix")}
            
        }
        
        let mv1 = v1.matrixview
        let mv2 = mv1.vectorview
        
        mv1[0,0] = T().cast(2, obj1: 2)
        mv2[0]   = T().cast(8,obj1:3)
        for i in 0...v1.size-1{
            if mv1[0,i] != m1[i,0] || mv1[0,i] != v1[i] || mv2[i] != m1[i,0] || v2[i] != v1[i]
            {print("error in convert from vector to matrix  in integrated test")}
            
        }
        
        
        m1[0,0]=self.data1[0]
        for i in 0...self.row-1{
            for j in 0...self.col-1{
                if  m1[i,j] != self.data1[i*self.col+j]{
                    print("error on transposed matrix and vector matrix view operation, the reference doesnot work")
                }
            }
        }
        
        
        let v: Vector<Float> = Vector<Float>(size: 3)
        let _: Matrix<Float> = v.matrixview
        let M: Matrix<Float> = Matrix<Float>(rows:2, columns: 3)
        let arow: Vector<Float> = M.row(1)
        let acol: Vector<Float> = M.column(0)
        let _: Matrix<Float> = arow.matrixview
        let _: Matrix<Float> = acol.matrixview
        
        
        
        
        
    }
    
    
    private func gen_report(){
        print("There are \(self.MAX_NUM) round test on Matrix&Vector \(T.self) running.")
        
        
        if(err_cnt_MXrowSG != 0){
            print("The error rate  in matrix\(T.self)  set&get row is \(err_cnt_MXrowSG) out of \(self.MAX_NUM)")
        }
        else {
            print("Test matrix\(T.self) set&get row pass")
        }
        if(err_cnt_MXcolSG != 0){
            print("The error rate  in matrix\(T.self)  set&get column is \(err_cnt_MXcolSG) out of \(self.MAX_NUM)")
        }
        else {
            print("test matrix\(T.self)  set&get column pass")
            
        }
        if(err_cnt_VsizeSG != 0){
            print("The error rate  in vector\(T.self)  setget size is \(err_cnt_VsizeSG) out of \(self.MAX_NUM)")
        }
        else {
            print("test vector\(T.self)  set&get size pass")
            
        }
        if(err_cnt_MXUnitSG != 0){
            print("The error rate  in set&get matrix\(T.self)  element is \(err_cnt_MXUnitSG) out of \(self.MAX_NUM * self.row * self.col)")
        }
        else {
            print("test matrix\(T.self)  set&get element pass")
        }
        if(err_cnt_VUnitSG != 0){
            print("The error rate  in set&get vector\(T.self)  element is \(err_cnt_VUnitSG) out of \(self.MAX_NUM * self.row * self.col)")
        }
        else {
            print("test vector\(T.self)  set&get element pass")
        }
        if(err_cnt_Vdot != 0){
            print("The error rate  in vector\(T.self)  dot operation is \(err_cnt_Vdot) out of \(self.MAX_NUM)")
        }
        else {
            print("test vector\(T.self)  dot operation pass")
        }
        if(err_cnt_VFMROW != 0){
            print("The error rate in getrow vector\(T.self)  from matrix\(T.self)  is \(err_cnt_VFMROW) out of \(self.MAX_NUM)")
        }
        else {
            print("test get row vector \(T.self) from matrix\(T.self) pass")
        }
        if(err_cnt_VFMCOL != 0){
            print("The error rate in get column vector\(T.self)  from  matrix\(T.self)   is \(err_cnt_VFMCOL) out of \(self.MAX_NUM)")
        }
        else{
            print("test get column vector \(T.self) from matrix\(T.self) pass")
        }
        if(err_cnt_Mtrans != 0){
            print("The error rate in matrix\(T.self)  transpose is \(err_cnt_Mtrans) out of \(self.MAX_NUM)")
        }
        else {
            print("Test matrix\(T.self) tranpose pass")
        }
        
        
        if(err_cnt_MCP != 0){
            print("The error rate in matrix\(T.self)  copy is \(err_cnt_MCP) out of \(self.MAX_NUM)")
        }
        else {
            print("test matrix\(T.self) copy pass")
        }
        
        
        if(err_cnt_VCP != 0){
            print("The error rate in vector\(T.self)  copy is \(err_cnt_VCP) out of \(self.MAX_NUM)")
        }
        else {
            print("test vector\(T.self) copy pass")
            
        }
        
        if(err_cnt_Mplus != 0){
            print("The error rate in matrix\(T.self)  addition is \(err_cnt_Mplus) out of \(self.MAX_NUM)")
        }
        else {
            print("test matrix\(T.self) plus operation pass")
        }
        if(err_cnt_Mminu != 0){
            print("The error rate in matrix\(T.self)  minus operation is \(err_cnt_Mminu) out of \(self.MAX_NUM)")
        }
        else {
            print("test matrix\(T.self) minus operation pass")
        }
        if(err_cnt_Mmulti != 0){
            print("The error rate in matrix\(T.self)  multiply is \(err_cnt_Mmulti) out of \(self.MAX_NUM)")
        }
        else {
            print("test matrix\(T.self) multiply operation pass")
        }
        if(err_cnt_Msplu != 0){
            print("The error rate in matrix\(T.self)  plus scaler is \(err_cnt_Msplu) out of \(self.MAX_NUM)")
        }
        else {
            print("test matrix\(T.self) plus scaler pass")
        }
        
        if(err_cnt_Msmul != 0){
            print("The error rate in matrix\(T.self)  multiply scaler is \(err_cnt_Msmul) out of \(self.MAX_NUM)")
        }
        else {
            print("test matrix\(T.self) multiply scaler pass")
        }
        
        if(err_cnt_Msdiv != 0){
            print("The error rate in matrix\(T.self)  division scaler is \(err_cnt_Msdiv) out of \(self.MAX_NUM)")
        }
        else {
            print("test matrix\(T.self) division scalelr pass")
        }
        if(err_cnt_Msmin != 0){
            print("The error rate in matrix\(T.self)  minus scaler row is \(err_cnt_Msmin) out of \(self.MAX_NUM)")
        }
        else {
            print("test matrix\(T.self) minus scaler pass")
        }
        
        if(err_cnt_Vplus != 0){
            print("The error rate in vector\(T.self)  plus operation is \(err_cnt_Vplus) out of \(self.MAX_NUM)")
        }
        else {
            print("test vector\(T.self) plus operation pass")
        }
        
        if(err_cnt_Vminu != 0){
            print("The error rate in vector\(T.self)  minus opeartion is \(err_cnt_Vminu) out of \(self.MAX_NUM)")
        }
        else {
            print("test vector\(T.self) minus operation pass ")
        }
        if(err_cnt_Vmulti != 0){
            print("The error rate in vector\(T.self)  multiply operation is \(err_cnt_Vmulti) out of \(self.MAX_NUM)")
        }
        else {
            print("test vector\(T.self) multiply operation pass")
        }
        if(err_cnt_Vsplu != 0){
            print("The error rate in vector\(T.self)  plus scaler is \(err_cnt_Vsplu) out of \(self.MAX_NUM)")
        }
        else {
            print("test vector\(T.self) plus scaler")
        }
        if(err_cnt_Vsmul != 0){
            print("The error rate in vector\(T.self)  multiply scaler  is \(err_cnt_Vsmul) out of \(self.MAX_NUM)")
        }
        else {
            print("test vector\(T.self) multiply scaler pass")
        }
        if(err_cnt_Vsdiv != 0){
            print("The error rate in vector \(T.self)  division scaler is \(err_cnt_Vsdiv) out of \(self.MAX_NUM)")
        }
        else {
            print("test vector\(T.self) division scaler pass")
        }
        if(err_cnt_Vsmin != 0){
            print("The error rate in vector \(T.self) minus scaler is \(err_cnt_Vsmin) out of \(self.MAX_NUM)")
        }
        else {
            print("test vector\(T.self) minus scaler pass")
        }
        
        if (err_cnt_MXrowSG  +
            err_cnt_MXcolSG  +
            err_cnt_VsizeSG  +
            err_cnt_MXUnitSG +
            err_cnt_VUnitSG  +
            err_cnt_Vdot     +
            err_cnt_VFMROW   +
            err_cnt_VFMCOL   +
            err_cnt_Mtrans   +
            err_cnt_MCP      +
            err_cnt_VCP      +
            err_cnt_Mplus   +
            err_cnt_Mminu   +
            err_cnt_Mmulti  +
            err_cnt_Msplu   +
            err_cnt_Msmul   +
            err_cnt_Msdiv   +
            err_cnt_Msmin   +
            err_cnt_Vplus   +
            err_cnt_Vminu   +
            err_cnt_Vmulti  +
            err_cnt_Vsplu   +
            err_cnt_Vsmul   +
            err_cnt_Vsdiv   +
            err_cnt_Vsmin   ==  0) {
            print("All the test cases on Matrix&Vector\(T.self) passed")
            print("\n")
        }
        
        
    }
}

