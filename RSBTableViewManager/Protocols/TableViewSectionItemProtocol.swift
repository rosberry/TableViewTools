//
//  TableViewSectionItemProtocol.swift
//
//  Created by Dmitry Frishbuter on 19/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

public protocol TableViewSectionItemProtocol: AnyObject {
    
    /// Array of `TableViewCellItemProtocol` objects, each responds for configuration of cell at specified index path in table view.
    var cellItems : [TableViewCellItemProtocol]  { get set }

    /// Should return the title of the header of the specified section of the table view.
    ///
    /// - Parameter tableView: The table-view object asking for the title.
    /// - Returns: A string to use as the title of the section header. If you return nil , the section will have no title.
    func titleForHeader(in tableView: UITableView) -> String?
    
    /// Should return the height of the header of the specified section of the table view.
    /// This method allows the section item to specify section header with varying height.
    ///
    /// - Parameter tableView: The table-view object requesting this information.
    /// - Returns: A nonnegative floating-point value that specifies the height (in points) of the header for section.
    func heightForHeader(in tableView: UITableView) -> CGFloat
    
    /// Should return a view object to display in the header of the specified section of the table view.
    /// The returned object can be a `UILabel` or `UIImageView` object, as well as a custom view.
    ///
    /// - Parameter tableView: The table-view object asking for the view object.
    /// - Returns: A view object to be displayed in the header of section.
    func viewForHeader(in tableView: UITableView) -> UIView?
    
    /// Should return the title of the footer of the specified section of the table view.
    ///
    /// - Parameter tableView: The table-view object asking for the title.
    /// - Returns: A string to use as the title of the section footer. If you return nil , the section will have no title.
    func titleForFooter(in tableView: UITableView) -> String?
    
    /// Should return the height to use for the footer of a particular section.
    /// This method allows the section item to specify section footer with varying height. This method will not be called if table view was created in a plain style (plain).
    ///
    /// - Parameter tableView: The table-view object requesting this information.
    /// - Returns: A nonnegative floating-point value that specifies the height (in points) of the footer for section.
    func heightForFooter(in tableView: UITableView) -> CGFloat
    
    /// Should return a view object to display in the footer of the specified section of the table view.
    /// The returned object can be a `UILabel` or `UIImageView` object, as well as a custom view.
    ///
    /// - Parameter tableView: The table-view object asking for the view object.
    /// - Returns: A view object to be displayed in the footer of section.
    func viewForFooter(in tableView: UITableView) -> UIView?
    
    /// Tells the section item that a header view is about to be displayed for the section associated with this item.
    ///
    /// - Parameters:
    ///   - headerView: The header view that is about to be displayed.
    ///   - section: An index number identifying a section of tableView.
    func willDisplayHeaderView(_ headerView: UIView, for section: Int)
    
    /// Tells the section item that a footer view is about to be displayed for the section associated with this item.
    ///
    /// - Parameters:
    ///   - footerView: The footer view that is about to be displayed.
    ///   - section: An index number identifying a section of tableView.
    func willDisplayFooterView(_ footerView: UIView, for section: Int)
    
    /// Tells the section item that the specified header view was removed from the table.
    ///
    /// - Parameters:
    ///   - headerView: The header view that was removed.
    ///   - section: The index of the section that contained the header.
    func didEndDisplayingHeaderView(_ headerView: UIView, for section: Int)
    
    /// Tells the section item that the specified footer view was removed from the table.
    ///
    /// - Parameters:
    ///   - footerView: The footer view that was removed.
    ///   - section: The index of the section that contained the header.
    func didEndDisplayingFooterView(_ footerView: UIView, for section: Int)
}

public extension TableViewSectionItemProtocol {

    func titleForHeader(in tableView: UITableView) -> String? { return nil }
    func heightForHeader(in tableView: UITableView) -> CGFloat { return 0 }
    func viewForHeader(in tableView: UITableView) -> UIView? { return nil }
    func titleForFooter(in tableView: UITableView) -> String? { return nil }
    func heightForFooter(in tableView: UITableView) -> CGFloat { return 0 }
    func viewForFooter(in tableView: UITableView) -> UIView? { return nil }
    
    func willDisplayHeaderView(_ headerView: UIView, for section: Int) {}
    func willDisplayFooterView(_ footerView: UIView, for section: Int) {}
    func didEndDisplayingHeaderView(_ headerView: UIView, for section: Int) {}
    func didEndDisplayingFooterView(_ footerView: UIView, for section: Int) {}
}
