//
//  TableViewManager+UITableViewDataSource.swift
//  RSBTableViewManager
//
//  Created by Dmitry Frishbuter on 22/12/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit.UITableView

extension TableViewManager: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionItems.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self[section].cellItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellItem = self[indexPath]!
        let cell = tableView.dequeueReusableCell(withIdentifier: cellItem.reuseType.identifier,
                                                 for: indexPath)
        cellItem.configureCell(cell, in: tableView, at: indexPath)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self[section].titleForHeader(in: tableView)
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self[section].titleForFooter(in: tableView)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let cellItem = self[indexPath] {
            return cellItem.canEdit(in: tableView)
        }
        return false
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        var sectionItem = self[indexPath.row]
        let cellItem = self[indexPath]
        if editingStyle == .delete {
            guard let cellItem = cellItem else {
                return
            }
            if cellItem.canCommitEditingStyle(editingStyle, in: tableView) {
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    cellItem.didFinishRemovingAnimation(in: tableView, at: indexPath)
                }
                removeCellItems([cellItem], fromSectionItem: &sectionItem, withRowAnimation: .automatic)
                CATransaction.commit()
                
                cellItem.didRemove(from: tableView, at: indexPath)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if let cellItem = self[indexPath] {
            return cellItem.canMoveRow(in: tableView, at: indexPath)
        }
        return false
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if let delegate = delegate {
            return delegate.sectionIndexTitles(for: tableView)
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if let delegate = delegate {
            return delegate.tableView(tableView, sectionForSectionIndexTitle: title, at: index)
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        delegate?.tableView(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
}

