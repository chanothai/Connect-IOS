//
//  QuizResponse.swift
//  Connect4.0
//
//  Created by Pakgon on 7/3/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper

class QuizResponse: Mappable {
    var result: QuizResult?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["result"]
    }
}

class QuizResult: Mappable {
    var success: String?
    var data: DataQuiz?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        success <- map["Success"]
        data <- map["Data"]
    }
}

class DataQuiz: Mappable {
    var quiz: PersonalQuiz?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        quiz <- map["PersonalQuiz"]
    }
}

class PersonalQuiz: Mappable {
    var url: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        url <- map["url"]
    }
}
