//
//  ViewController.swift
//  Example-iOS
//
//  Created by Dmitry Frishbuter on 23/12/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit
import TableViewTools

class ViewController: UIViewController, TableViewManagerDelegate {
    
    let tableView = UITableView()
    let manager: TableViewManager

    init() {
        manager = TableViewManager(tableView: tableView)
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .green
        manager.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAction(sender:)))
        let plusItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertAction(sender:)))
        navigationItem.rightBarButtonItems = [editItem, plusItem]
        view.addSubview(tableView)
        
        let proverbs = ["Two wrongs don't make a right.",
                        "The pen is mightier than the sword.",
                        "When in Rome, do as the Romans.",
                        "The squeaky wheel gets the grease.",
                        "When the going gets tough, the tough get going.",
                        "No man is an island.",
                        "Fortune favors the bold.",
                        "People who live in glass houses should not throw stones.",
                        "Hope for the best, but prepare for the worst.",
                        "Keep your friends close and your enemies closer.",
                        "If you want something done right, you have to do it yourself.",
                        "You can lead a horse to water, but you can't make him drink."]
        var cellItems = [ExampleTableViewCellItem]()
        proverbs.forEach { proverb in
            let cellItem = ExampleTableViewCellItem(title: proverb)
            cellItem.itemDidSelectHandler = { tableView, indexPath in
                print(cellItem.title)
            }
            cellItems.append(cellItem)
        }
        
        let sectionItem = TableViewSectionItem(cellItems: cellItems)
        sectionItem.headerTitle = "Header title"
        sectionItem.footerTitle = "Footer Title"
        manager.sectionItems = [sectionItem]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    func editAction(sender: Any?) {
        tableView.isEditing = !tableView.isEditing
        tableView.reloadData()
    }
    
    func insertAction(sender: Any?) {
        let newItem = ExampleTableViewCellItem(title: "Inserted cell")
        manager.appendCellItems([newItem], toSectionItemAt: 0, withRowAnimation: .automatic)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceSectionItem = manager[sourceIndexPath.section]
        let destinationSectionItem = manager[destinationIndexPath.section]
        
        let sourceCellItem = sourceSectionItem.cellItems[sourceIndexPath.row]
        guard let index = sourceSectionItem.cellItems.index(where: {$0 === sourceCellItem}) else { return }
        sourceSectionItem.cellItems.remove(at: index)
        
        destinationSectionItem.cellItems.insert(sourceCellItem, at: destinationIndexPath.row)
    }
}
