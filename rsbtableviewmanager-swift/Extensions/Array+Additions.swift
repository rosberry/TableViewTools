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
        indexes.enumerateIndexesUsingBlock { (index, stop) in
            self.insert(elements[index], atIndex: index)
        }
    }
}
