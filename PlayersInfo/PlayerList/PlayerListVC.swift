//
//  PlayerListVC.swift
//  PlayersInfo
//
//  Created by Mohit CCT on 22/01/19.
//  Copyright © 2019 Mohit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PlayerListVC: UIViewController {

    var isFilterOn: Bool = false
    var filterDict: Dictionary<String, Any> = Dictionary.init()
    var selectedFilterDict: Dictionary<String, Any> = Dictionary.init()
    @IBOutlet weak var playersTableView: UITableView!
    var playersArray = [PlayerInfoList]()
    var appDel: AppDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedFilterDict["Categories"] = [Int]()
        self.selectedFilterDict["Buildings"] = [Int]()
        self.selectedFilterDict["Skills"] = [Int]()
        self.selectedFilterDict["Team Status"] = [Int]()
        
        self.appDel = UIApplication.shared.delegate as? AppDelegate
        self.title = "Players"
        self.setNavigationButton()
        self.playersTableView.register(UINib.init(nibName: "PlayerListCell", bundle:nil), forCellReuseIdentifier: "PlayerListCell")
        self.playersTableView.tableFooterView = UIView(frame: .zero)
        self.playersTableView.estimatedRowHeight = 500.0
        self.playersTableView.rowHeight = UITableView.automaticDimension
        self.playersTableView.separatorStyle = .none
        self.fetchPlayersInfo()
        self.fetchFilterValues()
    }
    func setNavigationButton() {
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "logoutImage"), style: .plain, target: self, action: #selector(logoutClicked))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.setRightFilterItem()
    }
    func setRightFilterItem() {
        
        self.navigationItem.rightBarButtonItems = nil
        
        var barArrayItems: Array<UIBarButtonItem> = Array.init()
        
        let refreshItem = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.refresh, target: self, action:
            #selector(refreshClicke))
        refreshItem.tintColor = UIColor.white
        barArrayItems.append(refreshItem)
        
        if isFilterOn {
            
            let filterItem = UIBarButtonItem.init(image: UIImage.init(named: "filteredImage"), style: .plain, target: self, action: #selector(filterClicked))
            
            filterItem.tintColor = UIColor.white
            barArrayItems.append(filterItem)
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "filteredImage"), style: .plain, target: self, action: #selector(filterClicked))
            
        } else {
            
            let filterItem = UIBarButtonItem.init(image: UIImage.init(named: "filterImage"), style: .plain, target: self, action: #selector(filterClicked))
            filterItem.tintColor = UIColor.white
            barArrayItems.append(filterItem)
        }
       
        
        self.navigationItem.rightBarButtonItems = barArrayItems
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    @objc func refreshClicke() {
        self.fetchPlayersInfo()
    }
    @objc func filterClicked() {
        
        let filterVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        filterVC.filterDict = self.filterDict
        filterVC.selectedFilterDict = self.selectedFilterDict
        filterVC.delegate = self
        let navController = UINavigationController.init(rootViewController: filterVC)
        self.present(navController, animated: true, completion: nil)
    }
    @objc func logoutClicked() {
        
        let controller = UIAlertController(title: "Are you sure you want to logout?", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "NO", style: .cancel) { (action) in
            
        }
        let yesaction = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            UserDefaults.standard.removeObject(forKey: Constant.isUserLogin)
            UserDefaults.standard.removeObject(forKey: Constant.kTokenValue)
            UserDefaults.standard.synchronize()
            
            self.appDel.setCurrentViewController()
        }
        controller.addAction(action)
        controller.addAction(yesaction)
        self.present(controller, animated: true, completion: nil)
    }
   
    func fetchPlayersInfo() {
        
        if !Connectivity.isConnectedToInternet() {
            self.showAlert(title: "Alert", msg: Constant.noInternetMessage, completion: nil)
            return
        }

        let categoryArray = (self.selectedFilterDict["Categories"] as! [Int]).flatMap { String($0) }
        let categoryStr = categoryArray.map { String($0) }.joined(separator: ",")
        
        let skillArray = (self.selectedFilterDict["Skills"] as! [Int]).flatMap { String($0) }
        let skillStr = skillArray.map { String($0) }.joined(separator: ",")
        
        let statusArray = (self.selectedFilterDict["Team Status"] as! [Int]).flatMap { String($0) }
        let statusStr = statusArray.map { String($0) }.joined(separator: ",")
        
        let buildingArray = (self.selectedFilterDict["Buildings"] as! Array<Int>).flatMap { "\($0)" }
        let buildingStr = buildingArray.map { String($0) }.joined(separator: ",")
        
        let params: Parameters = [
            "offset": 0,
            "category" : categoryStr,
            "skill" : skillStr,
            "building" : buildingStr,
            "team_status" : statusStr
        ]
        
        let auth_header: HTTPHeaders = [ "token" : UserDefaults.standard.value(forKey: Constant.kTokenValue) as! String,
                                         "Content-Type":"application/x-www-form-urlencoded"
        ]
        
        let requestURL: String = Constant.BASEURL + Constant.PLAYERINFOAPI
        
        self.showLoading()
        
        Alamofire.request(requestURL, method: .post, parameters: params, encoding: URLEncoding(), headers: auth_header)
            .responseJSON { response in
                
                self.hideLoading()
                switch response.result {
                case .success(_):
                    
                    if let data = response.result.value {
                        
                        let responseJSON = JSON(data)
                        if responseJSON["success"].boolValue {
                            
                            if responseJSON["data"]["players"].array != nil {
                                self.playersArray.removeAll()
                                let playersArray = responseJSON["data"]["players"].arrayValue
                                
                                for i in 0..<playersArray.count {
                                    
                                    let playerInfo = PlayerInfoList.init(playerDict: playersArray[i])
                                    self.playersArray.append(playerInfo)
                                }
                                self.playersTableView.reloadData()
                            } else {
                                
                                self.showAlert(title: "Alert", msg: "No Player found.", completion: nil)
                            }
                        } else {
                            self.showAlert(title: "Error", msg: responseJSON["msg"].string ?? "", completion: nil)
                        }
                        
                    } else
                    {
                        self.showAlert(title: "Alert", msg: "Error occurred, please try after some time.", completion: nil)
                    }
                    break
                    
                case .failure(_):
                    
                    self.showAlert(title: "Alert", msg: "Error occurred, please try after some time.", completion: nil)
                    
                    break
                    
                }
        }
    }
    func fetchFilterValues() {
        
        if !Connectivity.isConnectedToInternet() {
            return
        }
        
        let auth_header: HTTPHeaders = [ "token" : UserDefaults.standard.value(forKey: Constant.kTokenValue) as! String,
                                         "Content-Type":"application/x-www-form-urlencoded"
        ]
        
        let requestURL: String = Constant.BASEURL + Constant.PLAYERFILTERAPI
        
        Alamofire.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: auth_header)
            .responseJSON { response in
                
                switch response.result {
                case .success(_):
                    
                    if let data = response.result.value {
                        
                        let responseJSON = JSON(data)
                        if responseJSON["success"].boolValue {
                            
                            var categoryFilterArray = [FilterObj]()
                            if responseJSON["data"]["categories"].array != nil {
                                
                                let categoriesArray = responseJSON["data"]["categories"].arrayValue
                                for i in 0..<categoriesArray.count {
                                    
                                    let filterDict = FilterObj.init(filterDict: categoriesArray[i])
                                    categoryFilterArray.append(filterDict)
                                    
                                }
                            }
                            var buildingsFilterArray = [FilterObj]()
                            if responseJSON["data"]["buildings"].array != nil {
                                
                                let buildingsArray = responseJSON["data"]["buildings"].arrayValue
                                for i in 0..<buildingsArray.count {
                                    
                                    let filterDict = FilterObj.init(filterDict: buildingsArray[i])
                                    buildingsFilterArray.append(filterDict)
                                }
                            }
                            var skillsFilterArray = [FilterObj]()
                            if responseJSON["data"]["skills"].array != nil {
                                
                                let skillsArray = responseJSON["data"]["skills"].arrayValue
                                for i in 0..<skillsArray.count {
                                    
                                    let filterDict = FilterObj.init(filterDict: skillsArray[i])
                                    skillsFilterArray.append(filterDict)
                                }
                            }
                            var team_statusArray = [FilterObj]()
                            if responseJSON["data"]["team_status"].array != nil {
                                
                                let statusArray = responseJSON["data"]["team_status"].arrayValue
                                for i in 0..<statusArray.count {
                                    
                                    let filterDict = FilterObj.init(filterDict: statusArray[i])
                                    team_statusArray.append(filterDict)
                                }
                            }
                            self.filterDict["categories"] = categoryFilterArray
                            self.filterDict["buildings"] = buildingsFilterArray
                            self.filterDict["skills"] = skillsFilterArray
                            self.filterDict["team_status"] = team_statusArray
                        }
                    }
                    break
                    
                case .failure(_):
                    
                    break
                    
                }
        }
    }
}

extension PlayerListVC: FilterDelegate {
    func applyClickedFromFilter(filterDict: Dictionary<String, Any>) {
        self.selectedFilterDict = filterDict
        
        let categoryArray = (self.selectedFilterDict["Categories"] as! [Int]).flatMap { String($0) }
        
        let skillArray = (self.selectedFilterDict["Skills"] as! [Int]).flatMap { String($0) }
        
        let statusArray = (self.selectedFilterDict["Team Status"] as! [Int]).flatMap { String($0) }
        
        let buildingArray = (self.selectedFilterDict["Buildings"] as! Array<Int>).flatMap { "\($0)" }
        
        if categoryArray.count > 0 || skillArray.count > 0 || statusArray.count > 0 || buildingArray.count > 0 {
            
            self.isFilterOn = true
            
        } else {
            
            self.isFilterOn = false
            
        }
        self.setRightFilterItem()
        
        self.fetchPlayersInfo()
    }
}

extension PlayerListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let playerCell = tableView.dequeueReusableCell(withIdentifier: "PlayerListCell") as? PlayerListCell
        
        let playerInfo = self.playersArray[indexPath.row]
        
        playerCell?.playerNameLabel.text = playerInfo.playerName
        playerCell?.teamNameLabel.text = "Team: \(playerInfo.teamName ?? "--")"
        
        if playerInfo.picture.count == 0 {
            
            playerCell?.playerImageView.image = UIImage.init(named: "defaultImage")
            
        } else {
            
            playerCell?.playerImageView.sd_setShowActivityIndicatorView(true)
            playerCell?.playerImageView.sd_setIndicatorStyle(.gray)
            
            let escapedString = playerInfo.picture.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            playerCell?.playerImageView.sd_setImage(with: URL.init(string: escapedString!), placeholderImage: UIImage.init(named: "defaultImage"), options: SDWebImageOptions(rawValue: 0))
            
        }
        return playerCell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let playerDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "PlayerDetailVC") as! PlayerDetailVC
        playerDetailVC.playerInfo = self.playersArray[indexPath.row]
        
        self.navigationController?.pushViewController(playerDetailVC, animated: true)
        
    }
}
