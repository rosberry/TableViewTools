//
//  Array+Additions.swift
//
//  Created by Dmitry Frishbuter on 25/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import Foundation

extension Array {
    mutating func removeElements(at indexes: IndexSet) {
        indexes.sorted(by: >).forEach {
            remove(at: $0)
        }
    }
    
    mutating func insertElements(_ elements: [Element], at indexes: IndexSet) {
        var index = indexes.first!
        for element in elements {
            if let nextIndex = indexes.integerGreaterThanOrEqualTo(index) {
                insert(element, at: nextIndex)
                index = nextIndex
            }
        }
    }
}
