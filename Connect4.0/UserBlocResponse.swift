//
//  UserBlocResponse.swift
//  Connect4.0
//
//  Created by Pakgon on 5/24/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

struct ResultCategory {
    private var _resultCategory:BlocCategoryResponse?
    private var _resultBloc:Bloc?
    
    var resultCategory:BlocCategoryResponse {
        get {
            return _resultCategory!
        }
        set {
            _resultCategory = newValue
        }
    }
    
    var resultBloc:Bloc {
        get {
            return _resultBloc!
        }
        set {
            _resultBloc = newValue
        }
    }
}

struct BlocCategoryResponse {
    private var _id:Int?
    private var _bloc_category_name:String?
    private var _sort_order:Int?
    private var _created:String?
    private var _modified:String?
    private var _bloc_category_image_path:String?
    
    var id:Int {
        get{
            return _id!
        }
        set{
            _id = newValue
        }
    }
    var bloc_category_name:String {
        get{
            return _bloc_category_name!
        }
        set{
            _bloc_category_name = newValue
        }
    }
    var sort_order:Int {
        get{
            return _sort_order!
        }
        set{
            _sort_order = newValue
        }
    }
    var created:String {
        get{
            return _created!
        }
        set{
            _created = newValue
        }
    }
    var modified:String {
        get{
            return _modified!
        }
        set{
            _modified = newValue
        }
    }
    var bloc_category_image_path:String {
        get{
            return _bloc_category_image_path!
        }
        set{
            _bloc_category_image_path = newValue
        }
    }
}

struct Bloc {
    private var _id:Int?
    private var _bloc_name:String?
    private var _bloc_description:String?
    private var _bloc_owner_id:Int?
    private var _bloc_url:String?
    private var _bloc_icon_path:String?
    private var _bloc_image1_path:String?
    private var _bloc_image2_path:String?
    private var _bloc_image3_path:String?
    private var _bloc_category_id:Int?
    private var _created:String?
    private var _modified:String?
    
    var id:Int {
        get {
            return _id!
        }
        set {
            _id = newValue
        }
    }
    
    var bloc_name:String {
        get {
            return _bloc_name!
        }
        set {
            _bloc_name = newValue
        }
    }
    
    var bloc_description:String {
        get {
            return _bloc_description!
        }
        set {
            _bloc_description = newValue
        }
    }
    
    var bloc_owner_id:Int {
        get {
            return _bloc_owner_id!
        }
        set {
            _bloc_owner_id = newValue
        }
    }
    
    var bloc_url:String {
        get {
            return _bloc_url!
        }
        set {
            _bloc_url = newValue
        }
    }
    
    var bloc_icon_path:String {
        get {
            return _bloc_icon_path!
        }
        set {
            _bloc_icon_path = newValue
        }
    }
    
    var bloc_image1_path:String {
        get {
            return _bloc_image1_path!
        }
        set {
            _bloc_image1_path = newValue
        }
    }
    
    var bloc_image2_path:String {
        get {
            return _bloc_image2_path!
        }
        set {
            _bloc_image2_path = newValue
        }
    }
    
    var bloc_image3_path:String {
        get {
            return _bloc_image3_path!
        }
        set {
            _bloc_image3_path = newValue
        }
    }
    
    var bloc_category_id:Int {
        get {
            return _bloc_category_id!
        }
        set {
            _bloc_category_id = newValue
        }
    }
    
    var created:String {
        get {
            return _created!
        }
        set {
            _created = newValue
        }
    }
    
    var modified:String {
        get {
            return _modified!
        }
        set {
            _modified = newValue
        }
    }
}
