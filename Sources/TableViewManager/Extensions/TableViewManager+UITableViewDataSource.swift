//
//  TableViewManager+UITableViewDataSource.swift
//  TableViewTools
//
//  Created by Dmitry Frishbuter on 22/12/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit.UITableView

extension TableViewManager: UITableViewDataSource {

    #if swift(>=4.2)
    public typealias EditingStyle = UITableViewCell.EditingStyle
    #else
    public typealias EditingStyle = UITableViewCellEditingStyle
    #endif
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionItems.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionItem = self[section] else { return 0 }
        return sectionItem.cellItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellItem = self[indexPath]!
        let cell = cellItem.cell(for: tableView, at: indexPath)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self[section]?.titleForHeader(in: tableView)
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self[section]?.titleForFooter(in: tableView)
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
    
    // MARK: - Editing
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let cellItem = self[indexPath] as? TableViewCellItemEditActionsProtocol {
            return cellItem.canEdit(in: tableView)
        }
        return false
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard var sectionItem = self[indexPath.section],
                let cellItem = self[indexPath],
                let editableCellItem = cellItem as? TableViewCellItemEditActionsProtocol else {
                    return
            }
            if editableCellItem.canCommit(editingStyle, in: tableView) {
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    editableCellItem.didFinishRemovingAnimation(in: tableView, at: indexPath)
                }
                removeCellItems([cellItem], fromSectionItem: &sectionItem, withRowAnimation: .automatic)
                CATransaction.commit()
                
                editableCellItem.didRemove(from: tableView, at: indexPath)
            }
        }
    }
    
}
