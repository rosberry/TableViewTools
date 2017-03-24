//
//  TableViewSectionItemProtocol.swift
//  TableViewTools
//
//  Created by Dmitry Frishbuter on 19/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit.UITableView

public protocol TableViewSectionItemProtocol: AnyObject {
    
    /// Array of `TableViewCellItemProtocol` objects, each responds for configuration of cell at specified index path in table view.
    var cellItems: [TableViewCellItemProtocol]  { get set }

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
}

public extension TableViewSectionItemProtocol {

    func titleForHeader(in tableView: UITableView) -> String? { return nil }
    func heightForHeader(in tableView: UITableView) -> CGFloat { return 0 }
    func viewForHeader(in tableView: UITableView) -> UIView? { return nil }
    func titleForFooter(in tableView: UITableView) -> String? { return nil }
    func heightForFooter(in tableView: UITableView) -> CGFloat { return 0 }
    func viewForFooter(in tableView: UITableView) -> UIView? { return nil }
}
