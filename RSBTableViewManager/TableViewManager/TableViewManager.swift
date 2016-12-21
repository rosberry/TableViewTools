//
//  TableViewManager.swift
//
//  Created by Dmitry Frishbuter on 14/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

public class TableViewManager: NSObject, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    unowned let tableView: UITableView
    weak var delegate: TableViewManagerDelegate?
    weak var scrollDelegate: UIScrollViewDelegate?
    var isPrefetchingEnabled = false {
        didSet {
            if isPrefetchingEnabled {
                if #available(iOS 10.0, *) {
                    self.tableView.prefetchDataSource = self
                }
                else {
                    fatalError("Prefetching allowed only on iOS versions greater than or equal to iOS 10.0")
                }
            }
        }
    }
    
    var sectionItems: [TableViewSectionItemProtocol] = [TableViewSectionItemProtocol]() {
        didSet {
            for sectionItem in sectionItems {
                self.registerSectionItem(sectionItem)
            }
            tableView.reloadData()
        }
    }
    
    public init(tableView: UITableView) {
        self.tableView = tableView
        
        super.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // MARK: - Public Methods
    
    // MARK: Cell Items
    
    public subscript(index: Int) -> TableViewSectionItemProtocol {
        return sectionItems[index]
    }
    
    public subscript(indexPath: IndexPath) -> TableViewCellItemProtocol? {
        return cellItem(for: indexPath)
    }
    
    public func reloadCellItems(_ cellItems: [TableViewCellItemProtocol],
                                inSectionItem sectionItem: TableViewSectionItemProtocol,
                                withRowAnimation animation: UITableViewRowAnimation) {
        let section = sectionItems.index(where: {$0 === sectionItem})!
        var indexPaths = [IndexPath]()
        
        for cellItem in cellItems {
            guard let row = sectionItem.cellItems.index(where: {$0 === cellItem}) else {
                fatalError("It's impossible to remove cell items that are not contained in section item")
            }
            indexPaths.append(IndexPath(row: row, section: section))
        }
        
        tableView.beginUpdates()
        
        tableView.reloadRows(at: indexPaths, with: animation)
        
        tableView.endUpdates()
    }
    
    public func removeCellItems(_ cellItems: [TableViewCellItemProtocol],
                                fromSectionItem sectionItem: inout TableViewSectionItemProtocol,
                                withRowAnimation animation: UITableViewRowAnimation) {
        let section = sectionItems.index(where: {$0 === sectionItem})!
        var indexPaths = [IndexPath]()
        var indexes = IndexSet()
        
        for cellItem in cellItems {
            guard let row = sectionItem.cellItems.index(where: {$0 === cellItem}) else {
                fatalError("It's impossible to remove cell items that are not contained in section item")
            }
            indexPaths.append(IndexPath(row: row, section: section))
            indexes.insert(row)
        }
        
        tableView.beginUpdates()
        
        sectionItem.cellItems.removeElements(at: indexes)
        tableView.deleteRows(at: indexPaths, with: animation)
        
        tableView.endUpdates()
    }
    
    public func removeCellItems(at cellIndexes: IndexSet,
                                fromSectionItemAt sectionIndex: Int,
                                withRowAnimation animation: UITableViewRowAnimation) {
        let indexPaths = cellIndexes.map { IndexPath(row: $0, section: sectionIndex) }
        tableView.beginUpdates()
        
        sectionItems[sectionIndex].cellItems.removeElements(at: cellIndexes)
        tableView.deleteRows(at: indexPaths, with: animation)
        
        tableView.endUpdates()
    }
    
    public func insertCellItems(_ cellItems: [TableViewCellItemProtocol],
                                toSectionItem sectionItem: inout TableViewSectionItemProtocol,
                                atIndexes indexes: IndexSet,
                                withRowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.first! <= sectionItem.cellItems.count, "It's impossible to insert item at index that is larger than count of cell items in this section")
        for cellItem in cellItems {
            registerCellItem(cellItem)
        }
        guard let section = sectionItems.index(where: {$0 === sectionItem}) else {
            return
        }
        let indexPaths = indexes.map { IndexPath(row: $0, section: section) }
        
        tableView.beginUpdates()
        
        sectionItem.cellItems.insertElements(cellItems, at: indexes)
        tableView.insertRows(at: indexPaths, with: animation)
        
        tableView.endUpdates()
    }
    
    public func appendCellItems(_ cellItems: [TableViewCellItemProtocol],
                                toSectionItem sectionItem: inout TableViewSectionItemProtocol,
                                withRowAnimation animation: UITableViewRowAnimation) {
        let indexSet = IndexSet(integersIn: sectionItem.cellItems.count...sectionItem.cellItems.count + cellItems.count)
        insertCellItems(cellItems, toSectionItem: &sectionItem, atIndexes: indexSet, withRowAnimation: animation)
    }
    
    public func replaceCellItems(at indexes: IndexSet,
                                 withCellItems cellItems: [TableViewCellItemProtocol],
                                 inSectionItem sectionItem: inout TableViewSectionItemProtocol,
                                 withRowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.count == cellItems.count, "It's impossible to replace not equal count of cell items")
        for cellItem in cellItems {
            registerCellItem(cellItem)
        }
        
        tableView.beginUpdates()
        
        sectionItem.cellItems.replaceSubrange(indexes.first!...indexes.last!, with: cellItems)
        guard let section = sectionItems.index(where: {$0 === sectionItem}) else {
            return
        }
        let indexPaths = indexes.map { IndexPath(row: $0, section: section) }
        tableView.reloadRows(at: indexPaths, with: animation)
        
        tableView.endUpdates()
    }
    
    // MARK: Section Items
    
    public func removeSectionItems(_ sectionItems: [TableViewSectionItemProtocol],
                                   withRowAnimation animation: UITableViewRowAnimation) {
        var indexes = IndexSet()
        for sectionItem in sectionItems {
            let section = self.sectionItems.index(where: {$0 === sectionItem})
            precondition(section != nil, "It's impossible to remove section items that are not contained in section items array")
            indexes.insert(section!)
        }
        
        tableView.beginUpdates()
        
        self.sectionItems.removeElements(at: indexes)
        tableView.deleteSections(indexes, with: animation)
        
        tableView.endUpdates()
    }
    
    public func removeSectionItems(at indexes: IndexSet,
                                   withRowAnimation animation: UITableViewRowAnimation) {
        tableView.beginUpdates()
        
        self.sectionItems.removeElements(at: indexes)
        tableView.deleteSections(indexes, with: animation)
        
        tableView.endUpdates()
    }
    
    public func insertSectionItems(_ sectionItems: [TableViewSectionItemProtocol],
                                   atIndexes indexes: IndexSet,
                                   withRowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.first! <= self.sectionItems.count, "It's impossible to insert item at index that is larger than count of section items")
        for sectionItem in sectionItems {
            registerSectionItem(sectionItem)
        }
        
        tableView.beginUpdates()
        
        self.sectionItems.insertElements(sectionItems, at: indexes)
        tableView.insertSections(indexes, with: animation)
        
        tableView.endUpdates()
    }
    
    public func appendSectionItems(_ sectionItems: [TableViewSectionItemProtocol],
                                   atIndexes indexes: IndexSet,
                                   withRowAnimation animation: UITableViewRowAnimation) {
        let indexSet = IndexSet(integersIn: self.sectionItems.count...self.sectionItems.count + sectionItems.count)
        insertSectionItems(sectionItems, atIndexes: indexSet, withRowAnimation: animation)
    }
    
    public func replaceSectionItems(at indexes: IndexSet,
                                    withSectionItems sectionItems: [TableViewSectionItemProtocol],
                                    rowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.count == sectionItems.count, "It's impossible to replace not equal count of section items")
        for sectionItem in sectionItems {
            registerSectionItem(sectionItem)
        }
        
        tableView.beginUpdates()
        
        self.sectionItems.replaceSubrange(indexes.first!...indexes.last!, with: sectionItems)
        tableView.reloadSections(indexes, with: animation)
        
        tableView.endUpdates()
    }
    
    // MARK: Others
    
    public func frameForCellItem(_ cellItem: TableViewCellItemProtocol,
                                 inSectionItem sectionItem: TableViewSectionItemProtocol) -> CGRect? {
        guard let sectionItemIndex = sectionItems.index(where: {$0 === sectionItem}),
            let cellItemIndex = sectionItem.cellItems.index(where: {$0 === cellItem}) else {
                return nil
        }
        let indexPath = IndexPath(row: cellItemIndex, section: sectionItemIndex)
        return tableView.rectForRow(at: indexPath)
    }
    
    public func scrollToCellItem(_ cellItem: TableViewCellItemProtocol,
                                 inSectionItem sectionItem: TableViewSectionItemProtocol,
                                 atScrollPosition scrollPosition: UITableViewScrollPosition,
                                 animated: Bool) {
        guard let sectionItemIndex = sectionItems.index(where: {$0 === sectionItem}),
            let cellItemIndex = sectionItem.cellItems.index(where: {$0 === cellItem}) else {
                return
        }
        let indexPath = IndexPath(row: cellItemIndex, section: sectionItemIndex)
        tableView.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    public func scrollToTopAnimated(animated: Bool) {
        guard let sectionItem = self.sectionItems.first,
            let cellItem = sectionItem.cellItems.first else {
                return
        }
        scrollToCellItem(cellItem,
                         inSectionItem: sectionItem,
                         atScrollPosition: .top,
                         animated: animated)
    }
    
    // MARK: Helpers
    
    public func cellItem(for indexPath: IndexPath) -> TableViewCellItemProtocol? {
        if let cellItems = self.sectionItem(for: indexPath)?.cellItems {
            if indexPath.row < cellItems.count {
                return cellItems[indexPath.row]
            }
        }
        return nil
    }
    
    public func sectionItem(for indexPath: IndexPath) -> TableViewSectionItemProtocol? {
        if indexPath.section < sectionItems.count {
            return sectionItems[indexPath.section]
        }
        return nil
    }
    
    private func registerSectionItem(_ sectionItem : TableViewSectionItemProtocol) {
        for cellItem in sectionItem.cellItems {
            registerCellItem(cellItem)
        }
    }
    
    private func registerCellItem(_ cellItem: TableViewCellItemProtocol) {
        let reuseIdentifier = reuseIdentifierForCellItem(cellItem)
        
        if !reuseIdentifier.isStoryboard {
            if let cellNib = cellItem.registeredTableViewCellNib() {
                tableView.register(cellNib, forCellReuseIdentifier: reuseIdentifier.identifier)
            }
            else if let cellClass = cellItem.registeredTableViewCellClass() {
                tableView.register(cellClass, forCellReuseIdentifier: reuseIdentifier.identifier)
            }
            else {
                fatalError("You have to provide at least one of the following methods: registeredTableViewCellNib, registeredTableViewCellClass or storyboardPrototypeTableViewCellReuseIdentifier.")
            }
        }
    }
    
    private func reuseIdentifierForCellItem(_ cellItem: TableViewCellItemProtocol) -> (identifier: String, isStoryboard: Bool) {
        let reuseIdentifier = NSStringFromClass(type(of: cellItem)).components(separatedBy: ".").last!
        guard let storyboardReuseIdentifier = cellItem.storyboardPrototypeTableViewCellReuseIdentifier() else {
            return (reuseIdentifier, false)
        }
        return (storyboardReuseIdentifier, true)
    }
    
    // MARK: UITableViewDelegate/UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionItems.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self[section].cellItems.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self[indexPath]!.height(in: tableView)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self[indexPath]?.willDisplayCell(cell, for: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellItem = self[indexPath]
        cellItem?.didEndDisplayingCell(cell, for: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellItem = self[indexPath]!
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierForCellItem(cellItem).identifier,
                                                 for: indexPath)
        cellItem.configureCell(cell, in: tableView, at: indexPath)
        return cell
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
        return self[indexPath]!.indentationLevel(in: tableView, at: indexPath)
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
    
    // MARK: - UITableViewDataSourcePrefetching
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        var cellItems = [TableViewCellItemProtocol]()
        for indexPath in indexPaths {
            if let cellItem = self[indexPath] {
                cellItems.append(cellItem)
            }
        }
        for (index, cellItem) in cellItems.enumerated() {
            cellItem.prefetchData(for: tableView, at: indexPaths[index])
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            self[indexPath]?.cancelPrefetchingData(for: tableView, at: indexPath)
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidZoom?(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollDelegate?.viewForZooming?(in: scrollView)
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let shouldScroll = scrollDelegate?.scrollViewShouldScrollToTop?(scrollView) {
            return shouldScroll
        }
        return true
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
}
    
