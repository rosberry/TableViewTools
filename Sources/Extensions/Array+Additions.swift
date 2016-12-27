//
//  Array+Additions.swift
//  TableViewTools
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
        for (index, intElement) in indexes.enumerated() {
            insert(elements[index], at: intElement)
        }
    }
    
    mutating func replace(_ newElements: [Element], at indexes: IndexSet) {
        for (index, intElement) in indexes.enumerated() {
            self[intElement] = newElements[index]
        }
    }
}
