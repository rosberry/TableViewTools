//
//  RSBTableViewSectionItemFake.swift
//  rsbtableviewmanager-swift
//
//  Created by Dmitry Frishbuter on 06/05/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit
@testable import RSBTableViewManager

class RSBTableViewSectionItemFake: RSBTableViewSectionItemProtocol {
    var cellItems : [RSBTableViewCellItemProtocol]?
    var headerTitle: String?
    var footerTitle: String?
    
    required init() {}
}
