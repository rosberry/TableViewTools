//
//  TableViewCellItemProtocol.swift
//  TableViewTools
//
//  Created by Dmitry Frishbuter on 19/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit.UITableView

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
    
    /// Asks the cell item for the estimated height of a row.
    /// Providing an estimate the height of rows can improve the user experience when loading the table view. If the table contains variable height rows, it might be expensive to calculate all their heights and so lead to a longer load time. Using estimation allows you to defer some of the cost of geometry calculation from load time to scrolling time.
    ///
    /// - Parameter tableView: The table-view object requesting this information.
    /// - Returns: A nonnegative floating-point value that estimates the height (in points) that row should be. Return UITableViewAutomaticDimension if you have no estimate.
    func estimatedHeight(in tableView:UITableView) -> CGFloat
    
    /// Asks the cell item for cell configured for displayong at specified index path
    ///
    ///   - tableView: The table-view object requesting this information.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: An object inheriting from UITableViewCell that the table view can use for the specified row.
    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    
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

public extension TableViewCellItemProtocol {
    
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
    
    func estimatedHeight(in tableView: UITableView) -> CGFloat { return 2 }
    
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
    
    // MARK: - Indentation
    func indentationLevel(in tableView: UITableView, at indexPath: IndexPath) -> Int { return 0 }
    
    // MARK: - Moving
    func canMoveRow(in tableView: UITableView, at indexPath: IndexPath) -> Bool { return false }
}
