//
//  TableViewCellItemEditingProtocol.swift
//  RSBTableViewManager
//
//  Created by Dmitry Frishbuter on 23/12/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit.UITableView

public protocol TableViewCellItemEditingProtocol {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath)
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?)
}
