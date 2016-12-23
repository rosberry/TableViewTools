//
//  TableViewCellItemEditActionsProtocol.swift
//  RSBTableViewManager
//
//  Created by Dmitry Frishbuter on 22/12/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit.UITableView

public protocol TableViewCellItemEditActionsProtocol {
    
    // MARK: - Editing
    
    /// Asks the cell item to verify that the cell is editable.
    ///
    /// - Parameters:
    ///   - tableView: The `UITableView` object that removed the view.
    /// - Returns: true if the cell is editable; otherwise, false.
    func canEdit(in tableView: UITableView) -> Bool
    
    /// Asks the cell item if the cell can commit editing style.
    ///
    /// - Parameters:
    ///   - editingStyle: The cell editing style corresponding to a insertion or deletion requested for the cell. Possible editing styles are insert or delete.
    ///   - tableView: The `UITableView` object requesting this information.
    /// - Returns: true if the cell item can commit editing style; otherwise, false.
    func canCommitEditingStyle(_ editingStyle: UITableViewCellEditingStyle, in tableView: UITableView) -> Bool
    
    /// Asks the cell item for the actions to display in response to a swipe in the cell.
    ///
    /// - Parameters:
    ///   - tableView: The table view requesting this information.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: An array of `UITableViewRowAction` objects representing the actions for the cell. Each action you provide is used to create a button that the user can tap.
    func editActions(in tableView: UITableView, at indexPath: IndexPath) -> [UITableViewRowAction]?
    
    /// Asks the cell item for the editing style of a row at a particular location in a table view.
    /// This method allows the cell item to customize the editing style of the cell located at index path. If the cell item does not implement this method and the UITableViewCell object is editable (that is, it has its isEditing property set to true), the cell has the delete style set for it.
    ///
    /// - Parameters:
    ///   - tableView: The table view requesting this information.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: The editing style of the cell for the row identified by indexPath.
    func editingStyle(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCellEditingStyle
    
    /// Changes the default title of the delete-confirmation button.
    /// By default, the delete-confirmation button, which appears on the right side of the cell, has the title of “Delete”. The table view displays this button when the user attempts to delete a row, either by swiping the row or tapping the red minus icon in editing mode. You can implement this method to return an alternative title, which should be localized.
    ///
    /// - Parameters:
    ///   - tableView: The table view requesting this information.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: A localized string to used as the title of the delete-confirmation button.
    func titleForDeleteConfirmationButton(in tableView: UITableView, at indexPath: IndexPath) -> String?
    
    /// Asks the cell item whether the background of the specified row should be indented while the table view is in editing mode.
    /// If the cell item does not implement this method, the default is true. This method is unrelated to indentationLevel(in tableView:, at indexPath:).
    ///
    /// - Parameters:
    ///   - tableView: The table view requesting this information.
    ///   - indexPath: An index path locating the row in its section.
    /// - Returns: true if the background of the row should be indented, otherwise false.
    func shouldIndentWhileEditing(in tableView: UITableView, at indexPath: IndexPath) -> Bool
    
    /// Tells the cell item that the table view is about to go into editing mode.
    /// This method is called when the user swipes horizontally across a row; as a consequence, the table view sets its isEditing property to true (thereby entering editing mode) and displays a Delete button in the row identified by indexPath. In this "swipe to delete" mode the table view does not display any insertion, deletion, and reordering controls. This method gives the cell item an opportunity to adjust the application's user interface to editing mode.
    ///
    /// - Parameters:
    ///   - tableView: The table view requesting this information.
    ///   - indexPath: An index path locating a row in tableView.
    func willBeginEditing(in tableView: UITableView, at indexPath: IndexPath)
    
    /// Tells the delegate that the table view has left editing mode.
    ///
    /// - Parameters:
    /// - Parameters:
    ///   - tableView: The table view requesting this information.
    ///   - indexPath: An index path locating a row in tableView.
    func didEndEditing(in tableView: UITableView, at indexPath: IndexPath?)
    
    /// Tells the cell item that the cell was removed.
    ///
    /// - Parameters:
    ///   - tableView: The table view requesting this information.
    ///   - indexPath: An index path locating the cell in tableView.
    func didRemove(from tableView: UITableView, at indexPath: IndexPath)
    
    /// Tells the cell item that the cell successfully finished removing animation.
    ///
    /// - Parameters:
    ///   - tableView: The table view requesting this information.
    ///   - indexPath: An index path locating the cell in tableView.
    func didFinishRemovingAnimation(in tableView: UITableView, at indexPath: IndexPath)
    
    // MARK: - Copy/Paste
    
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

extension TableViewCellItemEditActionsProtocol {

    func canEdit(in tableView: UITableView) -> Bool { return false }
    func canCommitEditingStyle(_ editingStyle: UITableViewCellEditingStyle, in tableView: UITableView) -> Bool { return false }
    func editActions(in tableView: UITableView) -> [UITableViewRowAction]? { return nil }
    
    func editingStyle(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCellEditingStyle { return .delete }
    func titleForDeleteConfirmationButton(in tableView: UITableView, at indexPath: IndexPath) -> String? { return nil }
    func shouldIndentWhileEditing(in tableView: UITableView, at indexPath: IndexPath) -> Bool { return true }
    
    func willBeginEditing(in tableView: UITableView, at indexPath: IndexPath) {  }
    func didEndEditing(in tableView: UITableView, at indexPath: IndexPath?) {  }
    
    func didRemove(from tableView: UITableView, at indexPath: IndexPath) {}
    func didFinishRemovingAnimation(in tableView: UITableView, at indexPath: IndexPath) {}
    
    func shouldShowMenu(in tableView: UITableView, forRowAt indexPath: IndexPath) -> Bool { return false }
    func canPerformAction(_ action: Selector, in tableView: UITableView, forRowAt indexPath: IndexPath, with sender: Any?) -> Bool { return false }
    func performAction(_ action: Selector, in tableView: UITableView, forRowAt indexPath: IndexPath, with sender: Any?) {}
}
