//
//  FilterObj.swift
//  PlayersInfo
//
//  Created by Mohit Gorakhiya on 1/22/19.
//  Copyright © 2019 Mohit. All rights reserved.
//

import UIKit
import SwiftyJSON
class FilterObj: NSObject {

    var filterId: Int!
    var filterName: String!
    
    init(filterDict: JSON) {
        self.filterId = filterDict["id"].int ?? 0
        self.filterName = filterDict["name"].string ?? ""
    }
    
}
