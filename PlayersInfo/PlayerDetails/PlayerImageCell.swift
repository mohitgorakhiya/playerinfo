//
//  PlayerImageCell.swift
//  PlayersInfo
//
//  Created by Mohit CCT on 22/01/19.
//  Copyright © 2019 Mohit. All rights reserved.
//

import UIKit

class PlayerImageCell: UITableViewCell {

    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var playerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.playerImageView.layer.masksToBounds = true
        self.playerImageView.layer.borderColor = UIColor.white.cgColor
        self.playerImageView.layer.borderWidth = 2.0
        self.playerImageView.layer.cornerRadius = self.playerImageView.frame.size.height / 2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
