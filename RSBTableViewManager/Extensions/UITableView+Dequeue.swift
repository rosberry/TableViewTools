//
//  UITableView+Dequeue.swift
//  VanHaren
//
//  Created by Artem Novichkov on 09/12/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register(_ type: UITableViewCell.Type) {
        register(type, forCellReuseIdentifier: NSStringFromClass(type))
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        return dequeueReusableCell(withIdentifier: NSStringFromClass(T.self)) as! T
    }
}
