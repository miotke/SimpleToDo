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
    
    let taskTitle = UILabel()
    let dateLabel = UILabel()
    let taskStatusIndicatorImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "STTableViewCell")
        
        layoutUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func layoutUI() {
        let padding: CGFloat = 8
        let stackView = UIStackView(arrangedSubviews: [taskTitle, dateLabel])
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        
        addSubview(stackView)
        addSubview(taskStatusIndicatorImageView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        taskStatusIndicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: STOPPING POINT: Finishing writing the constraints
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
