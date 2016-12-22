//
//  TableViewManager+UITableViewDelegate.swift
//  RSBTableViewManager
//
//  Created by Dmitry Frishbuter on 22/12/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit.UITableView

extension TableViewManager: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self[indexPath]!.height(in: tableView)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self[indexPath]?.willDisplayCell(cell, for: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self[indexPath]?.didEndDisplayingCell(cell, for: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if let cellItem = self[indexPath] {
            return cellItem.shouldHighlightCell(in: tableView, at: indexPath)
        }
        return true
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        self[indexPath]?.didHighlightCell(in: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        self[indexPath]?.didUnhighlightCell(in: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let cellItem = self[indexPath] {
            return cellItem.willSelectCell(in: tableView, at: indexPath)
        }
        return indexPath
    }
    
    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if let cellItem = self[indexPath] {
            return cellItem.willDeselectCell(in: tableView, at: indexPath)
        }
        return indexPath
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self[indexPath]?.didSelectCell(in: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self[indexPath]?.didDeselectCell(in: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self[section].heightForHeader(in: tableView)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self[section].heightForFooter(in: tableView)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self[section].viewForHeader(in: tableView)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self[section].viewForFooter(in: tableView)
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if let cellItem = self[indexPath] {
            return cellItem.editActions(in: tableView)
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        self[section].willDisplayHeaderView(view, for: section)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        self[section].willDisplayFooterView(view, for: section)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        self[section].didEndDisplayingHeaderView(view, for: section)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        self[section].didEndDisplayingFooterView(view, for: section)
    }
    
    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        guard let delegate = delegate else {
            return proposedDestinationIndexPath
        }
        return delegate.tableView(tableView,
                                  targetIndexPathForMoveFromRowAt: sourceIndexPath,
                                  toProposedIndexPath: proposedDestinationIndexPath)
    }
    
    public func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if let cellItem = self[indexPath] {
            return cellItem.indentationLevel(in: tableView, at: indexPath)
        }
        return 0
    }
    
    // MARK: Copy/Paste
    
    public func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        if let cellItem = self[indexPath] as? TableViewCellItemEditActionsProtocol {
            return cellItem.shouldShowMenu(in: tableView, forRowAt: indexPath)
        }
        return false
    }
    
    public func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if let cellItem = self[indexPath] as? TableViewCellItemEditActionsProtocol {
            return cellItem.canPerformAction(action, in: tableView, forRowAt: indexPath, with: sender)
        }
        return false
    }
    
    public func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if let cellItem = self[indexPath] as? TableViewCellItemEditActionsProtocol {
            cellItem.performAction(action, in: tableView, forRowAt: indexPath, with: sender)
        }
    }
}
