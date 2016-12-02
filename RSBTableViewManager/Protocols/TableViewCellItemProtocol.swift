//
//  TableViewCellItemProtocol.swift
//
//  Created by Dmitry Frishbuter on 19/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

public typealias SelectHandler = ((UITableView, IndexPath) -> Void)

extension TableViewCellItemProtocol {
    
    func didSelectCell(in tableView: UITableView, at indexPath: IndexPath) { itemDidSelectHandler?(tableView, indexPath) }
    func didDeselectCell(in tableView: UITableView, at indexPath: IndexPath) { itemDidDeselectHandler?(tableView, indexPath) }
    func willDisplayCell(_ cell: UITableViewCell, for tableView: UITableView, at indexPath: IndexPath) {}
    func didEndDisplayingCell(_ cell: UITableViewCell, for tableView: UITableView, at indexPath: IndexPath) {}
}

public protocol TableViewCellItemProtocol: AnyObject {
    
    var itemDidSelectHandler:   SelectHandler? { get set }
    var itemDidDeselectHandler: SelectHandler? { get set }
    
    func height(for tableView: UITableView) -> CGFloat
    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    func didSelectCell(in tableView: UITableView, at indexPath: IndexPath)
    func willDisplayCell(_ cell: UITableViewCell, for tableView: UITableView, at indexPath: IndexPath)
    func didEndDisplayingCell(_ cell: UITableViewCell, for tableView: UITableView, at indexPath: IndexPath)

    static func registerCell(for tableView : UITableView)
}
