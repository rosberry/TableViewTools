//
//  TableViewCellItemDataSourcePrefetching.swift
//  RSBTableViewManager
//
//  Created by Dmitry Frishbuter on 21/12/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit.UITableView

public protocol TableViewCellItemDataSourcePrefetching {
    
    func prefetchData(for tableView: UITableView, at indexPath: IndexPath)
    func cancelPrefetchingData(for tableView: UITableView, at indexPath: IndexPath)
}
