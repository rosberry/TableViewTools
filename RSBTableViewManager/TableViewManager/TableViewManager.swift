//
//  TableViewManager.swift
//
//  Created by Dmitry Frishbuter on 14/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

public class TableViewManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    unowned let tableView : UITableView
    weak var scrollDelegate : UIScrollViewDelegate?
    
    var sectionItems : [TableViewSectionItemProtocol] = [TableViewSectionItemProtocol]() {
        didSet {
            for sectionItem in sectionItems {
                self.register(sectionItem: sectionItem)
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
    
    // MARK: - Public Functions
    
    // MARK: Cell Items
    
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
            type(of: cellItem).registerCell(for: tableView)
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
    
    public func replaceCellItems(at indexes: IndexSet,
                                 withCellItems cellItems: [TableViewCellItemProtocol],
                                 inSectionItem sectionItem: inout TableViewSectionItemProtocol,
                                 withRowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.count == cellItems.count, "It's impossible to replace not equal count of cell items")
        for cellItem in cellItems {
            type(of: cellItem).registerCell(for: tableView)
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
    
    public func insertSectionItems(_ sectionItems: [TableViewSectionItemProtocol],
                                   atIndexes indexes: IndexSet,
                                   withRowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.first! <= self.sectionItems.count, "It's impossible to insert item at index that is larger than count of section items")
        for sectionItem in sectionItems {
            register(sectionItem: sectionItem)
        }
        
        tableView.beginUpdates()
        
        self.sectionItems.insertElements(sectionItems, at: indexes)
        tableView.insertSections(indexes, with: animation)
        
        tableView.endUpdates()
    }
    
    public func replaceSectionItems(at indexes: IndexSet,
                                    withSectionItems sectionItems: [TableViewSectionItemProtocol],
                                    rowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.count == sectionItems.count, "It's impossible to replace not equal count of section items")
        for sectionItem in sectionItems {
            register(sectionItem: sectionItem)
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
        scrollToCellItem(cellItem, inSectionItem: sectionItem, atScrollPosition: .top, animated: animated)
    }
    
    // MARK: Helpers
    
    private func cellItem(by indexPath: IndexPath) -> TableViewCellItemProtocol? {
        if let cellItems = self.sectionItem(by: indexPath)?.cellItems {
            if indexPath.row < cellItems.count {
                return cellItems[indexPath.row]
            }
        }
        return nil
    }
    
    private func sectionItem(by indexPath: IndexPath) -> TableViewSectionItemProtocol? {
        if indexPath.section < sectionItems.count {
            return sectionItems[indexPath.section]
        }
        return nil
    }
    
    private func register(sectionItem : TableViewSectionItemProtocol) {
        for cellItem in sectionItem.cellItems {
            type(of: cellItem).registerCell(for: tableView)
        }
    }
    
    // MARK: UITableViewDelegate/UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionItems.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = sectionItems[section]
        return sectionItem.cellItems.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellItem = self.cellItem(by: indexPath)!
        return cellItem.height(for: tableView)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellItem = self.cellItem(by: indexPath)
        cellItem?.willDisplayCell(cell, for: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellItem = self.cellItem(by: indexPath)
        cellItem?.didEndDisplayingCell(cell, for: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionItem = sectionItems[indexPath.section]
        let cellItem = sectionItem.cellItems[indexPath.row]
        let cell = cellItem.cell(for: tableView, at: indexPath)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionItem = sectionItems[indexPath.section]
        let cellItem = sectionItem.cellItems[indexPath.row]
        cellItem.didSelectCell(in: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let sectionItem = sectionItems[indexPath.section]
        let cellItem = sectionItem.cellItems[indexPath.row]
        cellItem.didDeselectCell(in: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionItem = sectionItems[section]
        return sectionItem.heightForHeader(in: tableView)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionItem = sectionItems[section]
        return sectionItem.heightForFooter(in: tableView)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionItem = sectionItems[section]
        return sectionItem.viewForHeader(in: tableView)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionItem = sectionItems[section]
        return sectionItem.viewForFooter(in: tableView)
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionItem = sectionItems[section]
        return sectionItem.titleForHeader(in: tableView)
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let sectionItem = sectionItems[section]
        return sectionItem.titleForFooter(in: tableView)
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

