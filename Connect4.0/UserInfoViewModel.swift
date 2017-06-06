//
//  UserInfoViewModel.swift
//  Connect4.0
//
//  Created by Pakgon on 6/6/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

protocol UserInfoViewModelProtocol {
    var userInfomation: UserInfoResponse {get set}
}

class UserInfoViewModel: BaseViewModel, UserInfoViewModelProtocol {
    var userInfomation: UserInfoResponse = ModelCart.getInstance().getUserInfo
}
