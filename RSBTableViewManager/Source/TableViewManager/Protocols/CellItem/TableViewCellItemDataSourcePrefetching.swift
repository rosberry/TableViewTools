//
//  TableViewCellItemDataSourcePrefetching.swift
//  RSBTableViewManager
//
//  Created by Dmitry Frishbuter on 21/12/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit.UITableView

public protocol TableViewCellItemDataSourcePrefetching {
    
    /// Instructs cell item object to begin preparing data for the cell at the supplied index path.
    ///
    /// - Parameters:
    ///   - tableView: The table view issuing the prefetch request.
    ///   - indexPath: The index path that specify the location of the item for which the data is to be prefetched.
    func prefetchData(for tableView: UITableView, at indexPath: IndexPath)
    
    /// Cancels a previously triggered data prefetch request.
    /// The table view calls this method to cancel prefetch request as cell scroll out of view. Your implementation of this method is responsible for canceling the operations initiated by a previous call to prefetchData(for tableView:, at indexPath:). For further information about canceling an asynchronous data loading task, see Concurrency Programming Guide.
    ///
    /// - Parameters:
    ///   - tableView: The table view issuing the cancellation of the prefetch request.
    ///   - indexPath: The index path that specify the location of the item for which the data is no longer required.
    func cancelPrefetchingData(for tableView: UITableView, at indexPath: IndexPath)
}
