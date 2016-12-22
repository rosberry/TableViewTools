//
//  TableViewManager+UITableViewDataSourcePrefetching.swift
//  RSBTableViewManager
//
//  Created by Artem Novichkov on 22/12/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit.UITableView

extension TableViewManager: UITableViewDataSourcePrefetching {
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        var cellItems = [TableViewCellItemProtocol]()
        for indexPath in indexPaths {
            if let cellItem = self[indexPath] {
                cellItems.append(cellItem)
            }
        }
        for (index, cellItem) in cellItems.enumerated() {
            cellItem.prefetchData(for: tableView, at: indexPaths[index])
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            self[indexPath]?.cancelPrefetchingData(for: tableView, at: indexPath)
        }
    }
}
