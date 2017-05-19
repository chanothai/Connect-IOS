//
//  BaseViewModel.swift
//  Connect4.0
//
//  Created by Pakgon on 5/19/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

public class BaseViewModel: NSObject {
    
    public weak var delegate: BaseViewModelDelegate?
    
    required public init(delegate: BaseViewModelDelegate) {
        self.delegate = delegate
    }
}
