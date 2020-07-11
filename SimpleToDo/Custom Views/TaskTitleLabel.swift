//
//  TaskTitleLabel.swift
//  SimpleToDo
//
//  Created by Andrew Miotke on 7/11/20.
//  Copyright © 2020 andrewmiotke. All rights reserved.
//

import UIKit

class TaskTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(fontSize: CGFloat, fontWeight: UIFont.Weight) {
        super.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
