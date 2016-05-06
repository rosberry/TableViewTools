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
@testable import rsbtableviewmanager_swift

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
                let cellItems = [RSBTableViewCellItemFake()]
                let sectionItem = RSBTableViewSectionItemFake(cellItems: cellItems)
                subject.sectionItems = [sectionItem]
            }
            
            it("should save passed section items") {
                expect(subject.sectionItems).notTo(beNil())
            }
            
            it("should call registerSectionItem for passed section items as setter args") {
                let cell = subject.tableView(tableView!, cellForRowAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
                expect(cell).notTo(beNil())
            }
        }
    }
}
