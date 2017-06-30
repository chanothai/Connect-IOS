//
//  CellData.swift
//  Connect4.0
//
//  Created by Pakgon on 5/5/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

struct CellData {
    var cell:Int!
    var text:String!
    
    public func createArrRegisterCell() -> [CellData]{
//        let arrTitles = ["หมายเลขบัตรประชาชน","ชื่อ","นามสกุล","ปี-เดือน-วัน", "หมายเลขโทรศัพท์","อีเมล์", "รหัสผ่าน", "ยืนยันรหัสผ่าน", "ยืนยัน"]
        let arrTitles = ["หมายเลขบัตรประชาชน","หมายเลขโทรศัพท์","อีเมล์", "รหัสผ่าน", "ยืนยันรหัสผ่าน", "ยืนยัน"]
        
        return calculateCell(arrTitles: arrTitles)
    }
    
    public func createArrLoginCell() -> [CellData] {
        let arrTitles = ["อีเมล์", "รหัสผ่าน", "เข้าสู่ระบบ", "ลืมรหัสผ่าน?"]
        
        return calculateCell(arrTitles: arrTitles)
    }
    
    public func createListForgot() -> [CellData] {
        let arrTitles = ["เลขบัตรประชาชน", "อีเมล์", "ตรวจสอบ"]
        return calculateCell(arrTitles: arrTitles)
    }
    
    public func createListNewPassword() -> [CellData] {
        let arrTextField = ["รหัสผ่านใหม่", "รหัสผ่าน", "บันทึก"]
        return calculateCell(arrTitles: arrTextField)
    }
    
    private func calculateCell(arrTitles:[String]) -> [CellData] {
        var arrCellData:[CellData] = [CellData]()
        
        var maxLows = 0
        repeat{
            var detail:CellData = CellData()
            detail.text = arrTitles[maxLows]
            detail.cell = maxLows
            
            arrCellData.append(detail)
            
            maxLows += 1
            
        } while maxLows < arrTitles.count
        
        return arrCellData
    }
}
