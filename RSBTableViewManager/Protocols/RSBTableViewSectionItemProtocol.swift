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
    
    func titleForHeaderIn(tableView: UITableView) -> String? {
        return headerTitle!
    }
    
    func heightForHeaderIn(tableView: UITableView) -> CGFloat {
        if headerTitle != nil {
            return 22.0
        }
        return 0.0
    }
    
    func viewForHeaderIn(tableView: UITableView) -> UIView? {
        return nil
    }
    
    func titleForFooterIn(tableView: UITableView) -> String? {
        return footerTitle!
    }
    
    func heightForFooterIn(tableView: UITableView) -> CGFloat {
        if footerTitle != nil {
            return 22.0
        }
        return 0.0
    }
    
    func viewForFooterIn(tableView: UITableView) -> UIView? {
        return nil
    }
}

public protocol RSBTableViewSectionItemProtocol: AnyObject {
    var cellItems : [RSBTableViewCellItemProtocol]?  { get set }
    var headerTitle: String? { get set }
    var footerTitle: String? { get set }
    
    init()
    
    func titleForHeaderIn(tableView: UITableView) -> String?
    func heightForHeaderIn(tableView: UITableView) -> CGFloat
    func viewForHeaderIn(tableView: UITableView) -> UIView?
    
    func titleForFooterIn(tableView: UITableView) -> String?
    func heightForFooterIn(tableView: UITableView) -> CGFloat
    func viewForFooterIn(tableView: UITableView) -> UIView?
}
