//
//  SpendingStatsCell.swift
//  Yourself
//
//  Created by Tri Dao on 7/5/17.
//  Copyright © 2017 Yourself. All rights reserved.
//

import UIKit

class SpendingStatsCell: UITableViewCell {
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var nameTypeLabel: UILabel!
    @IBOutlet weak var jar_TypeView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
