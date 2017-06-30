//
//  UserBlocResponse.swift
//  Connect4.0
//
//  Created by Pakgon on 5/24/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper

class ResponseBloc: Mappable {
    var resultBloc: ResultBloc?
    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        resultBloc <- map["result"]
    }
}

class ResultBloc: Mappable {
    var success: String?
    var dataBloc: [ResultCategory]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        success <- map["Success"]
        dataBloc <- map["Data"]
    }
}

class ResultCategory: Mappable {
    var category: CategoryBloc?
    var bloc: [Bloc]?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        category <- map["Category"]
        bloc <- map["App"]
    }
}

class CategoryBloc: Mappable {
    var id: Int?
    var categoryNameTH: String?
    var categoryNameEN: String?
    var orderSequence: Int?
    var imagePath: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        categoryNameTH <- map["cat_name_th"]
        categoryNameEN <- map["cat_name_en"]
        orderSequence <- map["order_seq"]
        imagePath <- map["cat_img_path"]
    }
}

class Bloc: Mappable {
    var id: Int?
    var blocNameTH: String?
    var blocNameEN: String?
    var orderSequence: Int?
    var imagePath: String?
    var blocURL: String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        blocNameTH <- map["app_name_th"]
        blocNameEN <- map["app_name_en"]
        orderSequence <- map["order_seq"]
        imagePath <- map["app_img_path"]
        blocURL <- map["app_url_path"]
    }
}

