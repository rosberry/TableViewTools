//
//  RSBTableViewManagerSpec.swift
//  rsbtableviewmanager-swift
//
//  Created by Damien on 26/04/16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit
import Quick
import Nimble
@testable import RSBTableViewManager

class RSBTableViewManagerSpec: QuickSpec {
    
    override func spec() {
        var subject: RSBTableViewManager!
        var tableView: UITableView?
        
        beforeEach {
            tableView = UITableView()
            subject = RSBTableViewManager(tableView: tableView!)
        }
        
        describe("storing/releasing tableView with weak reference") {
            it("should store tableView, passed in initializer") {
                expect(subject.tableView).notTo(beNil())
            }
            
            it("tableView property in manager should became nil after its releasing from owner") {
                tableView = nil
                expect(subject.tableView).to(beNil())
            }
        }
        
        describe("set/get section items") {
            beforeEach {
                var sectionItems = [RSBTableViewSectionItemProtocol]()
                for _ in 0...4 {
                    var cellItems = [RSBTableViewCellItemProtocol]()
                    for _ in 0...9 {
                        cellItems.append(RSBTableViewCellItemFake())
                    }
                    sectionItems.append(RSBTableViewSectionItemFake(cellItems: cellItems))
                }
                subject.sectionItems = sectionItems
            }
            
            it("should save passed section items") {
                expect(subject.sectionItems).notTo(beNil())
            }   
            
            it("should return cells for passed section items as setter args") {
                for (sectionIndex, sectionItem) in subject.sectionItems.enumerate() {
                    for (cellIndex, _) in (sectionItem.cellItems!.enumerate()) {
                        let cell = subject.tableView(tableView!, cellForRowAtIndexPath: NSIndexPath(forItem: cellIndex, inSection: sectionIndex))
                        expect(cell).notTo(beNil())
                    }
                }
            }
        }
        
        describe("adding/removing cells") {
            it("should add celItems for specific indexes") {
                var cellItems = [RSBTableViewCellItemProtocol]()
                for _ in 0...8 {
                    cellItems.append(RSBTableViewCellItemFake())
                }
                subject.sectionItems = [RSBTableViewSectionItemFake(cellItems: cellItems)]
                
                let countBefore = subject.sectionItems[0].cellItems?.count
                
                let cellItemsToAppend = [RSBTableViewCellItemFake() as RSBTableViewCellItemProtocol]
                subject.insertCellItems(cellItemsToAppend,
                                        toSectionItem: &subject.sectionItems[0],
                                        atIndexes: NSIndexSet(indexesInRange: NSMakeRange(5, 1)),
                                        withRowAnimation: UITableViewRowAnimation.None)
                let contains = subject.sectionItems[0].cellItems!.contains({$0 === cellItemsToAppend[0]})
                expect(contains).to(beTrue())
                let isEqualCount = countBefore! == subject.sectionItems[0].cellItems!.count - cellItemsToAppend.count
                expect(isEqualCount).to(beTrue())
            }
        }
    }
}
