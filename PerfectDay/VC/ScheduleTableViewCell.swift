//
//  ScheduleTableViewCell.swift
//  PerfectDay
//
//  Created by 최기훈 on 2022/05/17.
//

import UIKit
import RealmSwift

class ScheduleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
