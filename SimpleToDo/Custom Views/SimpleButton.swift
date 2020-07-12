//
//  SimpleButton.swift
//  SimpleToDo
//
//  Created by Andrew Miotke on 7/11/20.
//  Copyright © 2020 andrewmiotke. All rights reserved.
//

import UIKit

class SimpleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String, backgroundColor: UIColor) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        
        configure()
    }
    
    private func configure() {
        self.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
