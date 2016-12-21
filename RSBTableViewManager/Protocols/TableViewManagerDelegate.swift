//
//  TableViewManagerDelegate.swift
//  RSBTableViewManager
//
//  Created by Dmitry Frishbuter on 21/12/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit.UITableView

protocol TableViewManagerDelegate: class {
    
    func tableView(_ tableView: UITableView,
                   targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                   toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]?
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
}

extension TableViewManagerDelegate {
    
    func tableView(_ tableView: UITableView,
                   targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                   toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {}
    func sectionIndexTitles(for tableView: UITableView) -> [String]? { return nil }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int { return 0 }
}
