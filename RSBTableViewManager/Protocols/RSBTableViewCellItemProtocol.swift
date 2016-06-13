//
//  RSBTableViewCellItemProtocol.swift
//
//  Created by Dmitry Frishbuter on 19/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

extension RSBTableViewCellItemProtocol {
    func didSelectInTableView(tableView: UITableView, atIndexPath indexPath: NSIndexPath) {
        itemDidSelectHandler?(tableView, indexPath)
    }
    
    func willDisplayCell(cell: UITableViewCell, forTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) {}
    func configureCell(cell: UITableViewCell) {}
}

public protocol RSBTableViewCellItemProtocol: AnyObject {
    var itemDidSelectHandler: ((UITableView, NSIndexPath) -> Void)? { get set }
    
    func heightForTableView(tableView: UITableView) -> CGFloat
    func cellForTableView(tableView: UITableView) -> UITableViewCell
    func didSelectInTableView(tableView: UITableView, atIndexPath indexPath: NSIndexPath)
    func willDisplayCell(cell: UITableViewCell, forTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath)
    func configureCell(cell: UITableViewCell)
    static func registerCellForTableView(tableView : UITableView)
}
