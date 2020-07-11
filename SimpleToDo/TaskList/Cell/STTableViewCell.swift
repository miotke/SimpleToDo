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
    
    let taskTitleTextLabel = SimpleLabel(fontSize: 20, fontWeight: .bold)
    let taskDateLabel = SimpleLabel(fontSize: 16, fontWeight: .thin)
    let taskStatusIndicatorImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "STTableViewCell")
        
        layoutUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func layoutUI() {
        let padding: CGFloat = 8
        let taskStatusIndicatorImageViewDiminsion: CGFloat = 35
        let stackView = UIStackView(arrangedSubviews: [taskTitleTextLabel, taskDateLabel])
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        
        addSubview(stackView)
        addSubview(taskStatusIndicatorImageView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        taskStatusIndicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: taskStatusIndicatorImageView.leadingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            
            taskStatusIndicatorImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: padding),
            taskStatusIndicatorImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            taskStatusIndicatorImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            taskStatusIndicatorImageView.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: padding),
            taskStatusIndicatorImageView.heightAnchor.constraint(equalToConstant: taskStatusIndicatorImageViewDiminsion),
            taskStatusIndicatorImageView.widthAnchor.constraint(equalToConstant: taskStatusIndicatorImageViewDiminsion)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
