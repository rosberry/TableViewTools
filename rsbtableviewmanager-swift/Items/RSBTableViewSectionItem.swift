//
//  RSBTableViewSectionItem.swift
//
//  Created by Dmitry Frishbuter on 25/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

@objc class RSBTableViewSectionItem: NSObject, RSBTableViewSectionItemProtocol {
    
    var cellItems: [RSBTableViewCellItemProtocol]?
    var headerTitle: String?
    var footerTitle: String?
    
    init(cellItems: [RSBTableViewCellItemProtocol]) {
        self.cellItems = cellItems
    }
    
    func titleForHeaderInTableView(tableView: UITableView) -> String? {
        return headerTitle
    }
    
    func heightForHeaderInTableView(tableView: UITableView) -> CGFloat {
        if headerTitle != nil {
            return 22.0
        }
        return 0.0
    }
    
    func titleForFooterInTableView(tableView: UITableView) -> String? {
        return footerTitle
    }
    
    func heightForFooterInTableView(tableView: UITableView) -> CGFloat {
        if footerTitle != nil {
            return 22.0
        }
        return 0.0
    }
}
