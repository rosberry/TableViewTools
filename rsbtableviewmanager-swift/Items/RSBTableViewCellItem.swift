//
//  RSBTableViewCellItem.swift
//
//  Created by Dmitry Frishbuter on 25/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

@objc class RSBTableViewCellItem: NSObject, RSBTableViewCellItemProtocol {
    
    var itemDidSelectHandler: ((UITableView, NSIndexPath) -> Void)?

    func configureCell(cell: UITableViewCell) {
    }
    
    func heightForTableView(tableView: UITableView) -> CGFloat {
        NSException(name: NSStringFromClass(self.dynamicType) + "_exception", reason: "This method should be overriden by subclass", userInfo: nil).raise()
        return 0.0
    }
    
    func cellForTableView(tableView: UITableView) -> UITableViewCell {
        NSException(name: NSStringFromClass(self.dynamicType) + "_exception", reason: "This method should be overriden by subclass", userInfo: nil).raise()
        return UITableViewCell()
    }
    
    static func registerCellForTableView(tableView: UITableView) {
        NSException(name: NSStringFromClass(self) + "_exception", reason: "This method should be overriden by subclass", userInfo: nil).raise()
    }
    
    func didSelectInTableView(tableView: UITableView, atIndexPath indexPath: NSIndexPath) {
        itemDidSelectHandler?(tableView, indexPath)
    }
}
