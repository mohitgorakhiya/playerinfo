//
//  PlayerDetailVC.swift
//  PlayersInfo
//
//  Created by Mohit CCT on 22/01/19.
//  Copyright © 2019 Mohit. All rights reserved.
//

import UIKit

class PlayerDetailVC: UIViewController {

    @IBOutlet weak var playerDetailTableView: UITableView!
    var playerInfo: PlayerInfoList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = playerInfo.playerName
        self.playerDetailTableView.register(UINib.init(nibName: "PlayerImageCell", bundle:nil), forCellReuseIdentifier: "PlayerImageCell")
        self.playerDetailTableView.register(UINib.init(nibName: "PlayerInfocell", bundle:nil), forCellReuseIdentifier: "PlayerInfocell")
        self.playerDetailTableView.tableFooterView = UIView(frame: .zero)
        self.playerDetailTableView.estimatedRowHeight = 500.0
        self.playerDetailTableView.rowHeight = UITableView.automaticDimension
        self.playerDetailTableView.separatorStyle = .none
        self.setNavigationButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.playerDetailTableView.reloadData()
    }
    func setNavigationButton() {
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "backArrow"), style: .plain, target: self, action: #selector(backButtonClicked))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    @objc func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
}
extension PlayerDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let playerImageCell = tableView.dequeueReusableCell(withIdentifier: "PlayerImageCell") as? PlayerImageCell
            
            playerImageCell?.playerNameLabel.text = playerInfo.playerName
            
            var ageValue = "\(playerInfo.age ?? 0)"
            if ageValue.count == 0 {
                ageValue = "--"
            }
            playerImageCell?.ageLabel.text = "Age: \(ageValue)"
            
            if playerInfo.picture.count == 0 {
                playerImageCell?.playerImageView.image = UIImage.init(named: "defaultImage")
            } else {
                
                playerImageCell?.playerImageView.sd_setShowActivityIndicatorView(true)
                playerImageCell?.playerImageView.sd_setIndicatorStyle(.gray)
                
                let escapedString = playerInfo.picture.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                
                playerImageCell?.playerImageView.sd_setImage(with: URL.init(string: escapedString!), placeholderImage: UIImage.init(named: "defaultImage"), options: SDWebImageOptions(rawValue: 0))
            }
            return playerImageCell!
        }
        let playerInfoCell = tableView.dequeueReusableCell(withIdentifier: "PlayerInfocell") as? PlayerInfocell
        
        var leftTextValue: String = ""
        var rightTextValue: String = ""
        if indexPath.row == 1 {
            
            leftTextValue = "Team:"
            rightTextValue = playerInfo.teamName
            
        }
        if indexPath.row == 2 {
            
            leftTextValue = "Team Status:"
            if playerInfo.teamStatus == 0 {
                rightTextValue = "Assigned"
            } else
            {
                rightTextValue = "Not Assigned"
            }
        }
        if indexPath.row == 3 {
            
            leftTextValue = "Category:"
            rightTextValue = playerInfo.category_name
        }
        if indexPath.row == 4 {
            
            leftTextValue = "Building:"
            rightTextValue = playerInfo.building
            
        }
        if indexPath.row == 5 {
            
            leftTextValue = "Building:"
            rightTextValue = playerInfo.building
            
        }
        if indexPath.row == 6 {
            
            leftTextValue = "Bowling Style:"
            rightTextValue = playerInfo.bowlingStyle
            
        }
        if indexPath.row == 7 {
            
            leftTextValue = "Batting Style:"
            rightTextValue = playerInfo.battingStyle
            
        }
        if indexPath.row == 8 {
            
            leftTextValue = "Base Price:"
            rightTextValue = playerInfo.basePrice
            
        }
        if indexPath.row == 9 {
            
            leftTextValue = "Points:"
            rightTextValue = "\(playerInfo.points ?? 0)"
            
        }
        playerInfoCell?.leftLabel.text = leftTextValue
        playerInfoCell?.rightLabel.text = rightTextValue
        
        return playerInfoCell!
    }
    
}
