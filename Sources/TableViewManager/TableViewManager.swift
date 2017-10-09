//
//  TableViewManager.swift
//  TableViewTools
//
//  Created by Dmitry Frishbuter on 14/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit.UITableView

open class TableViewManager: NSObject {
    
    /// `UITableView` object for managing
    public unowned let tableView: UITableView
    
    /// The delegate of a `TableViewManager` object can adopt the `TableViewManagerDelegate` protocol. Optional methods of the protocol allow the delegate to configure section index titles, move rows from one index path to another, and perform other actions.
    public weak var delegate: TableViewManagerDelegate?
    
    /// The methods declared by the UIScrollViewDelegate protocol allow the adopting delegate to respond to messages from the UIScrollView class and thus respond to, and in some affect, operations such as scrolling, zooming, deceleration of scrolled content, and scrolling animations.
    public weak var scrollDelegate: UIScrollViewDelegate?
    
    /// The property that determines whether should be used data source prefetching. Prefetching allowed only on iOS versions greater than or equal to 10.0
    public var isPrefetchingEnabled = false {
        didSet {
            if isPrefetchingEnabled {
                if #available(iOS 10.0, *) {
                    tableView.prefetchDataSource = self
                }
                else {
                    fatalError("Prefetching allowed only on iOS versions greater than or equal to 10.0")
                }
            }
        }
    }
    
    /// Array of `TableViewSectionItemProtocol` objects, each responds for configuration of specified section in table view.
    public var sectionItems = [TableViewSectionItemProtocol]() {
        didSet {
            sectionItems.forEach { registerSectionItem($0) }
            tableView.reloadData()
        }
    }
    
    public init(tableView: UITableView) {
        self.tableView = tableView
        
        super.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // MARK: Cell Items
    
    /// Accesses the section item at the specified position.
    ///
    /// - Parameter index: The index of the section item to access.
    public subscript(index: Int) -> TableViewSectionItemProtocol? {
        guard index < sectionItems.count else { return nil }
        return sectionItems[index]
    }
    
    /// Accesses the cell item in the specified section and at the specified position.
    ///
    /// - Parameter indexPath: The index path of the cell item to access.
    public subscript(indexPath: IndexPath) -> TableViewCellItemProtocol? {
        return cellItem(for: indexPath)
    }
    
    /// Reloads rows, associated with passed cell items inside specified section, associated with passed section item
    ///
    /// - Parameters:
    ///   - cellItems: Cell items to reload
    ///   - sectionItem: Section item that contains cell items to reload
    ///   - animation: A constant that either specifies the kind of animation to perform when inserting the cell or requests no animation. See UITableViewRowAnimation for descriptions of the constants.
    open func reloadCellItems(_ cellItems: [TableViewCellItemProtocol],
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
        
        tableView.update {
            tableView.reloadRows(at: indexPaths, with: animation)
        }
    }
    
    /// Removes cell items, that are contained inside specified section item, and then removes rows at the coressponding locations, with an option to animate the removing.
    ///
    /// - Parameters:
    ///   - cellItems: Cell items to remove
    ///   - sectionItem: Section item that contains cell items to remove
    ///   - animation: A constant that either specifies the kind of animation to perform when inserting the cell or requests no animation. See UITableViewRowAnimation for descriptions of the constants.
    open func removeCellItems(_ cellItems: [TableViewCellItemProtocol],
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
        
        tableView.update {
            sectionItem.cellItems.remove(at: indexes)
            tableView.deleteRows(at: indexPaths, with: animation)
        }
    }
    
    /// Removes cell items, that are preserved at specified indexes inside section item, and then removes rows at the corresponding locations, with an option to animate the removing.
    ///
    /// - Parameters:
    ///   - cellIndexes: IndexSet, that contains indexes of cell items to remove inside specified section item
    ///   - sectionIndex: Index of section item that contains cell items to remove
    ///   - animation: A constant that either specifies the kind of animation to perform when inserting the cell or requests no animation. See UITableViewRowAnimation for descriptions of the constants.
    open func removeCellItems(at cellIndexes: IndexSet,
                              fromSectionItemAt sectionIndex: Int,
                              withRowAnimation animation: UITableViewRowAnimation) {
        let indexPaths = cellIndexes.map { IndexPath(row: $0, section: sectionIndex) }
        
        tableView.update {
            sectionItems[sectionIndex].cellItems.remove(at: cellIndexes)
            tableView.deleteRows(at: indexPaths, with: animation)
        }
    }
    
    /// Inserts cell items to the specified section item, and then inserts rows at the locations identified by array of corresponding index paths, with an option to animate the insertion.
    ///
    /// - Parameters:
    ///   - cellItems: An array of cell items to insert, each responds for cell configuration at specified index path
    ///   - sectionItem: Section item to insert cell items
    ///   - indexes: IndexSet of row positions inside specified section to insert rows
    ///   - animation: A constant that either specifies the kind of animation to perform when inserting the cell or requests no animation. See UITableViewRowAnimation for descriptions of the constants.
    open func insertCellItems(_ cellItems: [TableViewCellItemProtocol],
                              toSectionItem sectionItem: inout TableViewSectionItemProtocol,
                              atIndexes indexes: IndexSet,
                              withRowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.first! <= sectionItem.cellItems.count, "It's impossible to insert item at index that is larger than count of cell items in this section")
        cellItems.forEach { registerCellItem($0) }
        guard let section = sectionItems.index(where: {$0 === sectionItem}) else {
            return
        }
        let indexPaths = indexes.map { IndexPath(row: $0, section: section) }
        
        tableView.update {
            sectionItem.cellItems.insert(cellItems, at: indexes)
            tableView.insertRows(at: indexPaths, with: animation)
        }
    }
    
    /// Appends cell items at the end of specified section item, and then inserts rows at the end of section, with an option to animate the insertion.
    ///
    /// - Parameters:
    ///   - cellItems: An array of cell items to append, each responds for cell configuration at specified index path.
    ///   - sectionItem: Section item to append cell items.
    ///   - animation: A constant that either specifies the kind of animation to perform when inserting the cell or requests no animation. See UITableViewRowAnimation for descriptions of the constants.
    open func appendCellItems(_ cellItems: [TableViewCellItemProtocol],
                              toSectionItem sectionItem: inout TableViewSectionItemProtocol,
                              withRowAnimation animation: UITableViewRowAnimation) {
        let count = sectionItem.cellItems.count
        let indexSet = IndexSet(integersIn: count...(count + cellItems.count - 1))
        insertCellItems(cellItems, toSectionItem: &sectionItem, atIndexes: indexSet, withRowAnimation: animation)
    }
    
    /// Appends cell items at the end of specified section item at specified index, and then inserts rows at the end of section, with an option to animate the insertion.
    ///
    /// - Parameters:
    ///   - cellItems: An array of cell items to append, each responds for cell configuration at specified index path.
    ///   - sectionIndex: Index of section to append cell items.
    ///   - animation: A constant that either specifies the kind of animation to perform when inserting the cell or requests no animation. See UITableViewRowAnimation for descriptions of the constants.
    open func appendCellItems(_ cellItems: [TableViewCellItemProtocol],
                              toSectionItemAt sectionIndex: Int,
                              withRowAnimation animation: UITableViewRowAnimation) {
        guard var sectionItem = self[sectionIndex] else { return }
        appendCellItems(cellItems, toSectionItem: &sectionItem, withRowAnimation: animation)
    }
    
    /// Replaces cell items inside the specified section item, and then replaces corresponding rows within section, with an option to animate the insertion.
    ///
    /// - Parameters:
    ///   - cellItems: An array of replacement cell items, each responds for cell configuration at specified index path
    ///   - sectionItem: Section item to insert cell items
    ///   - animation: A constant that either specifies the kind of animation to perform when inserting the cell or requests no animation. See UITableViewRowAnimation for descriptions of the constants.
    open func replaceCellItems(at indexes: IndexSet,
                               withCellItems cellItems: [TableViewCellItemProtocol],
                               inSectionItem sectionItem: inout TableViewSectionItemProtocol,
                               withRowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.count == cellItems.count, "It's impossible to replace not equal count of cell items")
        cellItems.forEach { registerCellItem($0) }
        
        tableView.update {
            sectionItem.cellItems.replace(cellItems, at: indexes)
            guard let section = sectionItems.index(where: {$0 === sectionItem}) else {
                return
            }
            let indexPaths = indexes.map { IndexPath(row: $0, section: section) }
            tableView.reloadRows(at: indexPaths, with: animation)
        }
    }
    
    // MARK: Section Items
    
    /// Removes one or more section items, with an option to animate the deletion. Don't need to call `beginUpdates()` and `endUpdates() `methods. Be sure that `UITableViewManager` contains section items.
    /// - Parameters:
    ///   - sectionItems: An array of `TableViewSectionItemProtocol` objects
    ///   - animation: A constant that either specifies the kind of animation to perform when deleting the section or requests no animation.
    open func removeSectionItems(_ sectionItems: [TableViewSectionItemProtocol],
                                 withRowAnimation animation: UITableViewRowAnimation) {
        var indexes = IndexSet()
        for sectionItem in sectionItems {
            let section = sectionItems.index(where: {$0 === sectionItem})
            precondition(section != nil, "It's impossible to remove section items that are not contained in section items array")
            indexes.insert(section!)
        }
        
        tableView.update {
            self.sectionItems.remove(at: indexes)
            tableView.deleteSections(indexes, with: animation)
        }
    }
    
    /// Removes one or more section items, with an option to animate the deletion. Don't need to call `beginUpdates()` and `endUpdates() `methods.
    /// - Parameters:
    ///   - indexes: An index set that specifies the section items to delete. If a section exists after the specified index location, it is moved up one index location.
    ///   - animation: A constant that either specifies the kind of animation to perform when deleting the section or requests no animation.
    open func removeSectionItems(at indexes: IndexSet,
                                 withRowAnimation animation: UITableViewRowAnimation) {
        tableView.update {
            self.sectionItems.remove(at: indexes)
            tableView.deleteSections(indexes, with: animation)
        }
    }
    
    /// Inserts one or more section items, with an option to animate the insertion. Don't need to call `beginUpdates()` and `endUpdates() `methods.
    ///
    /// - Parameters:
    ///   - sectionItems: An array of `TableViewSectionItemProtocol` objects
    ///   - indexes: An index set that specifies the sections to insert in the table view. If a section already exists at the specified index location, it is moved down one index location.
    ///   - animation: A constant that indicates how the insertion is to be animated, for example, fade in or slide in from the left. See UITableViewRowAnimation for descriptions of these constants.
    open func insertSectionItems(_ sectionItems: [TableViewSectionItemProtocol],
                                 atIndexes indexes: IndexSet,
                                 withRowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.first! <= sectionItems.count, "It's impossible to insert item at index that is larger than count of section items")
        sectionItems.forEach { registerSectionItem($0) }
        
        tableView.update {
            self.sectionItems.insert(sectionItems, at: indexes)
            tableView.insertSections(indexes, with: animation)
        }
    }
    
    /// Inserts one or more section items at the end of section items list, with an option to animate the insertion. Don't need to call `beginUpdates()` and `endUpdates() `methods.
    ///
    /// - Parameters:
    ///   - sectionItems: An array of `TableViewSectionItemProtocol` objects
    ///   - animation: A constant that indicates how the insertion is to be animated, for example, fade in or slide in from the left. See UITableViewRowAnimation for descriptions of these constants.
    open func appendSectionItems(_ sectionItems: [TableViewSectionItemProtocol],
                                 withRowAnimation animation: UITableViewRowAnimation) {
        let count = sectionItems.count
        let indexSet = IndexSet(integersIn: count...(count + sectionItems.count - 1))
        insertSectionItems(sectionItems, atIndexes: indexSet, withRowAnimation: animation)
    }
    
    /// Replaces one or more section items, with an option to animate the replacing. Don't need to call `beginUpdates()` and `endUpdates() `methods.
    ///
    /// - Parameters:
    ///   - indexes: An index set that specifies the sections to replace in the table view.
    ///   - sectionItems: An array of `TableViewSectionItemProtocol` objects
    ///   - animation: A constant that indicates how the insertion is to be animated, for example, fade in or slide in from the left. See UITableViewRowAnimation for descriptions of these constants.
    open func replaceSectionItems(at indexes: IndexSet,
                                  withSectionItems sectionItems: [TableViewSectionItemProtocol],
                                  rowAnimation animation: UITableViewRowAnimation) {
        precondition(indexes.count == sectionItems.count, "It's impossible to replace not equal count of section items")
        sectionItems.forEach { registerSectionItem($0) }
        
        tableView.update {
            self.sectionItems.replace(sectionItems, at: indexes)
            tableView.reloadSections(indexes, with: animation)
        }
    }
    
    // MARK: Others
    
    /// Determines frame of the cell, associated with passed cell item
    ///
    /// - Parameters:
    ///   - cellItem: `TableViewCellItemProtocol` object, that responds for configuration of cell at the specified index path.
    ///   - sectionItem: `TableViewSectionItemProtocol` object, that contains passed cell item
    /// - Returns: Frame of the cell, associated with passed cell item
    open func frameForCellItem(_ cellItem: TableViewCellItemProtocol,
                               inSectionItem sectionItem: TableViewSectionItemProtocol) -> CGRect? {
        guard let sectionItemIndex = sectionItems.index(where: {$0 === sectionItem}),
            let cellItemIndex = sectionItem.cellItems.index(where: {$0 === cellItem}) else {
                return nil
        }
        let indexPath = IndexPath(row: cellItemIndex, section: sectionItemIndex)
        return tableView.rectForRow(at: indexPath)
    }
    
    /// Scrolls through the table view until a row, associated with passed cell item is at a particular location on the screen.
    /// Invoking this method does not cause the delegate to receive a scrollViewDidScroll(_:) message, as is normal for programmatically invoked user interface operations.
    ///
    /// - Parameters:
    ///   - cellItem: `TableViewCellItemProtocol` object, that responds for configuration of cell at the specified index path.
    ///   - sectionItem: `TableViewSectionItemProtocol` object, that contains passed cell item
    ///   - scrollPosition: A constant that identifies a relative position in the table view (top, middle, bottom) for row when scrolling concludes. See UITableViewScrollPosition for descriptions of valid constants.
    ///   - animated: true if you want to animate the change in position; false if it should be immediate.
    open func scrollToCellItem(_ cellItem: TableViewCellItemProtocol,
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
    
    /// Scrolls table view to most top position.
    ///
    /// - Parameter animated: true if you want to animate the change in position; false if it should be immediate.
    open func scrollToTopAnimated(animated: Bool) {
        guard let sectionItem = sectionItems.first,
            let cellItem = sectionItem.cellItems.first else {
                return
        }
        scrollToCellItem(cellItem,
                         inSectionItem: sectionItem,
                         atScrollPosition: .top,
                         animated: animated)
    }
    
    // MARK: Helpers
    
    /// Returns the cell item at the specified index path.
    ///
    /// - Parameter indexPath: The index path locating the row in the table view.
    /// - Returns: An cell item associated with cell of the table, or nil if the cell item wasn't added to manager or indexPath is out of range.
    open func cellItem(for indexPath: IndexPath) -> TableViewCellItemProtocol? {
        if let cellItems = sectionItem(for: indexPath)?.cellItems {
            if indexPath.row < cellItems.count {
                return cellItems[indexPath.row]
            }
        }
        return nil
    }
    
    /// Returns the section item at the specified index path.
    ///
    /// - Parameter indexPath: The index path locating the section in the table view.
    /// - Returns: A section item associated with section of the table, or nil if the section item wasn't added to manager or indexPath.section is out of range.
    open func sectionItem(for indexPath: IndexPath) -> TableViewSectionItemProtocol? {
        if indexPath.section < sectionItems.count {
            return sectionItems[indexPath.section]
        }
        return nil
    }
    
    // MARK: - Private
    
    private func registerSectionItem(_ sectionItem: TableViewSectionItemProtocol) {
        sectionItem.cellItems.forEach { registerCellItem($0) }
    }
    
    private func registerCellItem(_ cellItem: TableViewCellItemProtocol) {
        tableView.register(by: cellItem.reuseType)
    }
}
