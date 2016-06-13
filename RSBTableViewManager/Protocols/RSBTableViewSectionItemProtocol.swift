//
//  RSBTableViewSectionItemProtocol.swift
//
//  Created by Dmitry Frishbuter on 19/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

extension RSBTableViewSectionItemProtocol {

    init(cellItems: [RSBTableViewCellItemProtocol]) {
        self.init()
        self.cellItems = cellItems
    }
    
    func titleForHeaderInTableView(tableView: UITableView) -> String? {
        return headerTitle!
    }
    
    func heightForHeaderInTableView(tableView: UITableView) -> CGFloat {
        if headerTitle != nil {
            return 22.0
        }
        return 0.0
    }
    
    func viewForHeaderInTableView(tableView: UITableView) -> UIView? {
        return nil
    }
    
    func titleForFooterInTableView(tableView: UITableView) -> String? {
        return footerTitle!
    }
    
    func heightForFooterInTableView(tableView: UITableView) -> CGFloat {
        if footerTitle != nil {
            return 22.0
        }
        return 0.0
    }
    
    func viewForFooterInTableView(tableView: UITableView) -> UIView? {
        return nil
    }
}

public protocol RSBTableViewSectionItemProtocol: AnyObject {
    var cellItems : [RSBTableViewCellItemProtocol]?  { get set }
    var headerTitle: String? { get set }
    var footerTitle: String? { get set }
    
    init()
    
    func titleForHeaderInTableView(tableView: UITableView) -> String?
    func heightForHeaderInTableView(tableView: UITableView) -> CGFloat
    func viewForHeaderInTableView(tableView: UITableView) -> UIView?
    
    func titleForFooterInTableView(tableView: UITableView) -> String?
    func heightForFooterInTableView(tableView: UITableView) -> CGFloat
    func viewForFooterInTableView(tableView: UITableView) -> UIView?
}
