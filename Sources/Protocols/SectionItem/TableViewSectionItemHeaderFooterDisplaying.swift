//
//  TableViewSectionItemHeaderFooterDisplaying.swift
//  TableViewTools
//
//  Created by Dmitry Frishbuter on 23/12/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit.UIView

public protocol TableViewSectionItemHeaderFooterDisplaying {
    
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

public extension TableViewSectionItemHeaderFooterDisplaying {
    
    func willDisplayHeaderView(_ headerView: UIView, for section: Int) {}
    func willDisplayFooterView(_ footerView: UIView, for section: Int) {}
    func didEndDisplayingHeaderView(_ headerView: UIView, for section: Int) {}
    func didEndDisplayingFooterView(_ footerView: UIView, for section: Int) {}
}
