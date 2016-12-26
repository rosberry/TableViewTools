//
//  ExampleTableViewCell.swift
//  Example-iOS
//
//  Created by Dmitry Frishbuter on 26/12/2016.
//  Copyright © 2016 Rosberry. All rights reserved.
//

import UIKit

class ExampleTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.sizeToFit()
        if let text = titleLabel.text {
            let width = contentView.bounds.width - 132
            titleLabel.frame = CGRect(x: 16,
                                      y: (contentView.bounds.height - titleLabel.bounds.height) / 2,
                                      width: width,
                                      height: text.heightWithConstrainedWidth(width: width, font: titleLabel.font))
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        setNeedsLayout()
        layoutIfNeeded()
        return CGSize(width: titleLabel.bounds.width, height: titleLabel.bounds.height + 16)
    }
}
