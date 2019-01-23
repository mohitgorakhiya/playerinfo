//
//  FilterCell.swift
//  PlayersInfo
//
//  Created by Mohit Gorakhiya on 1/22/19.
//  Copyright © 2019 Mohit. All rights reserved.
//

import UIKit

class FilterLeftCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class FilterRightCell: UITableViewCell {
    
    @IBOutlet weak var tickMarkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
