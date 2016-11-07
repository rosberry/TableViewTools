//
//  RSBTableViewCellItemProtocol.swift
//
//  Created by Dmitry Frishbuter on 19/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

extension RSBTableViewCellItemProtocol {
    func didSelectIn(tableView: UITableView, atIndexPath indexPath: IndexPath) {
        itemDidSelectHandler?(tableView, indexPath)
    }
    
    func willDisplay(cell: UITableViewCell, forTableView tableView: UITableView, atIndexPath indexPath: IndexPath) {}
    func configure(cell: UITableViewCell) {}
}

public protocol RSBTableViewCellItemProtocol: AnyObject {
    var itemDidSelectHandler: ((UITableView, IndexPath) -> Void)? { get set }
    
    func heightFor(tableView: UITableView) -> CGFloat
    func cellFor(tableView: UITableView) -> UITableViewCell
    func didSelectIn(tableView: UITableView, atIndexPath indexPath: IndexPath)
    func willDisplay(cell: UITableViewCell, forTableView tableView: UITableView, atIndexPath indexPath: IndexPath)
    func configure(cell: UITableViewCell)
    static func registerCellFor(tableView : UITableView)
}
