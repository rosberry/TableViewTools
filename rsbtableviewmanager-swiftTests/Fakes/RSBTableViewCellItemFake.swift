//
//  RSBTableViewCellItemFake.swift
//  rsbtableviewmanager-swift
//
//  Created by Dmitry Frishbuter on 06/05/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit
@testable import rsbtableviewmanager_swift

class RSBTableViewCellItemFake: RSBTableViewCellItemProtocol {
    var itemDidSelectHandler: ((UITableView, NSIndexPath) -> Void)?
    
    func configureCell(cell: UITableViewCell) {
    }
    
    func heightForTableView(tableView: UITableView) -> CGFloat {
        return 0.0
    }
    
    func cellForTableView(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TestReuseIdentifier")
        return cell!
    }
    
    static func registerCellForTableView(tableView: UITableView) {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TestReuseIdentifier")
    }
    
    func didSelectInTableView(tableView: UITableView, atIndexPath indexPath: NSIndexPath) {
        itemDidSelectHandler?(tableView, indexPath)
    }
}
