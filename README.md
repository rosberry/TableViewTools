# TableViewTools

[![Platform](https://img.shields.io/cocoapods/p/TableViewTools.svg?style=flat)](http://cocoapods.org/pods/TableViewTools)
[![Swift Version](https://img.shields.io/badge/swift-4.0+-orange.svg)](https://swift.org/)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-blue.svg)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/TableViewTools.svg)](https://img.shields.io/cocoapods/v/TableViewTools.svg)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat)](http://makeapullrequest.com)

Powerful tool for making your `UITableView` usage simple and comfortable. It allows you to move your `UITableView` configuration logic to separated objects and simply register, add and remove cells from your table view.

## Requirements

- iOS 8.0+
- Xcode 9.0+

## Installation

#### Carthage
Create a `Cartfile` that lists the framework and run `carthage update`. Follow the [instructions](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) to add the framework to your project.

```
github "rosberry/TableViewTools"
```

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install TableViewTools by adding it to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!
pod 'TableViewTools'
```

#### Manually

Drag `Sources` folder from [last release](https://github.com/rosberry/TableViewTools/releases) into your project.

## Basic usage

### Creating manager

```swift
manager = TableViewManager(tableView: tableView)
```

### Creating section

```swift
let titles = ["Item 1", "Item 2", "Item 3"]
var cellItems = [ExampleTableViewCellItem]()
titles.forEach { title in
let cellItem = ExampleTableViewCellItem(title: title)
    cellItems.append(cellItem)
}

let sectionItem = TableViewSectionItem(cellItems: cellItems)
manager.sectionItems = [sectionItem]
```

### Cell item implementation

For basic usage, inside cell item should be implemented these entries from `TableViewCellItemProtocol`:

```swift
class ExampleTableViewCellItem: TableViewCellItemProtocol {

    var reuseType = ReuseType(cellClass: ExampleTableViewCell.self)
	    
    func height(in tableView: UITableView) -> CGFloat {
        return 100
    }
	    
    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell: ExampleTableViewCell = tableView.dequeueReusableCell()
        return cell
    }
}
```

## Authors

* Dmitry Frishbuter, dmitry.frishbuter@rosberry.com
* Artem Novichkov, artem.novichkov@rosberry.com
* Nikita Ermolenko, nikita.ermolenko@rosberry.com

## About

<img src="https://github.com/rosberry/Foundation/blob/master/Assets/full_logo.png?raw=true" height="100" />

This project is owned and maintained by Rosberry. We build mobile apps for users worldwide 🌏.

Check out our [open source projects](https://github.com/rosberry), read [our blog](https://medium.com/@Rosberry) or give us a high-five on 🐦 [@rosberryapps](http://twitter.com/RosberryApps).

## License

TableViewTools is available under the MIT license. See the LICENSE file for more info.
