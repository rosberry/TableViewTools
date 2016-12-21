//
//  TableViewManagerDataSourcePrefetching.swift
//  RSBTableViewManager
//
//  Created by Dmitry Frishbuter on 21/12/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit.UITableView

protocol TableViewManagerDataSourcePrefetching: class {
    
    func cellItemsForPrefetching(in tableView: UITableView, at indexPaths: [IndexPath]) -> [TableViewCellItemProtocol]
}

