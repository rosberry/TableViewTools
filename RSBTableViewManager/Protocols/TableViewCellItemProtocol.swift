//
//  TableViewCellItemProtocol.swift
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
    
    var itemShouldHighlightHandler: HighlightingResolver? { get set }
    var itemDidHighlightHandler:    HighlightingHandler? { get set }
    var itemDidUnhighlightHandler:  HighlightingHandler? { get set }
    
    var itemDidSelectHandler:   SelectionHandler? { get set }
    var itemDidDeselectHandler: SelectionHandler? { get set }
    
    var itemWillSelectHandler:   SelectionResolver? { get set }
    var itemWillDeselectHandler: SelectionResolver? { get set }
    
    func storyboardPrototypeTableViewCellReuseIdentifier() -> String?
    func registeredTableViewCellNib() -> UINib?
    func registeredTableViewCellClass() -> AnyClass?
    
    func height(in tableView: UITableView) -> CGFloat
    func configureCell(_ cell: UITableViewCell, in tableView: UITableView, at indexPath: IndexPath)
    
    func shouldHighlightCell(in tableView: UITableView, at indexPath: IndexPath) -> Bool
    func didHighlightCell(in tableView: UITableView, at indexPath: IndexPath)
    func didUnhighlightCell(in tableView: UITableView, at indexPath: IndexPath)
    
    func willSelectCell(in tableView: UITableView, at indexPath: IndexPath) -> IndexPath?
    func willDeselectCell(in tableView: UITableView, at indexPath: IndexPath) -> IndexPath?
    func didSelectCell(in tableView: UITableView, at indexPath: IndexPath)
    func didDeselectCell(in tableView: UITableView, at indexPath: IndexPath)
    
    func willDisplayCell(_ cell: UITableViewCell, for tableView: UITableView, at indexPath: IndexPath)
    func didEndDisplayingCell(_ cell: UITableViewCell, for tableView: UITableView, at indexPath: IndexPath)
    func canEdit(in tableView: UITableView) -> Bool
    func canCommitEditingStyle(_ editingStyle: UITableViewCellEditingStyle, in tableView: UITableView) -> Bool
    func editActions(in tableView: UITableView) -> [UITableViewRowAction]?
    func indentationLevel(in tableView: UITableView, at indexPath: IndexPath) -> Int
    func canMoveRow(in tableView: UITableView, at indexPath: IndexPath) -> Bool
    func didRemove(from tableView: UITableView, at indexPath: IndexPath)
    func didFinishRemovingAnimation(in tableView: UITableView, at indexPath: IndexPath)

    static func registerCell(for tableView : UITableView)
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
    
    func storyboardPrototypeTableViewCellReuseIdentifier() -> String? { return nil }
    func registeredTableViewCellNib() -> UINib? { return nil }
    func registeredTableViewCellClass() -> AnyClass? { return nil }
    
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
    func canEditInTableView(_ tableView: UITableView) -> Bool { return false }
    func canCommitEditingStyle(_ editingStyle: UITableViewCellEditingStyle, in tableView: UITableView) -> Bool { return false }
    func editActions(in tableView: UITableView) -> [UITableViewRowAction]? { return nil }
    func indentationLevel(in tableView: UITableView, at indexPath: IndexPath) -> Int {
        fatalError("Method should implemented in protocol inheritor")
    }
    func canMoveRow(in tableView: UITableView, at indexPath: IndexPath) -> Bool { return false }
    func didRemove(from tableView: UITableView, at indexPath: IndexPath) {}
    func didFinishRemovingAnimation(in tableView: UITableView, at indexPath: IndexPath) {}
}
