//
//  Array+Additions.swift
//
//  Created by Dmitry Frishbuter on 25/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import Foundation

extension Array {
    mutating func removeElementsAtIndexes(indexes: NSIndexSet) {
        indexes.sort(>).forEach {
            removeAtIndex($0)
        }
    }
    
    mutating func insertElements(elements: [Element], atIndexes indexes: NSIndexSet) {
        var index = indexes.firstIndex
        for element in elements {
            indexes.indexGreaterThanOrEqualToIndex(index)
            self.insert(element, atIndex: index)
            index = index.successor()
        }
    }
}
