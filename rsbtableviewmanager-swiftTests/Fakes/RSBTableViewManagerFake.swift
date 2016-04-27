//
//  RSBTableViewManagerFake.swift
//  rsbtableviewmanager-swift
//
//  Created by Damien on 26/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import Foundation
@testable import rsbtableviewmanager_swift

class RSBTableViewManagerFake: RSBTableViewManager {
    var registerSectionItem_wasCalled = false
    
    override func registerSectionItem(sectionItem : RSBTableViewSectionItemProtocol) {
        registerSectionItem_wasCalled = true
    }
}
