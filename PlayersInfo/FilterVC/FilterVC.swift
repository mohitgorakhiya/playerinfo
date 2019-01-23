//
//  FilterVC.swift
//  PlayersInfo
//
//  Created by Mohit Gorakhiya on 1/22/19.
//  Copyright © 2019 Mohit. All rights reserved.
//

import UIKit

protocol FilterDelegate: class {
    func applyClickedFromFilter(filterDict: Dictionary<String, Any>)
}
class FilterVC: UIViewController {

    weak var delegate: FilterDelegate?
    @IBOutlet weak var filterRightTable: UITableView!
    @IBOutlet weak var filterLeftTable: UITableView!
    var categoryFilterArray = [FilterObj]()
    var skillsFilterArray = [FilterObj]()
    var buildingsFilterArray = [FilterObj]()
    var team_statusArray = [FilterObj]()
    var filterDict: Dictionary<String, Any> = Dictionary.init()
    var selectedFilterDict: Dictionary<String, Any> = Dictionary.init()
    var selectedFilter: Int = 0
    let leftFilterArray = ["Categories", "Buildings", "Skills", "Team Status"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Filter By"
        self.filterRightTable.tableFooterView = UIView(frame: .zero)
        self.filterRightTable.estimatedRowHeight = 500.0
        self.filterRightTable.rowHeight = UITableView.automaticDimension
        
        self.filterLeftTable.tableFooterView = UIView(frame: .zero)
        self.filterLeftTable.estimatedRowHeight = 500.0
        self.filterLeftTable.rowHeight = UITableView.automaticDimension
        self.filterLeftTable.separatorStyle = .none

        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(cancelFromFilter))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Clear All", style: .plain, target: self, action: #selector(clearAllFilter))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        categoryFilterArray = self.filterDict["categories"] as! [FilterObj]
        buildingsFilterArray = self.filterDict["buildings"] as! [FilterObj]
        skillsFilterArray = self.filterDict["skills"] as! [FilterObj]
        team_statusArray = self.filterDict["team_status"] as! [FilterObj]
    }
    @objc func cancelFromFilter() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func clearAllFilter() {
        self.selectedFilterDict["Categories"] = [Int]()
        self.selectedFilterDict["Buildings"] = [Int]()
        self.selectedFilterDict["Skills"] = [Int]()
        self.selectedFilterDict["Team Status"] = [Int]()
        self.filterRightTable.reloadData()
    }
    @IBAction func applyFilter(_ sedner: UIButton) {
        
        self.cancelFromFilter()
        self.delegate?.applyClickedFromFilter(filterDict: selectedFilterDict)
        
    }
}
extension FilterVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 0 {
            return 4
        }
        else {
            if self.selectedFilter == 0 {
                return self.categoryFilterArray.count
            }
            if self.selectedFilter == 1 {
                return self.buildingsFilterArray.count
            }
            if self.selectedFilter == 2 {
                return self.skillsFilterArray.count
            }
            if self.selectedFilter == 3 {
                return self.team_statusArray.count
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 {
            let filterLeftCell = tableView.dequeueReusableCell(withIdentifier: "FilterLeftCell") as? FilterLeftCell
            
            filterLeftCell?.titleLabel.text = leftFilterArray[indexPath.row]
            if self.selectedFilter == indexPath.row {
                filterLeftCell?.contentView.backgroundColor = UIColor.white
            } else {
                filterLeftCell?.contentView.backgroundColor = UIColor.init(hex: "2388DB", alpha: 0.5)
            }
            
            return filterLeftCell!
        }
        else
        {
            let filterLeftCell = tableView.dequeueReusableCell(withIdentifier: "FilterRightCell") as? FilterRightCell
            
            var filterTitle: String = ""
            var filterId: Int = 0
            if self.selectedFilter == 0 {
                filterTitle = self.categoryFilterArray[indexPath.row].filterName
                filterId = self.categoryFilterArray[indexPath.row].filterId
            }
            if self.selectedFilter == 1 {
                filterTitle = self.buildingsFilterArray[indexPath.row].filterName
                filterId = self.buildingsFilterArray[indexPath.row].filterId
            }
            if self.selectedFilter == 2 {
                filterTitle = self.skillsFilterArray[indexPath.row].filterName
                filterId = self.skillsFilterArray[indexPath.row].filterId
            }
            if self.selectedFilter == 3 {
                filterTitle = self.team_statusArray[indexPath.row].filterName
                filterId = self.team_statusArray[indexPath.row].filterId
            }
            filterLeftCell?.titleLabel.text = filterTitle
            let selectedValueArray = self.selectedFilterDict[self.leftFilterArray[self.selectedFilter]] as! Array<Int>
            
            if self.selectedFilter == 3 {
                
                if selectedValueArray.contains(filterId)
                {
                    filterLeftCell?.tickMarkImageView.image = UIImage.init(named: "radioOn")
                }
                else
                {
                    filterLeftCell?.tickMarkImageView.image = UIImage.init(named: "radioOff")
                }
                
                
            } else {
                if selectedValueArray.contains(filterId)
                {
                    filterLeftCell?.tickMarkImageView.image = UIImage.init(named: "tickMark")
                }
                else
                {
                    filterLeftCell?.tickMarkImageView.image = UIImage.init(named: "unTickMark")
                }
            }
            
            return filterLeftCell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.tag == 0 {
            self.selectedFilter = indexPath.row
            self.filterLeftTable.reloadData()
            self.filterRightTable.reloadData()
        } else {
            var selectedId = 0
            if self.selectedFilter == 0 {
                selectedId = self.categoryFilterArray[indexPath.row].filterId
            }
            if self.selectedFilter == 1 {
                selectedId = self.buildingsFilterArray[indexPath.row].filterId
            }
            if self.selectedFilter == 2 {
                selectedId = self.skillsFilterArray[indexPath.row].filterId
            }
            if self.selectedFilter == 3 {
                selectedId = self.team_statusArray[indexPath.row].filterId
            }
            var selectedValueArray = self.selectedFilterDict[self.leftFilterArray[self.selectedFilter]] as! Array<Int>
            
            if self.selectedFilter == 3 {
                
                selectedValueArray.removeAll()
                selectedValueArray.append(selectedId)
                
            } else {
                if let index = selectedValueArray.index(of: selectedId) {
                    selectedValueArray.remove(at: index)
                } else {
                    selectedValueArray.append(selectedId)
                }
            }
            
            self.selectedFilterDict[self.leftFilterArray[self.selectedFilter]] = selectedValueArray
            self.filterRightTable.reloadData()
        }
    }
}
