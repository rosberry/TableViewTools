//
//  TableViewSectionItem.swift
//
//  Created by Dmitry Frishbuter on 19/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

open class TableViewSectionItem: TableViewSectionItemProtocol {
    
    public var cellItems : [TableViewCellItemProtocol]
    public var headerTitle: String?
    public var footerTitle: String?
    
    convenience init() {
        self.init(cellItems: [])
    }
    
    init(cellItems: [TableViewCellItemProtocol]) {
        self.cellItems = cellItems
    }
    
    public func titleForHeader(in tableView: UITableView) -> String? {
        return headerTitle!
    }
    
    public func heightForHeader(in tableView: UITableView) -> CGFloat {
        if headerTitle != nil {
            return 22.0
        }
        return 0.0
    }
    
    public func viewForHeader(in tableView: UITableView) -> UIView? {
        return nil
    }
    
    public func titleForFooter(in tableView: UITableView) -> String? {
        return footerTitle!
    }
    
    public func heightForFooter(in tableView: UITableView) -> CGFloat {
        if footerTitle != nil {
            return 22.0
        }
        return 0.0
    }
    
    public func viewForFooter(in tableView: UITableView) -> UIView? {
        return nil
    }
}
