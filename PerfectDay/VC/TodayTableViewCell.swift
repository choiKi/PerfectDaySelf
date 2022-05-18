//
//  TodayTableViewCell.swift
//  PerfectDay
//
//  Created by 최기훈 on 2022/05/18.
//

import UIKit

class TodayTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
