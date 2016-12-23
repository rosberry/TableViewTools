//
//  TableViewManagerDelegate.swift
//  RSBTableViewManager
//
//  Created by Dmitry Frishbuter on 21/12/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit.UITableView

public protocol TableViewManagerDelegate: class {
    
    /// Asks the delegate to return a new index path to retarget a proposed move of a row.
    ///
    /// - Parameters:
    ///   - tableView: The `UITableView` object that is requesting this information.
    ///   - sourceIndexPath: An `IndexPath` object identifying the original location of a row (in its section) that is being dragged.
    ///   - proposedDestinationIndexPath: An `IndexPath` object identifying the currently proposed destination of the row being dragged.
    /// - Returns: An `index-path` object locating the desired row destination for the move operation. Return proposedDestinationIndexPath if that location is suitable.
    func tableView(_ tableView: UITableView,
                   targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                   toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath
    
    /// Tells the delegate to move a row at a specific location in the table view to another location.
    ///
    /// - Parameters:
    ///   - tableView: The `UITableView` object requesting this action.
    ///   - sourceIndexPath: An `IndexPath` locating the row to be moved in tableView.
    ///   - destinationIndexPath: An index path locating the row in table view that is the destination of the move.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    
    /// Asks the delegate to return the titles for the sections for a table view.
    ///
    /// - Parameter tableView: The `UITableView` object requesting this information.
    /// - Returns: An array of strings that serve as the title of sections in the table view and appear in the index list on the right side of the table view. The table view must be in the plain style (UITableViewStylePlain). For example, for an alphabetized list, you could return an array containing strings “A” through “Z”.
    func sectionIndexTitles(for tableView: UITableView) -> [String]?
    
    /// Asks the delegate to return the index of the section having the given title and section title index.
    ///
    /// - Parameters:
    ///   - tableView: The `UITableView` object requesting this information.
    ///   - title: The title as displayed in the section index of table view.
    ///   - index: An index number identifying a section title in the array returned by sectionIndexTitles(for:).
    /// - Returns: An index number identifying a section.
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
