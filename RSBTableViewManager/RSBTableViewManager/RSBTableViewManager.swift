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
                 self.registerSectionItem(sectionItem)
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
                         inout fromSectionItem sectionItem: RSBTableViewSectionItemProtocol,
                                               withRowAnimation animation: UITableViewRowAnimation) {
        let section = sectionItems.indexOf({$0 === sectionItem})!
        var indexPaths = [NSIndexPath]()
        let indexes = NSMutableIndexSet()
        
        for cellItem in cellItems {
            let row  = sectionItem.cellItems!.indexOf({$0 === cellItem})
            precondition(row != nil, "It's impossible to remove cell items that are not contained in section item")

            indexPaths.append(NSIndexPath(forRow: row!, inSection: section))
            indexes.addIndex(row!)
        }
        
        tableView!.beginUpdates()
        
        sectionItem.cellItems!.removeElementsAtIndexes(indexes)
        tableView!.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
        
        tableView!.endUpdates()
    }
    
    public func insertCellItems(cellItems: [RSBTableViewCellItemProtocol],
                         inout toSectionItem sectionItem: RSBTableViewSectionItemProtocol,
                                             atIndexes indexes: NSIndexSet,
                                                       withRowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.firstIndex <= sectionItem.cellItems!.count, "It's impossible to insert item at index that is larger than count of cell items in this section")
        for cellItem in cellItems {
            cellItem.dynamicType.registerCellForTableView(tableView!)
        }
        guard let section = sectionItems.indexOf({$0 === sectionItem}) else {
            return
        }
        
        tableView!.beginUpdates()
        
        sectionItem.cellItems!.insertElements(cellItems, atIndexes: indexes)
        
        var indexPaths = [NSIndexPath]()
        for idx in indexes {
            indexPaths.append(NSIndexPath(forRow: idx, inSection: section))
        }
        tableView!.insertRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
        
        tableView!.endUpdates()
    }
    
    public func replaceCellItemsAtIndexes(indexes: NSIndexSet,
                                   withCellItems cellItems: [RSBTableViewCellItemProtocol],
                                                 inout inSectionItem sectionItem: RSBTableViewSectionItemProtocol,
                                                                     withRowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.count == cellItems.count, "It's impossible to replace not equal count of cell items")
        for cellItem in cellItems {
            cellItem.dynamicType.registerCellForTableView(tableView!)
        }
        
        tableView!.beginUpdates()
        
        sectionItem.cellItems!.replaceRange(indexes.firstIndex ..< indexes.lastIndex, with: cellItems)
        guard let section = sectionItems.indexOf({$0 === sectionItem}) else {
            return
        }
        var indexPaths = [NSIndexPath]()
        indexes.enumerateIndexesUsingBlock { (index, stop) in
            indexPaths.append(NSIndexPath(forRow: index, inSection: section))
        }
        tableView!.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
        
        tableView!.endUpdates()
    }
    
        // MARK: Section Items
    
    public func removeSectionItems(sectionItems: [RSBTableViewSectionItemProtocol],
                                   withRowAnimation animation: UITableViewRowAnimation) {
        let indexes = NSMutableIndexSet()
        for sectionItem in sectionItems {
            let section = self.sectionItems.indexOf({$0 === sectionItem})
            precondition(section != nil, "It's impossible to remove section items that are not contained in section items array")
            indexes.addIndex(section!)
        }
        
        tableView!.beginUpdates()
        
        self.sectionItems.removeElementsAtIndexes(indexes)
        tableView!.deleteSections(indexes, withRowAnimation: animation)
        
        tableView!.endUpdates()
    }
    
    public func insertSectionItems(sectionItems: [RSBTableViewSectionItemProtocol],
                                   atIndexes indexes: NSIndexSet,
                                             withRowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.firstIndex <= self.sectionItems.count, "It's impossible to insert item at index that is larger than count of section items")
        for sectionItem in sectionItems {
            registerSectionItem(sectionItem)
        }
        
        tableView!.beginUpdates()
        
        self.sectionItems.insertElements(sectionItems, atIndexes: indexes)
        tableView!.insertSections(indexes, withRowAnimation: animation)
        
        tableView!.endUpdates()
    }
    
    public func replaceSectionItemsAtIndexes(indexes: NSIndexSet,
                                             withSectionItems sectionItems: [RSBTableViewSectionItemProtocol],
                                                              rowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.count == sectionItems.count, "It's impossible to replace not equal count of section items")
        for sectionItem in sectionItems {
            registerSectionItem(sectionItem)
        }
        
        tableView!.beginUpdates()
        
        self.sectionItems.replaceRange(indexes.firstIndex ..< indexes.lastIndex, with: sectionItems)
        tableView!.reloadSections(indexes, withRowAnimation: animation)
        
        tableView!.endUpdates()
    }
    
        // MARK: Others
    
    public func frameForCellItem(cellItem: RSBTableViewCellItemProtocol,
                                 inSectionItem sectionItem: RSBTableViewSectionItemProtocol) -> CGRect? {
        guard let sectionItemIndex = sectionItems.indexOf({$0 === sectionItem}) else {
            return nil
        }
        guard let cellItemIndex = sectionItem.cellItems!.indexOf({$0 === cellItem}) else {
            return nil
        }
        let indexPath = NSIndexPath(forRow: cellItemIndex, inSection: sectionItemIndex)
        return tableView!.rectForRowAtIndexPath(indexPath)
    }
    
    public func scrollToCellItem(cellItem: RSBTableViewCellItemProtocol,
                                 inSectionItem sectionItem: RSBTableViewSectionItemProtocol,
                                               atScrollPosition scrollPosition: UITableViewScrollPosition,
                                                                animated: Bool) {
        guard let sectionItemIndex = sectionItems.indexOf({$0 === sectionItem}) else {
            return
        }
        guard let cellItemIndex = sectionItem.cellItems!.indexOf({$0 === cellItem}) else {
            return
        }
        let indexPath = NSIndexPath(forRow: cellItemIndex, inSection: sectionItemIndex)
        tableView!.scrollToRowAtIndexPath(indexPath, atScrollPosition: scrollPosition, animated: animated)
    }
    
    public func scrollToTopAnimated(animated: Bool) {
        guard let sectionItem = self.sectionItems.first else {
            return
        }
        guard let cellItem = sectionItem.cellItems!.first else {
            return
        }
        scrollToCellItem(cellItem,
                         inSectionItem: sectionItem,
                         atScrollPosition: UITableViewScrollPosition.Top,
                         animated: animated)
    }
    
        // MARK: Helpers
    
    func registerSectionItem(sectionItem : RSBTableViewSectionItemProtocol) {
        for cellItem in sectionItem.cellItems! {
            cellItem.dynamicType.registerCellForTableView(tableView!)
        }
    }
    
        // MARK: UITableViewDelegate/UITableViewDataSource
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionItems.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = sectionItems[section]
        return sectionItem.cellItems!.count
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let sectionItem = sectionItems[indexPath.section]
        let cellItem = sectionItem.cellItems![indexPath.row]
        return cellItem.heightForTableView(tableView)
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let sectionItem = self.sectionItems[indexPath.section]
        let cellItem = sectionItem.cellItems![indexPath.row]
        cellItem.willDisplayCell(cell, forTableView: tableView, atIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sectionItem = sectionItems[indexPath.section]
        let cellItem = sectionItem.cellItems![indexPath.row]
        let cell = cellItem.cellForTableView(tableView)
        cellItem.configureCell(cell)
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sectionItem = sectionItems[indexPath.section]
        let cellItem = sectionItem.cellItems![indexPath.row]
        cellItem.didSelectInTableView(tableView, atIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionItem = sectionItems[section]
        return sectionItem.heightForHeaderInTableView(tableView)
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionItem = sectionItems[section]
        return sectionItem.heightForFooterInTableView(tableView)
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionItem = sectionItems[section]
        return sectionItem.viewForHeaderInTableView(tableView)
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionItem = sectionItems[section]
        return sectionItem.viewForFooterInTableView(tableView)
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionItem = sectionItems[section]
        return sectionItem.titleForHeaderInTableView(tableView)
    }
    
    public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let sectionItem = sectionItems[section]
        return sectionItem.titleForFooterInTableView(tableView)
    }
    
        // MARK: UIScrollViewDelegate
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewDidZoom(scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidZoom?(scrollView)
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        scrollDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollDelegate?.viewForZoomingInScrollView?(scrollView)
    }
    
    public func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        scrollDelegate?.scrollViewWillBeginZooming?(scrollView, withView: view)
    }
    
    public func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        scrollDelegate?.scrollViewDidEndZooming?(scrollView, withView: view, atScale: scale)
    }
    
    public func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        if let shouldScroll = scrollDelegate?.scrollViewShouldScrollToTop?(scrollView) {
            return shouldScroll
        }
        return true
    }
    
    public func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
}
    