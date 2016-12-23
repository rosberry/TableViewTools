//
//  UITableView+Additions.swift
//  VanHaren
//
//  Created by Artem Novichkov on 09/12/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

public enum ReuseType {
    case byStoryboard(identifier: String)
    case byNib(nib: UINib, identifier: String)
    case byClass(cellClass: UITableViewCell.Type, identifier: String)
    
    var identifier: String {
        switch self {
        case let .byStoryboard(identifier): return identifier
        case let .byNib(_, identifier: identifier): return identifier
        case let .byClass(cellClass: _, identifier: identifier): return identifier
        }
    }
    
    init(cellClass: UITableViewCell.Type) {
        let identifier = NSStringFromClass(cellClass).components(separatedBy: ".").last!
        self = .byClass(cellClass: cellClass, identifier: identifier)
    }
}

extension UITableView {
    
    func register(by type: ReuseType) {
        switch type {
        case let .byNib(nib: nib, identifier: identifier):
            register(nib, forCellReuseIdentifier: identifier)
        case let .byClass(cellClass: cellClass, identifier: identifier):
            register(cellClass, forCellReuseIdentifier: identifier)
        default: break
        }
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
