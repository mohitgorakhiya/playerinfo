//
//  PlayerInfoList.swift
//  PlayersInfo
//
//  Created by Mohit CCT on 22/01/19.
//  Copyright © 2019 Mohit. All rights reserved.
//

import UIKit
import SwiftyJSON

class PlayerInfoList: NSObject {
    
    var playerId: Int!
    var playerName: String!
    var teamName: String!
    var bowlingStyle: String!
    var battingStyle: String!
    var basePrice: String!
    var building: String!
    var category_name: String!
    var picture: String!
    var teamStatus: Int!
    var age: Int!
    var points: Int!
    
    init(playerDict: JSON) {
        
        self.playerId = playerDict["player_id"].int ?? 0
        self.playerName = playerDict["name"].string ?? ""
        self.teamName = playerDict["team"].string ?? "--"
        self.bowlingStyle = playerDict["bowler"].string ?? ""
        self.battingStyle = playerDict["batsman"].string ?? ""
        self.basePrice = playerDict["base_price"].string ?? ""
        self.building = playerDict["building"].string ?? ""
        self.category_name = playerDict["category_name"].string ?? ""
        self.building = playerDict["building"].string ?? ""
        self.building = playerDict["building"].string ?? ""
        self.picture = playerDict["picture"].string ?? ""
        self.points = playerDict["points"].int ?? 0
        self.age = playerDict["age"].int ?? 0
    }

    
}
