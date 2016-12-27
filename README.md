# TableViewTools

[![CI Status](http://img.shields.io/travis/Dmitry Frishbuter/TableViewTools.svg?style=flat)](https://travis-ci.org/Dmitry Frishbuter/TableViewTools)
[![Version](https://img.shields.io/cocoapods/v/TableViewTools.svg?style=flat)](http://cocoapods.org/pods/TableViewTools)
[![License](https://img.shields.io/cocoapods/l/TableViewTools.svg?style=flat)](http://cocoapods.org/pods/TableViewTools)
[![Platform](https://img.shields.io/cocoapods/p/TableViewTools.svg?style=flat)](http://cocoapods.org/pods/TableViewTools)
[![carthage compatible](https://img.shields.io/badge/Carthage-compatible-blue.svg)](https://github.com/Carthage/Carthage) 

## Overview

This repo contains the powerful tool for making your UITableView usage simply and comfortable! At allows you to move your UITableView configuration logic to separated objects, such as inheritors of TableViewSectionItemProtocol and TableViewCellItemProtocol, and simply register, add and remove cells from your table view.

## Example

To run the example project, run `pod try`, or simply clone the repo and open project Example-iOS.

## Requirements

## Installation
### CocoaPods

TableViewTools is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TableViewTools"
```

Then run `pod install` command. For details of the installation and usage of CocoaPods, visit [its official website](https://cocoapods.org).

### Carthage

To install TableViewTools using Carthage, add the following lines to your `Cartfile`:

```ruby
github "Rosberry/TableViewTools"
```

Then run `carthage update --platform iOS` command. For details of the installation and usage of Carthage, visit [its  repo website](https://github.com/Carthage/Carthage).

---

## Basic usage

### Creating manager

```swift
	self.manager = TableViewManager(tableView: self.tableView)

```

### Creating section with header and footer title

```swift
	let titles = ["Item 1", "Item 2", "Item 3"]
    var cellItems = [ExampleTableViewCellItem]()
    titles.forEach { title in
        let cellItem = ExampleTableViewCellItem(title: title)
        cellItem.itemDidSelectHandler = { tableView, indexPath in
            print(cellItem.title)
        }
        cellItems.append(cellItem)
    }
    
    let sectionItem = TableViewSectionItem(cellItems: cellItems)
    sectionItem.headerTitle = "Header title"
    sectionItem.footerTitle = "Footer Title"
    manager.sectionItems = [sectionItem]

```

### Cell item implementation

For basic usage, inside cell item should be implemented these entries from TableViewCellItemProtocol:

```swift
	var reuseType: ReuseType {
        return ReuseType(cellClass: ExampleTableViewCell.self)
    }
    
    func height(in tableView: UITableView) -> CGFloat {
        return 100
    }
    
    func cellForTableView(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell: ExampleTableViewCell = tableView.dequeueReusableCell()
        cell.titleLabel.text = title
        return cell
    }
```

## Authors

Dmitry Frishbuter, dmitry.frishbuter@rosberry.com
Artem Novichkov, artem.novichkov@rosberry.com
Nikita Ermolenko, nikita.ermolenko@rosberry.com

## License

TableViewTools is available under the MIT license. See the LICENSE file for more info.
