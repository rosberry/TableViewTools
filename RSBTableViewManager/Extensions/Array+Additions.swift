//
//  Array+Additions.swift
//
//  Created by Dmitry Frishbuter on 25/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import Foundation

extension Array {
    mutating func removeElementsAt(indexes: NSIndexSet) {
        indexes.sorted(by: >).forEach {
            remove(at: $0)
        }
    }
    
    mutating func insert(elements: [Element], at indexes: NSIndexSet) {
        var index = indexes.firstIndex
        for element in elements {
            indexes.indexGreaterThanOrEqual(to: index)
            self.insert(element, at: index)
            index = index + 1
        }
    }
}
