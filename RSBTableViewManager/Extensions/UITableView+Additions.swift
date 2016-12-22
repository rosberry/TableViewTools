//
//  UITableView+Additions.swift
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
    
    /// Calls `beginUpdates()` before execution of closure in parameter and `endUpdates()` after
    ///
    /// - Parameter closure: a closure with insertions, deletions or selections operations in `UITableView`
    func update(_ closure: (() -> Void)) {
        beginUpdates()
        closure()
        endUpdates()
    }
}
