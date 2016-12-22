//
//  TableViewCellItemEditActionsProtocol.swift
//  RSBTableViewManager
//
//  Created by Dmitry Frishbuter on 22/12/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit.UITableView

public protocol TableViewCellItemEditActionsProtocol {
    
    /// Asks the cellItem if the editing menu should be shown for a certain row.
    /// If the user tap-holds a certain row in the table view, this method (if implemented) is invoked first. Return false if the editing menu shouldn’t be shown—for example, the cell corresponding to the row contains content that shouldn’t be copied or pasted over.
    ///
    /// - Parameters:
    ///   - tableView: The `UITableView` object that is making this request.
    ///   - indexPath: An `IndexPath` object locating the row in its section.
    /// - Returns: true if the editing menu should be shown positioned near the row and pointing to it, otherwise false. The default value is false.
    func shouldShowMenu(in tableView: UITableView, forRowAt indexPath: IndexPath) -> Bool
    
    /// Asks the cell item if the editing menu should omit the Copy or Paste command for a given row.
    /// This method is invoked after shouldShowMenu(in tableView:, forRowAt indexPath:). It gives the developer the opportunity to exclude one of the commands—Copy or Paste—from the editing menu. For example, the user might have copied some cell content from one row but wants to paste into another row that doesn’t take the copied content. In a case like this, return false from this method.
    ///
    /// - Parameters:
    ///   - action: A selector type identifying the copy(_:) or paste(_:) method of the UIResponderStandardEditActions informal protocol.
    ///   - tableView: The `UITableView` object that is making this request.
    ///   - indexPath: An `IndexPath` object locating the row in its section.
    ///   - sender: The object that initially sent the copy: or paste: message. T
    /// - Returns: true if the command corresponding to action should appear in the editing menu, otherwise false. The default value is false.
    func canPerformAction(_ action: Selector, in tableView: UITableView, forRowAt indexPath: IndexPath, with sender: Any?) -> Bool
    
    /// Tells the cell item to perform a copy or paste operation on the content of a given row.
    ///
    /// - Parameters:
    ///   - action: A selector type identifying the copy(_:) or paste(_:) method of the UIResponderStandardEditActions informal protocol.
    ///   - tableView: The `UITableView` object that is making this request.
    ///   - indexPath: An `IndexPath` object locating the row in its section.
    ///   - sender: The object that initially sent the copy: or paste: message.
    func performAction(_ action: Selector, in tableView: UITableView, forRowAt indexPath: IndexPath, with sender: Any?)
}
