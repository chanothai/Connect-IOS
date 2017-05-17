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
    
    func createCell() -> [CellData]{
        let arrTitles = ["หมายเลขบัตรประชาชน","ชื่อ","นามสกุล","ปี-เดือน-วัน", "หมายเลขโทรศัพท์","อีเมล์", "รหัสผ่าน", "ยืนยันรหัสผ่าน", "ยืนยัน"]
        
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
