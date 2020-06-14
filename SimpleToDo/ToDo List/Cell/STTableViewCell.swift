//
//  STTableViewCell.swift
//  SimpleToDo
//
//  Created by Andrew Miotke on 5/7/20.
//  Copyright © 2020 andrewmiotke. All rights reserved.
//

import UIKit

class STTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskTitleTextLabel: UILabel!
    @IBOutlet weak var taskItemStatusIndictorImage: UIImageView!
    @IBOutlet weak var taskDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTaskTitleTextLabel()
        configureTaskItemStatusIndictorImage()
        configureTaskDatelabel()
    }
    
    func configureTaskTitleTextLabel() {
        let title = self.taskTitleTextLabel
        title?.font = UIFont.systemFont(ofSize: 21, weight: .bold)
    }
    
    func configureTaskItemStatusIndictorImage() {
        
    }
    
    func configureTaskDatelabel() {
        let dateLabel = self.taskDateLabel
        dateLabel?.font = UIFont.systemFont(ofSize: 18, weight: .ultraLight)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
