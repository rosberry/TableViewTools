//
//  RSBTableViewSectionItemProtocol.swift
//
//  Created by Dmitry Frishbuter on 19/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

@objc protocol RSBTableViewSectionItemProtocol {
    var cellItems : [RSBTableViewCellItemProtocol]?  { get set }
    
    optional func heightForHeaderInTableView(tableView: UITableView) -> CGFloat
    optional func viewForHeaderInTableView(tableView: UITableView) -> UIView?
    optional func heightForFooterInTableView(tableView: UITableView) -> CGFloat
    optional func viewForFooterInTableView(tableView: UITableView) -> UIView?
    optional func titleForHeaderInTableView(tableView: UITableView) -> String?
    optional func titleForFooterInTableView(tableView: UITableView) -> String?
}
