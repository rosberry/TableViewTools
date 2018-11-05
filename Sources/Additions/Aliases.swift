//
//  Aliases.swift
//  TableViewTools
//
//  Created by Artem Novichkov on 05/11/2018.
//  Copyright © 2018 Dmitry Frishbuter. All rights reserved.
//

import UIKit

#if swift(>=4.2)
public typealias RowAnimation = UITableView.RowAnimation
public typealias EditingStyle = UITableViewCell.EditingStyle
public typealias ScrollPosition = UITableView.ScrollPosition
#else
public typealias RowAnimation = UITableViewRowAnimation
public typealias EditingStyle = UITableViewCellEditingStyle
public typealias ScrollPosition = UITableViewScrollPosition
#endif
