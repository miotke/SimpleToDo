//
//  STTableViewCell.swift
//  SimpleToDo
//
//  Created by Andrew Miotke on 5/7/20.
//  Copyright © 2020 andrewmiotke. All rights reserved.
//

import UIKit

class STTableViewCell: UITableViewCell {
    
    static let reuseId = "STTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "STTableViewCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
