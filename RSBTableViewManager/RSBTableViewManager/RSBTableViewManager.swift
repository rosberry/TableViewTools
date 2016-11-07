//
//  RSBTableViewManager.swift
//
//  Created by Dmitry Frishbuter on 14/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

public class RSBTableViewManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var tableView : UITableView?
    weak var scrollDelegate : UIScrollViewDelegate?
    
    private var _sectionItems = [RSBTableViewSectionItemProtocol]()
    var sectionItems : [RSBTableViewSectionItemProtocol] {
        set {
            _sectionItems = newValue
            for sectionItem in _sectionItems {
                 self.register(sectionItem: sectionItem)
            }
            tableView!.reloadData();
        }
        get {
            return _sectionItems
        }
    }
    
    public init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
    }
    
        // MARK: - Public Functions
    
        // MARK: Cell Items
    
    public func removeCellItems(cellItems: [RSBTableViewCellItemProtocol],
                         fromSectionItem sectionItem: inout RSBTableViewSectionItemProtocol,
                                               withRowAnimation animation: UITableViewRowAnimation) {
        let section = sectionItems.index(where: {$0 === sectionItem})!
        var indexPaths = [IndexPath]()
        let indexes = NSMutableIndexSet()
        
        for cellItem in cellItems {
            let row  = sectionItem.cellItems!.index(where: {$0 === cellItem})
            precondition(row != nil, "It's impossible to remove cell items that are not contained in section item")

            indexPaths.append(IndexPath(row: row!, section: section))
            indexes.add(row!)
        }
        
        tableView!.beginUpdates()
        
        sectionItem.cellItems!.removeElementsAt(indexes: indexes)
        tableView!.deleteRows(at: indexPaths as [IndexPath], with: animation)
        
        tableView!.endUpdates()
    }
    
    public func insertCellItems(cellItems: [RSBTableViewCellItemProtocol],
                         toSectionItem sectionItem: inout RSBTableViewSectionItemProtocol,
                                             atIndexes indexes: NSIndexSet,
                                                       withRowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.firstIndex <= sectionItem.cellItems!.count, "It's impossible to insert item at index that is larger than count of cell items in this section")
        for cellItem in cellItems {
            type(of: cellItem).registerCellFor(tableView: tableView!)
        }
        guard let section = sectionItems.index(where: {$0 === sectionItem}) else {
            return
        }
        
        tableView!.beginUpdates()
        
        sectionItem.cellItems!.insert(elements: cellItems, at: indexes)
        
        var indexPaths = [IndexPath]()
        for idx in indexes {
            indexPaths.append(IndexPath(row: idx, section: section))
        }
        tableView!.insertRows(at: indexPaths as [IndexPath], with: animation)
        
        tableView!.endUpdates()
    }
    
    public func replaceCellItemsAtIndexes(indexes: NSIndexSet,
                                   withCellItems cellItems: [RSBTableViewCellItemProtocol],
                                                 inSectionItem sectionItem: inout RSBTableViewSectionItemProtocol,
                                                                     withRowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.count == cellItems.count, "It's impossible to replace not equal count of cell items")
        for cellItem in cellItems {
            type(of: cellItem).registerCellFor(tableView: tableView!)
        }
        
        tableView!.beginUpdates()
        
        sectionItem.cellItems!.replaceSubrange(indexes.firstIndex ..< indexes.lastIndex, with: cellItems)
        guard let section = sectionItems.index(where: {$0 === sectionItem}) else {
            return
        }
        var indexPaths = [IndexPath]()
        for index in indexes {
            indexPaths.append(IndexPath(row: index, section: section))
        }
        tableView!.reloadRows(at: indexPaths as [IndexPath], with: animation)
        
        tableView!.endUpdates()
    }
    
        // MARK: Section Items
    
    public func removeSectionItems(sectionItems: [RSBTableViewSectionItemProtocol],
                                   withRowAnimation animation: UITableViewRowAnimation) {
        let indexes = NSMutableIndexSet()
        for sectionItem in sectionItems {
            let section = self.sectionItems.index(where: {$0 === sectionItem})
            precondition(section != nil, "It's impossible to remove section items that are not contained in section items array")
            indexes.add(section!)
        }
        
        tableView!.beginUpdates()
        
        self.sectionItems.removeElementsAt(indexes: indexes)
        tableView!.deleteSections(indexes as IndexSet, with: animation)
        
        tableView!.endUpdates()
    }
    
    public func insertSectionItems(sectionItems: [RSBTableViewSectionItemProtocol],
                                   atIndexes indexes: NSIndexSet,
                                             withRowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.firstIndex <= self.sectionItems.count, "It's impossible to insert item at index that is larger than count of section items")
        for sectionItem in sectionItems {
            register(sectionItem: sectionItem)
        }
        
        tableView!.beginUpdates()
        
        self.sectionItems.insert(elements: sectionItems, at: indexes)
        tableView!.insertSections(indexes as IndexSet, with: animation)
        
        tableView!.endUpdates()
    }
    
    public func replaceSectionItemsAtIndexes(indexes: NSIndexSet,
                                             withSectionItems sectionItems: [RSBTableViewSectionItemProtocol],
                                                              rowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.count == sectionItems.count, "It's impossible to replace not equal count of section items")
        for sectionItem in sectionItems {
            register(sectionItem: sectionItem)
        }
        
        tableView!.beginUpdates()
        
        self.sectionItems.replaceSubrange(indexes.firstIndex ..< indexes.lastIndex, with: sectionItems)
        tableView!.reloadSections(indexes as IndexSet, with: animation)
        
        tableView!.endUpdates()
    }
    
        // MARK: Others
    
    public func frameForCellItem(cellItem: RSBTableViewCellItemProtocol,
                                 inSectionItem sectionItem: RSBTableViewSectionItemProtocol) -> CGRect? {
        guard let sectionItemIndex = sectionItems.index(where: {$0 === sectionItem}) else {
            return nil
        }
        guard let cellItemIndex = sectionItem.cellItems!.index(where: {$0 === cellItem}) else {
            return nil
        }
        let indexPath = IndexPath(row: cellItemIndex, section: sectionItemIndex)
        return tableView!.rectForRow(at: indexPath as IndexPath)
    }
    
    public func scrollToCellItem(cellItem: RSBTableViewCellItemProtocol,
                                 inSectionItem sectionItem: RSBTableViewSectionItemProtocol,
                                               atScrollPosition scrollPosition: UITableViewScrollPosition,
                                                                animated: Bool) {
        guard let sectionItemIndex = sectionItems.index(where: {$0 === sectionItem}) else {
            return
        }
        guard let cellItemIndex = sectionItem.cellItems!.index(where: {$0 === cellItem}) else {
            return
        }
        let indexPath = IndexPath(row: cellItemIndex, section: sectionItemIndex)
        tableView!.scrollToRow(at: indexPath as IndexPath, at: scrollPosition, animated: animated)
    }
    
    public func scrollToTopAnimated(animated: Bool) {
        guard let sectionItem = self.sectionItems.first else {
            return
        }
        guard let cellItem = sectionItem.cellItems!.first else {
            return
        }
        scrollToCellItem(cellItem: cellItem,
                         inSectionItem: sectionItem,
                         atScrollPosition: UITableViewScrollPosition.top,
                         animated: animated)
    }
    
        // MARK: Helpers
    
    func register(sectionItem : RSBTableViewSectionItemProtocol) {
        for cellItem in sectionItem.cellItems! {
            type(of: cellItem).registerCellFor(tableView: tableView!)
        }
    }
    
        // MARK: UITableViewDelegate/UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionItems.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = sectionItems[section]
        return sectionItem.cellItems!.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionItem = sectionItems[indexPath.section]
        let cellItem = sectionItem.cellItems![indexPath.row]
        return cellItem.heightFor(tableView: tableView)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let sectionItem = self.sectionItems[indexPath.section]
        let cellItem = sectionItem.cellItems![indexPath.row]
        cellItem.willDisplay(cell: cell, forTableView: tableView, atIndexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionItem = sectionItems[indexPath.section]
        let cellItem = sectionItem.cellItems![indexPath.row]
        let cell = cellItem.cellFor(tableView: tableView)
        cellItem.configure(cell: cell)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionItem = sectionItems[indexPath.section]
        let cellItem = sectionItem.cellItems![indexPath.row]
        cellItem.didSelectIn(tableView: tableView, atIndexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionItem = sectionItems[section]
        return sectionItem.heightForHeaderIn(tableView: tableView)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionItem = sectionItems[section]
        return sectionItem.heightForFooterIn(tableView: tableView)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionItem = sectionItems[section]
        return sectionItem.viewForHeaderIn(tableView: tableView)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionItem = sectionItems[section]
        return sectionItem.viewForFooterIn(tableView: tableView)
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionItem = sectionItems[section]
        return sectionItem.titleForHeaderIn(tableView: tableView)
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let sectionItem = sectionItems[section]
        return sectionItem.titleForFooterIn(tableView: tableView)
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
    
