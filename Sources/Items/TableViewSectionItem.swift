//
//  TableViewSectionItem.swift
//  TableViewTools
//
//  Created by Dmitry Frishbuter on 19/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit.UITableView

open class TableViewSectionItem: TableViewSectionItemProtocol {
    
    public var cellItems : [TableViewCellItemProtocol]
    public var headerTitle: String?
    public var footerTitle: String?
    
    public convenience init() {
        self.init(cellItems: [])
    }
    
    public init(cellItems: [TableViewCellItemProtocol]) {
        self.cellItems = cellItems
    }
    
    open func titleForHeader(in tableView: UITableView) -> String? {
        return headerTitle!
    }
    
    open func heightForHeader(in tableView: UITableView) -> CGFloat {
        if headerTitle != nil {
            return 22.0
        }
        return 0.0
    }
    
    open func viewForHeader(in tableView: UITableView) -> UIView? {
        return nil
    }
    
    open func titleForFooter(in tableView: UITableView) -> String? {
        return footerTitle!
    }
    
    open func heightForFooter(in tableView: UITableView) -> CGFloat {
        if footerTitle != nil {
            return 22.0
        }
        return 0.0
    }
    
    open func viewForFooter(in tableView: UITableView) -> UIView? {
        return nil
    }
}
