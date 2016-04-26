//
//  RSBTableViewCellItemProtocol.swift
//
//  Created by Dmitry Frishbuter on 19/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

@objc protocol RSBTableViewCellItemProtocol {
    func heightForTableView(tableView: UITableView) -> CGFloat
    func cellForTableView(tableView: UITableView) -> UITableViewCell
    static func registerCellForTableView(tableView : UITableView)
    func didSelectInTableView(tableView: UITableView, atIndexPath indexPath: NSIndexPath)
    optional func willDisplayCell(cell: UITableViewCell, forTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath)
    optional func configureCell(cell: UITableViewCell)
}
