//
//  TableViewCellItemProtocol.swift
//  RSBTableViewManager
//
//  Created by Dmitry Frishbuter on 19/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

public typealias SelectionHandler = ((UITableView, IndexPath) -> Void)
public typealias SelectionResolver = ((UITableView, IndexPath) -> IndexPath?)
public typealias HighlightingHandler = ((UITableView, IndexPath) -> Void)
public typealias HighlightingResolver = ((UITableView, IndexPath) -> Bool)

public protocol TableViewCellItemProtocol: AnyObject {
    
    /// The closure that handles `tableView(_:shouldHighlightRowAt:)` method calling.
    var itemShouldHighlightHandler: HighlightingResolver? { get set }
    /// The closure that handles `tableView(_:didHighlightRowAt:)` method calling.
    var itemDidHighlightHandler:    HighlightingHandler? { get set }
    /// The closure that handles `tableView(_:didUnhighlightRowAt:)` method calling.
    var itemDidUnhighlightHandler:  HighlightingHandler? { get set }
    
    /// The closure that handles `tableView(_:didSelectRowAt:)` method calling.
    var itemDidSelectHandler:   SelectionHandler? { get set }
    /// The closure that handles `tableView(_:didDeselectRowAt:)` method calling.
    var itemDidDeselectHandler: SelectionHandler? { get set }
    
    /// The closure that handles `tableView(_:willSelectRowAt:)` method calling.
    var itemWillSelectHandler:   SelectionResolver? { get set }
    /// The closure that handles `tableView(_:willDeselectRowAt:)` method calling.
    var itemWillDeselectHandler: SelectionResolver? { get set }
    
    var reuseType: ReuseType { get }
    
    /// Asks the cell item for the height to use for a related cell. The method allows the cell item to specify cells with varying heights. If this method is implemented, the value it returns overrides the value specified for the rowHeight property of UITableView for the given row.
    ///
    /// - Parameter tableView: The table-view object requesting this information.
    /// - Returns: A nonnegative floating-point value that specifies the height (in points) that cell should be.
    func height(in tableView: UITableView) -> CGFloat
    
    /// Configures dequeued cell
    ///
    /// - Parameters:
    ///   - cell: An object inheriting from UITableViewCell that the table view can use for the specified row.
    ///   - tableView: The table-view object requesting this information.
    ///   - indexPath: An index path locating a row in tableView.
    func configureCell(_ cell: UITableViewCell, in tableView: UITableView, at indexPath: IndexPath)
    
    /// Asks the cell item if the cell should be highlighted.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: true if the row should be highlighted or false if it should not
    func shouldHighlightCell(in tableView: UITableView, at indexPath: IndexPath) -> Bool
    
    /// Tells the cell item that the cell was highlighted.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - indexPath: An index path locating a row in tableView.
    func didHighlightCell(in tableView: UITableView, at indexPath: IndexPath)
    
    /// Tells the cell item that the cell was unhighlighted.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - indexPath: An index path locating a row in tableView.
    func didUnhighlightCell(in tableView: UITableView, at indexPath: IndexPath)
    
    /// Tells the cell item that the cell is about to be selected.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: An index-path object that confirms or alters the selected cell. Return an NSIndexPath object other than indexPath if you want another cell to be selected. Return nil if you don't want the row selected.
    func willSelectCell(in tableView: UITableView, at indexPath: IndexPath) -> IndexPath?
    
    /// Tells the cell item that the cell is about to be unselected.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: An index-path object that confirms or alters the unselected cell. Return an NSIndexPath object other than indexPath if you want another cell to be unselected. Return nil if you don't want the row unselected.
    func willDeselectCell(in tableView: UITableView, at indexPath: IndexPath) -> IndexPath?
    
    /// Tells the cell item that the specified cell is now selected.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - indexPath: An index path locating a row in tableView.
    func didSelectCell(in tableView: UITableView, at indexPath: IndexPath)
    
    /// Tells the cell item that the specified cell is now unselected.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - indexPath: An index path locating a row in tableView.
    func didDeselectCell(in tableView: UITableView, at indexPath: IndexPath)
    
    /// Tells the cell item that the table view is about to draw a cell for a particular row.
    ///
    /// - Parameters:
    ///   - cell: A table-view cell object that tableView is going to use when drawing the row.
    ///   - tableView: The table-view object requesting this information.
    ///   - indexPath: An index path locating a row in tableView.
    func willDisplayCell(_ cell: UITableViewCell, for tableView: UITableView, at indexPath: IndexPath)
    
    /// Tells the cell item that the cell was removed from the table. Use this method to detect when a cell is removed from a table view, as opposed to monitoring the view itself to see when it appears or disappears.
    ///
    /// - Parameters:
    ///   - cell: The cell that was removed.
    ///   - tableView: The table-view object that removed the view.
    ///   - indexPath: The index path of the cell.
    func didEndDisplayingCell(_ cell: UITableViewCell, for tableView: UITableView, at indexPath: IndexPath)
    
    /// Asks the cell item to verify that the cell is editable.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object that removed the view.
    /// - Returns: true if the cell is editable; otherwise, false.
    func canEdit(in tableView: UITableView) -> Bool
    
    /// Asks the cell item if the cell can commit editing style.
    ///
    /// - Parameters:
    ///   - editingStyle: The cell editing style corresponding to a insertion or deletion requested for the cell. Possible editing styles are insert or delete.
    ///   - tableView: The table-view object requesting this information.
    /// - Returns: true if the cell item can commit editing style; otherwise, false.
    func canCommitEditingStyle(_ editingStyle: UITableViewCellEditingStyle, in tableView: UITableView) -> Bool
    
    /// Asks the cell item for the actions to display in response to a swipe in the cell.
    ///
    /// - Parameter tableView: The table view object requesting this information.
    /// - Returns: An array of `UITableViewRowAction` objects representing the actions for the cell. Each action you provide is used to create a button that the user can tap.
    func editActions(in tableView: UITableView) -> [UITableViewRowAction]?
    
    /// Asks the cell item to return the level of indentation for a cell in a given section.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - indexPath: An index path locating the cell in tableView.
    /// - Returns: Returns the depth of the cell to show its hierarchical position in the section.
    func indentationLevel(in tableView: UITableView, at indexPath: IndexPath) -> Int
    
    /// Asks the cell item whether the cell can be moved to another location in the table view. This method allows the cell item to specify that the reordering control for the specified cell not be shown.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - indexPath: An index path locating the cell in tableView.
    /// - Returns: true if the cell can be moved; otherwise false.
    func canMoveRow(in tableView: UITableView, at indexPath: IndexPath) -> Bool
    
    /// Tells the cell item that the cell was removed.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - indexPath: An index path locating the cell in tableView.
    func didRemove(from tableView: UITableView, at indexPath: IndexPath)
    
    /// Tells the cell item that the cell successfully finished removing animation.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - indexPath: An index path locating the cell in tableView.
    func didFinishRemovingAnimation(in tableView: UITableView, at indexPath: IndexPath)
}

private struct AssociatedKeys {
    static var shouldHighlightHandler = "rsb_shouldHighlightHandler"
    static var didHighlightHandler    = "rsb_didHighlightHandler"
    static var didUnhighlightHandler  = "rsb_didUnhighlightHandler"
    static var willSelectHandler      = "rsb_willSelectHandler"
    static var willDeselectHandler    = "rsb_willDeselectHandler"
    static var didSelectHandler       = "rsb_didSelectHandler"
    static var didDeselectHandler     = "rsb_didDeselectHandler"
}

extension TableViewCellItemProtocol {
    
    // MARK: - Handlers
    var itemShouldHighlightHandler: HighlightingResolver? {
        get { return ClosureWrapper<HighlightingResolver>.handler(for: self, key: &AssociatedKeys.shouldHighlightHandler) }
        set { ClosureWrapper<HighlightingResolver>.setHandler(newValue, for: self, key: &AssociatedKeys.shouldHighlightHandler) }
    }
    
    var itemDidHighlightHandler: HighlightingHandler? {
        get { return ClosureWrapper<HighlightingHandler>.handler(for: self, key: &AssociatedKeys.didHighlightHandler) }
        set { ClosureWrapper<HighlightingHandler>.setHandler(newValue, for: self, key: &AssociatedKeys.didHighlightHandler) }
    }
    
    var itemDidUnhighlightHandler: HighlightingHandler? {
        get { return ClosureWrapper<HighlightingHandler>.handler(for: self, key: &AssociatedKeys.didUnhighlightHandler) }
        set { ClosureWrapper<HighlightingHandler>.setHandler(newValue, for: self, key: &AssociatedKeys.didUnhighlightHandler) }
    }
    
    var itemWillSelectHandler: SelectionResolver? {
        get { return ClosureWrapper<SelectionResolver>.handler(for: self, key: &AssociatedKeys.willSelectHandler) }
        set { ClosureWrapper<SelectionResolver>.setHandler(newValue, for: self, key: &AssociatedKeys.willSelectHandler) }
    }
    
    var itemWillDeselectHandler: SelectionResolver? {
        get { return ClosureWrapper<SelectionResolver>.handler(for: self, key: &AssociatedKeys.willDeselectHandler) }
        set { ClosureWrapper<SelectionResolver>.setHandler(newValue, for: self, key: &AssociatedKeys.willDeselectHandler) }
    }
    
    var itemDidSelectHandler: SelectionHandler? {
        get { return ClosureWrapper<SelectionHandler>.handler(for: self, key: &AssociatedKeys.didSelectHandler) }
        set { ClosureWrapper<SelectionHandler>.setHandler(newValue, for: self, key: &AssociatedKeys.didSelectHandler) }
    }

    var itemDidDeselectHandler: SelectionHandler? {
        get { return ClosureWrapper<SelectionHandler>.handler(for: self, key: &AssociatedKeys.didDeselectHandler) }
        set { ClosureWrapper<SelectionHandler>.setHandler(newValue, for: self, key: &AssociatedKeys.didDeselectHandler) }
    }
    
    // MARK: - Highlighting
    func shouldHighlightCell(in tableView: UITableView, at indexPath: IndexPath) -> Bool {
        if let itemShouldHighlightHandler = itemShouldHighlightHandler {
            return itemShouldHighlightHandler(tableView, indexPath)
        }
        return true
    }
    func didHighlightCell(in tableView: UITableView, at indexPath: IndexPath) { itemDidHighlightHandler?(tableView, indexPath) }
    func didUnhighlightCell(in tableView: UITableView, at indexPath: IndexPath) { itemDidUnhighlightHandler?(tableView, indexPath) }
    
    // MARK: - Selection
    func willSelectCell(in tableView: UITableView, at indexPath: IndexPath) -> IndexPath? {
        if let itemWillSelectHandler = itemWillSelectHandler {
            return itemWillSelectHandler(tableView, indexPath)
        }
        return indexPath
    }
    
    func willDeselectCell(in tableView: UITableView, at indexPath: IndexPath) -> IndexPath? {
        if let itemWillDeselectHandler = itemWillDeselectHandler {
            return itemWillDeselectHandler(tableView, indexPath)
        }
        return indexPath
    }
    
    func didSelectCell(in tableView: UITableView, at indexPath: IndexPath) { itemDidSelectHandler?(tableView, indexPath) }
    func didDeselectCell(in tableView: UITableView, at indexPath: IndexPath) { itemDidDeselectHandler?(tableView, indexPath) }
    
    // MARK: - Displaying
    func willDisplayCell(_ cell: UITableViewCell, for tableView: UITableView, at indexPath: IndexPath) {}
    func didEndDisplayingCell(_ cell: UITableViewCell, for tableView: UITableView, at indexPath: IndexPath) {}
    
    // MARK: - Editing
    func canEdit(in tableView: UITableView) -> Bool { return false }
    func canCommitEditingStyle(_ editingStyle: UITableViewCellEditingStyle, in tableView: UITableView) -> Bool { return false }
    func editActions(in tableView: UITableView) -> [UITableViewRowAction]? { return nil }
    func indentationLevel(in tableView: UITableView, at indexPath: IndexPath) -> Int { return 0 }
    func canMoveRow(in tableView: UITableView, at indexPath: IndexPath) -> Bool { return false }
    func didRemove(from tableView: UITableView, at indexPath: IndexPath) {}
    func didFinishRemovingAnimation(in tableView: UITableView, at indexPath: IndexPath) {}
}
