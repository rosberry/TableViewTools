//
//  Array+Additions.swift
//
//  Created by Dmitry Frishbuter on 25/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func remove(at indexes: IndexSet) {
        indexes.sorted(by: >).forEach {
            remove(at: $0)
        }
    }
    
    mutating func insert(_ elements: [Element], at indexes: IndexSet) {
        var index = indexes.first!
        for element in elements {
            if let nextIndex = indexes.integerGreaterThanOrEqualTo(index) {
                insert(element, at: nextIndex)
                index = nextIndex
            }
        }
    }
    
    mutating func replace(_ newElements: [Element], at indexes: IndexSet) {
        for (index, element) in indexes.enumerated() {
            self[element] = newElements[index]
        }
    }
}
