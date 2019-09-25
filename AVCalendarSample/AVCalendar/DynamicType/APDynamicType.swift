//
//  DynamicType.swift
//  Anirudh Vyas
//
//  Created by Anirudh on 10/03/19.
//  Copyright © 2019 Anirudh Vyas. All rights reserved.
//

import Foundation

class Dynamic<T> {
    
    var value: T? {
        didSet {
            bind?(value)
        }
    }
    
    var bind: ((T?)->())?
    
    init(_ _value: T) {
        value = _value
    }
}
