//
//  TableViewSectionItemProtocol.swift
//
//  Created by Dmitry Frishbuter on 19/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

public protocol TableViewSectionItemProtocol: AnyObject {
    
    var cellItems : [TableViewCellItemProtocol]  { get set }

    func titleForHeader(in tableView: UITableView) -> String?
    func heightForHeader(in tableView: UITableView) -> CGFloat
    func viewForHeader(in tableView: UITableView) -> UIView?
    
    func titleForFooter(in tableView: UITableView) -> String?
    func heightForFooter(in tableView: UITableView) -> CGFloat
    func viewForFooter(in tableView: UITableView) -> UIView?
    
    func willDisplayHeaderView(_ headerView: UIView, for section: Int)
    func willDisplayFooterView(_ footerView: UIView, for section: Int)
    func didEndDisplayingHeaderView(_ headerView: UIView, for section: Int)
    func didEndDisplayingFooterView(_ footerView: UIView, for section: Int)
}

extension TableViewSectionItemProtocol {

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
